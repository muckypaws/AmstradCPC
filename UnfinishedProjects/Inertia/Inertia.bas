10 ' Inertia Routine
20 ' By Jason Brooks
30 ' Initialization.
40 CALL &BBFF:BORDER 0:INK 0,0:INK 1,25
50 MODE 1:ORIGIN 0,0
60 DEFINT a-z
70 GRAPHICS PEN 1
80 DIM bullets(2,6)
90 score=0:hiscore=0
100 sightsx=320
110 sightsy=200
120 inertiax=0:inertiay=0
130 maxdrag=24
140 sights$=CHR$(232)
150 left=71
160 right=63
170 up=28
180 fire=18
190 friction!=1.5
200 down=30
210 horiz=0:vertical=0
220 maxx=604
230 minx=20
240 maxy=378:miny=34
250 MOVE 18,20:DRAW 18,380:DRAW 622,380:DRAW 622,18:DRAW 18,18
260 GRAPHICS PEN 2
270 TAGOFF:LOCATE 1,1:PRINT"Score =";score:LOCATE 20,1:PRINT"Hi-Score =";hiscore
280 ' Get Keyboard Input
290 keypx=0:keypy=0
300 IF INKEY(left)=0 THEN GOSUB 520
310 IF INKEY(right)=0 THEN GOSUB 550
320 IF INKEY(down)=0 THEN GOSUB 610
330 IF INKEY(up)=0 THEN GOSUB 580
340 IF INKEY(fire)=0 THEN GOSUB 640
350 ' Re-Calculate Inertia
360 IF inertiax>0 AND keypx=0 THEN inertiax=inertiax-1
370 IF inertiax<0 AND keypx=0 THEN inertiax=inertiax+1
380 IF inertiay>0 AND keypy=0 THEN inertiay=inertiay-1
390 IF inertiay<0 AND keypy=0 THEN inertiay=inertiay+1
391 IF ox<>0 THEN MOVE ox,oy:TAG:PRINT CHR$(238);
400 ox=bullet(1,6):oy=bullet(2,6)
410 IF j=6 AND ox<>0 THEN FOR i=6 TO 1 STEP -1:bullet(1,i)=bullet(1,i-1):bullet(2,i)=bullet(2,i-1):NEXT:TAG:MOVE ox,oy:PRINT" ";
420 IF j=6 THEN j=0
430 j=j+0.5
440 ' Delete Cross
450 IF inertiax<>0 OR inertiay<>0 THEN TAG:MOVE sightsx,sightsy:PRINT" ";:keyp=0
460 ' Re_calculate Position for cross according to inertia/Momentum
470 sightsx=sightsx+inertiax:IF sightsx>maxx THEN sightsx=maxx:inertiax=-inertiax/friction!
480 IF sightsx<minx THEN sightsx=minx:inertiax=-inertiax/friction!
490 sightsy=sightsy+inertiay:IF sightsy>maxy THEN sightsy=maxy:inertiay=-inertiay/friction!
500 IF sightsy<miny THEN sightsy=miny:inertiay=-inertiay/friction!
510 TAG:MOVE sightsx,sightsy:PRINT sights$;:GOTO 280
520 ' Move Sights Left
530 IF inertiax>-maxdrag THEN inertiax=inertiax-1
540 keypx=1:RETURN
550 ' Move Sights Right
560 IF inertiax<maxdrag THEN inertiax=inertiax+1
570 keypx=1:RETURN
580 ' Move Sights Up
590 IF inertiay<maxdrag THEN inertiay=inertiay+1:keypy=1
600 RETURN
610 ' Move Sights Down
620 IF inertiay>-maxdrag THEN inertiay=inertiay-1:keypy=1
630 RETURN
640 ' Fire A Bullet Routine.
650 IF bullet(1,1)<>0 THEN RETURN
660 b=0:WHILE b<7 AND bullet(1,b)=0:b=b+1:WEND
670 b=b-1:bullet(1,b)=sightsx:bullet(2,b)=sightsy
680 ox=sightsx:oy=sightsy
690 RETURN
