10 MODE 2
20 REM: PRO-PUNTER : PRO :
30 REM: DGA SOFTWARE  : 1987 :
40 CLEAR
50 BORDER 11
60 CLS
70 PRINT
80 PRINT TAB(28)"WELCOME TO PRO-PUNTER"
90 PRINT:PRINT
100 PRINT TAB(26)"DGA SOFTWARE  (c)1987,1988"
110 PRINT:PRINT:PRINT:PRINT:PRINT:PRINT:PRINT:PRINT:PRINT
120 PRINT TAB(15)"ORIGINAL CONCEPT AND SOFTWARE BY D.G. ATHERTON."
130 PRINT:PRINT:PRINT:PRINT
140 PRINT TAB(26)"PROGRAMMED BY S.D.THOMAS."
150 PRINT
160 PRINT TAB(27)"AMSTRAD CPC 6128 SERIES"
170 PRINT
180 FOR T=1 TO 3000:NEXT
190 BORDER 1
200 CLS
210 PRINT "PRO-PUNTER"
220 PRINT
230 PRINT
240 PRINT "1: INPUT STAGE 1"
250 PRINT
260 PRINT "2: INPUT STAGE 2"
270 PRINT
280 PRINT "3: INPUT STAGE 3"
290 PRINT
300 PRINT "4: INPUT STAGE 4"
310 PRINT
320 PRINT "5: INPUT STAGE 5"
330 PRINT
340 PRINT "6: RESULTS MENU"
350 PRINT
360 PRINT "7: EXIT"
370 PRINT
380 PRINT :PRINT :PRINT
390 PRINT "Which option? "
400 opt$=INKEY$
410 IF opt$=" " THEN 400
420 opt=VAL(opt$)
430 IF OPT<1 OR opt>7 THEN 400
440 IF opt=1 THEN GOSUB 530
450 IF opt=2 THEN GOSUB 870
460 IF opt=3 THEN GOSUB 980
470 IF opt=4 THEN GOSUB 1090
480 IF opt=5 THEN GOSUB 1190
490 IF opt=6 THEN GOSUB 1340
500 IF opt=7 THEN CLS:END
510 GOTO 200
520 END
530 CLS
540 PRINT "The MAIN MENU options 1 - 7 normally allow access to the data entry stages of":PRINT"PRO-PUNTER. They have been replaced by information pages which tell you more":PRINT"about the software."
550 PRINT:PRINT"PRO-PUNTER - THE THEORY BEHIND THE SYSTEM"
560 PRINT:
570 PRINT "If you could accurately forecast the probability of a particular event occuring":PRINT"and could bet at odds significantly better than that probability, then betting"
580 PRINT"over a series of similar events you would make money with mathematical          certainty.":PRINT
590 PRINT"Imagine a series of 11 races in which a donkey called DOBBIN keeps racing. If":PRINT"the true probability of DOBBIN winning each race is 10/1, then he will win one"
600 PRINT"race in 11. If you bet on DOBBIN in every race and each time accept odds of":PRINT"10/1 then at the end of the series you will break even. For example, at #1 a"
610 PRINT "time your outlay will be 11 x #1 (#11) and your return when DOBBIN wins at 10/1":PRINT"will be 10 x #1 (#10) plus the #1 you staked on the winning race (= #11)."
620 PRINT:PRINT"However, if the true probability of DOBBIN winning is 10/1 and you can obtain":PRINT"odds of 20/1 on each race, then when he wins your return will be #21 for an"
630 PRINT"outlay of #11 and you will be #10 in profit. If you are foolish enough to":PRINT"accept odds of LESS than 10/1 then you will LOSE money; for example 5/1 on each":PRINT"race would return only #6 for an outlay of #11, a loss of #5."
640 GOSUB 1800
650 CLS
660 PRINT"BOOKMAKERS however will always try to offer odds LESS than the true probability":PRINT"of an event taking place. On DOBBINS race, they may only offer 5/1 when the":PRINT"true probability of DOBBIN winning is 10/1. Thus the #5 you lose on the"
670 PRINT"sequence if you bet at 5/1 is the Bookmaker's profit."
680 PRINT:PRINT"How, then, can the punter win? The simple answer is that most in the long term  do not. Trying to determine both which event is most likely to take place       (difficult enough in itself) and the true probability of that event occuring "
690 PRINT"defeats most people. Result: poorer punters and rich bookies!"
700 PRINT:PRINT"SOME DO WIN....."
710 PRINT:PRINT"Yet some punters do consistently win. How? Well, bookmakers do make mistakes in fixing their odds. The astute punter tries to find events where the bookmaker   has got his sums wrong. To use old DOBBIN again as an example, knowledgeable"
720 PRINT"punters will seek out the bookmaker who is offering over 10/1 and bet with him."
730 PRINT:PRINT"ENTER PRO-PUNTER....."
740 PRINT:PRINT"Horse racing offers lots of opportunities to 'beat the bookmaker', but to do so has always required hours of painstaking study and analysis by enthusiasts.
750 PRINT"There are rules to learn, and lots of information to handle in connection with  each race, the aim being to find a horse capable of winning at generous odds."
760 GOSUB 1800
770 CLS
780 PRINT"'Lazy' punters have searched for simple systems to beat the bookmaker but the   proliferation of thriving bookies suggests that they have not succeeded: if theyhad there would be no bookmakers!"
790 PRINT:PRINT "However, at DGA we realised that the advent of the disk based micro computer    offered the ideal opportunity to create an easy to operate but internally       complex piece of software which, given the data, would analyse form. Our"  
800 PRINT"'brief' then was to create an 'intelligent' program which would quickly and     consistently perform analyses which had previously taken hours manually, which  could therefore provide accurate probability forecasts and which could be used"
810 PRINT"by expert and non-expert alike. Such a system would highlight betting           opportunities and allow a number of people to 'cream off' profits from the huge amount of money in the betting pool without affecting the odds on offer."
820 PRINT:PRINT"The study of racing form is a pseudo science with a set of rules and a knowledgebase which may be applied to any race. It lends itself ideally to the Expert" 
830 PRINT"System concept and PRO-PUNTER is the result of three years research and         development into an Expert System which can 'beat the bookmaker'."
840 PRINT:PRINT:PRINT"More information about PRO-PUNTER may be viewed from MENU OPTION 2."
850 GOSUB 1800
860 RETURN
870 CLS 
880 PRINT"PRO-PUNTER does NOT operate a results database and thus never needs updating.   Its Expert System design means that it can lie unused for any length of time andbe ready for instant use on any racing day.":PRINT 
890 PRINT "PRO-PUNTER may be used to analyse any type of horse race from the FLAT or       NATIONAL HUNT season. Each of five input stages prompt the user to enter        information about the following:"
900 PRINT:PRINT"Trainers and jockeys.":PRINT"The race conditions.":PRINT"Horses in the race.":PRINT
910 PRINT"Information required is copied from the racing press and is easily input. Data  for an average size race (10-12) runners will, with practice, take approximately30 minutes to  enter. Against the input 'time penalty' users should bear in"
920 PRINT"mind that the system does the equivalent of many hours manual work and that you don't get something for nothing! Time spent on input must be viewed as time"
930 PRINT"invested. Additionally, on most race days one or two races may be identified    using our race selection guidelines as being particularly worthy of analysis."
940 PRINT"'Proofing' of forecasts to the racing press well illustrate that analysis of oneor two races on Saturdays only can realise a large profit."
950 PRINT:PRINT"More information about PRO-PUNTER may be viewed from MENU OPTION 3."
960 GOSUB 1800
970 RETURN
980 CLS
990 PRINT"At the end of its race analysis PRO-PUNTER displays a forecast finishing order, allocates each horse a rating on a scale of 0-150, displays its probability of  winning expressed as odds (eg 3/1) and offers INVESTMENT ADVICE."
1000 PRINT:PRINT "The system assesses and reports the VALUE on offer at the bookies as available  odds are input. This is an essential feature as some horses have an INFLATED"
1010 PRINT"price: to attract the 'mug' money, bookmakers often offer over generous prices  on horses with very little chance of winning. Thus a horse whose true chance is 33/1 may be offered at 100/1; good value but a poor bet."
1020 PRINT:PRINT"The INVESTMENT ADVICE suggests whether you should back the top-rated horse or   not. If you are advised against betting the system gives you a reason for this."
1030 PRINT"For example, the top-rated horse may be available at good value odds but may    never have proved itself over today's race distance."
1040 PRINT:PRINT"There are of course several betting strategies which may be used, outlined in   the manual supplied, and the final forecast screen provides all the information required for the user to make an informed decision about betting."
1050 PRINT:PRINT"The manual also offers some guidance to the racing novice and we provide full   telephone support if required on any racing day."
1060 PRINT:PRINT"MENU OPTION 4 contains information on system performance."
1070 GOSUB 1800
1080 RETURN
1090 CLS
1100 PRINT"RESULTS from PRO-PUNTER can be quite startling and the overall performance of   the software should confound those sceptics who think that horse racing is all  luck and chance."
1110 PRINT:PRINT "During its first year on the market forecasts were 'proofed' to the racing      press. This involved submitting race forecasts BEFORE the start of racing.      Twelve months' proofing, mainly one or two races on a Saturday, resulted in "
1120 PRINT"a profit of #888.00 from 103 races, assuming #10 + #1 tax had been placed on    EVERY top-rated horse. The win strike-rate for top-rated horses was 49%."
1130 PRINT:PRINT"Our own pre-marketing trials produced a strike rate of 57% for top-rated horses and its general accuracy may be gauged by the fact that 80% of winners came fromthe top three computer selections."
1140 PRINT:PRINT"Of course, the idea of 'shopping' for good value odds means that some horses    proofed to the press would not have been backed as their odds were less than    their probable chance of winning."
1150 PRINT:PRINT"Profits from following INVESTMENT ADVICES during the period of proofing amountedto almost 100% of capital invested after deduction of tax."
1160 PRINT:PRINT"More information may be viewed from MENU OPTION 5."
1170 GOSUB 1800
1180 RETURN
1190 CLS
1200 PRINT "PRESS REACTION to PRO-PUNTER has been favourable with reviews appearing in the  following publications:"
1210 PRINT:PRINT"'The Raceform Handicap Book', May 1987.~
1220 PRINT"'The Acorn User'(BBC), October 1987"
1230 PRINT"'The Micro User'(BBC),January 1988"
1240 PRINT"'8000 PLUS'(Amstrad PCW), March 1988"
1250 PRINT"'Computing With the Amstrad PCW', April 1988 (Cover Feature)"
1260 PRINT"'PC PLUS'(IBM PC), October 1988."
1270 PRINT"'CPC Computing', October 1988."
1280 PRINT"'Your Amstrad PCW', November 1988."
1290 PRINT:PRINT"It is currently available for the following micros: BBC, ATARI ST, AMSTRAD PCW, AMSTRAD CPC6128, IBM COMPATIBLES including all Amstrad."
1300 PRINT:PRINT"Unfortunately the size and complexity of the system require a disk based micro. However, CPC464 users with a disk drive may look forward to the release of a    version for that machine in the New Year (1989)."
1310 PRINT:PRINT"More information is available from MENU OPTION 6."
1320 GOSUB 1800
1330 RETURN
1340 CLS:PRINT"PRO-PUNTER costs #57.50 including VAT, packaging and postage. Mail order only.":PRINT
1350 PRINT "ORDERS AND ENQUIRIES regarding PRO-PUNTER should be addressed to:":PRINT
1360 PRINT"DGA SOFTWARE, PO BOX 36, ASHTON-UNDER-LYNE, OL7 9AJ.":PRINT
1370 PRINT"TELEPHONE: 061-330-0184":PRINT
1380 PRINT"An INFORMATION PACK about the software including results and a review is        available on request."
1390 PRINT:PRINT:PRINT"Please note that any investment in horse racing involves an element of risk.    Figures quoted in relation to the performance of PRO-PUNTER refer only to       proofing to the racing press and to previous trials."
1400 PRINT:PRINT"We would hope that the purchaser will have equal success, but cannot in any way guarantee that the product's future performance will create an investment       profit."
1405 PRINT:PRINT:PRINT"A sample final forecast screen follows....."
1410 GOSUB 1800
1420 CLS
1430 DIM hname$(5),hol(5),SP$(5),stpc$(5),value(5)
1440 MPX=157
1450 PRINT TAB(26)"PRO-PUNTER COMPUTER ANALYSIS"
1460 PRINT
1470 PRINT "   NAME                       RATING     COMPUTER SP     INPUT SP    VALUE"                                                      
1480 FOR fc=1 TO 5
1490 READ hname$(fc),hol(fc),SP$(fc),stpc$(fc),value(fc)
1500 IF hname$(fc)="NON RUNNER" THEN 1670
1510 LOCATE 1,fc+4
1520 PRINT hname$(fc)
1530 LOCATE 31,fc+4
1540 PRINT MPX-hol(fc)
1550 IF LEN(SP$(fc))>4 THEN LOCATE 45,fc+4
1560 IF LEN(SP$(fc))=4 THEN LOCATE 46,fc+4
1570 IF LEN(SP$(fc))=3 THEN LOCATE 47,fc+4
1580 PRINT SP$(fc)
1590 IF LEN(stpc$(fc))>6 THEN LOCATE 58,fc+4
1600 IF LEN(stpc$(fc))=4 THEN LOCATE 59,fc+4
1610 IF LEN(stpc$(fc))=3 THEN LOCATE 60,fc+4
1620 PRINT stpc$(fc)
1630 IF INT(value(fc))<10 THEN LOCATE 73,fc+4
1640 IF INT(value(fc))>9 THEN LOCATE 72,fc+4
1650 IF INT(value(fc))>99 THEN LOCATE 71,fc+4
1660 PRINT INT(value(fc))
1670 NEXT
1680 DATA ABATHAIC,12,"2/1","3/1",1
1690 DATA "POYLE GEORGE",25,"5/2","2/1",0
1700 DATA "SINGING STEVEN",26,"4/1","2/1",-2
1710 DATA "CRAGSIDE",26,"4/1","10/1",6
1720 DATA "CAROLS TREASURE",28,"9/1","5/2",-6
1730 LOCATE 1,18
1740 PRINT "BEST VALUE : CRAGSIDE"
1750 PRINT "INVESTMENT ADVICE: NO BET (R)"
1760 LOCATE 1,21
1770 PRINT "(P)rint forecast or (M)enu? "
1780 GOSUB 1800
1790 RETURN
1800 PRINT:PRINT TAB(30)"Press <space> bar."
1810 ok$=INKEY$
1820 IF ok$="" THEN 1810
1830 IF ok$=" " THEN RETURN:ELSE 1800
