10 ' A 464 - 664 Version Of Willow Pattern Copier Including The Screen.
20 ' Copy The Screen Using The Same Method As The 6128 People. And Then Run
30 ' This Routine.  RENAME YOUR COPY OF WILLOW PATTERN SO THAT 1Q = 2PATTERN
40 ' AND 2Q = 3PATTERN
50 ' THIS ROUTINE WILL SAVE THE CORRUPTED PART OF THE SCREEN.
60 ' To Run The Game Use The Next Loader
70 lin=0:addr=&9C00
80 tot=0
90 FOR i=1 TO 20:READ a$:POKE addr,VAL("&"+a$):addr=addr+1:tot=tot+VAL("&"+a$):NEXT 
100 READ chk$:IF tot<>VAL("&"+chk$) THEN PRINT"Error in line ";lin+21*10:END
110 lin=lin+10:IF lin<>20 THEN 80
120 SAVE"1PATTERN",b,&2000,3800:|BASIC
130 DATA 21,3D,C0,11,00,20,06,08,C5,0E,19,06,13,7E,12,23,13,10,FA,D5,0507
140 DATA 11,3D,00,19,D1,0D,3E,00,B1,20,EC,2E,3D,C1,10,E4,C9,00,00,00,0629
