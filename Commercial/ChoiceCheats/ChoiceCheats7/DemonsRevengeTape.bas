10 ' Demons Revenge Cheat Mode
11 '(C) 1989 1st Choice Software
12 CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 RESTORE 49:FOR i=&BE80 TO &BEDE:READ a$:POKE i,VAL("&"+a$):NEXT:RESTORE 47:PEN 3:PRINT:GOSUB 19
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
41 DATA "DEMONS REVENGE - Cheat Mode"
42 DATA "(C) 1989 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For Firebirds","Demons Revenge Gives You Infinite Health."
45 DATA "Please Wait Whilst I Set Up The Cheat"
46 DATA XX
47 DATA "Hello Again, Sorry For The Delay. Please Insert Your DEMONS REVENGE Cassette And Press Play.","When You Are Ready Press Space."
48 DATA XX
49 DATA F3,01,C0,7F,ED,49,CD,37,BD,3E,FF,CD,6B,BC,11,00,01,43,CD,77,BC,EB,32
50 DATA A1,BE,E5,CD,83,BC,CD,7A,BC,3E,00,CB,4F,E1,28,E7,31,F8,BF,E5,3E,C3,21
51 DATA C3,BE,32,0E,BC,22,0F,BC,2A,38,BD,22,C4,BE,2A,01,BB,22,38,BD,C9,21,00
52 DATA 00,22,38,BD,CD,37,BD,21,D5,BE,22,BE,01,C3,0E,BC,AF,32,F5,6D,32,00,6E
53 DATA C3,62,68
54 ENV 1,12,-1,1:ENV 2,12,1,2:ENV 3,15,1,1:ENV 4,15,-1,1:ENV 5,1,1,1,1,-2,1:ENV 6,1,-1,5:ENV 7,1,-1,1:ENT -1,1,10,1,1,-10,1:ENT -2,15,-8,1:ENT -3,15,8,1:ENT -4,1,20,1,1,-10,1,1,50,1,1,-50,1:ENT -5,=200,10,=0,5,=300,10,=0,5,=400,20:ENT -6,1,5,1
55 LOCATE 12,2:PAPER 3:PEN 2:PRINT" DEMON'S REVENGE "
56 WINDOW#1,15,27,10,10:WINDOW#2,15,27,13,13:RETURN
