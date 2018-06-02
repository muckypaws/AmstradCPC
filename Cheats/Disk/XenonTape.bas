10 ' Xenon Cheat Mode
11 '(C) 1990 1st Choice Software
12 CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1:MEMORY &7FFF
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 RESTORE 49:FOR i=&8000 TO &8069:READ a$:POKE i,VAL("&"+a$):NEXT:RESTORE 47:PEN 3:PRINT:GOSUB 19
16 a$=INKEY$:IF a$<>" " THEN 16
17 PEN 1:MODE 1:a$="O.k. Here We Go...":GOSUB 22:CALL &8000
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
41 DATA "XENON - Cheat Mode"
42 DATA "(C) 1990 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For Melbourne House's","Xenon Gives You :-"
45 DATA "Infinite Lives","Please Wait Whilst I Set Up The Cheat"
46 DATA XX
47 DATA "Hello Again, Sorry For The Delay. Please Insert Your Fully Rewound Xenon Cassette And Press Play.","When You Are Ready Press Space."
48 DATA XX
49 DATA F3,31,F8,BF,01,C0,7F,ED,49,CD,37,BD,3E,FF,CD,6B,BC,00,00,00,21,3F,80
50 DATA 11,00,10,06,00,CD,77,BC,EB,CD,83,BC,E5,CD,7A,BC,21,37,80,11,50,00,01
51 DATA 40,00,ED,53,C9,03,ED,B0,C9,3E,B6,32,2A,08,C3,78,05,44,49,53,43,2E,42
52 DATA 49,4E,28,43,29,20,31,39,38,38,39,20,31,73,74,20,43,68,6F,69,63,65,20
53 DATA 53,6F,66,74,77,61,72,65,20,4C,74,64,2E,00
