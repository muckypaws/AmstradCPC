5 'Motos Cheat By J.Brooks
10 DATA 06,00,11,00,30,21
20 DATA 00,00,CD,77,BC,EB
30 DATA CD,83,BC,CD,7A,BC
40 DATA 21,00,40,11,00,00
50 DATA 3E,16,CD,A1,BC,21
60 DATA A6,BE,22,44,40,C3
70 DATA 00,40,AF
80 DATA 32,fb,05:'Inf. Men
90 DATA 32,71,0b:'Start With 1 Power & 1 Jump Capsule
100 DATA 32,df,06:'Inf. Power
110 DATA 32,ea,06:'Inf. Jumps
120 DATA c3,00,04:'leave
125 DATA END
130 i=&BE80
140 READ a$:IF a$="END" THEN CALL &BE80
150 POKE i,VAL("&"+a$):i=i+1
160 GOTO 140
