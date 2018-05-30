10 ' Dragons Lair Cheat Mode V1.0
11 '(C) 1989 1st Choice Software
12 CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 RESTORE 49:FOR i=&BE80 TO &BF0E:READ a$:POKE i,VAL("&"+a$):NEXT:GOSUB 56:RESTORE 47:PEN 3:GOSUB 19
16 a$=INKEY$:IF a$<>" " THEN 16
17 CALL &BBFF:PEN 1:MODE 1:a$="Loading...":GOSUB 22:CALL &BD37:CALL &BE80
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
41 DATA "DRAGON'S LAIR - Cheat Mode"
42 DATA "(C) 1989 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For Encore's / Elite's Dragon's Lair Gives You :-"
45 DATA "Infinite Lives And Allows You To Select Which Level You Wish To Start Playing On.","Please Wait Whilst I Set Up The Cheat"
46 DATA XX
47 DATA "Hello Again, Sorry For The Delay. Please Insert Your DRAGON'S LAIR Cassette And Press Play.","When You Are Ready Press Space."
48 DATA XX
49 DATA F3,31,F8,BF,01,C0,7F,ED,49,CD,37,BD,06,FF,CD,6B,BC,21,BF,BE,11,00,01
50 DATA 06,02,CD,77,BC,30,61,EB,CD,83,BC,30,5B,CD,7A,BC,30,56,21,B2,BE,22,0A
51 DATA 82,C3,F4,81,3E,B7,32,B7,25,3E,01,32,5A,25,C3,17,25,44,4C,43,72,65,61
52 DATA 74,65,64,20,42,79,20,54,68,65,20,41,52,4F,47,4E,41,55,54,20,31,39,38
53 DATA 37,4C,4F,41,44,20,45,52,52,4F,52,20,3A,20,52,45,57,49,4E,44,20,43,41
54 DATA 53,53,45,54,54,45,07,07,0D,0A,0A,00,CD,7D,BC,21,DD,BE,7E,B7,28,88,23
55 DATA CD,5A,BB,18,F6
56 PRINT"1Which Level Do You Wish To Start (1-8) ";
57 l$=INKEY$:IF l$<"1" OR l$>"8" THEN 57
58 PRINT l$:l=VAL(l$):POKE &BEB8,l:RETURN
