10 '*****************************
20 '**        TREACHERY        **
30 '*****************************
40 '**  Typed in by J.Brooks   **
50 '**  From Computer & Video  **
60 '**          Games          **
70 '*****************************
80 CLEAR
90 MODE 1
100 WINDOW#1,11,37,5,22:PAPER#1,0
110 ON ERROR GOTO 7750
120 GOTO 3420
130 '*************************
140 '** Print Message Sheet **
150 '*************************
160 CLS#1
170 PLOT 158,336,2:DRAWR 438,0:DRAWR 0,-294:DRAWR -438,0:DRAWR 0,294
180 PEN 1
190 RETURN
200 '************************
210 '** Start Of Turn Page **
220 '************************
230 CLS:CLS#1:x=3:y=2:GOSUB 2940
240 PLOT 1,1,1:DRAW 1,399:DRAW 639,399:DRAW 639,1:DRAW 1,1
250 GOSUB 160
260 FOR k=1 TO 3
270 LOCATE#1,4,1+k:PRINT #1,t$(k)
280 NEXT
290 LOCATE#1,5,5:PRINT#1,p$(p,1)
300 LOCATE#1,2,7:PRINT #1,"OPERATIONAL FILE"
310 LOCATE#1,2,9:PRINT#1,"REF:  ";P$(p,2)
320 LOCATE#1,2,11:PRINT#1,"Heidelberg Schweinstein"
330 LOCATE#1,2,13:PRINT#1,"GRADE 1 ACCESS ONLY"
340 LOCATE#1,2,15:PRINT#1,"Enter Clearance Code"
350 LOCATE#1,2,17:PRINT#1,STRING$(6,210)
360 SOUND 7,200,25,5
370 c$="":FOR k=1 TO 6
380 k$=INKEY$:IF k$="" THEN 380
390 IF k$<"a" OR k$>"z" THEN 380
400 k$=CHR$(ASC(k$)-32):c$=c$+k$
410 LOCATE#1,1+k,17:PRINT#1,k$
420 IF INKEY$<>"" THEN 420
430 NEXT:IF day=3 THEN g$(p)=c$
440 IF c$<>g$(p) THEN LOCATE#1,9,17:PRINT#1,"IS INCORRECT":SOUND 7,1000,25,5,0,0,7:FOR k=1 TO 1000:NEXT:LOCATE#1,9,17:PRINT#1,"     
       ":GOTO 350
450 RETURN
460 '*****************
470 '** End of Page **
480 '*****************
490 LOCATE#1,2,17:PRINT#1,CHR$(24);" KEY COPY or RETURN ";CHR$(24)
500 SOUND 7,200,25,2
510 IF INKEY(18)<>-1 THEN 550
520 IF INKEY(9)<>-1 THEN 540
530 GOTO 510
540 LOCATE#1,2,17:PRINT#1,"                   ":GOSUB 7620
550 RETURN
560 GOSUB 160
570 LOCATE#1,2,2:PRINT #1,p$(p,1);" day";day
580 LOCATE #1,2,3:PRINT #1,"INCOMING REPORT"
590 LOCATE#1,2,5:PRINT#1,"PRESS ANY KEY FOR YOUR AGENT"
600 K$=INKEY$:IF k$="" THEN 600
610 IF k$=" " THEN RETURN
620 IF k$>="a" AND k$<="z" THEN ag=ASC(k$)-96:GOTO 650
630 IF k$>="0" AND k$<="9" THEN ag=ASC(k$)-21:GOTO 650
640 GOTO 600
650 IF ASC(n$(ag,4))=0 THEN 610
660 orank=ASC(n$(ag,p+1))
670 erank=ASC(n$(ag,4-p))
680 IF orank>erank AND ASC(MID$(f$(1,ag),5,1))>0 THEN 720
690 LOCATE#1,2,7:PRINT#1,CHR$(24);" NO REPORT IS AVAILABLE ";CHR$(24)
700 FOR k=1 TO 500:NEXT
710 GOTO 560
720 IF ASC(MID$(f$(1,ag),2,1))=0 THEN 780
730 m1=ASC(MID$(f$(1,ag),2,1))
740 m5=ASC(MID$(f$(1,ag),3,1)) 
750 m6=ASC(MID$(f$(1,ag),4,1))
760 f$(1,ag)=LEFT$(f$(1,ag),1)+CHR$(0)+MID$(f$(1,ag),3)
770 GOTO 820
780 m1=17:IF ASC(LEFT$(f$(1,ag),1)>1 THEN m1=16
790 m5=ASC(MID$(f$(1,ag),6))
800 m6=0
810 f$(1,ag)=LEFT$(f$(1,ag),5)+MID$(f$(1,ag),7,8)+RIGHT$(f$(1,ag),1)
820 m2=ag
830 m3=p
840 m4=day-1
850 f$(1,ag)=LEFT$(f$(1,ag),4)+CHR$(ASC(MID$(f$(1,ag),5,1))-1)+MID$(f$(1,ag),6
860 m$=CHR$(m1)+CHR$(m2)+CHR$(m3)+CHR$(m4)+CHR$(m5)+CHR$(m6)
870 from=ASC(n$(ag,1))
880 type=1:IF p=2 THEN de=25 ELSE de=18
890 LOCATE #1,2,5:PRINT#1,"                         "
900 loacte#1,2,5:PRINT#1,x$(ag);" TO ";MID$(p$(p,1),5):GOSUB 2360
910 IF k$="X" THEN 560
920 me=stack-1:md=3
930 GOSUB 160
940 LOCATE#1,2,2:PRINT#1,p$(p,1);" DAY";day
950 loacte#1,2,3:PRINT#1,"INCOMING REPORT"
960 IF e=1 THEN LOCATE#1,2,5:PRINT#1,"REPORT HAS BEEN SENT BUT":LOCATE#1,2,6:PRINT#1,"IT HAS NOT BEEN RECIEVED":GOTO 490
970 y=4:GOSUB 1030
980 '********************
990 '** DECODE MESSAGE **
1000 GOTO 490
1010 '********************
1020 M1=ASC(LEFT$(S$(MD,ME),1))
1030 M2=ASC(MID$(S$(MD,ME),2,1))
1040 M3=ASC(MID$(S$(MD,ME),3,1))
1050 M4=ASC(MID$(S$(MD,ME),4,1))
1060 M5=ASC(MID$(S$(MD,ME),5,1)) 
1070 M6=ASC(MID$(S$(MD,ME),6,1))
1080 LOCATE#1,2,y:PEN#1,3:PRINT#1,STRING$(25,255):PEN#1,1:y=y+1
1090 IF m1<10 THEN LOCATE#1,2,y:PRINT#1,MID$(p$(m3,1),5);" TO ";x$(m2)
1100 IF m1>9 THEN LOCATE#1,2,y:PRINT#1,x$(m2);" TO ";MID$(p$(m3,1),5)
1110 y=y+1
1120 ON m1 GOSUB 1170,1180,1190,1200,1220,1230,1250,1260,1270,1280,1300,1320
1130 IF m1>12 THEN ON(m1-12) GOSUB 1340,1360,1380,1390,1420
1140 y=y+1
1150 LOCATE#1,2,y:PEN#1,3:PRINT#1,STRING$(25,255):PEN#1,1
1160 RETURN
1170 LOCATE#1,2,y:PRINT#1,"Go To ";w$(m5):RETURN
1180 LOCATE#1,2,y:PRINT#1,"Kill ";x$(m5):RETURN
1190 LOCATE#1,2,y:PRINT#1,"Search ";w$(m5):RETURN
1200 LOCATE#1,2,y:PRINT#1,"Steal ";r$(m5):y=y+1
1210 LOCATE#1,2,y:PRINT#1,"From Agent ";x$(m6):RETURN
1220 LOCATE#1,2,y:PRINT#1,"Hide ";r$(m5):RETURN
1230 LOCATE#1,2,y:PRINT#1,"Transfer ";r$(m5):Y=Y+1
1240 LOCATE#1,2,y:PRINT#1,"To agent ";x$(m5):RETURN
1250 LOCATE#1,2,y:PRINT#1,"Change status to ";q$(m5):RETURN
1260 LOCATE#1,2,y:PRINT#1,"Switch HOMING-BEACON ";o$(m5):RETURN
1270 LOCATE#1,2,y:PRINT#1,"Explode MIND-BOMB":RETURN
1280 LOCATE#1,2,y:PRINT#1," captured":y=y+1
1290 LOCATE#1,2,y:PRINT#1,"in ";w$(m6):RETURN
1300 LOCATE#1,2,y:PRINT#1,r$(m5);" located":y=y+1
1310 LOCATE#1,2,y:PRINT#1,"in ";w$(m6):RETURN
1320 LOCATE#1,2,y:PRINT#1,"SCHWEINSTEIN was seen on":y=y+1
1330 LOCATE#1,2,y:PRINT#1,"DAY";m5;"in ";w$(m6):RETURN
1340 LOCATE#1,2,y:PRINT#1,"I have got ";r$(m5):y=y+1
1350 LOCATE#1,2,y:PRINT#1,"From ";x$(m6):RETURN
1360 LOCATE#1,2,y:PRINT#1,"I have not got":y=y+1
1370 LOCATE#1,2,y:PRINT#1,r$(m5):RETURN
1380 LOCATE#1,2,y:PRINT#1,"Goods have been stolen":RETURN
1390 LOCATE#1,2,y:PRINT#1,"Message stopped on DAY";m4:y=y+1
1400 IF md=1 THEN LOCATE#1,2,y:PRINT#1,"Contents not available":RETURN
1410 me=m5:md=md-1:GOSUB 1020:RETURN
1420 LOCATE#1,2,y:PRINT#1,"Message passed on DAY";m4:y=y+1
1430 IF md=1 THEN LOCATE#1,2,y:PRINT#1,"Contents not available":RETURN
1440 me=m5:md=md-1:GOSUB 1020:RETURN
1450 '*****************
1460 '** Give Orders **
1470 '*****************
1480 i$="":m6=0:GOSUB 160:LOCATE#1,2,2:PRINT#1,p$(p,1);" DAY";day
1490 LOCATE#1,2,4:PRINT#1,"OUTGOING ORDER'S"
1500 LOCATE#1,2,6:PRINT#1,"PRESS ANY KEY FOR YOUR     AGENT"
1510 k$=INKEY$:IF k$="" THEN 1510
1520 IF k$=" " THEN RETURN
1530 IF k$>="a" AND k$<="z" THEN m2=ASC(k$)-96:GOTO 1560
1540 IF k$>="0" AND k$<="9" THEN m2=ASC(k$)-21:GOTO 1560
1550 GOTO 1510
1560 IF ASC(n$(m2,4))=0 THEN 1510
1570 CLS#1: LOCATE#1,2,7:PRINT#1,MID$(p$(p,1),5);" TO ";x$(m2)
1580 LOCATE#1,2,8:PRINT#1," KEY 1  Goto city"
1590 LOCATE#1,2,9:PRINT#1," KEY 2  Kill agent"
1600 LOCATE#1,2,10:PRINT#1," KEY 3  Search city"
1610 LOCATE#1,2,11:PRINT#1," KEY 4  Steal object"
1620 LOCATE#1,2,12:PRINT#1," KEY 5  Hide object"
1630 LOCATE#1,2,13:PRINT#1," KEY 6  Transfer object"
1640 LOCATE#1,2,14:PRINT#1," KEY 7  Change status"
1650 LOCATE#1,2,15:PRINT#1," KEY 8  Switch BEACON"
1660 LOCATE#1,2,16:PRINT#1," KEY 9  Explode MIND-BOMB"
1670 k$=INKEY$:IF k$="" THEN 1670
1680 IF k$<"1" OR k$>"9" THEN 1670
1685 CLS#1
1690 m1=VAL(k$)
1700 FOR k=2 TO 9
1710 LOCATE#1,2,7+k:PRINT#1,"               "
1720 NEXT
1725 CLS#1
1730 LOCATE#1,2,8:PRINT#1,"                         ":LOCATE#1,2,8
1740 ON VAL(k$) GOSUB 1840,1850,1860,1870,1880,1890,1900,1910,1920
1750 m3=p:m4=day
1760 m$=CHR$(m1)+CHR$(m2)+CHR$(m3)+CHR$(m4)+CHR$(m5)+CHR$(m6)
1770 IF p=2 THEN from=25 ELSE from=18
1780 type=0:de=ASC(n$(m2,1)):GOSUB 2360
1790 IF k$="x" THEN GOTO 1480
1800 RETURN
1810 '*************************
1820 '** Parameter Selection **
1830 '*************************
1840 PRINT#1,"Go to ...":GOTO 1930
1850 PRINT#1,"Kill ...":GOSUB 2020:m5=ag:LOCATE#1,7,8:PRINT#1,x$(m5):RETURN
1860 m5=ASC(n$(m2,1)):PRINT#1,"Search ";w$(m5):RETURN
1870 PRINT#1,"Steal ...":GOSUB 2110:LOCATE#1,8,8:PRINT#1,r$(m5):LOCATE#1,2,9:PRINT#1,"from agent ...":GOSUB 2020:m6=ag:LOCATE#1,13,9
:PRINT#1,x$(m6):RETURN
1880 PRINT#1,"Hide ...":GOSUB 2110:LOCATE#1,7,8:PRINT#1,r$(m5):RETURN
1890 PRINT#1,"Transfer ...":GOSUB 2110:LOCATE#1,11,8:PRINT#1,r$(m5):LOCATE#1,2,9:PRINT#1,"to agent ...":GOSUB 2020:m6=ag:LOCATE#1,11
,9:PRINT#1,x$(m6):RETURN
1900 PRINT#1,"Change status to ...":GOSUB 2200:LOCATE#1,19,8:PRINT#1,q$(m5):RETURN
1910 PRINT#1,"Switch HOMING-BEACON ...":GOSUB 2270:LOCATE#1,23,8:PRINT#1,O$(M5):RETURN
1920 PRINT#1,"Exploded MIND-BOMB":RETURN
1930 l=8:m5=ASC(n$(m2,1)):FOR k=1 TO 8
1940 k$=MID$(y$(m5),k,1):IF k$=" " THEN l=k-1:k=8:GOTO 1960
1950 LOCATE#1,2,10+k:PRINT#1,"KEY";k;w$(ASC(k$)-64)
1960 NEXT
1970 k$=INKEY$:IF k$="" THEN 1970
1980 IF k$<"1" OR k$>RIGHT$(STR$(l),1) THEN 1970
1990 GOSUB 2320
2000 m5=ASC(MID$(y$(m5),VAL(k$),1))-64:LOCATE#1,8,8:PRINT#1,w$(m5):RETURN
2010 '** Key in Agent **
2020 LOCATE#1,2,11:PRINT#1,"PRESS KEY FOR AGENT"
2030 k$=INKEY$:IF k$="" THEN 2030
2040 IF k$>="a" AND k$<="z" THEN ag=ASC(k$)-96:GOTO 2070
2050 IF k$>="0" AND k$<="9" THEN ag=ASC(k$)-21:GOTO 2070
2060 GOTO 2030
2070 IF ASC(n$(ag,4))=0 THEN 2030
2080 l=1:GOSUB 2320
2090 RETURN
2100 '** Key in Object **
2110 FOR k=1 TO 3
2120 LOCATE#1,2,10+k:PRINT#1,"KEY";k;r$(k)
2130 NEXT
2140 k$=INKEY$:IF k$="" THEN 2140
2150 IF k$<"0" OR k$>"3" THEN 2140
2160 m5=VAL(k$)
2170 l=3:GOSUB 2320
2180 RETURN
2190 '** Key in Status **
2200 FOR k=1 TO 3
2210 LOCATE#1,2,10+k:PRINT#1,"KEY";k;q$(k)
2220 NEXT
2230 k$=INKEY$:IF k$="" THEN 2230
2240 IF k$<"1" OR k$>"3" THEN 2230
2250 GOTO 2160
2260 '** Key in ON/OFF **
2270 LOCATE#1,2,11:PRINT#1,"KEY 1 ON":LOCATE #1,2,12:PRINT#1,"KEY 2 OFF"
2280 k$=INKEY$:IF k$="" THEN 2280
2290 IF k$<"1" OR k$>"2" THEN 2280
2300 m5=VAL(k$)
2310 l=2
2320 FOR k=1 TO 1+1:LOCATE#1,2,9+k:PRINT#1,"                         ":NEXT:RETURN
2330 '**********************
2340 '** Message Routing ***
2350 '**********************
2360 LOCATE#1,2,10:PRINT#1,"Choose route for message"
2370 LOCATE#1,2,11:PRINT#1,"by pressing agent keys"
2374 LOCATE#1,2,12:PRINT#1,"                     "
2380 LOCATE#1,2,13:PRINT#1,"Destination of message"
2390 LOCATE#1,2,14:PRINT#1,"will end route entry"
2394 LOCATE#1,2,15:PRINT#1,"                     "
2400 LOCATE#1,2,16:PRINT#1,"SPACE will cancel."
2410 LOCATE#1,2,17:PRINT#1,"Longest route = 8 agents"
2420 k$=INKEY$:IF k$="" THEN 2420
2430 IF (k$<"0" OR k$>"9") AND(k$<"a" OR k$>"z") AND k$<>" " THEN 2420
2440 IF k$=" " THEN k$="X":RETURN
2450 l=8:GOSUB 2320
2460 a$="":n=0:GOTO 2480
2470 k$=INKEY$:IF k$="" THEN 2470
2480 IF k$=" " THEN l=8:GOSUB 2320:GOTO 2360
2490 IF k$>="0" AND k$<="9" THEN k=ASC(k$)-21:GOTO 2520
2500 IF k$>="a" AND k$<="z" THEN k=ASC(k$)-96:GOTO 2520
2510 GOTO 2470
2520 IF ASC(n$(k,4))=0 THEN 2470
2530 c=ASC(n$(k,1)):LOCATE#1,2,10+n:PRINT#1,x$(k);" ";w$(c)
2540 n=n+1:a$=a$+CHR$(k):IF c=de AND (type=1 OR k=m2)THEN 2580
2550 IF n=8 THEN LOCATE#1,2,9:PRINT#1,CHR$(24);" THIS ROUTE IS TOO LONG ";CHR$(24):FOR k=1 TO 500:NEXT:l=8:GOSUB 2320:LOCATE#1,2,9:P
RINT#1,"                         ":GOTO 2360
2560 IF INKEY$<>"" THEN 2560
2570 GOTO 2470
2580 l=8:GOSUB 2320:LOCATE#1,2,10:PRINT#1,"MESSAGE TO BE SENT VIA":FOR k=0 TO 2:LOCATE#1,2,12+k
2590 FOR j=1 TO 3
2600 IF k*3+j>n THEN 2630
2610 ag=ASC(MID$(a$,k*3+j,1))
2620 PRINT#1,x$(ag);"  ";
2630 NEXT:NEXT
2640 SOUND 7,200,25,5
2650 LOCATE#1,2,17:PRINT#1,CHR$(24);" KEY CLEAR, COPY OR ENTER ";CHR$(24)
2660 IF INKEY(9)<>-1 THEN GOSUB 7620:GOTO 2700
2670 IF INKEY(18)<>-1 THEN 2700
2680 IF INKEY(47)<>-1 THEN RETURN
2690 GOTO 2660
2700 LOCATE#1,2,17:PRINT#1,"THE MESSAGE IS BEING SENT"
2710 s$(3,stack)=m$
2720 '**************************
2730 '** Message Interception **
2740 '**************************
2750 e=0:a$=i$+a$:n=LEN(a$):FOR k=1 TO n
2760 ag=ASC(MID$(a$,k,1)):tt=ASC(n$(ag,1))
2770 IF e=1 OR VAL(MID$(z$(from),tt,1))>1 THEN e=1:GOTO 2840
2780 orank=ASC(n$(ag,p+1)):erank=ASC(n$(ag,4-p))
2790 IF orank>=erank THEN 2840
2800 im=ASC(MID$(f$(2,ag),5,1)):IF im>0 AND ASC(MID$(f$(2,ag),im+5,1))=stack THEN 2840
2810 im=im+1:f$(2,ag)=LEFT$(f$(2,ag),4)+CHR$(im)+MID$(f$(2,ag),6)
2820 f$(2,ag)=LEFT$(f$(2,ag),im+4)+CHR$(stack)+MID$(f$(2,ag),im+6)
2830 IF ASC(n$(ag,4))<>1 THEN e=1:IF k=n AND ASC(LEFT$(m$,1))<10 AND ASC(n$(ag,4))=2 THEN e=0
2840 from=tt
2850 NEXT
2860 IF ASC(LEFT$(m$,1))>9 OR e=1 THEN 2900
2870 IF orank=0 THEN 2900
2880 IF oran<erank AND ASC(n$(ag,5))<>0 THEN 2900
2890 n$(ag,5)=CHR$(stack)
2900 stack=stack+1:RETURN
2910 '***************
2920 '** Draw Flag **
2930 '***************
2940 IF p=2 THEN PEN 3
2950 FOR k=1 TO 14
2960 LOCATE x,y+k-1:PRINT u$(p,k)
2970 NEXT
2980 PEN 1:RETURN
2990 '*****************
3000 '** Player Tune **
3010 '*****************
3020 '*****************
3030 '*****************
3040 '*****************
3050 '**  UDG Data   **
3060 '*****************
3070 DATA 255,255,253,248,241,225,246,255
3080 DATA 255,255,239,199,152,63,127,255
3090 DATA 255,255,239,247,251,251,251,123
3100 DATA 187,211,231,199,27,253,255,255
3110 '**********************
3120 '** Various Strings ***
3130 '**********************
3140 DATA MI6 LONDON CENTRAL
3150 DATA KGB MOSCOW CENTRAL
3160 DATA  SCHW.315b/QZ  
3170 DATA LIQ/ROBOTNIK/S-20
3180 DATA ON,OFF
3190 DATA ASLEEP,AWAKE,ACTIVE
3200 DATA SCWEINSTEIN,FIRING BOTTON,HOMING BEACON
3210 DATA 4,3,3,4,3,2,3,2
3220 DATA 2,3,2,3,2,1,2,1
3230 DATA 2,1,2,1,1,2,1,2
3240 DATA 1,2,1,2,1,0,1,0
3250 DATA 1,0,1,0,1,0,1,0
3260 DATA 1,0,1,0,0,1,0,1
3270 DATA 0,1,0,1,0,1,0,1
3280 DATA 0,1,0,1,0,0,0,0
3290 DATA 0,0,0,0,0,0,0,0
3300 '*********************
3310 '** Cities & Agents **
3320 '*********************
3330 DATA AMSTERDAM,ALPHA,BELGRADE,BRAVO,VIENNA,CHARLIE,PARIS,DELTA,OSLO,ECHO,LISBON,FOXTROT,MADRID,GOLF,TANGIER,HOTEL,WARSAW,IVAN,R
OME,JULIET
3340 DATA ATHENS,KING,ISTANBUL,LIMA,BUCHAREST,MIKE,SOFIA,NOBLE,PRAQUE,OSCAR,COPENHAGEN,PAPA,REYKJAVIK,QUIZ,LONDON,ROMEO,BRUSSELS,SIE
RRA,BERLIN,TANGO
3350 DATA HELSINKI,UNCLE,BUDAPEST,VICTOR,DUBLIN,WINTER,ZURICH,X-RAY,MOSCOW,YANKEE,STOCKHOLM,ZULU
3360 DATA ZERO,ONE,TWO,THREE,FOUR,FIVE,SIX,SEVEN,EIGHT,NINE
3370 DATA"PTSR    ","VMNKJC  ","OVBJXT  ","STXJGR  ","UZPRWQ  ","WRGH    ","RDJKHF  ","KFG     ","YVOTPZ  ","CBKGDX  ","NLHGJB  ","Y
KNM    ","YLNBV   ","MLKB    ","IVCT    ","EZITAR  ","UEW     ","EPASDGFW","ATDR    ","PIOCXDSA","YZEQ    ","IYMBCO  "
3380 DATA "QERF    ","TCJD    ","LMVIZU  ","UYIPE   "
3390 '****************
3400 '** Game Start **
3410 '****************
3420 BORDER 13:INK 0,26:INK 1,0:INK 2,2:INK 3,6
3430 CLS:PEN 1
3440 LOCATE 12,1:PRINT" T R E A C H E R Y"
3450 LOCATE 4,3:PRINT"when the ";:PEN 3:PRINT"KGB ";:PEN 1:PRINT"and ";:PEN 2:PRINT"MI6 ";:PEN 1:PRINT"wage a war of"
3460 LOCATE 3,4:PRINT"wits through the capitals of Europe,"
3470 LOCATE 11,5:PRINT"nothing is simple!!"
3480 OPENOUT "dummy"
3490 MEMORY HIMEM-1
3500 CLOSEOUT
3510 '***************************
3520 '** User Defined Graphics **
3530 '***************************
3540 BORDER 9
3550 FOR char=251 TO 254
3560 FOR ch=1 TO 8
3570 READ a(ch)
3580 NEXT
3590 SYMBOL char,a(1),a(2),a(3),a(4),a(5),a(6),a(7),a(8)
3600 NEXT
3610 SYMBOL 255,0,0,0,255,255,0,0,0
3620 '***********************
3630 '** 'Top Secret' Data **
3640 '***********************
3650 t$(1)=CHR$(139)+CHR$(129)+CHR$(135)+CHR$(133)+CHR$(135)+CHR$(133)+"  "+CHR$(135)+CHR$(129)+CHR$(135)+CHR$(129)+CHR$(135)+CHR$(1
29)+CHR$(135)+CHR$(133)+CHR$(135)+CHR$(129)+CHR$(139)+CHR$(129)
3660 t$(2)=CHR$(138)+" "+STRING$(2,133)+CHR$(135)+CHR$(129)+"  "+CHR$(131)+CHR$(133)+CHR$(135)+" "+CHR$(133)+" "+CHR$(135)+CHR$(132)
+CHR$(135)+" "+CHR$(138)
3670 t$(3)=CHR$(130)+" "+CHR$(131)+CHR$(129)+CHR$(129)+"   "+CHR$(131)+CHR$(129)+CHR$(131)+CHR$(129)+CHR$(131)+CHR$(129)+CHR$(129)+C
HR$(129)+CHR$(131)+CHR$(129)+CHR$(130)
3680 '****************************
3690 '** Construct Flag Strings **
3700 '****************************
3710 '.... is CTRL & O
3720 DIM u$(2,14):u$(1,1)="3"+CHR$(213)+CHR$(143)+CHR$(215)+"2"+CHR$(213)+STRING$(3,143)+" 3"+STRING$(3,143)+" 2"+STRING$(3,143)+CHR
$(212)+"3"+CHR$(214)+CHR$(143)+CHR$(212)+"2"
3730 u$(1,2)="2"+CHR$(215)+"3"+CHR$(213)+CHR$(143)+CHR$(215)+"2"+CHR$(213)+STRING$(2,143)+" 3"+STRING$(3,143)+" "+"2"+STRING$(2,143)
+CHR$(212)+"3"+CHR$(214)+CHR$(143)+CHR$(212)+"2"+CHR$(214)
3740 u$(1,3)="2"+CHR$(143)+CHR$(215)+"3"+CHR$(213)+CHR$(143)+CHR$(215)+"2"+CHR$(213)+CHR$(143)+" "+"3"+STRING$(3,143)+" "+"2"+CHR$(1
43)+CHR$(212)+"3"+CHR$(214)+CHR$(143)+CHR$(212)+"2"+CHR$(214)+CHR$(143)
3750 u$(1,4)="2"+CHR$(143)+CHR$(143)+CHR$(215)+"3"+CHR$(213)+CHR$(143)+CHR$(215)+"2"+CHR$(213)+" "+"3"+STRING$(3,143)+" "+"2"+CHR$(2
12)+"3"+CHR$(214)+CHR$(143)+CHR$(212)+"2"+CHR$(214)+STRING$(2,143)
3760 u$(1,5)="2"+STRING$(3,143)+CHR$(215)+"3"+CHR$(213)+CHR$(143)+CHR$(215)+" "+STRING$(3,143)+" "+CHR$(214)+CHR$(143)+CHR$(212)+"2"
+CHR$(214)+STRING$(3,143)
3770 u$(1,6)=STRING$(8," ")+"3"+STRING$(3,143)+STRING$(8," "):u$(1,9)=u$(1,6)
3780 u$(1,7)="3"+STRING$(19,143):u$(1,8)=u$(1,7)
3790 u$(1,10)="2"+STRING$(3,143)+CHR$(212)+"3"+CHR$(214)+CHR$(143)+CHR$(212)+" "+STRING$(3,143)+" "+CHR$(213)+CHR$(143)+CHR$(215)+"2
"+CHR$(213)+STRING$(3,143)
3800 u$(1,11)="2"+STRING$(2,143)+CHR$(212)+"3"+CHR$(214)+CHR$(143)+CHR$(212)+"2"+CHR$(214)+"3"+" "+STRING$(3,143)+" 2"+CHR$(215)+"3"
+CHR$(213)+CHR$(143)+CHR$(215)+"2"+CHR$(213)+STRING$(2,143)
3810 u$(1,12)="2"+CHR$(143)+CHR$(212)+"3"+CHR$(214)+CHR$(143)+CHR$(212)+"2"+CHR$(214)+CHR$(143)+"3"+" "+STRING$(3,143)+" 2"+CHR$(143
)+CHR$(215)+"3"+CHR$(213)+CHR$(143)+CHR$(215)+"2"+CHR$(213)+CHR$(143)
3820 u$(1,13)="2"+CHR$(212)+"3"+CHR$(214)+CHR$(143)+CHR$(212)+"2"+CHR$(214)+STRING$(2,143)+"3 "+STRING$(3,143)+" 2"+STRING$(2,143)+C
HR$(215)+"3"+CHR$(213)+CHR$(143)+CHR$(215)+"2"+CHR$(213)
3830 u$(1,14)="3"+CHR$(214)+CHR$(143)+CHR$(212)+"2"+CHR$(214)+STRING$(3,143)+"3 "+STRING$(3,143)+" 2"+STRING$(3,143)+CHR$(215)+"3"+C
HR$(213)+CHR$(143)+CHR$(215)
3840 l$=STRING$(19,143)
3850 FOR i=1 TO 14
3860 u$(2,l)=l$ 
3870 NEXT
3880 MID$(u$(2,2),16,2)=CHR$(251)+CHR$(253)
3890 MID$(u$(2,3),16,2)=CHR$(252)+CHR$(254)
3900 REM
3910 '*****************
3920 '** Print Flags **
3930 '*****************
3940 p=2:x=20:y=7
3950 GOSUB 2940
3960 p=1:x=3:y=11
3970 GOSUB 2940
3980 '**************************
3990 '** Read Various Strings **
4000 '**************************
4010 DIM p$(2,2)
4020 READ p$(1,1),p$(2,1)
4030 READ p$(1,2),p$(2,2)
4040 DIM o$(2),q$(3),r$(3)
4050 DIM s$(3,16)
4060 READ o$(1),o$(2)
4070 READ q$(1),q$(2),q$(3)
4080 READ r$(1),r$(2),r$(3)
4090 DIM n$(36,5),f$(2,36)
4100 FOR k=1 TO 26:n$(k,1)=CHR$(k):NEXT k
4110 FOR k=27 TO 31:n$(k,1)=CHR$(18):NEXT
4120 FOR k=32 TO 36:n$(k,1)=CHR$(25):NEXT
4130 FOR k=1 TO 36:FOR j=2 TO 5:n$(k,j)=CHR$(32):NEXT:NEXT
4140 m$="":FOR k=1 TO 13:m$=m$+CHR$(0):NEXT
4150 RANDOMIZE TIME:FOR k=1 TO 36
4160 READ a,b
4170 c=INT(RND*36)+1:IF ASC(n$(c,2))<>32 THEN 4170
4180 n$(c,2)=CHR$(a):n$(c,3)=CHR$(b)
4190 f$(1,c)=CHR$(1)+m$:n$(c,4)=CHR$(1)
4200 IF (a=1 AND b=0) OR (a=0 AND b=1) THEN f$(1,c)=CHR$(3)+m$:n$(c,4)=CHR$(3)
4210 f$(2,c)=f$(1,c)
4220 n$(c,5)=CHR$(0)
4230 NEXT
4240 DIM g$(2),o(6,5),s(4)
4250 BORDER 20
4260 '**************************
4270 '** Read Cities & Agents **
4280 '**************************
4290 DIM w$(26),x$(36)
4300 FOR k=1 TO 26
4310 READ w$(k),x$(k)
4320 NEXT
4330 FOR k=27 TO 36
4340 READ x$(k)
4350 NEXT
4360 DIM y$(26)
4370 FOR k=1 TO 26
4380 READ y$(k)
4390 NEXT
4400 BORDER 6
4410 '***************************
4420 '** City to City Distance **
4430 '***************************
4440 DIM z$(26):GOSUB 7800
4450 GOSUB 8100:REM screen copy M/C
4460 '****************
4470 '** Game Start **
4480 '****************
4490 BORDER 24:zzz=FRE("")
4500 day=3
4510 BORDER 26
4520 stack=1
4530 p=1
4540 r=INT(RND*26)+1:IF r=18 OR r=25 THEN 4540
4550 s(1)=r:scwag=0
4560 FOR j=1 TO 5:GOSUB 6210:NEXT
4570 r=INT(RND*26)+1:IF r=18 OR r=25 THEN 4570
4580 btag=0:btloc=r
4590 r=INT(RND*26)+1:IF r=18 OR r=25 OR r=btloc THEN 4590
4600 bcag=0:bcloc=r:bcon=2
4610 manloc=INT(RND*26)+1
4620 explod=0
4630 GOTO 4980
4640 '***********************
4650 '** Print Agent Ranks **
4660 '***********************
4670 GOSUB 160
4680 LOCATE#1,2,2:PRINT#1,MID$(p$(p,1),1,4);"RANK & AGENT DAY";day
4690 PEN#1,3
4700 y=4:x=2:FOR k=1 TO 36
4710 IF ASC(n$(k,4))=0 OR ASC(n$(k,p+1))=0 THEN 4770
4720 a=ASC(n$(k,p+1))
4730 LOCATE#1,x,y:PRINT#1,a;" ",x$(k)
4740 y=y+1
4750 IF y=15 THEN y=4:x=14
4760 NEXT
4770 PEN#1,1
4790 GOTO 490
4800 '************************
4810 '** List Agent Reports **
4820 '************************
4830 GOSUB 160
4840 LOCATE#1,2,2:PRINT#1,MID$(p$(p,1),1,4);"AGENTS REPORTS DAY";day
4850 y=4:x=2
4860 FOR k=1 TO 36
4870 IF ASC(n$(k,4))=0 THEN 4930
4880 orank=ASC(n$(k,p+1))
4890 erank=ASC(n$(k,4-p))
4900 IF orank<=erank OR ASC(MID$(f$(1,k),5,1))=0 THEN 4930
4910 LOCATE #1,x,y:PRINT#1,x$(k);" ";ASC(MID$(f$(1,k),5,1))
4920 y=y+1:IF y=15 THEN y=4:x=14
4930 NEXT
4940 GOTO 490
4950 '*************************
4960 '** Player Turn Reports **
4970 '*************************
4980 reports=0:GOSUB 230
4990 IF report=5 THEN 5200
5000 GOSUB 160
5010 IF day=3 THEN 5200
5020 LOCATE#1,2,2:PRINT#1,p$(p,1);" DAY";day
5030 LOCATE#1,2,3:PRINT#1,"YESTERDAY'S FIELD REPORTS"
5040 LOCATE#1,2,6:PRINT#1,"KEY 1 List all agents"
5050 LOCATE#1,2,7:PRINT#1,"      and their rank"
5060 LOCATE#1,2,9:PRINT#1,"KEY 2 List agents with"
5070 LOCATE#1,2,10:PRINT#1,"      reports to send and"
5080 LOCATE#1,2,11:PRINT#1,"      how many reports"
5090 LOCATE#1,2,13:PRINT#1,"KEY 3 Call in a report"
5100 LOCATE#1,2,15:PRINT#1,"KEY 4 Finish with reports"
5110 LOCATE#1,2,16:PRINT#1,"      Give today's orders"
5120 k$=INKEY$:IF k$="" THEN 5120
5130 IF k$<"1" OR k$>"4" THEN 5120
5140 IF k$="1" THEN GOSUB 4670:GOTO 4990
5150 IF k$="2" THEN GOSUB 4830:GOTO 4990
5160 IF k$="3" THEN GOSUB 560:reports=reports+1:GOTO 4990
5170 '************************
5180 '** Player Turn Orders **
5190 '************************
5200 orders=0
5210 IF orders=3 THEN 5350
5220 GOSUB 160
5230 LOCATE #1,2,2:PRINT#1,p$(p,1);" DAY";day
5240 LOCATE #1,2,4:PRINT#1,"TODAY'S ORDERS"
5250 LOCATE #1,2,6:PRINT#1,"KEY 1 List all agents"
5260 LOCATE #1,2,7:PRINT#1,"      and their rank"
5270 LOCATE #1,2,9:PRINT#1,"KEY 2 Give an order"
5280 LOCATE #1,2,11:PRINT#1,"KEY 3 Finish with orders"
5290 LOCATE #1,2,12:PRINT#1,"      Operations over"
5300 LOCATE#1,2,13:PRINT#1,"      until tomorrow"
5310 k$=INKEY$:IF k$="" THEN 5310
5320 IF k$<"1" OR k$>"3" THEN 5310
5330 IF k$="1" THEN GOSUB 4670:GOTO 5210
5340 IF k$="2" THEN GOSUB 1480:orders=orders+1:GOTO 5210
5350 p=p+1:IF p<3 THEN 4980
5360 '****************
5370 '** End of Day **
5380 '****************
5390 GOSUB 5550
5400 day=day+1
5410 FOR k=1 TO 16
5420 s$(1,k)=s$(2,k)
5430 s$(2,k)=s$(3,k)
5440 NEXT:stack=1
5450 m$="":FOR k=1 TO 13:m$=m$+CHR$(0):NEXT
5460 FOR k=1 TO 36
5470 f$(1,k)=f$(2,k)
5480 f$(2,k)=n$(k,4)+m$
5490 NEXT
5500 p=1
5510 GOTO 4980
5520 '********************
5530 '** Execute Orders **
5540 '********************
5550 CLS
5560 GOSUB 160
5570 LOCATE#1,2,2:PRINT#1,"END OF DAY";day;CHR$(8);"'s TREACHERY"
5580 GOSUB 6210
5590 FOR K=1 TO 6:FOR J=1 TO 5:O(K,J)=0:NEXT:NEXT
5600 no=0
5610 FOR k=1 TO 36
5620 o1=ASC(n$(k,5)):IF o1=0 THEN 5700
5630 no=no+1
5640 o(no,1)=ASC(LEFT$(s$(3,o1),1))
5650 o(no,2)=ASC(MID$(s$(3,o1),2,1))
5660 o(no,3)=ASC(MID$(s$(3,o1),5,1)) 
5670 o(no,4)=ASC(MID$(s$(3,o1),6,1)) 
5680 o(no,5)=ASC(MID$(s$(3,o1),3,1))
5690 n$(k,5)=CHR$(0)
5700 NEXT
5710 y=4
5720 FOR o=1 TO no:IF o(o,1)=9 THEN GOSUB 6350
5730 NEXT
5740 FOR o=1 TO no:IF o(o,1)=1 THEN GOSUB 6520
5750 NEXT
5760 FOR o=1 TO no:IF o(o,1)=5 THEN GOSUB 6630
5770 NEXT
5780 FOR o=1 TO no:IF o(o,1)=6 THEN GOSUB 6750
5790 NEXT
5800 FOR o=1 TO no:IF o(o,1)=3 THEN GOSUB 6980
5810 NEXT
5820 FOR o=1 TO no:IF o(o,1)=4 THEN GOSUB 7210
5830 NEXT
5840 FOR o=1 TO no:IF o(o,1)=2 THEN GOSUB 7290
5850 NEXT
5860 FOR o=1 TO no:IF o(o,1)=8 THEN GOSUB 77740
5870 NEXT
5880 FOR o=1 TO no:IF o(o,1)=7 THEN GOSUB 7520
5890 NEXT
5900 FOR k=1 TO 36
5910 IF ASC(MID$(f$(2,k),2,1))<>0 THEN f$(2,k)=LEFT$(f$(2,k),4)+CHR$(ASC(MID$(f$(2,k),5,1))+1+MID$(f$(2,k),6)
5920 NEXT
5930 LOCATE#1,2,y:PRINT#1,"3 days ago SCWEINSTEIN":y=y+1
5940 LOCATE#1,2,y:PRINT#1,"Was seen in ";w$(s(4)):y=y+1
5950 IF bcon=2 THEN 5970
5960 LOCATE#1,2,y:PRINT#1,"BEACON ON in";w$(bcloc):y=y+1
5970 IF btag=0 THEN 6000
5980 LOCATE#1,2,y:PRINT#1,"FIRING BUTTON detected":y=y+1
5990 LOCATE#1,2,y:PRINT#1,"in ";w$(btloc):y=y+1
6000 IF explod=1 THEN 6120
6010 d=VAL(MID$(z$(manloc),bcloc,1))
6020 IF d=0 AND bcon=1 THEN 6110
6030 n=0:FOR k=1 TO 8
6040 IF MID$(y$(manloc),k,1)<>" " THEN n=n+1
6050 NEXT
6060 r=INT(RND*n)+1
6070 IF bcon=2 THEN manloc=ASC(MID$(y$(manloc),r,1))-64:GOTO 6110
6080 c=ASC(MID$(y$(manloc),r,1))-64
6090 IF VAL(MID$(z$(c),bcloc,1))>=d THEN 6060
6100 manloc=c
6110 LOCATE#1,2,y:PRINT#1,"MANDROID in ";w$(manloc):y=y+1
6120 IF s(1)<>18 AND s(1)<>25 THEN 490
6130 IF s(1)=18 THEN LOCATE#1,2,y:PRINT#1,"SCWEINSTEIN IN LONDON":y=y+2:LOCATE#1,2,y:PRINT#1,"MI6 HAVE WON THE GAME":p=1
6140 IF s(1)=25 THEN LOCATE#1,2,y:PRINT#1,"SCWEINSTEIN IN MOSCOW":y=y+2:LOCATE#1,2,y:PRINT#1,"THE KGB HAVE WON THE GAME":P=2
6150 REM
6160 GOTO 6160
6170 STOP
6180 '***********************
6190 '** Move Schweinstein **
6200 '***********************
6210 FOR k=4 TO 2 STEP-1
6220 s(k)=s(k-1)
6230 NEXT
6240 IF scwag>0 THEN RETURN
6250 n=0:FOR k=1 TO 8
6260 IF MID$(y$(s(1)),k,1) <> " "THEN n=n+1        
6270 NEXT
6280 r=INT(RND*n)+1
6290 c=ASC(MID$(y$(s(1)),r,1))-64
6300 IF c=s(3) OR c=18 OR c=25 THEN 6280
6310 s(1)=c:RETURN
6320 '**********************
6330 '** Explode Mindbomb **
6340 '**********************
6350 IF explod=1 THEN RETURN
6360 ag=o(o,2):IF btag<>ag THEN ob=2:GOTO 6900
6370 LOCATE#1,2,y:PRINT#1,"MIND-BOMB explodes in":y=y+1
6380 LOCATE#1,2,y:PRINT#1,w$(manloc):y=y+1
6390 IF manloc=18 THEN y=y+1:LOCATE#1,2,y:PRINT#1,"THE KGB HAVE WON THE GAME":p=p+2:GOTO 6150
6400 IF manloc=25 THEN y=y+1:LOCATE#1,2,y:PRINT#1,"MI6 HAVE WON THE GAME":p=1:GOTO 6150
6410 FOR k=1 TO 36
6420 IF ASC(n$(k,1))<>manloc THEN 6470
6430 n$(k,4)=CHR$(0)
6440 IF btag=k THEN btag=0
6450 IF bcag=k THEN bcag=0
6460 IF schwag=k THEN scwag=0
6470 NEXT
6480 explod=1:RETURN
6490 '****************
6500 '** Go to City **
6510 '****************
6520 ag=o(o,2):c=o(o,3)
6530 IF ASC(n$(ag,4))=0 THEN RETURN
6540 n$(ag,1)=CHR$(c)
6550 IF btag=ag THEN btloc=c
6560 IF bcag=ag THEN bcloc=c 
6570 IF scwag=ag THEN s(1)=c
6580 LOCATE#1,2,y:PRINT#1,x$(ag);" go to ";w$(c)
6590 y=y+1:RETURN
6600 '*****************
6610 '** Hide Object **
6620 '*****************
6630 ag=o(o,2):ob=o(o,3)
6640 IF ASC(n$(ag,4))=0 THEN RETURN
6650 ON ob GOTO 6660,6680,6700
6660 IF scwag<>ag THEN 6900
6670 schwag=0:RETURN
6680 IF btag<>ag THEN 6900
6690 btag=0:RETURN
6700 IF bcag<>ag THEN 6900
6710 bcag=0:RETURN
6720 '**********************
6730 '** Transfer Object ***
6740 '**********************
6750 ag=o(o,2):ob=o(o,3):to1=o(o,4):IF ag=to1 THEN RETURN
6760 IF ASC(n$(ag,4))=0 OR ASC(n$(to1,4))=0 THEN RETURN
6770 fc=ASC(n$(ag,1)):tc=ASC(n$(to1,1))
6780 IF MID$(z$(fc),tc,1)>"1" THEN RETURN
6790 ON ob GOTO 6800,6830,6860
6800 IF scwag<>ag THEN 6900
6810 schwag=to1:s(1)=tc
6820 GOTO 6880
6830 IF btag<>ag THEN 6900
6840 btag=to1:btloc=tc
6850 GOTO 6880
6860 IF bcag<>ag THEN 6900
6870 bcag=to1:bcloc=tc
6880 f$(2,to1)=LEFT$(f$(2,to1),1)+CHR$(13)+CHR$(ob)+CHR$(ag)+MID$(f$(2,to1),5)
6890 RETURN
6900 IF o(o,1)=4 THEN 6930
6910 f$(2,ag)=LEFT$(f$(2,ag),1)+CHR$(14)+CHR$(ob)+MID$(f$(2,ag),4)
6920 RETURN
6930 f$(2,to1)=LEFT$(f$(2,to1),1)+CHR$(14)+CHR$(ob)+MID$(f$(2,to1),4)
6940 RETURN
6950 '*****************
6960 '** Search City **
6970 '*****************
6980 ag=o(o,2):c=o(o,3)
6990 IF ASC(n$(ag,4))=0 THEN RETURN
7000 sl=0:FOR k=3 TO 2 STEP-1
7010 IF s(k)=c THEN s1=k
7020 NEXT
7030 IF sl=0 THEN 7050
7040 f$(2,ag)=LEFT$(f$(2,ag),1)+CHR$(12)+CHR$(day+1-sl)+CHR$(c)+MID$(f$(2,ag),5)
7050 IF s(1)<>c THEN 7100
7060 IF schwag=0 THEN schwag=ag:f$(2,ag)=LEFT$(f$(2,ag),1)+CHR$(10)+MID$(f$(2,ag),3):GOTO 7080
7070 f$(2,ag)=LEFT$(f$(2,ag),1)+CHR$(11)+MID$(f$(2,ag),3)
7080 f$(2,ag)=LEFT$(f$(2,ag),2)+CHR$(1)+CHR$(c)+MID$(f$(2,ag),5)
7090 RETURN
7100 IF btloc<>c OR btag<>0 THEN 7130
7110 f$(2,ag)=LEFT$(f$(2,ag),1)+CHR$(10)+CHR$(2)+CHR$(c)+MID$(f$(2,ag),5)
7120 btag=ag
7130 IF bcloc<>c OR bcon=1 THEN RETURN
7140 IF bcag=0 THEN bcag=ag:f$(2,ag)=LEFT$(f$(2,ag),1)+CHR$(10)+MID$(f$(2,ag),3):GOTO 7160
7150 f$(2,ag)=LEFT$(f$(2,ag),1)+CHR$(11)+MID$(f$(2,ag),3)
7160 f$(2,ag)=LEFT$(f$(2,ag),2)+CHR$(3)+CHR$(c)+MID$(f$(2,ag),5)
7170 RETURN
7180 '******************
7190 '** Steal Object **
7200 '******************
7210 to1=o(o,2):ob=o(o,3):ag=o(o,4):IF ag=to1 THEN RETURN
7220 GOSUB 6760
7230 IF ASC(MID$(f$(2,to1),2,1))<>13 THEN RETURN
7240 f$(2,ag)=LEFT$(f$(2,ag),1)+CHR$(15)+MID$(f$(2,ag),3)
7250 RETURN
7260 '****************
7270 '** Kill Agent **
7280 '****************
7290 ag=o(o,2):to1=o(o,3)
7300 IF ag=to1 THEN RETURN
7310 IF ASC(n$(ag,4))=0 OR ASC(n$(to1,4))=0 THEN RETURN
7320 c=ASC(n$(ag,1))
7330 IF ASC(n$(to1,1))<>c THEN RETURN
7340 n$(to1,4)=CHR$(0)
7350 IF btag=to1 THEN btag=0
7360 IF bcag=to1 THEN bcag=0
7370 IF schwag=to1 THEN schwag=0
7380 LOCATE#1,2,y:PRINT#1,x$(to1);" is eliminated"
7390 y=y+1
7400 RETURN
7410 '******************
7420 '** Switch Beacon *
7430 '******************
7440 ag=o(o,2):on1=o(o,3)
7450 IF ASC(n$(ag,4))=0 THEN RETURN
7460 IF bcag<>ag THEN ob=3:GOTO 6900
7470 bcon=on1
7480 RETURN
7490 '*******************
7500 '** Change Status **
7510 '*******************
7520 ag=o(o,2):pl=o(o,5)
7530 IF ASC(n$(ag,4))=0 THEN RETURN
7540 orank=ASC(n$(ag,pl+1))
7550 erank=ASC(n$(ag,4-pl))
7560 IF erank>orank THEN RETURN
7570 n$(ag,4)=CHR$(o(o,3))
7580 RETURN
7590 '**************************
7600 '** Hard Copy To Printer **
7610 '**************************
7620 PRINT#8,CHR$(13):a%=0
7630 FOR k2=5 TO 19
7640 FOR k1=11 TO 36
7650 LOCATE k1,k2
7660 CALL copychar,@a%
7670 PRINT#8,CHR$(a%);
7680 NEXT
7690 PRINT#8
7700 NEXT
7710 RETURN
7720 '********************
7730 '** Error Traping ***
7740 '********************
7750 LOCATE 1,24:PRINT"Error";ERR;"in LINE";ERL
7760 END
7770 '********************
7780 '** z$(array) DATA **
7790 '********************
7800 RESTORE 7810:FOR k=1 TO 26:READ z$(k):NEXT:RETURN
7810 DATA "03222223233444213111332232"
7820 DATA "30124322211211234332314223"
7830 DATA "21023323212322124321314123"
7840 DATA "22202212212333223111332133"
7850 DATA "24320223233334311122131321"
7860 DATA "23322011322343422123341343"
7870 DATA "22212101311232323122332233"
7880 DATA "32323110421232433233432334"
7890 DATA "22222334033223113221213211"
7900 DATA "31113212301222234222423134"
7910 DATA "31223211310121334233323223"
7920 DATA "42333322221011333343224312"
7930 DATA "41233433222101233443214312"
7940 DATA "41234322321110344343324323"
7950 DATA "22123434123323024321314222"
7960 DATA "13221223133334202121222221"
7970 DATA "34431233344334420233131422"
7980 DATA "13311112222343312012231232"
7990 DATA "13212223223444223101332233"
8000 DATA "12112323123333113210323122"
8010 DATA "33331334243223321233022411"
8020 DATA "31133433122212123332204212"
8030 DATA "24421122333444421123240332"
8040 DATA "22113323212333224221423033"
8050 DATA "32232433132112222332113301"
8060 DATA "23331334143223212232122310"
8070 '******************************
8080 '** Screen Copy Machine Copy **
8090 '******************************
8100 RESTORE 8160
8110 MEMORY HIMEM-12
8120 copychar=HIMEM+1
8130 FOR address=copychar TO copychar+10
8140 READ byte:POKE address,byte
8150 NEXT
8160 DATA &cd,&60,&bb,&dd,&6e,&00,&dd,&66,&01,&77,&c9
8170 RETURN
