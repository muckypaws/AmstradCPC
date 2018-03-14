10 MODE 2
20 MEMORY &A1FF
30 LOAD"copier.bin",&A200
40 MODE 2
50 BORDER 0:INK 0,0:INK 1,26
60 PRINT"Jason's         B.A.S.I.C.        Deprotector"
70 PRINT CHR$(22);CHR$(1);:LOCATE 1,1:PRINT"_______         __________        ___________"
80 PRINT"This utility will transfer Protected Basic SAVEd by the ,p method onto the       following :-"
90 PRINT" Tape to Tape"
100 PRINT" Tape to Disc"
110 PRINT" Disc to Tape"
120 PRINT" Disc to Disc"
130 PRINT"Please input the following information please"
140 PRINT" 1 = Tape    2 = Disc"
150 PRINT"From which is the source file to be loaded"
160 INPUT source
170 IF source<1 OR source>2 THEN PRINT"Shut up dimmy and answer properly":GOTO 140 
180 PRINT"To what is the source file to be copied onto"
190 INPUT destination 
200 IF destination<1 OR destination>2 THEN PRINT"Are you thick or something":GOTO 180
210 IF source=1 THEN |TAPE.IN
220 IF source=2 THEN |DISC.IN
230 IF destination=1 THEN |TAPE.OUT
240 IF destination=2 THEN |DISC.OUT
250 PRINT"Please input the length of the file you want to copy If in doubt use my header program to find the length on tape (or for disc multiply the number of K shown when you catalogue by 1024"
260 INPUT length
270 length$=HEX$(length,4)
280 part$=LEFT$(length$,2)
290 part1$=RIGHT$(length$,2)
300 CLS
310 IF source=1 THEN 340
320 INPUT"Please type in the file name for the source file";source$:IF LEN(source$)>12 THEN 320
330 FOR i=1 TO LEN(source$):POKE &A231+i,ASC(MID$(source$,i,1)):NEXT
340 INPUT"What is the destination file to be called ";dest$:IF LEN(dest$)>12 THEN 340 
350 FOR i=1 TO LEN(dest$):POKE &A23D+i,ASC(MID$(dest$,i,1)):NEXT
360 PRINT"From the information given you wish to transfer Protected BASIC"
370 IF source=1 THEN PRINT"Tape to"; ELSE PRINT"Disc to";
380 IF destination=1 THEN PRINT" Tape" ELSE PRINT" Disc"
390 PRINT"And the length is ";
400 PRINT length$
410 PRINT"This is the length in Hexadecimal"
415 IF LEN(source$)=0 THEN PRINT"The first file on tape is to loaded" ELSE PRINT"The first file name is called ";source$ 
416 IF LEN(dest$)=0 THEN PRINT"The file is Saved as an UNNAMED file on tape" ELSE PRINT"The file to be saved is called ";dest$
420 PRINT"Is this information correct"  
430 CLEAR INPUT
440 a$=INKEY$:IF a$="" THEN 440
450 IF a$="n" THEN RUN 40
460 IF a$="y" THEN 480
470 GOTO 440
480 IF source=1 THEN POKE &A201,0 ELSE POKE &A201,LEN(source$)
490 IF destination=1 THEN POKE &A216,0 ELSE POKE &A216,LEN(dest$)
500 POKE &A224,VAL("&"+part1$)
510 POKE &A225,VAL("&"+part$)
520 IF destination=2 AND source=2 THEN POKE &A214,&C9:PRINT"When loaded the copier will stop and you must insert your destination discand type CALL &A215" ELSE POKE &A214,0
540 PRINT"You will see some weird characters on the screen PLEASE DO NOT WORRY"
545 PRINT"Now type NEW and CALL &A200
550 END
