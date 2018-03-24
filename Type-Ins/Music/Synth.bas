1 ' Synth
2 ' Alastair Scott
3 ' Amstrad Action March 1987
10 CLS:DEFINT a-z:DIM no(5,20),ke(20)
20 ON BREAK GOSUB 140
40 GOSUB 490:GOSUB 690
50 EVERY 3,3 GOSUB 310
60 EVERY 3,2 GOSUB 340
70 EVERY 3,1 GOSUB 370
80 WHILE INKEY(16)
90 FOR c=1 TO 20
100 IF INKEY(ke(c))=0 AND c<>c1 AND c<>c2 AND c<>c3 THEN GOSUB 170
110 NEXT
120 IF INKEY(23)=128 THEN fl=0:GOSUB 400
130 WEND
140 SOUND 135,200,10,10:CLS:CALL &BC02
150 PEN 1:FOR a=1 TO 3:re=REMAIN(a):NEXT
160 WHILE INKEY$<>"":WEND:END
170 IF c1=0 THEN GOSUB 190 ELSE IF c2=0 THEN GOSUB 230 ELSE IF c3=0 THEN GOSUB 270
180 RETURN
190 IF c AND c=c2 OR c=c3 THEN RETURN
200 SOUND 129,0
210 SOUND 129,no(oct,c),32767,12,1,et
220 c1=c:RETURN
230 IF c AND c=c1 AND c=c2 OR c=c3 THEN RETURN
240 SOUND 130,0
250 SOUND 130,no(oct,c),32767,12,1,et
260 c2=c:RETURN
270 IF c AND c=c1 OR c=c2 THEN RETURN
280 SOUND 132,0
290 SOUND 132,no(oct,c),32767,12,1,et
300 c3=c:RETURN
310 IF c1=0 OR INKEY(ke(c1))=0 THEN RETURN
320 SOUND 129,no(oct,c1),0,12,2,et
330 c1=0:RETURN
340 IF c2=0 OR INKEY(ke(c2))=0 THEN RETURN
350 SOUND 130,no(oct,c2),0,12,2,et
360 c2=0:RETURN
370 IF c3=0 OR INKEY(ke(c3))=0 THEN RETURN
380 SOUND 132,no(oct,c3),0,12,2,et
390 c3=0:RETURN
400 IF INKEY(13)=128 THEN oct=oct MOD 5+1
410 IF INKEY(3)=128 THEN et=(et+1)MOD 9
420 IF INKEY(5)=128 THEN attack=(attack+1)MOD 6:fl=1
430 IF INKEY(12)=128 THEN decay=(decay+1)MOD 6:fl=1
440 IF INKEY(10)=128 THEN rel=rel MOD 9+1:fl=1
450 IF fl THEN ENV 1,5,3,attack,2,-1,decay:ENV 2,12,-1,rel
460 PEN 2:LOCATE 1,25
470 PRINT USING"Attack # Decay # Oct # Release # Tone #";attack,decay,oct,rel,et
480 RETURN
490 FOR oct=2 TO 2
500 FOR note=1 TO 20
510 IF note>12 THEN o=oct+1:n=note MOD 12 ELSE o=oct:n=note
520 fr!=440*(2^(o+((n-10)/12)))
530 t=ROUND(62500/fr!)
540 no(oct+3,note)=t
550 NEXT note,oct
560 FOR a=1 TO 20:READ ke(a):NEXT
570 DATA 71,60,63,61,62,55,52,54,44,46
580 DATA 45,38,39,36,31,29,30,22,19,06
590 FOR a=&BF00 TO &BF0B:READ a$
600 POKE a,VAL("&"+a$):NEXT
610 DATA dd,7e,00,cd,e4,bb
620 DATA dd,7e,02,c3,de,bb
630 ENT-1,9,1,1,9,-1,1:ENT-3,4,4,4,4,-4,4
640 ENT-2,1,5,4,1,-10,4,1,5,4:ENV 1
650 ENT-4,6,3,1,6,-3,1:ENV 2,12,-1,6
660 ENT-5,8,4,2,8,-4,2:ENT-6,3,1,1,3,-1,1
670 ENT-7,2,6,6,2,-6,6:ENT-8,8,2,4,8,-2,4
680 oct=3:attack=0:decay=0:rel=6:et=0:RETURN
690 MODE 1:BORDER 26:FOR a=0 TO 3:INK a,26:NEXT
700 SYMBOL 255,233,137,141,235,137,137,233
710 c=1:white$="ZXCVBNM<>/\"+CHR$(255):BLACK$="SDGHJL*]"
720 CALL &BF00,1,0
730 FOR a=1 TO 12
740 MOVE a*40+30,100:DRAWR 0,160:DRAWR 40,0:DRAWR 0,-160:DRAWR -40,0
750 MOVE a*40+46,130:TAG:PRINT MID$(white$,a,1);:TAGOFF
760 NEXT
770 CALL &BF00,0,1
780 FOR a=1 TO 11
790 IF a=3 OR a=7 OR a=10 THEN 820
800 ORIGIN 0,0,a*40+60,a*40+80,260,150:CLG 1
810 MOVE a*40+64,180:TAG:PRINT MID$(black$,c,1);:c=c+1:TAGOFF
820 NEXT
830 PEN 2:LOCATE 7,1:PRINT"SYNTH by Alastair Scott 1987"
840 PEN 3:LOCATE 11,3:PRINT"Press CLR to finish."
850 PEN 1:LOCATE 7,5:PRINT"f1 Octave f3 Attack f5 Decay"
860 PRINT TAB(8)"f7 Release f9 Tone [+CTRL]"
870 INK 1,0:INK 2,6:INK 3,18
880 GOTO 460
890 CLS:CALL &BC02:PEN 1:PRINT CHR$(7)"Error"ERR"at line"ERL