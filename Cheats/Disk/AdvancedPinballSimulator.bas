10 'Advanced  Pinball
20 '    Simulator
30 '   By P.Wizard
40 ' From Shropshire
50 '(C) CPC COMPUTING
60 DATA F3,DD,21,00,BF,11
70 DATA 47,00,CD,67,BB,21
80 DATA 2C,BE,22,44,BF,C3
90 DATA 00,BF,21,40,00,E5
100 DATA 21,00,BB,E5,C3,4b
110 DATA 3a,3E,45,32,4B,00
120 DATA 3E,99,32,4E,00,F3
130 DATA F1,C9,AF,32,15,04
140 DATA c3,31,1
150 MEMORY &3800:LOAD"!"
160 POKE &3A76,&C3
170 POKE &3A77,&1F
180 POKE &3A78,&BE
190 FOR i=&BE00 TO &BE32
200 READ a$:a=VAL("&"+a$)
210 s=s+a:POKE i,a:NEXT
220 IF s<>5099 THEN 230
225 CALL &BE14
230 PRINT"Ping Ting Ting"
240 PRINT"Data Error !!!"