//VARIJABLE ZA POCETAK I KRAJ POLJA
@100
D=A
@start
M=D

@R0
D=M
@100
D=D+A
D=D-1 //polje 0-indeksirano
@end
M=D

//SELECTION SORT
@end
D=M
@start
D=D-M
D=D+1 //duljina polja je gornja granica - donja granica + 1

@n //varijabla duljine polja
M=D

@i
M = 0
//for(i = 0; i < n-1; i++)
(OUTER_LOOP)
    $MV(i, min_idx)
    //iduce 3 linije: j = i+1
    $MV(i,j)
        @j
        M = M+1
        //for(j = i+1; j < n; j++)
        (INNER_LOOP)
            @start
            D = M
            @min_idx
            D = D + M //D = start + min_idx
            A = D
            D = M //D = *(arr + min_idx)
            @tmpA
            M = D //tmpA = *(arr + min_idx)

            @start
            D = M
            @j
            D = D + M //D = start + j
            A = D
            D = M //D = *(arr + j)
            @tmpB
            M = D

            //usporedba tmpA i tmpB
            @tmpA
            D = M
            @tmpB
            D = D - M
            @SWAP_SKIP
            D; JLE //ako je element na min_idx i dalje najmanji, nemoj radit swap

            //inace, spremi j u min_idx
            $MV(j, min_idx)

            (SWAP_SKIP)
            //provjeri je li min_idx == i
            @min_idx
            D = M
            @i
            D = D - M
            @OUTER_INCREMENT
            D;JEQ

            //inace, swapaj elemente na ta 2 indeksa
            @start
            D = M
            @min_idx
            D = D + M //D = start + min_idx
            A = D
            D = M //D = *(arr + min_idx)
            @tmpA
            M = D //tmpA = *(arr + min_idx)

            @start
            D = M
            @i
            D = D + M //D = start + i
            A = D
            D = M //D = *(arr + i)
            @tmpB
            M = D

            //prvi swap
            @start
            D = M
            @min_idx
            D = D + M //D = start + min_idx
            @tmpC
            M = D //tmpC = start + min_idx, to je sad spremljeno
            
            @tmpB
            D = M //D = tmpB
            @tmpC
            A = M //A = tmpC = start + min_idx
            M = D //*(arr + min_idx) = tmpB

            //drugi swap
            @start
            D = M
            @i
            D = D + M //D = start + i
            @tmpC
            M = D //tmpC = start + i, to je sad spremljeno
            
            @tmpA
            D = M //D = tmpB
            @tmpC
            A = M //A = tmpC = start + i
            M = D //*(arr + i) = tmpB

            //pomak petlje
            (OUTER_INCREMENT)
            @j
            M = M+1
            D = M
            @n
            D = M - D
            @INNER_LOOP
            D; JGT //ako je n > j
        (INNER_LOOP_END)
    //pomak petlje
    @i
    M = M+1
    D = M
    @n
    D = M - D
    D = D - 1
    @OUTER_LOOP
    D;JGT //ako je n-1 > i
(OUTER_LOOP_END)

(END)
@END
0;JMP