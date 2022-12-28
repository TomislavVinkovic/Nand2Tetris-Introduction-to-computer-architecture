@R0
D = M
@a
M = D-1

@answer
M = D
@increment
M = D

@R1
D = M
@m
M = D-1

//a je kopija baze, a m kopija eksponenta(obje umanjene za 1)
//one ce mi sluziti kao kontrolne varijable
$WHILE(a)
    $WHILE(m)
        @increment
        D = M
        @answer
        M = M+D

        //pomak unutarnje petlje
        @m
        M = M-1
    $END
    @answer
    D=M
    @increment
    M=D

    //pomak vanjske petlje
    @a
    M = M-1
$END