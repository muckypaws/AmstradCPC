10 ' Asterix and The Magic Cauldron
20 ' Pokes by JASON BROOKS
30 MEMORY &9FFF
40 LOAD"!",&A000
50 POKE &A039,&80:POKE &A03A,&BE
60 ' Leave out pokes not required
70 i=&BE80
80 READ a$:IF a$="ASTERIX" THEN CALL &A000
90 POKE i,VAL("&"+a$):i=i+1:GOTO 80
200 ' Pieces of cauldron to collect (07)
210 DATA 3e,07,32,77,25:' Change the 7
220 ' No men ALTER 'FF
230 DATA 3e,FF,32,d1,23
240 ' Inf. Men
250 DATA af,32,11,27
260 ' No. of Hams Alter FF
270 DATA 3e,ff,32,00,24
280 ' Inf. Hams
290 DATA af,32,41,26
300 ' Alter start screen (Change 2D)
310 ' To a number between &01 and &2d
320 DATA 3e,2d,32,e9,23
330 ' Do not remove this line
340 DATA c3,00,0a,ASTERIX
