10 |TAPE:h=HIMEM:CLS:MEMORY 1980:m%=1981
20 DEF FNget(x%)=PEEK(x%)+256*PEEK(x%+1)
30 FOR n%=0 TO 11
40 READ d$:POKE m%+n%,VAL("&"+d$):NEXT
50 PRINT"Prepare cassete, press spacebar to start."
60 k$=INKEY$:IF k$="" THEN 60
70 CALL m%:m%=2000
80 PRINT:PRINT"Program ";
90 FOR n%=0 TO 15:PRINT CHR$(PEEK(m%+n%));:NEXT
100 PRINT:IF PEEK(m%+18)AND 1 THEN PRINT"Protected" ELSE PRINT"Not protected"
110 PRINT"File type ";
120 x%=PEEK(m%+18)AND 14
130 IF x%=0 THEN PRINT"Coded BASIC"
140 IF x%=2 THEN PRINT"Machine code"
150 IF x%=6 THEN PRINT"ASCII characters"
160 IF x%=4 THEN PRINT"Screen image"
170 PRINT:PRINT"Start address is ";FNget(m%+21)
180 PRINT"Length is ";FNget(m%+24)
190 PRINT"Execute address is ";FNget(m%+26)
200 DATA 21,d0,07,11,40,00,3e,2c,cd,a1,bc,c9
210 MEMORY h:|DISC
