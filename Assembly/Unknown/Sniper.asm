;
          ORG #8700
.demo     ENT $                         ; Codemasters Demonstration Of SNIPER
          CALL disqprst
          LD a,(bb5a)
          LD (#bb5a),a
.re_entry
          LD ix,colours
          CALL setinks
          CALL xycalc
          CALL dhiscore
.ren
          LD a,(bb5a)
          LD (#bb5a),a
.return
          XOR a
          LD (vert),a
          LD hl,message
          LD (origmssg),hl
          LD (mssgHL),hl
          LD hl,messagev
          LD (msg),hl
          LD hl,#50*20+#c000+5
          LD (Screenof),hl
          LD a,#50-13
          LD (lenscrol),a
.awaitinp
          CALL vertical
          CALL mssgscr                  ; Call Character Scroll
          JP nc,await1
          LD hl,(origmssg)
          LD (mssgHL),hl
          LD a,(flag4)
          XOR 1
          LD (flag4),a
          CALL mssgscr
.await1
          LD a,64
          CALL #bb1e                    ; Is 1 - Start Pressed
          JP nz,player1
          LD a,50
          CALL #bb1e                    ; Is R - Redefine Keys Pressed
          JP nz,redefine
          LD a,62
          CALL #bb1e                    ; Is C - For Cheat Mode Pressed
          JR nz,cheatmde
          LD a,60                       ; Is S - For Save High Score Table
          CALL #bb1e
          JP nz,save
          LD a,36                       ; Is L - Load In High Score Table
          CALL #bb1e
          JP nz,load
          LD a,46                       ; Is N - For New Name
          CALL #bb1e
          JP nz,newname
          JR awaitinp
.cheatmde
          LD b,42
          CALL spaces
          LD hl,cheatmsg
          LD a,(flag5)                  ; Toggle Cheat Mode
          XOR 1
          LD (flag5),a
          OR a
          JR nz,cheat1
          LD hl,cheatm2
.cheat1
          CALL movemess
          LD b,8
          CALL spaces
          LD b,200
          CALL pause
          LD a,(flag5)
          OR a
          JP z,ren
          RET                           ; Insert Pokes When Time arises
.newname
          LD b,40
          CALL spaces
          LD hl,newnamem
          CALL movemess
          LD b,14
          CALL spaces
          LD b,200
          CALL pause
          LD b,68
          CALL spaces
          LD ix,playname
          LD b,8
          LD hl,#1015
          CALL inputrtn
          LD b,40
          CALL spaces
          JP ren
.hi_score                               ; No Entry Cond. All Reg. Corrupt
          LD ix,hisc5
          LD iy,score
          AND a
          LD h,(ix+0)
          LD d,(iy+0)
          LD l,(ix+1)
          LD e,(iy+1)
          SBC hl,de
          LD b,4
          JR c,h2
          JR z,h1
          RET nc
.h1
          ADD hl,de
          AND a
          LD h,l
          LD d,e
          LD l,(ix+2)
          LD e,(iy+2)
          SBC hl,de
          RET nc
          LD b,4
.h2
          DEC ix
          DEC ix
          DEC ix
          AND a
          LD h,(ix+0)
          LD l,(ix+1)
          LD d,(iy+0)
          LD e,(iy+1)
          SBC hl,de
          JR z,h3
          JR nc,swapem
          JR c,h4
.h3
          ADD hl,de
          LD h,l
          LD d,e
          AND a
          LD l,(ix+2)
          LD e,(iy+2)
          SBC hl,de
          JR nc,swapem
.h4
          DJNZ h2
          DEC ix
          DEC ix
          DEC ix
.swapem
          INC ix
          INC ix
          INC ix
          LD l,b
          LD h,0
          ADD hl,hl
          LD de,table
          ADD hl,de
          PUSH hl
.swaps
          LD b,3
.swap1
          LD a,(ix+0)
          LD c,a
          LD a,(iy+0)
          LD (ix+0),a
          LD a,c
          LD (iy+0),a
          INC ix
          INC iy
          DJNZ swap1
          POP ix
          LD l,(ix+0)
          LD h,(ix+1)
          LD de,playname
          LD b,8
.swap2
          LD a,(hl)
          LD c,a
          LD a,(de)
          LD (hl),a
          LD a,c
          LD (de),a
          INC hl
          INC de
          DJNZ swap2
          JP hi_score
.load
          LD b,42
          CALL spaces
          LD hl,loadmssg
          CALL movemess
          LD b,9
          CALL spaces
          LD b,50
          CALL pause
          LD hl,doptionL
          LD a,(discfit)
          OR a
          CALL nz,discopt
          LD a,(disctape)
          OR a
          JP z,loadtape
          LD hl,enterfil
          CALL movemess
          LD b,14
          CALL spaces
          LD b,100
          CALL pause
          LD b,38
          CALL spaces
          LD b,8
          LD ix,filename
          LD hl,#1015
          CALL inputrtn
          LD a,#c9
          LD (#bb5a),a
          LD b,8
          LD de,#c000
          LD hl,filename
          CALL #bc77
          JR nc,nofile
          PUSH bc
          POP hl
          LD de,endhisc-hiscna1
          AND a
          SBC hl,de
          JP nz,badfile
          LD hl,hiscna1
          CALL #bc83
          CALL #bc7a
          LD a,(bb5a)
          LD (#bb5a),a
          JP re_entry
.nofile
          CALL #bc7a
          CALL #bc83
          LD b,68
          CALL spaces
          LD hl,nofilerr
          CALL movemess
          LD b,9
          CALL spaces
          LD b,100
          CALL pause
          LD b,68
          CALL spaces
          LD a,(bb5a)
          LD (#bb5a),a
          JP re_entry
.loaderr
          LD b,68
          CALL spaces
          LD hl,taperror
          CALL movemess
          LD b,12
          CALL spaces
          LD b,100
          CALL pause
          JP re_entry
.loadtape
          LD b,30
          CALL spaces
          LD hl,taprompt
          CALL movemess
          LD b,2
          CALL spaces
          LD b,100
          CALL pause
          LD hl,tapbuff
          LD de,endhisc-hiscna1
          LD a,#10
          CALL #bca1
          JR nc,loaderr
          LD a,(tapbuff)
          OR a
          JR nz,badfile
          LD hl,tapbuff+1
          LD de,hiscna1
          LD bc,endhisc-hiscna1
          LDIR
          JP re_entry
.badfile
          CALL #bc7a
          LD b,80
          CALL spaces
          LD hl,badfilem
          CALL movemess
          LD b,2
          CALL spaces
          LD b,100
          CALL pause
          LD b,80
          CALL spaces
          JP re_entry
.inputrtn                               ; Routine to accept Keyboard Input
          PUSH af                       ; On Entry :-
          PUSH bc                       ; HL = XY Cursor Position
          PUSH de                       ; IX=Location to store data
          PUSH hl                       ; B = Max Length Of Chars to input
          PUSH ix                       ; On Exit:-
          PUSH hl                       ; All Registers Preserved
          PUSH bc
          PUSH ix
          CALL #bb75
.inputr8
          CALL #bb09
          JR c,inputr8
.inputr1
          LD (ix+0),#20
          INC ix
          PUSH af
          LD a,46
          CALL #bb5a
          POP af
          DJNZ inputr1
          POP ix
          POP bc
          LD a,b
          DEC a
          LD (max),a
          LD a,wait
          LD (counter),a
          POP hl
          PUSH bc
          CALL #bb75
          POP bc
.inputr2
          CALL #bd19
          LD hl,counter
          DEC (hl)
          CALL z,inputr3
          LD a,(which)
          CALL #bb5a
          LD a,8
          CALL #bb5a
          CALL #bb09
          JR nc,inputr2
          PUSH af
.inputr4
          CALL #bb09
          JR c,inputr4
          POP af
          CP 127
          JR z,inputr6
          CP 13
          JR z,inputr7
          CP 48
          JR c,inputr2
          CP 58
          JR c,inputr5
          LD c,2
          CP 65
          JR c,inputr2
          CP 91
          JR c,inputr5
          SUB #20
          CP 65
          JR c,inputr2
          CP 91
          JR nc,inputr2
.inputr5
          CALL #bb5a
          LD (ix+0),a
          INC ix
          DJNZ inputr2
.inputr7
          POP ix
          POP hl
          POP de
          POP bc
          POP af
          RET
.inputr6
          LD a,(max)
          CP b
          JR c,inputr2
          INC b
          LD a,46
          CALL #bb5a
          LD a,8
          CALL #bb5a
          CALL #bb5a
          LD a,"."
          CALL #bb5a
          LD a,8
          CALL #bb5a
          DEC ix
          LD (ix+0),32
          JR inputr2
.inputr3
          LD a,(which)
          XOR %10001
          LD (which),a
          LD a,wait
          LD (counter),a
          RET
.discopt
          LD b,42
          CALL spaces
          CALL movemess
          LD b,3
          CALL spaces
.discopt1
          LD a,51                       ; T - Key For TAPE
          CALL #bb1e
          LD a,0
          JR nz,selected
          LD a,61                       ; D - Key For DISQ
          CALL #bb1e
          LD a,1
          JR z,discopt1
.selected
          LD (disctape),a               ; Store Option 0 = Tape 1 = Disc
          LD b,38
          CALL spaces
          RET
.disqprst                               ; Is There A Disc Drive Fitted
          LD a,(#bb5a)
          LD (bb5a),a
          LD hl,disccomm
          CALL #bcd4
          RET nc
          LD hl,#abff
          LD de,#40
          LD c,7
          CALL #bcce
          LD a,1
          LD (discfit),a
          LD hl,erm
          CALL #bcd4
          LD (erm1),hl
          LD a,c
          LD (rom),a
          LD a,#ff
          RST #18
          DEFW erm1
          RET
.save
          LD b,42
          CALL spaces
          LD hl,savemssg
          CALL movemess
          LD b,10
          CALL spaces
          LD b,50
          CALL pause
          LD hl,doptionS
          LD a,(discfit)
          OR a
          CALL nz,discopt
          LD a,(disctape)
          OR a
          JR z,savetape
          LD hl,enterfil
          CALL movemess
          LD b,14
          CALL spaces
          LD b,200
          CALL pause
          LD b,60
          CALL spaces
          LD ix,filename
          LD hl,#1015
          LD b,8
          CALL inputrtn
          LD a,#c9
          LD (#bb5a),a
          LD hl,filename
          LD b,8
          LD de,#c000
          CALL #bc8c
          JP nc,nofile
          LD hl,hiscna1
          LD de,endhisc-hiscna1
          CALL #bc98
          CALL #bc8f
          JP ren
.savetape
          LD hl,hiscna1
          LD de,tapbuff+1
          LD bc,endhisc-hiscna1
          LDIR
          LD hl,tapbuff
          LD de,endhisc-hiscna1
          LD a,#10
          CALL #bc9e
          JP ren
.bigscrll
          LD hl,#c000
          LD (scrollHL),hl
          LD bc,#bc0d
          OUT (c),c
          INC b
          XOR a
.bigscrol
          CALL #bd19
          OUT (c),a
          CALL deletebl
          INC a
          CP 40
          JR nz,bigscrol
          XOR a
          OUT (c),a
          RET
.redefine
          LD b,40
          CALL spaces
          LD hl,REDEFINE
          CALL movemess
          LD b,11
          CALL spaces
          LD b,50
          CALL pause
          LD b,20
          CALL spaces
          LD hl,REDEFIN1
          CALL movemess
          LD b,1
          CALL spaces
          LD b,50
          CALL pause
.waiter
          LD a,50
          CALL #bb1e
          JR nz,waiter
          LD hl,UP
          LD iy,up
          XOR a
          LD (part),a
          LD (pointer),iy
.rkey1
          LD a,(part)
          CP 7
          JP z,return
          LD (keymssg),hl
          LD b,40
          CALL spaces
          CALL movemess
          LD b,40
          CALL spaces
          LD a,wait
          LD (counter),a
.keep
          LD hl,#1515
          CALL #bb75
          CALL #bd19
          LD a,(counter)
          DEC a
          LD (counter),a
          JR nz,mark
          LD a,(which)
          XOR #11
          LD (which),a
          LD a,wait
          LD (counter),a
.mark
          LD a,(which)
          CALL #bb5a
          LD a,76
          CALL #bb1e
          JR nz,joy
          CALL redef
          JR c,keep
          LD a,(part)
          OR a
          JR z,key
          LD b,a
          LD a,(ix+0)
          LD iy,(pointer)
.validate
          CP (iy-1)
          JR z,keep
          DEC iy
          DJNZ validate
.key      LD a,(ix+0)
          LD iy,(pointer)
          LD (iy+0),a
          LD hl,part
          INC (hl)
          LD de,8
          LD hl,(keymssg)
          ADD hl,de
          INC iy
          LD (pointer),iy
          PUSH hl
          CALL printkey
          POP hl
          JP rkey1
.redef
          PUSH af
          PUSH bc
          PUSH de
          PUSH hl
.redef1
          LD ix,r1
          LD b,73
.loop
          LD a,(ix+0)
          CALL #bb1e
          JR nz,redef2
          INC ix
          INC ix
          INC ix
          DJNZ loop
          POP hl
          POP de
          POP bc
          POP af
          SCF
          RET
.redef2
          POP hl
          POP de
          POP bc
          POP af
          OR a
          RET
.joy
          LD hl,joystick
          LD de,up
          LD bc,7
          LDIR
          LD b,30
          CALL spaces
          LD hl,JOYS
          CALL movemess
          LD b,11
          CALL spaces
          LD b,50
          CALL pause
          CALL clear
          JP return
.clear
          CALL #bb09
          JR nc,clear
          RET
.printkey
          LD hl,#1515
          CALL #bb75
          LD l,(ix+1)
          LD h,(ix+2)
.printk1
          LD a,(hl)
          PUSH af
          AND #7f
          INC hl
          CALL #bb5a
          POP af
          BIT 7,a
          JR z,printk1
          RET
.clearkey
          CALL #bb09
          RET nc
          JR clearkey
.deletebl
          PUSH af
          PUSH bc
          PUSH de
          PUSH hl
          LD hl,(scrollHL)
          LD b,#c8
.deleteb1
          PUSH hl
          LD (hl),0
          INC hl
          LD (hl),0
          POP hl
          LD a,h
          ADD a,8
          LD h,a
          JR nc,deleteb2
          LD de,#c050
          ADD hl,de
.deleteb2
          DJNZ deleteb1
          LD hl,(scrollHL)
          INC hl
          INC hl
          LD (scrollHL),hl
          POP hl
          POP de
          POP bc
          POP af
          RET
.player1
          LD b,60
          CALL spaces
          XOR a
          LD (flag),a
          LD hl,PLAYER1
          LD (mssgHL),hl
.play1l
          CALL mssgscr
          JR nc,play1l
          LD b,14
          CALL spaces
          LD b,100
          CALL pause
          CALL bigscrll
          CALL #bd19
          RET
.spaces
          PUSH af
          PUSH bc
          PUSH de
          PUSH hl
          LD hl,blanks
          LD (msg),hl
.spaces1
          PUSH bc
          LD a,#20
          CALL mssgscr1
          LD a,(vert)
          OR a
          JR nz,spaces2
          CALL vertical
          CALL vertical
.spaces2
          POP bc
          DJNZ spaces1
          LD a,1
          LD (vert),a
          DEC a
          LD (point),a
          POP hl
          POP de
          POP bc
          POP af
          RET
.xycalc
          LD ix,scrdest
          LD hl,199
          LD b,#c8
.xycalc1
          PUSH bc
          PUSH hl
          LD de,0
          CALL #bc1d
          LD (ix+0),l
          LD (ix+1),h
          INC ix
          INC ix
          POP hl
          DEC hl
          POP bc
          DJNZ xycalc1
          RET
.pause
          CALL #bd19
          DJNZ pause
          RET
.dhiscore
          LD a,1
          LD (flag1),a
          LD a,34
          LD (selfmod),a
          LD b,25
          LD c,25
          LD hl,mhiscore
          CALL scrollit
          LD b,49
          LD c,11
          LD hl,hiscna1
          LD a,16
          LD (selfmod),a
          LD a,5
.dhisc1
          CALL scrollit
          LD de,hiscna2-hiscna1
          ADD hl,de
          PUSH af
          LD a,b
          ADD a,16
          LD b,a
          POP af
          DEC a
          JR nz,dhisc1
          PUSH bc
          LD hl,#50*5+#c000+42
          LD (Screenof),hl
          LD a,#25
          LD (lenscrol),a
          LD hl,buffer
          LD (mssgHL),hl
          LD hl,hisc1
          XOR a
          LD (flag4),a
          LD a,5
.disphisc
          PUSH af
          PUSH hl
          LD b,3
          LD de,buffer
          LD (mssgHL),de
.covhisc
          LD a,#30
          RLD
          LD (de),a
          INC de
          RLD
          LD (de),a
          INC de
          RLD
          INC hl
          DJNZ covhisc
          CALL movemeS1
          LD b,12
          CALL spaces
          POP hl
          LD de,hisc2-hisc1
          ADD hl,de
          PUSH hl
          LD hl,(Screenof)
          LD de,#a0
          ADD hl,de
          LD (Screenof),hl
          POP hl
          POP af
          DEC a
          JR nz,disphisc
          POP bc
          LD hl,soption
          LD a,b
          ADD a,8
          LD b,a
          LD c,6
          LD a,68
          LD (selfmod),a
          CALL scrollit
          LD a,1
          LD (flag4),a
          RET
.movemess
          LD (mssgHL),hl
.movemeS1
          PUSH af
          PUSH bc
          PUSH de
          PUSH hl
          XOR a
          LD (flag),a
.movemes1
          CALL mssgscr
          JR nc,movemes1
          POP hl
          POP de
          POP bc
          POP af
          RET
.scrollit
          PUSH af
          PUSH bc
          PUSH de
          PUSH hl
          LD a,(flag1)
          XOR 1
          LD (flag1),a
          XOR a
          LD (count),a
          LD e,b
          LD d,1
.scrlprt1
          CALL #bd19
          CALL #bd19
          CALL printit
          PUSH bc
          DEC e
          LD b,e
          LD a,34
.selfmod  EQU $-1
          INC d
          CALL scrollti
          POP bc
          LD a,(count)
          INC a
          LD (count),a
          CP 8
          JR nz,scrlprt1
          POP hl
          POP de
          POP bc
          POP af
          RET
.scrollti                               ; On Entry :-
          PUSH af                       ; A = No. Of Bytes Horiz. to scroll
          PUSH bc                       ; B=Y Coord , C=X Coords To Scroll from
          PUSH de                       ; D = No. Of Bytes Vertically To Scroll
          PUSH hl                       ; Store Registers
          PUSH de                       ; Store Vert. Counter
          DEC b
          DEC c
          LD h,0
          LD l,b
          ADD hl,hl
          LD de,scrdest
          ADD hl,de
          PUSH hl
          POP ix
          POP de
          LD b,0
.scrollup
          PUSH de
          PUSH af
          LD l,(ix+0)
          LD h,(ix+1)
          ADD hl,bc
          LD e,(ix+2)
          LD d,(ix+3)
          EX de,hl
          ADD hl,bc
.scrollu1
          PUSH af
          LD a,(hl)
          LD (de),a
          INC hl
          INC de
          POP af
          DEC a
          JR nz,scrollu1
          INC ix
          INC ix
          POP af
          POP de
          DEC d
          JR nz,scrollup
          POP hl
          POP de
          POP bc
          POP af
          RET
.print
          LD a,7
          LD (count),a
          CALL #bd19
          CALL #bd19
          LD a,b
          ADD a,7
          LD b,a
.print8
          CALL printit
          DEC b
          LD a,(count)
          DEC a
          LD (count),a
          CP #ff
          JR nz,print8
          LD a,7
          LD (count),a
          RET
.printit
          PUSH hl
          PUSH de
          PUSH bc
          PUSH af                       ; Preserve Registers
.printit1                               ; On Entry :-
          PUSH hl                       ; HL=Pointer To Message
          PUSH bc                       ; B=No. Of Bytes Down From Top Left
          PUSH hl
          LD de,scrdest-2
          LD h,0
          LD l,b
          ADD hl,hl
          ADD hl,de
          PUSH hl
          POP ix
          LD e,(ix+0)
          LD d,(ix+1)
          EX de,hl
          DEC c
          LD d,0
          LD e,c
          ADD hl,de
          EX de,hl
          POP hl
.print2
          LD a,(hl)
          SUB 32
          JR c,print3
          PUSH hl
          PUSH de
          LD de,keychar
          LD h,0
          LD l,a
          ADD hl,hl
          ADD hl,hl
          ADD hl,hl
          ADD hl,de
          LD a,(count)
          LD e,a
          LD d,0
          ADD hl,de
          LD a,(flag2)
          LD b,15
          OR a
          JR nz,print5
          LD b,%11110000
.print5
          POP de
          LD a,(hl)
          AND b
          LD b,a
          LD a,(flag1)
          OR a
          LD a,b
          JR nz,print9
          SRL a
          SRL a
          SRL a
          SRL a
          OR b
.print9
          LD (de),a
          POP hl
          LD a,(flag2)
          XOR 1
          LD (flag2),a
          OR a
          JR nz,print6
          INC hl
.print6
          INC de
          JR print2
.print3
          JR print4
          LD a,(count)
          INC a
          LD (count),a
          CP 8
          JR z,print4
          POP bc
          INC b
          POP hl
          JR printit1
.print4
          POP bc
          POP hl
          POP af
          POP bc
          POP de
          POP hl
          RET
          LD hl,message
          LD (msg),hl
.vertical
          LD hl,#50*5+#28+#c000
          LD b,#48
.verts1
          PUSH hl
          POP de
          LD a,h
          ADD a,8
          LD h,a
          JR nc,verts2
          PUSH de
          LD de,#c050
          ADD hl,de
          POP de
.verts2
          LD a,(hl)
          LD (de),a
          INC hl
          INC de
          LD a,(hl)
          LD (de),a
          DEC hl
          DJNZ verts1
          LD (storey+1),hl
.unreset
          LD hl,(msg)
          LD a,(hl)
          SUB #20
          JR c,reset
          LD l,a
          LD h,0
          LD de,keychar
          ADD hl,hl
          ADD hl,hl
          ADD hl,hl
          ADD hl,de
          LD a,(point)
          LD e,a
          LD d,0
          ADD hl,de
.storey   LD de,0
          LD a,(hl)
          AND %11110000
          SRL a
          SRL a
          SRL a
          SRL a
          BIT 0,a
          JR z,st
          SET 4,a
.st
          BIT 1,a
          JR z,st2
          SET 5,a
.st2
          LD (de),a
          INC de
          LD a,(hl)
          AND 15
          SLA a
          SLA a
          SLA a
          SLA a
          BIT 7,a
          JR z,st1
          SET 3,a
.st1
          LD (de),a
          LD a,(point)
          INC a
          LD (point),a
          CP 8
          RET nz
          XOR a
          LD (point),a
          LD hl,(msg)
          INC hl
          LD (msg),hl
          RET
.reset    LD hl,messagev
          LD (msg),hl
          JR unreset
.mssgscr
          LD hl,(mssgHL)
          LD a,(hl)
.mssgscr1
          SUB 32
          RET c
          LD hl,keychar
          JR z,next
          LD de,keychar
          LD h,0
          LD l,a
          ADD hl,hl
          ADD hl,hl
          ADD hl,hl
          ADD hl,de
.next
          LD a,(flag)
          XOR 1
          LD (flag),a
          LD d,%11110000
          OR a
          JR nz,next1
          LD d,%1111
.next1
          LD b,7
          LD iy,stack
.store
          LD a,(hl)
          AND d
          LD c,a
          LD a,(flag4)
          OR a
          LD a,c
          JR nz,next4
          LD a,(flag)
          OR a
          LD a,c
          JR nz,next4
          SLA a
          SLA a
          SLA a
          SLA a
.next4
          LD (iy+0),a
          INC hl
          INC iy
          DJNZ store
.scroll
          LD iy,stack
          LD c,7
          LD a,(lenscrol)
          LD b,a
          LD ix,(Screenof)
          CALL #bd19
          PUSH AF
          PUSH BC
          LD B,#F5
.R7B8     IN A,(C)
          RRA
          JR NC,R7B8
          POP BC
          POP AF
.scroll1
          LD a,(iy+0)
          LD d,a
          PUSH bc
          PUSH ix
          PUSH iy
.scroll2
          LD a,(ix+1)
          LD (ix+0),a
          INC ix
          DJNZ scroll2
          LD (ix+0),d
          POP iy
          INC iy
          POP hl
          LD a,h
          ADD a,8
          LD h,a
          PUSH hl
          POP ix
          POP bc
          DEC c
          JR nz,scroll1
          LD hl,(mssgHL)
          LD a,(flag)
          OR a
          JR nz,next2
          INC hl
.next2
          LD (mssgHL),hl
          RET
.setinks
          LD a,(ix+0)
          CALL #bc0e
          INC ix
          LD b,(ix+0)
          LD c,b
          CALL #bc38
          INC ix
          XOR a
.setinks1
          PUSH af
          LD b,(ix+0)
          LD c,b
          CALL #bc32
          INC ix
          POP af
          INC a
          CP 4
          JR nz,setinks1
          RET
.erm      DEFB #81
.erm1     DEFW 0
.rom      DEFB 0
.colours  DEFB 1,0,0,24,6,15
.stack    DEFS 8,0
.mssgHL   DEFW 0
.origmssg DEFW 0
.flag     DEFB 0
.flag4    DEFB 1
.Screenof DEFW 0
.lenscrol DEFB 0
.playname DEFM JASON...
.up       DEFB 19                       ; ]
.down     DEFB 22                       ; \
.left     DEFB 71                       ; Z
.right    DEFB 63                       ; X
.fire     DEFB 18                       ; Return
.pausek   DEFB 27                       ; P
.quit     DEFB 67                       ; Q
.joystick DEFB 72,73,74,75,76,27,67
.JOYS     DEFM >> JOYSTICK SELECTED <<
          DEFB 0
.REDEFINE DEFM >>>  REDEFINE KEYS  <<<
          DEFB 0
.REDEFIN1
          DEFM > PRESS FIRE TO SELECT J
          DEFM OYSTICK <
          DEFB 0
.part     DEFB 0
.UP       DEFM UP.....
          DEFB 0
.DOWN     DEFM DOWN...
          DEFB 0
.LEFT     DEFM LEFT...
          DEFB 0
.RIGHT    DEFM RIGHT..
          DEFB 0
.FIRE     DEFM FIRE...
          DEFB 0
.PAUSE    DEFM PAUSE..
          DEFB 0
.QUIT     DEFM QUIT...
          DEFB 0
.newnamem DEFM >> ENTER YOUR NAME <<
          DEFB 0
.score    DEFS 3,0
.which    DEFB 46
.max      DEFB 0
.counter  DEFB 0
.wait     EQU 15
.nofilerr DEFM >> DISK ERROR  XOR  RE-TRY <<
          DEFB 0
.filename DEFS 8,0
.disctape DEFB 0
.doptionS
          DEFM >>  STORE TO TAPE OR DIS
          DEFM K ?  <<
          DEFB 0
.doptionL
          DEFM >>  LOAD FROM TAPE / DIS
          DEFM K ?  <<
          DEFB 0
.discfit  DEFB 0
.disccomm DEFM CP
          DEFB "M"+#80
.savemssg DEFM >> SAVE HI-SCORE TABLE <<
          DEFB 0
.loadmssg DEFM >> LOAD HI-SCORE TABLE <<
          DEFB 0
.bb5a     DEFB 0
.blanks   DEFS 20,32
.vert     DEFB 1
.msg      DEFW 0
.point    DEFB 0
.origscrn DEFW 0
.mssg     DEFW 0
.screen   DEFW 0
.r1       DEFB 66
          DEFW k1
.r2       DEFB 64
          DEFW k2
.r3       DEFB 65
          DEFW k3
.r4       DEFB 57
          DEFW k4
.r5       DEFB 56
          DEFW k5
.r6
          DEFB 49
          DEFW k6
.r7
          DEFB 48
          DEFW k7
.r8
          DEFB 41
          DEFW k8
.r9
          DEFB 40
          DEFW k9
.r10
          DEFB 33
          DEFW k10
.r11
          DEFB 32
          DEFW k11
.r12
          DEFB 25
          DEFW k12
.r13
          DEFB 24
          DEFW k13
.r14
          DEFB 16
          DEFW k14
.r15
          DEFB 79
          DEFW k15
.r16
          DEFB 10
          DEFW k16
.r17
          DEFB 11
          DEFW k17
.r18
          DEFB 3
          DEFW k18
.r19
          DEFB 68
          DEFW k19
.r20
          DEFB 67
          DEFW k20
.r21
          DEFB 59
          DEFW k21
.r22
          DEFB 58
          DEFW k22
.r23
          DEFB 50
          DEFW k23
.r24
          DEFB 51
          DEFW k24
.r25
          DEFB 43
          DEFW k25
.r26
          DEFB 42
          DEFW k26
.r27
          DEFB 35
          DEFW k27
.r28
          DEFB 34
          DEFW k28
.r29
          DEFB 27
          DEFW k29
.r30
          DEFB 26
          DEFW k30
.r31
          DEFB 17
          DEFW k31
.r32
          DEFB 18
          DEFW k32
.r33
          DEFB 20
          DEFW k33
.r34
          DEFB 12
          DEFW k34
.r35
          DEFB 4
          DEFW k35
.r36
          DEFB 70
          DEFW k36
.r37
          DEFB 69
          DEFW k37
.r38
          DEFB 60
          DEFW k38
.r39
          DEFB 61
          DEFW k39
.r40
          DEFB 53
          DEFW k40
.r41
          DEFB 52
          DEFW k41
.r42
          DEFB 44
          DEFW k42
.r43
          DEFB 45
          DEFW k43
.r44
          DEFB 37
          DEFW k44
.r45
          DEFB 36
          DEFW k45
.r46
          DEFB 29
          DEFW k46
.r47
          DEFB 28
          DEFW k47
.r48
          DEFB 19
          DEFW k48
.r49
          DEFB 13
          DEFW k49
.r50
          DEFB 14
          DEFW k50
.r51
          DEFB 5
          DEFW k51
.r52
          DEFB 21
          DEFW k52
.r53
          DEFB 71
          DEFW k53
.r54
          DEFB 63
          DEFW k54
.r55
          DEFB 62
          DEFW k55
.r56
          DEFB 55
          DEFW k56
.r57
          DEFB 54
          DEFW k57
.r58
          DEFB 46
          DEFW k58
.r59
          DEFB 38
          DEFW k59
.r60
          DEFB 39
          DEFW k60
.r61
          DEFB 31
          DEFW k61
.r62
          DEFB 30
          DEFW k62
.r63
          DEFB 22
          DEFW k63
.r64
          DEFB 15
          DEFW k64
.r65
          DEFB 0
          DEFW k65
.r66
          DEFB 7
          DEFW k66
.r67
          DEFB 23
          DEFW k67
.r68
          DEFB 9
          DEFW k68
.r69
          DEFB 47
          DEFW k69
.r70
          DEFB 6
          DEFW k70
.r71
          DEFB 8
          DEFW k71
.r72
          DEFB 2
          DEFW k72
.r73
          DEFB 1
          DEFW k73
.k1       DEFM ESCAP
          DEFB "E"+#80
.k2       DEFB "1"+#80
.k3       DEFB "2"+#80
.k4       DEFB "3"+#80
.k5       DEFB "4"+#80
.k6       DEFB "5"+#80
.k7       DEFB "6"+#80
.k8       DEFB "7"+#80
.k9       DEFB "8"+#80
.k10      DEFB "9"+#80
.k11      DEFB "0"+#80
.k12      DEFB "-"+#80
.k13      DEFB "^"+#80
.k14      DEFM CL
          DEFB "R"+#80
.k15      DEFM DELET
          DEFB "E"+#80
.k16      DEFB "F","7"+#80
.k17      DEFB "F","8"+#80
.k18      DEFB "F","9"+#80
.k19      DEFM TA
          DEFB "B"+#80
.k20      DEFB "Q"+#80
.k21      DEFB "W"+#80
.k22      DEFB "E"+#80
.k23      DEFB "R"+#80
.k24      DEFB "T"+#80
.k25      DEFB "Y"+#80
.k26      DEFB "U"+#80
.k27      DEFB "I"+#80
.k28      DEFB "O"+#80
.k29      DEFB "P"+#80
.k30      DEFB " OR "+#80
.k31      DEFB "["+#80
.k32      DEFM RETUR
          DEFB "N"+#80
.k33      DEFB "F","4"+#80
.k34      DEFB "F","5"+#80
.k35      DEFB "F","6"+#80
.k36      DEFM CAPS LOC
          DEFB "K"+#80
.k37      DEFB "A"+#80
.k38      DEFB "S"+#80
.k39      DEFB "D"+#80
.k40      DEFB "F"+#80
.k41      DEFB "G"+#80
.k42      DEFB "H"+#80
.k43      DEFB "J"+#80
.k44      DEFB "K"+#80
.k45      DEFB "L"+#80
.k46      DEFB ":"+#80
.k47      DEFB ";"+#80
.k48      DEFB "]"+#80
.k49      DEFB "F","1"+#80
.k50      DEFB "F","2"+#80
.k51      DEFB "F","3"+#80
.k52      DEFM SHIF
          DEFB "T"+#80
.k53      DEFB "Z"+#80
.k54      DEFB "X"+#80
.k55      DEFB "C"+#80
.k56      DEFB "V"+#80
.k57      DEFB "B"+#80
.k58      DEFB "N"+#80
.k59      DEFB "M"+#80
.k60      DEFB ","+#80
.k61      DEFB "."+#80
.k62      DEFB "/"+#80
.k63      DEFB "\"+#80
.k64      DEFB "F","0"+#80
.k65      DEFM CURSOR U
          DEFB "P"+#80
.k66      DEFB "F","."+#80
.k67      DEFM CONTRO
          DEFB "L"+#80
.k68      DEFM COP
          DEFB "Y"+#80
.k69      DEFM SPAC
          DEFB "E"+#80
.k70      DEFM ENTE
          DEFB "R"+#80
.k71      DEFM CURSOR LEF
          DEFB "T"+#80
.k72      DEFM CURSOR DOW
          DEFB "N"+#80
.k73      DEFM CURSOR RIGH
          DEFB "T"+#80
.pointer  DEFW up
.message
          DEFM >>>>>  WELCOME TO THE GAM
          DEFM E WITH NO NAME <<<<<
          DEFS 5,32
          DEFM YOU MAY PRESS ANY OF TH
          DEFM E FOLLOWING KEYS FOR AN
          DEFM Y OF THE FOLLOWING OPTION
          DEFM S, YOU MAY OF COURSE PRES
          DEFM S ANY OTHER KEY BUT I DOU
          DEFM BT THAT THEY DO ANYTHIN
          DEFM G MORE THAN GO DOWN ON T
          DEFM O THE KEY PAD...
          DEFM OPTIONS :-
          DEFS 5,32
          DEFM 1) START GAME
          DEFM R) REDEFINE KEYS
          DEFM S) SAVE HI-SCORES
          DEFM L) LOAD HI-SCORES
          DEFM C) CHEAT MODE
          DEFM N) CHANGE NAME OF PLAYE
          DEFM R....
          DEFM YOU MAY PRESS ONE OF THES
          DEFM E KEYS NOW OR YOU CAN JUS
          DEFM T SIT THERE LIKE A SPAR
          DEFM E ONE AT A WEDDING AND D
          DEFM O ABSOLUTELY NOTHING BU
          DEFM T WATCH THIS STATE-OF-THE
          DEFM -ART PIECE OF PROGRAMMIN
          DEFM G WHICH IS SCROLLING THI
          DEFM S MESSAGE ROUND AND ROUN
          DEFM D AND ROUND AND ROUND AN
          DEFM D ROUND. THIS IS MAKING M
          DEFM E DIZZY. I BET YOU'RE WON
          DEFM DERING WHO I AM.. "NO" WE
          DEFM LL NEITHER DID I BUT I TH
          DEFM INK MY NAME IS "JASON BRO
          DEFM OKS" BUT THEN I COULD B
          DEFM E WRONG.. WOULD YOU LIK
          DEFM E TO KNOW WHAT YOUR SUP
          DEFM POSED TO DO IN THIS MONST
          DEFM ROSITY, "YES" WELL I'LL T
          DEFM ELL YOU THEN.  YOU'RE MEA
          DEFM NT TO BE A COP WHOSE JO
          DEFM B IT IS TO CLEAR THE CIT
          DEFM Y FROM SLIMEBALLS.  TO D
          DEFM O T
          DEFM HIS YOU MUST AIM YOUR RIF
          DEFM LE AT YOUR VICTIM AND BLA
          DEFM ST THEM AWAY.
          DEFM (THIS OF COURSE IS MY EXC
          DEFM USE FO
          DEFM R A GOOD OLD BLAST - BUT
          DEFM B
          DEFM ECAUSE I'M NO ORDINARY P
          DEFM ROGRAMMER I'VE DECIDED T
          DEFM O MAKE LIFE A LITTLE MOR
          DEFM E DIFFICULT FOR YOU. BECA
          DEFM USE IN REAL LIFE - IF YO
          DEFM U KILLED/MURDERED (* DELE
          DEFM TE AS APPLICABLE) YOU WO
          DEFM ULD SPEND A RATHER LONG H
          DEFM OLIDAY IN PRISON. (ANY ON
          DEFM E WATCH PRISONER CELL BLO
          DEFM CK H-OLIDAY CAMP ?) AND N
          DEFM O MATTER HOW HARD YOU THI
          DEFM NK IT IS NOT TO GIVE HI
          DEFM M A QUICK BLAST IN THE HE
          DEFM AD YOU MUST NOT, BECAUS
          DEFM E AS IN REAL LIFE THERE W
          DEFM ILL ALWAYS BE A WITNESS..
          DEFM THERE IS OF COURSE A POS
          DEFM SIBILITY OF BLASTING THE
          DEFM WITNESS AWAY BUT THEN THA
          DEFM T IS A RATHER WASTE OF A
          DEFM GOOD LIFE - WHAT MAKES M
          DEFM E THINK THESE WITNESSES A
          DEFM RE ANGELS ?
          DEFM ANSWER ON A POSTCARD AND
          DEFM SEND TO ......)
          DEFM WELL THAT WRAPS IT UP. I'
          DEFM D BETTER LET THIS MESSAG
          DEFM E SCROLL AROUND BEFORE YO
          DEFM UR COFFEE GETS COLD
          DEFM BYE  XOR  XOR  XOR
          DEFB 0
.messagev DEFM WELL WHAT DO YOU THIN
          DEFM K OF THIS THEN ? BET YO
          DEFM U DIDN'T EXPECT TWO SCRO
          DEFM LLS FOR THE PRICE OF ONE
          DEFM  XOR    I'M NOT REALLY SURE
          DEFM WHAT TO FILL THIS SPAC
          DEFM E UP WITH SO I SUPPOSE
          DEFM I WILL HAVE TO GIVE
          DEFM A LOAD OF BLURB AND DRIVE
          DEFM L. IF ANY OF YOU ARE HACK
          DEFM ERS THINKING ABOUT FINDIN
          DEFM G INFINITE ANYTHINGS THE
          DEFM N I AM AFRAID YOU ARE TO
          DEFM O LATE BECAUSE I HAVE BEA
          DEFM TEN YOU TO IT  BUT THERE
          DEFM IS NO REASON WHY YOU SH
          DEFM OULD NOT LOOK AT MY ROUTI
          DEFM NES  BUT IF ANY OF YOU AR
          DEFM E SOFTWARE PIRATES AND AR
          DEFM E THINKING OF RIPPING M
          DEFM E OFF THEN DON'T BECAUS
          DEFM E IF I FIND OUT WHO AND W
          DEFM HERE YOU LIVE I WILL PERS
          DEFM ONALLY RIP YOU TO PIECE
          DEFM S AND FEED YOU TO SIR CLI
          DEFM VE SINCLAIR.  WHY WASN'T
          DEFM THE SPECTRUM CALLED AN OR
          DEFM IC ?   ALAS MY ORIC I....
          DEFM FINISH THIS FAMOUS SENT
          DEFM ENCE AND YOU COULD WIN A
          DEFM PRIZE.  A WHOLE DAY PLAYI
          DEFM NG AMSOFT GAMES.  YOU AR
          DEFM E PROBABLY WONDERING WH
          DEFM Y I USE DOUBLE COLOURED C
          DEFM HARACTERS IN MY PROGRAM A
          DEFM ND WHETHER OR NOT I CAN A
          DEFM LTER THEM.
          DEFM THE ANSWER IS YES I CAN B
          DEFM UT I'M TOO LAZY TO PUT I
          DEFM N THE EXTRA BIT OF CODE..
          DEFM BUT IF YOU CARRY ON WATCH
          DEFM ING THE MESSAGE AT THE BO
          DEFM TTOM THEN YOU WOULD OF NO
          DEFM TICED THAT IT CHANGES
          DEFM COLOUR.  WELL THAT WAS A
          DEFM RATHER WASTE OF VALUABLE
          DEFM MEMORY SPENT ON THIS WAFF
          DEFM LE.  BEFORE I GO I APO
          DEFM LOGISE FOR THE POORLY D
          DEFM IGITIZED SPEECH BUT IT I
          DEFM S THE BEST I COULD DO..
          DEFM T T F N     TA TAA FOR N
          DEFM OW
          DEFB 0
.enterfil DEFM >> ENTER FILENAME <<
          DEFB 0
.badfilem DEFM > FILE IS NOT A HIGH-S
          DEFM CORE FILE <
          DEFB 0
.taperror DEFM >> LOADING ERROR. <<
          DEFB 0
.taprompt DEFM >> INSERT TAPE AND PRESS
          DEFM PLAY <<
          DEFB 0
.scrollHL DEFW 0
.cheatmsg DEFM >> CHEAT MODE OPERATIVE <
          DEFB "<",0
.cheatm2  DEFM >> CHEAT MODE NOW OFF  XOR  <
          DEFB "<",0
.count    DEFB 7
.flag5    DEFB 0                        ; Cheat Mode Flag
.flag2    DEFB 0
.flag1    DEFB 0
.soption  DEFM >> PRESS KEY FOR DESIRED
          DEFM OPTION <<
          DEFB 0
.table    DEFW hiscna1,hiscna2,hiscna3
          DEFW hiscna4,hiscna5
.mhiscore DEFM TODAY'S HI-SCORES
          DEFB 0
.hiscna1  DEFM MASTER..
          DEFB 0
.hiscna2  DEFM EXPERT..
          DEFB 0
.hiscna3  DEFM GOOD....
          DEFB 0
.hiscna4  DEFM FAIR....
          DEFB 0
.hiscna5  DEFM POOR....
          DEFB 0
.hisc1    DEFB 1,0,0
.hisc2    DEFB 0,#80,0
.hisc3    DEFB 0,#60,0
.hisc4    DEFB 0,#40,0
.hisc5    DEFB 0,#20,0
.endhisc  EQU $
.buffer   DEFS 7,0
.keymssg  DEFW UP
.PLAYER1
          DEFM > PLAYER ONE START <
          DEFB 0
.tapbuff  DEFS endhisc-hiscna1+2,0
.scrdest  DEFS #c9*2,0
.keychar
          DEFB #00,#00,#00,#00
          DEFB #00,#00,#00,#00
          DEFB #18,#18,#18,#18
          DEFB #18,#00,#18,#00
          DEFB #6C,#6C,#6C,#00
          DEFB #00,#00,#00,#00
          DEFB #6C,#6C,#FE,#6C
          DEFB #FE,#6C,#6C,#00
          DEFB #18,#3E,#58,#3C
          DEFB #1A,#7C,#18,#00
          DEFB #00,#C6,#CC,#18
          DEFB #30,#66,#C6,#00
          DEFB #38,#6C,#38,#76
          DEFB #DC,#CC,#76,#00
          DEFB #18,#18,#30,#00
          DEFB #00,#00,#00,#00
          DEFB #0C,#18,#30,#30
          DEFB #30,#18,#0C,#00
          DEFB #30,#18,#0C,#0C
          DEFB #0C,#18,#30,#00
          DEFB #00,#66,#3C,#FF
          DEFB #3C,#66,#00,#00
          DEFB #00,#18,#18,#7E
          DEFB #18,#18,#00,#00
          DEFB #00,#00,#00,#00
          DEFB #00,#18,#18,#30
          DEFB #00,#00,#00,#7E
          DEFB #00,#00,#00,#00
          DEFB #00,#00,#00,#00
          DEFB #00,#18,#18,#00
          DEFB #06,#0C,#18,#30
          DEFB #60,#C0,#80,#00
          DEFB #7C,#C6,#CE,#D6
          DEFB #E6,#C6,#7C,#00
          DEFB #18,#38,#18,#18
          DEFB #18,#18,#7E,#00
          DEFB #3C,#66,#06,#3C
          DEFB #60,#66,#7E,#00
          DEFB #3C,#66,#06,#1C
          DEFB #06,#66,#3C,#00
          DEFB #1C,#3C,#6C,#CC
          DEFB #FE,#0C,#1E,#00
          DEFB #7E,#62,#60,#7C
          DEFB #06,#66,#3C,#00
          DEFB #3C,#66,#60,#7C
          DEFB #66,#66,#3C,#00
          DEFB #7E,#66,#06,#0C
          DEFB #18,#18,#18,#00
          DEFB #3C,#66,#66,#3C
          DEFB #66,#66,#3C,#00
          DEFB #3C,#66,#66,#3E
          DEFB #06,#66,#3C,#00
          DEFB #00,#00,#18,#18
          DEFB #00,#18,#18,#00
          DEFB #00,#00,#18,#18
          DEFB #00,#18,#18,#30
          DEFB #0C,#18,#30,#60
          DEFB #30,#18,#0C,#00
          DEFB #00,#00,#7E,#00
          DEFB #00,#7E,#00,#00
          DEFB #60,#30,#18,#0C
          DEFB #18,#30,#60,#00
          DEFB #3C,#66,#66,#0C
          DEFB #18,#00,#18,#00
          DEFB #7C,#C6,#DE,#DE
          DEFB #DE,#C0,#7C,#00
          DEFB #18,#3C,#66,#66
          DEFB #7E,#66,#66,#00
          DEFB #FC,#66,#66,#7C
          DEFB #66,#66,#FC,#00
          DEFB #3C,#66,#C0,#C0
          DEFB #C0,#66,#3C,#00
          DEFB #F8,#6C,#66,#66
          DEFB #66,#6C,#F8,#00
          DEFB #FE,#62,#68,#78
          DEFB #68,#62,#FE,#00
          DEFB #FE,#62,#68,#78
          DEFB #68,#60,#F0,#00
          DEFB #3C,#66,#C0,#C0
          DEFB #CE,#66,#3E,#00
          DEFB #66,#66,#66,#7E
          DEFB #66,#66,#66,#00
          DEFB #7E,#18,#18,#18
          DEFB #18,#18,#7E,#00
          DEFB #1E,#0C,#0C,#0C
          DEFB #CC,#CC,#78,#00
          DEFB #E6,#66,#6C,#78
          DEFB #6C,#66,#E6,#00
          DEFB #F0,#60,#60,#60
          DEFB #62,#66,#FE,#00
          DEFB #C6,#EE,#FE,#FE
          DEFB #D6,#C6,#C6,#00
          DEFB #C6,#E6,#F6,#DE
          DEFB #CE,#C6,#C6,#00
          DEFB #38,#6C,#C6,#C6
          DEFB #C6,#6C,#38,#00
          DEFB #FC,#66,#66,#7C
          DEFB #60,#60,#F0,#00
          DEFB #38,#6C,#C6,#C6
          DEFB #DA,#CC,#76,#00
          DEFB #FC,#66,#66,#7C
          DEFB #6C,#66,#E6,#00
          DEFB #3C,#66,#60,#3C
          DEFB #06,#66,#3C,#00
          DEFB #7E,#5A,#18,#18
          DEFB #18,#18,#3C,#00
          DEFB #66,#66,#66,#66
          DEFB #66,#66,#3C,#00
          DEFB #66,#66,#66,#66
          DEFB #66,#3C,#18,#00
          DEFB #C6,#C6,#C6,#D6
          DEFB #FE,#EE,#C6,#00
          DEFB #C6,#6C,#38,#38
          DEFB #6C,#C6,#C6,#00
          DEFB #66,#66,#66,#3C
          DEFB #18,#18,#3C,#00
          DEFB #FE,#C6,#8C,#18
          DEFB #32,#66,#FE,#00
          DEFS 8,0
.endcode
