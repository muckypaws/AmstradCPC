10 ' Joe Blade II Cheat Mode
11 '(C) 1989 1st Choice Software
12 MEMORY &3FFF:CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 GOSUB 48:MODE 1:RESTORE 46:PEN 3:GOSUB 19
16 a$=INKEY$:IF a$<>" " THEN 16
17 PEN 1:MODE 1:a$="O.k. Here We Go...":GOSUB 22:CALL &BD37:LOAD"!":CALL &BC6B,1:CALL &9000
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
41 DATA "JOE BLADE II - Cheat Mode"
42 DATA "(C) 1989 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For Players Joe Blade 2 Will Give You The Choice Of Stopping The Clock In The Main Game And/Or Stopping The Clock In The 4 Sub Games."
45 DATA XX
46 DATA "Thank You. Please Insert Your","JOE BLADE 2 Cassette And Press Play","Hit Space When You Are Ready."
47 DATA XX
48 GOSUB 100:RESTORE 60
49 FOR i=&9000 TO &9064:READ a$:a=VAL("&"+a$):POKE i,a:NEXT
50 RESTORE 66
51 PAPER 0:PEN 1:MODE 2:BORDER 0:INK 0,0:INK 1,26
52 READ ask$,cheat$:IF ask$="54321" THEN 56
53 GOSUB 70:INPUT y$:y$=UPPER$(y$):y$=LEFT$(y$,1):IF y$="Y" OR y$="O" THEN GOSUB 58
54 IF y$="N" OR y$="Y" OR y$="O"  THEN PRINT:PRINT:GOTO 52
55 PRINT:p$=ask$:ask$="Pardon ?":GOSUB 70:ask$=p$:PRINT:PRINT:GOTO 53
56 GOSUB 58
57 RETURN
58 L=LEN(cheat$):FOR t=1 TO L STEP 2:t$=MID$(cheat$,t,2):p=VAL("&"+t$)
59 POKE i,p:i=i+1:NEXT:RETURN
60 DATA 3E,C3,21,27,90,32,80,BE,22,81,BE,3E,8F,32,7F,41,3E,B3,32,CC
61 DATA 41,3E,F9,32,2C,42,3E,02,32,2B,42,21,05,40,0E,FF,C3,16,BD,21
62 DATA 65,90,11,80,BE,01,A0,00,ED,B0,2A,01,AC,23,22,40,90,7E,FE,1C
63 DATA 20,F7,AF,32,00,00,23,7E,22,58,90,FE,C4,20,F7,23,7E,FE,14,20
64 DATA F1,23,7E,FE,AC,20,EB,21,00,00,36,C3,23,36,80,23,36,BE,C3,00
65 DATA AC
66 DATA "Do You Wish To Stop The Main Clock",AF326A15
67 DATA "Do You Wish To Stop The Clocks In The 4 Sub-Games"
68 DATA AF32192332AD2432B42632D328
69 DATA 54321,C314AC
70 FOR x=1 TO LEN(ask$):PRINT MID$(ask$,x,1);" ";:SOUND 1,ASC(MID$(ask$,x,1))+100,1:SOUND 2,ASC(MID$(ask$,x,1))+200,1:NEXT:PRINT" ";:RETURN
100 i=TIME+450:WHILE i>TIME:WEND
110 PAPER 1:PEN 3:LOCATE 10,24:PRINT "HIT SPACE TO PROCEED"
120 WHILE INKEY$<>" ":WEND
130 RETURN