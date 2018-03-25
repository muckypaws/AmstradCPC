10 ' Speed Lock Breaker For Versions 5.5 (A)
20 ' To Transfer New Speedlocks Only To Disk
30 ' By  Jason  - Cracker  - Brooks (C) 1987
40 ' JACESOFT
50 INK 3,6,24:SPEED INK 20,20
60 PAPER 0:PEN 1:MODE 1:BORDER 0:INK 0,0:IF PEEK(&8000)<>205 THEN MEMORY &7FFF:LOAD"speink47",&8000
70 RESTORE:i=&BE80
80 READ a$:IF a$="SPEEDT47" THEN 100
90 POKE i,VAL("&"+a$):i=i+1:GOTO 80
100 INK 2,15:PRINT"***** NEW SPEEDLOCK BREAKER *****"
110 PRINT:PRINT"Written by J.Brooks 1987":LOCATE 1,3:PRINT CHR$(22);"________________________"
120 PRINT"This utility transfers files 47k in length."
130 PRINT"Insert Speedlock tape into cassette player. When rewound press any key."
140 OUT &F600,16
150 CALL &BB18
160 OUT &F600,0
170 LINE INPUT"New filename (Up to 7 Letters) or ENTER For the DEFAULT";filename$
180 IF filename$="" THEN 260
190 IF LEN(filename$)>7 THEN RUN
200 FOR i=1 TO 16:POKE &81CA+i,&20:POKE &BEC2+i,&20:NEXT
210 FOR i=1 TO LEN(filename$):POKE &81CA+i,ASC(MID$(filename$,i,1)):POKE &BEC2+i,ASC(MID$(filename$,i,1))
220 NEXT
230 POKE i+&81CA,&31:POKE i+&BEC2,&31
240 FOR i=1 TO LEN(filename$):POKE &81D2+i,ASC(MID$(filename$,i,1)):POKE &BECA+i,ASC(MID$(filename$,i,1)):NEXT
250 POKE i+&81D2,&32:POKE &BECA+i,&32
260 CLS:|DISC:|USER,0:PRINT"Insert blank disk and press a key":CALL &BB18
270 MODE 2:|TAPE:CLS:PRINT"Strange characters will appear on the screen but Don't Worry."
280 IF filename$="" THEN filename$="SPEEDLCK" 
290 SAVE filename$,b,&BE80,256,&BE80
300 CALL &8000
310 DATA F5,BF,FF,BF,0E,07,21,FF,AB,11,00,A6,CD,CE,BC,21,A5,BE,E5,21
320 DATA C3,BE,06,08,CD,77,BC,EB,CD,83,BC,22,80,BE,C3,7A,BC,21,CB,BE
330 DATA CD,96,BE,F3,21,00,C0,11,00,A6,01,00,13,ED,B0,CD,37,BD,3E,0C
340 DATA CD,5A,BB,2A,80,BE,E9,53,50,45,44,4C,43,4B,31,53,50,45,44,4C
350 DATA 43,4B,32,SPEEDT47
