10 ' The Untouchables Cheat Mode
11 '(C) 1989 1st Choice Software
12 CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1:MEMORY &3FFF
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 RESTORE 49:FOR i=&4000 TO &4320:READ a$:POKE i,VAL("&"+a$):NEXT:RESTORE 47:PEN 3:PRINT:GOSUB 19
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
41 DATA "THE UNTOUCHABLES - Cheat Mode"
42 DATA "(C) 1990 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For Ocean's","Untouchables Gives You :-"
45 DATA "Infinite Time","Infinite Life Force On Scene 1","Please Wait Whilst I Set Up The Cheat"
46 DATA XX
47 DATA "Hello Again, Sorry For The Delay. Please Insert Your UNTOUCHABLES Cassette And Press Play.","When You Are Ready Press Space."
48 DATA XX
49 DATA F3,31,00,C0,01,C0,7F,ED,49,CD,37,BD,01,00,00,CD,38,BC,AF,47,48,CD,32
50 DATA BC,06,00,11,00,10,CD,77,BC,EB,CD,83,BC,7E,FE,F3,20,01,23,22,68,42,CD
51 DATA 7A,BC,F3,31,90,BF,01,8E,7F,AF,D9,08,2A,70,42,23,22,70,42,CD,56,40,23
52 DATA 5E,23,56,ED,53,68,42,3A,0F,42,C6,01,CB,BF,32,0F,42,2A,68,42,7E,FE,C3
53 DATA 28,E6,FE,F3,CA,A7,42,11,C2,B3,06,0E,CD,D8,41,30,03,C3,8C,41,11,C2,B1
54 DATA 06,3F,CD,D8,41,30,03,C3,8C,41,11,18,E0,06,24,CD,D8,41,30,03,C3,14,41
55 DATA 11,CA,B0,06,1F,CD,D8,41,30,03,C3,56,41,2A,68,42,22,6A,42,11,00,00,06
56 DATA 30,CD,D8,41,30,55,23,CD,B5,41,D5,11,B8,ED,06,12,2A,6A,42,CD,DB,41,2B
57 DATA 22,6F,42,21,00,20,06,3C,CD,DB,41,2B,E5,2B,2B,D1,4E,73,23,46,72,ED,43
58 DATA 6F,42,11,06,00,19,36,21,23,23,5E,23,56,2B,2B,E5,2A,6F,42,19,EB,E1,73
59 DATA 23,72,23,36,00,23,36,00,2A,68,42,23,22,68,42,D1,CD,40,42,C3,99,41,11
60 DATA C2,B0,06,1C,CD,D8,41,30,03,C3,8C,41,31,F8,BF,01,C4,7F,ED,49,C3,00,40
61 DATA E5,2A,68,42,22,6A,42,11,5F,ED,06,1E,CD,D8,41,EB,E1,E5,A7,ED,52,7D,2F
62 DATA D6,02,32,6F,42,E1,CD,20,42,2A,6A,42,3A,6F,42,12,13,D5,11,EA,B8,06,14
63 DATA CD,DB,41,D1,23,4E,73,23,46,72,23,ED,43,68,42,CD,40,42,18,43,ED,4B,68
64 DATA 42,C5,23,22,6A,42,23,23,CD,B5,41,2A,68,42,23,22,68,42,D5,CD,40,42,D1
65 DATA C1,D5,2A,6A,42,5E,23,56,ED,53,68,42,A7,ED,42,EB,21,16,20,19,D1,2B,73
66 DATA 23,72,C3,99,41,CD,B5,41,2A,68,42,23,22,68,42,CD,40,42,CD,EB,41,CD,A2
67 DATA 41,C3,00,20,06,F0,11,49,ED,21,00,20,CD,DB,41,D0,36,00,2B,36,00,18,ED
68 DATA 23,E5,6E,ED,4B,68,42,A7,ED,42,26,00,22,6F,42,E1,CD,20,42,21,16,20,ED
69 DATA 4B,6F,42,1B,09,EB,73,23,72,23,EB,C9,2A,68,42,23,7E,BA,20,05,23,7E,BB
70 DATA 28,04,10,F4,B7,C9,37,C9,F5,C5,3A,6E,42,EE,10,32,6E,42,01,10,7F,ED,49
71 DATA ED,79,C1,F1,C9,21,FF,AB,11,40,00,0E,07,C3,CE,BC,F3,31,DC,BF,3E,00,ED
72 DATA 4F,E1,D1,C1,F1,08,D9,FD,E1,DD,E1,E1,D1,C1,F1,E5,21,0A,42,11,00,20,01
73 DATA 16,00,ED,B0,E1,ED,4B,68,42,A7,ED,42,23,E5,2A,68,42,C1,ED,B0,22,68,42
74 DATA C9,21,49,42,01,1D,00,ED,B0,C9,31,F0,BF,F5,C5,D5,E5,DD,E5,FD,E5,D9,08
75 DATA F5,C5,D5,E5,ED,5F,D6,1F,CB,BF,32,0F,42,C3,30,40,00,00,00,00,00,00,00
76 DATA 00,56,00,00,00,41,42,43,44,45,46,47,48,49,4A,4B,4C,4D,4E,4F,50,51,52
77 DATA 53,54,55,56,57,58,59,5A,30,31,32,33,34,35,36,37,38,39,21,22,23,24,26
78 DATA 2B,2D,40,5E,20,20,20,20,20,20,20,20,31,F8,BF,2A,68,42,24,23,7E,FE,C2
79 DATA 20,FA,23,23,23,7E,FE,11,20,F2,23,23,23,7E,FE,ED,20,EA,23,7E,FE,53,20
80 DATA E4,23,23,23,7E,FE,11,20,DC,23,23,23,7E,FE,D5,20,D4,23,7E,FE,ED,20,CE
81 DATA 23,7E,FE,5B,20,C8,11,0C,00,A7,ED,52,3E,C3,11,00,BE,77,23,73,23,72,21
82 DATA 02,43,01,40,00,ED,B0,2A,68,42,E9,21,12,BE,11,40,00,ED,53,90,80,01,40
83 DATA 00,ED,B0,C3,00,80,AF,32,E1,0F,32,D2,0F,32,16,46,C3,90,10
