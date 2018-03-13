10 'Lock Picker Ver. 1.1 (By Justin, Copyright ACU)
20 MODE 1:MEMORY 12345
30 tot=0:ad=&7FF0
40 READ a$:IF a$="end" THEN 80
50 a=VAL("&"+a$)
55 PRINT a$;" ";:CALL &BB18
60 POKE ad,a:tot=tot+a
70 ad=ad+1:GOTO 40
80 READ sum
90 IF tot<>sum THEN PRINT"ZUT! You'd better check all the data.":END
120 DATA f3,21,00,80,11,00,be,01
130 DATA ff,00,ed,b0,c3,35,be,4a
140 DATA 21,0b,b9,36,b9,23,23,23
150 DATA 36,2e,ed,4b,02,bc,06,8a
160 DATA 11,00,b9,c5,1a,d5,11,79
170 DATA 03,91,21,8a,b9,ae,77,23
180 DATA 1d,20,fa,15,20,f7,d1,13
190 DATA c1,4f,05,20,e6,3e,c9,32
200 DATA 82,b9,c3,56,be,21,49,be
210 DATA 3e,c3,32,f4,37,22,f5,37
220 DATA 21,ff,ab,11,40,00,c3,c1
230 DATA 37,21,4b,00,36,45,23,23
240 DATA 23,36,99,f3,f1,c9,dd,21
250 DATA d9,bb,ed,5b,74,be,cd,67
260 DATA bb,dd,21,76,be,dd,6e,00
270 DATA dd,66,01,11,78,be,73,23
280 DATA 72,c3,03,bc
290 '
300 DATA 83,00,5a,bc,af,32,c0,5b
310 DATA 32,31,6b,c3,80,a2,4a
320 DATA end,16306
