10 REM   Simple pattern designer
20 REM       by Ian C. Sharpe
30 REM Computing with the Amstrad
40 REM ----------- CPC -----------
50 DEFINT a-z:OPENOUT"dummy":MEMORY HIMEM-1:CLOSEOUT
60 md=-1:WHILE md<0 OR md>2:MODE 1:INPUT"Mode :",md:WEND
70 MODE md:xs=3-md-(md=0):xo=4*xs:nc=2^(xo/4)-1:cp=2:ncp=1:ox=7:x=7:oy=7:y=7:DIM mat(15,15),cols(nc)
80 FOR i=0 TO nc:READ cols(i):INK i,cols(i):PEN i:PRINT CHR$(143):NEXT
90 DATA 13,0,2,6,10,11,12,13,14,15,16,17,18,19,20,21
100 ORIGIN 200,100:PLOT 0,-4:DRAWR 84*xs,0,1:DRAWR 0,160:DRAWR -84*xs,0:DRAWR 0,-160
110 WHILE INKEY(68)<>0
120 IF ncp<>cp THEN LOCATE 2,cp+1:PRINT CHR$(32):PEN 1:LOCATE 2,ncp+1:PRINT"<":cp=ncp
130 PLOT x*xo*1.25,y*10,-(mat(x,y)=0):DRAWR xo,-8:MOVER 0,8:DRAWR -xo,-8:PLOT ox*xo*1.25,oy*10,mat(ox,oy):FOR i=0 TO 4:DRAWR xo,0:MOVER -xo,-2:NEXT
140 IF INKEY(47)=0 THEN mat(x,y)=cp:PLOT x*xs,200+y*2,mat(x,y)
150 ncp=cp+(INKEY(0)=32)-(INKEY(2)=32) AND nc
160 ox=x:oy=y
170 x=ox+(INKEY(8)=0)-(INKEY(1)=0):IF x=0 THEN x=15 ELSE IF x=16 THEN x=1
180 y=oy+(INKEY(2)=0)-(INKEY(0)=0):IF y=0 THEN y=15 ELSE IF y=16 THEN y=1
190 WEND
200 LOCATE 1,25:PRINT"Define block";
210 lx=15:ly=15:PRINT CHR$(23)CHR$(1)
220 WHILE INKEY(68)=0:WEND:olx=200:lx=15:oly=200:ly=15:GOSUB 430
230 WHILE INKEY(68)<>0:olx=lx:oly=ly
240 lx=olx-(INKEY(1)=0)+(INKEY(8)=0):IF lx=0 THEN lx=15 ELSE IF lx=16 THEN lx=1
250 ly=oly-(INKEY(2)=0)+(INKEY(0)=0):IF ly=0 THEN ly=15 ELSE IF ly=16 THEN ly=1
260 GOSUB 430
270 WEND:PRINT CHR$(23)CHR$(0)
280 REM ------ write to file ------
290 FOR j=1 TO ly:FOR i=1 TO lx:pat$=pat$+HEX$(mat(i,16-j)):NEXT:NEXT
300 MODE 2:WHILE INKEY$<>"":WEND
310 INPUT"What do you want to call the string? :",s$:IF LEN(s$)=0 THEN 310
320 INPUT"Line number :",ln$
330 INPUT"Filename :",f$
340 OPENOUT f$
350 line0$=ln$+" "+s$+"="+CHR$(34)
360 IF LEN(line0$)+1+LEN(pat$)<255 THEN line0$=line0$+pat$+CHR$(34):GOTO 390
370 line1$=LEFT$(ln$,LEN(ln$)-1)+"1"+" "+s$+"="+s$+"+"+CHR$(34)+RIGHT$(pat$,100)+CHR$(34)
380 line0$=line0$+LEFT$(pat$,LEN(pat$)-100)+CHR$(34)
390 PRINT#9,line0$:IF line1$<>"" THEN PRINT#9,line1$
400 PRINT#9,LEFT$(ln$,LEN(ln$)-1)+"2 REM width="lx"height="ly
410 CLOSEOUT:END
420 :
430 MOVE (olx+1)*xo*1.25,-4:DRAWR 0,160,1:MOVE (lx+1)*xo*1.25,-4:DRAWR 0,160,1
440 MOVE 0,(15-oly)*10:DRAWR xo*21,0:MOVE 0,(15-ly)*10:DRAWR xo*21,0
450 RETURN
