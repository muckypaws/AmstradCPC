10 MODE 0
20 PRINT"I hope you ran the  pattern fill program first!"
30 INK 1,0:INK 2,2:INK 9,15:INK 10,16:INK 14,26
40 MOVE 30,200:FOR i=1 TO 13:READ x,y:DRAWR x,y:NEXT
50 DATA 100,100,300,-90,50,50,50,-60,-50,-60,-50,50,-300,-90,-100,90,0,-100,-10,0,0,210,50,0,-40,-100
60 MOVER 10,0
70 eye$="AAA9A3393A9AAAAAA993EEEE399AAAA9AEEEEEEEE99AAAA9EE2222EE9AAAA9EE221E22EE9AA93EE2111E2EE3933EEE211112EEE3993EE211112EE39AA9E
E221122EE9AAA99EE2222EE99AAAA9EEEEEEEE9AAAAA993EEEE939AAAAAAA9399399AAAAAAAA9333939AAAAAAAAA93939AAAAA"
80 REM width= 15 height= 15 
90 CALL &9000,15,15,@eye$
