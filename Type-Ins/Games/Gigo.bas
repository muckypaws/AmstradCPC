1 ' GIGO
2 ' J C Ablett
3 ' Wakefield
4 ' West Yorkshire
10 '
20 MODE 1:PAPER 2:BORDER 11:SYMBOL AFTER 0:PRINT CHR$(23);CHR$(0);
30 FOR A=0 TO 3:READ B:INK A,B:NEXT A:FOR A=1 TO 7:READ B,C,D,E,F,G:WINDOW #A,B,C,D,E:PAPER #A,F:PEN #A,G:NEXT A:FOR A=1 TO 8:READ B:CLS #B:NEXT A:DATA 0,26,11,1,19,22,3,7,0,0,18,21,2,6,1,0,2,39,9,24,1,3,3,40,10,25,0,0,2,15,2,6,1,0,3,16,3,7,0,0
40 DATA 25,40,3,7,0,0,0,4,3,1,2,6,5,7
50 WINDOW #1,24,39,2,6:PAPER #1,1:CLS #1:WINDOW #3,3,38,10,23
60 LOCATE #1,1,2:LOCATE #5,1,2:PRINT#5," GIGO De-Luxe  "+CHR$(164)+" J.C.Ablett   July 1986":PRINT#1," WATCH THIS        SPACE":LOCATE #1,5,4:PEN #1,2:PRINT#1,CHR$(242)+"     "+CHR$(242)
70 FOR a=1 TO 3:READ c,d:PLOT c,385,0:DRAWR d,0:DRAWR 0,-82:DRAWR -d,0:DRAWR 0,82:NEXT a:PLOT 15,272:DRAWR 0,-258:DRAWR 610,0:DRAWR 0,258:DRAWR -610,0:DATA 15,226,271,66,367,257
80 DIM r$(100):FOR a=0 TO 100:READ r$(a):NEXT a:GOSUB 230:a$="hi !,what do you want to talk about today ?":GOSUB 330:PRINT#3
90 r=INT(RND*101):a$=r$(r):LINE INPUT#3,r$(r):GOSUB 330:PRINT#3:GOTO 90
100 DATA please,thankyou,bonjour, I don't know,yes,no,possibly...,that's rather a rash statement to make-can you prove it ?,what's that got to do with me ?,I don't care,are you trying to be sarcastic ?,is that meant to be a rhetorical question ?
110 DATA how should I know ?,what's that supposed to mean ?,I beg your pardon ?,well you see doctor - it's like this...,was that supposed to be funny ?,you love me really, i've run out of things to say - it's your turn now,do you come here often ?
120 DATA have you ever wondered what we're doing here ?,nice weather we've been having lately,let's talk about marmosets,you aren't making a lot of sense,please don't contradict me - I don't like it,I have this fear of being replaced by a human
130 DATA pass the salt,ho-hum,gibber...gibber,can I flog you a musical toilet seat ?,you don't say,well I never,who would have thought it ?,you're really only saying that to make me feel better,that's not a very nice thing to say,I fink you spelt dat rong
140 DATA you don't know the half of it,if only you knew,je ne comprends pas,spraken sie deutsch,I heard rumours that they were teaching a computer to have intelligent conversations,what's new ?,I won't answer that,rubbish,utter waffle,well...
150 DATA I'll see what I can do for you,but...,this is a recorded message.,can I help you ?,stop trying to change the subject,good question,I never could get to grips with humor, I cannot tell a lie...
160 DATA it makes you feel really silly when you realise that you're talking to a computer.(or a human in my case),I try my best,please could you type that in again ? - slowly,you're twisting my words,no comment,I think I'm in love with you
170 DATA I like you - you're cute,that's the nicest thing anybody's said to me all day,it makes me very happy to hear you type that,you don't really mean that,honestly ?,you wouldn't be telling fibs by any chance ?,that sounds interesting
180 DATA could you explain that to me ?,that's fascinating, I'd love to,you must be joking,you can't be serious,I quite agree,my sentiments exactly,never !,I wouldn't mind learning to do that,sorry if I don't make a lot of sense
190 DATA I'll bear that in mind in future,parlez-vous franglais ?,I like a person with a sense of humour,it's no laughing matter,I'm bored with this - let's talk about something else,o.k.,ignorance is bliss,necessity is the mother of invention
200 DATA great minds think alike,time and tide wait for no man,a fool and his honey are soon parted,monday is the root of all evil,amazing how I come up with such intelligent responses isn't it ?
210 DATA there's no money to be made from max headroom impersonations,have you ever considered being a wally full time ?,I'm feeling depressed,oh dear - that is dismal,personally speaking - i prefer marmosets,can I go home now ?,oh please - just for me 
220 DATA the mind boggles,I see,but of course,help-I'm a prisoner in an Amstrad computer factory typing out silly comments
230 FOR a=1 TO 20:READ b,c:m$(0)=m$(0)+CHR$(b):m$(1)=m$(1)+CHR$(c):NEXT a:DATA 32,218,234,219,235,220,32,32,236,221,237,222,238,223,239,32,240,224,241,225,242,226,243,32,32,227,224,228,245,229,32,32,246,230,247,231,248,232,249,233
240 FOR a=1 TO 3:a$(a)=" "+CHR$(a*2+248)+CHR$(a*2+249)+" ":NEXT a:a$(0)=MID$(m$(0),13,4):b$(0)="MBP":b$(1)="CDGKNRSTHZLFV":b$(2)="OAIEY":b$(3)="WQU":FOR a=37 TO 0 STEP -1:READ b,c,d,e,f,g,h,i:SYMBOL 255-a,b,c,d,e,f,g,h,i:NEXT a
250 DATA 0,0,1,6,15,24,55,46,0,63,197,50,136,100,20,200,0,0,0,192,96,32,16,16,116,103,239,249,234,245,238,111,98,136,34,72,162,81,255,223,16,8,8,30,62,250,124,124
260 DATA 124,126,62,63,63,31,31,15,190,186,116,122,229,233,232,235,58,50,18,146,234,130,114,146,15,7,7,7,3,3,1,1,230,209,232,216,228,251,245,254,34,194,18,98,2,4,216,160
270 DATA 1,2,7,7,15,15,31,31,255,127,159,195,224,208,240,216,216,151,39,115,187,93,91,185,0,192,248,252,254,254,255,255
280 DATA 0,0,7,60,114,137,196,160,0,0,240,156,38,75,23,79,1,1,1,1,1,1,3,2,1,0,12,66,1,121,255,242,47,87,47,31,35,31,255,253,128,128,128,128,128,128,192,64
290 DATA 2,2,2,1,0,0,0,0,236,124,50,4,138,137,144,144,251,221,237,227,115,183,95,15,192,192,128,128,0,0,0,0,151,128,67,40,16,25,55,80,230,22,238,108,28,60,254,255
300 DATA 1,7,31,127,255,255,255,255,232,228,242,241,243,253,249,253,127,63,99,197,100,119,207,223,128,192,248,252,255,255,255,255
310 DATA 139,140,67,32,19,24,55,80,230,54,206,44,220,60,254,255,147,135,70,34,17,24,55,80,198,230,110,76,156,60,254,255,147,135,67,32,19,24,55,80,134,198,142,76,156,60,254,255
320 RETURN
330 LOCATE #2,1,1:PRINT#2,m$(0);:FOR m=1 TO LEN(a$):LOCATE #2,1,4:PRINT#2,a$(1):FOR b=0 TO 3:IF INSTR(b$(b),UPPER$(MID$(a$,m,1)))<>0 THEN l=b
340 NEXT b:PRINT#3,UPPER$(MID$(a$,m,1));:NEXT m:IF l<>0 THEN FOR a=0 TO 500:NEXT a:LOCATE #2,1,4:PRINT#2,a$(0):FOR a=0 TO 200:NEXT a
350 IF INSTR(a$,"?")=0 THEN LOCATE #2,1,1:PRINT#2,m$(1);
360 RETURN
