10 ' Loader For Transfered Games (Like Fast Food, Fantasy World Dizzy Etc.)
11 'Created By The Argonaut 1990 : Alter savename$ to File Name For Loading
12 MEMORY &7FFF:s=0:FOR i=&BE80 TO &BF03:READ a$:e=VAL("&"+a$):POKE i,e:s=s+i*e:NEXT
13 IF s<>-300188735 THEN PRINT"Error In Data Lines Please Check, ":END
14 savename$="FRUITII":b$=SPACE$(8):FOR i=1 TO 8:MID$(b$,i,1)=MID$(savename$,i,1):NEXT
15 FOR i=0 TO 7:POKE &BEFA+i,ASC(MID$(b$,i+1,1)):NEXT:MODE 1:CALL &BBFF:CALL &BC02
16 PRINT"Insert Disk With Files .1 .2 .3 & Press Space.":WHILE INKEY$<>" ":WEND
17 SAVE savename$,b,&BE80,&84,&BE80
18 DATA F3,31,F8,BF,01,C0,7F,ED,49,CD,D7,BE,CD,E2,BE,3E,C3,11,9E,BE,32,77,BC,ED,53,78
19 DATA BC,CD,D6,BE,F3,31,F8,BF,CD,37,BD,CD,D7,BE,CD,E2,BE,C4,D6,BE,CD,E2,BE,E5,11,E7
20 DATA AB,21,34,C3,01,1D,2D,C5,E5,7E,12,23,13,10,FA,E1,3E,08,84,30,07,3E,50,85,6F,3E
21 DATA C8,8C,67,C1,0D,20,E6,E1,E9,21,FF,B0,11,40,00,0E,07,C3,CE,BC,21,03,BF,34,21,FA
22 DATA BE,06,0A,CD,77,BC,EB,CD,83,BC,E5,CD,7A,BC,E1,7D,B4,C9,46,52,55,49,54,49,49,20
23 DATA 2E,30
