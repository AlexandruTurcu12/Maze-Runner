	În rezolvarea acestei teme, am parcurs un labirint de dimensiune 64x64 în cadrul 
modulului maze.
	La începutul programului, am definit stările automatului, dar și direcțiile care pot fi luate 
în parcurgerea labirintului. Am declarat variabile pentru state și next_state, pozițiile precedente 
ale rândului și ale coloanei și direcția înspre care privesc.

	• În starea start am inițializat coordonatele traseului, am setat direcția inițială la dreapta 
și am marcat poziția inițială cu 2. Apoi am trecut în starea wall_check.

	• În starea wall_check verific dacă există perete la dreapta poziției curente. Memorez
coordonatele curente în variabilele previous_row și previous_col și “privesc” în dreapta, 
în funcție de direcția curentă.
		- Dacă direcția este la dreapta, mă deplasez cu un rând în jos.
		- Dacă direcția este în jos, mă deplasez cu o coloană la stânga.
		- Dacă direcția este la stânga, mă deplasez cu o coloană în sus.
		- Dacă direcția este în sus, mă deplasez cu o coloană la dreapta.
	Apoi citesc poziția din labirint și trec în starea wall.

	• În starea wall, decid următoarea acțiune în funcție de prezența peretelui. Dacă acesta 
există, mă întorc la poziția precedentă și trec în starea move_check pentru a verifica 
dacă mă pot deplasa de-a lungul lui. Dacă nu am perete în dreapta, marchez poziția 
actuală cu 2, schimb direcția spre dreapta și trec în starea check.
	Explicația schimbării direcției la dreapta este următoarea: dacă mă deplasez de-a lungul 
unui zid iar acesta se oprește, mă deplasez pe poziția din dreapta (care este un culoar), 
iar dacă schimb direcția la dreapta, voi avea în dreapta mea ultimul bloc din zidul 
respectiv. Astfel, dacă nu am ajuns la ieșire și trebuie să verific dacă am perete în 
dreapta, îl voi găsi din prima încercare.

	• În starea move_check verific dacă am un culoar în față ca să pot avansa. Memorez
coordonatele curente în variabilele previous_row și previous_col și “privesc” înainte, în 
funcție de direcția curentă.
		- Dacă direcția este la dreapta, mă deplasez cu o coloană la dreapta.
		- Dacă direcția este în jos, mă deplasez cu un rând în jos.
		- Dacă direcția este la stânga, mă deplasez cu o coloană la stânga.
		- Dacă direcția este în sus, mă deplasez cu un rând în sus.
	Apoi citesc poziția din labirint și trec în starea move.

	• În starea move, decid următoarea acțiune în funcție de prezența culoarului. Dacă acesta 
există, îl marchez cu 2 și trec în starea check. Dacă nu am culoar în față (am perete), mă 
întorc la poziția precedentă, schimb direcția spre stânga pentru a putea avea peretele în 
dreapta și trec în starea check. Astfel, dacă nu am ajuns la ieșire și trebuie să verific dacă 
am perete în dreapta, îl voi găsi din prima încercare.

	• În starea check, verific dacă am ajuns la finalul labirintului. Dacă am găsit ieșirea, o 
marchez cu 2 și trec în starea finish. Dacă nu, mă întorc în starea wall_check.

	• În starea finish, marchez variabila done cu 1, semn că am ieșit din labirint.