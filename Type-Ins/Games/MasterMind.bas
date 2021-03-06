10 ' Mastermind
20 ' By Robin Nixon
30 ' (C) Computing with the Amstrad
40 ' ---------- CPC ONLY ----------
50 |START
60 |PROC,initialise
70 WHILE 1:g=0
80 FOR x=1 TO 4:a(x)=-1:NEXT:b=0
90 |PROC,title
100 |PROC,randomnum
110 WHILE b<4 AND g<12
120 |PROC,guess
130 |PROC,result
140 |PROC,show
150 WEND
160 IF b=4 THEN |PROC,youwin
170 IF b<4 THEN |PROC,youlose
180 |PROC,playagain
190 WEND
200 |DEFPROC,initialise
210 MODE 1:BORDER 10
220 DEFINT a-z
230 DIM a(4),b(4),c(4)
240 |ENDPROC
250 |DEFPROC,randomnum
260 FOR x=1 TO 4
270 r=RND*9:|PROC,check
280 IF r=-1 THEN GOTO 270
290 a(x)=r
300 NEXT
310 |ENDPROC
320 |DEFPROC,check
330 FOR y=1 TO 4
340 IF a(y)=r THEN y=4:r=-1
350 NEXT
360 |ENDPROC
370 |DEFPROC,title
380 MODE 1
390 DRAW 638,0:DRAW 638,398:DRAW 0,398:DRAW 0,0
400 PEN 3:PAPER 2:LOCATE 16,2:PRINT"MASTERMIND"
410 |PROC,wind
420 |ENDPROC
430 |DEFPROC,guess
440 WINDOW 1,40,1,25
450 PEN 1:PAPER 0:LOCATE 10,24
460 a$="":PRINT"Enter your guess?";STRING$(5,32)
470 PEN 2:|PROC,getnum
480 LOCATE 28,24:PRINT a$;" "
490 FOR x=1 TO 4:b(x)=VAL(MID$(a$,x,1)):NEXT
500 |ENDPROC
510 |DEFPROC,getnum
520 LOCATE 28,24:PRINT a$;CHR$(143);" "
530 ik$=INKEY$:IF ik$="" THEN 530
540 IF (ik$<"0" OR ik$>"9") AND ik$<>CHR$(13) AND ik$<>CHR$(127) THEN 530
550 IF ik$=CHR$(127) AND LEN(a$)=0 THEN 530
560 IF ik$=CHR$(127) AND LEN(a$)>0 THEN a$=LEFT$(a$,LEN(a$)-1):GOTO 520
570 IF ik$=CHR$(13) AND LEN(a$)<4 THEN 520
580 IF ik$=CHR$(13) THEN |ENDPROC
590 IF LEN(a$)<4 THEN a$=a$+ik$
600 GOTO 520
610 |DEFPROC,wind
620 w1=13:w2=27:w3=5:w4=20:p1=2:p2=3:|PROC,shadow
630 PEN 1:PAPER 0:LOCATE 2,2
640 PRINT"Guess   Score"
650 |ENDPROC
660 |DEFPROC,shadow
670 WINDOW w1+1,w2+1,w3+1,w4+1:PAPER p2:CLS
680 WINDOW w1,w2,w3,w4:PAPER p1:CLS
690 |ENDPROC
700 |DEFPROC,result
710 b=0:c=0:FOR x=1 TO 4:c(x)=0
720 IF a(x)=b(x) THEN c(x)=1:b=b+1
730 NEXT
740 FOR x=1 TO 4
750 FOR y=1 TO 4
760 IF c(x)=1 THEN 780
770 IF a(x)=b(y) THEN c(x)=1:c=c+1
780 NEXT
790 NEXT
800 |ENDPROC
810 |DEFPROC,show
820 g=g+1:LOCATE 14,g+7
830 PEN 3:PAPER 2:PRINT a$;STRING$(5,32);
840 PEN 3:PRINT STRING$(b,233);
850 PEN 0:PRINT STRING$(c,233);
860 |ENDPROC
870 |DEFPROC,youlose
880 |PROC,gameover
890 PEN 0:PAPER 1:LOCATE 11,2:PRINT"You lost this game"
900 PEN 3:LOCATE 10,3:PRINT"The solution is ";
910 a$="":FOR x=1 TO 4:a$=a$+CHR$(a(x)+48):NEXT
920 PRINT a$
930 |ENDPROC
940 |DEFPROC,youwin
950 |PROC,gameover
960 PEN 0:PAPER 1:LOCATE 11,2:PRINT"You won this game"
970 |ENDPROC
980 |DEFPROC,gameover
990 FOR x=0 TO 500 STEP 17
1000 SOUND 2,x,2:NEXT:FOR x=1 TO 1000:NEXT
1010 w1=2:w2=38:w3=18:w4=23:p1=1:p2=3:|PROC,shadow
1020 |ENDPROC
1030 |DEFPROC,playagain
1040 PEN 2:PAPER 0:LOCATE 7,5
1050 PRINT"Press SPACE  to play again"
1060 IF INKEY$="" THEN 1060
1070 WHILE INKEY$<>" ":WEND
1080 |ENDPROC
