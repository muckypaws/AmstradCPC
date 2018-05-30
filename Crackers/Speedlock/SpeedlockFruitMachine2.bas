10 ' Alternative Speedlock Transfer For Games Like Fruit Machine Sim.2 & Fast Food Etc.
20 ' Created By The Argonaut 1990
30 MEMORY &7FFF:s=0:FOR i=&8000 TO &80E0:READ a$:e=VAL("&"+a$):POKE i,e:s=s+i*e:NEXT
40 IF s<>-895410135 THEN PRINT"Error In data":END
50 CLS:INPUT"Filename for DISC files [OMIT SUFFIX]  ?",savename$
60 IF LEN(savename$)>8 OR LEN(savename$)<1 THEN 50
70 b$=SPACE$(8):FOR i=1 TO 8:MID$(b$,i,1)=MID$(savename$,i,1):NEXT
80 FOR i=0 TO 7:POKE &80D7+i,ASC(MID$(b$,i+1,1)):NEXT:MODE 1:CALL &BBFF:CALL &BC02
90 PRINT"Insert Formatted Disc & Press Space.":PEN 2:LOCATE 1,10
100 PRINT"Create Loader For Game by Running ARGLDR after transfer.  ";
110 PEN 1:WHILE INKEY$<>" ":WEND:CALL &8000
120 DATA f3,31,f8,bf,01,c0,7f,ed,49,cd,37,bd,3e,ff,cd,6b,bc,11,00,01,06,00,cd,77,bc,eb
130 DATA e5,c5,cd,83,bc,e5,cd,7a,bc,21,6d,80,11,80,be,01,ff,00,ed,b0,21,ff,b0,11,40,00
140 DATA 01,07,00,cd,ce,bc,c1,d1,e1,c5,cd,d0,be,01,03,00,cd,19,bd,10,fb,0d,20,f8,cd,37
150 DATA bd,21,37,bd,e5,11,3a,bd,01,03,00,ed,b0,21,6a,80,d1,0e,03,ed,b0,21,ff,ab,11,40
160 DATA 00,c9,c3,80,be,f3,e1,31,f8,bf,e5,11,e7,ab,21,34,c3,01,1d,2d,c5,e5,1a,77,23,13
170 DATA 10,fa,e1,3e,08,84,30,07,3e,50,85,6f,3e,c8,8c,f6,c0,67,c1,0d,20,e4,cd,3a,bd,21
180 DATA ff,b0,11,40,00,0e,07,cd,ce,bc,21,00,c0,11,00,40,01,00,00,cd,d0,be,21,40,00,11
190 DATA a8,ab,c1,cd,d0,be,c7,c5,d5,e5,21,f3,be,34,21,ea,be,06,0a,cd,8c,bc,e1,d1,c1,3e
200 DATA 02,cd,98,bc,c3,8f,bc,46,52,55,49,54,49,49,20,2e,30
