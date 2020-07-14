10 ' Screen Editor : By Jason Brooks (C) 1987 JacesofT
20 MODE 2
30 INK 1,17:INK 0,0:BORDER 0:PEN 1:PAPER 0
40 ZONE 20
50 b$="1"
60 WINDOW #1,1,40,1,25:PAPER #1,1:CLS#1:WINDOW 41,80,1,25:PAPER 0:CLS
70 LOCATE 12,1:PRINT"Screen Editor : V1"
80 PRINT
90 PRINT"1 : Brick Work","2 : Pavement"
100 PRINT"3 : Pavement 2","4 : Concrete"
110 PRINT"5 : Slate <","6 : Slate Edge <"
120 PRINT"7 : Sky","8 : Edge Slate >"
130 PRINT"9 : Slate >","A : Bottom Railings"
140 PRINT"B : Top Railings","C : Cloud <"
150 PRINT"D : Cloud >","E : Garage"
160 PRINT"F : Door Bot <","G : Door Bot >"
170 PRINT"H : Door Up <","I : Door Up >"
180 PRINT"J : Door Mid <","K : Door Mid >"
190 PRINT"L : Door Top <","M : Door Top >"
200 PRINT"         ::  RETURN TO CODE ::"
210 WINDOW SWAP 1,0:PEN 0
220 LOCATE 1,25:l=1:u=25
230 IF INKEY(8)=0 AND l>1 THEN l=l-1
240 IF INKEY(1)=0 AND l<40 THEN l=l+1
250 IF INKEY(0)=0 AND u>1 THEN u=u-1
260 IF INKEY(2)=0 AND u<25 THEN u=u+1
270 IF INKEY(18)=0 THEN 340
280 IF INKEY(31)=0 THEN GOSUB 600
290 LOCATE l,u:PRINT" ";:FRAME:LOCATE l,u:PRINT b$;:FRAME
300 a$=INKEY$:IF a$="" THEN 230
310 a$=UPPER$(a$)
320 IF a$<"1" OR a$>"N" THEN 230
330 b$=a$:GOTO 230
340 ' Encode Screen
350 WINDOW SWAP 0,1
360 PEN 1
370 OPENOUT"mapscr"    
380 FOR i=25 TO 1 STEP -1
390 FOR t=1 TO 40
400 LOCATE #1,t,i:a$=COPYCHR$(#1)
410 LOCATE t,i:PRINT a$;
420 IF a$="A" THEN a$="10"
430 IF a$="B" THEN a$="11"
440 IF a$="C" THEN a$="12"
450 IF a$="D" THEN a$="13"
460 IF a$="E" THEN a$="14"
470 IF a$="F" THEN a$="15"
480 IF a$="G" THEN a$="16"
490 IF a$="H" THEN a$="17"
500 IF a$="I" THEN a$="18"
510 IF a$="J" THEN a$="19"
520 IF a$="K" THEN a$="20"
530 IF a$="L" THEN a$="21"
540 IF a$="M" THEN a$="22"
550 WRITE #9,a$
560 NEXT t,i
570 CLOSEOUT
580 PRINT"ċFinished .."
590 END
600 ' Reload Screen Data
610 OPENIN"mapscr"
620 FOR i=25 TO 1 STEP -1
630 FOR t=1 TO 40
640 INPUT #9,a$
650 a=VAL(a$):IF a<10 THEN 670
660 a=a+55:a$=CHR$(a)
670 LOCATE t,i:PRINT a$;
680 NEXT t:NEXT i
690 CLOSEIN:RETURN
