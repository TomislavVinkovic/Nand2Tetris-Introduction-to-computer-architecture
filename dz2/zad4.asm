@128 //ucitaj konstantu 127 za visinu do zadnjeg piksela
D = A //D = 128
@WIDTH
D; JLE //if D <= 0 goto WIDTH
@counter
M = D //*counter = 128
@SCREEN
D = A //D = SCREEN
@966 //dosl neka random konstanta samo da ne bude bas u vrhu zaslona, nego malo offsetovano
D=D+A
@address
M = D //address = D = SCREEN

//PETLJA ZA VISINU TROKUTA
(LOOP)
@address
A = M //A = *address
M = 1 //obojaj prvi piksel od njih
@address
D = M //D = *address = SCREEN
@32
D = D + A
@address
M = D //*address = address + 32, tj, odi u isti stupac, ali u slj retku
@counter
MD = M - 1
@LOOP
D; JGT
//kraj petlje

//RUTINA ZA SIRINU TROKUTA
(WIDTH)
@8 //ucitaj konstantu 8 za counter za sirinu
D = A
@END
D; JLE
@counter
M = D
@32
D = A

//PETLJA ZA SIRINU TROKUTA
(WIDTHLOOP)
@address
A = M //A = *address
M = -1 //obojaj sve piksele
@address
D = M //D = *address = SCREEN
D = D + 1 //D = (*address) + 1
@address
M = D //*address = address + 1, tj, odi u slj segment piksela
@counter
MD = M - 1
@WIDTHLOOP
D; JGT
//kraj petlje

//spremi gdje se nalazi zadnji redak, odnosno
//do gdje crtas dijagonalu
@address
D=M
@last_row
M=D


//RUTINA ZA DIJAGONALU
@SCREEN
D=A
@998 //326(pocetak katete visine) + 32(prijedi odmah u sljedeci redak)
D=D+A
@address
M=D
@2
D=A
@pixel
M=D

@minus_one
M=0

(DIAGONAL_LOOP)
@pixel
D = M //d = *pixel
@INC
D; JGT //preskoci inicijalizaciju na 1 ako je D > 0
//inace, postavi taj segment na zaslonu na jedinicu
@address
A=M //A = *address, neka memorijska adresa
M = 1 //*address = 1
@pixel
M = 1 //*pixel = 1
@NO_INC
0;JMP

(INC)
@address
A = M //A = *address, neka memorijska adresa
M = M+D //*address = *address + pixel

(NO_INC)
@address
D = M //D = address
@32
D=D+A //D = address + 32, odnosno odi redak dolje
@address
M=D //address += 32
@pixel
//ova 3 retka rade: M = M << 1
D = M
D = D+M //ne radi d + d
M = D
//
//ako je d <= 0, idi u sljedeci stupac, i postavi pixel varijablu na 1
@CONTINUE
D;JGT //ne radi nista ako je d > 0

//ovo treba raditi samo za prvi break dijagonale
//inace treba vrijednost u zadnjem stupcu postaviti na -32768
@32767
D=0
D = D-A
@address
A=M
M=D //obojaj zadnji piksel
@minus_one
D = M
@SKIP_MINUS_ONE
D; JEQ
@address
D = 1
A=M
M=M-D //*pixel - pixel-1
(SKIP_MINUS_ONE)
@minus_one
M=1
@address
D=M
@33
D=D+A //a = *address + 33
@address
M=D
D=0 //ovaj i sljedeca 2 retka postavljaju pixel varijablu na nulu
@pixel
M=D

(CONTINUE)
@address
A=M
D=A
@last_row
D = D - M
@END
D; JGT


@pixel
D=M
@DIAGONAL_LOOP
D;JGE


(END)
@END
0;JMP