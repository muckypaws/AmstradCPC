1 GOTO 500
2 PEN 1:POKE 46642,255:MODE 1
3 LOCATE 8,12:PRINT"Is Printer On-Line (Y\N)":GOSUB 5:IF x$="Y" THEN pr=1:PRINT#8,CHR$(27);"R";CHR$(3);:WIDTH 80
4 CLS:GOTO 66
5 x$=UPPER$(INKEY$)
6 IF x$<>"Y"AND x$<>"N"THEN 5
7 RETURN
8 'Check for SOs.
9 IF tem(x,1)>s THEN RETURN
10 IF tem(x,1)=0 OR tem(x,1)=99 THEN RETURN
11 b$(p(z),z)=tem$(x,0):s(p(z),z)=tem(x,0):GOSUB 19
12 b(p(z),z)=tem(x,1):b$(p(z),z)="S.O. "+tem$(x,0)+"#":tem(x,1)=0
13 PEN 2:PRINT USING"##";b(p(z),z):PRINT TAB(4);LEFT$(b$(p(z),z),LEN(b$(p(z),z))-1);TAB(30);:PEN 2+(1 AND s(p(z),z)<0):PRINT USING"#####.##-";s(p(z),z)
14 p(z)=p(z)+1:RETURN
15 CLS#3:PRINT#3,"Press ANY KEY to Continue"
16 WHILE INKEY$="":WEND:CLS#3:CLS
17 PEN 2:RETURN
18 'Check for Special Entries.
19 FOR n=1 TO ct
20 IF b$(p(z),z)=ct$(n) THEN spend(n)=spend(n)+(s(p(z),z))
21 NEXT:RETURN
22 CLS#3:PRINT#3,"       ****** INVALID ENTRY ******":GOSUB 30:RETURN
23 CLS#3:PRINT#3,"    ***** NO DATA ENTERED YET *****":GOSUB 30:RETURN
24 PEN 3:PRINT#ch,TAB(20-LEN(q$)/2);q$:PEN 2:PRINT#ch:RETURN
25 CLS:CLS#3:INPUT#3,"Which Month (1-12):   ",q:zz=q-1:CLS#3:IF zz<0 OR zz>11 THEN GOSUB 22:GOTO 25
26 z=q-start+(12 AND start>q)
27 IF x=3 THEN RETURN
28 IF p(z)=1 AND z=0 THEN GOSUB 23:RETURN
29 CLS#3:RETURN
30 SOUND 1,100,50,7:FOR i=1 TO 500:NEXT:CLS#3:RETURN 
31 PRINT:PRINT:FOR n=0 TO 11:PRINT USING"   ##)....&";n+1;:PRINT mo$(n):NEXT
32 INPUT#3,"PLEASE ENTER OPENING MONTH No OF A/C: ",start:PRINT#3,mo$(start-1);:GOSUB 40
33 IF x$<>"Y" THEN 32
34 INPUT#3,"PLEASE ENTER YEAR eg 1985:  ",year:CLS#3
35 IF year MOD 4=0 THEN f=29
36 INPUT#3,"PLEASE ENTER ACCOUNT NAME (MAX 8 CHARS):  ",name$:CLS#3
37 file$="!"+LEFT$(name$,8)
38 n$=name$+" "+n$:GOSUB 70:ac$=n$+" - "
39 n$=mo$(start-1)+STR$(year-1900)+" TO "+mo$((start-2)+(12 AND start=1))+STR$((year-1900)+(1 AND start>1)):GOSUB 70:RETURN
40 PRINT#3,"-Is This correct Y/N":GOSUB 5:CLS#3:RETURN
41 ch=0:PRINT#3,"Send Statement to Printer Y\N":GOSUB 5:prc=1:CLS#3:IF x$="Y"THEN ch=8
42 RETURN
43 'Sort.
44 CLS#3:PRINT#3,"Please Wait - Sorting Entries."
45 FOR n=1 TO p(z)
46 IF b(n,z)<=0 THEN b(n,z)=99:b$(n,z)="":s(n,z)=0
47 NEXT
48 FOR aa=1 TO p(z)
49 ff=0
50 FOR bb=0 TO p(z)-aa
51 IF b(bb,z)<=b(bb+1,z) THEN 56
52 ff=1
53 cc=b(bb+1,z):cc$=b$(bb+1,z):dd=s(bb+1,z)
54 b(bb+1,z)=b(bb,z):b$(bb+1,z)=b$(bb,z):s(bb+1,z)=s(bb,z)
55 b(bb,z)=cc:b$(bb,z)=cc$:s(bb,z)=dd
56 NEXT
57 IF ff=0 THEN 59
58 NEXT
59 CLS#3:RETURN
60 'Validate Date.
61 IF s>f AND zz=1 THEN GOSUB 22:er=1:RETURN
62 IF s>30 AND (zz=3 OR zz=5 OR zz=8 OR zz=10) THEN GOSUB 22:er=1:RETURN
63 IF s>31 OR s<1 THEN GOSUB 22:er=1:RETURN
64 RETURN
65 'Initialize.
66 MODE 1:BORDER 13:INK 1,2:INK 0,13:INK 2,0:INK 3,6:f=28
67 WINDOW #3,1,40,24,25:WINDOW #1,1,40,1,1
68 CLS:PEN #1,0:PEN 2:WINDOW 1,40,4,23
69 n$="BANK ACCOUNT":GOSUB 70:GOTO 71
70 CLS#1:PRINT#1,TAB(20-LEN(n$)/2);n$:RETURN
71 DIM a$(20,1),mo$(11),a(20,1):a(0,1)=999:pa=0
72 DIM b$(60,11),b(60,11),s(60,11),p(11),bfwd(12),ct$(18),spend(18)
73 RESTORE 78
74 FOR i=0 TO 11
75 READ mo$(i):p(i)=1:b$(0,i)="Balance Forward"
76 NEXT
77 b$(0,0)="Opening Balance"
78 DATA JANUARY,FEBRUARY,MARCH,APRIL,MAY,JUNE
79 DATA JULY,AUGUST,SEPTEMBER,OCTOBER,NOVEMBER,DECEMBER
80 'Main Menu.
81 CLS:CLS#3:PEN 2
82 q$="MAIN MENU":GOSUB 24
83 PRINT"  1) DISPLAY BANK ACCOUNT":PRINT
84 PRINT"  2) STANDING ORDERS":PRINT
85 PRINT"  3) INPUT DATA":PRINT
86 PRINT"  4) EXAMINE/DELETE ENTRIES":PRINT
87 PRINT"  5) RECONCILIATION MENU":PRINT
88 PRINT"  6) LOAD DATA-FILE":PRINT
89 PRINT"  7) SAVE DATA-FILE":PRINT
90 PRINT"  8) SPECIAL EXPENDITURE MENU":PRINT
91 PRINT"  9) INSTRUCTIONS
92 INPUT#3," Please Enter Selection (1 to 9):  ",x$:CLS#3
93 x=VAL(x$)
94 IF x<1 OR x>9 THEN GOSUB 22:GOTO 81
95 ch=0:CLS
96 IF year=0 AND (x=2 OR x=3 OR x=8) THEN GOSUB 31
97 ON x GOSUB 100,299,226,199,145,287,271,420,482
98 ch=0:prc=0:PRINT CHR$(7):GOTO 81
99 'Display Statement.
100 ER=0:CLS#3:IF year=0 THEN GOSUB 23:RETURN
101 IF bfwd(0)<>0 THEN 105
102 INPUT#3,"Please Enter Opening Balance:  #",bfwd(0)
103 GOSUB 40
104 IF x$<>"Y"THEN PRINT CHR$(7):GOTO 102
105 CLS#3
106 GOSUB 25:GOSUB 45:IF er THEN 100
107 CLS:q$="STATEMENT for "+mo$(zz)+STR$(year+(1 AND (z+start>11))):GOSUB 24
108 CLS#3:PRINT#3,"  Please Wait while Previous Entries are Checked"
109 FOR k=0 TO z:tot=bfwd(k)
110 FOR l=1 TO p(k)
111 tot=tot+s(l,k):NEXT
112 bfwd(k+1)=tot:NEXT:CLS#3:tot=0
113 PEN 2:PRINT TAB(4);b$(0,z);TAB(30);:PEN 2+(1 AND bfwd(z)<0):PRINT USING"######.##-";bfwd(z)
114 PRINT STRING$(39,"=")
115 tot=bfwd(z)
116 FOR n=1 TO p(z)
117 tot=tot+s(n,z)
118 l=LEN(b$(n,z))-1:IF l>18 THEN l=18
119 IF b(n,z)<32 THEN PEN 2:PRINT USING"##";b(n,z);:PRINT TAB(4);LEFT$(b$(n,z),l);TAB(22);:PEN 2+(1 AND s(n,z)<0):PRINT USING"#####.
##-";s(n,z):PRINT TAB(31);:PEN 2+(1 AND tot<0):PRINT USING"#####.##-";tot:PEN 2
120 IF n MOD 16=0 THEN GOSUB 15:PRINT q$+" cont":PRINT TAB(31);:PEN 2+(1 AND tot<0):PRINT USING"#####.##-";tot
121 NEXT
122 bfwd(z+1)=tot
123 PEN 2:PRINT TAB(31);STRING$(8,"="):PRINT TAB(12);"BALANCE FORWARD =  ";:PEN 2+(1 AND tot<0):PRINT USING"#####.##-";tot:tot=0
124 IF pr=0 THEN GOSUB 15
125 IF pr THEN GOSUB 41:IF ch=8 THEN GOSUB 131
126 ch=0:CLS#3:PRINT#3,"Display Statement for Another Month Y/N":GOSUB 5:CLS#3
127 IF x$="Y"THEN 105
128 IF z=11 THEN CLS#3:PRINT#3,"This is the Last Month of Your Year.  Please Note Final Balance of ";:PRINT#3,USING"#####.##";bfwd(1
2):FOR n=1 TO 5000:NEXT
129 RETURN
130 'Print Statement.
131 PRINT#8,TAB(37-((LEN(ac$)+LEN(q$))/2));ac$;q$
132 PRINT#8,TAB(46);b$(0,z);:PRINT#8,TAB(66);USING"#####.##-";bfwd(z)
133 PRINT#8,STRING$(75,"=")
134 PRINT#8,TAB(47);"RECEIPTS  PAYMENTS    BALANCE"
135 tot=bfwd(z)
136 FOR n=1 TO p(z)
137 tot=tot+s(n,z)
138 IF b(n,z)<32 THEN PRINT#8,USING"##";b(n,z);:PRINT#8,TAB(5);LEFT$(b$(n,z),LEN(b$(n,z))-1);TAB(46+(10 AND s(n,z)<0)):PRINT#8,USING"#####.##-";s(n,z);:PRINT#8,TAB(67);USING"#####.##-";tot
139 NEXT
140 PRINT#8,TAB(67);STRING$(8,"=")
141 PRINT#8,TAB(50);"Balance Forward";:PRINT#8,TAB(66);USING"#####.##-";bfwd(z+1)
142 FOR n=1 TO 2:PRINT#8:NEXT
143 RETURN
144 'Reconciliation.
145 q$="RECONCILIATION MENU":GOSUB 24:PRINT:PRINT
146 PRINT" 1) RECONCILE WITH BANK STATEMENT":PRINT
147 PRINT" 2) DISPLAY ITEMS NOT YET CLEARED":PRINT
148 PRINT" 3) DISPLAY CLEARED ITEMS":PRINT
149 PRINT" 4) RETURN TO MAIN MENU"
150 INPUT#3,"PLEASE ENTER SELECTION (1 to 4):  ",x$:CLS#3:CLS
151 x=VAL(x$)
152 IF x<1 OR x>4 THEN GOSUB 22:GOTO 150
153 IF x=4 THEN RETURN
154 ON x GOSUB 157,171,171
155 ch=0:GOTO 145
156 'Reconcile.
157 GOSUB 25
158 q$="RECONCILIATION FOR "+mo$(zz)
159 GOSUB 24
160 FOR n=1 TO p(z)
161 l=LEN(b$(n,z))-1:IF l>18 THEN l=18
162 IF b(n,z)<32 AND RIGHT$(b$(n,z),1)="#"THEN PEN 2:PRINT USING"##";b(n,z);:PRINT TAB(4);LEFT$(b$(n,z),l);TAB(23);:PEN 2+(1 AND s(n,z)<0):PRINT USING"#####.##-";s(n,z);ELSE 168
163 PRINT#3,"Has this Entry been Cleared (Y\N)":GOSUB 5
164 b=LEN(b$(n,z))-1:PEN 2
165 IF x$="Y"THEN b$(n,z)=LEFT$(b$(n,z),b)+"$":PRINT TAB(33);"Clear"
166 IF x$="N"THEN PRINT TAB(33);"Not Clr"
167 CLS#3
168 NEXT
169 CLS:CLS#3:RETURN
170 'Display Reconciliation.
171 GOSUB 25
172 IF x=2 THEN q$="UNCLEARED ITEMS FOR "+mo$(zz)
173 IF x=3 THEN q$="CLEARED ITEMS FOR "+mo$(zz)
174 GOSUB 24
175 k=1:rec=0
176 FOR n=1 TO p(z)
177 l=LEN(b$(n,z))-1:IF l>18 THEN l=18
178 IF x=2 THEN IF RIGHT$(b$(n,z),1)="#"THEN GOSUB 190 ELSE 183
179 IF x=3 THEN IF RIGHT$(b$(n,z),1)<>"#"THEN GOSUB 190 ELSE 183
180 k=k+1
181 IF ch=8 THEN 183
182 IF k MOD 17=0 THEN GOSUB 15:GOSUB 24
183 NEXT
184 GOSUB 193:PEN 2
185 IF ch=8 AND prc=1 THEN 189
186 IF pr=0 THEN GOSUB 15:GOTO 189
187 PEN 2:IF ch=0 AND prc=0 THEN GOSUB 41 ELSE 189
188 IF ch=8 THEN 172
189 rec=0:prc=0:CLS:RETURN
190 IF b(n,z)<32 THEN PEN 2:PRINT#ch,USING"##";b(n,z);:PRINT#ch,TAB(4);LEFT$(b$(n,z),l);TAB(30);:PEN 2+(1 AND s(n,z)<0):PRINT#ch,USING"#####.##-";s(n,z)
191 rec=rec+s(n,z)
192 RETURN
193 PEN 2:PRINT#ch,TAB(30);STRING$(8,"=")
194 PRINT#ch,TAB(22);"Total  #";
195 PRINT#ch,TAB(30);:PEN 2+(1 AND rec<0):PRINT#ch,USING"#####.##-";rec
196 PRINT#ch,TAB(30);STRING$(8,"=")
197 RETURN
198 'Examine/Delete.
199 GOSUB 25
200 q$="EXAMINE/DELETE ITEMS FOR "+mo$(zz)
201 GOSUB 24
202 q$="COMMANDS AVAILABLE":GOSUB 24
203 IF s(1,z)=0 THEN GOSUB 23:RETURN
204 LOCATE 1,10
205 PEN 1:PRINT"ENTER ";:PEN 2:PRINT"For Next Entry":PRINT
206 PEN 1:PRINT" `Q`";:PEN 2:PRINT"    To Quit":PRINT
207 PEN 1:PRINT" `D`";:PEN 2:PRINT" To Delete Entry"
208 LOCATE 1,20:PRINT"DATE DETAILS";TAB(33);"AMOUNT":PEN 2
209 FOR n=1 TO p(z)
210 l=LEN(b$(n,z))-1:IF l>25 THEN l=25
211 CLS#3
212 IF b(n,z)>31 THEN q$="Q":GOTO 222
213 PRINT USING"##";b(n,z);:PRINT TAB(6);LEFT$(b$(n,z),l);TAB(32);:PRINT USING"#####.##-";s(n,z)
214 q$="":INPUT#3,"Please Select `ENTER`, Q or D ";q$
215 q$=UPPER$(q$)
216 WHILE q$="D"
217 FOR j=n TO p(z)
218 b(j,z)=b(j+1,z):b$(j,z)=b$(j+1,z):s(j,z)=s(j+1,z)
219 NEXT
220 p(z)=p(z)-1:q$="Q"
221 WEND
222 IF Q$="Q"THEN CLS#3:RETURN
223 IF q$=""THEN NEXT
224 RETURN
225 'Input Data.
226 DIM tem$(pa+1,1),tem(pa+1,1)
227 GOSUB 25
228 q$="INPUT DATA FOR "+mo$(zz):GOSUB 24
229 PRINT#3,"Please Wait."
230 co=1
231 FOR i=0 TO pa
232 d=0:WHILE MID$(a$(i,1),q,1)="1"AND d=0 AND a(i,1)<>0:d=1
233 tem(co,1)=a(i,1):tem$(co,0)=a$(i,0):tem(co,0)=a(i,0)
234 IF tem(co,1)>f AND zz=1 THEN tem(co,1)=f
235 IF tem(co,1)>30 AND(zz=3 OR zz=8 OR zz=10) THEN tem(co,1)=30
236 co=co+1
237 WEND
238 NEXT
239 IF p(z)>1 THEN 240 ELSE 249
240 FOR n=1 TO p(z):FOR x=1 TO co
241 IF tem(x,1)=b(n,z) AND INSTR(b$(n,z),tem$(x,0)) THEN tem(x,1)=99
242 NEXT:NEXT
243 IF p(z)=1 THEN 249
244 CLS#3:FOR n=1 TO p(z)
245 IF b(n,z)=99 THEN GOSUB 45:GOTO 248
246 PEN 2:PRINT USING"##";b(n,z);:PRINT TAB(4);LEFT$(b$(n,z),LEN(b$(n,z))-1);TAB(30);:PEN 2+(1 AND s(n,z)<0):PRINT USING"#####.##-";s(n,z)
247 IF n MOD 17=0 THEN GOSUB 15:GOSUB 24
248 NEXT
249 CLS#3:er=0:INPUT#3,"Date e.g. 3, - or 99 to QUIT:  ",s:CLS#3
250 IF s=99 THEN 253
251 GOSUB 61
252 IF er THEN 249
253 FOR x=1 TO co:GOSUB 9:NEXT
254 IF s=99 THEN GOSUB 44:GOTO 269
255 INPUT#3,"Cheque No (or just ENTER):   ",da$
256 INPUT#3,"Details:  ",det$:det$=UPPER$(det$):CLS#3
257 INPUT#3,"Debit or Credit (D or C):   ",d$:d$=UPPER$(d$):CLS#3
258 IF d$<>"D"AND D$<>"C"THEN PRINT CHR$(7):CLS#3:GOTO 257
259 INPUT#3,"Amount # ",am:CLS#3
260 IF d$="D"THEN am=-am
261 PRINT#3,s;da$;" ";LEFT$(det$,20);" ";:PRINT#3,USING"#####.##-";am:GOSUB 40
262 IF x$<>"Y"THEN 249
263 b$(p(z),z)=det$:s(p(z),z)=am:GOSUB 19
264 b(p(z),z)=s:b$(p(z),z)=da$+" "+det$+"#"
265 PEN 2:PRINT USING"##";b(p(z),z);:PRINT TAB(4);LEFT$(b$(p(z),z),LEN(b$(p(z),z))-1);TAB(30);:PEN 2+(1 AND s(p(z),z)<0):PRINT USING"#####.##-";s(p(z),z)
266 p(z)=p(z)+1
267 IF p(z)=60 THEN CLS#3:PRINT#3,"** MONTH NOW FULL **":GOSUB 30:s=99:GOTO 253
268 GOTO 249
269 ERASE tem$,tem:RETURN
270 'Save Data.
271 CLS:LOCATE 8,12:PRINT"PREPARE RECORDER TO SAVE":LOCATE 14,13:PRINT"PRESS ANY KEY"
272 WHILE INKEY$="":WEND:file$="!"+name$
273 '**If using DISC Delete Lines 9000 & 9010 and type line 9030 as 9000
274 CLS:LOCATE 8,10:PRINT"SAVING DATA - PLEASE WAIT":SPEED WRITE 1
275 file$=file$:OPENOUT file$
276 WRITE#9,pa,ct,year,f,start,name$
277 FOR i=0 TO pa
278 WRITE#9,a$(i,0);a$(i,1);a(i,0);a(i,1)
279 NEXT
280 FOR i=0 TO 12:WRITE#9,bfwd(i):NEXT
281 FOR i=0 TO 11:WRITE#9,p(i):NEXT
282 FOR i=0 TO 11:FOR x=0 TO p(i):WRITE#9,b$(x,i);b(x,i);s(x,i):NEXT:NEXT
283 FOR i=1 TO ct:WRITE#9,ct$(i):spend(i):NEXT
284 CLOSEOUT
285 RETURN
286 'Load.
287 CLS:INPUT#3,"WHAT IS ACCOUNT NAME ";file$:CLS#3:file$="!"+file$
288 LOCATE 12,12:PRINT"LOADING DATA"
289 file$=file$:OPENIN file$
290 INPUT#9,pa,ct,year,f,start,name$
291 FOR i=0 TO pa
292 INPUT#9,a$(i,0),a$(i,1),a(i,0),a(i,1):NEXT
293 FOR i=0 TO 12:INPUT#9,bfwd(i):NEXT
294 FOR i=0 TO 11:INPUT#9,p(i):NEXT
295 FOR i=0 TO 11:FOR x=0 TO p(i):INPUT#9,b$(x,i),b(x,i),s(x,i):NEXT:NEXT
296 FOR i=1 TO ct:INPUT#9,ct$(i),spend(i):NEXT
297 CLOSEIN:GOSUB 38:RETURN
298 'S.Os.
299 x=0:CLS
300 q$="STANDING-ORDERS MENU":GOSUB 24
301 PRINT"  1) NEW PAYMENTS":PRINT
302 PRINT"  2) EXAMINE/DELETE ENTRIES":PRINT
303 PRINT"  3) PRINT STANDING-ORDERS":PRINT
304 PRINT"  4) RETURN TO MAIN MENU":PRINT:PRINT
305 INPUT#3,"PLEASE ENTER SELECTION (1-4):  ",x:CLS#3
306 WHILE pa=0 AND (x=2 OR x=3)
307 GOSUB 23:RETURN
308 x=0
309 WEND
310 IF x<1 OR x>4 THEN GOSUB 22:GOTO 305
311 IF x=4 THEN RETURN
312 ON x GOSUB 315,364,396
313 CLS:ch=0:GOTO 299
314 'Enter New Items.
315 CLS:CLS#3:PEN 2:q$="STANDING-ORDERS":GOSUB 24
316 IF pa>19 THEN PRINT#3,"** FILE FULL **":GOSUB 30:CLS#3:RETURN
317 q$="New Items":GOSUB 24
318 PRINT"ėCėredit,ėDėebit or ėQėuit:-";
319 INPUT#3,"Which do You Require C, D or Q:  ",x$:x$=UPPER$(x$):IF x$<>"D"AND x$<>"C"AND x$<>"Q"THEN PRINT CHR$(7):CLS#3:GOTO 319
320 PRINT x$:PRINT:CLS#3
321 IF x$="Q"THEN RETURN
322 q$="":WHILE q$="":PRINT"Name of Payment (Max 18 Characters):":INPUT"",q$:q$=LEFT$(UPPER$(q$),18):WEND
323 PRINT:INPUT"Amount: # ",q
324 IF x$="D"THEN q=-q
325 en=1:WHILE en
326 LOCATE 1,11:PRINT:INPUT"Months Due e.g. 01040710 would be Months1,4,7, &10 (Jan,Apr,Jul & Oct) or M if  Every Month:  ",r$:PRINT
327 IF LEN(r$)<1 THEN PRINT CHR$(7):GOTO 325
328 IF UPPER$(r$)="M"THEN r$="010203040506070809101112"
329 en=0:FOR i=1 TO LEN(r$) STEP 2
330 m=VAL(MID$(r$,i,2))-1
331 IF m<0 OR m>11 THEN GOSUB 22:GOTO 326
332 IF en=0 THEN PRINT mo$(m);":";
333 NEXT:PRINT:PRINT
334 WEND
335 er=0:INPUT#3,"Day of Payment:  ",s:GOSUB 64:CLS#3
336 IF er THEN 335
337 PRINT"Day of Payment:-";s
338 GOSUB 40:IF x$<>"Y"THEN CLS:GOTO 315
339 a$(pa,1)="000000000000"
340 FOR i=1 TO LEN(r$) STEP 2
341 m=VAL(MID$(r$,i,2))
342 a$(pa,1)=LEFT$(a$(pa,1),m-1)+"1"+RIGHT$(a$(pa,1),12-m):NEXT
343 a$(pa,0)=q$:a(pa,0)=q:a(pa,1)=s
344 pa=pa+1
345 PRINT#3,"Add any More S.Os Y/N ":GOSUB 5:CLS#3
346 IF x$="Y"THEN CLS:GOTO 315
347 FOR jj=1 TO pa-1
348 FOR j=0 TO pa-jj
349 IF a(j,1)=0 THEN FOR q=j TO pa-1:FOR k=0 TO 1:a$(q,k)=a$(q+1,k):a(q,k)=a(q+1,k):NEXT:NEXT:pa=pa-1
350 IF a(j,1)<=a(j+1,1) THEN 357
351 FOR k=0 TO 1
352 c$(k)=a$(j+1,k)
353 c(k)=a(j+1,k)
354 a$(j+1,k)=a$(j,k):a(j+1,k)=a(j,k)
355 a$(j,k)=c$(k):a(j,k)=c(k)
356 NEXT
357 NEXT
358 NEXT
359 FOR i=0 TO pa-1
360 IF a(i,1)>31 THEN pa=pa-1
361 NEXT
362 RETURN
363 'Examine/Delete SOs.
364 FOR i=0 TO pa:CLS:PEN 2
365 IF a(i,0)=0 THEN q$="":GOTO 393
366 q$="STANDING-ORDERS":GOSUB 24
367 PEN 1:PRINT#ch,"Payment: ";:PEN 2:PRINT#ch,a$(i,0):PRINT#ch
368 PEN 1:PRINT#ch,"Amount: ";:PEN 2:PRINT#ch,USING"#####.##-";a(i,0):PRINT#ch
369 PEN 1:PRINT#ch,"Months Payable: ";:PEN 2
370 FOR j=1 TO 12
371 IF MID$(a$(i,1),j,1)="1"THEN PRINT#ch,mo$(j-1);":";
372 NEXT:PRINT#ch:PRINT#ch
373 PEN 1:PRINT#ch,"Day of Payment: ";:PEN 2:PRINT#ch,a(i,1)
374 IF ch=8 THEN PRINT#8,:PRINT 38:GOTO 380
375 PEN 2:PRINT:PRINT"Commands Available:":PRINT
376 PEN 1:PRINT"ENTER";:PEN 2:PRINT" Next Item"
377 PEN 1:PRINT"`Q`";:PEN 2:PRINT" Quit"
378 IF pr THEN PEN 1:PRINT"`P`";:PEN 2:PRINT" Output to Printer"
379 PEN 1:PRINT"`D`";:PEN 2:PRINT" Delete"
380 IF ch=8 THEN q$="":CLS:GOTO 392
381 q$="":PRINT#3,"Please Select `ENTER`, Q, D";:IF pr THEN PRINT#3," or P: "; ELSE PRINT#3,":";
382 INPUT#3,"  ",q$:q$=UPPER$(q$):CLS#3
383 IF q$<>""AND q$<>"Q"AND q$<>"D"AND q$<>"P"THEN PRINT CHR$(7):GOTO 381
384 WHILE q$="D"
385 FOR j=i TO pa
386 FOR k=0 TO 1
387 a$(j,k)=a$(j+1,k):a(j,k)=a(j+1,k)
388 NEXT:NEXT
389 pa=pa-1:q$=""
390 WEND
391 IF q$="P"THEN ch=8:GOTO 366
392 ch=0
393 IF q$=""OR q$="D"THEN CLS:NEXT
394 RETURN
395 'Display SO File.
396 CLS:PEN 2
397 q$="STANDING-ORDERS":GOSUB 24
398 q=0:WHILE q<1 OR q>12
399 INPUT#3,"Month No for Standing-Orders (1 to 12):  ",q:CLS#3:CLS
400 WEND
401 PRINT:q$=q$+" "+mo$(q-1)
402 GOSUB 24:PRINT#ch,STRING$(39,"-")
403 PRINT#ch,"DAY & DETAILS";TAB(35);"ITEM "
404 PRINT#ch,STRING$(39,"-")
405 sosum=0:co=1
406 FOR i=0 TO pa
407 d=0:WHILE MID$(a$(i,1),q,1)="1"AND d=0:d=1
408 PEN 2:PRINT#ch,USING"## &";a(i,1);a$(i,0);
409 PEN 2+(1 AND a(i,0)<0):PRINT#ch,TAB(32);USING"#####.##-";a(i,0)
410 sosum=sosum+a(i,0):co=co+1
411 WEND
412 IF co MOD 12=0 AND ch=0 THEN GOSUB 15:CLS:PRINT q$;" cont":PRINT
413 NEXT:PEN 2
414 PRINT#ch,TAB(32);STRING$(8,"=")
415 PRINT#ch,TAB(10);"Total for ";mo$(q-1);:PEN 2+(1 AND sosum<0):PRINT#ch,TAB(32);USING"#####.##";sosum
416 IF ch=8 THEN FOR n=1 TO 2:PRINT#ch:NEXT:CLS:ch=0:RETURN
417 IF pr THEN GOSUB 41:IF x$="Y"THEN 402 ELSE ch=0:prc=0:co=0:RETURN
418 GOSUB 15:RETURN
419 'Selective Entries.
420 CLS:CLS#3:q$="SELECTIVE ENTRIES MENU":GOSUB 24:PRINT
421 PRINT"  1) CREATE SPECIAL CATEGORIES":PRINT
422 PRINT"  2) ADD TO CATEGORIES":PRINT
423 PRINT"  3) DISPLAY ENTRIES YEAR TO DATE":PRINT
424 PRINT"  4) INSTRUCTIONS":PRINT
425 PRINT"  5) EXAMINE/DELETE ENTRIES":PRINT
426 PRINT"  6) RETURN TO MAIN MENU":PRINT
427 INPUT#3,"PLEASE ENTER SELECTION (1 to 6):  ",x$:CLS#3
428 x=VAL(x$)
429 IF x<1 OR x>6 THEN GOSUB 22:GOTO 427
430 IF x=6 THEN RETURN
431 IF x=3 AND ct<1 THEN GOSUB 23:GOTO 420
432 CLS
433 ON x GOSUB 436,452,457,465,471
434 ch=0:prc=0:GOTO 420
435 'Create Special Entries.
436 IF ct=0 THEN 441
437 CLS:PEN 3:LOCATE 16,2:PRINT"WARNING !":PRINT:PRINT:PEN 2:PRINT"CATEGORIES ARE ALREADY ESTABLISHED. IF  YOU CONTINUE ALL OF THESE WILL BE ERASED":PRINT"PRESS Y TO CONTINUE OR N TO RETURN TO   MENU WHERE OPTION 2) SHOULD BE SELECTED"
438 PRINT#3,"Press Y to continue or N to Return "
439 GOSUB 5
440 IF x$<>"Y"THEN RETURN
441 q$="CREATE HEADINGS":GOSUB 24:ct=0
442 IF ct>=18 THEN CLS#3:PRINT 33,"FILE FULL":GOSUB 30:RETURN
443 INPUT#3,"NAME OF CATEGORY OR 99 TO QUIT:  ",y$:CLS#3
444 IF y$="99"THEN RETURN
445 y$=UPPER$(y$)
446 PRINT#3,y$:PRINT#3,"IS THIS CORRECT Y/N ?":GOSUB 5
447 IF x$<>"Y"THEN 443
448 ct=ct+1:ct$(ct)=y$
449 PRINT USING"##) &";ct;ct$(ct)
450 GOTO 442
451 'Add Headings.
452 CLS:q$="ADDITIONS TO HEADINGS":GOSUB 24
453 FOR n=1 TO ct
454 PRINT USING"##) &";n;ct$(n)
455 NEXT
456 GOTO 442
457 CLS:'Year Totals.
458 q$="YEAR TO DATE TOTALS":GOSUB 24
459 FOR n=1 TO ct
460 PEN 2:PRINT#ch,USING"##) &";n;ct$(n);:PRINT#ch,TAB(32);:PEN 2+(1 AND spend(n)<0):PRINT#ch,USING"####.##-";spend(n)
461 NEXT:IF prc THEN 464
462 IF pr=0 THEN GOSUB 15 ELSE GOSUB 41
463 IF ch=8 AND prc THEN 458
464 ch=0:prc=0:CLS:PEN 2:RETURN
465 q$="INSTRUCTIONS FOR SELECTIVE ENTRIES":GOSUB 24
466 PRINT"The purpose of this section is to keep  a running total of expenditure within   named sections for example Electricity, Telephone, credit-cards etc."
467 PRINT:PRINT"You may enter a maximum of eighteen suchsub-sections and once having named theseentries in the INPUT DATA section they  must conform to the specified entry."
468 PRINT:PRINT"You may not change the entries after    setting up although you may add to the  categories at any time up to the limit  of eighteen although any expenditure    before this time will be ignored unless deleted and re-entered."
469 GOSUB 15
470 RETURN
471 CLS:CLS#3
472 q$="SPECIAL CATEGORY ENTRIES":GOSUB 24
473 FOR n=1 TO ct:PRINT USING"##) &";n;ct$(n):NEXT
474 INPUT#3,"Enter Number of Entry to be Deleted    or ** to QUIT  ",x$
475 IF x$="**"THEN RETURN
476 x=VAL(x$):IF x>ct THEN GOSUB 22:GOTO 474
477 CLS#3:PRINT#3,x;ct$(x)
478 INPUT#3,"Is this the correct entry Y/N ",x$
479 IF UPPER$(x$)<>"Y"THEN CLS#3:GOTO 474
480 FOR n=x TO ct:ct$(n)=ct$(n+1):spend$(n)=spend$(n+1):NEXT:ct=ct-1:GOTO 471
481 RETURN
482 CLS:CLS#3:PRINT"The program will hold up to 60 entries  in each month and will handle all trans-actions for a full 12 month period."
483 PRINT:PRINT"Up to 20 Standing Orders will be posted to the Account on the correct date. SOs may be at any frequency and can also be changed during the course of the year."
484 PRINT:PRINT"Up to 18 categories of expenditure may  be named and year to date totals in eachwill be accurately recorded."
485 PRINT:PRINT"Facilities are included for reconciliat-ion with your Bank Statement and output can be sent to a printer wherever this  is appropriate."
486 GOSUB 15
487 PRINT"It is recommended that the Standing     Orders file and the Special Expenditure categories are created before any data  is entered."
488 PRINT:PRINT"When used with Disc-Drive, Frequent use should be made of the SAVE DATA Option. (No 7 in Main Menu)"
489 GOSUB 15:RETURN
490 ch=0:RESTORE 78:FOR i=0 TO 11:READ mo$(i):NEXT:GOTO 81
500 CLS
510 INPUT"Password PleaseĎ0";p$ 
520 IF p$="pig" THEN GOTO 2
530 PEN 1:GOTO 500
