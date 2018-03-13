20 MEMORY 42500
30 DEFSTR a,z:field1=9
50 DIM field$(9):DIM z(5)
60 CLOSEIN:PEN 1:INK 1,0:INK 0,24:BORDER 24:MODE 1:LOCATE 17,1:INK 2,2:PRINT"AMFILE":WINDOW 1,40,5,25:WINDOW #1,1,40,3,3:INK 3,6:WIN
DOW #2,1,40,25,25
80 IF PEEK(43901)<>237 AND PEEK(43901)<>238 THEN GOSUB 2850
90 IF PEEK(43901)=238 THEN INK 2,8:INK 3,14
100 PRINT#1,"MENU MODE":PRINT"Select from:":PRINT
110 RESTORE:FOR g=1 TO 8:READ a
120 PRINT:PRINT"("MID$(STR$(g),2,1)") "a:NEXT
130 DATA Field entry,Record entry,List or order present file,Edit or delete a record,Save file/fields only,Load file/fields only,Era
se file,Exit program
140 WHILE INKEY$<>"":WEND
150 a="":WHILE a<"1"OR a>"8":a=INKEY$:WEND
160 ON VAL(a)GOTO 180,340,560,1370,1730,2220,2650,2710
170   '
180   '                     *** (1) FIELD ENTRY *** 
190 CLS:PRINT#1,"FIELD ENTRY MODE"
200 LINE INPUT "Enter title of file:";title$:IF LEN(title$)>20 THEN PRINT"TITLE TOO LONG.":GOTO 200
210 IF title$=""THEN title$="Unnamed file"
220 title$=UPPER$(title$):CLS:PRINT title$:WINDOW 1,40,7,25:FOR g=1 TO field1
230 PRINT"Enter field no."MID$(STR$(g),2,1)":";:LINE INPUT field$(g)
240 IF LEN(field$(g))>20 THEN PRINT"FIELD TOO LONG.":GOTO 230
250 IF RIGHT$(field$(g),1)=":"THEN field$(g)=LEFT$(field$(g),LEN(field$(g))-1)
260 IF field$(g)=""THEN PRINT"INVALID ENTRY.":GOTO 230
270 IF g=field1 GOTO 320
280 PRINT:PRINT"Another field? (Y/N)"
290 WHILE INKEY$<>"":WEND
300 a="":WHILE a<>"Y" AND a<>"N":a=UPPER$(INKEY$):WEND
310 IF a="Y" THEN CLS:NEXT
320 field=g
330 WINDOW 1,40,5,25:CLS:GOTO 100
340  '
350  '                     *** (2) RECORD ENTRY ***
360 'ON ERROR GOTO 2500
370 IF field=0 THEN PRINT#2,"NO FIELDS HAVE YET BEEN ENTERED.":FOR pause=1 TO 1500:NEXT:CLS#2:GOTO 140
380 IF st=1 GOTO 410 ELSE st=1
390 num=INT(FRE("")/(field*30))
400 DIM rec$(num,field)
410 PRINT#1,"DATA ENTRY MODE"
420 WINDOW #3,21,40,5,5:CLS:PRINT title$:WINDOW 1,40,7,25
430 FOR g=rec+1 TO num
440 CLS
450 PRINT#3,"Record"g:FOR h=1 TO field
460 PEN 2:PRINT field$(h)":";:PEN 3:LINE INPUT rec$(g,h):PEN 1
470 IF LEN(rec$(g,h))>60 THEN PRINT"ENTRY TOO LONG.":GOTO 460
480 NEXT:PRINT:PRINT"Enter another record? (Y/N)"
490 WHILE INKEY$<>"":WEND
500 a="":WHILE a<>"Y"AND a<>"N":a=UPPER$(INKEY$):WEND
510 IF a="Y"THEN NEXT
520 rec=g:field1=field
530 GOTO 60
540 PRINT"NO ROOM FOR ANY MORE RECORDS.":rec$(g,1)="":FOR h=1 TO field:rec$(g,h)="":NEXT:num=g:GOTO 100
550  '
560  '                     *** (3) LIST/ORDER FILE ***
570 IF rec=0 THEN PRINT#2,"NO RECORDS HAVE YET BEEN ENTERED.":FOR pause=1 TO 1500:NEXT:CLS#2:GOTO 140
580 PEN 1:WINDOW 1,40,5,25:CLS:PRINT#1,"LIST/ORDER FILE MODE"
590 PRINT"Select from:":PRINT
600 RESTORE 610:PRINT:FOR g=1 TO 5:READ a:PRINT"("RIGHT$(STR$(g),1)") "a:PRINT
610 NEXT
620 DATA List all records,List certain fields of all records,Search through file,Order file,Return to main menu
630 WHILE INKEY$<>"":WEND
640 a="":WHILE a<"1"OR a>"5":a=INKEY$:WEND
650 IF a="5"GOTO 60
660 ON VAL(a)GOTO 680,770,960,1230,60
670  '
680  '                     *** (3A) LIST ALL RECORDS ***
690 CLS:PRINT Title$:PRINT#2," PRESS SPACE BAR TO STOP, ESC TO PAUSE":WINDOW 1,40,7,23
700 FOR g=1 TO rec:PRINT:PRINT"RECORD"g
710 FOR h=1 TO field
720 PEN 2:PRINT field$(h)":";:PEN 3:PRINT LEFT$(rec$(g,h),39-LEN(field$(h)));MID$(rec$(g,h),40-LEN(field$(h)),40)
730 IF INKEY$=" "GOTO 580
740 PEN 1:NEXT:NEXT
750 GOTO 2780
760  '
770  '                     *** (3B) LIST CERTAIN FIELDS OF ALL RECORDS ***
780 CLS
790 LINE INPUT"Type in the number(s) of the fields to  be listed: ",a
800 IF a=""THEN GOTO 830
810 FOR g=1 TO LEN(a):IF MID$(a,g,1)>="0"AND MID$(a,g,1)<="9"THEN NEXT:GOTO 820 ELSE 830
820 IF VAL(a)=0 THEN GOTO 830 ELSE 840
830 PRINT"INVALID ENTRY.":GOTO 790
840 IF LEN(a)=1 THEN IF VAL(a)>field THEN PRINT"THERE ARE NOT THIS MANY FIELDS.":GOTO 790 ELSE 860
850 FOR g=1 TO LEN(a):IF VAL(MID$(a,g,1))<=field THEN NEXT:GOTO 860 ELSE PRINT"THERE ARE NOT THIS MANY FIELDS.":GOTO 790
860 CLS:PRINT Title$:WINDOW 1,40,7,23
870 PRINT#2,"  PRESS SPACE BAR TO STOP, ESC TO PAUSE"
880 FOR g=1 TO rec
890 FOR h=1 TO LEN(a)
900 temp1=VAL(MID$(a,h,1))
910 PEN 2:PRINT field$(temp1)":";:PEN 3:PRINT LEFT$(rec$(g,temp1),39-LEN(field$(h)));MID$(rec$(g,temp1),40-LEN(field$(temp1)),40)
920 IF INKEY$=" "THEN GOTO 580
930 NEXT:NEXT:PRINT:GOTO 2780  
940 END
950  '
960  '                     *** (3C) SEARCH THROUGH FILE ***
970 RESTORE 990
980 CLS
990 FOR g=1 TO 5:READ a1
1000 PRINT"Enter the "RIGHT$(STR$(g),1);a1" piece of data to be found:";:LINE INPUT z(g)
1010 IF z(g)=""THEN PRINT"INVALID ENTRY.":GOTO 1000
1020 DATA st,nd,rd,th,th
1030 IF g=5 THEN 1070 ELSE PRINT"Do you want to search for other data    simultaneously? (Y/N)"
1040 WHILE INKEY$<>"":WEND
1050 a="":WHILE a<>"Y"AND a<>"N":a=UPPER$(INKEY$):WEND
1060 IF a="Y"THEN CLS:NEXT
1070 CLS:temp=g
1080 flagA=0
1090 FOR g=1 TO rec:flagB=0
1100 a1=""
1110 FOR h=1 TO field
1120 a1=a1+rec$(g,h)+" "
1130 NEXT
1140 FOR h=1 TO temp:IF INSTR(a1,z(h))>0 THEN flagB=flagB+1:IF flagB=temp THEN flagA=flagA+1:GOTO 1170 ELSE NEXT
1150 flag5=1:GOTO 1210
1160 IF flagA=0 GOTO 1190 ELSE IF g>rec THEN PRINT:PRINT:GOTO 2780
1170 IF flagA=1 THEN PRINT title$:WINDOW 1,40,7,25
1180 PRINT:PRINT"RECORD"g:FOR h=1 TO field:PEN 2:PRINT field$(h)":";:PEN 3:PRINT LEFT$(rec$(g,h),39-LEN(field$(h)));MID$(rec$(g,h),4
0-LEN(field$(h)),40):PEN 1:NEXT:GOTO 1210
1190 PRINT"No record was found containing ";:FOR h=1 TO temp:PRINT z(h);:IF temp=1 THEN PRINT".":GOTO 2780 ELSE IF h=temp-1 THEN PRI
NT" and "z(h+1)".":GOTO 2780
1200 PRINT", ";:NEXT:GOTO 2780
1210 NEXT g:IF flag5=0 THEN PRINT:PRINT:GOTO 2780 ELSE flag5=0:GOTO 1160
1220  '
1230  '                     *** (3D) ORDER FILE ***
1240 CLS:PRINT"Enter number of field by which file is  to be ordered:"
1250 WHILE INKEY$<>"":WEND
1260 a="":WHILE VAL(a)<1 OR VAL(a)>field:a=INKEY$:WEND
1270 temp=VAL(a)
1280 SPEED INK 20,30:PEN #4,2:INK 2,24,0:WINDOW #4,1,40,9,9:PRINT#4,"       SORTING FILE, PLEASE WAIT"
1290 FlagA=0:FOR g=1 TO rec-1
1300 IF rec$(g,temp)<=rec$(g+1,temp)GOTO 1330
1310 FOR h=1 TO field:temp$=rec$(g+1,h):rec$(g+1,h)=rec$(g,h):rec$(g,h)=temp$
1320 NEXT:flagA=1
1330 NEXT:IF flagA=1 GOTO 1290
1340 IF PEEK(43903)=238 THEN INK 2,8 ELSE INK 2,2
1350 PEN #4,1:PRINT#4,"       File has been ordered.":FOR pause=1 TO 1500:NEXT:GOTO 580
1360  '
1370  '                     *** (4) EDIT/DELETE A RECORD ***
1380 IF REC=0 THEN PRINT#2,"NO RECORDS HAVE YET BEEN ENTERED.":FOR pause=1 TO 1500:NEXT:PRINT#2:GOTO 140
1390 CLS:PRINT#1,"EDIT/DELETE RECORD MODE"
1400 PRINT"Select from:":PRINT:PRINT:PRINT"Edit a record":PRINT:PRINT"Delete a record"
1410 WHILE INKEY$<>"":WEND
1420 a="":WHILE a<>"E" AND a<>"D":a=UPPER$(INKEY$):WEND
1430 IF a="D" GOTO 1580
1440  '
1450  '                     *** (4A) EDIT A RECORD ***
1460 CLS
1470 LINE INPUT"Enter number of record to be edited:",a:IF a=""GOTO 1570
1480 FOR g=1 TO LEN(a):IF MID$(a,g,1)<"0"OR MID$(a,g,1)>"9"GOTO 1570 ELSE NEXT
1490 IF VAL(a)=0 GOTO 1570
1500 IF VAL(a)>rec THEN PRINT"THERE ARE NOT THIS MANY RECORDS.":GOTO 1470
1510 CLS:PRINT"Press ENTER alone to bypass a field.":PRINT:PRINT
1520 FOR g=1 TO field
1530 PEN 2:PRINT field$(g)":";:PEN 3:PRINT LEFT$(rec$(VAL(a),g),39-LEN(field$(g)));MID$(rec$(VAL(a),g),40-LEN(field$(g)),40);TAB(LEN
(field$(g)))"  ";:LINE INPUT a1
1540 IF a1=""THEN 1560 ELSE IF LEN(a1)>60 THEN PRINT"ENTRY TOO LONG.":GOTO 1530
1550 rec$(VAL(a),g)=a1
1560 NEXT:GOTO 60
1570 PRINT"INVALID ENTRY.":GOTO 1470
1580  '
1590  '                     *** (4B) DELETE A RECORD ***
1600 CLS:PRINT"Select from:":PRINT:PRINT:PRINT"Move following records up one":PRINT:PRINT"Leave a blank record" 
1610 WHILE INKEY$<>"":WEND
1620 a="":WHILE a<>"M"AND a<>"L":a=UPPER$(INKEY$):WEND
1630 IF a="L"THEN flagA=1 ELSE flagA=0
1640 CLS
1650 LINE INPUT"Enter number of record to be deleted:",a:IF a=""THEN 1720
1660 FOR g=1 TO LEN(a):IF MID$(a,g,1)<"0"AND MID$(a,g,1)>"9"THEN 1720 ELSE NEXT
1670 IF VAL(a)=0 THEN 1720
1680 IF VAL(a)>rec THEN PRINT"THERE ARE NOT THIS MANY RECORDS.":GOTO 1650
1690 IF flagA=0 THEN FOR g=VAL(a) TO rec-1::FOR h=1 TO field:rec$(g,h)=rec$(g+1,h):NEXT:NEXT:rec=rec-1:GOTO 1710
1700 FOR g=1 TO field:rec$(VAL(a),g)="":NEXT
1710 PRINT:PRINT:PRINT"Record "a" has been deleted.":FOR g=1 TO 1500:NEXT:GOTO 60
1720 PRINT"INVALID ENTRY.":GOTO 1650
1730  '
1740  '                     *** (5) SAVE FILE/FIELDS ONLY ***
1750 IF field=0 THEN PRINT#2,"NO FIELDS HAVE YET BEEN ENTERED.":FOR pause=1 TO 1500:NEXT:PRINT#2:GOTO 140
1760 CLS:PRINT#1,"SAVE FILE/FIELDS MODE":PRINT"Select from:":PRINT:PRINT:PRINT"(1) Save whole file":PRINT:PRINT"(2) Save the fields 
alone"
1770 WHILE INKEY$<>"":WEND
1780 a="":WHILE a<>"1"AND a<>"2":a=INKEY$:WEND
1790 IF rec=0 AND a="1"THEN PRINT#2,"NO RECORDS HAVE YET BEEN ENTERED.":FOR pause=1 TO 1500:NEXT:GOTO 60
1800 PRINT:PRINT:PRINT"Saving speed Fast or Normal? (F/N)"
1810 WHILE INKEY$<>"":WEND
1820 a1="":WHILE a1<>"F"AND a1<>"N":a1=UPPER$(INKEY$):WEND
1830 IF a1="N"THEN SPEED WRITE 0 ELSE SPEED WRITE 1
1840 IF a="2"GOTO 2050
1850  '
1860  '                     *** (5A) SAVE WHOLE FILE ***
1870 CLS:PRINT"Press play and record on the tape, ""and ""then press the ENTER key."
1880 WHILE INKEY$<>"":WEND
1890 WHILE INKEY$<>CHR$(13):WEND:PRINT:PRINT"SAVING "title$"."
1900 ON BREAK GOSUB 2910
1910 OPENOUT("!Extras")
1920 PRINT#9,title$:PRINT#9,field:PRINT#9,rec:CLOSEOUT
1930 OPENOUT("!Fields")
1940 FOR g=1 TO field:PRINT#9,field$(g):NEXT:CLOSEOUT
1950 OPENOUT("!Records"):FOR g=1 TO rec:FOR h=1 TO field:PRINT#9,rec$(g,h):NEXT:NEXT:CLOSEOUT
1960 OPENOUT ("!PRESSESC.NOW"):PRINT#9,"!":CLOSEOUT
1970 PRINT:PRINT "File has now been saved. ""Would you ""like to verify? (Y/N)" 
1980 WHILE INKEY$<>"":WEND
1990 a="":WHILE a<>"Y"AND a<>"N":a=UPPER$(INKEY$):WEND
2000 IF a="N"THEN GOTO 60
2010 PRINT:PRINT"Rewind tape and press play. If a read   error occurs, then either rewind tape,orpress ESC twice and re-record. Pres
s ESCtwice on seeing "CHR$(34)"PRESS ESC NOW"CHR$(34)".
2020 KEY DEF 66,1,252,252,252:ON BREAK GOSUB 2040:CAT:ON BREAK GOSUB 2910:KEY DEF 66,1,32,32,32
2030 GOTO 60
2040 RETURN
2050  '
2060  '                     *** (5B) SAVE FIELDS ALONE ***
2070 CLS:PRINT"Press play and record on the tape, ""and ""then press the ENTER key."
2080 WHILE INKEY$<>"":WEND:WHILE INKEY$<>CHR$(13):WEND:PRINT:PRINT"SAVING FIELDS."
2090 OPENOUT("!Extras") 
2100 PRINT#9,title$:PRINT#9,field:PRINT#9,rec:CLOSEOUT
2110 OPENOUT("!Fields") 
2120 FOR g=1 TO field:PRINT#9,field$(g):NEXT:CLOSEOUT
2130 OPENOUT("!PRESS ESC NOW."):PRINT#9,"!":CLOSEOUT
2140 PRINT:PRINT "Fields have now been saved. ""Would you ""like to verify? (Y/N)" 
2150 WHILE INKEY$<>"":WEND
2160 a="":WHILE a<>"Y"AND a<>"N":a=UPPER$(INKEY$):WEND
2170 IF a="N"THEN 60
2180 PRINT:PRINT"Rewind tape and press play. If a read   error occurs, then either rewind tape,orpress ESC twice and re-record. Pres
s ESCtwice on seeing "CHR$(34)"PRESS ESC NOW"CHR$(34)".
2190 KEY DEF 66,1,252,252,252:ON BREAK GOSUB 2040:CAT:ON BREAK GOSUB 2910:KEY DEF 66,1,32,32,32
2200 GOTO 60
2210  '
2220  '                     *** (6) LOAD FILE/FIELDS ONLY ***
2230 CLS:PRINT#1,"LOAD FILE/FIELDS ONLY MODE"
2240 PRINT"Select from:":PRINT:PRINT:PRINT"(1) Load whole file  ":PRINT:PRINT"(2) Load fields only"
2250 WHILE INKEY$<>"":WEND
2260 a="":WHILE a<>"1"AND a<>"2":a=UPPER$(INKEY$):WEND
2270 PRINT:PRINT:PRINT
2280 IF a="2" THEN 2480
2290  '
2300  '                     *** (6A) LOAD WHOLE FILE ***
2310 CLEAR:DEFSTR a,z:field1=9:DIM z(5)
2320 LINE INPUT"Enter name of file to be loaded, or     press ENTER alone to load the first filefound: ",a1
2330 IF LEN(A1)>20 THEN PRINT"NAME TOO LONG.":GOTO 2320 ELSE a1=UPPER$(a1)
2340 CLS:PRINT"Press play on tape, then press ENTER.":WHILE INKEY$<>"":WEND:WHILE INKEY$<>CHR$(13):WEND
2350 PRINT:PRINT:PRINT"SEARCHING FOR ";:IF a1<>""THEN PRINT a1"."ELSE PRINT"UNKNOWN FILE."
2360 LOCATE 1,18:PRINT"If a read error occurs, rewind tape and press play, or press ESC, and then type GOTO 60 <ENTER>.":LOCATE 1,7
2370 ON BREAK GOSUB 2460
2380 OPENIN("!Extras"):GOSUB 2470:LINE INPUT#9,title$:PRINT"FOUND "title$;:IF title$<>a1 AND a1<>""THEN PRINT:CLOSEIN:GOTO 2380 ELSE
 PRINT"-LOADING."
2390 INPUT#9,field:INPUT#9,rec:DIM field$(field):st1=1:num=INT(FRE(0)/(field*30)):DIM rec$(num,field):st=1
2400 CLOSEIN:OPENIN("!fields"):GOSUB 2470
2410 FOR g=1 TO field:LINE INPUT#9,field$(g):NEXT:CLOSEIN
2420 OPENIN("!Records"):GOSUB 2470
2430 FOR g=1 TO rec:FOR h=1 TO field:LINE INPUT#9,rec$(g,h):NEXT:NEXT:CLOSEIN
2440 field1=field
2450 ON BREAK STOP:CLS:GOTO 100
2460 flag=1:RETURN
2470 IF flag=1 GOTO 2450 ELSE RETURN
2480  '                     *** (6B) LOAD FIELDS ONLY ***
2490 LINE INPUT"Enter name of fields to be loaded, or   press ENTER alone to load the first filefound: ",a1
2500 IF LEN(a1)>20 THEN PRINT"NAME TOO LONG.":GOTO 2490 ELSE a1=UPPER$(a1)
2510 CLS:PRINT"Press play on tape, then press ENTER.":WHILE INKEY$<>"":WEND:WHILE INKEY$<>CHR$(13):WEND 
2520 PRINT:PRINT:PRINT"SEARCHING FOR ";:IF a1<>""THEN PRINT a1"."ELSE PRINT"UNKNOWN FIELDS."
2530 LOCATE 1,18:PRINT"If a read error occurs, rewind tape and press play, or press ESC, and then type GOTO 60 <ENTER>.":LOCATE 1,7
2540 ON BREAK GOSUB 2460
2550 OPENIN("!Extras"):GOSUB 2470:LINE INPUT#9,title$:PRINT"FOUND "title$;:IF title$<>a1 AND a1<>""THEN PRINT:CLOSEIN:GOTO 2550 ELSE
 PRINT"-LOADING FIELDS."
2560 INPUT#9,field:INPUT#9,dummy:num=INT(FRE(0)/(field*30))
2570 CLOSEIN:OPENIN("!fields"):GOSUB 2470
2580 IF field1>field THEN FIELD2=FIELD ELSE FIELD2=FIELD1
2590 FOR G=1 TO FIELD2
2600 IF field1<field THEN field=field1
2610 LINE INPUT#9,field$(g):NEXT:CLOSEIN
2620 num=INT(FRE(0)/(field*30))
2630 IF rec=0 THEN DIM rec$(num,field):st=1
2640 ON BREAK STOP:CLS:GOTO 100
2650  '                     *** (7) ERASE FILE ***
2660 CLS:PRINT"Are you sure?  (Y/N)"
2670 WHILE INKEY$<>"":WEND
2680 a="":WHILE a<>"Y"AND a<>"N":a=UPPER$(INKEY$):WEND
2690 IF a="N"THEN CLS:GOTO 100
2700 FOR g=1 TO 1500:NEXT:PRINT:PRINT:PRINT"File has been erased.":FOR g=1 TO 1500:NEXT:RUN
2710  '                     *** (8) EXIT PROGRAM ***
2720 CLS:PRINT"Are you sure?  (Y/N)"
2730 WHILE INKEY$<>"":WEND
2740 a="":WHILE a<>"Y"AND a<>"N":a=UPPER$(INKEY$):WEND
2750 IF a="N"THEN CLS:GOTO 100
2760 CALL 0
2770 END
2780 '
2790 '                     *** WAIT FOR ENTER KEY ***
2800 PRINT#2,"     PRESS ENTER TO RETURN TO MENU"
2810 WHILE INKEY$<>"":WEND
2820 a="":WHILE a<>CHR$(13):a=INKEY$:WEND
2830 GOTO 580
2840  '
2850 '                     *** GREEN SCREEN ROUTINE ***
2860 PRINT:PRINT:PRINT:PRINT" Are you using Green screen or Colour?                 (G/C)"
2870 WHILE INKEY$<>"":WEND
2880 a="":WHILE a<>"G"AND a<>"C":a=UPPER$(INKEY$):WEND
2890 IF a="G"THEN POKE 43901,238 ELSE POKE 43901,237
2900 CLS:RETURN
2910 RETURN
