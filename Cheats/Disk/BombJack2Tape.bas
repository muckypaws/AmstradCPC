1 ' Don't Know If This Will Work, But If Your Listing This And You Have A
2 ' Disk Version Of The Game Then UN REM Line 9 And It May Work With Your
3 ' Disk Version.
9 REM POKE &BD37,&C9:'Enable Disk Drive
10 ' Airwolf II Cheat Mode V1.0
11 '(C) 1990 1st Choice Software
12 CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 RESTORE 49:FOR i=&BE80 TO &BF00:READ a$:POKE i,VAL("&"+a$):NEXT:RESTORE 47:PEN 3:PRINT:GOSUB 19
16 a$=INKEY$:IF a$<>" " THEN 16
17 PEN 1:MODE 0:a$="O.k. Here We Go...":GOSUB 22:CALL &BD37:CALL &BE80
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
41 DATA "BOMB JACK II - Cheat Mode"
42 DATA "(C) 1990 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For Elite's/Encore's","Bomb Jack II Gives You :-"
45 DATA "Infinite Lives","Please Wait Whilst I Set Up The Cheat"
46 DATA XX
47 DATA "Hello Again, Sorry For The Delay. Please Insert Your BOMBJACK II Cassette And Press Play.","When You Are Ready Press Space."
48 DATA XX
49 DATA F3,31,F8,BF,01,C0,7F,ED,49,CD,37,BD,3E,FF,CD,6B,BC,AF,CD,0E,BC,01,00
50 DATA 00,CD,38,BC,DD,21,EE,BE,AF,DD,46,00,48,DD,23,F5,CD,32,BC,F1,3C,FE,10
51 DATA 20,F0,21,D6,BE,11,00,C0,CD,C9,BE,21,E2,BE,11,5C,17,CD,C9,BE,AF,32,EA
52 DATA 18,C3,70,17,D5,06,0C,CD,77,BC,E1,CD,83,BC,C3,7A,BC,42,32,53,43,52,45
53 DATA 45,4E,2E,42,49,4E,42,32,43,4F,44,45,20,20,2E,42,49,4E,00,1A,01,08,0B
54 DATA 0A,0E,05,14,0F,15,19,06,03,0C,18,00,00,00
