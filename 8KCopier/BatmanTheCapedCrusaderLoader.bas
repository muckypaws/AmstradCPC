10 ' Batman - The Caped Crusader 8K / 6K Read Fix.
20 ' Designed, Created And Written By THE ARGONAUT (C) 1990
30 MODE 2:PEN 1:PAPER 0:CALL &BC02:BORDER 0:INK 0,0:INK 1,25
40 MEMORY &2FFF:LOAD"batman.bkp",&3000
50 LOAD"batman.lod",&8000
60 PRINT"Batman The Caped Crusader Fix."
70 PRINT"(C) 1990 THE ARGONAUT"
80 PRINT"Instructions ? ";
90 a$=INKEY$:IF a$="" THEN 90
100 a$=UPPER$(a$):IF a$<>"Y" AND a$<>"N" THEN 90
110 PRINT a$:IF a$="Y" THEN GOSUB 390
120 MODE 1:LOCATE 5,10:PRINT"2STAGE 13 - Back-Up First Game."
130 LOCATE 5,12:PRINT"2STAGE 23 - Back-Up Second Game."
140 LOCATE 5,14:PRINT"2STAGE 33 - Back-Up Title Page."
150 LOCATE 5,16:PRINT"1Put Loader Onto Back-Up Disk."
160 LOCATE 5,18:PRINT"3Press 21, 2, 3 or P3 To Select."
170 a$=INKEY$:IF a$="" THEN 170
180 a$=UPPER$(a$):IF a$<"1" OR a$>"3" AND a$<>"P" THEN 170
190 IF a$="1" OR a$="2" THEN 300
200 IF a$="3" THEN 280
210 CLS:PRINT"2As A Bonus I'll Let You Have A":PRINT"Cheat Mode."
220 PRINT"Insert Your Destination Disk"
230 PRINT"In Drive A: And Press A Key."
240 CALL &BB18
250 SAVE"a:batman",b,&8000,&230,&8000
260 PRINT"Thank You For Your Time."
270 END
280 ' Transfer Title Page
290 POKE &3459,255
300 ' Transfer Main Game Over.
310 CLS:PRINT"Please Insert Your BATMAN Disk In"
320 PRINT"Drive A:":PRINT"3Press 'T' When Ready."
330 a$=INKEY$:IF a$<>"T" AND a$<>"t" THEN 330
340 PRINT"Remember When Border Turns Blue"
350 PRINT"And A Tone Is Heard, Swap Disks"
360 PRINT"And Press 'T'"
370 FOR i=0 TO 500:NEXT:CALL &3000
380 END
390 ' Instructions
400 WHILE a$<>" ":READ a$:PRINT a$:WEND
410 WHILE INKEY$<>" ":WEND
420 RETURN
430 ' Instruction Data.
440 DATA "This Utility Is Simple To Use.  It Basically Allows You To Back-Up Your Own."
450 DATA "Batman The Caped Crusader Disk.  Which The Standard Utility Won't Do."
460 DATA "First Have A Blank Disk Formatted To DATA Ready."
470 DATA "You Will Have To Back This Disk Up In 3 Stages."
480 DATA "Stage One, Select This Option Follow The Prompts And Select Either Game."
490 DATA "Stage Two, As Stage One But Select The Other Game."
500 DATA "Stage Three, This Will Get The TITLE PAGE And SELECTION PAGE Out"
510 DATA "Then All You Need Is To Copy The Loader With OPTION P"
520 DATA "If You Have HARRY'S Excellent File Cruncher And Screen Compressor, You May Use"
530 DATA "These On BATPAGE.BIN (Title Page), BATFETE1.BIN, BATBIRD1.BIN Use Harry's"
540 DATA "Option 1 On The Last Two."
550 DATA "Press Space When Ready."
560 DATA " "
