10 ' Stunt Bike Simulator Cheat Mode
11 '(C) 1989 1st Choice Software
12 CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 RESTORE 49:FOR i=&BE80 TO &BEE2:READ a$:POKE i,VAL("&"+a$):NEXT:RESTORE 47:PEN 3:PRINT:GOSUB 19
16 a$=INKEY$:IF a$<>" " THEN 16
17 PEN 1:MODE 1:a$="O.k. Here We Go...":GOSUB 22:GOSUB 54:CALL &BE80
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
41 DATA "STUNT BIKE SIMULATOR - Cheat Mode"
42 DATA "(C) 1989 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For Silverbirds","Stunt Bike Simulator Gives You Infinite Points & Attempts."
45 DATA "Please Wait Whilst I Set Up The Cheat"
46 DATA XX
47 DATA "Hello Again, Sorry For The Delay. Please Insert Your STUNT BIKE SIMULATOR Cassette And Press Play.","When You Are Ready Press Space."
48 DATA XX
49 DATA F3,01,C0,7F,ED,49,CD,37,BD,3E,FF,CD,6B,BC,11,00,01,43,CD,77,BC,EB,32
50 DATA A1,BE,E5,CD,83,BC,CD,7A,BC,3E,00,CB,4F,E1,28,E7,31,F8,BF,E5,3E,C3,21
51 DATA C3,BE,32,0E,BC,22,0F,BC,2A,38,BD,22,C4,BE,2A,01,BB,22,38,BD,C9,21,00
52 DATA 00,22,38,BD,CD,37,BD,21,D7,BE,22,95,01,AF,00,C3,0E,BC,21,00,00,22,68
53 DATA 83,22,ED,82,C3,00,80
54 SYMBOL AFTER 237:SYMBOL 239,150,215,213,245,181,183,150,0:SYMBOL 240,138,138,170,170,170,250,82,0:SYMBOL 241,206,238,168,172,200,174,174,0:SYMBOL 242,74,170,170,142,170,170,74,0:SYMBOL 243,76,174,170,170,236,170,170,0
55 SYMBOL 244,78,174,136,76,40,174,78,0:SYMBOL 245,0,1,0,0,0,0,0,0:SYMBOL 246,228,234,74,74,78,74,74,0:SYMBOL 247,196,234,170,170,174,234,202,0:SYMBOL 248,128,64,64,128,128,0,128,0:SYMBOL 249,160,161,224,192,224,160,160,0
56 SYMBOL 250,68,170,170,168,170,170,68,0:SYMBOL 251,200,232,168,200,168,238,206,0:SYMBOL 252,128,64,0,192,64,64,128,0:SYMBOL 253,164,181,181,189,173,173,164,0:SYMBOL 254,76,174,170,170,234,174,172,0:SYMBOL 255,132,138,138,138,138,234,228,0
57 SYMBOL 238,14,14,4,4,4,4,4,0:SYMBOL 237,64,160,160,160,160,160,64,0
58 CLS:LOCATE 9,2:PEN 1:PRINT"STUNT BIKE SIMULATOR":LOCATE 9,3:PRINT"--------------------":INK 2,15:INK 3,6
59 WINDOW#1,15,27,10,10:WINDOW#2,15,27,13,13
60 RETURN
