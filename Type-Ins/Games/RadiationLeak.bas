10 '******** CPC 6128 ********
20 '***   Radiation Leak   ***
30 '**************************
40 'Computing with the Amstrad
50 GOSUB 650
60 GOSUB 890
70 ' ** menu **
80 LOCATE #2,8,2:PEN#2,6:PRINT#2,"menu";
90 FOR slctn=1 TO 3
100 PEN#2,1:LOCATE#2,3,slctn+3:PRINT#2,slctn;:PEN#2,6:LOCATE#2,5,slctn+3:PRINT#2,ch$(slctn);
110 NEXT
120 PEN #2,12:LOCATE#2,2,10:PRINT#2,"z=left      p=up";:LOCATE#2,2,12:PRINT#2,"x=right   l=down";:LOCATE#2,2,14:PRINT#2,"  or joystick";
130 LOCATE#2,2,16:PRINT#2,"a=restart screen"
140 LOCATE#2,2,17:PRINT#2,"q=quit game"
150 GOSUB 210
160 WHILE INKEY$<>"":WEND
170 ch=0:WHILE ch<1 OR ch>3:ch=VAL(INKEY$):WEND
180 IF ch=3 THEN 240
190 sel=ch:GOSUB 200:GOTO 160
200 PEN #2,6:LOCATE#2,5,osel+3:PRINT#2,ch$(osel);
210 PEN#2,4:LOCATE#2,5,sel+3:PRINT#2,ch$(sel);
220 osel=sel
230 RETURN
240 '** start game **
250 WHILE droids>0 AND radn<8
260 IF newsheet=1 THEN GOSUB 1020:' new screen
270 x2=x:y2=y
280 IF INKEY(ctrl(sel,1))=0 THEN x=x-1:IF x=0 THEN x=1
290 IF INKEY(ctrl(sel,2))=0 THEN x=x+1:IF x=19 THEN x=18
300 IF INKEY(ctrl(sel,3))=0 THEN y=y-1:IF y=0 THEN y=1
310 IF INKEY(ctrl(sel,4))=0 THEN y=y+1:IF y=19 THEN y=18
320 IF INKEY(67)=0 THEN CLS#2:GOTO 440
330 IF INKEY(69)=0 THEN droids=droids-1:LOCATE#6,3,1:PRINT#6,USING"#";droids;:newsheet=1:diff=caskets-casketno(screen-1):FOR chge=1 TO 6:casketno(chge)=casketno(chge)+diff:NEXT:screen=screen-1:GOTO 250
340 GOSUB 1240:' check pos
350 PEN#2,1:LOCATE#2,x,y:PRINT#2,CHR$(251);:chrnums(y,x)=32
360 IF x2=x AND y2=y THEN 380
370 PEN #2,5:LOCATE#2,x2,y2:PRINT#2,CHR$(32);
380 IF x2=x THEN 400
390 IF chrnums(y-1,x2)=254 AND y>1 THEN GOSUB 1310:'rockdrop
400 IF y<=2 THEN 420
410 IF x2=x AND y2=y-1 AND chrnums(y-2,x)=254 THEN GOSUB 1540:' rock crushes droid
420 crad=crad-1:IF crad=0 THEN radn=radn+1:LOCATE#4,radn,1:PRINT#4,CHR$(143);:crad=crad2+50
430 WEND
440 ' ** end of game routine **
450 CLS#2:PEN#2,1:LOCATE#2,5,8:PRINT#2,"Game  Over":FOR delay=1 TO 2000:NEXT
460 IF caskets<=hiscore THEN 630
470 IF caskets>=hisc(1) THEN plc=1:GOTO 510
480 FOR hisc=9 TO 1 STEP -1
490 IF caskets<hisc(hisc) THEN plc=hisc+1:GOTO 510
500 NEXT
510 FOR shft=10 TO plc STEP -1:name$(shft)=name$(shft-1):hisc(shft)=hisc(shft-1):NEXT
520 CLS#2:LOCATE#2,4,2:PRINT#2,"well done !";:LOCATE#2,1,4:PRINT#2,"you have a hiscore";:LOCATE#2,1,6:PRINT#2,"Please enter your";:LOCATE#2,1,7:PRINT#2,"name.";:PEN#2,4
530 WHILE INKEY$<>"":WEND
540 LOCATE#2,1,9:LINE INPUT#2,name$(plc)
550 name$(plc)=LEFT$(name$(plc),12):hisc(plc)=caskets
560 CLS#2:LOCATE#2,3,2:PRINT#2,"Hiscore table";:LOCATE#2,1,4:PRINT#2,"name         score";:PEN#2,1
570 FOR hst=1 TO 10
580 LOCATE#2,1,hst+5:PRINT#2,name$(hst);:LOCATE#2,15,hst+5:PRINT#2,USING"###";hisc(hst);
590 NEXT
600 PEN#2,12:LOCATE#2,3,17:PRINT#2,"Press any key";
610 WHILE INKEY$<>"":WEND
620 WHILE INKEY$="":WEND
630 radn=0:crad2=50:droids=3:caskets=0:newsheet=1:screen=0:count=0:LOCATE#5,12,1:PRINT#5,"  0";:LOCATE#6,3,1:PRINT#6,"3";:CLS#4:CLS#2
635 RESTORE 880:FOR i=1 TO 6:READ casketno(i):NEXT
640 GOTO 70
650 '*** Initialisation ***
660 DEFINT a-z
670 MODE 1:INK 0,0:INK 1,24:INK 2,20:INK 3,6:BORDER 0
680 PEN 1:PRINT:PRINT"Do you have a green screen? (y/n)"
690 i$="":WHILE i$<>"N" AND i$<>"Y":i$=UPPER$(INKEY$):WEND
700 IF i$="N" THEN INK 2,13 ELSE INK 2,26
710 SYMBOL 250,0,0,24,24,102,102,0,0:SYMBOL 251,60,90,60,24,129,24,36,102:SYMBOL 252,254,0,239,0,254,0,239,0
720 SYMBOL 253,24,231,129,129,129,129,129,255:SYMBOL 254,56,124,254,254,254,252,120,0:SYMBOL 255,255,255,231,195,129,129,129,129
730 ENT 1,5,-20,2
740 DIM chrnums(18,18),ctrl(3,4)
750 RESTORE 850:FOR i=1 TO 3:READ ch$(i):NEXT
760 FOR i=1 TO 6:READ x(i),y(i):NEXT
770 FOR i=1 TO 3:FOR j=1 TO 4
780 READ ctrl(i,j):NEXT j,i
790 FOR i=1 TO 6:READ casketno(i):NEXT
800 screen=0:sel=1:droids=3:newsheet=1:caskets=0:crad2=50:count=0
810 FOR i=1 TO 10
820 name$(i)="A team":hisc(10-i)=i*6+20
830 NEXT
840 RETURN
850 DATA Keyboard,Joystick,Start game
860 DATA 4,5,2,14,9,8,1,9,6,13,1,15
870 DATA 71,63,27,36,74,75,72,73,50,51,48,49
880 DATA 13,30,51,78,110,176
890 ' ** screen info **
900 MODE 0:PAPER 4:CLS:PEN 3
910 INK 7,3
920 WINDOW#1,2,19,1,1:WINDOW#2,2,19,3,20:WINDOW#3,2,10,22,22:WINDOW#4,12,19,22,22:WINDOW#5,2,15,24,24:WINDOW#6,17,19,24,24
930 FOR pap=1 TO 6:PAPER#pap,5:NEXT
940 PEN#1,1:PEN#3,4:PEN#4,3:PEN#5,4:PEN#6,1
950 ' ** Set up Screen **
960 FOR rows=1 TO 25:PRINT STRING$(20,252);:NEXT
970 FOR wdw=1 TO 6:CLS#wdw:NEXT
980 PRINT#1,CHR$(251);CHR$(251);CHR$(15);CHR$(4);"Radiation Leak";CHR$(15);CHR$(1);CHR$(251);CHR$(251);
990 PRINT#3,"Radiation";
1000 PRINT#5,"No.treated=  0";:PRINT#6,CHR$(251);CHR$(15);CHR$(4);"=3";
1010 RETURN
1020 '*** set up new playing screen ***
1030 WINDOW SWAP 0,2
1040 CLS#4:CLS:crad=crad2:radn=0:cols=1:rows=1:screen=screen+1
1050 ON screen GOSUB 2000,2040,2080,2120,2160,2200
1060 FOR rd=1 TO 3
1070 READ char$
1080 FOR rd2=1 TO 108
1090 char2$=MID$(char$,rd2,1)
1100 IF char2$="@" THEN p=7:p2=7:chr=143:chr2=143
1110 IF char2$="["THEN p=4:p2=3:chr=143:chr2=252
1120 IF char2$="*" THEN p=1:p2=3:chr=250:chr2=253
1130 IF char2$="+" THEN p=7:p2=2:chr=143:chr2=254
1140 IF char2$="/" THEN p=12:p2=p:chr=255:chr2=255
1150 IF char2$="." THEN chr=32:chr2=32
1160 PEN p:LOCATE cols,rows:PRINT CHR$(chr);CHR$(22);CHR$(1);:PEN p2:LOCATE cols,rows:PRINT CHR$(chr2);CHR$(22);CHR$(0);
1170 chrnums(rows,cols)=chr2
1180 cols=cols+1:IF cols=19 THEN rows=rows+1:cols=1
1190 NEXT
1200 NEXT
1210 newsheet=0:x=x(screen):y=y(screen)
1220 WINDOW SWAP 0,2
1230 RETURN
1240 ' *** check posistion ***
1250 IF x2<x AND y2>y OR x2<x AND y2<y OR x2>x AND y2<y OR x2>x AND y2>y THEN x=x2:y=y2:GOTO 1300
1260 IF casketno(screen)=caskets AND chrnums(y,x)=255 THEN newsheet=1
1270 IF screen=6 AND newsheet=1 THEN screen=0:crad2=crad2-5:count=count+1:FOR casketnos=1 TO 6:casketno(casketnos)=casketno(casketnos)+(176*count):NEXT:GOTO 1300
1280 IF chrnums(y,x)=252 OR chrnums(y,x)=254 OR chrnums(y,x)=255 THEN x=x2:y=y2
1290 IF chrnums(y,x)=253 THEN caskets=caskets+1:SOUND 1,100,10,15,0,1:LOCATE#5,12,1:PRINT#5,USING"###";caskets;
1300 RETURN
1310 '*** rock drop ***
1320 rock=y-1:rock2=0
1330 WHILE rock<>0
1340 IF chrnums(rock,x2)<>254 THEN 1380
1350 IF chrnums(rock,x2)=254 THEN rock2=rock2+1
1360 rock=rock-1
1370 WEND
1380 space=y:space2=0
1390 WHILE space<>19
1400 IF chrnums(space,x2)<>32 THEN 1440
1410 IF chrnums(space,x2)=32 THEN space2=space2+1
1420 space=space+1
1430 WEND
1440 FOR m=1 TO rock2
1450 rpos=y-m
1460 FOR m2=1 TO space2
1470 rpos=rpos+1
1480 PEN#2,2:LOCATE#2,x2,rpos:PRINT#2,CHR$(254);:chrnums(rpos,x2)=254
1490 PEN#2,5:LOCATE#2,x2,rpos-1:PRINT#2,CHR$(32);:chrnums(rpos-1,x2)=32
1500 NEXT
1510 SOUND 1,0,5,15,0,0,2
1520 NEXT
1530 RETURN
1540 '** rock crushes droid **
1550 rock=y-2:rock2=0
1560 WHILE rock<>0
1570 IF chrnums(rock,x)<>254 THEN 1610
1580 IF chrnums(rock,x)=254 THEN rock2=rock2+1
1590 rock=rock-1
1600 WEND
1610 space=y+1:space2=0
1620 WHILE space<>19
1630 IF chrnums(space,x)<>32 THEN 1670
1640 IF chrnums(space,x)=32 THEN space2=space2+1
1650 space=space+1
1660 WEND
1670 FOR m=1 TO rock2
1680 rpos=y-1-m
1690 rpos=rpos+1
1700 PEN#2,2:LOCATE#2,x,rpos:PRINT#2,CHR$(254);:chrnums(rpos,x)=254
1710 PEN#2,5:LOCATE#2,x,rpos-1:PRINT#2,CHR$(32);:chrnums(rpos-1,x)=32
1720 NEXT
1730 posy=y
1740 rpos=posy-1
1750 FOR m2=1 TO space2
1760 y=y+1
1770 PEN#2,1:LOCATE#2,x,y:PRINT#2,CHR$(251);
1780 PEN#2,5:LOCATE#2,x,y-1:PRINT#2,CHR$(32);
1790 rpos=rPOS+1
1800 PEN#2,2:LOCATE#2,x,rpos:PRINT#2,CHR$(254):chrnums(rpos,x)=254
1810 PEN#2,5:LOCATE#2,x,rpos-1:PRINT#2,CHR$(32);:chrnums(rpos-1,x)=32
1820 NEXT
1830 SOUND 1,0,5,15,0,0,2
1840 FOR m3=2 TO rock2
1850 rpos=posy-m3
1860 FOR m4=1 TO space2
1870 rpos=rpos+1
1880 PEN#2,2:LOCATE#2,x,rpos:PRINT#2,CHR$(254);:chrnums(rpos,x)=254
1890 PEN#2,5:LOCATE#2,x,rpos-1:PRINT#2,CHR$(32);:chrnums(rpos-1,x)=32
1900 NEXT
1910 SOUND 1,0,5,15,0,0,2
1920 NEXT
1930 PEN#2,5:LOCATE#2,x,rpos:PRINT#2," ";:chrnums(rpos,x)=32
1940 PEN#2,2:LOCATE#2,x,y:PRINT#2,CHR$(254);:chrnums(y,x)=254
1950 FOR i=1 TO 50:SOUND 1,i*20,1:SOUND 4,i*20+5,1:NEXT
1960 x=x(screen):y=y(screen)
1970 droids=droids-1
1980 LOCATE#6,3,1:PRINT#6,USING"#";droids;
1990 RETURN
2000 RESTORE 2000:RETURN:'screen 1
2010 DATA @@@@[[+[+[+[[@@@@@+@@@[@@***@@[@@@@@+*@@@@*[[[*@@@@@@@[[@@@@@@@@@@@@@@@@@@+@@@@@@@@@@+@@@@+@+@@@[[[[[[[@@@@@ 
2020 DATA *@+@@@@@@+@@@*[@@@[[+@@@[[++@[[@@@@@[/+@@@@@*@@[@@@@@@[[@@@@@[[[[[@@@@@@**@@@@@@++[@@@@@@@@@@@@@@@++[@@@@@@@
2030 DATA +@@@@@@@++@@@@[@@@[@@@@@@@[*@@@@[@@@+@[@@@@@@[@@[[[@@@*@[@@@@@@@@@@@@@@@+@[@@@@@@@@@@@@@@@+@@@@@@@@@@@@@@@@
2040 RESTORE 2040:RETURN:' screen 2
2050 DATA +@@@+@@+@+@[@+@@@@*@@@@@+*@@@@@*@@+@[[[[[[[[[[[[[@@@*@[**[**++++[@[*@[[@[@+[@+*@@*+@[@@@[@[@*[@@+@@@@@[@@@[@
2060 DATA [*.[@@[@+[@@[@@@[@[/.[@@[[++@@[@@@[@[[.[@@++++@@[@@@[@@@.[@@***+@@[@@@[@@@[[@@@@@+@@[@@@[@@@@[@@@@@+@@[[@@[@
2070 DATA @@@[[+[[@+@@[@@@@@@@@@@@@[@+@@[@@@@@@@@@@@@[@*@@[@@[[@@@@@@@@[@@@@[@@@@@@@@@[[[[[[[@[@@@@@@@@@@@@@@@@@@@@@@@
2080 RESTORE 2080:RETURN:' screen 3
2090 DATA [+[*[[[[[[[[[[[[*+[*+@+[/.......[[[+@[@@@[[[[[[[[+[[[+[++++@.......*...@[[[[+[[[[[[[[+[[.@@@@@@[[[[[[[[+[[.@
2100 DATA @@@@@[[[[[[[[+[..@+@++@[.......*..[[+**++[@[[[[[[[[[[[[[[@@[@@@@@@@@@[*[@@[@@[@@@@@@@[@@+[@@@@@[@@@@@@@@[@@[
2110 DATA @@[**[@**@@@@@@[[[@@[@[[@@@[[++@@@[[[[[+[[+[[[[**+@@@[+[**@**@@*[@@@@@@@+[@@@@@@*@[@@@@@@@*@@@@@@@@@@@@@@@@@
2120 RESTORE 2120:RETURN:' screen 4
2130 DATA @@**@+++++[[+[@@@@+++++[@**@[/*[@@@@@@***[[@@@[[.[@@@@@@@@.[[+[@@@.[@@@@@@[[.[*+[@@@[[@@@@@@@@.[*+[@@@@@@@@@
2140 DATA @@@@.[[+[+@@@@@@[[@@@@@[[+[*@@@@@@[*@@@@@[[+[.++++@@@+@@[[[[@@[*****@@@+@@[+[[[@[[[[[[[[[+@@[***[@@@@@@@@@[+
2150 DATA @@[.@@@@@@[[[[[@[+@@[.[[[+@@[+++[@[+@@[.[*[+@@[*@*[@@+@@[*[+[*@@@@@[[@@@@@[[[@@*@@@@@@@@@[@@@@@@[*@@@@@@@@@
2160 RESTORE 2160:RETURN:' Screen 5
2170 DATA [@@@@@@@@@@@@@@@@@[@[[[@@[[[[[[[[[[@+@[*[@@[/.....*@[@+@[+[@@[[[[[[[[+[@*@[+[@@@@++++@[+[@+@[+[[[[@****@[+[@
2180 DATA *@[+@@@[@....@[+[@*@[+[[@[[....@[+[@*@[+[@@[******[+[@[@[+[@@[[[[[[[[+[@[@[+[@@@@@[[[[[@@@+@[+[@@@[@+++++@@@
2190 DATA +@[+[@@@[*******@@*@[@@@@@[[[[[[[@@@+@[@[@@@[++++@[@@@*@[@[@@@[****@[@@@[[[*@@@[*@@@@@*@@@[[[[[@@@@@@@@@@@@@
2200 RESTORE 2200:RETURN:' Screen 6
2210 DATA @@@@@@@****@@@@@@@@[[[[[[[[[[[[[[[[@@[+***********@@[@*[++[[[[[[[[[[@@[**[++[@@***@@[[*@[**[+*[@+[[[[@+[.[[*
2220 DATA *[+[[*+[++[@@[.*[*@[+*[*+[*@[+@[.*[@@[@*[*+[./[@*[.@[@@[@+[*[[.[[@[[.*[@@[*+[**[++[@[[[.[@@[*+[@@@+@*@@[*.[@
2230 DATA @[*+[[[[+[[[[[*.[@@[@*@@@@**+*@[@[[@@[[*@@@+*+**@@@*[@@[[[[[[[*[[[[[[[[@@[*+@@@@@+[++++++@@[[@@+++@********@
