10 DEFINT a-z:DEFREAL t
20 ON BREAK GOSUB 30:GOTO 40
30 MODE 2:STOP
40 DEF FNinx(x)=MIN(x+4,144):DEF FNdec(v)=MAX(v-4,0):DEF FNiny(y)=MIN(y+4,167)
50 MODE 0:ORIGIN 0,0,0,640,0,382
60 IF PEEK(&8000)=0 THEN MEMORY &7FFF:LOAD"scode",&8000:CALL &8000
70 FOR n=0 TO 15:READ i:INK n,i:NEXT
80 DATA 0,24,9,3,14,10,13,16,26,12,6,18,23,3,1,0
90 up=72:down=73:left=74:right=75:fire=76:up1=67:down1=69:left1=34:right1=27:fir1=47
100 d=20:diff=20
110 ENV 1,=9,3000:ENV 2,1,10,1,1,-10,1,1,-10,1:ENT -1,4,6,2
120 ENT -2,=100,1,=200,1,=140,2,=650,2:ENV 3,50,0,50
130 GOTO 1170
140 '
150 '
160 'main loop
170 p1x=10:p1y=10:p2x=120:p2y=10:r1=5
180 p1hits=0:p2hits=0:endgame=0
190 SOUND 130,1000+p1y,50,5,3:SOUND 132,900+p2y,50,5,3:a=0:a2=0
200 IF twoplayer THEN 660
210 r1=r1-2:IF r1<=0 THEN GOSUB 460
220 ON dirx GOSUB 360,370,380
230 ON diry GOSUB 410,420,430
240 GOSUB 530
250 IF p1ox=p1x AND p1oy=p1y THEN |SPRITE,0,p1x,p1y ELSE |BLANK,p1ox,p1oy:|SPRITE,0,p1x,p1y 
260 IF p2ox=p2x AND p2oy=p2y THEN |SPRITE,1,p2x,p2y ELSE |BLANK,p2ox,p2oy:|SPRITE,1,p2x,p2y
270 p1ox=p1x:p1oy=p1y:p2ox=p2x:p2oy=p2y
280 IF shoot THEN GOSUB 790
290 IF shoot2 AND p1x<p2x+16 AND p1x>p2x-16 AND p2y<p1y-8 THEN GOSUB 860
300 IF shoot3 THEN GOSUB 860
310 IF endgame THEN 1040
320 '
330 GOTO 190
340 '
350 '
360 p2x=FNdec(p2x):RETURN
370 p2x=FNinx(p2x):RETURN
380 RETURN
390 '
400 '
410 p2y=FNdec(p2y):RETURN
420 p2y=FNiny(p2y):RETURN
430 RETURN
440 '
450 '
460 r1=INT(RND*5)+1:shoot2=0
470 IF p1y-24<p2y THEN diry=1 ELSE diry=INT(RND*2)+2:r1=r1+diff:GOTO 490
480 dirx=INT(RND*3)+1:RETURN
490 IF p1x<p2x THEN dirx=1 ELSE dirx=2
500 shoot2=-1
510 RETURN
520 '
530 IF INKEY(up) THEN 550
540 p1y=FNiny(p1y)
550 IF INKEY(down) THEN 570
560 p1y=FNdec(p1y)
570 IF INKEY(left) THEN 590
580 p1x=FNdec(p1x)
590 IF INKEY(right) THEN 610
600 p1x=FNinx(p1x)
610 IF INKEY(fire)THEN shoot=0:RETURN
620 shoot=1:RETURN
630 RETURN
640 '
650 '
660 IF INKEY(up1) THEN 680
670 p2y=FNiny(p2y)
680 IF INKEY(down1) THEN 700
690 p2y=FNdec(p2y)
700 IF INKEY(left1) THEN 720
710 p2x=FNdec(p2x)
720 IF INKEY(right1) THEN 740
730 p2x=FNinx(p2x)
740 IF INKEY(47)=0 THEN shoot3=1:GOTO 240
750 shoot3=0:GOTO 240 
760 '
770 '
780 '
790 MOVE p1x*4+32,p1y*2+48:FOR n=1 TO 5:a=a+TESTR(0,d):NEXT
800 SOUND 129,1000,-10,3,2,0,24
810 MOVE p1x*4+32,p1y*2+48:FOR n=1 TO 5:PLOTR 0,d,1:NEXT
820 MOVE p1x*4+32,p1y*2+48:FOR n=1 TO 5:PLOTR 0,d,0:NEXT
830 IF a>0 THEN p1hits=p1hits+1:SOUND 129,13,50,0,1,1:IF p1hits>5 THEN 930
840 RETURN
850 '
860 MOVE p2x*4+32,p2y*2+48:FOR n=1 TO 5:a2=a2+TESTR(0,d):NEXT 
870 SOUND 129,2000,-10,3,2,0,20
880 MOVE p2x*4+32,p2y*2+48:FOR n=1 TO 5:PLOTR 0,d,1:NEXT
890 MOVE p2x*4+32,p2y*2+48:FOR n=1 TO 5:PLOTR 0,d,0:NEXT
900 IF a2>0 THEN p2hits=p2hits+1:dirx=3:diry=3:r1=5:SOUND 129,20,50,0,1,1:IF p2hits>5 THEN 980
910 RETURN
920 '
930 |SPRITE,2,p2x,p2y:FOR n=p2y TO 0 STEP-8:|SPRITE,2,p2x,n:NEXT
940 SOUND 4,0,0,0,1,0,20
950 FOR n=3 TO 6:|SPRITE,n,p2x,p2y:FOR i=1 TO 50:NEXT i,n:p1score=p1score+1
960 FOR n=1 TO 20:|SPRITE,(n MOD 2)+5,p2x,p2y:NEXT n:endgame=-1:GOTO 1130
970 '
980 |SPRITE,2,p1x,p1y:FOR n=p1y TO 0 STEP-8:|SPRITE,2,p1x,n:NEXT
990 SOUND 4,0,0,0,1,0,20
1000 FOR n=3 TO 6:|SPRITE,n,p1x,p1y:FOR i=1 TO 50:NEXT i,n:p2score=p2score+1
1010 FOR n=1 TO 20:|SPRITE,(n MOD 2)+5,p1x,p1y:NEXT n:endgame=-1:GOTO 1130
1020 '
1030 '
1040 '
1050 IF p1score>9 THEN LOCATE 7,5:PRINT"GREEN WINS!":GOTO 1090
1060 IF p2score>9 THEN LOCATE 7,5:PRINT"BLUE WINS!":GOTO 1090
1070 CLS:GOSUB 1130:shoot2=0:GOTO 170
1080 t=TIME:WHILE t+1500>TIME:WEND
1090 LOCATE 3,15:PRINT"Press any key":WHILE INKEY$<>"":WEND:WHILE INKEY$="":WEND
1100 p1score=0:p2score=0:GOTO 1170
1110 '
1120 '
1130 LOCATE 1,1:PRINT USING"GREEN ### BLUE ###";p1score;p2score
1140 RETURN
1150 '
1160 '
1170 CLS:LOCATE 4,3:PRINT"Select option"
1180 LOCATE 6,5:PRINT"1 One player":LOCATE 6,7:PRINT"2 Two player"
1190 a$=INKEY$
1200 IF a$="1" THEN twoplayer=0:GOTO 1070
1210 IF a$="2" THEN twoplayer=-1:GOTO 1070
1220 GOTO 1190