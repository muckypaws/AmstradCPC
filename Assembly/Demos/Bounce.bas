10 ' Bouncey Ball Routineish
20 MODE 1:ballx=326:bally=200
30 offsety=0:flag=1:flag1=1
40 WHILE INKEY$=""
50 'GOSUB 200
60 bally=(bally-(offsety*flag))
70 LOCATE 1,1:PRINT bally:LOCATE 2,2
80 IF bally<20 THEN bally=20:flag=-flag:PRINT flag
90 offsety=offsety+(flag*0.25)
100 IF offsety=0 THEN flag=-flag
110 IF offsety>12 THEN offsety=12
120 ballx=ballx-flag1:IF ballx>630 THEN ballx=630:flag1=-flag1
130 IF ballx<10 THEN flag1=-flag1
140 FRAME:GOSUB 170
150 WEND
160 END
170 ' Display Ball
180 TAG:MOVE ballx,bally:PRINT CHR$(231);:TAGOFF:RETURN
190 ' Erase Ball
200 TAG:MOVE ballx,bally:PRINT " ";:TAGOFF:RETURN
