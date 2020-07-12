10 ' ADAM Assembly File Creator For Shrunk Text
20 ' (C) 1990 JacesofT
30 MEMORY &3FFF
40 IF PEEK(&6D00)<>17 THEN LOAD"scrol.cod",&6D00:'LOAD"fruitch1.spr",&7000
50 FOR i=0 TO 15:READ a:INK i,a:NEXT:aswidth=0:i=&4000
60 PEN 1:PAPER 0:MODE 0:PRINT"ADAM - Assembly File":PRINT"Creator For Text."
70 WINDOW 1,20,15,25
80 PEN 3:PRINT"File To Create : "
90 INPUT f$:f$=f$+".ADM"
100 GOSUB 190:GOSUB 210:GOSUB 120:POKE i,&D:i=i+1:POKE i,0:i=i+1:SAVE f$,b,&4000,(i-&4000+5),(i-&4000+5)
110 END
120 ' Input Character
130 a$=INKEY$:IF a$="" THEN 130
140 a=ASC(a$):IF a<&1F THEN GOSUB 340:GOSUB 170:GOTO 130
150 IF a>200 THEN RETURN ELSE GOSUB 250
160 GOSUB 170:GOTO 120
170 ' Display Character Inputted
180 POKE &6D5B,ASC(a$):CALL &BD19:CALL &6D00:CALL &6D00:RETURN
190 ' Insert REM Statement In ADAM Form.
200 POKE i,255:i=i+1:POKE i,&D:i=i+1:RETURN
210 ' Insert DEFM Statement
220 POKE i,&C5:i=i+1:RETURN
230 ' Insert DEFB Statement
240 POKE i,&C3:i=i+1:RETURN
250 ' Insert Ascii Character
260 IF a$=CHR$(34) THEN a$="a":GOTO 320
270 IF a$="," THEN a$="[":GOTO 320
280 IF a$="[" THEN a$="\":GOTO 320
290 IF a$="]" THEN a$="]":GOTO 320
300 IF a$=" " THEN a$="@":GOTO 320
310 IF a$="." THEN a$="^":GOTO 320
315 IF a$="+" THEN a$="_":GOTO 320
316 IF a$="-" THEN a$="`":GOTO 320
320 aswidth=aswidth+1:IF aswidth=26 THEN POKE i,&D:i=i+1:aswidth=0:GOSUB 210
330 POKE i,ASC(a$):i=i+1:RETURN
340 ' Insert Colour Command
350 POKE i,&D:i=i+1:GOSUB 230:a=ASC(a$):IF a<10 THEN POKE i,a+&30 ELSE POKE i,&31:i=i+1:POKE i,a+38
360 i=i+1:POKE i,&D:i=i+1:aswidth=0:GOSUB 210:RETURN
370 DATA 0,6,15,25,22,18,12,1,2,5,11,26,24,4,3,7
