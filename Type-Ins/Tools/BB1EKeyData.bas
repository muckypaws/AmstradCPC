10 ' Key Getter For Calls To &BB1E Written By J.Brooks '86
11 RESTORE:CLEAR
12 CALL &BBFF:CALL &BC02:BORDER 0:INK 0,0:INK 1,25:PAPER 0:PEN 1:MODE 2
13 t$="DH":PRINT "Are You Entering Numbers In Hex Or Dec ? "
14 a$=UPPER$(INKEY$):IF a$="" THEN 14
15 t=INSTR("DH",a$):IF t=0 THEN 14
16 FOR i=1 TO 80:LOCATE i,1:PRINT"*";:LOCATE 81-i,25:PRINT"*";:NEXT
17 FOR i=2 TO 24:LOCATE 80,i:PRINT"*";:LOCATE 1,26-i:PRINT"*";:NEXT
18 LOCATE 13,6:PRINT"Keyboard Analysis Program"
19 LOCATE 40,8:PRINT"Written By Jason Brooks 1986"
20 ' Initialize
21 DIM keyboard(90),keyboard$(90),ke$(90)
22 template$="ABCDEF0123456789":IF t=1 THEN template$=RIGHT$(template$,10)
23 FOR i=1 TO 79:READ keyboard(i):NEXT:FOR i=1 TO 79:READ keyboard$(i):NEXT
24 FOR i=1 TO 79:ke$(keyboard(i))=keyboard$(i):NEXT
25 ' Get Keynumbers & Display Actual Key
26 LOCATE 20,14:PRINT"Enter Key Number : "
27 LOCATE 26,18:PRINT"Actual Key : "
28 ' Get Key Presses
29 x=0:b$=""
30 WHILE x<>2
31 a$=UPPER$(INKEY$):IF a$="" THEN 31 ELSE IF INSTR(template$,a$)=0 THEN 31
32 x=x+1:IF x=1 THEN LOCATE 39,14:PRINT"  "
33 LOCATE 38+x,14:PRINT a$:b$=b$+a$
34 WEND
35 IF t=1 THEN ke=VAL(b$) ELSE ke=VAL("&"+b$)
36 LOCATE 39,18:PRINT SPACE$(20):LOCATE 39,18
37 IF ke>79 THEN 39
38 IF ke$(ke)="" THEN PRINT "Un-Defined" ELSE PRINT ke$(ke)
39 GOTO 28
40 ' Key Data
41 DATA 66,64,65,57,56,49,48,41,40,33,32,25,24,16,79,10,11,3
42 DATA 68,67,59,58,50,51,43,42,35,34,27,26,17,18,20,12,4
43 DATA 70,69,60,61,53,52,44,45,37,36,29,28,19,13,14,5
44 DATA 21,71,63,62,56,54,46,38,39,31,30,22,15,0,7
45 DATA 23,9,47,6,8,2,1
46 DATA 72,74,75,73,76,77
47 ' Key Words
48 DATA Escape,1,2,3,4,5,6,7,8,9,0,-,^,CLR,Delete,F7,F8,F9
49 DATA Tab,Q,W,E,R,T,Y,U,I,O,P,@,[,Return,F4,F5,F6
50 DATA Caps Lock,A,S,D,F,G,H,J,K,L,":",";","]",F1,F2,F3
51 DATA Shift,Z,X,C,V,B,N,M,",",.,/,\,F0,Cursor Up,F.
52 DATA Control,Copy,Space,Enter,Cursor Left,Cursor Down,Cursor Right
53 DATA Joystick Up,Joystick Left,Joystick Right,Joystick Down
54 DATA Joystick Fire 2,Joystick Fire 1
