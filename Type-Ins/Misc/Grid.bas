10 MODE 1:GRAPHICS PEN 1:w=16
20 BORDER 0:INK 0,0:INK 1,24
30 FOR i=0 TO 640 STEP w
40 MOVE i,0:DRAW i,400:NEXT
50 FOR i=0 TO 400 STEP w
60 MOVE 0,i:DRAW 640,i:NEXT
70 MOVE 639,0:DRAW 639,399:DRAW 0,399
75 WHILE INKEY$="":WEND
80 WHILE INKEY$=""
90 RANDOMIZE TIME
100 PLOT INT(RND(1)*640),INT(RND(1)*400),INT(RND(1)*4),1:WEND
