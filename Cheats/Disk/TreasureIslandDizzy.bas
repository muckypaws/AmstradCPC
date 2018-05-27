10 ' Dizzy II - Treasure Island Dizzy - Cheat Mode
11 '(C) 1989 1st Choice Software
12 MEMORY &3FFF:CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 GOSUB 49:MODE 1:RESTORE 44:PEN 2:GOSUB 19:PRINT:RESTORE 47:PEN 1:GOSUB 19
16 a$=INKEY$:IF a$<>" " THEN 16
17 PEN 1:MODE 1:a$="O.k. Here We Go...":GOSUB 22:CALL &BD37:CALL &BC6B,1:CALL &BE80
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
39 FOR x=1 TO LEN(c$):GOSUB 150:SOUND 1,ASC(MID$(c$,x,1))+10,1:SOUND 2,ASC(MID$(c$,x,1))+50,1:NEXT:PAPER 0:PRINT" ":RETURN
40 ' Place Instruction Data
41 DATA "TREASURE ISLAND DIZZY - Cheat Mode"
42 DATA "(C) 1989 1st Choice Software.",XX
43 DATA "This Cheat For Codemasters' Dizzy 2 Gives You The Choice Of.","Removing The Collision Detection And/Or Speeding Dizzy Up.",XX
44 DATA "Don't Forget The Built In Cheat Mode, When The Game Has Loaded Hold Down The Keys 3A  P  C  SPACE2  And Keep"
45 DATA "Holding Them Until Dizzy Appears On The Screen. Now During The Game Press 3C2 And Use The Keys 3Z  X  K  M2 To Select A New Screen Then Press 3SPACE2 To Continue",XX
47 DATA "Please Insert Your Dizzy 2 Cassette And Press Play.","When You Are Ready Press Space."
48 DATA XX
49 GOSUB 100:RESTORE 62
50 FOR i=&BE80 TO &BEA7:READ a$:a=VAL("&"+a$):POKE i,a:CALL &BD19:NEXT
51 RESTORE 70
52 PAPER 0:PEN 1:MODE 2:BORDER 0:INK 0,0:INK 1,26
53 READ ask$,cheat$:IF ask$="54321" THEN 57
54 GOSUB 61:INPUT y$:y$=UPPER$(y$):y$=LEFT$(y$,1):IF y$="Y" OR y$="O" THEN GOSUB 59
55 IF y$="N" OR y$="Y" OR y$="O"  THEN PRINT:PRINT:GOTO 53
56 PRINT:p$=ask$:ask$="Pardon ?":GOSUB 61:ask$=p$:PRINT:PRINT:GOTO 54
57 GOSUB 59
58 RETURN
59 L=LEN(cheat$):FOR t=1 TO L STEP 2:t$=MID$(cheat$,t,2):p=VAL("&"+t$)
60 POKE i,p:i=i+1:NEXT:RETURN
61 FOR x=1 TO LEN(ask$):PRINT MID$(ask$,x,1);" ";:SOUND 1,ASC(MID$(ask$,x,1))+100,1:SOUND 2,ASC(MID$(ask$,x,1))+200,1:NEXT:PRINT" ";:RETURN
62 DATA F3,01,C0,7F,ED
63 DATA 49,31,00,C0,CD
64 DATA 37,BD,3E,FF,CD
65 DATA 6B,BC,11,00,10
66 DATA 06,00,CD,77,BC
67 DATA EB,CD,83,BC,E5
68 DATA CD,7A,BC,21,A8
69 DATA BE,22,C0,AF,C9
70 DATA "Remove Collision Detection ",3EC9325E10
71 DATA "Speed Dizzy Up",3E02320E8E
72 DATA 54321,C34000
100 i=TIME+450:WHILE i>TIME:WEND
110 PAPER 1:PEN 3:LOCATE 10,24:PRINT "HIT SPACE TO PROCEED"
120 WHILE INKEY$<>" ":WEND 
130 RETURN
150 Z$=MID$(c$,x,1)
160 IF Z$="" THEN PRINT Z$; ELSE PRINT Z$;CHR$(24);" ";CHR$(24);CHR$(8);
170 RETURN
