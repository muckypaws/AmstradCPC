10 'Willow Pattern Copier + Screen For the CPC 6128, CPC 664 + 64k,
20 'CPC 464 + DDI1 + 64k. By JASON BROOKS. 1987. To Transfer First use BONZO'S
30 'RAMDAM. To Put The Screen Onto Disk. First Run Ramdam As Normal Enter N for
40 'For The Reset Block And Use Ramdam A. When Told to PRESS PLAY AND ANY KEY:
50 'Press Any Key And When The Relay Clicks Press Escape And Type The Following
60 'In Direct Mode ( No Line Numbers )
70 'FOR I=&BEA0 TO &BEE8:POKE I,0:NEXT
80 'POKE &BEFA,&35:POKE &BEFB,&BF:POKE &BF00,&00:POKE &BF01,&C0
90 'POKE &BF08,&00:POKE &BF09,&40:POKE &BF15,&C9:POKE &BF35,&32
100 'FOR I=0 TO 7:PAPER #I,0:NEXT:RUN"
110 'Now Wait As The Game Loads. When The Title Page Has Appeared Hold Down The
120 'TAB Key. It May Take Until The Next Block Loads In. The Title Page Will
130 'Then Be Saved As 3Q.BIN  Rename this to SCREEN.BIN And Use This Loader
140 ' You Could Even Use This Routine As A Title Page Copier.  This would 
150 ' Most Likely Copy DragonTorc Without Screen Distortion !!!!!
160 lin=0
170 addr=&BE80
180 tot=0
190 FOR i=1 TO 20:READ a$:POKE addr,VAL("&"+a$):addr=addr+1:tot=tot+VAL("&"+a$):NEXT 
200 READ chk$:IF tot<>VAL("&"+chk$) THEN PRINT"Error in line ";lin+21*10:END
210 lin=lin+10:IF lin<>90 THEN 180
220 SAVE"willow",b,&BE80,&B0,&BE80
230 DATA 21,D4,AD,11,FC,A6,0E,07,CD,CE,BC,01,00,7F,3E,C4,ED,79,06,06,08B5
240 DATA 21,28,BF,CD,77,BC,21,00,40,CD,83,BC,CD,7A,BC,01,00,7F,3E,C0,08F6
250 DATA ED,79,21,2E,BF,34,06,02,11,40,00,D5,CD,77,BC,E1,CD,83,BC,CD,0990
260 DATA 7A,BC,00,3E,C9,32,BE,BE,21,00,C1,22,B1,BE,CD,AA,BE,CD,37,BD,0A54
270 DATA 31,80,BF,F3,11,00,92,21,00,C2,01,D7,2C,ED,B0,21,00,C1,11,80,07FD
280 DATA BF,01,80,00,ED,B0,3E,C9,32,9F,BE,2A,9C,C1,E5,F1,ED,5B,94,C1,0B6D
290 DATA ED,4B,96,C1,DD,2A,98,C1,FD,2A,9A,C1,ED,7B,90,C1,F5,CD,06,B9,0CAB
300 DATA F1,D9,01,00,7F,C5,3E,C4,ED,79,21,00,40,11,00,C0,01,80,3F,ED,0856
310 DATA B0,C1,3E,C0,ED,79,D9,C9,53,43,52,45,45,4E,30,51,51,00,00,00,0809
