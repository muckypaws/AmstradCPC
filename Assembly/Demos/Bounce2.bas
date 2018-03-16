10 ' Bouncey Ball Routineish
20 MODE 2:ballx=326:bally=350
30 offsety=0:flag=0.1:flag1=8
40 WHILE INKEY$=""
50 GOSUB 200
60 bally=(bally-(offsety*(flag*ABS(1/flag))))
80 IF bally<20 THEN bally=20:flag=-flag
90 offsety=offsety+flag
100 IF offsety=0 THEN flag=-flag
110 IF offsety>10 THEN offsety=10
120 ballx=ballx-(flag1):IF ballx>610 THEN ballx=610:flag1=-flag1
130 IF ballx<10 THEN flag1=-flag1
140 GOSUB 170:FRAME
150 WEND
160 END
170 ' Display Ball
180 TAG:MOVE ballx,bally:PRINT CHR$(231);:TAGOFF:RETURN
190 ' Erase Ball
200 TAG:MOVE ballx,bally:PRINT " ";:TAGOFF:RETURN
