10 ' Cybernoid Cheat Mode
11 '(C) 1989 1st Choice Software
12 MEMORY &3FFF:CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 GOSUB 48:MODE 1:RESTORE 46:PEN 3:GOSUB 19
16 a$=INKEY$:IF a$<>" " THEN 16
17 PEN 1:MODE 1:a$="O.k. Here We Go...":GOSUB 22:CALL &BD37:LOAD"!loader",&4000:CALL &8017:INK 1,24:INK 3,26:INK 2,20:MODE 1:PRINT"Loading...":CALL &4000
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
41 DATA "CYBERNOID - Cheat Mode"
42 DATA "(C) 1989 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For Hewson's Cybernoid. Will Give You The Choice Of","Infinite Lives,","Infinite Weapons,","Removing Collision Detection,","Removing The Aliens,","Stopping Rockets Shooting At You,","Removing Aliens In The Shafts And "
45 DATA "Stopping Hornets Nests Shooting At You.",XX
46 DATA "Thank You. Please Insert Your","CYBERNOID Cassette And Press Play","Hit Space When You Are Ready."
47 DATA XX
48 GOSUB 100:RESTORE 64
49 FOR i=&8000 TO &802D:READ a$:a=VAL("&"+a$):POKE i,a:CALL &BD19:NEXT
50 RESTORE 67
51 PAPER 0:PEN 1:MODE 2:BORDER 0:INK 0,0:INK 1,26
52 READ ask$,cheat$:IF ask$="54321" THEN 56
53 GOSUB 60:INPUT y$:y$=UPPER$(y$):y$=LEFT$(y$,1):IF y$="Y" OR y$="O" THEN GOSUB 58
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
64 DATA F3,00,00,00,CD,37,BD,06,00,11,00,90,CD,77,BC,EB,CD,83,BC,00
65 DATA CD,7A,BC,21,40,00,22,53,41,21,2E,80,11,40,00,01,00,01,ED,B0
66 DATA 3E,C9,32,F4,BD,C9
67 DATA Infinite Lives,AF32AE2B
68 DATA Infinite Weapons,AF320D1A
69 DATA Remove Collision Detection,3EC9323A2B
70 DATA Remove Aliens,3EC9321135
71 DATA Stop Rockets Shooting At You,3EC9324D34
72 DATA Stop Aliens In The Shaft,3EC9329F2C
73 DATA Stop Hornets Nests Shooting At You,3EC9329B29
74 DATA 54321,C30002
100 i=TIME+450:WHILE i>TIME:WEND
110 PAPER 1:PEN 3:LOCATE 10,24:PRINT "HIT SPACE TO PROCEED" 
120 WHILE INKEY$<>" ":WEND 
130 RETURN
