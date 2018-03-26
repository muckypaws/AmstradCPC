10 ' Mission Genocide
20 MEMORY &85FF:LOAD"!"
30 POKE &8629,&C3:POKE &862A,&80
40 POKE &862B,&BE:i=&BE80
50 READ a$:IF a$="run" THEN CALL &8600
60 POKE i,VAL("&"+a$)
70 i=i+1:GOTO 50
80 DATA cd,a1,bc
90 DATA 3e,ff,32,94,90:' 255 lives
100 DATA af,32,c7,a0:' Inf. men
110 DATA c3,2c,86,run:'leave
