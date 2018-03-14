10 ' Procedures
20 ' By Robin Nixon
30 ' (c) Computing with the Amstrad
40 '-------------CPC ONLY-----------
50 MEMORY &8FFF:ln=180:GOTO 80
60 c(m)=ASC(MID$(a$,k+m,3))-59:RETURN
70 PRINT"Error in line";ln:END
80 FOR a=&9000 TO &9216 STEP 18:READ a$
90 ch=0:FOR i=0 TO 8:j=i*2:k=i*3
100 FOR m=1 TO 3:GOSUB 60:ch=ch+c(m)
110 NEXT:p=a+j
120 IF c(1)>15 OR c(2)>63 OR c(3)>63 THEN 70
130 POKE p+1,c(1)*16+((c(2) AND 60)/4)
140 POKE p,c(3)+((c(2) AND 3)*64):NEXT
150 k=27:m=1:GOSUB 60:m=2:GOSUB 60
160 IF ch<>c(1)*64+c(2) THEN 70
165 PRINT ln
170 ln=ln+10:NEXT
180 DATA G_y;;m=eKD;`>w<FYK?Fh;vCGo;D=
190 DATA F_PJtwGK;D@j>w<=AKD;^HB>;=wBu
200 DATA ;;;@;;?xM?R>?LI@DKGHJ?P?@<A?C
210 DATA ?xM@J>?@OHLM=W;GIKD<I<n>GIL@t
220 DATA D@X@v>;=LGRpIRP=[uJuM=;E=?AB]
230 DATA DBaEb>=eKEso=Hy=nyJc[=G^IO^Ed 
240 DATA <;A;;IJty>[=JsG=[gJsC=[[=G?C?
250 DATA <;G;VjI?;<WLIqM>uk<FzCOe<AiC[
260 DATA ;@kIqrIhMGBP;kL<eMFBhEXs<s[EU
270 DATA EXt<c[HK\GqLD@`;;y=[m=AM;;;CT
280 DATA >K]=EiEsqBO]GIiD?R<cNJzy;ScES
290 DATA ==y=JJJKSBsf;>yJc[=B`DCd=[uDZ
300 DATA JQM;TJ;_;;_D;_D>cDEso=Hr>OuCY
310 DATA BYi>c^Esq=Hr>WuBYi>c^Etp=HrGR
320 DATA BSuBYi>nl=[mIAM>K]=ii>S]=IiEV
330 DATA Bs^;>yJc[BO]IAiGBLGblGRpIRPEN
340 DATA =[uJuM=;;=?ADBsEb>>qK=[m=AMBs
350 DATA DCd;TJ;_;;_D;_DBsD>Km=Ii>DyBp
360 DATA EspBs^>Sm=Ii>DyEsrBs^BOm=IiGO
370 DATA >DyEtq<Z>GaLDZp=[mJAMBvD;>yEH
380 DATA GrCFhU<[^>vq>CVD<[A[yCom>uKF?
390 DATA >CVD=p<oyF[m>uK>DSD=v<gyIKmEc
400 DATA >uK>CWD>d<oyIsm>uK>CYD>n@[yEg
410 DATA J[m>uK>DTD>x<gy;Wm>uL>CXD?FD^
420 DATA @[y<Om>uL>CVD?z<ky?Km>uL>CXEP
430 DATA D@D<sy?sm>uL>DSD@N@_y@[mGaLEK
440 DATA AtPAP_A`aAPi=<_@DK?HJ;oB;;EBR
450 DATA AxO=<jA@hB`i@;[?xMBH>;oB;;EBj
460 DATA AxIAo[BL\A\^Atd=<b@DK?HJ;oBCt
470 DATA ;;E?P?@<A?xM=n>;;H;;;;;;;;;>F
