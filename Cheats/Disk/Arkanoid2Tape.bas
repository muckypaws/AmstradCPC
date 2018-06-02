10 ' Arkanoid II Cheat Mode
11 '(C) 1989 1st Choice Software
12 MEMORY &9FFF:CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1
14 RESTORE 39:GOSUB 18:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 18
15 RESTORE 49:FOR i=&BE80 TO &BEF8:READ a$:POKE i,VAL("&"+a$):NEXT:RESTORE 47:PEN 3:GOSUB 18
16 a$=INKEY$:IF a$<>" " THEN 16
17 PEN 1:MODE 1:a$="O.k. Here We Go...":GOSUB 21:CALL &BD37:CALL &BC6B,1:CALL &BE80
18 ' Messages
19 READ a$:IF a$="XX" THEN RETURN
20 GOSUB 21:GOTO 19
21 ' Print Routine For Mode 1 - Rather Long Winded N'est Pas ?
22 t=1:b$="":ma=40
23 IF LEN(a$)<ma+1 THEN c$=a$:GOTO 38
24 c$=""
25 mat=1
26 b$=""
27 WHILE MID$(a$,t,1)<>" " AND t<>LEN(a$)+1
28 b$=b$+MID$(a$,t,1)
29 t=t+1:WEND
30 IF MID$(a$,t,1)=" " THEN b$=b$+" ":t=t+1
31 mat=mat+LEN(b$)
32 IF mat>ma THEN 35
33 IF mat<ma+1 THEN c$=c$+b$:IF t<LEN(a$)+1 THEN 26
34 IF t=LEN(a$) OR t>LEN(a$) THEN GOSUB 38:PRINT:RETURN
35 t=t-LEN(b$)
36 GOSUB 38:PRINT
37 c$="":GOTO 25
38 FOR x=1 TO LEN(c$):PRINT MID$(c$,x,1);CHR$(24);" ";CHR$(24);CHR$(8);:SOUND 1,ASC(MID$(c$,x,1))+100,1:SOUND 2,ASC(MID$(c$,x,1))+200,1:NEXT:PAPER 0:PRINT" ":RETURN
39 ' Place Instruction Data
40 DATA "ARKANOID II - Cheat Mode"
41 DATA "(C) 1989 1st Choice Software."
42 DATA XX
43 DATA "This Cheat For Imagine's Arkanoid II Gives You Infinite Lives."
44 DATA "And By Pressing Escape At Any Point During The Game Will Uncover The Entrance To The Next Level."
45 DATA "Please Wait Whilst I Set Up The Cheat"
46 DATA XX
47 DATA "Hello Again, Sorry For The Delay. Please Insert Your Arkanoid 2 Tape And Press Play.","When You Are Ready Press Space."
48 DATA XX
49 DATA F3,31,00,C0,01,C0,7F,ED,49,21,96,BE,11,50,00,D5,01,00,01,ED,B0,C9
50 DATA F3,31,00,C0,01,C0,7F,ED,49,CD,37,BD,06,00,11,00,10,CD,77,BC,EB,CD
51 DATA 83,BC,E5,CD,7A,BC,3E,C3,21,78,00,32,4E,BB,22,4F,BB,C9,F3,31,00,C0
52 DATA 3E,C9,32,4F,34,CD,12,34,DD,21,5B,AA,11,00,01,CD,68,A8,21,A0,00,11
53 DATA 80,BE,01,40,00,ED,53,0A,AB,ED,B0,C3,92,AA,AF,32,18,33,21,00,00,22
54 DATA 18,31,22,1D,31,22,22,31,C3,FD,30
