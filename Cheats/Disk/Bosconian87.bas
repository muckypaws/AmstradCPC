10 'Bosconian '87 cheats
20 'By JASON BROOKS
30 DATA 21,00,04,11,00,40
40 DATA 3E,16,CD,A1,BC,3A
50 DATA 00,04,FE,21,28,EE
60 DATA 3E,C3,21,20,A0,32
70 DATA 27,04,22,28,04,C3
80 DATA 00,04,21,3B,A0,11
90 DATA D1,C7,01,40,00,ED
100 DATA B0,DD,21,00,10,11
110 DATA 00,BB,31,FF,03,21
120 DATA d1,c7,3E,1A,C7
130 DATA af,32,d7,37:'Inf. Men
140 DATA 3e,c9,32,0e,a3:'Bases don't fire missiles
150 DATA 3e,c9,32,3e,a5:'No Formation attacks.
160 DATA c3,37,04,RUN:'Leave
170 i=&A000
180 READ a$:IF a$="RUN" THEN CALL &A000
190 POKE i,VAL("&"+a$):i=i+1:GOTO 180
