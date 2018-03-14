10 '**** Bomber by J.Brooks ****
20 '**** Copyright (C) 1986 ****
30 '
40 MODE 1:CLS:INK 0,0:BORDER 0:INK 1,18:INK 2,6:INK 3,4:INK 5,15:INK 6,2:INK 7,24:INK 8,8:INK 9,26:INK 10,1:INK 11,20:INK 12,12:INK 13,16:INK 14,14:INK 15,21
50 SYMBOL AFTER 240:SYMBOL 241,&40,&60,&70,&7F,&7F,&3F,&7,&0:SYMBOL 242,0,&32,&7A,&FE,&FA,&F2,&E0,0
60 score=0:hiscore=0:plane$=CHR$(241)+CHR$(242):x=2:y=2:drop=0:a=2:b=2
70 GOSUB 480
80 CLS
90 PEN 2:LOCATE 1,15:INPUT"Enter Skill : 0 (ACE) to 5 (NOVICE) : ",skill
100 IF skill<0 OR skill>5 GOTO 90
110 skill=skill+10
120 LOCATE 1,15:PRINT CHR$(18);:LOCATE 1,15:INPUT"Enter speed 0 (FAST) to 100 (SLOW) :",RATE
130 IF RATE>100 OR RATE<0 GOTO 120
140 '
150 'BUILDINGS
160 '
170 MODE 0:FOR base=5 TO 15:FOR height=21 TO INT(RND(1)*8+skill) STEP -1:LOCATE base,height:PEN base-2:PRINT CHR$(143)+CHR$(8)+CHR$(11)+CHR$(244);:NEXT:NEXT
180 PLOT 0,20,4:DRAW 640,20,4
190 LOCATE 1,25:PEN 2:PRINT"score";score;:LOCATE 13,25:PRINT"Hi";hiscore;
200 '
210 'main game
220 '
230 LOCATE x-1,y:PRINT"   ";
240 PEN 1:LOCATE x,y:PRINT plane$;:PEN 2
250 IF y=21 AND x=15 THEN 290:ELSE GOTO 340
260 '
270 'Landed
280 '
290 FOR c=0 TO 1000:NEXT
300 score=score+100-(skill*2):skill=skill-1:x=2:y=2:a=2:b=2:drop=0
310 IF skill<10 THEN skill=10:rate=rate-20
320 IF rate<0 THEN rate=0
330 GOTO 150
340 FOR c=0 TO rate:NEXT
350 x=x+1
360 IF x=18 THEN LOCATE x-1,y:PRINT CHR$(18);:x=2:y=y+1:LOCATE x,y:PEN 1:PRINT plane$;:PEN 2
370 a$=INKEY$:IF a$=" " AND drop =0 THEN drop=1:b=y+2:a=x
380 IF y=21 THEN drop=0
390 IF drop=1 THEN LOCATE a,b:PRINT CHR$(252);:LOCATE a,b-1:PRINT" ";:b=b+1:IF b>21 THEN LOCATE a,b:PRINT" ";:LOCATE a,b-1:PRINT" ";:a=0:b=0:drop=0:SOUND 3,4000,10,12,0,0,10
400 ga=(a-0.5)*32:gb=400-(b*16):bomb=TEST(ga,gb)
410 IF bomb>0 THEN 670
420 gx=((x+1.5)*32):gy=408-(y*16):crash=TEST(gx,gy)
430 IF crash>0 THEN 570
440 GOTO 230
450 '
460 'Instructions
470 '
480 LOCATE 1,2:PEN 1:PRINT"You are piloting an aircraft over a des-erted city and must clear the buildings in order to land and refuel.  Your air- craft moves across the screen from left to right.";:PRINT
490 PRINT:PRINT"On reaching the right, the aircraft returns to the left A LINE FURTHER DOWN.You have an unlimited supply of bombs and you can drop them on the buildings  below by pressing the SPACE BAR.";:PRINT
500 PRINT:PRINT"Each time you land, the height of the buildings or the speed of your aircraft increases.";:PRINT:PRINT:PRINT"ONCE YOU HAVE RELEASED A BOMB, YOU WILL NOT BE ABLE TO RELEASE ANOTHER UNTIL THE FIRST HAS EXPLODED !!!!";
510 PEN 2:LOCATE 1,24:PRINT:PRINT"Press any key to start.";
520 a$=INKEY$:IF a$="" THEN 520
530 RETURN
540 '
550 'Collision
560 '
570 LOCATE x-1,y:PRINT CHR$(32)+CHR$(32)+CHR$(32)+CHR$(253)+CHR$(8)+CHR$(238)+CHR$(8);
580 FOR t=1 TO 10:SOUND 7,4000,5,15,0,0,5:PEN t:PRINT CHR$(253)+CHR$(8)+CHR$(238)+CHR$(8)+CHR$(32)+CHR$(8);:FOR tm=0 TO 50:NEXT:NEXT:PEN 2
590 CLS:LOCATE 1,5:PRINT"You Scored";score;
600 IF score>hiscore THEN hiscore=score:LOCATE 1,8:PRINT"TOP SCORE!!";
610 score=0:LOCATE 1,12:PRINT"Press R to restart";
620 a$=INKEY$:IF a$="r" OR a$="R" THEN 630 ELSE 620
630 PEN 1:MODE 1:x=2:y=2:a=2:b=2:GOTO 90
640 '
650 'Bombed Building
660 '
670 LOCATE a,b-1:PRINT" "+CHR$(8);:PEN 4:FOR tr=1 TO INT(RND(1)*3)+1:score=score+5:SOUND 3,4000,10,12,0,0,10:LOCATE a,b:FOR t=0 TO 4:PRINT CHR$(253)+CHR$(8)+CHR$(32)+CHR$(8);:NEXT:b=b+1
680 IF b=24 THEN b=b-1
690 NEXT
700 LOCATE 6,25:PRINT score;:drop=0:a=x:b=y:GOTO 230
