10 ' Wonder Boy Cheat Mode
11 '(C) 1990 1st Choice Software
12 MEMORY &3FFF:CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1:INK 2,15
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 RESTORE 49:FOR i=&9000 TO &906B:READ a$:POKE i,VAL("&"+a$):NEXT:RESTORE 47:PEN 3:PRINT:GOSUB 19
16 a$=INKEY$:IF a$<>" " THEN 16
17 PEN 1:MODE 1:a$="O.k. Here We Go...":GOSUB 22:CALL &BD37:LOAD"!":CALL &BC6B,1:CALL &9000
18 END
19 ' Messages
20 READ a$:IF a$="XX" THEN RETURN
21 GOSUB 22:GOTO 20
22 ' Print Routine For Mode 1 - Rather Long Winded N'est Pas ?
23 t=1:b$="":ma=40
24 IF LEN(a$)<ma+1 THEN c$=a$:GOTO 39
25 c$=""
26 mat=1
27 b$=""
28 WHILE MID$(a$,t,1)<>" " AND t<>LEN(a$)+1
29 b$=b$+MID$(a$,t,1)
30 t=t+1:WEND
31 IF MID$(a$,t,1)=" " THEN b$=b$+" ":t=t+1
32 mat=mat+LEN(b$)
33 IF mat>ma THEN 36
34 IF mat<ma+1 THEN c$=c$+b$:IF t<LEN(a$)+1 THEN 27
35 IF t=LEN(a$) OR t>LEN(a$) THEN GOSUB 39:PRINT:RETURN
36 t=t-LEN(b$)
37 GOSUB 39:PRINT
38 c$="":GOTO 26
39 FOR x=1 TO LEN(c$):PRINT MID$(c$,x,1);CHR$(24);" ";CHR$(24);CHR$(8);:SOUND 1,ASC(MID$(c$,x,1))+100,1:SOUND 2,ASC(MID$(c$,x,1))+200,1:NEXT:PAPER 0:PRINT" ":RETURN
40 ' Place Instruction Data
41 DATA "WONDER BOY - Cheat Mode"
42 DATA "(C) 1990 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For The Hit Squads","Wonder Boy Gives You Infinite Lives For Both Players."
45 DATA "Please Wait Whilst I Set Up The Cheat"
46 DATA XX
47 DATA "Hello Again, Sorry For The Delay. Please Insert Your WONDER BOY Tape And","Press Play.","When You Are Ready Press Space."
48 DATA XX
49 DATA 3E,C3,21,27,90,32,80,BE,22,81,BE,3E,8F,32,7F,41,3E,B3,32,CC
50 DATA 41,3E,F9,32,2C,42,3E,02,32,2B,42,21,05,40,0E,FF,C3,16,BD,21
51 DATA 65,90,11,80,BE,01,A0,00,ED,B0,2A,01,AC,23,22,40,90,7E,FE,1C
52 DATA 20,F7,AF,32,00,00,23,7E,22,58,90,FE,C4,20,F7,23,7E,FE,14,20
53 DATA F1,23,7E,FE,AC,20,EB,21,00,00,36,C3,23,36,80,23,36,BE,C3,00
54 DATA AC,AF,32,E5,52,C3,14,AC
