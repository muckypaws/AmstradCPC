10 ' P47 Thunderbolt Cheat Mode
11 '(C) 1990 1st Choice Software
12 CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1:MEMORY &3FFF
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 RESTORE 49:FOR i=&4000 TO &42A4:READ a$:POKE i,VAL("&"+a$):NEXT:RESTORE 47:PEN 3:PRINT:GOSUB 19
16 a$=INKEY$:IF a$<>" " THEN 16
17 PEN 1:MODE 1:a$="O.k. Here We Go... ":GOSUB 22:CALL &BC6B,1:CALL &4000
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
41 DATA "P47 THUNDERBOLT - Cheat Mode"
42 DATA "(C) 1990 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For Firebird's","P47 Thunderbolt Gives You :-"
45 DATA "Infinite Planes","Please Wait Whilst I Set Up The Cheat"
46 DATA XX
47 DATA "Hello Again, Sorry For The Delay. Please Insert Your P47 Cassette And Press Play.","When You Are Ready Press Space."
48 DATA XX
49 DATA F3,31,F8,BF,01,C0,7F,ED,49,CD,37,BD,CD,65,BC,3E,FF,CD,6B,BC,06,00,11
50 DATA 00,10,CD,77,BC,EB,CD,83,BC,7E,FE,F3,20,01,23,22,3B,42,CD,7A,BC,F3,31
51 DATA 90,BF,01,8E,7F,AF,D9,08,CD,4B,40,23,5E,23,56,ED,53,3B,42,3A,E4,41,C6
52 DATA 01,CB,BF,32,E4,41,2A,3B,42,7E,FE,C3,28,E6,FE,F3,CA,41,42,11,C2,B3,06
53 DATA 0E,CD,B8,41,DA,6C,41,11,C2,B1,06,3F,CD,B8,41,DA,6C,41,11,18,E0,06,24
54 DATA CD,B8,41,DA,F4,40,11,CA,B0,06,1F,CD,B8,41,DA,36,41,2A,3B,42,22,3D,42
55 DATA 11,00,00,06,30,CD,B8,41,30,55,23,CD,95,41,D5,11,B8,ED,06,12,2A,3D,42
56 DATA CD,BB,41,2B,22,40,42,21,00,20,06,3C,CD,BB,41,2B,E5,2B,2B,D1,4E,73,23
57 DATA 46,72,ED,43,40,42,11,06,00,19,36,21,23,23,5E,23,56,2B,2B,E5,2A,40,42
58 DATA 19,EB,E1,73,23,72,23,36,00,23,36,00,2A,3B,42,23,22,3B,42,D1,CD,15,42
59 DATA C3,79,41,11,C2,B0,06,1C,CD,B8,41,DA,6C,41,E5,2A,3B,42,22,3D,42,11,5F
60 DATA ED,06,1E,CD,B8,41,EB,E1,E5,A7,ED,52,7D,2F,D6,02,32,40,42,E1,CD,F5,41
61 DATA 2A,3D,42,3A,40,42,12,13,D5,11,EA,B8,06,14,CD,BB,41,D1,23,4E,73,23,46
62 DATA 72,23,ED,43,3B,42,CD,15,42,18,43,ED,4B,3B,42,C5,23,22,3D,42,23,23,CD
63 DATA 95,41,2A,3B,42,23,22,3B,42,D5,CD,15,42,D1,C1,D5,2A,3D,42,5E,23,56,ED
64 DATA 53,3B,42,A7,ED,42,EB,21,16,20,19,D1,2B,73,23,72,C3,79,41,CD,95,41,2A
65 DATA 3B,42,23,22,3B,42,CD,15,42,CD,CB,41,CD,82,41,C3,00,20,06,F0,11,49,ED
66 DATA 21,00,20,CD,BB,41,D0,36,00,2B,36,00,18,ED,23,E5,6E,ED,4B,3B,42,A7,ED
67 DATA 42,26,00,22,40,42,E1,CD,F5,41,21,16,20,ED,4B,40,42,1B,09,EB,73,23,72
68 DATA 23,EB,C9,2A,3B,42,23,7E,BA,20,05,23,7E,BB,28,04,10,F4,B7,C9,37,C9,F5
69 DATA C5,3A,3F,42,EE,10,32,3F,42,01,10,7F,ED,49,ED,79,C1,F1,C9,F3,31,DC,BF
70 DATA 3E,00,ED,4F,E1,D1,C1,F1,08,D9,FD,E1,DD,E1,E1,D1,C1,F1,E5,21,DF,41,11
71 DATA 00,20,01,16,00,ED,B0,E1,ED,4B,3B,42,A7,ED,42,23,E5,2A,3B,42,C1,ED,B0
72 DATA 22,3B,42,C9,21,1E,42,01,1D,00,ED,B0,C9,31,F0,BF,F5,C5,D5,E5,DD,E5,FD
73 DATA E5,D9,08,F5,C5,D5,E5,ED,5F,D6,1F,CB,BF,32,E4,41,C3,2C,40,00,00,00,00
74 DATA 54,00,2A,3B,42,24,23,7E,FE,C2,20,FA,23,23,23,7E,FE,11,20,F2,23,23,23
75 DATA 7E,FE,ED,20,EA,23,7E,FE,53,20,E4,23,23,23,7E,FE,11,20,DC,23,23,23,7E
76 DATA FE,D5,20,D4,23,7E,FE,ED,20,CE,23,7E,FE,5B,20,C8,11,0C,00,A7,ED,52,3E
77 DATA C3,11,00,BE,77,23,73,23,72,21,9C,42,11,00,BE,01,40,00,ED,B0,2A,3B,42
78 DATA E9,F3,3E,B7,32,DC,27,C3,00,BF