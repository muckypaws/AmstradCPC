10 'Gameover Part1 pokes By Jason Brooks
20 DATA 3E,B9,32,0B,B9,3E,2E,32,0E
30 DATA B9,ED,4B,02,BC,06,8A,11,00
40 DATA B9,C5,1A,D5,11,79,03,91,21
50 DATA 8A,B9,AE,77,23,1D,C2,1D,BE
60 DATA 15,C2,1D,BE,D1,13,C1,4F,05
70 DATA C2,13,BE,DD,21,D9,BB,11,02
80 DATA 01,CD,67,BB,21,5B,BE,22,C3
90 DATA BC,C3,03,BC,21,40,00,E5,21
100 DATA 00,B9,E5,C3,C9,37,3E,45,32
110 DATA 4B,00,3E,99,32,4E,00,F3,F1
120 DATA c9,end
130 MODE 1:MEMORY &3000:LOAD"!
140 POKE &37F4,&C3:POKE &37F5,&4E
150 POKE &37F6,&BE:i=&BE00
160 READ a$:IF a$="end" THEN 190
170 POKE i,VAL("&"+a$):i=i+1
180 c=c+VAL("&"+a$):GOTO 160
190 IF c<>9686 THEN PRINT"Data Error":END
200 READ a$:IF a$="go!" THEN CALL &BE43
210 POKE i,VAL("&"+a$):i=i+1:GOTO 200
220 DATA 3e,ff,32,10,06:' 255 lives
230 DATA 3e,ff,32,1a,06:' 255 grenades
240 DATA 3e,c3,32,6f,06:' Infinite men
250 DATA 21,00,00,af,32
260 DATA 2e,08,22,2f,8e:' Infinite Grenades
270 DATA 3e,09,32,0b,06:' Start Room
280 DATA af,32,3f,23: 'Infinite Energy
290 DATA c3,94,8e,go!:' Leave this line
