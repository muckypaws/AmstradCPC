10 FOR i=&B460 TO &B48B
20 READ a$:POKE i,VAL("&"+a$):NEXT
30 MODE 1:PRINT"Freeze installed"
50 DATA 21,91,b4,06,81,11,7d,b4,c3,ef,bc,21
60 DATA 8b,b4,11,05,00,01,05,00,c3,e9,bc,21
70 DATA 8b,b4,c3,ec,bc,3e,44,cd,1e,bb,c8,3e
80 DATA 46,cd,1e,bb,28,f9,c9,00
