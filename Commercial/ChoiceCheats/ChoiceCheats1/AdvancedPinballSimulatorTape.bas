10 ' Advanced Pinball Simulator Cheat Mode
11 '(C) 1989 1st Choice Software
12 MEMORY &9FFF:CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 RESTORE 49:FOR i=&A000 TO &A068:READ a$:POKE i,VAL("&"+a$):NEXT:RESTORE 47:PEN 3:GOSUB 19
16 a$=INKEY$:IF a$<>" " THEN 16
17 PEN 1:MODE 1:a$="O.k. Here We Go...":GOSUB 22:CALL &BD37:CALL &BC6B,1:CALL &A000
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
35 IF t=LEN(a$) OR t>LEN(a$) THEN GOSUB 39:RETURN
36 t=t-LEN(b$)
37 GOSUB 39:PRINT
38 c$="":GOTO 26
39 FOR x=1 TO LEN(c$):PRINT MID$(c$,x,1);CHR$(24);" ";CHR$(24);CHR$(8);:SOUND 1,ASC(MID$(c$,x,1))+100,1:SOUND 2,ASC(MID$(c$,x,1))+200,1:NEXT:PAPER 0:PRINT" ":RETURN
40 ' Place Instruction Data
41 DATA "ADVANCED PINBALL SIMULATOR - Cheat Mode"
42 DATA "(C) 1989 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For Codemasters Advanced Pinball Simulator Gives You Infinite Balls For All Players."
45 DATA "Please Wait Whilst I Set Up The Cheat"
46 DATA XX
47 DATA "Hello Again, Sorry For The Delay. Please Insert Your PINBALL Tape And Press Play.","When You Are Ready Press Space."
48 DATA XX
49 DATA F3,31,00,C0,CD,37,BD,06,00,11,00,10,CD,77,BC,EB
50 DATA CD,83,BC,E5,CD,7A,BC,3E,C3,21,38,A0,32,76,3A,22
51 DATA 77,3A,21,45,A0,11,00,BE,01,00,01,ED,B0,21,40,00
52 DATA E5,21,00,BB,E5,C3,4B,3A,3E,45,32,4B,00,3E,99,32
53 DATA 4E,00,F3,F1,C9,F3,DD,21,00,BF,11,47,00,CD,67,BB
54 DATA 21,14,BE,22,44,BF,C3,00,BF
55 DATA 21,1b,04,7e,fe,3d,28,03,21,15,04,36,00,c3,31,01
