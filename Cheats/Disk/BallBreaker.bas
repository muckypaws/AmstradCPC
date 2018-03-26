10 ' Ball Breaker Pokes by J.Brooks
20 MEMORY 29999:LOAD"!a",30000
30 POKE &75C6,&80:POKE &75C7,&BE
40 i=&BE80:' Leave out pokes not needed
50 READ a$:IF a$="GO!" THEN CALL 30000
60 POKE i,VAL("&"+a$):i=i+1:GOTO 50
70 DATA 3e,FF,32,1d,28
80 ' 255 missiles
90 DATA 3e,FF,32,22,28
100 ' 255 bats
110 DATA af,32,1e,29,32,d8,28
120 ' Infinite men
130 DATA af,32,bd,1e
140 ' Infinite missiles
150 DATA c3,40,00,GO!:' leave this LINE
