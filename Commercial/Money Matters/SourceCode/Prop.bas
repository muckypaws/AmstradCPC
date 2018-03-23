10 ' DATA Loader for proportional Character Sets.
20 ' Written By Jason Brooks (C) 1992 JacesofT Software
30 ' All Rights Reserved
50 MEMORY &6FFF:RESTORE 240
60 i=1:WHILE i<=46
70 READ a,b
80 c%=(a*16)+b
90 POKE &6FFF+i,c%
100 i=i+1:WEND
110 SAVE"proptabl",b,&7000,46
200 ' Proportional Data For Character Set.  Please Note :-
210 ' A space has been allowed for to the right of the character !
220 ' This set corresponds to the standard ascii set !
240 DATA 3,2,4,6,6,4,7,3,5,5,6,6,3,5,2,6
250 ' "0123456789*;<=>?@"
260 DATA 5,4,5,5,6,5,6,5,5,5,2,3,6,5,6,5,6
270 ' "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
280 DATA 5,6,6,6,6,6,6,6,6,6,6,6,6,6
290 DATA 7,6,7,6,6,6,5,6,6,5,6,6
300 ' "[\]^_'"
310 DATA 3,5,3,6,3,4
320 ' "abcdefghijklmnopqrstuvwxyz"
330 DATA 6,6,5,6,5,5,5,6,4,5,6,4,8,6,5,6,6
340 DATA 6,6,6,5,6,8,6,5,6,0
