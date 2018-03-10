10 ' Speedlock 8K / 6K Read Disk Decoder
20 ' Designed & Written By Jason - THE ARGONAUT - Brooks
30 ' (C) 1990 JacesofT Software Ltd.
40 MEMORY &3FFF:LOAD"8kcopier.trf",&4000
50 CALL &BBFF:CALL &BC02:PEN 1:PAPER 0:BORDER 0:INK 0,0:INK 1,25:MODE 2
60 PRINT"The Speedlock 8K / 6K Read Disk Decoder"
70 PRINT"Written By THE ARGONAUT"
80 PRINT"(C) 1990 Jacesoft Software Ltd."
90 PRINT:PRINT"Instructions : Insert Source Disk In Drive A: And Press Space"
100 PRINT"If Successful Game Will Appear To Load As Normal, But When Finished"
110 PRINT"The Border Will Turn Blue, And A Continuous Bleep May Be Heard."
120 PRINT"Insert A Freshly Formatted Disk In DRIVE A: And Press The ";CHR$(34);"T";CHR$(34);" Key."
130 PRINT"Once The Data Has Been Recorded An Automatic Reset Is Performed"
140 PRINT"Most Games Have Extra Game Data Stored On The Disk. Use A Program Such As"
150 PRINT"Procopy (From NEMESIS), Discology, Nirvana To Copy All Normal Tracks From Around"
160 PRINT"Track 19 - Track 41"
170 PRINT"Write Protect Your Disk. Although You Appear To Have Around 100K Free, Infact"
180 PRINT"You Will Have 0K Free."
190 PRINT"To Run The Game Type RUN";CHR$(34);"DISC";CHR$(34)
200 FOR i=&BE80 TO &BE8E:READ a$:POKE i,VAL("&"+a$):NEXT
210 PRINT"Press Space To Attempt Copy !"
220 WHILE INKEY$<>" ":WEND
230 CALL &BE80
240 DATA f3,21,00,40,11,00,10,01,00,0A,ed,b0,c3,00,10
