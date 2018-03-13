10 CLS:|TAPE.IN
20 m%=325
30 FOR n%=0 TO 40:READ d$
40 POKE m%+n%,VAL("&"+d$):NEXT n%
50 PRINT:PRINT"Now go through this sequence-"
60 PRINT"1.Type New [ENTER]"
70 PRINT"2.Type Call 325 [ENTER]"
80 PRINT"3.Type List [enter]"
90 PRINT"4.Type |disc [enter]"
100 PRINT"5.Now save the program on disc"
110 PRINT:PRINT"That's it!"
120 DATA 06,00,21,00,00,11,2b,a0,cd,77
130 DATA bc,30,18,c5,21,70,01,cd,83,bc
140 DATA c1,21,70,01,09,eb,21,83,ae,06
150 DATA 04,73,23,72,23,10,fa,cd,7a,bc
160 DATA c9
