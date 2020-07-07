10 ' Raw Data Creator
20 ' I'll Do Some Refinements One Day.....
30 MODE 1:MEMORY &3FFF
35 INPUT "Load : ",a$:LOAD a$,&8000
40 INPUT"Name for ASCII file ",n$:n$=UPPER$(n$)
50 OPENOUT n$:name$=n$
60 ad=&8000
70 INPUT"Length : ",ad2$:ad2=VAL("&"+ad2$)+ad
80 l=10000:l1=l
90 n=26
100 PRINT:PRINT"Saving ";name$
110 FOR a=ad TO ad2 STEP n:PRINT#9,STR$(l);" DATA ";
120 cs=0:PRINT#9,HEX$(PEEK(a),2);:cs=cs+PEEK(a)
130 FOR x=1 TO n-1
140 IF a+x>ad2 THEN 170
150 PRINT#9,",";HEX$(PEEK(a+x),2);:cs=cs+PEEK(a+x):NEXT
160 PRINT#9,:l=l+10:NEXT
170 CLOSEOUT
