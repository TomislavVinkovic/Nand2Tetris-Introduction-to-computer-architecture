//0^0 je nedefinirano, pa odmah skoci na kraj
@R0
D=M
@R1
D=D+M
@END
D;JEQ

@R0
D = M
@END
D;JEQ //ako je baza 0, odmah idi na kraj programa

@R1
D = M
@b
M = D-1

@R0
D = M
@R2 //answer
M = D
@increment
M = D

@R1
D = M
@answernot1
D; JGT //ako je eksponent 0, onda je odgovor (R2) = 1
@R2
M = 1
@END
0;JMP

(answernot1)
//b je kopija baze, a a kopija eksponenta(obje umanjene za 1)
//one ce mi sluziti kao kontrolne varijable
$WHILE(b) //while b>0
    @R0
    D=M
    @a
    M=D-1
    $WHILE(a) //while a>0

        //answer += increment
        @increment
        D = M
        @R2
        M = M+D

        //pomak unutarnje petlje
        @a
        M = M-1
    $END
    //increment = answer
    @R2
    D=M
    @increment
    M=D

    //pomak vanjske petlje
    @b
    M = M-1
$END

(END)
@END
0;JMP