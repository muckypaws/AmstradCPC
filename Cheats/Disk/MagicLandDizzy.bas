10 ' Magic Land Dizzy Cheat Mode
11 '(C) 1991 1st Choice Software
12 CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1:MEMORY &3FFF
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 RESTORE 49:FOR i=&A000 TO &A071:READ a$:POKE i,VAL("&"+a$):NEXT:RESTORE 47:PEN 3:PRINT:GOSUB 19
16 a$=INKEY$:IF a$<>" " THEN 16
17 PEN 1:MODE 1:a$="O.k. Here We Go... ":GOSUB 22:CALL &BC6B,1:CALL &A000
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
41 DATA "MAGICLAND DIZZY - Cheat Mode"
42 DATA "(C) 1991 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For Codemasters'","Magicland Dizzy Gives You :-"
45 DATA "Infinite Live & Energy.","Please Wait Whilst I Set Up The Cheat"
46 DATA XX
47 DATA "Hello Again, Sorry For The Delay. Please Insert Your Magicland Dizzy Cassette And Press Play.","When You Are Ready Press Space."
48 DATA XX
49 DATA F3,01,C0,7F,ED,49,31,F8,BF,CD,37,BD,3E,FF,CD,6B,BC,06,00,11,70,01,CD
50 DATA 77,BC,EB,CD,83,BC,E5,CD,7A,BC,F3,21,AB,8A,11,00,BE,ED,53,32,8B,01,BB
51 DATA 01,ED,B0,21,68,A0,11,00,00,01,0A,00,ED,B0,21,5A,A0,11,00,BE,01,0E,00
52 DATA ED,B0,31,00,BE,3E,FF,32,FF,FF,01,8D,7F,ED,49,21,00,C0,C3,10,BE,21,00
53 DATA C3,22,4B,3E,3E,C7,32,A9,54,C3,E0,BC,78,3C,28,02,3E,01,3D,47,7E,C9
