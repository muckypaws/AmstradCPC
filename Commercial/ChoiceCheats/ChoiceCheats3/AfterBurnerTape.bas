10 ' After Burner Cheat Mode
11 '(C) 1989 1st Choice Software
12 CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 RESTORE 49:FOR i=&BE80 TO &BEF7:READ a$:POKE i,VAL("&"+a$):NEXT:RESTORE 47:PEN 3:PRINT:GOSUB 19
16 a$=INKEY$:IF a$<>" " THEN 16
17 PEN 1:MODE 1:a$="O.k. Here We Go...":GOSUB 22:CALL &BE80
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
41 DATA "AFTER BURNER - Cheat Mode"
42 DATA "(C) 1989 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For Activision's After Burner","Gives You Infinite Lives & Missiles."
45 DATA "Please Wait Whilst I Set Up The Cheat"
46 DATA XX
47 DATA "Hello Again, Sorry For The Delay. Please Insert Your AFTER BURNER Cassette And Press Play.","When You Are Ready Press Space."
48 DATA XX
49 DATA F3,01,C0,7F,ED,49,31,00,C0,21,16,BD,11,F8,BE,01,03,00,ED,B0,CD,37
50 DATA BD,CD,65,BC,3E,FF,CD,6B,BC,06,00,11,00,10,CD,77,BC,EB,CD,83,BC,E5
51 DATA CD,7A,BC,3E,C3,21,BB,BE,32,16,BD,22,17,BD,C9,21,C3,BE,0E,FF,CD,F8
52 DATA BE,3E,C9,32,41,A6,CD,08,A6,F3,DD,21,B8,A8,11,AB,00,CD,C9,A6,21,DF
53 DATA BE,22,61,A9,C3,EF,A8,06,06,21,A7,20,CD,F2,BE,06,03,21,57,1D,CD,F2
54 DATA BE,C3,00,46,36,00,23,10,FB,C9
