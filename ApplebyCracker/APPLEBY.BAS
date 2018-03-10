10 ' The Appleby Tape To Disk Hack
11 ' (C) 1989 Jason Brooks
12 ' Original Written For NEMESIS
13 ' Revised 1st March 1991 - By Jason Brooks
14 ' (C) All Rights Reserved. - Must Not Be Used For Infringing Copyright.
15 MODE 0:BORDER 6:INK 0,6:INK 1,26
16 CALL &BBFF:CALL &BC02:BORDER 0:INK 0,0:INK 1,25
17 PAPER 0:PEN 3:MODE 1:PRINT"    >>>> Appleby Tapes To Disk <<<<"
18 PRINT"  **** Experimental Version 1.91 ****"
19 PRINT"Information :-"
20 PRINT"Option A"
21 PRINT"This Option Will Transfer All Of The"
22 PRINT"Appleby Tapes And Is The One To Use For"
23 PRINT"Most Cases"
24 PRINT"Option B"
25 PRINT"This Option Is For The Tapes Which Have"
26 PRINT"Only 1 Title Page But The Inks Have Been"
27 PRINT"Altered Such As THUNDER BLADE Or For""
28 PRINT"Games Where You Want The First Screen."
30 PRINT"Such As SOLOMON'S KEY..Press A Key"
31 CALL &BB18
32 MODE 1
33 PRINT"Filenames Are Automatically Detected"
34 PRINT"

Directly From The Tape"
35 PRINT"Once The Transfer Has Finished"
36 PRINT"You Return Back To Basic. Catalogue Your"
37 PRINT"Disk And Run The File According To The"
38 PRINT"Cassette.  For Example SOLOMON'S KEY"
39 PRINT"Will Become SOLOMON.BIN"
40 PRINT"            Press A Key"
41 CALL &BB18
42 MODE 1:PRINT"Information."
43 PRINT"Revised Edition V1.91"
44 PRINT"Would Appreciate Information On"
45 PRINT"On Transfer Capabilities."
46 PRINT"Which Option Do You Wish To Use:-"
47 PRINT"1) Option A":PRINT"2) Option B"
48 PRINT"Please Make Sure There's About 64K"
49 PRINT"Free On Your Destination Disk."
50 a$=INKEY$:IF a$<>"1" AND a$<>"2" THEN 50
51 IF a$="1" THEN RUN"appleby1",&40
52 RUN"appleby2",&40
