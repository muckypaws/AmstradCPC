10 ' Escape From The Planet Of The Robot Monsters Cheat Mode V1.00
11 '(C) 1990 1st Choice Software
12 CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1:MEMORY &3FFF
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 RESTORE 49:FOR i=&6000 TO &605B:READ a$:POKE i,VAL("&"+a$):NEXT:RESTORE 47:PEN 3:PRINT:GOSUB 19
16 a$=INKEY$:IF a$<>" " THEN 16
17 PEN 1:MODE 1:a$="O.k. Here We Go... ":GOSUB 22:CALL &BC6B,1:CALL &6000
18 MODE 1:GOTO 53
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
41 DATA "ESCAPE F.T.P.O.T.R. MONSTERS - Cheat"
42 DATA "(C) 1990 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For Tengen/Domark's","Escape From The Planet Of The Robot Monsters","Gives You :-"
45 DATA "Infinite Credits","Please Wait Whilst I Set Up The Cheat"
46 DATA XX
47 DATA "Hello Again, Sorry For The Delay. Please Insert Your E.F.T.P.O.T.R.M Cassette And Press Play.","When You Are Ready Press Space."
48 DATA XX
49 DATA F3,ED,73,51,60,31,F0,BF,01,C0,7F,ED,49,CD,37,BD,CD,65,BC,3E,FF,CD,6B
50 DATA BC,06,00,58,53,14,CD,77,BC,EB,E5,CD,83,BC,CD,7A,BC,E1,11,00,80,A7,ED
51 DATA 52,20,1F,2A,91,80,11,84,03,A7,ED,52,20,14,21,A8,01,22,91,80,21,54,60
52 DATA 11,88,81,01,08,00,ED,B0,C3,00,80,31,00,00,C9,3E,A7,32,1A,42,C3,84,03
53 PEN 1:PRINT"An Error Has Occured :"
54 PRINT"Either You Have Not Placed The"
55 PRINT"Correct Game Cassette."
56 PRINT"Or The Game Has A New"
57 PRINT"Protection System."
58 PRINT"If This Does Not Work A Second"
59 PRINT"Time Then Please Send Your Game"
60 PRINT"Tape To 1st Choice Software"
61 PRINT"Where An Update Will Be Issued."
62 PRINT"Press Space To Try One Last Time."
63 GOTO 16
