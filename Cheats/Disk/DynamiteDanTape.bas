10 ' Dynamite Dan Cheat Mode
11 '(C) 1989 1st Choice Software
12 MEMORY &9FFF:CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 RESTORE 49:FOR i=&BE80 TO &BEE3:READ a$:POKE i,VAL("&"+a$):NEXT:RESTORE 47:PEN 3:PRINT:GOSUB 19
16 a$=INKEY$:IF a$<>" " THEN 16
17 PEN 1:MODE 1:a$="O.k. Here We Go...":GOSUB 22:LOCATE 13,2:WINDOW #1,14,30,10,10:WINDOW #2,14,30,12,12:CALL &BD37:CALL &BC6B,1:CALL &BE80
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
41 DATA "DYNAMITE DAN - Cheat Mode"
42 DATA "(C) 1989 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For Silverbird's","Dynamite Dan Gives You Infinite Lives."
45 DATA "Please Wait Whilst I Set Up The Cheat"
46 DATA XX
47 DATA "Hello Again, Sorry For The Delay. Please Insert Your Dynamite Dan Tape And Press Play.","When You Are Ready Press Space."
48 DATA XX
49 DATA F3,31,00,C0,CD,37,BD,2A,38,BD,22,C0,BE,21,01,BB,22,38,BD,3E
50 DATA FF,CD,6B,BC,06,00,11,00,04,CD,77,BC,EB,32,AC,BE,E5,CD,83,BC
51 DATA CD,7A,BC,3E,00,CB,4F,28,E7,3E,C3,21,BD,BE,32,0E,BC,22,0F,BC
52 DATA C9,F5,E5,21,00,00,22,38,BD,CD,37,BD,21,D3,BE,22,A3,01,E1,F1
53 DATA C3,0E,BC,21,C7,16,36,00,21,CC,16,36,00,C3,00,02,00,00,00,00
