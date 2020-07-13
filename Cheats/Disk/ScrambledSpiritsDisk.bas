10 ' Scrambled Spirits Cheat Mode V1.00
11 '(C) 1990 1st Choice Software
12 CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,14:INK 2,1:INK 3,2:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1:MEMORY &7FFF
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 RESTORE 49:FOR i=&8000 TO &8088:READ a$:POKE i,VAL("&"+a$):NEXT:RESTORE 47:PEN 3:PRINT:GOSUB 19
16 a$=INKEY$:IF a$<>" " THEN 16
17 PEN 1:MODE 1:a$="O.k. Here We Go... ":GOSUB 22:CALL &BC6B,1:CALL &8000
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
41 DATA "SCRAMBLED SPIRITS - Cheat Mode"
42 DATA "(C) 1990 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For Grandslam's","Scrambled Spirits Gives You :-"
45 DATA "Infinite Lives For Both Players","Infinite Credits For Both Players","Please Wait Whilst I Set Up The Cheat"
46 DATA XX
47 DATA "Hello Again, Sorry For The Delay. Please Insert Your SCRAMBLED SPIRITS Disk In Drive A:","When You Are Ready Press Space."
48 DATA XX
49 DATA F3,31,F8,BF,01,C0,7F,ED,49,21,FF,AB,11,40,00,0E,07,CD,CE,BC,21,84,80
50 DATA CD,D4,BC,22,85,80,21,00,01,E5,11,00,00,0E,41,DF,85,80,F3,21,3A,80,11
51 DATA 40,00,01,4A,00,ED,53,05,01,ED,B0,C9,AF,32,EA,1B,32,85,1B,32,DD,3B,32
52 DATA 3C,3C,C3,68,06,28,43,29,20,31,39,39,30,20,31,73,74,20,43,68,6F,69,63
53 DATA 65,20,53,6F,66,74,77,61,72,65,20,4C,74,64,2E,20,20,57,72,69,74,74,65
54 DATA 6E,20,42,79,20,54,48,45,20,41,52,47,4F,4E,41,55,54,84,00,00,07,00
