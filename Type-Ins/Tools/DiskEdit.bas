10 ON ERROR GOTO 1800
20 ' Jason's Track & Sector EDITOR
30 ' Written by J.Brooks  1987
40 ' (C) JACESOFT 1987
50 ' Set up screen
60 SYMBOL AFTER 256
70 MODE 2:INK 0,0:BORDER 0:INK 1,26
80 PAPER 0:PEN 1
90 DIM layout$(32),layout1$(32)
100 KEY DEF 66,1,47,47,47
110 mo$="Hex":mo=1
120 ' Set mode to 80 characters width
130 ' Set Background and paper to Black
140 ' Set ink to Brilliant White 
150 DEFINT a-z
160 MEMORY &9FFF
170 RESTORE
180 FOR i=&A000 TO &A000+61
190 READ jay$
200 jay=VAL("&"+jay$)
210 POKE i,jay
220 chex=chex+jay
230 NEXT:IF chex<>7825 THEN PRINT"I tink ders summat wrong in dis data.":END
240 DATA dd,7e,00,dd,56,01,32,3e,a0
250 DATA 1e,00,ed,53,3f,a0,21,41,a0
260 DATA f5,0e,07,cd,0f,b9,f1,c5,4f
270 DATA cd,66,c6,c1,cd,18,b9,c9,3a
280 DATA 3e,a0,ed,5b,3f,a0,21,41,a0
290 DATA f5,0e,07,cd,0f,b9,f1,c5,4f
300 DATA cd,4e,c6,c1,cd,18,b9,c9
310 WINDOW #3,1,80,1,4
320 PRINT#3,"       Disc Editor Written By Jason (HACKER) Brooks  (C) 1987 Jacesoft"
330 LOCATE 1,1:PRINT CHR$(22);CHR$(1);"       _______________________________________________________________"
340 PRINT CHR$(22);CHR$(0)
350 WINDOW 1,80,6,25
360 WINDOW #2,1,80,5,1
370 INPUT"Please enter Track number 0-39";track 
380 IF track<0 OR track>39 THEN PRINT"Error Re-try":GOTO 370
390 INPUT"Please enter Sector number 0 - 8";sector
400 IF sector<0 OR sector>8 THEN PRINT"Error Re-try":GOTO 390
410 INPUT"Which Format D - Data  or  C - CPM  or  I - IBM  or  V - Vendor";format1$
420 format$=LEFT$(format1$,1)
430 format$=LOWER$(format$)
440 IF format$<>"d" AND format$<>"c" AND format$<>"i" AND format$<>"v" THEN PRINT"Error Re-enter":GOTO 410
450 IF format$="d" THEN addition=&C1:LOCATE #3,1,3:PRINT #3,"Format DATA"
460 IF format$="c" THEN addition=&41:LOCATE #3,1,3:PRINT #3,"Format CP/M"
470 IF format$="i" THEN addition=&1:LOCATE #3,1,3:PRINT #3,"Format IBM"
480 IF format$="i" AND sector=8 THEN sector=7
490 IF format$="v" THEN addition=&41:LOCATE #3,1,3:PRINT #3,"Format Vendor"
500 LOCATE #3,20,3:PRINT#3,"Track";track:LOCATE #3,40,3:PRINT#3,"Sector";sector:LOCATE #3,60,3:PRINT#3,"Mode ";mo$
510 sector=sector+addition
520 buffer=track*256+sector
530 CLS
540 WINDOW 1,80,5,25
550 CALL &A000,buffer
560 LOCATE 1,1:PRINT"No.                     Hex                              Characters"  
570 WINDOW #2,1,80,4,4
580 WINDOW 1,80,6,25 
590 value=&A040
600 byte=0
610 FOR i=1 TO 32:final$="":final1$="" 
620 FOR t=1 TO 16:jay1$="":jay2$=""  
630 value=value+1
640 jay1$=HEX$(PEEK(value),2)
650 jay=VAL("&"+jay1$):IF jay<32 THEN jay=127
660 jay2$=CHR$(jay)
670 final1$=final1$+jay2$
680 jay1$=jay1$+" ":final$=final$+jay1$
690 NEXT t
700 layout$(i)=final$
710 layout1$(i)=final1$
720 IF i<21 THEN PRINT HEX$(byte,3);"   ";layout$(i);"   ";layout1$(i):byte=byte+16
730 NEXT i
740 byte=0
750 mo=1
760 LOCATE 1,1
770 ' Place cursor at fixed Y position
780 ' X axis is variable  
790 x=6:y=9:x1=8
800 byte=&80
810 CLS#2:LOCATE x,y:PRINT"[":LOCATE x+3,y:PRINT"]":LOCATE #3,20,3:PRINT#3,"Track";track:LOCATE #3,40,3:PRINT#3,"Sector";sector-addition:LOCATE #3,60,3:PRINT#3,"Mode ";mo$
820 keypress=INKEY(8)
830 IF keypress=0 THEN 990
840 IF keypress=128 THEN 1840
850 keypress=INKEY(1)
860 IF keypress=0 THEN 1040
870 IF keypress=128 THEN 1890
880 keypress=INKEY(0)
890 IF keypress=0 THEN 1080
900 IF keypress=128 THEN 1950
901 restart=INKEY(79):IF restart>-1 THEN RUN
910 keypress=INKEY(2)
920 IF keypress=0 THEN 1150
930 IF keypress=128 THEN 1990 
940 keypress=INKEY(68)
950 IF keypress=0 THEN 1220
960 keypress=INKEY(66)
970 IF keypress<>-1 THEN 2030
980 GOTO 1260:' Rest of the editor keys
990 IF x=6 THEN 810
1000 LOCATE x,y:PRINT" ":LOCATE x+3,y:PRINT" "
1010 x=x-3:byte=byte-1
1020 GOTO 810
1030 'Move cursor LEFT
1040 IF x=51 THEN 810
1050 LOCATE x,y:PRINT" ":LOCATE x+3,y:PRINT" "
1060 x=x+3:byte=byte+1
1070 GOTO 810
1080 'Scroll page down 1
1090 LOCATE x,y:PRINT" ":LOCATE x+3,y:PRINT" " 
1100 IF x1=0 THEN 810 
1110 IF x1<9 THEN LOCATE 1,1:PRINT"":byte=byte-&10:x1=x1-1:GOTO 810
1120 LOCATE 1,1:PRINT"";:PRINT HEX$((x1-9)*16,3);"   ";layout$(x1-8);"   ";layout1$(x1-8):x1=x1-1 
1130 byte=byte-16
1140 GOTO 810
1150 'Scroll page up 1
1160 IF x1=31 THEN 810
1170 LOCATE x,y:PRINT" ":LOCATE x+3,y:PRINT" "
1180 IF x1>19 THEN LOCATE 1,25:PRINT:byte=byte+16:x1=x1+1:GOTO 810
1190 x1=x1+1:LOCATE 1,25:PRINT HEX$((x1+11)*16,3);"   ";layout$(x1+12);"   ";layout1$(x1+12)
1200 byte=byte+16
1210 GOTO 810
1220 IF mo=1 THEN mo=2:mo$="ASCII  ":GOTO 810
1230 IF mo=2 THEN mo=3:mo$="Decimal":GOTO 810
1240 IF mo=3 THEN mo=1:mo$="Hex    "
1250 GOTO 810
1260 ' Any other keys to edit bytes
1270 IF mo=2 THEN 1480
1280 IF mo=3 THEN 1640
1290 a$=INKEY$:IF a$="" THEN 810
1300 a$=UPPER$(a$)
1310 IF a$<>CHR$(13) THEN 810
1320 INPUT#2,"Enter new bytes ";newbytes$
1330 IF LEN(newbytes$)<1 THEN 1320  
1340 newbyte=VAL("&"+newbytes$)
1350 POKE &A041+byte,newbyte
1360 ' Re-Calculate LAYOUT1$ and LAYOUT$
1370 layout$(x1+1)=""
1380 layout1$(x1+1)=""
1390 valv=&A041+(x1*16)
1400 FOR i=0 TO 15
1410 layout$(x1+1)=layout$(x1+1)+HEX$(PEEK(valv+i),2)+" "
1420 vat=PEEK(valv+i):IF vat<32 THEN vat=127
1430 layout1$(x1+1)=layout1$(x1+1)+CHR$(vat)
1440 NEXT
1450 LOCATE 1,9
1460 PRINT HEX$(x1*16,3);"   ";layout$(x1+1);"   ";layout1$(x1+1)
1470 GOTO 810
1480 REM
1490 a$=INKEY$:IF a$="" THEN 810
1500 brooksy=ASC(a$)
1510 IF brooksy=9 OR brooksy>239 THEN 810 
1520 POKE &A041+byte,brooksy  
1530 layout$(x1+1)=""
1540 layout1$(x1+1)=""
1550 valv=&A041+(x1*16)
1560 FOR i=0 TO 15
1570 layout$(x1+1)=layout$(x1+1)+HEX$(PEEK(valv+i),2)+" "
1580 vat=PEEK(valv+i):IF vat<32 THEN vat=127
1590 layout1$(x1+1)=layout1$(x1+1)+CHR$(vat)
1600 NEXT
1610 LOCATE 1,9
1620 PRINT HEX$(x1*16,3);"   ";layout$(x1+1);"   ";layout1$(x1+1) 
1630 GOTO 810
1640 a$=INKEY$:IF a$="" THEN 810
1650 IF a$<>CHR$(13) THEN 810
1660 INPUT#2,"Enter new bytes ";newbytes
1670 IF newbytes>255 OR newbytes<0 THEN 1660
1680 POKE &A041+byte,newbyteS
1690 ' Re-Calculate LAYOUT1$ and LAYOUT$
1700 layout$(x1+1)=""
1710 layout1$(x1+1)=""
1720 valv=&A041+(x1*16) 
1730 FOR i=0 TO 15
1740 layout$(x1+1)=layout$(x1+1)+HEX$(PEEK(valv+i),2)+" "
1750 vat=PEEK(valv+i):IF vat<32 THEN vat=127
1760 layout1$(x1+1)=layout1$(x1+1)+CHR$(vat)
1770 NEXT
1780 LOCATE 1,9:PRINT HEX$(x1*16,3);"   ";layout$(x1+1);"   ";layout1$(x1+1)
1790 GOTO 810
1800 IF ERR=13 THEN GOTO 1320
1810 PRINT"Error "ERR" in line "ERL
1820 a$=INKEY$:IF a$="" THEN 1820
1830 PRINT ASC(a$):GOTO 1820
1840 sector=sector-addition
1850 IF sector=0 THEN sector=sector+addition:GOTO 810
1860 sector=sector-1
1870 FOR i=0 TO 32:layout$(i)="":layout1$(i)="":NEXT
1880 GOTO 500
1890 sector=sector-addition
1900 IF sector=8 THEN sector=sector+addition:GOTO 810
1910 sector=sector+1
1920 FOR i=0 TO 32:layout$(i)="":layout1$(i)="":NEXT 
1930 IF sector=8 AND format$="i" THEN sector =7:GOTO 500
1940 GOTO 500
1950 IF track=39 THEN 810
1960 track=track+1:sector=sector-addition
1970 FOR i=0 TO 32:layout$(i)="":layout1$(i)="":NEXT
1980 GOTO 500
1990 IF track=0 THEN 810
2000 FOR i=0 TO 32:layout$(i)="":layout1$(i)="":NEXT
2010 track=track-1:sector=sector-addition 
2020 GOTO 500
2030 LOCATE #3,38,2:PRINT#3,"SAVE Y/N"
2040 a$=INKEY$
2050 IF a$="" THEN 2040
2060 a$=LOWER$(a$)
2070 IF a$="y" THEN CALL &A023:LOCATE #3,38,2:PRINT#3,"        ":GOTO 810
2080 IF a$="n" THEN LOCATE #3,38,2:PRINT#3,"         ":GOTO 810
2090 GOTO 2040
