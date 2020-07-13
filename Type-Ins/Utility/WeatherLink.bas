10 REM Weather Link Demo-program
20 MEMORY &3FFF
30 c%(0)=0:c%(1)=26:c%(2)=11:c%(3)=13
40 MODE 1:FOR a=0 TO 3:INK a,c%(a):NEXT
50 GOSUB 800:GOSUB 440
60 nf%=0:PAPER 0:PEN 1:CLS
70 INPUT "Enter filename :";fil$:CLS
80 fil$="!"+fil$
90 OPENIN fil$
100 CALL &8077:CLOSEIN
110 WHILE INKEY$<>" ":WEND
120 CALL &8143:PAPER 1:PEN 0
130 FOR a=1 TO 10:LOCATE 13,a
140 PRINT SPACE$(12):NEXT
150 LOCATE 15,1:PRINT"Main Menu"
160 RESTORE 360:FOR a=3 TO 8
170 READ m$(a):LOCATE 15,a
180 PRINT m$(a):NEXT
190 PAPER 0:PEN 1:y=3:LOCATE 15,y
200 PRINT m$(y):quit%=0:WHILE quit%<>1
210 x=0:IF INKEY(1)=0 THEN x=1 ELSE IF INKEY(8)=0 THEN x=-1
220 IF x<>0 THEN GOSUB 310:GOTO 290
230 t=0:IF INKEY(0)=0 THEN t=-1 ELSE IF INKEY(2)=0 THEN t=1
240 IF y+t<3 OR y+t>8 OR y+t=y THEN 290
250 PAPER 1:PEN 0:LOCATE 15,y
260 PRINT m$(y):y=y+t
270 PAPER 0:PEN 1:LOCATE 15,y
280 PRINT m$(y)
290 WHILE INKEY$<>"":WEND
300 WEND:CALL &814F:i$="":IF nf%=1 THEN 60 ELSE 110
310 IF y=7 THEN quit%=1:RETURN
320 IF y=8 THEN GOSUB 370:quit%=1:RETURN
330 c%(y-3)=c%(y-3)+x:IF c%(y-3)<0 OR c%(y-3)>26 THEN c%(y-3)=c%(y-3)-x
340 INK y-3,c%(y-3)
350 FOR b=1 TO 100:NEXT:RETURN
360 DATA Colour 0,Colour 1,Colour 2,Colour 3,Quit menu,New file
370 REM NEW FILE?
380 CALL &814F:CALL &8144
390 LOCATE 10,24:PRINT"A new file (Y or N)"
400 nf%=0:i$=UPPER$(INKEY$):IF i$<>"N" AND i$<>"Y" THEN 400
410 IF i$="Y" THEN nf%=1
420 i$="":CALL &814F:RETURN
430 REM Poke machine code
440 ln=530:RESTORE 530
450 FOR adr=&8000 TO &815B STEP 13
460 READ byte$:chk=0
470 FOR i=0 TO 12
480 v=VAL("&"+MID$(byte$,i*2+1,2))
490 POKE adr+i,v:chk=chk+v
500 NEXT
510 IF chk<>VAL("&"+RIGHT$(byte$,3)) THEN PRINT"ERROR in LINE";ln:STOP
520 ln=ln+10:NEXT:RETURN
530 DATA 0200000102000001010103030100F
540 DATA 0303033E3F40414243444546472A2
550 DATA 48494A4B4C3435363738393A3B32E
560 DATA 3C3D4D4E4F0000000000010203169
570 DATA 0405060708090A0B0C0D0E0F10082
580 DATA 111213141516171819000000000BD
590 DATA 00001A1B1C1D1E1F2021222324155
600 DATA 25262728292A2B2C2D2E2F303122F
610 DATA 32330000000000000000000000065
620 DATA 00002100C0AF326B803276803E413
630 DATA C8326A80CD80BCD0FE1438F8FE7FD
640 DATA 3E201A115000A7ED52110008192F1
650 DATA 30041150C0193A6A803D326A803EB
660 DATA 20DBC9CD10813A7680FE0438D065C
670 DATA 016C801100000ACB3FCB12CB3F3F9
680 DATA CB13030ACB3FCB12CB3FCB13034BD
690 DATA 0ACB3FCB12CB3FCB13030ACB3F4F0
700 DATA CB12CB3FCB137A878787878377655
710 DATA 23E53A7680D604327680280F474B8
720 DATA 116B802104001923137E127710287
730 DATA F9E13A7680FE0430A9C38680E5793
740 DATA 211080D621856F7E5FCB3FCB3F58D
750 DATA CB3FCB3F3C47C53A76804F803258D
760 DATA 76800600216B80097BE60FEB26492
770 DATA 806F7EEBC1237710FCE1C9110067A
780 DATA 402100C0010040EDB0C91100C0499
790 DATA 210040010040EDB0C900000000308
800 REM Title screen
810 RESTORE 940:FOR B=1 TO 3
820 GOSUB 880
830 FOR a=1 TO 6
840 READ me$:PRINT me$:PRINT:NEXT
850 WHILE INKEY$<>CHR$(13):WEND:NEXT
860 LOCATE 5,24:PRINT"Poking machine code. Please wait"
870 RETURN
880 MODE 1:CLS:PEN 0:PAPER 1
890 LOCATE 12,1
900 PRINT"Weather Link Demo"
910 LOCATE 9,3:PRINT"How to use this program"
920 LOCATE 1,5
930 PEN 1:PAPER 0:RETURN
940 DATA "The maps on weather link are updated    every 24 hours, which can be downloaded and saved to tape or disc. This loader  pr
ogram will prompt you for a filename, which is stored on tape or disc."
950 DATA "Some maps will differ from others in thecolours they use, and to get around thisproblem, a menu is provided to let you  ch
ange them."
960 DATA "To make use of this facility, wait untilthe map has been displayed and press thespacebar"
970 DATA "","","         PRESS RETURN WHEN READY"
980 DATA "After pressing the spacebar, a small    menu will appear with six options"
990 DATA "The first four simply alter each of the colours, whereas the fifth leaves the   menu, and restores the screen image."
1000 DATA "To change a colour, use the up and down arrows to position the bar over the     selected colour. Pressing the left and  r
ight arrows will now alter it."
1010 DATA "To leave the menu, place the bar over   the QUIT MENU option, and press either  the left or right arrow key."
1020 DATA "","         PRESS RETURN WHEN READY"
1030 DATA "The final option is NEW FILE. This will let you enter the name of the next map  to display. After positioning the bar,  a
nd pressing the left/right arrow key,  you'll be asked to confirm this choice."
1040 DATA "If Y is entered you'll be prompted for  the new filename, otherwise the screen  display will be recreated, and the menu r
emoved."
1050 DATA "For all those interested in Z80 machine code, the source code has been included at the end of Basic program."
1060 DATA "","","       PRESS RETURN TO DISPLAY MAP"
1070 REM
1080 REM
1090 REM ;Weather Link Program
1100 REM org &8000
1110 REM ;
1120 REM ;Tables
1130 REM .col_table
1140 REM defb 2,0,0,1,2,0,0,1,1,1,3,3,1,3,3,3
1150 REM .ref_table
1160 REM defb 62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,52
1170 REM defb 53,54,55,56,57,58,59,60,61,77,78,79,0,0,0,0
1180 REM defb 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
1190 REM defb 16,17,18,19,20,21,22,23,24,25,0,0,0,0,0,0
1200 REM defb 26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41
1210 REM defb 42,43,44,45,46,47,48,49,50,51
1220 REM ;END OF TABLES
1230 REM ;
1240 REM ;VARIABLES
1250 REM .eol defs 1
1260 REM .counter defs 1; 0 to 4
1270 REM .chardata defs 10
1280 REM .charcount defs 1
1290 REM ;===================================
1300 REM ;         START OF CODE
1310 REM ;===================================
1320 REM .start
1330 REM ld hl,&c000
1340 REM xor a
1350 REM ld (counter),a
1360 REM ld (charcount),a
1370 REM ld a,200
1380 REM ld (eol),a
1390 REM ;
1400 REM .back_again
1410 REM ;GET CHARACTER FROM A FILE
1420 REM ;AND RETURN IT IN THE A REGISTER
1430 REM call &bc80; FIRMWARE ROUTINE
1440 REM ret nc; Back to BASIC
1450 REM ;
1460 REM .all_ok
1470 REM cp 20
1480 REM jr c,back_again
1490 REM cp ">"
1500 REM jr nz,over1
1510 REM ;CALCULATE NEWLINE POSITION
1520 REM ld de,&50
1530 REM and a
1540 REM sbc hl,de
1550 REM ld de,&800
1560 REM add hl,de
1570 REM jr nc,all_ok2
1580 REM ld de,&c050
1590 REM add hl,de
1600 REM ;
1610 REM .all_ok2
1620 REM ld a,(eol)
1630 REM dec a
1640 REM ld (eol),a
1650 REM jr nz,back_again
1660 REM ret;back to basic
1670 REM ;
1680 REM .over1
1690 REM call calc_how_many_pixels
1700 REM ld a,(charcount)
1710 REM cp 4
1720 REM jr c,back_again
1730 REM ;
1740 REM .display_loop1
1750 REM ld bc,chardata
1760 REM ld de,0
1770 REM ld a,(bc)
1780 REM srl a
1790 REM rl d
1800 REM srl a
1810 REM rl e
1820 REM inc bc
1830 REM ld a,(bc)
1840 REM srl a
1850 REM rl d
1860 REM srl a
1870 REM rl e
1880 REM inc bc
1890 REM ld a,(bc)
1900 REM srl a
1910 REM rl d
1920 REM srl a
1930 REM rl e
1940 REM inc bc
1950 REM ld a,(bc)
1960 REM srl a
1970 REM rl d
1980 REM srl a
1990 REM rl e
2000 REM ld a,d
2010 REM add a,a
2020 REM add a,a
2030 REM add a,a
2040 REM add a,a
2050 REM add a,e
2060 REM ld (hl),a
2070 REM inc hl
2080 REM push hl
2090 REM ld a,(charcount)
2100 REM sub 4
2110 REM ld (charcount),a
2120 REM jr z,ok
2130 REM ld b,a
2140 REM ld de,chardata-1
2150 REM ld hl,4
2160 REM add hl,de
2170 REM .mloop1
2180 REM inc hl
2190 REM inc de
2200 REM ld a,(hl)
2210 REM ld (de),a
2220 REM ld (hl),a
2230 REM djnz mloop1
2240 REM ;
2250 REM .ok
2260 REM pop hl
2270 REM ld a,(charcount)
2280 REM cp 4
2290 REM jr nc,display_loop1
2300 REM jp back_again
2310 REM ;===================================
2320 REM .calc_how_many_pixels
2330 REM push hl
2340 REM ld hl,ref_table
2350 REM sub a,33
2360 REM add a,l
2370 REM ld l,a
2380 REM ld a,(hl)
2390 REM ld e,a
2400 REM srl a
2410 REM srl a
2420 REM srl a
2430 REM srl a
2440 REM inc a
2450 REM ld b,a
2460 REM push bc
2470 REM ld a,(charcount)
2480 REM ld c,a
2490 REM add a,b
2500 REM ld (charcount),a
2510 REM ld b,0
2520 REM ld hl,chardata-1
2530 REM add hl,bc
2540 REM ld a,e
2550 REM and 15
2560 REM ex de,hl
2570 REM ld h,&80;l,col_table
2580 REM ld l,a
2590 REM ld a,(hl)
2600 REM ex de,hl
2610 REM pop bc
2620 REM .calc_loop1
2630 REM inc hl
2640 REM ld (hl),a
2650 REM djnz calc_loop1
2660 REM pop hl
2670 REM ret
2680 REM ;===================================
2690 REM ;Copy the screen ram into &4000
2700 REM .copy_screen
2710 REM ld de,&4000
2720 REM ld hl,&c000
2730 REM ld bc,&4000
2740 REM ldir
2750 REM ret
2760 REM ;copy &4000 to screen ram
2770 REM .screen_back
2780 REM ld de,&c000
2790 REM ld hl,&4000
2800 REM ld bc,&4000
2810 REM ldir
2820 REM ret
