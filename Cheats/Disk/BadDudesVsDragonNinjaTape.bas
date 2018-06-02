10 ' Bad Dudes Vs The Dragon Ninja Cheat Mode
11 '(C) 1989 1st Choice Software
12 MEMORY &9FFF:CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 RESTORE 49:FOR i=&BE80 TO &BF0E:READ a$:POKE i,VAL("&"+a$):NEXT:RESTORE 47:PEN 3:PRINT:GOSUB 19
16 a$=INKEY$:IF a$<>" " THEN 16
17 PEN 1:MODE 1:a$="O.k. Here We Go...":GOSUB 22:CALL &BD37:CALL &BC6B,1:CALL &BE92
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
41 DATA "DRAGON NINJA - Cheat Mode"
42 DATA "(C) 1989 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For Imagine's","Bad Dudes Vs The Dragon Ninja Gives You Infinite Lives And Infinite Health."
45 DATA "Please Wait Whilst I Set Up The Cheat"
46 DATA XX
47 DATA "Hello Again, Sorry For The Delay. Please Insert Your Dragon Ninja Tape And Press Play.","When You Are Ready Press Space."
48 DATA XX
49 DATA AF,32,16,1F,32,51,22,32,54,1D,01,8C,7F,ED,49,C3,00,80,CD,37,BD,F3
50 DATA 31,00,C0,3E,01,CD,0E,BC,AF,F5,01,00,00,CD,32,BC,F1,3C,FE,04,20,F3
51 DATA 21,00,C0,11,01,C0,01,FF,3F,36,F0,ED,B0,01,00,00,CD,38,BC,CD,19,BD
52 DATA 01,18,18,AF,CD,32,BC,3E,02,01,0F,0F,CD,32,BC,3E,03,01,06,06,CD,32
53 DATA BC,3E,FF,CD,6B,BC,06,00,11,00,10,CD,77,BC,EB,CD,83,BC,E5,CD,7A,BC
54 DATA 3E,C3,21,FA,BE,32,16,BD,22,17,BD,C9,F3,DD,21,BA,A8,11,AB,00,CD,49
55 DATA A8,F3,21,80,BE,22,63,A9,C3,F1,A8
