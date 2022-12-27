//zadatak koji gleda registre r0-r4 i maksimalni element iz tih 5 registara
//sprema u registar r5 (iz prethodne zadace)

//ucitaj prvu adresu(R0)

@R0
D = M //postavi D na vrijednost u RAM0
@R5
M = D //postavi vrijednost u RAM5 na trenutni maksimum

@R1
D = M - D //D = RAM1 - RAM0
@STEP2
D; JLE //if D <= 0 jump to STEP2
@R1
D = M //D = RAM1
@R5
M = D //RAM5 = D = RAM1
@STEP2NOLOAD
0; JMP

(STEP2)
@R5
D = M
(STEP2NOLOAD)
@R2
D = M - D
@STEP3
D; JLE //if D <= 0 jump to STEP2
@R2
D = M //D = RAM2
@R5
M = D //RAM5 = D = RAM2
@STEP3NOLOAD
0; JMP

(STEP3) 
@R5
D = M
(STEP3NOLOAD)
@R3
D = M - D
@STEP4
D; JLE //if D <= 0 jump to STEP2
@R3
D = M //D = RAM3
@R5
M = D //RAM5 = D = RAM3
@STEP4NOLOAD
0; JMP

(STEP4)
@R5
D = M
(STEP4NOLOAD)
@R4
D = M - D
@END
D; JLE //if D <= 0 jump to STEP2
@R4
D = M //D = RAM4
@R5
M = D //RAM5 = D = RAM4

(END)
@END
0; JMP