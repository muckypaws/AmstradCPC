10 ' Key Getter For Calls To &BB1E Written By J.Brooks '86
20 RESTORE:CLEAR
30 CALL &BBFF:CALL &BC02:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 2
40 t$="DH":PRINT "Are You Entering Numbers In Hex Or Dec ? "
50 a$=UPPER$(INKEY$):IF a$="" THEN 50
60 t=INSTR("DH",a$):IF t=0 THEN 50
70 FOR i=1 TO 80:LOCATE i,1:PRINT"*";:LOCATE 81-i,25:PRINT"*";:NEXT
80 FOR i=2 TO 24:LOCATE 80,i:PRINT"*";:LOCATE 1,26-i:PRINT"*";:NEXT
90 LOCATE 8,6:PRINT"Hardware Colour Decoder Program"
100 LOCATE 45,8:PRINT"Written By Jason Brooks 1986"
110 ' Initialize
120 DIM hardware(40),hardware$(40),ha$(40)
130 template$="ABCDEF0123456789":IF t=1 THEN template$=RIGHT$(template$,10)
140 FOR i=0 TO 26:hardware(i)=255:hardware$(i)="Un-Defined Colour !":NEXT
150 FOR i=0 TO 26:READ a,a$:hardware(a)=i:hardware$(a)=a$:NEXT
160 ' Get Keynumbers & Display Actual Key
170 LOCATE 8,14:PRINT"Enter Hardware Colour Number : "
180 LOCATE 14,18:PRINT"Software Colour Number : "
190 LOCATE 30,20:PRINT"Colour : "
200 ' Get Key Presses
210 x=0:b$=""
220 WHILE x<>2
230 a$=UPPER$(INKEY$):IF a$="" THEN 230 ELSE IF INSTR(template$,a$)=0 THEN 230
240 x=x+1:IF x=1 THEN LOCATE 39,14:PRINT"  "
250 LOCATE 38+x,14:PRINT a$:b$=b$+a$
260 WEND
270 IF t=1 THEN ke=VAL(b$) ELSE ke=VAL("&"+b$)
280 LOCATE 38,18:PRINT SPACE$(20):LOCATE 38,20:PRINT SPACE$(30):LOCATE 38,18
290 IF ke>31 THEN ke=ke XOR &40:IF ke>31 THEN 320
300 IF hardware(ke)=255 THEN PRINT" Un-Defined" ELSE PRINT hardware(ke)
310 LOCATE 39,20:PRINT hardware$(ke)
320 GOTO 200
330 ' Hardware Ink Values & Hardware Ink Names
340 DATA 20,Black,4,Blue,21,Bright Blue,28,Red,24,Magenta,29,Mauve
350 DATA 12,Bright Red,5,Purple,13,Bright Magenta,22,Green,6,Cyan,23,Sky Blue
360 DATA 30,Yellow,0,White,31,Pastel Blue,14,Orange,7,Pink,15,Pastel Magenta
370 DATA 18,Bright Green,2,Sea Green,19,Bright Cyan,26,Lime,25,Pastel Green
380 DATA 27,Pastel Cyan,10,Bright Yellow,3,Pastel Yellow,11,Bright White
