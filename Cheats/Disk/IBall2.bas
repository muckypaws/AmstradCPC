10 ' I BALL II. By
11 ' Miss Rebecca
12 ' Claxton
13 ' (SANDIACRE)
14 DATA 2A,38,BD,22,00,BE
15 DATA 2A,01,BB,22,38,BD
16 DATA 3E,C3,21,1A,BE,32
17 DATA A7,BC,22,A8,BC,C3
18 DATA 00,8D
19 DATA 2A,00,BE,22,38,BD
20 DATA CD,37,BD,AF,32,4F
21 DATA 1A,32,B3,21,3E,18
22 DATA 32,BD,22,3E,5E,32
23 DATA 4F,24,3D,32,59,24
24 DATA C3,A7,BC
25 SYMBOL AFTER 256
26 MEMORY &484F
27 SYMBOL AFTER 32
28 MODE 1:MEMORY 9999
29 LOAD"!IBALL1
30 ENV 1,15,1,16
31 ENT 1,130,-2,2
32 ENV 2,15,-1,16
33 ENT 2,130,2,2
34 ENV 3,15,-1,5
35 ENT 3,13,20,2
36 ENT 4,8,-20,4
37 ENV 4,4,-3,1
38 ENT 5,8,-10,4,8,10,4,8,-10,4,8,10,4
39 ENV 5,1,7,1,7,-1,1
40 ENT 6,8,10,32,8,-10,32
41 ENV 6,7,1,4,1,-7,4
42 ENT 7,16,-10,1
43 ENV 7,15,-1,3
44 ENT 8,239,20,1
45 BORDER 0:INK 0,0
46 WINDOW #1,1,20,1,1
47 WINDOW #2,1,20,3,3
48 FOR i=&BE00 TO &BE3A
49 READ a$:a=VAL("&"+a$)
50 POKE i,a:s=s+a:NEXT
51 IF s<>5675 THEN 53
52 CALL &BE00
53 PRINT"Data Error"
