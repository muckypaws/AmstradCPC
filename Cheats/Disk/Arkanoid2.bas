10 ' Arkanoid II Cheat - Disk Version
20 ' (C) 1989 First Choice Software
30 MODE 1:BORDER 0:INK 0,0:INK 1,25
40 PRINT "ARKANOID II - Infinite Lives"
50 PRINT"THE REVENGE OF DOH"
60 PRINT"

For The Disk Version"
70 PRINT"(C) 1989 First Choice Software"
80 PRINT"If you wish to use the built in cheat"
90 PRINT"then wait until ARKANOID II has loaded"
100 PRINT"and on the title page hold down the"
110 PRINT"keys R T & F"
120 PRINT"Now during the game pressing ESC"
130 PRINT"Will take you to the next screen !"
140 PRINT"Please Wait Poking Data"
150 MEMORY &9FFF
160 FOR i=&A000 TO &A153
170 READ a$:POKE i,VAL("&"+a$)
180 NEXT
190 PRINT"Thank you,":PRINT"Now insert your ARKANOID II Disk & Press A Key"
200 CALL &BB18
210 CALL &A000
220 MODE 1:PRINT "Sorry A Disk Error Has Occured"
230 PRINT"Insert Side A Of Your Arkanoid II"
240 PRINT"Disk & Hit A Key.":GOTO 200
250 DATA 21,FF,AB,11,40,00,0E,07,CD,CE,BC,21,4E,A1,CD,D4,BC,79,22,4F
260 DATA A1,32,51,A1,21,00,01,11,00,00,0E,41,DF,4F,A1,D0,21,2D,A0,22
270 DATA 11,01,CD,00,01,F3,F3,31,FE,BF,3E,09,ED,4F,21,E1,1C,01,DE,03
280 DATA 16,05,ED,5F,AE,AA,77,57,23,0B,14,79,B0,CA,4F,A0,C3,3E,A0,11
290 DATA F4,1C,21,CB,03,ED,5F,EB,AE,EB,12,2B,13,7D,B4,C2,55,A0,EB,11
300 DATA BC,03,2B,35,1B,7A,FE,FF,C2,66,A0,23,E8,21,03,1D,01,64,00,11
310 DATA 02,1D,ED,B8,21,22,1D,01,9D,03,ED,5F,AE,77,23,0B,78,B1,C2,82
320 DATA A0,C3,90,A0,01,E8,FE,ED,79,3A,00,00,FE,F3,C2,9D,A0,21,3C,1D
330 DATA 11,3B,1D,01,64,00,ED,B8,01,53,03,21,6C,1D,DD,21,50,1D,00,11
340 DATA 1C,00,DD,19,ED,5F,DD,AC,96,DD,AD,77,0B,79,23,B0,C2,CA,A0,C3
350 DATA CD,A0,C3,B8,A0,21,6C,1D,11,6B,1D,01,64,00,ED,B8,01,23,03,21
360 DATA 9C,1D,DD,21,80,1D,00,11,1C,00,DD,19,ED,5F,DD,AC,96,DD,AD,77
370 DATA 0B,79,23,B0,C2,FA,A0,C3,FD,A0,C3,E8,A0,11,15,03,2B,34,1B,7A
380 DATA FE,FF,C2,00,A1,23,EA,00,40,1D,11,A9,1D,01,64,00,ED,B8,21,C6
390 DATA 1D,01,F9,02,ED,5F,AE,77,23,0B,79,B0,C2,1C,A1,21,E3,1D,11,00
400 DATA A8,01,DC,02,ED,B0,21,80,BE,22,E5,A8,21,46,A1,11,80,BE,01,50
410 DATA 00,ED,B0,C3,4D,A8,AF,32,18,33,C3,FD,30,C9,84,00,00,00,00,00
