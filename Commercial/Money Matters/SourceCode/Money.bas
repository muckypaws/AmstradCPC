10 ' Money Matters
20 ' CPC Conversion By Jason Brooks
30 ' (C) 1992 RRR Software
40 ' All Rights Reserved
50 music!=&A279:IF PEEK(&7A80)=201 THEN 100
60 SYMBOL AFTER 256:OPENOUT"d":MEMORY &7A7F:CLOSEOUT
65 IF PEEK(&BF00)<>&4A THEN NEW
70 LOAD"sprites.mm",&8400:LOAD"charset.bin",&9FA1:LOAD"sprites.rsx",&7A80
80 LOAD"musique.bin",music!
90 a%=0:CALL &7A80,@a%:POKE &BE81,a%:|SPON
100 DEFINT a-z:DIM g$(4):ENV 6,=8,10
110 DEF FNperiod(note)=ROUND(62500/(440*(2^(oct+((note-10)/12)))))
120 ENV 2,1,-1,1,4,-1,3,3,1,1,14,-1,5,0,0,1
130 MODE 0:|MOFF:|SM,0:|BLANK:|SGL:fa=213:fb=145:fc=150:tempo!=3.5
140 |RESET:|GCOL,0,5:|BOX,0,0,399,639:|SM,0:|THW,2,2:|TIP,4,0:|SGL:RESTORE 530:FOR i=0 TO 4:READ x,y:|SPR,i,x,y:NEXT
150 a$="Money":b$="Matters":|CEN,80,2,@a$:|CEN,80,22,@b$
160 RESTORE 540:FOR i=0 TO 3:|THW,1,1:|TINK,1:READ g$(i):a=(i*42)+51:|CEN,80,a,@g$(i):|TINK,7:|TEXTH,2:a$=CHR$(49+i):|CEN,140,a-4,@a$:NEXT
170 |SPR,5,60,2:|SPEECH,10:music!=&A279:GOSUB 400
180 EI:EVERY 6 GOSUB 350:|INKSET,0:GOSUB 1200
190 a$=INKEY$:IF a$="" THEN 190 ELSE IF a$<"2" OR a$>"5" THEN 190
200 a=REMAIN(0):ENV 1,1,0,1:SOUND 135,0
210 gm=VAL(a$)-1:|BLANK:MODE 0
220 |SPR,0,1,0:|SPR,1,0,11:|SPR,2,70,0:|SPR,3,70,160
230 |SPR,4,0,160
240 |SPR,5,0,87:|SPR,5,72,87
245 |TIP,7,0:|THW,2,1:|CEN,80,148,@g$(gm-1)
250 |TIP,2,0:|THW,1,1:a$="CPC Conversion":b$="By Jason Brooks":|CEN,80,179,@a$:|CEN,80,190,@b$:|TINK,12:|TEXTH,3::a$="Money matters":|CEN,80,6,@a$:|TEXTH,1
260 |GCOL,3,5:|BOX,76,126,176,484:GOSUB 345
270 a$="Do you want":b$="Sound?":c$="(Yes/No)":|TIP,2,5
280 |CEN,80,69,@a$:|CEN,80,89,@b$:|TINK,13:|CEN,80,109,@c$:EI
290 GOSUB 400:EI:EVERY 8 GOSUB 350:|INKSET,0
300 GOSUB 1200:GOSUB 1100:IF kb$<>"Z" AND kb$<>"X" THEN 300
310 IF kb$="Z" THEN vol=1 ELSE vol=0
320 POKE &BE80,vol:a=REMAIN(0):ENV 1,1,0,1:SOUND 135,0
321 IF PEEK(&BE81)>0 THEN 330 ELSE b$="Speech?"
322 GOSUB 345:|CEN,80,69,@a$:|CEN,80,89,@b$:|TINK,13:|CEN,80,109,@c$:GOSUB 1200:WHILE kb$<>"Z" AND kb$<>"X":GOSUB 1100:WEND:IF kb$="Z" THEN |SPON ELSE |SPOFF
330 ON gm GOTO 2000,4000,6000,3000
340 RUN
345 |GCOL,0,133:|CLG,80,125,556,300:|GCOL,0,7:|BOX,80,130,168,476:RETURN
350 ON SQ(1) GOSUB 410
360 ON SQ(4) GOSUB 440
370 ON SQ(2) GOSUB 470
380 IF NOT(FC=PTC AND FA=PTA AND fb=ptb) THEN RETURN
390 SOUND 63,0,500,0,0
400 SOUND 63,0,80,0,0:al=0:bl=0:cl=0:PTA=1:PTC=1:PTB=1:chana!=music!:chanb!=&2D2+music!:chanc!=&1A8+music!:ENV 1,1,15,1,3,-1,1,5,0,1,12,-1,5:RETURN
410 DI:IF pta>=fa THEN RETURN
420 cn=1:cda=PEEK(chana!+1):cd=PEEK(chana!):GOSUB 500
430 GOSUB 520:chana!=chana!+2:pta=pta+1:al=al+cda:RETURN
440 DI:IF ptc>=fc THEN RETURN
450 cn=4:cda=PEEK(chanc!+1):cd=PEEK(chanc!):GOSUB 500
460 GOSUB 520:chanc!=chanc!+2:ptc=ptc+1:bl=bl+cda:RETURN
470 DI:IF ptb>=fb THEN RETURN
480 cn=2:cda=PEEK(chanb!+1):cd=PEEK(chanb!):GOSUB 500
490 GOSUB 520:chanb!=chanb!+2:ptb=ptb+1:cl=cl+cda:RETURN
500 oct%=-4+((cd AND 240)/16):tone=cd AND 15:IF tone=0 THEN ev=0 ELSE ev=1
510 RETURN
520 SOUND cn,FNperiod(tone),cda*tempo!,0,ev:RETURN
530 DATA 5,34,4,45,4,76,4,118,6,162
540 DATA Cozmo's coins,Piggy bank,Fizzy pop,Boingy boingy
1000 ' Decipher Keyboard Layout !
1010 qk=INKEY(66):cn=0
1011 IF qk<>-1 THEN RUN
1020 kb$=UPPER$(INKEY$):IF kb$="" THEN RETURN
1030 IF kb$=" " THEN RETURN
1035 IF kb$=CHR$(13) OR kb$="]" OR kb$="}" THEN kb$=CHR$(13):RETURN
1036 IF kb$="B" THEN kb$=CHR$(127):RETURN
1040 nm=INSTR("1234567890",kb$):IF nm<>0 THEN kb$=RIGHT$(STR$(nm-1),1):nm=nm-1:RETURN
1045 nm=255
1050 nm$="QA	 WESDRT  YUHJIOKLP@:;^["+CHR$(16)+" FCVG"
1060 nk=INSTR(nm$,kb$)
1065 IF nk=0 THEN RETURN ELSE cn=INT(((nk-1)/4))+1:RETURN
1070 RETURN
1100 zzz=FRE(""):kb$="":GOSUB 1000:IF gm=1 AND ble=1 THEN bl=bl+1:IF bl>blr THEN GOSUB 1190:bl=0:blr=350+INT(RND(1)*100)
1102 IF kb$="" AND qk=-1 THEN 1100
1105 RETURN
1190 |SPR,24,26,72:|SPR,24,45,72:FOR d2=1 TO 50:NEXT:|SPR,21,26,72:|SPR,21,45,72:RETURN
1200 kb$="":WHILE INKEY$<>"":WEND:RETURN
1300 IF cn<9 AND cn>0 THEN vl=coi(cn) ELSE vl=0
1305 RETURN
1390 DIM coi%(8):RESTORE 1391:FOR i=1 TO 8:READ coi(i):NEXT:RETURN
1391 DATA 1,2,5,10,20,50,100,200
1400 l%=0:|SLEN,@l%,@mess$:xt1=xt-(l%/2)
1401 |TSET,xt1,yt,@mess$:l=1:WHILE l%>0:|TALK,@l:IF gm=2 THEN |SM,1:|SPR,37,15,91
1410 SOUND 1*vol,40+(RND(1)*30),3,15*vol:FOR d1=1 TO 30:NEXT d1:WEND:IF gm=2 THEN |SM,0:|SPR,38,15,91
1420 RETURN
1500 cn=0:IF vl<3 THEN cn=vl ELSE IF vl=5 THEN cn=3 ELSE IF vl=10 THEN cn=4 ELSE IF vl=20 THEN cn=5 ELSE IF vl=50 THEN cn=6 ELSE IF vl=100 THEN cn=7 ELSE IF vl=200 THEN cn=8
1510 RETURN
1700 GOSUB 1200:WHILE p>0 AND INKEY$<>" ":p=p-1:WEND:RETURN
1710 GOSUB 345:a$="What is the":b$="BIGGEST coin":c$="you want to count?":|THW,1,1:|TIP,14,5:|CEN,80,65,@a$:|CEN,80,89,@b$:|CEN,80,114,@c$:|GCOL,0,128:|CLG,100,42,520,120:|SGL:RETURN
1800 x$="":x2=0:IF cv<100 THEN x$=RIGHT$(STR$(cv),LEN(STR$(cv))-1)+"p" ELSE x1=INT(cv/100):x2=cv MOD 100:x$="&"+RIGHT$(STR$(x1),LEN(STR$(x1))-1):IF x2>0 THEN x$=x$+".":IF x2<10 THEN x$=x$+"0"
1810 IF x2>0 THEN x$=x$+RIGHT$(STR$(x2),LEN(STR$(x2))-1)
1820 RETURN
1850 x$=STRING$(st,"-")
1900 FOR i=1 TO 8:mu(i)=0:cy(i)=96:NEXT:ofn=fq:fq=0:WHILE fq<ln OR fq=ofn:Fq=INT(RND(1)*hn):WEND
1910 fa=fq:nc=0:cn=mc:WHILE cn>0:GOSUB 1300:IF vl>0 AND (fa-vl)>=0 AND mu(cn)<2 THEN fa=fa-vl:mu(cn)=mu(cn)+1:nc=nc+1 ELSE cn=cn-1
1920 WEND:RETURN
2000 ' Cozmo's Coins
2010 DEFINT a-z:DIM c$(8),op$(5),cg$(5),ct(8),cy(8),s(5):RESTORE 2470:FOR i=1 TO 8:READ c$(i):NEXT:FOR i=1 TO 5:READ op$(i),cg$(i):NEXT:FOR i=1 TO 5:READ s(i):NEXT:FOR i=1 TO 8:READ ct(i),cy(i):NEXT:ec=1:bl=0:blr=130:GOSUB 1390
2020 ENT -1,5,1,1,5,-1,1:ENV 1,1,15,3,5,-3,2
2030 GOSUB 345:a$="1 - You choose":b$="2 - Cozmo chooses":c$="3 - Speedy Coins"
2040 |THW,1,1:|TIP,14,5:|CEN,80,65,@a$:|CEN,80,89,@b$:|CEN,80,114,@c$:GOSUB 1200
2050 GOSUB 1100:IF kb$<"1" OR kb$>"3" THEN 2050
2060 game=VAL(kb$)
2070 GOSUB 2370
2080 ble=1:tm!=0:ok=0:wr=0:cnt=0:WHILE cnt<10:GOSUB 1200:GOSUB 1000
2090 ON game GOSUB 2160,2260,2320
2100 |SPR,25,34,80:|SPR,20,40,86:cnt=cnt+1:WEND
2110 IF game=1 THEN mess$="Shall I choose now?":GOSUB 2180:WHILE kb$<>"Z" AND kb$<>"X":GOSUB 1100:WEND:IF kb$="Z" THEN game=2:GOTO 2080 ELSE 2080
2120 IF game=3 THEN t=INT(tm!/300):t$=RIGHT$(STR$(t),LEN(STR$(t))-1):w$=RIGHT$(STR$(wr),LEN(STR$(wr))-1):IF t>60 THEN t$=RIGHT$(STR$(INT(t/60)),LEN(STR$(INT(t/60)-1)))+" min."+STR$(t MOD 60)
2121 IF game=3 THEN mess$=t$+" Sec. and "+w$+" wrong.":GOSUB 2180:GOSUB 2420:GOTO 2080
2130 IF wr=0 THEN mess$="You are an expert!" ELSE IF wr<3 THEN mess$="You're doing well." ELSE mess$="We'll do some more."
2140 GOSUB 2180:IF wr<3 THEN GOSUB 2420:game=3:GOTO 2080
2150 GOSUB 2220:GOTO 2080
2160 mess$="Press a coin for me.":GOSUB 2180:GOSUB 1200:WHILE cn=0 AND qk=-1:GOSUB 1100:WEND:IF cn>0 THEN cn$="It's":GOSUB 2190
2170 mess$=cn$:GOSUB 2210:RETURN
2180 l%=0:|SLEN,@l%,@mess$:x=80-(l/2):|TSET,x,183,@mess$:|TIP,5,0:|THW,2,1:GOSUB 2390:GOSUB 1200:RETURN
2190 cn$=cn$+" "+c$(cn):IF cn=1 THEN cn$=cn$+" penny." ELSE IF cn<7 THEN cn$=cn$+" pence." ELSE IF cn=7 THEN cn$=cn$+" pound." ELSE IF cn=8 THEN cn$=cn$+" pounds."
2200 RETURN
2210 GOSUB 2460:GOSUB 2180:GOSUB 2410:RETURN
2220 p=300:GOSUB 1700:RETURN
2230 ofc=fc
2240 fc=INT(RND(1)*7+1):IF fc=ofc THEN 2240 ELSE cn$=op$(INT(RND(1)*4)+1):cn=fc:GOSUB 2190
2250 RETURN
2260 GOSUB 2230:wc=0:IF cnt>9 THEN RETURN
2270 |SPR,25,34,80:|SPR,20,40,86:cn=0:mess$=cn$:GOSUB 2180:GOSUB 1200:WHILE cn=0:GOSUB 1100:WEND:GOSUB 2460:IF cn=fc THEN 2300 ELSE wc=wc+1
2280 IF wc=1 THEN mess$="Have another go.":GOSUB 2180:GOSUB 2220:GOTO 2270
2290 IF wc=2 THEN wr=wr+1:cnt=cnt+1:mess$="Look at my nose.":GOSUB 2180:cn=fc:GOSUB 2460:p=500:GOSUB 1700:wc=0:GOTO 2270
2300 IF wc=0 THEN j=(INT(RND(1)*4)+1):mess$=cg$(j) ELSE mess$="You're doing fine."
2310 GOSUB 2180:IF wc=0 THEN |SPEECH,s(j)
2311 GOSUB 2420:RETURN
2320 IF tm!<>0 THEN 2330 ELSE mess$="I'm timing you !":GOSUB 2180:GOSUB 2420:mess$="Press SELECT to go.":GOSUB 2180:GOSUB 1200:WHILE kb$<>" ":GOSUB 1100:WEND
2330 GOSUB 2230:|SPR,25,34,80:|SPR,20,40,86:cn=0:mess$=cn$:GOSUB 2180:GOSUB 1200:ts!=TIME:WHILE cn=0:GOSUB 1100:WEND:tm!=tm!+(TIME-ts!):GOSUB 2460:IF cn=fc THEN 2350
2340 wr=wr+1:mess$="Wrong coin !":GOSUB 2180:GOSUB 2220:RETURN
2350 wc=0:GOSUB 2300:RETURN
2370 ' Draw Cozmo
2380 MODE 0:|BLANK:CALL &BD19:|DBL:|SPR,18,18,0:|SPR,19,10,48:|SPR,20,40,86:|INKSET,2:RETURN
2390 ' Clown Talk
2400 |GCOL,0,128:|CLG,0,0,639,39:ENV 1,1,15,3,5,-3,2:m=26:l=1:WHILE l%>0:|SPR,m,36,134:|TALK,@l:SOUND 1,100+(RND(1)*30),1,0,1*vol:FOR d1=1 TO 30:NEXT d1:m=m XOR 1:WEND:|SPR,27,36,134:RETURN
2410 ' Cocky Cozmo!
2420 |SPR,22,26,72:|SPR,22,45,72:FOR d1=1 TO 100:NEXT:|SPR,23,26,72:|SPR,23,45,72
2430 FOR i=1 TO 5:CALL &BD19:|SPR,29,ec*19+28,54:|SPR,28,ec*19+28,48:FOR d1=1 TO 500:NEXT:CALL &BD19:|SPR,29,ec*19+28,48:|SPR,28,ec*19+28,54:FOR d1=1 TO 500:NEXT:NEXT:ec=ec XOR 1
2440 |SPR,22,26,72:|SPR,22,45,72:FOR i=1 TO 100:NEXT:|SPR,21,26,72:|SPR,21,45,72
2450 RETURN
2460 |MON:|MI,4,7:|SPR,25,34,80:|SGL:|MOFF:|SM,2:|SPR,cn+5,ct(cn),cy(cn):|DBL:|SM,0:RETURN
2470 DATA one,two,five,ten,twenty,fifty,one,two
2480 DATA Pick,Excellent.,Press,Very good.,Find,You got it !,Show,Fantastic.,Touch,Brilliant !
2481 DATA 8,4,5,0,2
2490 DATA 37,89,36,84,38,91,36,83,37,88,35,81,36,85,35,81
3000 ' Boingy boingy
3010 DEFINT a-z:|RESET:vol=PEEK(&BE80):GOSUB 1390:|SGL
3015 ENT -2,3,1,1:ENV 2,10,-1,1,30,0,1,10,1,1
3020 DIM pc$(8),qs$(12),cg$(8),cw(8)
3030 RESTORE 3690:FOR i=1 TO 8:READ c$(i):NEXT:FOR i=1 TO 12:READ qs$(i):NEXT:FOR i=1 TO 8:READ cg$(i):NEXT:FOR i=1 TO 8:READ cw(i):NEXT
3040 GOSUB 1710
3050 |COIN,2,21,175:|COIN,3,26,175:|COIN,4,35,175:|COIN,5,42,175:|COIN,6,52,175
3060 GOSUB 1200:cn=0:WHILE cn<3 OR cn>7:GOSUB 1100:WEND:bk=cn:GOSUB 1300
3070 GOSUB 345:a$="What is the":b$="most coins":d$="2  3  4  5  6"
3080 |CEN,80,60,@a$:|CEN,80,78,@b$:|CEN,80,96,@c$:|TINK,0:|CEN,80,120,@d$
3090 nm=0:WHILE nm<2 OR nm>6:GOSUB 1000:WEND:mk=nm
3100 cw=bk+mk-3:ls=2*cw:IF vl=100 THEN z$=" &1" ELSE z$=STR$(vl)+"p"
3110 a$="The biggest coin is"+z$:b$="No more than"+STR$(mk)+" coins"
3120 c$="Correct coin wins"+STR$(cw)+"p":d$="A lesson costs"+STR$(ls)+"p":e$="OK?   (YES/NO)"
3130 |TINK,2:GOSUB 345:|CEN,80,60,@a$:|CEN,80,75,@b$:|TINK,0:|CEN,80,90,@c$:|CEN,80,105,@d$:|TINK,15:|CEN,80,120,@e$
3140 GOSUB 1200:WHILE kb$<>"Z" AND kb$<>"X":GOSUB 1100:WEND:IF kb$="X" THEN 3030
3150 |BLANK:MODE 0:|SM,0:|SPR,14,0,20:|FOR,15,10,66:|GCOL,0,1:MOVE 0,80:DRAW 639,80:MOVE 0,0:DRAW 639,0:|GCOL,0,132:|CLG,0,0,638,78
3160 |INKSET,1:win=0:WHILE win<9999:aw=0
3170 q=(INT(RND(1)*4)*3)+1:|TIP,1,0:|THW,2,1:|GCOL,0,128:|CLG,200,90,600,399
3180 xt=100:mess$=qs$(q):yt=0:GOSUB 1400:xt=100:mess$=qs$(q+1):yt=20:GOSUB 1400:xt=100:mess$=qs$(q+2):yt=40:GOSUB 1400
3190 GOSUB 3460:ttv=t:GOSUB 3350
3200 GOSUB 1200:cn=0:WHILE cn=0:GOSUB 1100:WEND:GOSUB 1300:IF vl=ttv THEN GOSUB 3370:GOTO 3340
3210 aw=aw+1:IF aw=1 THEN GOSUB 1200:|TIP,1,0:|THW,2,1:|GCOL,0,128:|CLG,200,90,600,399:mess$="Try again.":xt=100:yt=20:GOSUB 1400:|SPEECH,9:GOTO 3200
3220 IF LEN(fc$)=2 THEN 3310
3230 |GCOL,0,128:|CLG,200,90,600,399:|TIP,1,0:mess$="Let's add them":xt=100:yt=20:GOSUB 1400:mess$="up together.":xt=100:yt=40:GOSUB 1400:p=400:GOSUB 1700:GOSUB 1200
3240 cn=VAL(LEFT$(fc$,1)):GOSUB 1300:tot=vl:p3=2:WHILE p3<=LEN(fc$):|GCOL,0,128:|CLG,200,90,600,399:|TIP,1,0:|THW,2,1:cv=tot:GOSUB 1800:mess$=x$+" + ":cn=VAL(MID$(fc$,p3,1)):GOSUB 1300:cv=vl:GOSUB 1800:mess$=mess$+x$:xt=100:yt=20:GOSUB 1400
3250 a$="= ":|TEXT,70,50,@a$
3260 vl=tot+cv:st=LEN(STR$(vl))-1:cj=vl:GOSUB 1500
3265 f$="":GOSUB 3950:|CEN,100,50,@x$:IF cn<>0 THEN cn=0:crf=1:GOSUB 3900 ELSE crf=0:GOSUB 3630
3266 IF cn=0 AND vl=0 AND crf=1 THEN cn=1:GOTO 3265
3267 IF cn<>0 THEN f$="":GOSUB 3950:|TINK,0:|CEN,100,50,@x$:|TINK,1
3270 IF cn<>0 THEN GOSUB 1300:cv=vl:GOSUB 1800:|CEN,100,50,@x$
3280 IF vl=cj THEN mess$="Correct !":xt=100:yt=90:GOSUB 1400:|SPEECH,7:p=400:GOSUB 1700:GOTO 3300
3290 mess$="Not right look . . . .":xt=100:yt=90:GOSUB 1400:|TINK,0:|CEN,100,50,@x$:|TINK,7:cv=cj:GOSUB 1800:|THW,3,1:FOR z=1 TO 3:|TINK,0:xt=100:yt=46:mess$=x$:GOSUB 1400:|TINK,7:xt=100:yt=46:GOSUB 1400:p=400:GOSUB 1700:NEXT:|THW,2,1
3300 p3=p3+1:tot=cj:WEND
3310 |GCOL,0,128:|CLG,200,90,600,399:|TIP,1,0:mess$="The Correct Coin":xt=100:yt=20:GOSUB 1400:cv=ttv:GOSUB 1800:mess$="was "+x$:xt=
100:yt=40:GOSUB 1400:vl=ttv:GOSUB 1500:|COIN,cn-1,44,103
3320 |THW,3,1:mess$="That cost":IF LEN(fc$)=2 OR (win-(cw*2))<0 THEN mess$=mess$+" nothing." ELSE win=win-(cw*2):mess$=mess$+STR$(cw*2)+"p"
3330 GOSUB 3440:aw=0:GOSUB 3410
3340 WEND:|GCOL,0,128:|CLG,200,90,600,399:|TIP,2,0:mess$="Phew! I'm Broke.":xt=100:yt=20:|THW,4,1:GOSUB 1400:mess$="See you later !":xt=100:yt=80:|TIP,14:GOSUB 1400:p=400:GOSUB 1700:RUN
3350 tp=LEN(fc$):WHILE tp>1:z=INT(RND(1)*(tp-1))+1:z$=MID$(fc$,z,1):MID$(fc$,z,1)=MID$(fc$,tp,1):MID$(fc$,tp,1)=z$:tp=tp-1:WEND
3360 |GCOL,0,132:|CLG,0,0,638,78:x=2:FOR i=1 TO LEN(fc$):v=VAL(MID$(fc$,i,1)):|SM,2:|COIN,v-1,x,199:x=x+cw(v):NEXT:|SM,0:RETURN
3370 |FXOR,15,10,66:|SPR,17,10,66:SOUND 1*vol,148,0,15,2,2:|SPROING,14,66:|FXOR,15,11,66:|FOR,15,10,66
3380 SOUND 1,30,5,15*vol,,,15
3390 |COIN,cn-1,44,103:|GCOL,0,128:|CLG,200,270,600,399:|THW,5,2:x=INT(RND(1)*8)+1:mess$=cg$(x):xt=100:yt=5:IF aw>0 THEN mess$="That's it."
3400 GOSUB 1400:x2=0:|THW,3,1:IF aw=0 THEN win=win+cw:|SPEECH,x-1
3410 cv=win:GOSUB 1800
3420 IF x$="0p" THEN x$="nothing."
3430 IF aw=0 THEN mess$="You have "+x$ ELSE mess$="But you win nothing."
3440 |GCOL,0,132:|CLG,0,0,638,78:|TIP,13,4:xt=80:yt=169:GOSUB 1400:|TIP,1,0
3450 p=400:GOSUB 1700:RETURN
3460 ' Calculate Combination
3470 obk=bk:ofc$=fc$
3480 IF LEN(c$(bk))>mk THEN bk=bk-1:GOTO 3480:' Calculate Maximum Coin
3490 b=INT(RND(1)*bk)+2:b$=c$(b):' Get Combination Key For Maximum Coin
3500 IF LEN(b$)<2 THEN 3480
3510 d$=b$:f$="":p=LEN(b$):p2=1:WHILE p2<=LEN(d$) AND LEN(d$)<=mk AND bk>1
3520 x$=MID$(d$,p2,1):x=VAL(x$):IF (LEN(c$(x))+LEN(d$)>mk+1) THEN 3570
3530 IF RND(1)*10>5 THEN 3570
3540 d$=d$+c$(x):MID$(d$,p2,1)=" "
3550 fc$="":FOR i=1 TO LEN(d$):IF MID$(d$,i,1)<>" " THEN fc$=fc$+MID$(d$,i,1)
3560 NEXT:d$=fc$
3570 bk=bk-1:p2=p2+1
3580 WEND:bk=obk:IF LEN(d$)<2 THEN 3470
3590 t=0:FOR i=1 TO LEN(d$):cn=VAL(MID$(d$,i,1)):GOSUB 1300:t=t+vl:NEXT
3600 fc$="":FOR i=1 TO LEN(d$):IF MID$(d$,i,1)<>" " THEN fc$=fc$+MID$(d$,i,1)
3610 NEXT:IF mk>2 AND bk>3 AND fc$=ofc$ THEN 3460
3620 RETURN
3630 GOSUB 1200
3635 vl=0:f$=""
3640 cv=VAL(f$):GOSUB 3950:|CEN,100,50,@x$
3650 GOSUB 1100:IF kb$=CHR$(13) AND vl>0 THEN GOSUB 3990:RETURN
3660 IF kb$=CHR$(127) AND f$<>"" THEN |TINK,0:|CEN,100,50,@x$:f$=LEFT$(f$,LEN(f$)-1):|TINK,1:SOUND 1,50,2,vol*15,,1:IF f$<>"" THEN 3640 ELSE IF crf>0 THEN vl=0:RETURN
3670 IF kb$<"0" OR kb$>"9" OR LEN(f$)>=st THEN 3640 ELSE IF kb$="0" AND f$="" THEN 3640 ELSE |TINK,0:|CEN,100,50,@x$:|TINK,1:f$=f$+kb$:GOSUB 3950:vl=VAL(f$):cv=vl:|CEN,100,50,@x$:SOUND 1,100,2,vol*15,,1:GOTO 3640
3680 GOTO 3640
3690 DATA 1,11,221,33,44,554,66,77
3700 DATA Which coin,do these,add up to?
3710 DATA What's the,value of,these coins?
3720 DATA How much,are these,coins worth?
3730 DATA Add up,all of,the coins.
3740 DATA Fantastic,Right,Brilliant,Genius,Very Good,You got it,Perfect,Correct
3750 DATA 7,9,6,10,8,11,9,11
3900 WHILE cn=0 AND (kb$<"0" OR kb$>"9"):GOSUB 1100:WEND:IF INSTR("0123456789",kb$)<>0 AND kb$<>"" THEN vl=0:f$="":GOTO 3660 ELSE GOSUB 1300:RETURN
3950 x$="":IF f$<>"" THEN 3951 ELSE IF f$="" AND st=3 THEN x$="&"+"-.--":RETURN ELSE x$=STRING$(st,"-")+"p":RETURN
3951 x$="":IF st=3 THEN x$="&"+LEFT$(f$,1)+"." ELSE x$=LEFT$(f$,1)
3960 cwx=LEN(f$):x$=x$+RIGHT$(f$,cwx-1):x$=x$+STRING$(st-cwx,"-")
3970 IF st<3 THEN x$=x$+"p"
3980 RETURN
3990 IF st=3 THEN vl=vl*(10^(st-cwx))
3991 RETURN
4000 ' Piggy Bank
4010 DEFINT a-z:vol=PEEK(&BE80):gm=2:GOSUB 1390:ENV 1,=1,1000:|SGL
4020 DIM cg$(4),cw(8),mu(8),cx(8),cy(8):RESTORE 3750:x=44:FOR i=1 TO 8:READ cw(i):cx(i)=x+(cw(i)*4):x=x+(cw(i)*8)+24:NEXT:RESTORE 3740:FOR i=1 TO 4:READ cg$(i):NEXT
4030 GOSUB 1710:|COIN,3,21,175:|COIN,4,37,175:|COIN,5,50,175
4040 GOSUB 1200:cn=0:WHILE cn<4 OR cn>6:GOSUB 1100:WEND:mc=cn
4050 GOSUB 1300:cw=vl*0.2:cv=vl:GOSUB 1800:a$="The biggest coin is "+x$:c$="Correct coin wins"+STR$(cw)+"p":d$="Wrong coin loses"+STR$(cw*2)+"p":e$="OK?   (YES/NO)"
4060 |TINK,2:GOSUB 345:|CEN,80,60,@a$:|CEN,80,79,@c$:|TINK,13:|CEN,80,98,@d$:|TINK,0:|CEN,80,120,@e$:GOSUB 1200:WHILE kb$<>"Z" AND kb$<>"X":GOSUB 1100:WEND:IF kb$="X" THEN 4030
4070 |BLANK:MODE 0:|SGL:|SM,0:|SPR,34,4,20:|SPR,35,46,50:|GCOL,0,1:MOVE 0,76:DRAW 639,76:MOVE 0,0:DRAW 639,0:MOVE 0,130:DRAW 639,130:|GCOL,0,142:|CLG,0,76,633,128:|SPR,20,15,64:|BOX,0,0,399,639:|INKSET,4:x=372:y=320:r=37:GOSUB 4300
4080 r=27:x=286:y=364:GOSUB 4300:r=19:x=216:y=376:GOSUB 4300:r=12:x=158:y=374:GOSUB 4300:MOVE 368,262:DRAW 368,280:x=8:FOR i=1 TO mc:|COIN,i-1,x,198:x=x+(cw(i)+3):NEXT
4090 IF mc=6 THEN hn=99 ELSE IF mc=5 THEN hn=59 ELSE IF mc=4 THEN hn=19
4100 win=0:WHILE win<10000 AND win>-1000:zzz=FRE("")
4110 ln=4:GOSUB 1900
4130 IF nc<2 OR nc>6 THEN 4110 ELSE cv=fq:GOSUB 1800:mess$="Which"+STR$(nc)+" coins make "+x$
4140 x=19:y=10:GOSUB 4310:x=26:y=9:GOSUB 4310:x=35:y=15:GOSUB 4310
4150 GOSUB 4320:GOSUB 4340
4160 GOSUB 4510:p=500:GOSUB 1700
4170 wf=0:cf=1:wrc=0:WHILE nc>0:cn=0:GOSUB 1200:WHILE cn<1 OR cn>mc:GOSUB 1100:WEND
4180 IF cf=1 THEN |GCOL,0,142:|CLG,8,76,629,128:cf=0
4190 IF mu(cn)>0 THEN GOSUB 4380 ELSE GOSUB 4390
4200 WEND:|THW,3,1:|TIP,1,13:a$="O.K. !":|CEN,127,72,@a$
4210 IF wrc=0 THEN js=INT(RND(1)*4):GOSUB 4500 ELSE IF wrc=1 THEN mess$="You're doing fine." ELSE IF wrc>1 THEN mess$="Keep trying."
4220 IF wrc>0 THEN GOSUB 4510:p=500:GOSUB 1700
4230 IF win<0 THEN mess$="You owe me " ELSE mess$="You have "
4240 cv=ABS(win):GOSUB 1800:IF win=0 THEN x$="nothing."
4250 mess$=mess$+x$:GOSUB 4510
4260 GOSUB 4320:|SM,2:|SPR,35,46,50:|SM,0:WEND
4270 IF win>9999 THEN mess$="Phew! I'm broke." ELSE mess$="Sorry, You are broke."
4280 GOSUB 4510:p=500:GOSUB 1700:mess$="See you later !":GOSUB 4510:p=500:GOSUB 1700:RUN
4300 DEG:MOVE x+r,y:FOR i=0 TO 360 STEP 9:DRAW x+r*COS(i),y+r*SIN(i):NEXT:MOVE x+(r*0.7*SIN(60)),y+r*COS(60)*0.7:FOR i=60 TO 70 STEP 3:DRAW r*COS(i)*0.7+x,y+r*SIN(i)*0.6:NEXT:RETURN
4310 |SM,1:FOR i=0 TO 10:|TINK,INT(RND(1)*15):r=INT(RND(1)*9):|NUM,r,x,y:CALL &BD19:SOUND 1*vol,50+r*14,2,15:FOR i1=0 TO 20:NEXT:|NUM,r,x,y:CALL &BD19:NEXT:|SM,0:RETURN
4320 |SM,1:|TINK,2:|DBL:x=INT(fq/10):x1=fq MOD 10:IF x>0 THEN |NUM,x,43,35:|NUM,x1,47,35 ELSE |NUM,x1,45,35
4330 |SGL:RETURN
4340 ' Display Coins On Pig.
4350 onc=nc:|SM,0:x=57:y=84:GOSUB 4360:x=57:y=68:GOSUB 4360:nc=onc:RETURN
4360 FOR c=0 TO 2:IF nc>0 THEN |SPR,36,x,y ELSE |SPR,39,x,y
4370 x=x+4:nc=nc-1:NEXT:RETURN
4380 mu(cn)=mu(cn)-1:nc=nc-1:win=win+cw:GOSUB 4340:SOUND 1*vol,30,15,15,1:|GCOL,2,13:TAG:MOVE cx(cn),cy(cn):PRINT CHR$(231);:MOVE cx(cn),cy(cn)+4:PRINT CHR$(231);:TAGOFF:cy(cn)=cy(cn)+22:RETURN
4390 SOUND 1*vol,350,15,15,1:IF cy(cn)<120 THEN wf=1:IF mu(cn)>-1 THEN |GCOL,0,5:TAG:MOVE cx(cn)+4,cy(cn):PRINT"X";:TAGOFF:mu(cn)=-1:win=win-(2*cw):wrc=wrc+1
4400 RETURN
4500 mess$=cg$(js+1):GOSUB 4510:|SPEECH,js:i1=9:i2=18:i3=24:FOR i=1 TO 100:CALL &BD19:INK 4,i1:INK 12,i2:INK 5,i3:i0=i1:i1=i2:i2=i3:i3=i0:CALL &BD19:FOR d1=1 TO 50:NEXT:NEXT:|INKSET,4:RETURN
4510 |GCOL,0,142:|CLG,8,76,629,128:|SGL:|TIP,1,14:|THW,3,1:xt=80:yt=136:GOSUB 1400:RETURN
5900 DATA 0,3,7,8,10,11,13,14,15
6000 ' Fizzy Pop
6010 DEFINT a-z:vol=PEEK(&BE80):|SGL:ENV 1,=1,400:vol=PEEK(&BE80):gm=3
6020 DIM cg$(8),mu(8),cy(8),cw(8),is(9):GOSUB 1390:RESTORE 3750:FOR i=1 TO 8:READ cw(i):NEXT:RESTORE 5900:FOR i=0 TO 8:READ is(i):NEXT:cp=1:|MOFF:|SM,0:RESTORE 3740:FOR i=1 TO 8:READ cg$(i):NEXT
6030 GOSUB 345:a$="What is the BIGGEST":b$="coin you want to":c$="give change for?":|THW,1,1:|TIP,14,5:|CEN,80,65,@a$:|CEN,80,89,@b$:|CEN,80,114,@c$:|GCOL,0,128:|CLG,100,42,520,120:|SGL
6040 |COIN,3,21,175:|COIN,4,37,175:|COIN,5,50,175
6050 GOSUB 1200:cn=0:WHILE cn<4 OR cn>6:GOSUB 1100:WEND:mc=cn:GOSUB 1300
6060 GOSUB 345:a$="How many coins":b$="do you want":c$="in the change?":d$="1  or  2":|CEN,80,60,@a$:|CEN,80,78,@b$:|CEN,80,96,@c$:|TINK,0:|CEN,80,120,@d$
6070 nm=0:WHILE nm<1 OR nm>2:GOSUB 1000:WEND:cg=nm
6080 cw=cg*vl/10:cv=vl:GOSUB 1800:a$="The biggest coin is "+x$:c$="Right change earns"+STR$(cw)+"p":d$="Wrong change loses"+STR$(cw*2)+"p":e$="OK?   (YES/NO)":b$=RIGHT$(STR$(cg),LEN(STR$(cg))-1)+" coin":IF cg=2 THEN b$=b$+"s"
6081 b$=b$+" in the change."
6090 |TINK,2:GOSUB 345:|CEN,80,60,@a$:|CEN,80,75,@b$:|TINK,0:|CEN,80,90,@c$:|CEN,80,105,@d$:|TINK,15:|CEN,80,120,@e$
6100 GOSUB 1200:WHILE kb$<>"Z" AND kb$<>"X":GOSUB 1100:WEND:IF kb$="X" THEN 6030
6110 |BLANK:MODE 0:|SPR,30,1,2:|GCOL,0,1:|GCOL,0,130:|CLG,0,0,633,74:|GCOL,0,142:|CLG,0,76,633,98:|BOX,0,0,399,639:|BOX,0,76,24,639:|INKSET,3
6120 ocg=cg:win=0:WHILE win<9999
6130 cg=ocg:RANDOMIZE TIME:cc=INT(RND(1)*(mc-1))+2:IF cc<cg+1 THEN 6130
6140 |GCOL,0,128:|CLG,8,100,629,210:|CLG,200,100,629,396:|GCOL,0,142:|CLG,8,76,629,98:|GCOL,0,130:|CLG,8,0,629,74
6150 |THW,3,1:|TIP,5,2:mess$="Customer Choosing.":xt=80:yt=170:GOSUB 1400
6160 |COIN,cc-1,62-cw(cc),46
6170 |THW,3,1:|TIP,4,0:RESTORE 6640:yt=2:FOR i=1 TO 3:READ mess$:l%=0:|SLEN,@l%,@mess$:xt1=156-l%:GOSUB 1401:yt=yt+30:NEXT
6180 cg=ocg:cic=cg:o1=cg1:o2=cg2:GOSUB 16050
6420 x=64:WHILE chews>0:GOSUB 6650:chews=chews-1:WEND
6430 WHILE drinks>0:GOSUB 6670:drinks=drinks-1:WEND:WHILE ices>0:GOSUB 6660:ices=ices-1:WEND
6440 |GCOL,0,130:|CLG,8,0,629,74:|TIP,1,2:mess$="What change":|THW,2,1:xt=120:yt=164:GOSUB 1400:mess$="do I give?":xt=120:yt=182:GOSUB 1400:wf=0:wr=0
6450 FOR i=0 TO 8:mu(i)=0:NEXT:mu(cg1)=mu(cg1)+1:mu(cg2)=mu(cg2)+1
6460 wf=0:mx=3:WHILE cg>0:GOSUB 1200
6470 cn=0:WHILE cn<1 OR cn>mc-1:GOSUB 1100:WEND
6480 |SM,2:|COIN,cn-1,mx,199:SOUND 1*vol,50,9,15,1,,8:mx=mx+cw(cn):cg=cg-1
6490 mu(cn)=mu(cn)-1:IF mu(cn)<0 THEN wf=1
6500 WEND:p=300:GOSUB 1700
6510 IF wf=0 THEN 6580 ELSE wr=wr+1
6520 |GCOL,0,130:|TIP,1,2:|THW,2,1:yt=172:IF wr=1 THEN |CLG,8,0,629,74:mess$="Try again.":xt=120:p=2 ELSE mess$="This isn't right.":xt=100:|THW,3,1:p=500:|CLG,190,0,629,74
6530 GOSUB 1400:IF wr=1 THEN |SPEECH,9
6531 GOSUB 1700:IF wr=1 THEN cg=ocg:GOTO 6450
6540 |GCOL,0,130:|CLG,8,0,629,74:|THW,3,1:mess$="This is right.":xt=100:yt=172:GOSUB 1400:mx=3:|COIN,cg1-1,mx,199:SOUND 1*vol,50,9,15,1,,8:mx=mx+cw(cg1):IF ocg=2 THEN |COIN,cg2-1,mx,199:SOUND 1*vol,50,9,15,1,,8
6550 p=500:GOSUB 1700
6560 mess$="You lose ":IF win-(2*cw)<0 THEN x$="nothing." ELSE cv=cw*2:GOSUB 1800:win=win-(2*cw)
6570 |GCOL,0,130:|CLG,8,0,629,74:mess$=mess$+x$:|THW,3,1:xt=80:yt=172:GOSUB 1400:p=500:GOSUB 1700:GOTO 6600
6580 IF wr=1 THEN sj=8:mess$="Correct !" ELSE sj=(INT(RND(1)*7)+1):mess$=cg$(sj):win=win+cw
6590 |GCOL,0,130:|CLG,8,0,629,74:|THW,3,1:xt=80:yt=172:GOSUB 1400:|SPEECH,sj-1:p=500:IF vol>0 THEN SOUND 135,0:GOSUB 400:fa=11:fc=8:fb=8:WHILE al<32:GOSUB 350:WEND:p=250
6591 GOSUB 1700
6600 cv=win:GOSUB 1800:IF win=0 THEN x$="nothing.":p=500:GOSUB 1700
6610 |TINK,0:mess$="You have "+x$:|GCOL,0,130:|CLG,8,0,629,74:|THW,3,1:xt=80:yt=172:GOSUB 1400:p=500:GOSUB 1700
6620 WEND
6630 |TINK,7:mess$="Phew! I'm broke.":|GCOL,0,130:|CLG,8,0,629,74:|THW,3,1:xt=80:yt=172:GOSUB 1400:p=500:GOSUB 1700:|CLG,8,0,629,74:mess$="See You Later.":xt=80:GOSUB 1400:p=500:GOSUB 1700:RUN
6640 DATA Pence,given,to me for these.
6650 |SM,0:|MON:cp=((cp+1) MOD 7)+1:|MI,is(cp),13:|SPR,33,x,120:|MOFF:|TIP,1,14:|THW,1,1:cv=chewp:GOSUB 1800:|CEN,x*2+9,152,@x$:x=x-14:SOUND 1*vol,70,8,15,1,,12:RETURN
6660 |SM,0:|SPR,32,x,94:|TIP,1,14:|THW,1,1:cv=icesp:GOSUB 1800:|CEN,x*2+9,152,@x$:x=x-14:SOUND 1*vol,70,8,15,1,,12:RETURN
6670 |SM,0:|MON:|MI,is(cp),13:|SPR,31,x,95:|MOFF:cp=(cp+1) MOD 9:|TIP,1,14:|THW,1,1:cv=drinkp:GOSUB 1800:|CEN,x*2+9,152,@x$:x=x-14:SOUND 1*vol,70,8,15,1,,12:RETURN
16050 chews=0:ices=0:drinks=0:icesp=0:drinkp=0:chewp=1
16060 ' Decide What Initial Coin Is Going To Be
16070 con=cc
16090 IF INKEY(66)<>-1 THEN RUN
16100 cg1=INT(RND(1)*con+1):IF cg1>=con THEN 16100
16110 cg2=0:IF cic=2 THEN cg2=INT(RND(1)*con+1):IF (cg2>=con) OR (cg2=cg1 AND (cg2<>2 AND cg2<>5)) THEN 16110
16111 IF cc>3 AND cg1+cg2=o1+o2 THEN 16100
16120 cn=con:GOSUB 1300:sk=vl:cn=cg1:GOSUB 1300:wl=sk-vl:cn=cg2:GOSUB 1300:wl=wl-vl:owl=wl
16130 chewp=1:IF wl<5 THEN drinkp=2+INT(RND(1)*2):icesp=2:GOSUB 16280:GOTO 16200
16140 IF wl>2 THEN drinkp=INT(RND(1)*wl)*0.8:IF drinkp<2 OR drinkp>12 THEN 16140
16150 nod=INT(wl/drinkp):drinks=INT(RND(1)*nod):wl=wl-(drinks*drinkp)
16160 IF wl<3 THEN chews=wl:GOTO 16200
16170 icesp=INT(RND(1)*wl)+1:ices=INT(wl/icesp):IF ices=0 AND wl>2 THEN 16170
16180 IF icesp>15 OR icesp<3 THEN 16170 ELSE wl=wl-(icesp*ices)
16190 chews=wl
16200 IF chews+drinks+ices>5 THEN 16070
16210 IF (chews*chewp)+(drinks*drinkp)+(ices*icesp)<>owl THEN 16070
16260 RETURN
16280 chewp=1:drinkp=2+INT(RND(1)*2):icesp=3
16290 ices=INT(RND(1)*2):IF ices=1 THEN chews=wl-ices:RETURN
16300 drinks=INT(RND(1)*2):chews=wl-drinks:RETURN
