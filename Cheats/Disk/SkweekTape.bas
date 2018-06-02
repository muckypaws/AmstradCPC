10 ' SKWEEK Cheat Mode
11 '(C) 1989 1st Choice Software
12 CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 RESTORE 49:FOR i=&BE80 TO &BF10:READ a$:POKE i,VAL("&"+a$):NEXT:RESTORE 47:PEN 3:PRINT:GOSUB 19
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
41 DATA "SKWEEK - Cheat Mode"
42 DATA "(C) 1989 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For Loricels Skweek Gives You Infinite Lives."
45 DATA "Please Wait Whilst I Set Up The Cheat"
46 DATA XX
47 DATA "Hello Again, Sorry For The Delay. Please Insert Your SKWEEK Cassette And Press Play.","When You Are Ready Press Space.","Please Note You Do Not Get The First Title Page Of The Cat !!! - Sorry !"
48 DATA XX
49 DATA F3,01,C0,7F,ED,49,CD,37,BD,3E,FF,CD,6B,BC,06,00,11,00,70,CD,77,BC
50 DATA EB,CD,83,BC,CD,7A,BC,21,6F,01,11,4F,07,3E,58,E5,D5,CD,A1,BC,D1,E1
51 DATA 06,0A,0E,E5,7E,A9,77,23,1B,10,F9,AE,77,23,1B,47,7A,B3,78,20,F6,21
52 DATA 01,BF,22,D0,02,0E,00,CD,0F,B9,21,C0,08,3A,02,C0,B7,28,18,22,66,AE
53 DATA 22,68,AE,22,6A,AE,22,6C,AE,21,40,00,36,00,3D,CA,7D,EA,C3,78,EA,22
54 DATA 83,AE,22,85,AE,22,87,AE,22,89,AE,21,40,00,36,00,C3,BD,E9,21,0A,BF
55 DATA 22,1A,9F,C3,10,80,AF,32,B2,72,C3,30,72
