10 ' XOUT Cheat Mode
11 '(C) 1990 1st Choice Software
12 CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1:MEMORY &7FFF
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 RESTORE 50:FOR i=&8000 TO &8191:READ a$:POKE i,VAL("&"+a$):NEXT:RESTORE 47:PEN 3:PRINT:GOSUB 19
16 a$=INKEY$:IF a$<>" " THEN 16
17 PEN 1:MODE 1:a$="O.k. Here We Go... ":GOSUB 22:CALL &8000
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
41 DATA "XOUT - Cheat Mode"
42 DATA "(C) 1990 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For Rainbow Arts'","Xout Gives You :-"
45 DATA "Infinite Energy (Removes Collision Detection)","Please Wait Whilst I Set Up The Cheat"
46 DATA XX
47 DATA "Hello Again, Sorry For The Delay. Please Insert Your XOUT Disk In DRIVE A:","When You Are Ready Press Space."
48 DATA XX
49 ' Hexagon Protection Systems Decoder (C) 1990 THE ARGONAUT - Not To Be Used For Infringing Copyrite etc.
50 DATA F3,ED,56,31,00,C0,01,C0,7F,ED,49,21,FF,AB,11,40,00,0E,07,CD,CE,BC,21
51 DATA CD,80,06,04,CD,77,BC,D2,52,81,EB,32,35,80,CD,83,BC,7E,FE,F3,20,01,23
52 DATA 22,CA,80,CD,7A,BC,3E,00,CB,4F,CA,52,81,F3,2A,CA,80,7E,FE,C3,CA,D1,80
53 DATA FE,F3,CA,D1,80,11,20,B1,CD,9E,80,30,7F,EB,2A,CA,80,EB,A7,ED,52,E5,C1
54 DATA 03,2A,CA,80,11,00,20,ED,B0,D5,23,22,CA,80,21,07,20,1E,7E,CD,93,80,38
55 DATA 0A,11,1B,CB,21,07,20,CD,A3,80,2B,2B,EB,E1,E5,ED,52,7D,2F,E1,77,23,36
56 DATA C9,CD,B3,80,CD,00,20,18,A8,06,0A,7E,BB,37,C8,23,10,F9,B7,C9,2A,CA,80
57 DATA 06,1E,23,7E,BA,20,05,23,7E,BB,28,04,10,F4,B7,C9,37,C9,F5,C5,3A,CC,80
58 DATA 3C,E6,1F,F6,40,32,CC,80,01,10,7F,ED,49,ED,79,C1,F1,C9,71,01,54,44,49
59 DATA 53,4B,C3,71,81,0C,07,2A,2A,2A,2A,20,57,52,4F,4E,47,20,44,49,53,4B,20
60 DATA 49,4E,20,44,52,49,56,45,20,41,3A,20,2A,2A,2A,2A,0D,0A,0A,50,52,45,53
61 DATA 53,20,22,54,22,20,54,4F,20,54,52,59,20,41,47,41,49,4E,2E,0D,0A,0A,00
62 DATA 44,65,73,69,67,6E,65,64,20,26,20,57,72,69,74,74,65,6E,20,42,79,20,2D
63 DATA 20,54,68,65,20,4D,61,73,74,65,72,20,4F,66,20,44,65,63,6F,64,65,72,73
64 DATA 20,2D,20,54,48,45,20,41,52,47,4F,4E,41,55,54,2E,CD,7D,BC,CD,7A,BC,21
65 DATA D4,80,CD,68,81,3E,33,CD,1E,BB,28,F9,C3,00,80,7E,B7,C8,23,CD,5A,BB,18
66 DATA F7,21,7B,81,22,FF,02,2A,CA,80,E9,21,8C,81,11,80,BE,22,AF,75,01,60,00
67 DATA ED,B0,C3,5A,75,AF,32,EC,15,C3,8D
