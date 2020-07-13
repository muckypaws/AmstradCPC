10 REM Circle
20 REM By R.A.Waddilove
30 REM (c) CPC Computing
40 PRINT"|CIRCLE,rx,ry,pen"
50 MEMORY &9FFF
60 address=&A000
70 FOR i=1 TO 24
80 sum=0:READ code$,check$
90 FOR j=1 TO 21 STEP 2
100 byte=VAL("&"+MID$(code$,j,2))
110 POKE address,byte
120 sum=sum+byte:address=address+1
130 NEXT
140 IF sum<>VAL("&"+check$) THEN PRINT "Error in line ";160+i*10:END
150 NEXT
160 CALL &A000
170 DATA 3E00A7C03C3201A00111A0,366
180 DATA 210EA1C3D1BC16A0C31DA0,556
190 DATA 434952434CC500DD7E00CD,45A
200 DATA DEBBCDC6BBED5309A1220B,5FE
210 DATA A1DD4E02DD4603ED4307A1,4CC
220 DATA DD4E04DD4605ED4305A1EB,518
230 DATA 09EBCDC0BBDD21D3A0FD21,6CB
240 DATA ECA03E19320DA12A05A1DD,470
250 DATA 5E001600CBBBCDBFA0CDA6,599
260 DATA A0ED5B09A1DDCB007E2003,4DB
270 DATA 191804A7EBED52E52A07A1,4BD
280 DATA FD5E001600CBBBCDBFA0CD,5F0
290 DATA A6A0ED5B0BA1FDCB007E28,5A8
300 DATA 03191804A7EBED52D1CDF6,59D
310 DATA BBDD23FD233A0DA13D20AC,4CC
320 DATA C9CB3CCB1DCB3CCB1DCB3C,5AE
330 DATA CB1DCB3CCB1DCB3CCB1DCB,591
340 DATA 3CCB1DC94A7BEB21000006,3C4
350 DATA 10CB391F300119EB29EB10,38C
360 DATA F5C9403E372D20110091A0,402
370 DATA ADB7BEC0BEB7ADA0910011,646
380 DATA 202D373E400011202D373E,1D5
390 DATA 403E372D20110091A0ADB7,3A8
400 DATA BEC0BEB7ADA09100000000,4D1
