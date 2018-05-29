10 ' Batman The Caped Crusader Cheat Mode
11 '(C) 1989 1st Choice Software
12 CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 RESTORE 49:FOR i=&BE80 TO &BF09:READ a$:POKE i,VAL("&"+a$):NEXT:RESTORE 47:PEN 3:PRINT:GOSUB 19
16 a$=INKEY$:IF a$<>" " THEN 16
17 PEN 1:MODE 1:a$="O.k. Here We Go...":GOSUB 22:CALL &BE80
18 END
19 ' Messages
20 READ a$:IF a$="XX" THEN RETURN
21 GOSUB 22:GOTO 20
22 ' Print Routine For Mode 1 - Rather Long Winded N'est Pas ?
23 t=1:b$="":ma=39
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
41 DATA "BATMAN THE CAPED CRUSADER - Cheat Mode"
42 DATA "(C) 1989 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For Oceans Batman Removes The Collision Detection So That You Can Never Die. This Cheat Works Out Which Plot You Have Loaded."
45 DATA "Please Wait Whilst I Set Up The Cheat"
46 DATA XX
47 DATA "Hello Again, Sorry For The Delay. Please Insert Your Batman Tape Either Side And Press Play.","When You Are Ready Press Space."
48 DATA XX
49 DATA F3,31,00,C0,01,C0,7F,ED,49,CD,37,BD,CD,65,BC,3E,FF,CD,6B,BC,06,00
50 DATA 11,00,10,CD,77,BC,EB,CD,83,BC,E5,CD,7A,BC,3E,C3,21,B0,BE,32,16,BD
51 DATA 22,17,BD,C9,F3,01,00,F6,ED,49,3E,C9,32,3A,A6,CD,0C,A6,DD,21,B1,A8
52 DATA 11,05,01,CD,C2,A6,2A,B4,A9,11,30,6A,A7,ED,52,7C,B5,21,EA,BE,28,03
53 DATA 21,F8,BE,11,80,BE,ED,53,B4,A9,01,20,00,ED,B0,C3,E8,A8,3E,C9,21,00
54 DATA 00,32,80,70,22,37,7B,C3,30,6A,3E,C9,21,00,00,32,A7,72,22,12,7D,C3
55 DATA FD,69,00,00,00,00
