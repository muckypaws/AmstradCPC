10 ' PUNCH & JUDY Cheat Mode V1.0
11 '(C) 1990 1st Choice Software
12 CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 RESTORE 49:FOR i=&BE80 TO &BEEC:READ a$:POKE i,VAL("&"+a$):NEXT:RESTORE 47:PEN 3:PRINT:GOSUB 19
16 a$=INKEY$:IF a$<>" " THEN 16
17 PEN 1:MODE 1:a$="O.k. Here We Go...":GOSUB 22:CALL &BD37:CALL &BE80
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
41 DATA "PUNCH & JUDY - Cheat Mode"
42 DATA "(C) 1990 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For Alternative's","Punch & Judy Gives You :-"
45 DATA "Infinite Tidal Time","Please Wait Whilst I Set Up The Cheat"
46 DATA XX
47 DATA "Hello Again, Sorry For The Delay. Please Insert Your PUNCH & JUDY Cassette And Press Play.","When You Are Ready Press Space."
48 DATA XX
49 DATA F3,31,F8,BF,01,C0,7F,ED,49,CD,37,BD,3E,FF,CD,6B,BC,CD,A6,BE,3E,00,CB
50 DATA 4F,CC,BA,BE,28,F4,21,DB,BE,22,9B,00,C3,40,00,11,70,01,06,00,CD,77,BC
51 DATA 21,40,00,32,95,BE,CD,83,BC,C3,7A,BC,F5,21,CA,BE,7E,B7,28,06,23,CD,5A
52 DATA BB,18,F6,F1,C9,0C,07,4C,6F,61,64,69,6E,67,2E,2E,2E,2E,0D,0A,0A,00,AF
53 DATA 6F,65,32,87,13,32,8E,13,22,7F,13,22,80,13,C3,00,03
