10 ' ********************************************
20 ' * Sprite Generator Written By Jason Brooks *
30 ' * Converted from the ARCHIMEDES by myself. *
40 ' * Conversion Started on 23rd September '89 *
50 ' ********************************************
60 '
70 ' Ensure 2 K Buffer
80 'OPENOUT"dummy":MEMORY HIMEM-1:CLOSEOUT
90 ' Initialize Variables
100 DEFINT a-z:DIM col(15,2):down$=CHR$(10)+CHR$(10):template$="0123456789":l=1:k=1:m=50:block$=CHR$(24)+" "+CHR$(24):boxy=0:brush=1:block1$=CHR$(24)+"*"+CHR$(24)
110 opp=1:opp1=1
120 cursor.left=8:cursor.right=1:cursor.down=2:cursor.up=0:spray=21:colour.left=71:colour.right=63:sprite.save=60:sprite.load=36:sprite.clear=16
130 cut=68:toggle.spr.box=51:toggle.grid=43:paste=27
140 ' Set Up Screen Mode & Colours
150 '
160 'CALL &BBFF:CALL &BC02:MODE 1:BORDER 0:INK 0,0
170 MODE 2:PRINT"Which Mode Do You Wish To Design Your Sprites In ? ";:GOSUB 540:md=VAL(b$):IF md>2 THEN 170
180 l=2:x=md*20+16:mo=2^(2-md)
190 ' Select Sprite Grid Size
200 CLS:LOCATE 1,1:PRINT"Enter Grid Size":PRINT:PRINT"Maximum = ";m:LOCATE 1,5:PRINT"X - Length =   ";CHR$(8);CHR$(8);:GOSUB 540:gridx=VAL(b$):IF gridx>m OR gridx<1 THEN 200
210 LOCATE 1,7:PRINT"Y - Length =   ";CHR$(8);CHR$(8);:GOSUB 540:gridy=VAL(b$):IF gridy>m OR gridy<1 THEN 210
220 ' Set Up Array For Sprite Cell
230 '
240 DIM sprite(gridx,gridy),paste(gridx,gridy)
250 ' Set Up Pallette
260 '
270 FOR i=0 TO 15:col(i,1)=i:col(i,2)=i:NEXT
280 col=2^(mo)-1:template1$=LEFT$("0123456789ABCDEF",col+1)
290 GOSUB 1560
300 boxx=gridx*lx+(2*mo)
310 IF set=1 THEN GOSUB 1580
320 GOSUB 1530
330 GOSUB 1820
340 bx=gridx/2:by=gridy/2
350 GOSUB 870
360 ' Un-Draw Cursor
370 '
380 IF INKEY(cursor.left)>-1 THEN bx=bx-1:IF bx=0 THEN bx=gridx
390 IF INKEY(cursor.right)>-1 THEN bx=bx+1:IF bx=gridx+1 THEN bx=1
400 IF INKEY(cursor.up)>-1 THEN by=by+1:IF by=gridy+1 THEN by=1
410 IF INKEY(cursor.down)>-1 THEN by=by-1:IF by=0 THEN by=gridy
420 IF INKEY(spray)>-1 THEN GOSUB 980
430 IF INKEY(sprite.load)>-1 THEN 1620
440 IF INKEY(sprite.save)>-1 THEN GOTO 1220
450 IF INKEY(sprite.clear)>-1 THEN GOSUB 1450
460 IF INKEY(colour.left)>-1 THEN i=1:GOSUB 1180
470 IF INKEY(colour.right)>-1 THEN i=2:GOSUB 1180
480 IF INKEY(cut)>-1 THEN cx=bx:cy=by:cutf=1:LOCATE 1,3:PRINT"Function = CUT"
490 IF INKEY(toggle.spr.box)>-1 THEN opp1=opp1 XOR 1:GOSUB 1820
500 IF INKEY(toggle.grid)>-1 THEN opp=opp XOR 1:GOSUB 1570
501 IF INKEY(paste)>-1 THEN GOSUB 5000
510 GOSUB 760:GOSUB 1100
520 ' Draw Cursor & Brush Change ?
530 GOTO 350
540 ' Input Routine: Exits With String Variable 'b' With Chars typed
550 ' Enter with variable 'l' for length of string required
560 ' And enter with variable 'template' for stencil required
570 '
580 b$=""
590 a$=UPPER$(INKEY$):IF a$="" THEN 590
600 IF a$=CHR$(13) THEN numb=VAL(b$):RETURN
610 IF a$=CHR$(127) THEN GOSUB 650
620 IF INSTR(template$,a$)=0 THEN 590
630 IF LEN(b$)=l THEN RETURN
640 b$=b$+a$:PRINT a$;:GOTO 590
650 ' Delete Character From B$ If Possible And Delete Character From Screen.
660 ' Routine uses variable 'a' for calculations
670 '
680 IF b$="" THEN RETURN
690 a=LEN(b$):IF a=1 THEN b$="":GOTO 710
700 a=a-1:b$=LEFT$(b$,a)
710 PRINT CHR$(8);CHR$(32);CHR$(8);:RETURN
720 ' Display A Slab Of Colour
730 ' Display The Pen Number In Hex.
740 LOCATE i+1,1:PEN i:PRINT block$;:PEN 1:LOCATE i+1,2:PRINT HEX$(i);:IF brush=i THEN PEN brush:LOCATE i+1,1:PRINT block1$;
750 RETURN
760 ' Draw Cursor
770 cbrush=cbrush+1:IF cbrush>13 THEN cbrush=2
780 IF cutf<>0 THEN 800
790 MOVE (bx-1)*lx,(by-1)*ly:DRAWR lx,0,cbrush:DRAWR 0,ly:DRAWR -lx,0:DRAWR 0,-ly:RETURN
800 MOVE (cx-1)*lx,(cy-1)*ly
810 opp2=cbrush
820 IF (cx<bx OR cx=bx) AND (cy<by OR cy=by) THEN 1980
830 IF cx<bx OR cx=bx AND cy>by THEN 2040
840 IF bx<cx AND (by>cy OR by=cy) THEN 2100
850 IF bx<cx AND by<cy THEN 2160
860 RETURN
870 ' Un-Draw Cursor
880 '
890 IF cutf<>0 THEN 910
900 MOVE (bx-1)*lx,(by-1)*ly:DRAWR lx,0,opp:DRAWR 0,ly:DRAWR -lx,0:DRAWR 0,-ly:RETURN
910 MOVE (cx-1)*lx,(cy-1)*ly
920 opp2=opp1
930 IF (cx<bx OR cx=bx) AND (cy<by OR cy=by) THEN 1980
940 IF cx<bx OR cx=bx AND cy>by THEN 2040
950 IF bx<cx AND (by>cy OR by=cy) THEN 2100
960 IF bx<cx AND by<cy THEN 2160
970 RETURN
980 ' Toggle Block On Screen.
990 '
1000 IF cutf=1 THEN 1840
1010 sprite(bx,by)=brush
1020 height=(by+1)*ly-(by*ly)-4
1030 length=(bx+1)*lx-(bx*lx)-(2*mo)
1040 fx=(bx-1)*lx+mo:fy=(by-1)*ly+2
1050 FOR i=0 TO height
1060 MOVE fx,fy+i:DRAWR length,0,brush
1070 NEXT
1080 PLOT boxx+(bx*mo),boxy+(by*2),brush
1090 RETURN
1100 'Does User Wish to Alter Brush
1110 '
1120 a$=UPPER$(INKEY$):IF a$="" THEN RETURN
1130 IF INSTR(template1$,a$)=0 THEN RETURN
1140 LOCATE brush+1,1:PEN brush:PRINT block$;:brush=VAL("&"+a$):i=brush:GOSUB 740:PEN 1
1150 'Clear Key Board Buffer
1160 '
1170 WHILE INKEY$<>"":WEND:RETURN
1180 'Cycle through current ink selected if user wishes.
1190 '
1200 a=col(brush,i):a=a+1:IF a=27 THEN a=0
1210 col(brush,i)=a:INK brush,col(brush,1),col(brush,2):RETURN
1220 ' Save Sprite Data, Ink Values And Mode Routine.
1230 '
1240 MODE 1:PEN 1:INK 1,26:INK 0,0:PAPER 0:CLS
1250 template$="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ.-:"
1260 l=16
1270 PRINT"Please Enter File Name To Save Data":PRINT:PRINT"> ";
1280 GOSUB 1150
1290 GOSUB 580
1300 MODE 1:PRINT"Thank you. SAVEing :";b$
1310 OPENOUT b$
1320 ' Write Sprite Mode
1330 WRITE #9,md
1340 ' Write Size Of Matrix
1350 WRITE #9,gridx,gridy
1360 ' Write Ink Values
1370 FOR i=0 TO 15:WRITE #9,col(i,1),col(i,2):NEXT
1380 ' Write Sprite Data
1390 wri$=""
1400 FOR i=1 TO gridx:FOR t=1 TO gridy
1410 wri$=wri$+HEX$(sprite(i,t),1):NEXT t:WRITE#9,wri$:wri$="":NEXT i
1420 ' Close Down Sprite File
1430 CLOSEOUT
1440 MODE md:GOTO 290
1450 'Clear Grid Routine:
1460 GOSUB 1150:LOCATE 1,3:PEN 1:PRINT"Are You Sure ?"
1470 GOSUB 1780:LOCATE 1,3:PRINT SPACE$(15);:IF an=0 THEN RETURN
1480 FOR i=0 TO gridy*ly:MOVE 0,i:DRAW gridx*lx,i,brush:NEXT:GOSUB 1570
1490 FOR i=1 TO gridy:MOVE boxx+mo,i*2:DRAW boxx+(mo*gridx),i*2,brush:NEXT
1500 FOR i=1 TO gridx:FOR t=1 TO gridy
1510 sprite(i,t)=brush:NEXT t,i
1520 RETURN
1530 ' Set Inks To Ones In Array COL
1540 FOR i=0 TO col:GOSUB 720:INK i,col(i,1),col(i,2):NEXT:RETURN
1550 'Set Mode & Calculate offsets
1560 MODE md:ORIGIN 0,0:MOVE 0,0:ly=INT(336/gridy) AND 510:lx=INT(399/gridx) AND 510:lx=lx+(lx MOD mo)
1570 FOR i=0 TO gridy:MOVE 0,i*ly:DRAW gridx*lx,i*ly,opp:NEXT:FOR i=0 TO gridx:MOVE i*lx,0:DRAW i*lx,gridy*ly:NEXT:RETURN
1580 ' Re-Draw Grid.
1590 obx=bx:oby=by:FOR bx=1 TO gridx:FOR by=1 TO gridy:brush=sprite(bx,by)
1600 IF brush<>0 THEN GOSUB 890
1610 NEXT by,bx:bx=obx:by=oby:GOSUB 1570:RETURN
1620 ' Load In Sprite Data
1630 MODE 1:PEN 1:INK 1,26:INK 0,0:PAPER 0:CLS:template$="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ.-:":l=16:PRINT"Please Enter File Name To Load Data":PRINT:PRINT"> ";:GOSUB 1150:GOSUB 580
1640 MODE 1:PRINT"Thank you. LOADing : ";b$
1650 OPENIN b$
1660 INPUT #9,nmd
1670 IF md<>nmd THEN MODE 1:PRINT"This Sprite Is Not For The Current Mode";CHR$(7):PRINT:PRINT"Do You Wish To Convert It To Mode";md:GOSUB 1780:IF an=0 THEN md=nmd
1680 INPUT #9,ngridx,ngridy:IF ngridy>gridy OR ngridx>gridx THEN ERASE sprite:DIM sprite(ngridx,ngridy):gridx=ngridx:gridy=ngridy:GOTO 1700
1690 IF ngridx<gridx OR ngridy<gridy THEN MODE 2:PRINT"This Sprite Is Smaller Than Your Template":PRINT:PRINT"Do You Wish to Convert it":GOSUB 1780:IF an=0 THEN ERASE sprite:DIM sprite(ngridx,ngridy):gridx=ngridx:gridy=ngridy
1700 ' Get Ink Colours
1710 FOR i=0 TO 15:INPUT #9,col(i,1),col(i,2):NEXT
1720 ' Get Sprite
1730 FOR i=1 TO ngridx
1740 INPUT#9,wri$:FOR t=1 TO ngridy:sprite(i,t)=VAL("&"+MID$(wri$,t,1)):NEXT t
1750 NEXT i
1760 CLOSEIN
1770 MODE md:bx=1:by=1:set=1:GOTO 290
1780 ' Input Yes/No Exit With an=0 = No and an=1 for Yes
1790 a$=UPPER$(INKEY$):IF a$<>"Y" AND a$<>"N" THEN 1790
1800 IF a$="Y" THEN an=1 ELSE an=0
1810 RETURN
1820 'Toggle Sprite Border
1830 MOVE boxx,boxy:DRAW boxx+(gridx*mo+mo),boxy,opp1:DRAW boxx+(gridx*mo+mo),gridy*2+2:DRAW boxx,gridy*2+2:DRAW boxx,boxy:RETURN
1840 ' Select Section Of Matrix To Copy Display On The Screen And Reset Flag.
1841 LOCATE 1,3:PRINT SPACE$(15);
1850 cx1=bx:cy1=by
1860 IF cx>cx1 THEN cx2=cx:cx=cx1:cx1=cx2
1870 IF cy>cy1 THEN cy2=cy:cy=cy1:cy1=cy2
1871 FOR i=0 TO 108 STEP 2:MOVE boxx,gridy*2+(6+i):DRAWR 50*mo+2*mo,0,0:NEXT
1880 MOVE boxx,gridy*2+6
1890 DRAWR (cx1-cx)*mo+2*mo,0,1:DRAWR 0,(cy1-cy)*2+4
1900 DRAWR -(2*mo+(cx1-cx)*mo),0:DRAWR 0,-((cy1-cy)*2+4)
1910 pastel=cx1-cx+1
1920 pastew=cy1-cy+1
1930 FOR i=1 TO pastew:FOR t=1 TO pastel
1940 paste(t,i)=sprite(t+cx-1,i+cy-1)
1950 PLOT boxx+t*mo,(gridy*2)+6+i*2,paste(t,i)
1960 NEXT t,i
1970 cutf=0:pastef=1:RETURN
1980 'Box Section Top Right
1990 DRAWR lx*(bx-cx+1),0,opp2
2000 DRAWR 0,ly*(by-cy+1)
2010 DRAWR -lx*(bx-cx+1),0
2020 DRAWR 0,-ly*(by-cy+1)
2030 RETURN
2040 'Box Section Top Right
2050 DRAWR lx*(bx-cx+1),0,opp2
2060 DRAWR 0,-ly*(cy-by)
2070 DRAWR -lx*(bx-cx+1),0
2080 DRAWR 0,ly*(cy-by)
2090 RETURN
2100 'Box Bottom Right
2110 DRAWR lx*(bx-cx),0,opp2
2120 DRAWR 0,ly*(by-cy+1)
2130 DRAWR -lx*(bx-cx),0
2140 DRAWR 0,-ly*(by-cy+1)
2150 RETURN
2160 DRAWR lx*(bx-cx),0,opp2
2170 DRAWR 0,-ly*(cy-by)
2180 DRAWR -lx*(bx-cx),0
2190 DRAWR 0,ly*(cy-by)
2200 RETURN
5000 'Paste The Sprite At Current Cursor Position.
5010 IF pastel=0 THEN RETURN
5020 px=bx:py=by
5030 WHILE px<>pastew AND px<gridx
5040 sprite(px+t-1,py+i-1)=paste(t,i):GOSUB 980
5050 px=px+1
5060 WEND
