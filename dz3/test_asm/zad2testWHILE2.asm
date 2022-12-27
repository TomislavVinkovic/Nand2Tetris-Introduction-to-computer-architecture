@10
D=A
@n
M=D

@s
M=0

@s2
M=0

@m
M=0

$WHILE(n)
@n
M=M-1
$SUM(s, n, s)
@n
D=M
@m
M=D
$WHILE(m)
$SUM(s2, m, s2)
@m
M=M-1
$END
$END

(END)
@END
0;JMP