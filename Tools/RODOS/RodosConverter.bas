10 ' Multi File Copier For RODOS-Amsdos etc.
20 ' Designed & Written By Jason Brooks 1989
30 CALL &BC02:CALL &BBFF:BORDER 0:INK 0,0:INK 1,26:PAPER 0:PEN 1:MODE 2
40 ' Initialize A 2K Buffer & Lower Himem
50 |TAPE:OPENOUT"d":MEMORY &5FFF:CLOSEOUT:|DISC
60 ' Format Silicon Disk
70 PRINT "Formatting Silicon Disc - In The Event Of A Prompt Press Y"
80 |FORMAT,2,8
90 ' Get Source & Destination Drives:-
100 MODE 2
110 template$="AB"
120 PRINT"Rodos To Amsdos To Rodos, A - B - A  Copier Created By Jason Brooks 1989"
130 PRINT "Please Enter Source Drive A or B ?";:GOSUB 620:source$=g.key$
140 IF source$="A" THEN source=0 ELSE source=1
150 PRINT:PRINT"Please Enter Destination Drive A or B ?";:GOSUB 620
160 destination$=g.key$
170 destination=INSTR(template$,destination$)-1
180 ' Get Format Of Files - Either Rodos or Amsdos
190 PRINT:PRINT"Is The Source Files In Amsdos Format Or Rodos Format ?";
200 template$="AR"
210 GOSUB 620:type$=g.key$
220 type=INSTR(template$,type$)-1:IF type=0 THEN type.d$=type$:GOTO 250
230 PRINT:PRINT"Is The Destination Files To Be Amsdos Format Or Rodos Format ?";
240 GOSUB 620:type.d$=g.key$
250 ' Tell User To Insert Source Disk Into Appropriate Drive
260 type.d=INSTR(template$,type.d$)-1
270 MODE 2:PRINT"Insert Source Disk In Drive ";source$;" & Press Space":template$=" ":GOSUB 620:|DRIVE,@source$:zzz=FRE("")
280 MODE 2:CAT
290 ' Initialize More Variables
300 DIM file$(25,4),taged(25,4),cop$(100),cop1$(100):FOR i=1 TO 25:FOR t=1 TO 4
310 file$(i,t)=SPACE$(16):taged(i,t)=0:cop$(t*i)=SPACE$(16):cop1$(t*i)=SPACE$(16):NEXT t,i
320 pointer=1
330 ' Read Off Filenames Available For Copying
340 ON type+1 GOSUB 710,830
350 ' Display Files Available For Copying
360 MODE 2
370 ON type+1 GOSUB 960,1040
380 ' Display Instruction Messages
390 LOCATE 1,25:PRINT"	 Moves Pointer T Tag File L Logs On A New Disk Q Exits Copier B Begin Transfer"
400 LOCATE 1,1
410 ' Set Up Template For Keys
420 Template$="TLQB"+CHR$(&FB)+CHR$(&F7)+CHR$(&F3)
430 ' Set Up Start Co-ordinates Of Cursor
440 x=1:y=1
450 ' Display Cursor
460 ON type+1 GOSUB 1110,1760
470 ' Get User Input
480 GOSUB 550
490 keynumber=INSTR(template$,g.key$)
500 zzz=FRE("")
510 ON keynumber GOSUB 1150,1220,1260,1320,1490,1490,1490
520 GOTO 450
530 END
540 PRINT"This Has Been Created By Jason Brooks 1989"
550 ' Get A Single Key Stroke
560 G.KEY$=""
570 WHILE INKEY$<>"":WEND
580 G.KEY$=INKEY$:IF G.KEY$="" THEN 580
590 G.key$=UPPER$(G.key$)
600 IF INSTR(template$,g.key$)=0 THEN 580
610 RETURN
620 ' Get A Single Key Stroke & Print It
630 G.KEY$=""
640 G.KEY$=INKEY$:IF G.KEY$="" THEN 640
650 G.key$=UPPER$(G.key$)
660 IF INSTR(template$,g.key$)=0 THEN 640
670 PRINT " ";g.key$;
680 RETURN
690 PRINT"This Has Been Created By Jason Brooks 1989"
700 ' Tell User To Insert Source Disc In Drive A & Await Keypress
710 ' Type=0 Therefore Source Files Are Amsdos
720 FOR row=4 TO 25:FOR column=1 TO 4
730 readit$=SPACE$(12)
740 FOR readit=1 TO 12
750 LOCATE 20*(column-1)+readit,row
760 MID$(readit$,readit,1)=COPYCHR$(#0):PRINT" ";
770 NEXT readit
780 IF column=1 AND LEFT$(readit$,1)=" " THEN row=25:column=4
790 file$(row-3,column)=readit$
800 NEXT column,row
810 RETURN
820 PRINT"This Has Been Created By Jason Brooks 1989"
830 ' Type=1 Therefore Source Files Are Rodos
840 FOR row=3 TO 25:FOR column=1 TO 4
850 readit$=SPACE$(15)
860 FOR readit=1 TO 15
870 LOCATE 20*(column-1)+readit,row
880 MID$(readit$,readit,1)=COPYCHR$(#0):PRINT" ";
890 NEXT readit
900 IF column=1 AND LEFT$(readit$,1)=" " THEN row=25:column=4
910 IF column=1 AND LEFT$(readit$,10)="Bytes free" THEN row=25:column=4:GOTO 930
920 file$(row-2,column)=readit$
930 NEXT column,row
940 RETURN
950 PRINT"This has been created by Jason Brooks 1989"
960 ' Type 0 Print Filenames Available To Copy Routine
970 FOR row=1 TO 25:FOR column=1 TO 4
980 LOCATE 16*(column-1)+2,row:PRINT file$(row,column);
990 NEXT column
1000 IF LEFT$(file$(row+1,1),1)=" " THEN row=25:column=4
1010 PRINT:NEXT row
1020 RETURN
1030 PRINT"This has been created by Jason Brooks 1989"
1040 ' Type 1 Print Filenames Available To Copy Routine
1050 FOR row=1 TO 25:FOR column=1 TO 4
1060 LOCATE 20*(column-1)+2,row:PRINT file$(row,column)
1070 NEXT column
1080 IF LEFT$(file$(row+1,1),1)=" " THEN row=25:column=4
1090 PRINT:NEXT row
1100 RETURN
1110 ' Display Cursor For 0 type
1120 LOCATE 16*(x-1)+1,y:PRINT">												<";
1130 RETURN
1140 PRINT"This has been created by Jason Brooks 1989"
1150 ' Tag A File
1160 IF taged(y,x)=1 THEN RETURN
1170 taged(y,x)=1
1180 cop$(pointer)=file$(y,x):pointer=pointer+1
1190 PRINT" #"
1200 GOTO 1490
1210 PRINT"This has been created by Jason Brooks 1989"
1220 ' Log On A New Disk
1230 zzz=FRE("")
1240 CLEAR:RUN
1250 PRINT"This has been created by Jason Brooks 1989"
1260 ' Quiticus Gamus
1270 MODE 1:PRINT"Thank You For Your Co-Operation."
1280 PRINT"Signed,"
1290 PRINT"ROBO-COP"
1300 zzz=FRE(""):CLEAR:END
1310 PRINT"This has been created by Jason Brooks 1989"
1320 ' Begin Transfer
1330 ' But First Confirmation Of Transfers
1340 IF pointer=1 THEN RETURN
1350 MODE 1:template$="YN"
1360 IF type$="R" AND type.d$="A" THEN GOSUB 1560 ELSE GOSUB 1730
1370 MODE 2:PRINT"Confirmation Of Files To Copy."
1380 PRINT"=============================="
1390 PRINT"Source Filename         Destination Filename    Copy ? "
1400 PRINT"===============         ====================    ======"
1410 WINDOW 1,80,6,25:CLS
1420 ZONE 24
1430 FOR confirm=1 TO pointer-1:PRINT cop$(confirm),cop1$(confirm),;:GOSUB 550
1440 IF g.key$="N" THEN PRINT"NO":cop$(confirm)=SPACE$(16):GOTO 1460
1450 PRINT"YES"
1460 NEXT confirm
1470 GOTO 1790
1480 PRINT"This has been created by Jason Brooks 1989"
1490 ' Move To Next File
1500 IF type=0 THEN LOCATE 16*(x-1)+1,y:PRINT" 												 ";:ELSE LOCATE 20*(x-1)+1,y:PRINT" 															 ";
1510 x=x+1:IF x=5 THEN x=1:y=y+1:IF y=24 THEN y=1
1520 IF LEFT$(file$(y,1),1)=" " THEN y=1
1530 IF LEFT$(file$(y,x),1)=" " THEN 1510
1540 RETURN
1550 ' If Source & Destinations Drives The Same Then This Routine Applies.
1560 ' Confirmation Of RODOS To AMSDOS
1570 template$="YN"
1580 FOR confirm=1 TO pointer-1
1590 ext$=RIGHT$(cop$(confirm),3):filnam$="        ":check=1
1600 WHILE check<>9 AND MID$(cop$(confirm),check,1)<>" "
1610 MID$(filnam$,check,1)=MID$(cop$(confirm),check,1)
1620 check=check+1
1630 WEND
1640 PRINT" Rodos Filename: ";cop$(confirm)
1650 PRINT"Amsdos Filename: ";filnam$;".";ext$
1660 PRINT"Agree ? ";:GOSUB 550
1670 IF g.key$="Y" THEN PRINT"YES":cop1$(confirm)=filnam$+"."+ext$
1680 IF g.key$="N" THEN PRINT:INPUT"Destination Filename ? ",de$:cop1$(confirm)=de$
1690 CLS
1700 NEXT
1710 RETURN
1720 PRINT"This has been created by Jason Brooks 1989"
1730 'Copy Source Filenames To Destination Filenames.
1740 FOR i=1 TO pointer-1:cop1$(i)=cop$(i):NEXT:RETURN
1750 PRINT"This has been created by Jason Brooks 1989"
1760 ' Display Cursor For 1 type
1770 LOCATE 20*(x-1)+1,y:PRINT">															<";
1780 RETURN
1790 'Now We Can Start The Transfer.
1800 'At Last.
1810 template$=" "
1820 IF source$=destination$ THEN 1970
1830 start=1
1840 PRINT"Insert Destination Disk In Drive ";destination$;" & Press Space.":GOSUB 550
1850 |OPT,1,255
1860 IF LEFT$(cop$(start),1)=" " THEN 1900
1870 this$=source$+":"+cop$(start)
1880 this2$=destination$+":"+cop1$(start)
1890 |COPY,@this2$,@this$
1900 start=start+1:IF start<>pointer THEN 1860
1910 PRINT"Copying Complete."
1920 |DRIVE,@destination$
1930 |OPT,1,0
1940 CAT
1950 zzz=FRE(""):CLEAR:END
1960 PRINT"This has been created by Jason Brooks 1989"
1970 ' Transfer Files Routine For When The Source & Destination Files Are
1980 ' The Same.
1990 |OPT,1,255
2000 CLS:PRINT"Insert Source Disk In To Drive ";source$;" & Press Space.":GOSUB 550
2010 start=1
2020 FOR i=1 TO pointer-1
2030 CLS:zzz=FRE("")
2040 IF LEFT$(cop$(i),1)=" " THEN 2100
2050 this$=source$+":"+cop$(i)
2060 this2$="C:"+cop1$(i)
2070 |COPY,@this2$,this$
2080 LOCATE 1,3:df$=COPYCHR$(#0)
2090 IF df$="D" THEN GOSUB 2170
2100 NEXT
2110 GOSUB 2170
2120 PRINT"O.k. That's All Folks"
2130 |DRIVE,@destination$
2140 CAT
2150 END
2160 PRINT"This has been created by Jason Brooks 1989"
2170 'Transfer All Files From Silicon Disk To Destination Drive.
2180 PRINT"Insert Destination Disk In Drive ";destination$;" & Press Space.":template$=" ":GOSUB 550
2190 this3$=destination$+":"
2200 |COPY,@this3$,"c:*"
2210 PRINT"Insert Source Disk In To Drive ";source$;" & Press Space.":GOSUB 550
2220 |ERA,"c:*.*"
2230 RETURN
