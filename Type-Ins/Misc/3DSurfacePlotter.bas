10 '      3D SURFACE PLOTTER
20 '        By  Ian Sharpe
30 ' (c) Computing with the Amstrad
40 ' ------------ CPC Only --------
50 BORDER 0:INK 0,1:INK 1,26:INK 2,21:INK 3,17:MODE 1:DEG
60 sc=17:tilt=0.45:mag=400/sc:da=43:hlr=7:vex=10
70 DIM z(sc+1,sc+1),scrd(sc+1,sc+1,2)
80 PRINT"Calculating base coordinates ..."
90 FOR x=sc TO 0 STEP -1:LOCATE 33,1:PRINT x:FOR y=0 TO sc
100 a=ATN((x+1)/(y+1)):IF SGN(a)=-1 THEN a=180-a
110 r=SQR((x+1)^2+(y+1)^1)
120 scrd(x,y,1)=mag*r*COS(da+a)
130 scrd(x,y,2)=mag*r*SIN(da+a)*tilt
140 NEXT y,x
150 ' =========== MENU ============
160 WHILE 1:MODE 1:BORDER 0
170 ERASE z:DIM z(sc+1,sc+1)
180 PEN 2:LOCATE 11,2:PRINT CHR$(24);" 3D SURFACE PLOTTER ";CHR$(24)
190 INK 1,0:WINDOW 11,30,4,21:PAPER 1:CLS:WINDOW 12,29,5,20:PAPER 0:CLS:INK 1,26
200 PRINT:PEN 3
210 PRINT" FUNCTION LIBRARY"
220 PRINT
230 PRINT" Press"
240 PRINT:PEN 1
250 PRINT" 1 ... Black Hole"
260 PRINT" 2 ... White Hole"
270 PRINT" 3 ... Waves"
280 PRINT" 4 ... Bumps"
290 PRINT" 5 ... Plop"
300 PRINT" 6 ... Crumpled"
310 PRINT" 7 ... Cone"
320 PRINT" 8 ... Fold"
330 INK 1,26:WHILE INKEY$<>"":WEND
340 i=0:WHILE i<1 OR i>8:i=VAL(INKEY$):WEND
350 PEN 3:PRINT:PRINT" Computing ...":PEN 1
360 ON i GOSUB 610,670,710,760,810,870,1080,1130
370 '========= DRAW GRAPH =========
380 MODE 2:DRAW 639,0,1:DRAWR 0,399:DRAW 0,399:DRAW 0,0
390 BORDER 10:ORIGIN 320,4,1,638,2,396
400 ' paper 1:cls:paper 0
410 FOR x=sc TO 0 STEP -1:FOR y=sc TO 0 STEP -1
420 sx0=scrd(x,y,1):sy0=scrd(x,y,2)+vex*z(x,y)
430 sx1=scrd(x+1,y,1):sy1=scrd(x+1,y,2)+vex*z(x+1,y)
440 sx2=scrd(x,y+1,1):sy2=scrd(x,y+1,2)+vex*z(x,y+1)
450 IF x<>sc THEN GOSUB 520
460 IF y<>sc THEN GOSUB 560
470 NEXT y,x
480 WINDOW 1,1,1,25:PRINT CHR$(24);" Press any key for menu  ";CHR$(24);
490 WHILE INKEY$<>"":WEND:CALL &BB18
500 WEND
510 ' draw lines
520 PLOT 1000,1000,0
530 FOR n=1 TO hlr:MOVE sx0,sy0-n*2:DRAW sx1,sy1-n*2:NEXT
540 MOVE sx0,sy0:DRAW sx1,sy1,1
550 RETURN 
560 PLOT 1000,1000,0
570 FOR n=1 TO hlr:MOVE sx0,sy0-n*2:DRAW sx2,sy2-n*2:NEXT
580 MOVE sx0,sy0:DRAW sx2,sy2,1
590 RETURN
600 ' ======== FUNCTIONS ========
610 '                  Black Hole
620 FOR x=0 TO sc:FOR y=0 TO sc
630 z(x,y)=-((20/((x-sc/2+0.25)^2+(y-sc/2+0.25)^2)))
640 NEXT y,x
650 RETURN
660 ' White hole
670 FOR x=0 TO sc:FOR y=0 TO sc
680 z(x,y)=(15/((x-sc/2+0.25)^2+(y-sc/2+0.25)^2))
690 NEXT y,x
700 RETURN
710 ' Waves
720 FOR x=0 TO sc:FOR y=0 TO sc
730 z(x,y)=COS((x+y)*600/sc)
740 NEXT y,x
750 RETURN
760 ' Bumps
770 FOR x=0 TO sc:FOR y=0 TO sc
780 z(x,y)=COS(x*1000/sc)+SIN(y*1000/sc)
790 NEXT y,x
800 RETURN
810 ' Plop
820 FOR x=0 TO sc:FOR y=0 TO sc
830 q=(x-sc/2)^2+(y-sc/2)^2
840 z(x,y)=COS(q*8)/(0.01*(q+0.1))
850 NEXT y,x
860 RETURN
870 ' Crumpled
880 RANDOMIZE TIME:FOR i=1 TO 35
890 s1=RND*3+1:s2=RND*3+1
900 IF s2=s1 THEN 890
910 d1=RND*sc:d2=RND*sc
920 d0=d1:ON s1 GOSUB 1040,1050,1060,1070:ec1(0)=a:ec1(1)=b
930 d0=d2:ON s2 GOSUB 1040,1050,1060,1070:ec2(0)=a:ec2(1)=b
940 IF ec1(0)=ec2(0) AND ec1(1)=ec2(1) THEN 910
950 IF ec1(0)>ec2(0) THEN t0=ec1(0):t1=ec1(1):ec1(0)=ec2(0):ec1(1)=ec2(1):ec2(0)=t0:ec2(1)=t1
960 xd=ec2(0)-ec1(0):IF xd=0 THEN m=0:GOTO 980
970 m=(ec2(1)-ec1(1))/xd
980 c=ec1(1)-m*(ec1(0))
990 d=ROUND(RND)*2-1
1000 FOR x=0 TO sc:FOR y=0 TO sc
1010 IF y>m*x+c THEN z(x,y)=z(x,y)+d
1020 NEXT y,x,i
1030 RETURN
1040 a=d0:b=0:RETURN
1050 a=d0:b=sc:RETURN 
1060 a=0:b=d0:RETURN
1070 a=sc:b=d0:RETURN
1080 ' Cone
1090 FOR x=0 TO sc:FOR y=0 TO sc 
1100 z(x,y)=MAX((0.4*sc-SQR((x-sc/2)^2+(y-sc/2)^2)),0)
1110 NEXT y,x
1120 RETURN
1130 ' Fold
1140 FOR x=0 TO sc:FOR y=0 TO sc
1150 q=(x-sc/2)^3-(y-sc/2)^3-(sc/6)^3
1160 NEXT y,x
1170 RETURN
3
