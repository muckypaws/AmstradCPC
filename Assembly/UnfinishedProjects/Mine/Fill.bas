10 ' Fill, Routine By Jason Brooks (C) 1994
20 DEFINT a-z
30 DIM stack(2,700)
40 MODE 1
50 GRAPHICS PEN 1
60 MOVE 100,100:DRAW 200,100,3:DRAW 200,300:DRAW 100,300:DRAW 100,100
65 LOCATE 1,16:PRINT"Jason":PRINT"Test"
66 MOVE 0,170:DRAW 100,170
67 MOVE 100,100:DRAW 120,0
70 x=90:y=110:p=2
80 GOSUB 1000
90 END
1000 ' Fill A Routine
1010 stackp=0
1020 ' Up Routine
1030 sx=x:sy=y:GOSUB 2000
1040 WHILE stackp<>0
1041 GOSUB 2100
1045 LOCATE 1,1:PRINT"Stack : ";stackp
1050 ox=x:f1=0:f2=0
1060 WHILE TEST(x,y)=0 AND x>=0
1080 IF TEST(x,y-2)=0 THEN tx=x:f1=1 ELSE IF f1<>0 THEN sx=tx:sy=y-2:GOSUB 2000:f1=0
1090 IF TEST(x,y+2)=0 THEN bx=x:f2=1 ELSE IF f2<>0 THEN sx=bx:sy=y+2:GOSUB 2000:f2=0
1100 x=x-2
1110 WEND:x1=x
1111 IF f1<>0 THEN sx=tx:sy=y-2:GOSUB 2000
1112 IF f2<>0 THEN sx=bx:sy=y+2:GOSUB 2000
1113 f1=0:f2=0
1120 x=ox+2
1130 WHILE TEST(x,y)=0 AND x<=640
1150 IF TEST(x,y-2)=0 THEN tx=x:f1=1 ELSE IF f1<>0 THEN sx=tx:sy=y-2:GOSUB 2000:f1=0
1160 IF TEST(x,y+2)=0 THEN bx=x:f2=1 ELSE IF f2<>0 THEN sx=bx:sy=y+2:GOSUB 2000:f2=0
1165 x=x+2
1170 WEND:IF TEST(x1+2,y)=0 THEN MOVE x1+2,y:DRAW x-2,y,p:LOCATE 1,2:PRINT x1+2;x-2;y;"     "
1180 IF f1<>0 THEN sx=tx:sy=y-2:GOSUB 2000
1181 IF f2<>0 THEN sx=bx:sy=y+2:GOSUB 2000
1190 WEND
1200 RETURN
2000 ' Put Co-Ords Onto Stack.
2010 IF stackp>690 THEN RETURN
2011 IF sx<0 OR sx>640 THEN RETURN
2012 IF sy>400 OR sy<0 THEN RETURN
2020 stack(0,stackp)=sx:stack(1,stackp)=sy:stackp=stackp+1:RETURN
2100 ' Get Co-Ords Of Stack
2101 stackp=stackp-1
2110 IF stackp<0 THEN RETURN
2120 x=stack(0,stackp):y=stack(1,stackp):RETURN
