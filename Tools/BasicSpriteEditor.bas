10 ' ********************************************
20 ' * Sprite Generator Written By Jason Brooks *
30 ' * Converted from the ARCHIMEDES by myself. *
40 ' * Conversion Started on 23rd September '89 *
50 ' ********************************************
60 '
70 ' Ensure 2 K Buffer
80 OPENOUT"dummy":MEMORY HIMEM-1:CLOSEOUT
90 ' Initialize Variables
100 DEFINT a-z:DIM col(15,2):down$=CHR$(10)+CHR$(10):template$="0123456789":l=1:k=1:m=50:block$=CHR$(24)+" "+CHR$(24):boxy=0:brush=1
:block1$=CHR$(24)+"*"+CHR$(24)
110 opp=1:opp1=1
120 cursor.left=8:cursor.right=1:cursor.down=2:cursor.up=0:spray=21:colour.left=71:colour.right=63:sprite.save=60:sprite.load=36:spr
ite.clear=16
130 cut=68:toggle.spr.box=51:toggle.grid=43:paste=27
140 ' Set Up Screen Mode & Colours
150 '
160 CALL &BBFF:CALL &BC02:MODE 1:BORDER 0:INK 0,0
170 MODE 2:PRINT"Which Mode Do You Wish To Design Your Sprites In ? ";:GOSUB 550:md=VAL(b$):IF md>2 THEN 170
180 l=2:x=md*20+16:mo=2^(2-md)
190 ' Select Sprite Grid Size
200 CLS:LOCATE 1,1:PRINT"Enter Grid Size":PRINT:PRINT"Maximum = ";m:LOCATE 1,5:PRINT"X - Length =   ";CHR$(8);CHR$(8);:GOSUB 550:gri
dx=VAL(b$):IF gridx>m OR gridx<1 THEN 200
210 LOCATE 1,7:PRINT"Y - Length =   ";CHR$(8);CHR$(8);:GOSUB 550:gridy=VAL(b$):IF gridy>m OR gridy<1 THEN 210
220 ' Set Up Array For Sprite Cell
230 '
240 DIM sprite(gridx,gridy),paste(gridx,gridy)
250 ' Set Up Pallette
260 '
270 FOR i=0 TO 15:col(i,1)=i:col(i,2)=i:NEXT
280 col=2^(mo)-1:template1$=LEFT$("0123456789ABCDEF",col+1)
290 GOSUB 1570
300 boxx=gridx*lx+(2*mo)
310 IF set=1 THEN GOSUB 1590
320 GOSUB 1540
330 GOSUB 1830
340 bx=gridx/2:by=gridy/2
350 GOSUB 880
360 ' Un-Draw Cursor
370 '
380 IF INKEY(cursor.left)>-1 THEN bx=bx-1:IF bx=0 THEN bx=gridx
390 IF INKEY(cursor.right)>-1 THEN bx=bx+1:IF bx=gridx+1 THEN bx=1
400 IF INKEY(cursor.up)>-1 THEN by=by+1:IF by=gridy+1 THEN by=1
410 IF INKEY(cursor.down)>-1 THEN by=by-1:IF by=0 THEN by=gridy
420 IF INKEY(spray)>-1 THEN GOSUB 990
430 IF INKEY(sprite.load)>-1 THEN 1630
440 IF INKEY(sprite.save)>-1 THEN 1230
450 IF INKEY(sprite.clear)>-1 THEN GOSUB 1460
460 IF INKEY(colour.left)>-1 THEN i=1:GOSUB 1190
470 IF INKEY(colour.right)>-1 THEN i=2:GOSUB 1190
480 IF INKEY(cut)>-1 THEN cx=bx:cy=by:cutf=1:LOCATE 1,3:PRINT"Function = CUT"
490 IF INKEY(toggle.spr.box)>-1 THEN opp1=opp1 XOR 1:GOSUB 1830
500 IF INKEY(toggle.grid)>-1 THEN opp=opp XOR 1:GOSUB 1580
510 IF INKEY(paste)>-1 THEN GOSUB 2240
520 GOSUB 770:GOSUB 1110
530 ' Draw Cursor & Brush Change ?
540 GOTO 350
550 ' Input Routine: Exits With String Variable 'b' With Chars typed
560 ' Enter with variable 'l' for length of string required
570 ' And enter with variable 'template' for stencil required
580 '
590 b$=""
600 a$=UPPER$(INKEY$):IF a$="" THEN 600
610 IF a$=CHR$(13) THEN numb=VAL(b$):RETURN
620 IF a$=CHR$(127) THEN GOSUB 660
630 IF INSTR(template$,a$)=0 THEN 600
640 IF LEN(b$)=l THEN RETURN
650 b$=b$+a$:PRINT a$;:GOTO 600
660 ' Delete Character From B$ If Possible And Delete Character From Screen.
670 ' Routine uses variable 'a' for calculations
680 '
690 IF b$="" THEN RETURN
700 a=LEN(b$):IF a=1 THEN b$="":GOTO 720
710 a=a-1:b$=LEFT$(b$,a)
720 PRINT CHR$(8);CHR$(32);CHR$(8);:RETURN
730 ' Display A Slab Of Colour
740 ' Display The Pen Number In Hex.
750 LOCATE i+1,1:PEN i:PRINT block$;:PEN 1:LOCATE i+1,2:PRINT HEX$(i);:IF brush=i THEN PEN brush:LOCATE i+1,1:PRINT block1$;
760 RETURN
770 ' Draw Cursor
780 cbrush=cbrush+1:IF cbrush>13 THEN cbrush=2
790 IF cutf<>0 THEN 810
800 MOVE (bx-1)*lx,(by-1)*ly:DRAWR lx,0,cbrush:DRAWR 0,ly:DRAWR -lx,0:DRAWR 0,-ly:RETURN
810 MOVE (cx-1)*lx,(cy-1)*ly
820 opp2=cbrush
830 IF (cx<bx OR cx=bx) AND (cy<by OR cy=by) THEN 2010
840 IF cx<bx OR cx=bx AND cy>by THEN 2070
850 IF bx<cx AND (by>cy OR by=cy) THEN 2130
860 IF bx<cx AND by<cy THEN 2190
870 RETURN
880 ' Un-Draw Cursor
890 '
900 IF cutf<>0 THEN 920
910 MOVE (bx-1)*lx,(by-1)*ly:DRAWR lx,0,opp:DRAWR 0,ly:DRAWR -lx,0:DRAWR 0,-ly:RETURN
920 MOVE (cx-1)*lx,(cy-1)*ly
930 opp2=opp1
940 IF (cx<bx OR cx=bx) AND (cy<by OR cy=by) THEN 2010
950 IF cx<bx OR cx=bx AND cy>by THEN 2070
960 IF bx<cx AND (by>cy OR by=cy) THEN 2130
970 IF bx<cx AND by<cy THEN 2190
980 RETURN
990 ' Toggle Block On Screen.
1000 '
1010 IF cutf=1 THEN 1850
1020 sprite(bx,by)=brush
1030 height=(by+1)*ly-(by*ly)-4
1040 length=(bx+1)*lx-(bx*lx)-(2*mo)
1050 fx=(bx-1)*lx+mo:fy=(by-1)*ly+2
1060 FOR i=0 TO height
1070 MOVE fx,fy+i:DRAWR length,0,brush
1080 NEXT
1090 PLOT boxx+(bx*mo),boxy+(by*2),brush
1100 RETURN
1110 'Does User Wish to Alter Brush
1120 '
1130 a$=UPPER$(INKEY$):IF a$="" THEN RETURN
1140 IF INSTR(template1$,a$)=0 THEN RETURN
1150 LOCATE brush+1,1:PEN brush:PRINT block$;:brush=VAL("&"+a$):i=brush:GOSUB 750:PEN 1
1160 'Clear Key Board Buffer
1170 '
1180 WHILE INKEY$<>"":WEND:RETURN
1190 'Cycle through current ink selected if user wishes.
1200 '
1210 a=col(brush,i):a=a+1:IF a=27 THEN a=0
1220 col(brush,i)=a:INK brush,col(brush,1),col(brush,2):RETURN
1230 ' Save Sprite Data, Ink Values And Mode Routine.
1240 '
1250 MODE 1:PEN 1:INK 1,26:INK 0,0:PAPER 0:CLS
1260 template$="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ.-:"
1270 l=16
1280 PRINT"Please Enter File Name To Save Data":PRINT:PRINT"> ";
1290 GOSUB 1160
1300 GOSUB 590
1310 MODE 1:PRINT"Thank you. SAVEing :";b$
1320 OPENOUT b$
1330 ' Write Sprite Mode
1340 WRITE #9,md
1350 ' Write Size Of Matrix
1360 WRITE #9,gridx,gridy
1370 ' Write Ink Values
1380 FOR i=0 TO 15:WRITE #9,col(i,1),col(i,2):NEXT
1390 ' Write Sprite Data
1400 wri$=""
1410 FOR i=1 TO gridx:FOR t=1 TO gridy
1420 wri$=wri$+HEX$(sprite(i,t),1):NEXT t:WRITE#9,wri$:wri$="":NEXT i
1430 ' Close Down Sprite File
1440 CLOSEOUT
1450 MODE md:set=1:GOTO 290
1460 'Clear Grid Routine:
1470 GOSUB 1160:LOCATE 1,3:PEN 1:PRINT"Are You Sure ?"
1480 GOSUB 1790:LOCATE 1,3:PRINT SPACE$(15);:IF an=0 THEN RETURN
1490 FOR i=0 TO gridy*ly:MOVE 0,i:DRAW gridx*lx,i,brush:NEXT:GOSUB 1580
1500 FOR i=1 TO gridy:MOVE boxx+mo,i*2:DRAW boxx+(mo*gridx),i*2,brush:NEXT
1510 FOR i=1 TO gridx:FOR t=1 TO gridy
1520 sprite(i,t)=brush:NEXT t,i
1530 RETURN
1540 ' Set Inks To Ones In Array COL
1550 FOR i=0 TO col:GOSUB 730:INK i,col(i,1),col(i,2):NEXT:RETURN
1560 'Set Mode & Calculate offsets
1570 MODE md:ORIGIN 0,0:MOVE 0,0:ly=INT(336/gridy) AND 510:lx=INT(399/gridx) AND 510:lx=lx+(lx MOD mo)
1580 FOR i=0 TO gridy:MOVE 0,i*ly:DRAW gridx*lx,i*ly,opp:NEXT:FOR i=0 TO gridx:MOVE i*lx,0:DRAW i*lx,gridy*ly:NEXT:RETURN
1590 ' Re-Draw Grid.
1600 obx=bx:oby=by:FOR bx=1 TO gridx:FOR by=1 TO gridy:brush=sprite(bx,by)
1610 IF brush<>0 THEN GOSUB 990
1620 NEXT by,bx:bx=obx:by=oby:GOSUB 1580:RETURN
1630 ' Load In Sprite Data
1640 MODE 1:PEN 1:INK 1,26:INK 0,0:PAPER 0:CLS:template$="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ.-:":l=16:PRINT"Please Enter File Name
 To Load Data":PRINT:PRINT"> ";:GOSUB 1160:GOSUB 590
1650 MODE 1:PRINT"Thank you. LOADing : ";b$
1660 OPENIN b$
1670 INPUT #9,nmd
1680 IF md<>nmd THEN MODE 1:PRINT"This Sprite Is Not For The Current Mode";CHR$(7):PRINT:PRINT"Do You Wish To Convert It To Mode";md
:GOSUB 1790:IF an=0 THEN md=nmd
1690 INPUT #9,ngridx,ngridy:IF ngridy>gridy OR ngridx>gridx THEN ERASE sprite:DIM sprite(ngridx,ngridy):gridx=ngridx:gridy=ngridy:GO
TO 1710
1700 IF ngridx<gridx OR ngridy<gridy THEN MODE 2:PRINT"This Sprite Is Smaller Than Your Template":PRINT:PRINT"Do You Wish to Convert
 it":GOSUB 1790:IF an=0 THEN ERASE sprite:DIM sprite(ngridx,ngridy):gridx=ngridx:gridy=ngridy
1710 ' Get Ink Colours
1720 FOR i=0 TO 15:INPUT #9,col(i,1),col(i,2):NEXT
1730 ' Get Sprite
1740 FOR i=1 TO ngridx
1750 INPUT#9,wri$:FOR t=1 TO ngridy:sprite(i,t)=VAL("&"+MID$(wri$,t,1)):NEXT t
1760 NEXT i
1770 CLOSEIN
1780 MODE md:bx=1:by=1:set=1:GOTO 290
1790 ' Input Yes/No Exit With an=0 = No and an=1 for Yes
1800 a$=UPPER$(INKEY$):IF a$<>"Y" AND a$<>"N" THEN 1800
1810 IF a$="Y" THEN an=1 ELSE an=0
1820 RETURN
1830 'Toggle Sprite Border
1840 MOVE boxx,boxy:DRAW boxx+(gridx*mo+mo),boxy,opp1:DRAW boxx+(gridx*mo+mo),gridy*2+2:DRAW boxx,gridy*2+2:DRAW boxx,boxy:RETURN
1850 ' Select Section Of Matrix To Copy Display On The Screen And Reset Flag.
1860 LOCATE 1,3:PRINT SPACE$(15);
1870 cx1=bx:cy1=by
1880 IF cx>cx1 THEN cx2=cx:cx=cx1:cx1=cx2
1890 IF cy>cy1 THEN cy2=cy:cy=cy1:cy1=cy2
1900 FOR i=0 TO 108 STEP 2:MOVE boxx,gridy*2+(6+i):DRAWR 50*mo+2*mo,0,0:NEXT
1910 MOVE boxx,gridy*2+6
1920 DRAWR (cx1-cx)*mo+2*mo,0,1:DRAWR 0,(cy1-cy)*2+4
1930 DRAWR -(2*mo+(cx1-cx)*mo),0:DRAWR 0,-((cy1-cy)*2+4)
1940 pastel=cx1-cx+1
1950 pastew=cy1-cy+1
1960 FOR i=1 TO pastew:FOR t=1 TO pastel
1970 paste(t,i)=sprite(t+cx-1,i+cy-1)
1980 PLOT boxx+t*mo,(gridy*2)+6+i*2,paste(t,i)
1990 NEXT t,i
2000 cutf=0:pastef=1:RETURN
2010 'Box Section Top Right
2020 DRAWR lx*(bx-cx+1),0,opp2
2030 DRAWR 0,ly*(by-cy+1)
2040 DRAWR -lx*(bx-cx+1),0
2050 DRAWR 0,-ly*(by-cy+1)
2060 RETURN
2070 'Box Section Top Right
2080 DRAWR lx*(bx-cx+1),0,opp2
2090 DRAWR 0,-ly*(cy-by)
2100 DRAWR -lx*(bx-cx+1),0
2110 DRAWR 0,ly*(cy-by)
2120 RETURN
2130 'Box Bottom Right
2140 DRAWR lx*(bx-cx),0,opp2
2150 DRAWR 0,ly*(by-cy+1)
2160 DRAWR -lx*(bx-cx),0
2170 DRAWR 0,-ly*(by-cy+1)
2180 RETURN
2190 DRAWR lx*(bx-cx),0,opp2
2200 DRAWR 0,-ly*(cy-by)
2210 DRAWR -lx*(bx-cx),0
2220 DRAWR 0,ly*(cy-by)
2230 RETURN
2240 'Paste The Sprite At Current Cursor Position.
2250 IF pastel=0 THEN RETURN
2260 px=bx:py=by
2270 WHILE px<>pastew AND px<gridx
2280 sprite(px+t-1,py+i-1)=paste(t,i):GOSUB 990
2290 px=px+1
2300 WEND
10 ' ********************************************
20 ' * Sprite Generator Written By Jason Brooks *
30 ' * Converted from the ARCHIMEDES by myself. *
40 ' * Conversion Started on 23rd September '89 *
50 ' ********************************************
60 '
70 ' Ensure 2 K Buffer
80 OPENOUT"dummy":MEMORY HIMEM-1:CLOSEOUT
90 ' Initialize Variables
100 DEFINT a-z:DIM col(15,2):down$=CHR$(10)+CHR$(10):template$="0123456789":l=1:k=1:m=50:block$=CHR$(24)+" "+CHR$(24):boxy=0:brush=1
:block1$=CHR$(24)+"*"+CHR$(24)
110 opp=1:opp1=1
120 cursor.left=8:cursor.right=1:cursor.down=2:cursor.up=0:spray=21:colour.left=71:colour.right=63:sprite.save=60:sprite.load=36:spr
ite.clear=16
130 cut=68:toggle.spr.box=51:toggle.grid=43:paste=27
140 ' Set Up Screen Mode & Colours
150 '
160 CALL &BBFF:CALL &BC02:MODE 1:BORDER 0:INK 0,0
170 MODE 2:PRINT"Which Mode Do You Wish To Design Your Sprites In ? ";:GOSUB 550:md=VAL(b$):IF md>2 THEN 170
180 l=2:x=md*20+16:mo=2^(2-md)
190 ' Select Sprite Grid Size
200 CLS:LOCATE 1,1:PRINT"Enter Grid Size":PRINT:PRINT"Maximum = ";m:LOCATE 1,5:PRINT"X - Length =   ";CHR$(8);CHR$(8);:GOSUB 550:gri
dx=VAL(b$):IF gridx>m OR gridx<1 THEN 200
210 LOCATE 1,7:PRINT"Y - Length =   ";CHR$(8);CHR$(8);:GOSUB 550:gridy=VAL(b$):IF gridy>m OR gridy<1 THEN 210
220 ' Set Up Array For Sprite Cell
230 '
240 DIM sprite(gridx,gridy),paste(gridx,gridy)
250 ' Set Up Pallette
260 '
270 FOR i=0 TO 15:col(i,1)=i:col(i,2)=i:NEXT
280 col=2^(mo)-1:template1$=LEFT$("0123456789ABCDEF",col+1)
290 GOSUB 1570
300 boxx=gridx*lx+(2*mo)
310 IF set=1 THEN GOSUB 1590
320 GOSUB 1540
330 GOSUB 1830
340 bx=gridx/2:by=gridy/2
350 GOSUB 880
360 ' Un-Draw Cursor
370 '
380 IF INKEY(cursor.left)>-1 THEN bx=bx-1:IF bx=0 THEN bx=gridx
390 IF INKEY(cursor.right)>-1 THEN bx=bx+1:IF bx=gridx+1 THEN bx=1
400 IF INKEY(cursor.up)>-1 THEN by=by+1:IF by=gridy+1 THEN by=1
410 IF INKEY(cursor.down)>-1 THEN by=by-1:IF by=0 THEN by=gridy
420 IF INKEY(spray)>-1 THEN GOSUB 990
430 IF INKEY(sprite.load)>-1 THEN 1630
440 IF INKEY(sprite.save)>-1 THEN 1230
450 IF INKEY(sprite.clear)>-1 THEN GOSUB 1460
460 IF INKEY(colour.left)>-1 THEN i=1:GOSUB 1190
470 IF INKEY(colour.right)>-1 THEN i=2:GOSUB 1190
480 IF INKEY(cut)>-1 THEN cx=bx:cy=by:cutf=1:LOCATE 1,3:PRINT"Function = CUT"
490 IF INKEY(toggle.spr.box)>-1 THEN opp1=opp1 XOR 1:GOSUB 1830
500 IF INKEY(toggle.grid)>-1 THEN opp=opp XOR 1:GOSUB 1580
510 IF INKEY(paste)>-1 THEN GOSUB 2240
520 GOSUB 770:GOSUB 1110
530 ' Draw Cursor & Brush Change ?
540 GOTO 350
550 ' Input Routine: Exits With String Variable 'b' With Chars typed
560 ' Enter with variable 'l' for length of string required
570 ' And enter with variable 'template' for stencil required
580 '
590 b$=""
600 a$=UPPER$(INKEY$):IF a$="" THEN 600
610 IF a$=CHR$(13) THEN numb=VAL(b$):RETURN
620 IF a$=CHR$(127) THEN GOSUB 660
630 IF INSTR(template$,a$)=0 THEN 600
640 IF LEN(b$)=l THEN RETURN
650 b$=b$+a$:PRINT a$;:GOTO 600
660 ' Delete Character From B$ If Possible And Delete Character From Screen.
670 ' Routine uses variable 'a' for calculations
680 '
690 IF b$="" THEN RETURN
700 a=LEN(b$):IF a=1 THEN b$="":GOTO 720
710 a=a-1:b$=LEFT$(b$,a)
720 PRINT CHR$(8);CHR$(32);CHR$(8);:RETURN
730 ' Display A Slab Of Colour
740 ' Display The Pen Number In Hex.
750 LOCATE i+1,1:PEN i:PRINT block$;:PEN 1:LOCATE i+1,2:PRINT HEX$(i);:IF brush=i THEN PEN brush:LOCATE i+1,1:PRINT block1$;
760 RETURN
770 ' Draw Cursor
780 cbrush=cbrush+1:IF cbrush>13 THEN cbrush=2
790 IF cutf<>0 THEN 810
800 MOVE (bx-1)*lx,(by-1)*ly:DRAWR lx,0,cbrush:DRAWR 0,ly:DRAWR -lx,0:DRAWR 0,-ly:RETURN
810 MOVE (cx-1)*lx,(cy-1)*ly
820 opp2=cbrush
830 IF (cx<bx OR cx=bx) AND (cy<by OR cy=by) THEN 2010
840 IF cx<bx OR cx=bx AND cy>by THEN 2070
850 IF bx<cx AND (by>cy OR by=cy) THEN 2130
860 IF bx<cx AND by<cy THEN 2190
870 RETURN
880 ' Un-Draw Cursor
890 '
900 IF cutf<>0 THEN 920
910 MOVE (bx-1)*lx,(by-1)*ly:DRAWR lx,0,opp:DRAWR 0,ly:DRAWR -lx,0:DRAWR 0,-ly:RETURN
920 MOVE (cx-1)*lx,(cy-1)*ly
930 opp2=opp1
940 IF (cx<bx OR cx=bx) AND (cy<by OR cy=by) THEN 2010
950 IF cx<bx OR cx=bx AND cy>by THEN 2070
960 IF bx<cx AND (by>cy OR by=cy) THEN 2130
970 IF bx<cx AND by<cy THEN 2190
980 RETURN
990 ' Toggle Block On Screen.
1000 '
1010 IF cutf=1 THEN 1850
1020 sprite(bx,by)=brush
1030 height=(by+1)*ly-(by*ly)-4
1040 length=(bx+1)*lx-(bx*lx)-(2*mo)
1050 fx=(bx-1)*lx+mo:fy=(by-1)*ly+2
1060 FOR i=0 TO height
1070 MOVE fx,fy+i:DRAWR length,0,brush
1080 NEXT
1090 PLOT boxx+(bx*mo),boxy+(by*2),brush
1100 RETURN
1110 'Does User Wish to Alter Brush
1120 '
1130 a$=UPPER$(INKEY$):IF a$="" THEN RETURN
1140 IF INSTR(template1$,a$)=0 THEN RETURN
1150 LOCATE brush+1,1:PEN brush:PRINT block$;:brush=VAL("&"+a$):i=brush:GOSUB 750:PEN 1
1160 'Clear Key Board Buffer
1170 '
1180 WHILE INKEY$<>"":WEND:RETURN
1190 'Cycle through current ink selected if user wishes.
1200 '
1210 a=col(brush,i):a=a+1:IF a=27 THEN a=0
1220 col(brush,i)=a:INK brush,col(brush,1),col(brush,2):RETURN
1230 ' Save Sprite Data, Ink Values And Mode Routine.
1240 '
1250 MODE 1:PEN 1:INK 1,26:INK 0,0:PAPER 0:CLS
1260 template$="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ.-:"
1270 l=16
1280 PRINT"Please Enter File Name To Save Data":PRINT:PRINT"> ";
1290 GOSUB 1160
1300 GOSUB 590
1310 MODE 1:PRINT"Thank you. SAVEing :";b$
1320 OPENOUT b$
1330 ' Write Sprite Mode
1340 WRITE #9,md
1350 ' Write Size Of Matrix
1360 WRITE #9,gridx,gridy
1370 ' Write Ink Values
1380 FOR i=0 TO 15:WRITE #9,col(i,1),col(i,2):NEXT
1390 ' Write Sprite Data
1400 wri$=""
1410 FOR i=1 TO gridx:FOR t=1 TO gridy
1420 wri$=wri$+HEX$(sprite(i,t),1):NEXT t:WRITE#9,wri$:wri$="":NEXT i
1430 ' Close Down Sprite File
1440 CLOSEOUT
1450 MODE md:set=1:GOTO 290
1460 'Clear Grid Routine:
1470 GOSUB 1160:LOCATE 1,3:PEN 1:PRINT"Are You Sure ?"
1480 GOSUB 1790:LOCATE 1,3:PRINT SPACE$(15);:IF an=0 THEN RETURN
1490 FOR i=0 TO gridy*ly:MOVE 0,i:DRAW gridx*lx,i,brush:NEXT:GOSUB 1580
1500 FOR i=1 TO gridy:MOVE boxx+mo,i*2:DRAW boxx+(mo*gridx),i*2,brush:NEXT
1510 FOR i=1 TO gridx:FOR t=1 TO gridy
1520 sprite(i,t)=brush:NEXT t,i
1530 RETURN
1540 ' Set Inks To Ones In Array COL
1550 FOR i=0 TO col:GOSUB 730:INK i,col(i,1),col(i,2):NEXT:RETURN
1560 'Set Mode & Calculate offsets
1570 MODE md:ORIGIN 0,0:MOVE 0,0:ly=INT(336/gridy) AND 510:lx=INT(399/gridx) AND 510:lx=lx+(lx MOD mo)
1580 FOR i=0 TO gridy:MOVE 0,i*ly:DRAW gridx*lx,i*ly,opp:NEXT:FOR i=0 TO gridx:MOVE i*lx,0:DRAW i*lx,gridy*ly:NEXT:RETURN
1590 ' Re-Draw Grid.
1600 obx=bx:oby=by:FOR bx=1 TO gridx:FOR by=1 TO gridy:brush=sprite(bx,by)
1610 IF brush<>0 THEN GOSUB 990
1620 NEXT by,bx:bx=obx:by=oby:GOSUB 1580:RETURN
1630 ' Load In Sprite Data
1640 MODE 1:PEN 1:INK 1,26:INK 0,0:PAPER 0:CLS:template$="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ.-:":l=16:PRINT"Please Enter File Name
 To Load Data":PRINT:PRINT"> ";:GOSUB 1160:GOSUB 590
1650 MODE 1:PRINT"Thank you. LOADing : ";b$
1660 OPENIN b$
1670 INPUT #9,nmd
1680 IF md<>nmd THEN MODE 1:PRINT"This Sprite Is Not For The Current Mode";CHR$(7):PRINT:PRINT"Do You Wish To Convert It To Mode";md
:GOSUB 1790:IF an=0 THEN md=nmd
1690 INPUT #9,ngridx,ngridy:IF ngridy>gridy OR ngridx>gridx THEN ERASE sprite:DIM sprite(ngridx,ngridy):gridx=ngridx:gridy=ngridy:GO
TO 1710
1700 IF ngridx<gridx OR ngridy<gridy THEN MODE 2:PRINT"This Sprite Is Smaller Than Your Template":PRINT:PRINT"Do You Wish to Convert
 it":GOSUB 1790:IF an=0 THEN ERASE sprite:DIM sprite(ngridx,ngridy):gridx=ngridx:gridy=ngridy
1710 ' Get Ink Colours
1720 FOR i=0 TO 15:INPUT #9,col(i,1),col(i,2):NEXT
1730 ' Get Sprite
1740 FOR i=1 TO ngridx
1750 INPUT#9,wri$:FOR t=1 TO ngridy:sprite(i,t)=VAL("&"+MID$(wri$,t,1)):NEXT t
1760 NEXT i
1770 CLOSEIN
1780 MODE md:bx=1:by=1:set=1:GOTO 290
1790 ' Input Yes/No Exit With an=0 = No and an=1 for Yes
1800 a$=UPPER$(INKEY$):IF a$<>"Y" AND a$<>"N" THEN 1800
1810 IF a$="Y" THEN an=1 ELSE an=0
1820 RETURN
1830 'Toggle Sprite Border
1840 MOVE boxx,boxy:DRAW boxx+(gridx*mo+mo),boxy,opp1:DRAW boxx+(gridx*mo+mo),gridy*2+2:DRAW boxx,gridy*2+2:DRAW boxx,boxy:RETURN
1850 ' Select Section Of Matrix To Copy Display On The Screen And Reset Flag.
1860 LOCATE 1,3:PRINT SPACE$(15);
1870 cx1=bx:cy1=by
1880 IF cx>cx1 THEN cx2=cx:cx=cx1:cx1=cx2
1890 IF cy>cy1 THEN cy2=cy:cy=cy1:cy1=cy2
1900 FOR i=0 TO 108 STEP 2:MOVE boxx,gridy*2+(6+i):DRAWR 50*mo+2*mo,0,0:NEXT
1910 MOVE boxx,gridy*2+6
1920 DRAWR (cx1-cx)*mo+2*mo,0,1:DRAWR 0,(cy1-cy)*2+4
1930 DRAWR -(2*mo+(cx1-cx)*mo),0:DRAWR 0,-((cy1-cy)*2+4)
1940 pastel=cx1-cx+1
1950 pastew=cy1-cy+1
1960 FOR i=1 TO pastew:FOR t=1 TO pastel
1970 paste(t,i)=sprite(t+cx-1,i+cy-1)
1980 PLOT boxx+t*mo,(gridy*2)+6+i*2,paste(t,i)
1990 NEXT t,i
2000 cutf=0:pastef=1:RETURN
2010 'Box Section Top Right
2020 DRAWR lx*(bx-cx+1),0,opp2
2030 DRAWR 0,ly*(by-cy+1)
2040 DRAWR -lx*(bx-cx+1),0
2050 DRAWR 0,-ly*(by-cy+1)
2060 RETURN
2070 'Box Section Top Right
2080 DRAWR lx*(bx-cx+1),0,opp2
2090 DRAWR 0,-ly*(cy-by)
2100 DRAWR -lx*(bx-cx+1),0
2110 DRAWR 0,ly*(cy-by)
2120 RETURN
2130 'Box Bottom Right
2140 DRAWR lx*(bx-cx),0,opp2
2150 DRAWR 0,ly*(by-cy+1)
2160 DRAWR -lx*(bx-cx),0
2170 DRAWR 0,-ly*(by-cy+1)
2180 RETURN
2190 DRAWR lx*(bx-cx),0,opp2
2200 DRAWR 0,-ly*(cy-by)
2210 DRAWR -lx*(bx-cx),0
2220 DRAWR 0,ly*(cy-by)
2230 RETURN
2240 'Paste The Sprite At Current Cursor Position.
2250 IF pastel=0 THEN RETURN
2260 px=bx:py=by
2270 WHILE px<>pastew AND px<gridx
2280 sprite(px+t-1,py+i-1)=paste(t,i):GOSUB 990
2290 px=px+1
2300 WEND
