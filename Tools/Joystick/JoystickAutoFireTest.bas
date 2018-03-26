10 ' Joystick Auto Fire Tester
20 BORDER 0:INK 0,0:INK 1,25:MODE 2
30 PRINT"Joystick Auto Fire Tester - Jason Brooks 1989"
40 a=JOY(0) AND 16:IF a=0 THEN 40:'Wait For Next 0 Pulse
50 mark=0:space=1
60 WHILE JOY(0) AND 16=16:mark=mark+1:WEND
70 WHILE (JOY(0) AND 16)=0:space=space+1:WEND 
80 LOCATE 30,10:PRINT"Mark  :     ";mark:LOCATE 30,10:PRINT"Space :     ";space
90 GOTO 50
