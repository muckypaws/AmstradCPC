10 ' Please do not use this routine for piracy because PIRACY IS THEFT
20 ' MINI OFFICE II TAPE-DISC TRANSFER ROUTINE WRITTEN BY J.BROOKS 1987
30 ' REWIND MINI-OFFICE II TO THE START OF SIDE 1 THE WORD-PROCESSOR
40 ' INSERT A COMPLETELY BLANK FORMATED DISC IN DRIVE AND RUN THIS ROUTINE
50 ' THEN GO AWAY HAVE A COFFEE OR DO SOMETHING FOR HALF AN HOUR
60 ' THIS PART COPIES THE - WORD-PROCESSOR, DATABASE AND SPREAD SHEET
70 ' You do not have to type in lines 10-70
80 ' Word processor copier!
90 :
100 MODE 1
110 |DISC:|TAPE.IN::ON ERROR GOTO 200:LOAD"!",&C000:MEMORY &1FFF:LOAD"!",&8000
120 SAVE"word1",b,&8000,340,&8000:GOSUB 210:CALL &8000:LOAD"!",&2000
130 POKE &2000,&88:POKE &2001,&41:CALL &2004:SAVE"word2",b,&4188,&6000:GOSUB 210
140 ' Database copier!
150 MODE 1
160 LOAD"!",&C000:LOAD"!",&8000:SAVE"database.1",b,&8000,&200,&8000:CALL &8000:GOSUB 210
170 LOAD"!",&2000:POKE &2000,0:POKE &2001,88:POKE &2002,0:POKE &2003,0:CALL &2004
180 SAVE"database.2",b,&5188,&5000,&420:GOSUB 210
190 GOTO 240
200 RESUME NEXT
210 FOR i=0 TO 5000:NEXT:RETURN
220 ' Spread sheet copier!
230 :
240 MODE 1
250 FOR i=&BE80 TO &BEB1:READ a$:POKE i,VAL("&"+a$):NEXT
260 LOAD"!",&C000:MEMORY 6699:LOAD"!",&8000
270 SAVE"spread1",b,&8000,&200,&8000:CALL &8000:GOSUB 210:LOAD"!",6700
280 POKE 6702,0:POKE 6703,0:POKE 6700,144:POKE 6701,26:CALL 6704
290 SAVE"spread2",b,&1A90,17776:GOSUB 210:POKE 6700,192:POKE 6701,93:CALL 6704
300 SAVE"spread3",b,&5DC0,2048:GOSUB 210:POKE 6700,36:POKE 6701,144:CALL 6704
310 SAVE"spread4",b,&9024,1224:GOSUB 210:LOAD "!",&94D4:SAVE"spread5",b,&94D4,151 
320 GOSUB 210:LOAD"!",&9642:SAVE"spread6",b,&9642,47:GOSUB 210:CLEAR:MEMORY 6799:CALL &BC6B,1:CALL &BE80
330 RESUME NEXT
340 DATA 6,0,11,0,50,cd,77,bc,21,70,1,cd,83,bc,cd,7a,bc,6,7,21,ab,be,cd,8c,bc,21
350 DATA 70,1,11,17,17,1,0,0,3e,0,cd,98,bc,cd,8f,bc,c7,53,50,52,45,41,44,37,0,0
