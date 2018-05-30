10 ' Fast Food Dizzy Cheat Mode V1.0
11 '(C) 1989 1st Choice Software
12 MEMORY &3FFF:CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 GOSUB 48:MODE 1:RESTORE 46:PEN 3:GOSUB 19
16 a$=INKEY$:IF a$<>" " THEN 16
17 PEN 1:MODE 1:a$="O.k. Here We Go...":GOSUB 22:CALL &BE80
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
41 DATA "FAST FOOD - Cheat Mode"
42 DATA "(C) 1989 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For Codemasters' Fast Food Will Allow you To Choose All 30 Levels And Give You Infinite Lives."
45 DATA XX
46 DATA "Thank You. Please Insert Your","FAST FOOD Cassette And Press Play","Hit Space When You Are Ready."
47 DATA XX
48 GOSUB 64:RESTORE 68
49 FOR i=&BE80 TO &BEC6:READ a$:a=VAL("&"+a$):POKE i,a:NEXT
50 RESTORE 72
51 PAPER 0:PEN 1:MODE 2:BORDER 0:INK 0,0:INK 1,26
52 READ ask$,cheat$:IF ask$="54321" THEN 56
53 GOSUB 60:GOSUB 75:IF y$="Y" OR y$="O" THEN GOSUB 58
54 IF y$="N" OR y$="Y" OR y$="O"  THEN PRINT:GOTO 52
55 PRINT:p$=ask$:ask$="Pardon ?":GOSUB 60:ask$=p$:PRINT:PRINT:GOTO 53
56 GOSUB 58
57 RETURN
58 L=LEN(cheat$):FOR t=1 TO L STEP 2:t$=MID$(cheat$,t,2):p=VAL("&"+t$)
59 POKE i,p:i=i+1:NEXT:RETURN
60 FOR x=1 TO LEN(ask$):PRINT MID$(ask$,x,1);" ";:SOUND 1,ASC(MID$(ask$,x,1))+100,1:SOUND 2,ASC(MID$(ask$,x,1))+200,1:NEXT:PRINT" ";:RETURN
61 L=LEN(cheat$):FOR t=1 TO L STEP 2:t$=MID$(cheat$,t,2):p=VAL("&"+t$)
62 POKE i,p:i=i+1:NEXT:RETURN
63 MODE 2:PRINT "Sorry you have typed a mistake in the data lines":END
64 i=TIME+450:WHILE i>TIME:WEND
65 PAPER 1:PEN 3:LOCATE 10,24:PRINT "HIT SPACE TO PROCEED"
66 WHILE INKEY$<>" ":WEND
67 RETURN
68 DATA F3,31,f8,bf,01,C0,7F,ED,49,CD,37,BD,3E,FF,CD,6B,BC,06,00,11,00,10,CD
69 DATA 77,BC,EB,CD,83,BC,CD,7A,BC,21,37,BD,11,3A,BD,01,03,00,ED,B0,3E,C3,21
70 DATA C3,BE,32,37,BD,22,38,BD,F3,21,FF,AB,11,40,00,01,FF,B0,C3,43,3A,CD,3A
71 DATA BD
72 DATA Do You Wish To Be Able To Select All 30 Levels ?,3E1E329805
73 DATA Do You Require Infinite Lives ?,AF320C57
74 DATA 54321,C34000
75 y$=INKEY$:IF y$="" THEN 75
76 y$=UPPER$(y$):IF y$="Y" THEN PRINT"YES" ELSE IF y$="O" THEN PRINT"OUI" ELSE IF y$="N" THEN PRINT"NO" ELSE PRINT y$
77 RETURN
