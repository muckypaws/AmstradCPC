10 '**** Skycapers for the Amstrad 6128 ****
20 '**** Typed by J.Brooks 31/12/86 finished 01/01/87 ****
30 '**** keys are 3 = Left. 4 = Right ****
40 SPEED KEY 1,1
50 KEY 139,"mode 2:speed key 30,2:pen 3:paper 0:cls:list"+CHR$(13):KEY 138,CHR$(140)
60 IF flag=0 THEN GOSUB 760:flag=1
70 ON BREAK GOSUB 1580
80 GOSUB 1130
90 ll%=0:IF i=1 THEN GOSUB 1380
100 MODE 1
110 Hi%=200
120 screen%=1:doll%=100:poun%=200
130 lives%=3:man%=15:sc%=0
140 jason=0
150 x%=INT(1+29*RND(1)):y%=6:dx%=1:dy%=1
160 GOSUB 1020
170 PEN 3
180 LOCATE man%,23:PRINT top$:PEN 0:LOCATE man%,24:PRINT bottom$
190 GOSUB 260
200 jason$=INKEY$:IF jason$="" THEN FOR t=1 TO 43:NEXT
210 IF jason$="3" AND man%>1 THEN GOSUB 480
220 IF jason$="4" AND man%+1<29 THEN GOSUB 520
230 IF scf%=1 THEN GOSUB 670:scf%=0
240 IF ll%=1 THEN GOSUB 600
250 GOTO 190
260 IF z%<>1 THEN LOCATE x%,y%:PRINT CHR$(32); ELSE z%=0
270 x%=x%+dx%:IF x%=30 OR x%=1 THEN dx%=-dx%:SOUND 1,200,15,5
280 y%=y%+dy%:IF y%=6 THEN SOUND 1,200,15,5:GOSUB 560
290 IF y%<>23 THEN 310
300 IF y%=23 AND x%<>man%+1 AND x%<>man%+2 THEN ll%=1 ELSE dy%=-dy%:SOUND 1,200,15,5
310 FOR t=1 TO screen%: IF y%=cloudy(t) AND x%>=cloudx(t) AND x%<cloudx(t)+3 THEN dy%=-dy%:z%=1:SOUND 1,200,15,5
320 NEXT
330 IF z%=1 THEN GOTO 360
340 LOCATE x%,y%
350 PRINT CHR$(INT(193+4*RND(1)))
360 b=b+1:IF b=3 THEN GOSUB 380:b=0
370 RETURN
380 '**** Move Bailiff ****
390 bailiff=bailiff+1:IF bailiff=30 THEN LOCATE bailiff,6:PRINT CHR$(32);CHR$(32);CHR$(11);CHR$(8);CHR$(32):bailiff=1
400 LOCATE bailiff,6:PRINT bailiff$
410 PEN 3:LOCATE bailiff+2,6:PRINT head$
420 PEN 0
430 poun%=poun%-1:PEN 2:LOCATE 2,3:PRINT"#";poun%:SOUND 2,1,5,15
440 IF poun%<1 THEN 600
450 PEN 0:b=0
460 RETURN
470 '**** Move Stretcher Team ****
480 LOCATE man%,23:PRINT CHR$(32);CHR$(9);CHR$(9);CHR$(32);CHR$(10);CHR$(8);CHR$(32):man%=man%-1
490 LOCATE man%,23:PEN 3:PRINT top$
500 LOCATE man%,24:PEN 0:PRINT bottom$
510 RETURN
520 LOCATE man%,23:PRINT CHR$(32);CHR$(8);CHR$(10);CHR$(32);CHR$(11);CHR$(9);CHR$(9);CHR$(32):man%=man%+1
530 LOCATE man%,23:PEN 3:PRINT top$
540 LOCATE man%,24:PEN 0:PRINT bottom$
550 RETURN
560 '**** Collisions? ****
570 IF x%>=bailiff AND x%<bailiff+3 THEN scf%=1:SOUND 2,16,20,15,1,10
580 dy%=-dy%
590 RETURN
600 '**** Lose A Life ****
610 lives%=lives%-1:IF lives%<1 THEN 1290
620 PEN 2:LOCATE 18,2:PRINT"men";lives%
630 PEN 2:LOCATE 15,12:PRINT"AAARGH !":SOUND 1,1500,15,15,5,5,12
640 FOR t=1 TO 400:NEXT
650 ll%=0:poun%=200:man%=15
660 GOTO 150
670 '**** Score ****
680 sc%=sc%+poun%
690 PEN 3
700 IF sc%\500 > jason THEN GOSUB 1510
710 LOCATE 2,2:PRINT"1UP ";sc%
720 doll%=100:poun%=200
730 PEN 2:LOCATE 2,3:PRINT"#";poun%:LOCATE 30,3:PRINT"$";doll%
740 screen%=screen%+1
750 RETURN
760 '**** Characters ****
770 SYMBOL AFTER 139
780 SYMBOL 193,2,5,10,140,80,36,216,192
790 SYMBOL 194,192,220,32,80,142,144,24,0
800 SYMBOL 195,130,68,36,28,42,75,83,0
810 SYMBOL 196,6,230,24,23,48,72,140,0
820 SYMBOL 140,238,0,187,0,238,0,187,0
830 SYMBOL 197,63,127,127,255,255,127,63,14
840 SYMBOL 198,12,190,191,223,255,255,251,112
850 SYMBOL 199,56,124,126,254,252,248,112
860 SYMBOL 207,0,0,0,0,60,126,126,255
870 SYMBOL 200,62,88,170,95,182,120,60,24
880 SYMBOL 202,60,94,33,221,247,15,126,60
890 SYMBOL 203,126,118,247,251,60,118,102,119
900 SYMBOL 204,0,0,0,255,127,128,0,0
910 SYMBOL 205,126,110,239,223,60,110,102,238
920 SYMBOL 206,0,0,0,255,254,1,0,0
930 SYMBOL 208,62,88,170,95,178,110,56,128
940 SYMBOL 209,252,42,21,255,255,143,4,7
950 '**** Set character strings ****
960 bottom$=CHR$(203)+CHR$(9)+CHR$(9)+CHR$(205)
970 top$=CHR$(200)+CHR$(10)+CHR$(204)+CHR$(206)+CHR$(11)+CHR$(202)
980 cloud$=CHR$(197)+CHR$(198)+CHR$(199)
990 bailiff$=CHR$(32)+CHR$(209)+CHR$(11)+CHR$(8)+CHR$(32)+CHR$(207)
1000 head$=CHR$(208)
1010 RETURN
1020 '**** Set Screen Up ****
1030 BORDER 11:PAPER 1:CLS
1040 a$(1)="    "
1050 a$(2)=""
1060 PEN 2:PAPER 0
1070 FOR t=5 TO 25:LOCATE 32,t:PRINT a$(1);:NEXT
1080 FOR t=5 TO 25 STEP 4:LOCATE 32,t:PRINT a$(2);:NEXT
1090 PLOT 1,340,0:DRAW 636,340,0:DRAW 636,399,0:DRAW 1,399,0:DRAW 1,340,0
1100 PAPER 1:LOCATE 2,2:PEN 3:PRINT"1UP";sc%:LOCATE 30,2:PRINT"HI";hi%:PEN 2:LOCATE 2,3:PRINT"#";poun%:LOCATE 30,3:PRINT"$";doll%:LO
CATE 18,2:PRINT"Men";lives%
1110 PEN 3:FOR t=1 TO screen%:cloudx(t)=INT(1+26*RND(1)):cloudy(t)=INT(8+5*RND(0)):LOCATE cloudx(t),cloudy(t):PRINT cloud$:NEXT
1120 RETURN
1130 '**** Title Screen ****
1140 INK 1,11:INK 2,6:INK 0,0:INK 3,26:MODE 1:PAPER 1:CLS
1150 t$="S Y A E S":b$=" K C P R ":yc=2
1160 CLEAR INPUT
1170 CLEAR INPUT
1180 IF yc=1 THEN yc=2:cy=1 ELSE yc=1:cy=2
1190 PEN 0:LOCATE 4,7:PRINT"The Cast":PEN 2:LOCATE 4,8:PRINT"--- ----"
1200 PEN 3:LOCATE 4,10:PRINT top$:PEN 0:LOCATE 4,11:PRINT bottom$;"   ..... Fred & Bill"
1210 LOCATE 5,13:PRINT bailiff$:PEN 3:LOCATE 7,13:PRINT head$;:PEN 0:PRINT"   ..... Super bailiff"
1220 LOCATE 6,15:PRINT CHR$(196);"    ..... The Debtter"
1230 PEN 3:LOCATE 5,17:PRINT cloud$;:PEN 0:PRINT "   ..... The Cloud"
1240 PEN 2:LOCATE 10,20:PRINT"Press i for instructions":LOCATE 10,22:PRINT"Press any key to play"
1250 PEN 3:LOCATE 16,yc:PRINT t$:PEN 0:LOCATE 16,cy:PRINT b$
1260 c$=INKEY$:IF c$=""THEN 1180
1270 IF c$="i" OR c$="I" THEN i=1
1280 RETURN
1290 '**** Game Over ****
1300 a$="Game Over"
1310 PEN 2:LOCATE 18,2:PRINT"Men";lives%
1320 PEN 0
1330 IF sc%>hi% THEN hi%=sc%
1340 FOR t=1 TO 9:l$=MID$(a$,t,1):LOCATE t+14,12:PRINT l$;:FOR s=1 TO 200:NEXT
1350 NEXT
1360 FOR jason=1 TO 2000:NEXT
1370 GOTO 80
1380 '**** Instructions ****
1390 i=0:REM **** Make sure instructions don't come back unless requested ****
1400 MODE 1:PEN 0:PAPER 1:CLS:LOCATE 14,1:PRINT"Instructions"
1410 LOCATE 14,2:PRINT"------------"
1420 PRINT:PRINT"Once upon a time in the city of London acertain female politician who will      remain unamed, became Prime Ministe
r of jolly old England.
1430 PRINT"Suddenly jolly old England became not sojolly as the # went down against the $.
1440 PRINT"As this happened the people of England  became bankrupt and started commiting   suicide."
1450 PRINT:PRINT"You guide Fred & Bill the tax collectorsleft & right with your joystick  to try to bounce the people up to SUPER BA
ILIFFat the top of the screen."
1460 CLEAR INPUT
1470 PRINT"If you do this you get the tax the      person owes you if you don't before the #  reaches 0 then you lose a life."
1480 PRINT:PRINT:PRINT:PRINT"        press a key to start"
1490 c$=INKEY$:IF c$="" THEN 1490
1500 RETURN
1510 PEN 3:LOCATE 11,3:PRINT"bonus man awarded" 
1520 jason=jason+1
1530 lives%=lives%+1
1540 FOR t=400 TO 0 STEP -5:SOUND 1,t,1,15:NEXT:FOR t=100 TO 400 STEP 5:SOUND 1,t,1,15:NEXT 
1550 LOCATE 11,3:PRINT"                 "
1560 LOCATE 18,2:PEN 2:PRINT "Men";lives%
1570 RETURN
1580 RUN
