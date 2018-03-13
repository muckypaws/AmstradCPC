10 'Anagrams by Roland Perry
20 'copyright (c) AMSOFT 1985
30 '
40 'Remember to RUN "BANKMAN" before running program
50 '************************************************
60 '
70 MODE 2
80 DEFINT a-z
90 r%=0:|BANKOPEN,7
100 INPUT"What 7 letter word to scramble ";s$
110 IF LEN(s$)<>7 THEN 100
120 PRINT"Please wait...."
130 LOCATE 1,5:PRINT"Computing:"
140 FOR c1=1 TO 7
150 FOR c2=1 TO 7
160 IF c2=c1 THEN 370
170 FOR c3=1 TO 7
180 IF c3=c2 OR c3=c1 THEN 360
190 FOR c4=1 TO 7
200 IF c4=c3 OR c4=c2 OR c4=c1 THEN 350
210 FOR c5=1 TO 7
220 IF c5=c4 OR c5=c3 OR c5=c2 OR c5=c1 THEN 340
230 FOR c6=1 TO 7
240 IF c6=c5 OR c6=c4 OR c6=c3 OR c6=c2 OR c6=c1 THEN 330
250 FOR c7=1 TO 7
260 IF c7=c6 OR c7=c5 OR c7=c4 OR c7=c3 OR c7=c2 OR c7=c1 THEN 320
270 o$=MID$(s$,c1,1)+MID$(s$,c2,1)+MID$(s$,c3,1)+MID$(s$,c4,1)+MID$(s$,c5,1)+MID$(s$,c6,1)+MID$(s$,c7,1)
280 LOCATE 12,5:PRINT x;o$
290 |BANKWRITE,@r%,o$
300 IF r%<0 THEN STOP
310 x=x+1
320 NEXT c7
330 NEXT c6
340 NEXT c5
350 NEXT c4
360 NEXT c3
370 NEXT c2
380 NEXT c1
390 lastrec=r%
400 'Now look them up
410 r%=0:g$=SPACE$(7)
420 PRINT:INPUT"What match do you require: use ? as wild card: ",m$
430 m$=LEFT$(m$,7)
440 FOR x=1 TO LEN(m$)
450 IF MID$(m$,x,1)="?" THEN MID$(m$,x,1)=CHR$(0)
460 NEXT
470 |BANKFIND,@r%,m$,0,lastrec
480 IF r%<0 THEN 420
490 |BANKREAD,@r%,g$
500 PRINT g$,
510 |BANKFIND,@r%,m$,r%+1,lastrec
520 GOTO 480
