10 ' Calendar Calculator Written By Jason Brooks
20 ' Algorithm Only.
22 DEFINT a-z
25 DIM months(12),day$(7):FOR i=1 TO 12:READ months(i):NEXT:FOR i=0 TO 6:READ day$(i):NEXT
30 MODE 2:BORDER 0:INK 0,0:INK 1,25
40 INPUT" Year : ",year
50 INPUT"Month : ",month
60 INPUT"Date  : ",date
70 ' Validate Date
75 flag=0
80 IF month<1 OR month>12 THEN 50
90 IF date<1 OR date>months(month) THEN GOSUB 1900
100 IF flag<>0 THEN 60
200 GOSUB 1700
205 GOSUB 1500
210 PRINT:PRINT julian:PRINT:PRINT
998 GOTO 40
999 END
1400 ' Calculate Day For Dates < 1992
1410 ' Subtract 2 Days Per Leap Year And 1 Day Per Normal Year
1420 ' If Day<0 Then Day=Day+7 !
1430 day=2:FOR z=year TO 1990:GOSUB 1800:day=day-leap:IF day<0 THEN day=day+7
1440 NEXT:day=((day-(365-julian))MOD 7):IF day<0 THEN day=day+7
1450 GOTO 1530
1500 ' Calculate Day For 1992
1510 GOSUB 1700
1515 IF year>1992 THEN 1600
1516 IF year<1992 THEN 1400
1520 day=(2+julian) MOD 7
1530 PRINT "On The Date :";date;month;year;" The Day Will Be : "day$(day)
1540 RETURN
1600 ' Calculate Day For Dates > 1992
1610 ' Add 2 Days Per Leap Year And 1 day Per Normal Year.
1620 day=3:FOR z=1992 TO year-1:GOSUB 1800:day=day+leap:NEXT:day=(day+julian-1)MOD 7
1630 GOTO 1530
1700 ' Convert Month Date And Year Into JULIAN date for that year.
1710 julian=0:FOR i=1 TO month-1:julian=julian+months(i):NEXT
1720 julian=julian+date
1730 IF julian<60 THEN RETURN
1740 IF year MOD 4=0 THEN julian=julian+1
1745 IF year MOD 100=0 AND (year/400)<>INT(year/400) THEN julian=julian-1
1750 RETURN
1800 ' Check If Leap Year And Set Variable Accordingly.
1810 IF z MOD 4=0 THEN leap=2 ELSE leap=1
1820 IF z MOD 100=0 AND (z/400)<>INT(z/400) THEN leap=1
1830 RETURN
1900 ' Validation For A Leap Year.
1905 flag=1
1910 IF month<>2 THEN RETURN
1920 IF month=2 AND date<>29 THEN RETURN
1930 IF year MOD 4=0 THEN flag=0
1940 RETURN
2000 ' Days Per Month Data
2010 DATA 31,28,31,30,31,30,31,31,30,31,30,31
2020 ' Days Names Per Week Data
2030 DATA Sunday
2040 DATA Monday
2050 DATA Tuesday
2060 DATA Wednesday
2070 DATA Thursday
2080 DATA Friday
2090 DATA Saturday
