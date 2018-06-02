1 ' Don't Know If This Will Work, But If Your Listing This And You Have A
2 ' Disk Version Of The Game Then UN REM Line 9 And It May Work With Your
3 ' Disk Version.
9 REM POKE &BD37,&C9:'Enable Disk Drive
10 ' Airwolf II Cheat Mode V1.0
11 '(C) 1990 1st Choice Software
12 CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 1
13 PAPER 3:PEN 1
14 RESTORE 40:GOSUB 19:PAPER 0:PEN 2:PRINT:PRINT:GOSUB 19
15 RESTORE 49:FOR i=&BE80 TO &BF09:READ a$:POKE i,VAL("&"+a$):NEXT:RESTORE 47:PEN 3:PRINT:GOSUB 19
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
41 DATA "AIRWOLF II - Cheat Mode"
42 DATA "(C) 1990 1st Choice Software."
43 DATA XX
44 DATA "This Cheat For Elite's/Encore's Airwolf II Gives You :-"
45 DATA "Infinite Lives","Please Wait Whilst I Set Up The Cheat"
46 DATA XX
47 DATA "Hello Again, Sorry For The Delay. Please Insert Your AIRWOLF II Cassette And Press Play.","When You Are Ready Press Space."
48 DATA XX
49 DATA F3,31,F8,BF,01,C0,7F,ED,49,CD,37,BD,06,FF,CD,6B,BC,01,00,00,CD,38,BC
50 DATA DD,21,F3,BE,AF,F5,DD,46,00,48,CD,32,BC,F1,DD,23,3C,FE,10,20,F0,21,E0
51 DATA BE,11,70,01,06,04,CD,D5,BE,21,E4,BE,11,00,C0,06,08,CD,D5,BE,21,EC,BE
52 DATA 11,BC,02,06,07,CD,D5,BE,3E,B7,32,6F,78,CD,50,66,D5,CD,77,BC,E1,CD,83
53 DATA BC,C3,7A,BC,41,49,52,32,41,49,52,32,2E,53,43,52,41,49,52,43,4F,44,45
54 DATA 00,00,00,1A,00,00,06,00,01,02,05,0B,0E,14,0D,0A,00,00,00,00,00,00,00
