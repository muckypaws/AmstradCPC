10 ' ATV SIMULATOR Cheat Mode
11 '(C) 1989 1st Choice Software : Revised 1/3/1991 - Jason Brooks
12 MEMORY &9FFF:CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 RESTORE 49:FOR i=&9000 TO &90FC:READ a$:POKE i,VAL("&"+a$):NEXT:RESTORE 47:PEN 3:PRINT:GOSUB 19
16 a$=INKEY$:IF a$<>" " THEN 16
17 PEN 1:MODE 1:a$="O.k. Here We Go...":GOSUB 22:FOR i=0 TO 4:INK i,0:NEXT:CALL &BC6B,1:CALL &9000
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
41 DATA "ATV SIMULATOR - Cheat Mode"
42 DATA "(C) 1989 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For Codemasters'","ATV Simulator Allows Both Players To Exceed The Maximum Time Limit."
45 DATA "Please Wait Whilst I Set Up The Cheat"
46 DATA XX
47 DATA "Hello Again, Sorry For The Delay. Please Insert Your ATV SIMULATOR Tape And Press Play.","When You Are Ready Press Space."
48 DATA XX
49 DATA F3,31,F8,BF,01,C0,7F,ED,49,CD,37,BD,3E,FF,CD,6B,BC,11,00,10,06,00,CD
50 DATA 77,BC,D2,00,00,EB,32,36,90,CB,4F,20,03,21,70,01,CD,83,BC,D2,00,00,E5
51 DATA CD,7A,BC,D2,00,00,F3,3E,00,CB,4F,20,23,0E,70,21,94,01,11,80,04,79,AE
52 DATA 77,23,1B,7A,B3,20,F7,21,ED,90,11,80,BE,ED,53,30,02,01,30,00,ED,B0,C3
53 DATA 95,01,21,6C,90,11,00,50,01,00,01,ED,B0,C3,29,50,F3,31,00,C0,CD,37,BD
54 DATA 3E,FF,CD,6B,BC,21,00,60,11,01,60,01,00,4A,36,00,ED,B0,06,00,11,00,10
55 DATA CD,77,BC,EB,CD,83,BC,E5,CD,7A,BC,21,6D,50,11,80,BE,01,00,01,ED,B0,21
56 DATA 4D,50,11,16,BD,01,03,00,ED,B0,21,40,00,11,41,00,01,BF,4F,36,00,ED,B0
57 DATA C9,C3,80,BE,28,FE,29,20,31,39,38,FE,20,FE,73,74,20,FE,68,6F,69,63,65
58 DATA 20,FE,6F,66,74,77,61,72,65,2E,F3,11,00,01,DD,21,B1,A7,CD,40,A7,21,94
59 DATA BE,22,5A,A8,C3,DB,A7,21,66,37,36,C3,C3,00,04,00,00,00,00,00,00,00,00