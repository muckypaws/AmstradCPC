10 ' Bouncey Ball Routineish
20 MODE 2:ballx=326:bally=350:TAG
30 offsety=0:flag=0.27:flag1=1
40 WHILE INKEY$="":bally=(bally-(offsety*(flag*ABS(1/flag))))
50 IF bally<20 THEN bally=20:flag=-flag
60 offsety=offsety+flag
70 IF offsety=0 THEN flag=-flag
80 IF offsety>10 THEN offsety=10
90 ballx=ballx-(flag1):IF ballx>610 THEN ballx=610:flag1=-flag1
100 IF ballx<10 THEN flag1=-flag1
110 MOVE ballx,bally:PRINT CHR$(231);
120 WEND
130 END
140 ' Display Ball
150 TAG:MOVE ballx,bally:PRINT CHR$(231);:TAGOFF:RETURN
160 ' Erase Ball
170 TAG:MOVE ballx,bally:PRINT " ";:TAGOFF:RETURN
