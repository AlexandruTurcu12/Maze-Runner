`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:23:43 11/28/2021 
// Design Name: 
// Module Name:    maze 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module maze(
input 		          clk,
input [maze_width - 1:0]  starting_col, starting_row, 	// indicii punctului de start
input  			  maze_in, 			// ofera informa?ii despre punctul de coordonate [row, col]
output [maze_width - 1:0] row, col,	 		// selecteaza un rând si o coloana din labirint
output 			  maze_oe,			// output enable (activeaza citirea din labirint la rândul ?i coloana date) - semnal sincron	
output 			  maze_we, 			// write enable (activeaza scrierea în labirint la rândul ?i coloana date) - semnal sincron
output 			  done);		 	// ie?irea din labirint a fost gasita; semnalul ramane activ 

parameter maze_width = 6;
`define start 0
`define wall_check 1
`define wall 2
`define move_check 3
`define move 4
`define check 5
`define finish 6

reg [2 : 0] state, next_state = `start;
reg [5 : 0] previous_row, previous_col;

reg [1 : 0] direction;
`define right 0
`define down 1
`define left 2
`define up 3

always @(posedge clk) begin
	state <= next_state;
end

always @(*) begin
	maze_oe = 0;
	maze_we = 0;
	
	case(state)
		`start: begin //ma pozitionez la inceputul drumului
			row = starting_row;
			col = starting_col;
			done = 0;
			direction = `right;
			maze_we = 1;
			next_state = `wall_check;
		end
		
		`wall_check: begin //verific prezenta peretelui din partea dreapta - observ campul din dreapta mea
			previous_row = row;
			previous_col = col;
			
			if (direction == `right) begin
				row = row + 1;
			end else if (direction == `down) begin
				col = col - 1;
			end else if (direction == `left) begin
				row = row - 1;
			end else if (direction == `up) begin
				col = col + 1;
			end
			
			maze_oe = 1;
			next_state = `wall;
		end
		
		`wall: begin
			if (maze_in == 1) begin //daca exista peretele, verific daca ma pot deplasa de-a lungul sau
				row = previous_row;
				col = previous_col;
				next_state = `move_check;
			end
			
			else begin //daca nu exista peretele, schimb directia spre care ma uit
			maze_we = 1;
			
			if (direction == `right) begin
				direction = `down;
			end else if (direction == `down) begin
				direction = `left;
			end else if (direction == `left) begin
				direction = `up;
			end else if (direction == `up) begin
				direction = `right;
			end
				
			next_state = `check;
			end
		end
		
		`move_check: begin //verific daca pot avansa in labirint - observ campul din fata mea
			previous_row = row;
			previous_col = col;
			
			if (direction == `right) begin
				col = col + 1;
			end else if (direction == `down) begin
				row = row + 1;
			end else if (direction == `left) begin
				col = col - 1;
			end else if (direction == `up) begin
				row = row - 1;
			end
			
			maze_oe = 1;
			next_state = `move;
		end
		
		`move: begin
			if (maze_in != 1) begin //daca exista culoarul, marchez campul curent
				maze_we = 1;
			end
			
			else begin //daca nu exista culoarul, schimb directia spre care ma uit
				row = previous_row;
				col = previous_col;
				
				if (direction == `right) begin
					direction = `up;
				end else if (direction == `down) begin
					direction = `right;
				end else if (direction == `left) begin
					direction = `down;
				end else if (direction == `up) begin
					direction = `left;
				end
				
			end
			
			next_state = `check;
		end
		
		`check: begin //verific daca am ajuns la iesirea din labirint
			if (maze_in == 0 && (row == 0 || row == 63 || col == 0 || col == 63)) begin
				maze_we = 1;
				next_state = `finish;
			end
			
			else begin
				next_state = `wall_check;
			end
			
		end
		
		`finish: begin //semnalez ca am iesit din labirint
			done = 1;
			next_state = `finish;
		end
		
	endcase
	
end

endmodule