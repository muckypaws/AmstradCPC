1 ENT -1,1,2,1
2 DIM t(64),m$(10,10),ch(30):RESTORE 2:FOR f=1 TO 30:READ ch(f):NEXT:DATA 1,2,1,2,3,2,6,3,1,8,3,14,5,2,5,2,3,1,2,20,3,3,5,1,7,4,3,2,1,8
3 DIM be(1024),tr(30):RESTORE 3:FOR f=1 TO 20:READ tr(f):NEXT:DATA 10,9,8,20,3,6,14,7,3,5,9,1,6,6,6,9,15,13,5,1,1,1,2,2,2,2,2,10,4
4 GOSUB 9000:CALL &A000
5 RESTORE 8:FOR f=0 TO 15:READ a:INK f,a:NEXT
6 GOSUB 2000
7 sc=0:le=1:li=3:GOSUB 800
8 DATA 1,24,20,6,9,12,18,3,6,13,26,16,11,0,23,15
10 MODE 0:CLS:WINDOW #1,1,20,21,23:PEN #1,0:PAPER#1,1:CLS#1
20 FOR f=0 TO 19 STEP 2:|SPRITE,0,f,&A076:|SPRITE,36,f,&A076:NEXT
22 FOR f=0 TO 10:FOR q=0 TO 10:m$(f,q)="":NEXT q,f
25 FOR f=0 TO 10:m$(f,0)=".":m$(f,9)=".":NEXT
35 ti=100
40 LOCATE#1,7,3:PRINT#1,"Score";sc:LOCATE#1,2,1:PRINT#1,"Time";ti;" ":LOCATE#1,12,1:PRINT#1,"Lives";li
45 x=1:y=0:m1=8:m2=8
46 GOSUB 1000
47 m$(5,5)=""
50 |SPRITE,20,10,&A27E
55 |SPRITE,x*4,y*2,&A17A:|SPRITE,m1*4,m2*2,&A1FC
56 IF m$(y,x)="f" THEN SOUND 1,478,6,7,0,1,4:frc=frc-1:sc=sc+50:GOSUB 950:m$(y,x)=""
57 a=x:b=y:m3=m1:m4=m2
58 IF x=m1 AND y=m2 THEN CLS:|SPRITE,x*4,y*2,&A300:GOSUB 750:li=li-1:IF li=0 THEN 2500 ELSE 10
59 IF ti>0 THEN ti=ti-1
61 IF frc=0 AND x=5 AND y=5 THEN 850
62 IF INKEY(lef)=0 THEN IF x>1 THEN IF m$(y,x-1)<>"." THEN x=x-1
64 LOCATE#1,2,1:PRINT#1,"Time";ti;" "
65 IF INKEY(ri)=0 THEN IF x<8 THEN IF m$(y,x+1)<>"." THEN x=x+1
70 IF INKEY(up)=0 THEN GOSUB 100
75 IF INKEY(do)=0 THEN GOSUB 150
77 GOSUB 200
80 |SPRITE,a*4,b*2,&A382:|SPRITE,m3*4,m4*2,&A382
85 GOTO 50
99 CLS:FOR f=1 TO 10:FOR q=1 TO 8:LOCATE q,f:PRINT m$(f,q):NEXT q,f:END
100 IF y=0 THEN y=9:RETURN
105 IF m$(y-1,x)<>"." THEN y=y-1
110 RETURN
150 IF y=9 THEN y=0:RETURN
155 IF m$(y+1,x)<>"." THEN y=y+1
160 RETURN
200 IF m$(m2+1,m1)="" THEN m2=m2-(y>m2)
210 IF m$(m2-(1 AND m2>0),m1)="" THEN m2=m2+(y<m2)
220 IF m$(m2,m1+1)="" THEN m1=m1-(x>m1)
230 IF m$(m2,m1-1)="" THEN m1=m1+(x<m1)
240 RETURN
500 ENV 1,2,0,1,1,-6,1,17,0,1:ENV 2,15,-1,2:ENV 3,7,-2,1,3,0,1
510 RESTORE 511:FOR f=1 TO 64:READ t(f):NEXT
511 DATA 956,716,956,758,716,478,716,478,956,716,956,758,716,478,716,478
512 DATA 956,716,956,758,716,358,716,478,956,716,956,758,716,358,716,358
513 DATA 956,716,956,758,716,506,716,478,956,716,956,758,716,426,716,426
514 DATA 956,716,956,758,716,478,716,478,956,716,956,758,716,478,716,478
520 FOR f=129 TO 1024 STEP 8:be(f)=15:NEXT:FOR f=257 TO 1024 STEP 4:be(f)=15:NEXT:FOR f=257 TO 1024 STEP 32:FOR q=14 TO 0 STEP -1:be((14-q)+f)=q:NEXT q,f:FOR f=513 TO 1024 STEP 64:FOR q=14 TO 0 STEP -1:be(f+q)=q:NEXT q,f
521 FOR f=641 TO 1024:be(f)=0:NEXT:FOR f=673 TO 1024 STEP 32:be(f)=15:NEXT
522 FOR f=705 TO 1024 STEP 32:be(f)=3:be(f+16)=15:NEXT:FOR f=769 TO 1024 STEP 32:FOR q=0 TO 7:be(f+q)=15-(q+1):NEXT q,f:FOR f=897 TO 1024:be(f)=0:NEXT
523 FOR f=897 TO 1024 STEP 8:FOR q=0 TO 7 STEP 2:be(f+q)=8+q:NEXT q,f
525 p1=1:p2=1:ton=1:cou=1:kp=0
526 FOR f=1 TO 32:SOUND 1,0,20,6,1,0,1:FOR q=1 TO 165:NEXT q,f
530 GOSUB 600
532 SOUND 1,0,20,6,1,0,1
540 SOUND 2,t(p1)/ton,20,13,2
550 SOUND 4,0,10,15,3,0,be(p2):SOUND 4,0,10,15,3,0,be(p2+1)
560 p1=p1+1:IF p1=65 THEN p1=1
565 p2=p2+2:IF p2=1025 THEN 575
566 cou=cou+2:IF cou=257 THEN ton=2
567 IF cou=513 THEN ton=4
568 IF cou=769 THEN ton=8
569 IF kp=1 THEN RETURN
570 GOTO 530
575 FOR f=1 TO 32:SOUND 1,0,20,6,1,0,INT(RND*15)+1:FOR q=1 TO 165:NEXT q,f
580 FOR f=1 TO 10000:NEXT:GOTO 500
600 IF INKEY(37)=0 THEN lef=71:ri=63:up=27:do=36:kp=1:GOSUB 630:RETURN
610 IF INKEY(45)=0 THEN lef=74:ri=75:up=72:do=73:kp=1:RETURN
620 RETURN
630 WINDOW #1,4,16,8,13:PEN#1,6:PAPER#1,12:CLS#1:LOCATE#1,4,2:PRINT#1,"Z-Left":LOCATE#1,4,3:PRINT#1,"X-Right":LOCATE#1,4,4:PRINT#1,"P-Up":LOCATE#1,4,5:PRINT#1,"L-Down":FOR f=1 TO 5000:NEXT f:RETURN
750 ENT -3,2,-1,2,2,1,2:RESTORE 770:FOR f=1 TO 11:READ no,nno,du:SOUND 1,no,du*10,7,0,3:SOUND 2,nno,du*10,7,0,3:FOR q=1 TO du*120:NEXT q,f
760 RETURN
770 DATA 253,169,3,253,169,2,253,169,1,253,169,3,213,142,2,225,150,1,225,150,2,253,169,1,253,169,2,179,284,1,253,169,2
780 MODE 0:CLS:TAG:FOR f=400 TO 250 STEP -4:SOUND 1,401-f,1,7:MOVE 400-f,f:PRINT"game over";:NEXT:TAGOFF:FOR f=1 TO 2000:NEXT:RETURN
800 MODE 0:CLS:LOCATE 7,10:PRINT"Level";le:FOR f=1 TO 2000:NEXT:RETURN
850 FOR f=ti TO 0 STEP -1:ti=f:SOUND 1,1,1,7:sc=sc+1:GOSUB 950:NEXT
855 le=le+1:IF le>30 THEN 3000 ELSE GOSUB 800:GOTO 10
900 FOR q=1 TO frc
905 fr1=INT(RND*8)+1:fr2=INT(RND*7)+1:IF m$(fr2,fr1)<>"" THEN 905 ELSE IF fr1=5 AND fr2=5 THEN GOTO 905 ELSE m$(fr2,fr1)="f"
907 |SPRITE,fr1*4,fr2*2,&A0F8
910 NEXT q:RETURN
950 LOCATE #1,7,3:PRINT#1,"Score";sc:LOCATE#1,2,1:PRINT#1,"Time";ti;" ":RETURN
1000 ' Screen
1005 FOR f=1 TO tr(le)
1010 w1=INT(RND*8)+1:w2=INT(RND*8)+1:IF m$(w1,w2)="." THEN 1010 ELSE |SPRITE,w2*4,w1*2,&A076:m$(w1,w2)="."
1011 NEXT f
1020 frc=ch(le):GOSUB 900:RETURN
2000 MODE 0:CLS:FOR f=0 TO 23 STEP 2:FOR q=0 TO 36 STEP 4:|SPRITE,q,f,&A0F8:NEXT q,f
2010 LOCATE 4,2:PRINT"F R O O T E E":LOCATE 1,20:PRINT"(c) 1987 Brian Round":LOCATE 4,8:PRINT"J - Joystick ":LOCATE 4,10:PRINT"K - Keyboard"
2025 GOTO 500
2500 GOSUB 780:GOTO 5
3000 MODE 0:CLS:FOR f=1 TO 500:LOCATE 3,10:PEN INT(RND*15)+1:PRINT"Congratulations":x=INT(RND*10):y=INT(RND*10):SOUND 1,200+x+(y*40),2,15,3,0,INT(RND*15)+1:|SPRITE,x*4,y*2,&A17A:NEXT:PEN 1:GOTO 5
9000 DATA 01,0e,a0,21,0a,a0,cd,d1,bc,c9,0,0,0,0,13,a0,c3,1a,a0,53,50,52,49,54,c5,00,cd,19,bd,11,50,00,21,b0,bf,dd,46,02,04,19,10,fd,dd,7e,04,07,5f,16,00,19,dd,56,01,dd,5e,00,1a,47,13,1a,4f,13,c5,e5,e5,d5,11,75,a0,3e,00,12,7e,cb,7f,20,05,f5,3e,aa,12,f1,cb
9010 DATA 77,20,04,1a,f6,55,12,eb,d1,1a,00,e1,00,77,23,13,10,db,e1,01,00,08,09,30,04,01,50,c0,09,c1,0d,20,ca,c9,00
9020 RESTORE 9000:FOR f=0 TO 117:READ a$:POKE &A000+f,VAL("&"+a$):NEXT
9024 RESTORE 9025:FOR f=0 TO 779:READ a:POKE &A076+f,a:NEXT 
9025 DATA 8,16,0,0,0,16,32,0,0,0,0,0,0,16,32,0,0,0,0,0,0,48,48,0,0,0,0,0,0,112,56,0,0,0,0,0,16,112,56,32,0,0,0,0,16,112,60,32,0,0,0,0,48,112,60,48,0,0,0,0,48,240,180,56,0,0,0,16,48,240,180,56,32,0,0,16,48,240,180,60,32,0,0,48,48,48,48,48,48,0,0,0,0,252
9026 DATA 169,0,0,0,0,0,0,252,169,0,0,0,0,0,0,252,169,0,0,0,0,0,0,252,169,0,0,0,0,0,0,252,169,0,0,0
9029 DATA 8,16,0,0,0,0,0,0,0,0,0,0,0,0,0,16,48,0,0,0,0,0,16,48,32,0,0,0,0,16,48,32,0,0,0,0,0,48,48,0,0,0,0,0,48,32,16,32,0,0,0,16,48,0,0,48,0,0,0,48,0,0,0,48,32,0,84,252,252,0,84,252,252,0,252,86,252,168,252,86,252,168,169,252,252,168,169,252,252,168
9030 DATA 169,252,252,168,169,252,252,168,252,252,252,168,252,252,252,168,252,252,252,168,252,252,252,168,252,252,252,168,252,252,252,168,84,252,252,0,84,252,252,0
9031 DATA 8,16,0,0,0,0,0,0,0,0,0,0,0,15,15,0,0,0,0,0,5,207,207,10,0,0,0,0,5,199,203,10,0,0,0,0,5,207,207,10,0,0,0,0,0,203,199,0,0,0,0,0,0,69,138,0,0,0,0,0,0,51,51,0,0,0,0,0,17,51,51,34,0,0,0,0,51,17,34,51,0,0,0,0,103,17,34,155,0,0,0,0,207,20,40,207,0,0,0
9032 DATA 0,0,84,168,0,0,0,0,0,0,84,168,0,0,0,0,0,0,84,168,0,0,0,0,0,0,15,5,10,0,0
9033 DATA 8,16,0,0,1,3,3,3,0,0,0,1,3,252,252,169,3,0,0,3,15,252,252,15,169,2,1,86,91,252,252,167,252,2,1,252,252,252,252,252,252,3,3,252,173,15,15,94,252,169,86,252,91,243,243,167,252,169,3,173,243,243,243,243,94,3,1,86,15,243,243,15,169,2,0,3,252,15,15
9034 DATA 252,3,0,0,0,0,0,0,0,0,0,0,0,48,16,16,32,0,0,0,0,48,48,16,16,0,0,0,0,32,48,32,56,0,0,0,20,0,52,32,16,0,0,0,0,20,0,20,20,0,0
9035 DATA 8,16,0,84,252,252,252,252,168,0,0,252,252,252,252,252,252,0,84,252,252,252,252,252,252,168,252,252,252,252,252,252,252,252,195,195,195,195,195,195,195,195,135,15,75,195,195,135,15,75,135,195,75,195,195,135,195,75,135,195,75,195,195,135,195,75
9036 DATA 135,15,75,195,195,135,15,75,195,195,195,195,195,195,195,195,195,195,195,195,195,195,195,195,135,15,75,15,15,135,15,75,135,195,75,75,135,135,195,75,135,195,75,75,135,135,195,75,135,15,75,75,135,135,15,75,195,195,195,75,135,195,195,195
9037 DATA 8,16,0,0,0,86,252,0,0,0,0,0,0,86,252,0,0,0,0,0,0,86,252,0,0,0,0,0,252,252,252,252,168,0,0,1,252,252,252,252,168,0,0,1,252,252,252,252,168,0,0,1,252,252,252,252,168,0,0,1,3,86,252,3,0,0,0,0,0,86,252,0,0,0,0,0,0,86,252,0,0,0,0,0,0,86,252,0,0,0,0,0
9040 DATA 0,86,252,0,0,0,0,0,0,86,252,0,0,0,0,0,16,112,48,32,0,0,0,0,58,176,48,176,0,0,0,0,176,48,176,112,0,0
9041 POKE &A382,8:POKE &A383,16:FOR f=0 TO 127:POKE &A384+f,0:NEXT
9042 RETURN
