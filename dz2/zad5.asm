//PSEUDOKOD
// char1 = [
//     111....,
//     010...,
//     ...
// ];
// ...ponovi postupak za charactere od 2 do 5
// (INPUT)
// If(KeyIn() in range(0..5)) {
//     if(ScreenFull()) {
//     Ignore()
//     }
//     if(KeyIn() == Num1) {
//         drawChar1()
//     }
//     elif(KeyIn() == Num2) {
//         drawChar2()
//     }
//     ..ponovi postupak za karaktere od 3 do 5
//     elif(KeyIn() == Num0) {
//         deleteLastChar()
//     }
// }

//define character 1
//top i bottom red svakog slova moraju biti nule zbog offseta kod novog reda
@chA1
M=0

@504 //gornje podebljanje
D=A
@chA2
M=D

@448 //sredina, vecina piksela je obojana bas ovako
D=A
@chA3
M=D
@chA4
M=D
@chA5
M=D
@chA6
M=D
@chA7
M=D
@chA8
M=D
@chA9
M=D
@chA10
M=D
@chA11
M=D
@chA12
M=D
@chA13
M=D
@chA14
M=D

@4088 //donje podebljanje
D=A
@chA15
M=D

@chA16
M=0


//define character 2

@chB1
M=0

@8184
D=A
@chB2
M=D

@6168
D=A
@chB3
M=D

@6264
D=A
@chB4
M=D

@3696
D=A
@chB5
M=D

@3584
D=A
@chB6
M=D

@1920
D=A
@chB7
M=D

@896
D=A
@chB8
M=D

@224
D=A
@chB9
M=D
@chB10
M=D

@112
D=A
@chB11
M=D
@chB12
M=D

@28
D=A
@chB13
M=D
@chB14
M=D

@16380
D=A
@chB15
M=D

@chB16
M=0

//define character 3

@chC1
M=0

@16352
D=A
@chC2
M=D

@12288
D=A
@chC3
M=D
@chC4
M=D
@chC5
M=D
@chC6
M=D
@chC7
M=D

@16352
D=A
@chC8
M=D
@chC9
M=D

@12288
D=A
@chC10
M=D
@chC11
M=D
@chC12
M=D
@chC13
M=D
@chC14
M=D

@16352
D=A
@chC15
M=D

@chC16
M=0

//define character 4
@chD1
M=0

@3084
D=A
@chD2
M=D
@chD3
M=D
@chD4
M=D
@chD5
M=D
@chD6
M=D
@chD7
M=D

@4092
D=A
@chD8
M=D
@chD9
M=D

@3072
D=A
@chD10
M=D
@chD11
M=D
@chD12
M=D
@chD13
M=D
@chD14
M=D
@chD15
M=D

@chD16
M=0

//define character 5
@chE1
M=0

@4088
D=A
@chE2
M=D

@24
D=A
@chE3
M=D
@chE4
M=D
@chE5
M=D
@chE6
M=D

@4088
D=A
@chE7
M=D
@chE8
M=D

@6144
D=A
@chE9
M=D
@chE10
M=D
@chE11
M=D
@chE12
M=D
@chE13
M=D
@chE14
M=D

@4088
D=A
@chE15
M=D

@chE16
M=0

//u 1 red stane 32 znaka
//u 1 stupac stane 16 znakova
// => kad adresa prijede screen + 512, ne mogu vise pisati

@offset
M=0

@SCREEN
D = A
@draw_start
M = D

(MAIN_LOOP)

@KBD
D=M
@MAIN_LOOP
D;JEQ //preskoci crtanje u ovom cycleu ako je D = 0 (niti jedan karakter nije pritisnut)
@chr_to_draw_address
M = -1
//inace, zapocni update ekrana
//prvo, odredi koji broj je pritisnut
@key
M=D //ovdje spremi koji mi je key pritisnut

(ONE)
//if key == 1
@key
D=M
@49
D=D-A
@TWO
D;JNE
//postavi pointer na prvi registar karaktera 1
@chA1
D=A
@chr_to_draw_address
M = D
@DRAW
0;JMP //skoci na draw

(TWO)
@key
D=M
@50
D=D-A
@THREE
D;JNE

//postavi pointer na prvi registar karaktera 2
@chB1
D=A
@chr_to_draw_address
M = D
@DRAW
0;JMP //skoci na draw

(THREE)
@key
D=M
@51
D=D-A
@FOUR
D;JNE

//postavi pointer na prvi registar karaktera 3
@chC1
D=A
@chr_to_draw_address
M = D
@DRAW
0;JMP //skoci na draw

(FOUR)
@key
D=M
@52
D=D-A
@FIVE
D;JNE

//postavi pointer na prvi registar karaktera 4
@chD1
D=A
@chr_to_draw_address
M = D
@DRAW
0;JMP //skoci na draw

(FIVE)
@key
D=M
@53
D=D-A
@ZERO
D;JNE

//postavi pointer na prvi registar karaktera 5
@chE1
D=A
@chr_to_draw_address
M = D
@DRAW
0;JMP //skoci na draw

(ZERO)
@key
D=M
@48
D=D-A

@DELETE
D;JEQ //delete the last character

@ELSE
0;JMP

//----------------------- POCETAK RUTINE ZA CRTANJE -------------------------------------------------
(DRAW)
//provjeri jel adresa za iscrtavanje ide out of bounds
@offset
D = M
@draw_start
D = D + M
@24575 //zadnja moguca adresa za output na zaslonu
D = D - A
@ELSE
D; JGT

@chr_to_draw_address
D = M
@address
M = D
@16
D=A
@i //counter varijabla
M=D
@draw_start
D=M
@offset //pomakni draw adresu za offset
D = D + M
@drawAddress
M=D

(DRAW_LOOP)
@address
A = M
D = M

@drawAddress
A = M
M = D

@address
M = M + 1 //idi na sljedeci dio karaktera
@32
D=A
@drawAddress
M = M + D //pomakni se u iduci red za crtanje

@i
M = M - 1
D=M
@DRAW_LOOP
D; JGT

//dok god kljuc nije do kraja pusten, vrti ovo
(LET_GO)
@KBD
D = M
@LET_GO
D; JNE

//kad si gotov s petljom, inkrementiraj offset
//provjeri je li offset 31. ako je, prijedi u skroz novi red
@offset
D = M //D = offset
@31
D = D - A //D = D - 31
@INC_OFFSET
D; JNE //inkrementiraj umjesto da prelazis u novi red

@offset
M = 0
@draw_start
D = M
@512
D = D + A
@draw_start
M = D
@ELSE
0;JMP

//inkrementiraj offset za 1
(INC_OFFSET)
@offset
M = M + 1

@ELSE
0;JMP
//------------------------------------------ KRAJ RUTINE ZA CRTANJE -------------------------------------

//------------------------------------------ POCETAK RUTINE ZA BRISANJE ---------------------------------

(DELETE)
@offset
D = M
@draw_start
D = D + M
@SCREEN
D = D - A //=0 <=> offset + draw_start ==0 screen
@OFFSET_RESET
D; JLE //nemas sta brisat ako je ekran prazan

//ako ekran nije prazan, imamo 2 slucaja:
//1. offset je veci od 0 (lakse)
//2. offset je 0, ali ima nesto u gornjem dijelu ekrana. (teze)

//1. slucaj
//pobrisi sve u 16x16 celiji
@offset
D = M
@CASE_2
D; JLE //bilo JEQ 

//inace, smanji offset za 1
D = D - 1
@offset
M = D

@16
D = A //D = 16
@i
M = D //i = 16
@draw_start
D=M //D = *draw_start, neka mamorijska adresa
@offset //pomakni draw adresu za offset
D = D + M //D = draw_start + offset

@drawAddress
M = D

(CLEAR_LOOP)
@drawAddress
A = M
M = 0 //clearaj dio celije

@32
D=A
@drawAddress
M = M + D //pomakni se u iduci red za crtanje

@i
M = M - 1
D=M
@CLEAR_LOOP
D; JGT

(LET_GO_2)
@KBD
D = M
@LET_GO_2
D; JNE

@ELSE
0;JMP

(CASE_2)
//odi u red gore
@draw_start
D = M //D = draw_start
@512
D = D - A // D = draw_start - 512
@draw_start
M = D //draw_start = D = draw_start - 512

//postavi offset tako da brise zadnji character
@31
D = A
@offset
M = D

@draw_start
D = D + M //D = draw_start + 31
@drawAddress
M = D
@16
D = A //D = 16
@i
M = D //i = 16

(CLEAR_LOOP_2)
@drawAddress
A = M
M = 0 //clearaj dio celije

@32
D=A
@drawAddress
M = M + D //pomakni se u iduci red za crtanje

@i
M = M - 1
D=M
@CLEAR_LOOP_2
D; JGT

(LET_GO_3)
@KBD
D = M
@LET_GO_3
D; JNE
@ELSE
0;JMP

//------------------------------------------ KRAJ RUTINE ZA BRISANJE ---------------------------------
(OFFSET_RESET)
@offset
M = 0

(ELSE)
@MAIN_LOOP
0;JMP

//obrati paznju na:
//onemoguciti previse delete operacija !
//prelazak u novi red :)
//nemogucnost crtanja kad se ekran napuni :)