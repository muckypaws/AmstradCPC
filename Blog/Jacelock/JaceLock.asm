;
         ORG  #4000                     ; Alternative DDFDC Commands
         ENT  $                         ; Version 9.89
JacelocK                                ; JacelocK Protection System V2.89 (B)
         LD   a,#c9
         LD   (JacelocK),a
         LD   hl,kernel
         LD   bc,rsx
         JP   #bcd1
rsx
         DEFW table
         JP   formatd
         JP   formatv
         JP   formati
         JP   encrypt
table
         DEFM PROTECT.DAT
         DEFB "A"+#80
         DEFM PROTECT.CP
         DEFB "M"+#80
         DEFM PROTECT.IB
         DEFB "M"+#80
         DEFM ENCRYP
         DEFB "T"+#80
         DEFB 0
;
formatd                                 ; Format A Disk To DATA Format !
         OR   a
         RET  z
         LD   b,0
         LD   a,9
         LD   hl,data
         JR   formatt
formatv                                 ; Format A Disk To CPM Format !
         OR   a
         RET  z
         LD   b,1
         LD   a,9
         LD   hl,vendor
         JR   formatt
formati                                 ; Format A Disk To IBM Standard Format 
         OR   a
         RET  z
         LD   b,0
         LD   a,8
         LD   hl,IBM
formatt
         DI   
         LD   (standard+1),a
         LD   a,b
         LD   (CPMFLAG),a
         LD   a,(ix+0)
         LD   (drive),a
         LD   (driveb),a
         LD   de,fo
         LD   bc,36
         LDIR 
         LD   hl,standard
         LD   de,XDPB
         LD   bc,6
         LDIR 
         CALL motoron
         LD   e,(ix+0)
         LD   d,0
         DI   
         CALL movtrak
         LD   b,40
         LD   d,0
formatt1
         PUSH bc
         PUSH de
         CALL init
         POP  de
         POP  bc
         PUSH bc
         PUSH de
         CALL printtrk
         LD   hl,fo
         LD   a,(drive)
         LD   e,a
         DI   
         CALL format
         POP  de
         POP  bc
         INC  d
         CALL quitchk
         DJNZ formatt1
bad                                     ; Create The Protected Format On Track 
         DI   
         LD   hl,badparam               ; Point HL To Bad Parameters
         LD   de,XDPB
         LD   bc,6
         LDIR                           ; Copy Protection Parameters Into XDPB
         LD   hl,badform
         LD   a,(drive)
         LD   e,a
         LD   d,40
         CALL printtrk
         DI   
         CALL format
         LD   hl,standard
         LD   de,XDPB
         LD   bc,6
         LDIR 
         LD   a,(CPMFLAG)
         OR   a
         JR   z,exit
         LD   hl,CPMBOOT
         LD   c,#41
         LD   a,(drive)
         LD   e,a
         LD   d,0
         DI   
         CALL writsect
exit
         LD   a,(drive)
         LD   e,a
         LD   d,0
         DI   
         CALL movtrak
         JP   motoroff
quitchk
         PUSH hl
         PUSH de
         PUSH bc
         PUSH af
         LD   a,66
         CALL #bb1e
         DI   
         JR   nz,QUITFORM
         POP  af
         POP  bc
         POP  de
         POP  hl
         RET  
QUITFORM
         LD   hl,quitmess
         CALL print
         DI   
         POP  hl
         POP  af
         POP  bc
         POP  de
         POP  hl
         JR   exit
printtrk                                ; Print Which Track Your Formatting
         PUSH hl
         PUSH de
         PUSH bc
         PUSH af
         LD   hl,numbers
         LD   e,d
         LD   d,0
         ADD  hl,de
         ADD  hl,de
         LD   a,(hl)
         CALL #bb5a
         INC  hl
         LD   a,(hl)
         CALL #bb5a
         LD   a,8
         CALL #bb5a
         CALL #bb5a
         DI   
         POP  af
         POP  bc
         POP  de
         POP  hl
         RET  
init
         PUSH af
         PUSH hl
         PUSH de
         PUSH bc
         LD   hl,fo
         LD   b,9
init1
         LD   (hl),d
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         DJNZ init1
         LD   hl,standard
         LD   de,XDPB
         LD   bc,6
         LDIR 
         POP  bc
         POP  de
         POP  hl
         POP  af
         RET  
motoron
         DI                             ; All Reg. Preserved
         PUSH hl
         PUSH bc
         PUSH af
         LD   bc,#fa7e
         LD   a,1
         OUT  (c),a
         LD   hl,0
         LD   b,2
motoron1                                ; Pause Loop To Allow Motor To Pick Up 
         DEC  hl
         LD   a,h
         OR   l
         JR   nz,motoron1
         DJNZ motoron1
         POP  af
         POP  bc
         POP  hl
         RET                            ; Exit All Reg. Preserved
motoroff
         PUSH bc
         PUSH af                        ; All Reg. Preserved
         LD   bc,#fa7e
         XOR  a
         OUT  (c),a
         POP  af
         POP  bc
         RET                            ; Quit All Reg. Intact
format                                  ; Entry:- HL=Header Info.Buff. D=Track
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl                        ; Preserve Registers
         LD   a,e
         LD   (drive),a                 ; Which Drive
         CALL movtrak                   ; E=Drive
         PUSH hl                        ; Locate Drive Head To Correct Track
;
         LD   a,(sectsize)
         LD   (formcode+3),a            ; Store For Command Phase
         LD   a,(sect_trk)
         LD   (formcode+4),a            ; Store Sectors Per Track
         LD   a,(gap3f)
         LD   (formcode+5),a            ; Store GAP#3 For Formatting
         LD   a,(filler)
         LD   (formcode+6),a            ; Store Filler Byte
         LD   de,formcode               ; Codes For Command Phase
format1
         CALL ddfdccom                  ; Get Bytes And Act On 'em
         POP  hl                        ; Restore Registers
         CALL ddfdcwri                  ; Write Bytes To Disk
         LD   hl,formret                ; Return Status
         CALL ddfdcres                  ; Get status
         POP  hl
         POP  de
         POP  bc
         POP  af
         RET                            ; Quit with all registers intact
writsect                                ; Entry HL=DATA ADDR D=TRK E=DRV C=SECT
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl                        ; Preserve Registers
         CALL movtrak                   ; Move To Track D
         LD   de,writcomd               ; Point To Command Data
         CALL ddfdccom                  ; Start COMMAND PHASE
         LD   hl,CPMBOOT
         CALL ddfdcwri                  ; Write It To Disk
         LD   hl,writcomr               ; HL=Write Command Return
         CALL ddfdcres                  ; Call Up Result Phase
         POP  hl
         POP  de
         POP  bc
         POP  af                        ; Restore Registers
         RET                            ; Exit Routine
movtrak                                 ; On Entry D = Destination Track
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl                        ; Preserve Registers
         CALL senseint                  ; Get Current Track Position
         LD   a,(sense+1)
         SUB  d                         ; Is Destination Track Current Track ?
         JR   z,movtrake                ; If So Quit
         LD   a,d                       ; A = Track
         OR   a                         ; Is Destination Track 0
         JR   z,trak0                   ; If So Then Trak0
         CALL seek                      ; Give DDFDC SEEK Command
movtrak1                                ; Use This Since No DMA
         CALL senseint                  ; Has Drive Reached Destination ?
         LD   a,(sense+1)
         LD   b,a                       ; Let B=Current Track
         LD   a,d                       ; Let A=Destination Track
         SUB  b                         ; Are They Equal ?
         JR   nz,movtrak1               ; If Not Loop movtrak1
movtrake                                ; Quit Routine
         POP  hl
         POP  de
         POP  bc
         POP  af
         RET                            ; Preserved Registers
trak0
         CALL recalib                   ; Recalibrate (Move To Track 0)
trak01
         CALL senseds                   ; Call SENSE DRIVE STATUS
         LD   a,(hl)
         AND  %10000                    ; Has Drive Head Reached TRK 0
         JR   z,trak01                  ; If Not Loop
         JR   movtrake                  ; Restore Regs & Quit
;
;                       **** SENSE DRIVE STATUS ****
;
senseds
         LD   a,(drive)
         LD   (SenseCde+2),a
         LD   de,SenseCde
         CALL ddfdccom
         LD   hl,sendst                 ; Pointer To Put Resultant Data
         CALL ddfdcres
         DEC  hl                        ; On Exit HL=Address Of Status Reg. 3
         RET                            ; Quit
;
;                  **** RECALIBRATE DRIVE HEAD (TRACK 0) ****
;
recalib                                 ; Recalibrate
         LD   de,RECALCOM
         LD   a,(drive)
         LD   (RECALCOM+2),a
         JP   ddfdccom
;
;                       **** SENSE INTERUPT STATUS ****
;
senseint                                ; Sense Interupt Status
         PUSH de                        ; Preserve DE
         LD   de,SENSEINT
         CALL ddfdccom
         LD   hl,sense
         CALL ddfdcres                  ; Call & Quit
         POP  de
         RET  
;
;                   **** SEEK COMMAND MOVE TRACK HEAD ****
;
seek                                    ; SEEK Entry D=Track
         PUSH de
         LD   (Seek_DT+3),a
         LD   a,(drive)
         LD   (Seek_DT+2),a
         LD   de,Seek_DT
         CALL ddfdccom
         POP  de
         RET  
;
;                        **** DDFDC COMMAND PHASE ****
;
ddfdccom                                ; DDFDC Command Phase
         LD   bc,#fb7e
         PUSH bc
         LD   a,(de)                    ; Get Number Of Parameters
ddfdc
         PUSH af                        ; Preserve Counter
         INC  de
ddfdc1                                  ; Is Drive Ready To Accept Command ?
         IN   a,(c)
         ADD  a,a
         JR   nc,ddfdc1
         JP   m,ddfdc1                  ; If Not Then Wait
         LD   a,(de)
         INC  c
         OUT  (c),a                     ; Give DDFDC Command @ Port #FB7F
         DEC  c
         LD   a,5
ddfdcp                                  ; Wait 13 uS
         DEC  a
         JR   nz,ddfdcp
         POP  af
         DEC  a
         JR   nz,ddfdc
         POP  bc                        ; On Return BC=#FB7E
         RET                            ; Quit
;
ddfdcexc                                ; DDFDC Execution Phase - DATA IN
         LD   a,(drive)
         OR   #20
         LD   (ddfdexc2-1),a
ddfdcexd
         LD   bc,#fb7e
         IN   a,(c)
         CP   #c0
         JR   c,ddfdexc1
ddfdexc0
         INC  c                         ; Point To #FB7F - DATA REGISTER
         IN   a,(c)                     ; Get byte from port
         LD   (hl),a                    ; Store it
         DEC  c                         ; Restore Port To Main Status Reg.
         INC  hl                        ; HL+1
ddfdexc1
         IN   a,(c)
         JP   p,ddfdexc1                ; Drive Not Finished Output So Wait
         AND  #20                       ; Main Status Reg=Execution Phase Start
ddfdexc2
         JR   nz,ddfdexc0               ; If Not Finished Loop ddfdexc
         RET                            ; Else Quit
;
;              **** DDFDC EXECUTION PHASE DATA TO SYSTEM ****
;
ddfdcwri                                ; DDFDC Write Into Data Register
         LD   bc,#fb7e                  ; Point To MAIN STATUS REG
         LD   a,(drive)
         OR   #20
         LD   (ddfdcw3-1),a
         JR   ddfdcw2                   ; Wait Till DDFDC Ready.
ddfdcw1
         INC  c                         ; Point To Data Port
         LD   a,(hl)                    ; Get Byte To Place
         INC  hl                        ; HL+1
         OUT  (c),a                     ; Output To Port #FB7F
         DEC  c                         ; Restore Port
ddfdcw2
         IN   a,(c)
         JP   p,ddfdcw2                 ; If Drive Not Ready Loop ddfdcw2
         AND  #20
ddfdcw3
         JR   nz,ddfdcw1                ; Is All Output Finished ?
         RET                            ; Quit 
;
;                       **** DDFDC RESULTS PHASE ****
;
ddfdcres                                ; DDFDC Result Phase
         LD   a,(drive)
         OR   #10
         LD   (ddfdresq-1),a
ddfdcret
         IN   a,(c)
         CP   #c0                       ; Is DDFDC Ready ?
         JR   c,ddfdcret                ; If Not Wait
         INC  c
         IN   a,(c)                     ; Get Byte From DATA REG
         LD   (hl),a                    ; Store it
         DEC  c                         ; Restore Data Reg.
         INC  hl                        ; HL+1
         LD   a,5
ddfdresp                                ; Wait 13 uS
         DEC  a
         JR   nz,ddfdresp
         IN   a,(c)
         AND  #10                       ; Has Results Finished ?
ddfdresq
         JR   nz,ddfdcret               ; If Not Loop ddfdcres
         RET                            ; Quit 
;
;                  **** DATA AREA BUFFERS, POINTERS Etc. ****
;
sense                                   ; Data from RESULT PHASE OF SNSE INT ST
         DEFB 0                         ; ST0
         DEFB 0                         ; Present Track Number
;
;             **** BYTE FOR SENSE DRIVE STATUS RESULT PHASE ****
;
sendst   DEFB 0                         ; Status Register 3
;
;             **** DATA FOR COMMAND PHASE OF FORMAT A TRACK ****
;
formcode                                ; Format Track Data
         DEFB 6                         ; 6 Paramters
         DEFB #4d                       ; Code For Formatting
drive    DEFB 0                         ; Drive
         DEFB 2                         ; Size of Sectors 2 ^ (N+7)
         DEFB 9                         ; No. of Sector Per Track
         DEFB #2a                       ; Gap Length
         DEFB #e5                       ; Data Pattern = Filler Byte
;
;                  **** FORMAT RESULTS PHASE TABLE ****
;
formret                                 ; Resultant Data From FORMAT TRACK
         DEFB 0                         ; ST0
         DEFB 0                         ; ST1
         DEFB 0                         ; ST2
         DEFB 0                         ; Track
         DEFB 0                         ; Head
         DEFB 0                         ; Sector
         DEFB 0                         ; Size Of Sector
;
writcomd                                ; Write Command Data
         DEFB 9                         ; 9 Parameters
         DEFB #45                       ; WRITE DATA Command Alter #49 Del. Dta
driveb
         DEFB 0                         ; Drive
         DEFB 0                         ; Track
         DEFB 0                         ; Head Number
         DEFB #41                       ; Sector To Read
         DEFB 2                         ; Number Of Data Bytes Per Sector
         DEFB #41                       ; End Of Track
         DEFB #2a                       ; Gap #3 - Generally #2a
         DEFB #ff                       ; Data Length - Sect Size < 256
writcomr                                ; Write Command Result Table
         DEFB 0                         ; Status Register 0
         DEFB 0                         ; Status Register 1
         DEFB 0                         ; Status Register 2
         DEFB 0                         ; Track Number
         DEFB 0                         ; Head Number
         DEFB 0                         ; Sector Number
         DEFB 0                         ; Sector Size
         DEFS 12,0
;
;Default Numbers For 9 Sectors Per Track 512 Bytes Per Sector GAP #3=#2a
;
XDPB                                    ; For My Own Use (Alternative XPB)
;
filler   DEFB #e5                       ; Filler Byte When Formatting
sect_trk DEFB 9                         ; Number Of Sectors Per Track
sectsize DEFB 2                         ; Size Of Sectors
gap3rw   DEFB #2a                       ; GAP #3 For Read/Write
gap3f    DEFB #52                       ; GAP #3 For Formatting
dataleng DEFB #ff
standard DEFB #e5,9,2,#2a,#52,#ff
badparam DEFB 0,30,0,5,5,#ff
;
;            **** COMMAND DATA FOR SENSE DRIVE STATUS ****
;
SenseCde
         DEFB 2                         ; 2 Parameters
         DEFB 4                         ; Code For SENSE DRIVE STATUS
         DEFB 0                         ; Drive
;
;                   **** COMMAND DATA FOR SEEK ****
;
Seek_DT                                 ; Seek Codes For Command
         DEFB 3                         ; 3 Parameters
         DEFB 15                        ; Command For Seek
         DEFB 0                         ; Drive
         DEFB 0                         ; Destination Track
;
;            **** COMMAND DATA FOR SENSE INTERUPT STATUS ****
;
SENSEINT DEFB 1                         ; One Parameter
         DEFB 8                         ; Command Code For SENSE INTERUPT STATE
RECALCOM DEFB 2                         ; 2 Parameters
         DEFB 7                         ; Command Code For RECALIBRATE
         DEFB 0                         ; Which Drive
fo                                      ; Format Disk
         DEFS 9*4,0
data
         DEFB 0,0,#c1,2                 ; Data For Sector Numbers To Format
         DEFB 0,0,#c6,2                 ; In This Case DATA Format
         DEFB 0,0,#c2,2
         DEFB 0,0,#c7,2
         DEFB 0,0,#c3,2
         DEFB 0,0,#c8,2
         DEFB 0,0,#c4,2
         DEFB 0,0,#c9,2
         DEFB 0,0,#c5,2
vendor
         DEFB 0,0,#41,2
         DEFB 0,0,#46,2
         DEFB 0,0,#42,2
         DEFB 0,0,#47,2
         DEFB 0,0,#43,2
         DEFB 0,0,#48,2
         DEFB 0,0,#44,2
         DEFB 0,0,#49,2
         DEFB 0,0,#45,2
IBM
         DEFB 0,0,1,2
         DEFB 0,0,5,2
         DEFB 0,0,2,2
         DEFB 0,0,6,2
         DEFB 0,0,3,2
         DEFB 0,0,7,2
         DEFB 0,0,4,2
         DEFB 0,0,8,2
badform
         DEFB 128,67,255,6
         DEFB 0,0,0,0
         DEFB 1,1,1,1
         DEFB 2,2,2,2
         DEFB 99,99,99,99
         DEFB 64,64,64,64
         DEFB 26,26,26,26
         DEFM Jace
         DEFM locK 
         DEFM Pro
         DEFM tect
         DEFM ion 
         DEFM Syst
         DEFM em V
         DEFM 2.89
         DEFM (B) 
         DEFM (C) 
         DEFM 1989 
         DEFM Jac
         DEFM esof
         DEFM T. T
         DEFM o Al
         DEFM l Ha
         DEFM cker
         DEFM s Fu
         DEFM ck O
         DEFM ff  
         DEFB 40,0,0,0
         DEFB 99,99,99,99
         DEFB 66,66,66,66
kernel
         DEFS 4,0
;
encrypt
off      EQU  4
tlen     EQU  #52e0+off
tfile    EQU  #52e5+off
tdest    EQU  #52dd+off
texec    EQU  #5334+off
tcoding  EQU  #5336+off
         LD   hl,#5000
         LD   de,#5001
         LD   bc,#4000
         LD   (hl),0
         LDIR 
         LD   hl,spare
         LD   de,#5000
         LD   bc,#350
         LDIR 
         LD   hl,insert
         CALL print
         CALL #bb18
         LD   hl,filename
         LD   b,14
         CALL #bc77
         RET  nc
         EX   de,hl
         LD   (tdest),hl
         LD   (tlen),bc
         LD   (tfile),a
         LD   hl,tcoding
         CALL #bc83
         RET  nc
         LD   (texec),hl
         CALL #bc7a
         RET  nc
         LD   hl,(tlen)
         LD   de,#350
         ADD  hl,de
         LD   (#5013),hl
         LD   (xlen1),hl
xoring                                  ; Xor Routines
         DI   
         LD   hl,#5023
         LD   bc,#200
xlen1    EQU  $-2
         LD   a,"J"
         LD   r,a
         AND  a
xor1
         LD   a,r
         XOR  (hl)
         LD   (hl),a
         INC  hl
         DEC  bc
         LD   a,c
         OR   b
         JR   nz,xor1
         LD   hl,destin
         CALL print
         CALL #bb18
         LD   hl,creat
         CALL print
         LD   hl,savename
         LD   b,14
         CALL #bc8c
         LD   hl,#5000
         LD   de,(#5013)
         LD   bc,#5000
         LD   a,2
         CALL #bc98
         JP   #bc8f
print
         LD   a,(hl)
         OR   a
         RET  z
         INC  hl
         CALL #bb5a
         JR   print
insert
         DEFB 12
         DEFM Insert Source Disk With 
         DEFM : 
filename DEFM A:FILENAME.BIN 
         DEFM And Press A Key
         DEFB 0
destin
         DEFB 12
         DEFM Insert 
         DEFM Destination Disk & Press 
         DEFM A Key
         DEFB 0
creat
         DEFB 12
         DEFM Created Protected Fil
         DEFM e : 
savename DEFM B:SAVENAME.BIN
         DEFB 0
         DEFM JacelocK Protection SYSTE
         DEFM MS V2.89(B) BUDGET PROTE
         DEFM CTION 
         DEFM (C) 1989 JacesofT
         DEFM For Further Information C
         DEFM ontact JASON BROOKS (0602
         DEFM ) 397351
quitmess
         DEFB 12
         DEFM QUITTED FROM FORMATTING
         DEFB 7,0
numbers
         DEFM 0 1 2 3 4 5 6 7 8 9 1011
         DEFM 121314151617181920212223
         DEFM 242526272829303132333435
         DEFM 36373839404142
CPMFLAG  DEFB 0
CPMBOOT
         ORG  #100
         DI   
         LD   sp,#c000
         LD   hl,next1
         LD   c,#ff
         CALL #bd16
next1
         CALL #bccb
         LD   hl,next2
         LD   de,#af00
         PUSH de
         LD   bc,#100
         LDIR 
         RET  
next2
         ORG  #af00
         LD   a,#c9
         LD   (#bdee),a
         LD   hl,DiSc
         LD   b,4
         LD   de,#c000
         CALL #bc77
         LD   hl,#170
         PUSH hl
         PUSH bc
         CALL #bc83
         CALL #bc7a
         DI   
         POP  bc
         POP  hl
         LD   sp,#bff8
         ADD  hl,bc
         LD   c,0
         CALL #b90f
         EX   de,hl
         LD   a,(#c002)
         OR   a
         LD   hl,#ae81
         JR   z,basicl1
         PUSH hl
         PUSH de
         LD   hl,basvars
         LD   de,#ae00
         LD   bc,#70
         LDIR 
         POP  de
         POP  hl
         LD   hl,#ae64
basicl1
         LD   (hl),#6f
         INC  hl
         LD   (hl),1
         INC  hl
         LD   b,4
basicl
         LD   (hl),e
         INC  hl
         LD   (hl),d
         INC  hl
         DJNZ basicl
basic
         LD   hl,#40
         LD   (hl),0
         LD   a,(#c002)
         OR   a
         JP   z,#e9bd
         DEC  a
         JP   z,#ea7d
         JP   #ea78
DiSc
         DEFM DISC
basvars
         DEFB #05,#05,#05,#05
         DEFB #05,#05,#05,#05
         DEFB #05,#05,#05,#05
         DEFB #05,#00,#00,#00
         DEFB #00,#00,#00,#00
         DEFB #00,#00,#00,#6F
         DEFB #01,#70,#AE,#3F
         DEFB #00,#00,#00,#00
         DEFB #00,#00,#00,#00
         DEFB #00,#00,#00,#00
         DEFB #00,#00,#00,#00
         DEFB #00,#01,#09,#09
         DEFB #FF,#00,#00,#00
         DEFB #00,#00,#00,#00
         DEFB #00,#00,#C7,#00
         DEFB #00,#00,#00,#00
         DEFB #00,#00,#00,#00
         DEFB #00,#00,#00,#00
         DEFB #00,#00,#00,#00
         DEFB #00,#00,#00,#00
         DEFB #00,#00,#00,#00
         DEFB #00,#00,#40,#FF
         DEFB #45,#00,#FE,#BF
         DEFB #0D,#00,#7B,#A6
         DEFB #FB,#A6,#40,#00
         DEFB #6F,#01,#72,#01
         DEFB #72,#01,#72,#01
         DEFB #72,#01,#00,#00
         DEFB #00
spare    EQU  #4800