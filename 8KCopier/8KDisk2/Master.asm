;
         ORG  #7a00                     ; JacesofT Operating System V1.00
start    ENT  $
         DI   
         LD   bc,#7fc0
         OUT  (c),c
         CALL motoron
WPT
         XOR  a
         LD   (drive),a
         CALL checkst
         LD   a,1
         LD   (drive),a
         CALL checkst
         LD   hl,sendst
         LD   a,(hl)
         BIT  6,a
         RET  z
         LD   hl,WP
         CALL print
         LD   hl,KEY
         CALL print
         CALL #bb18
         JR   WPT
checkst
         DI   
         LD   a,(drive)
         PUSH af
         CALL senseds
         POP  af
         LD   b,a
         LD   a,(hl)
         AND  3
         CP   b
         JR   nz,checkst
         LD   a,(hl)
         BIT  5,a
nodisk
         RET  nz
         LD   hl,NODISK
         CALL print
DrIv
         LD   a,(drive)
         ADD  a,"A"
         CALL #bb5a
         LD   a,":"
         CALL #bb5a
         LD   hl,KEY
         CALL print
         CALL #bb18
         JR   checkst
;
print
         LD   a,(hl)
         OR   a
         RET  z
         INC  hl
         CALL #bb5a
         JR   print
initiate
         DI   
         LD   de,0
         CALL movtrak
         LD   de,1
         CALL movtrak
         LD   e,0
         CALL readid
         LD   hl,diskid+5
         LD   a,(hl)
         AND  #c0
         CP   #c0
         JR   z,DATA
         CP   #40
         JR   z,VENDOR
         LD   a,#ff
         JR   seterr
DATA
         LD   hl,data
         LD   de,fo
         LD   bc,9*4
         LDIR 
         LD   bc,#c9c1
         CALL patchrw
         JR   lasttrak
VENDOR
         LD   hl,vendor
         LD   de,fo
         LD   bc,9*4
         LDIR 
         LD   bc,#4941
         CALL patchrw
lasttrak                                ; Find Last Track Of Data
         LD   d,39
         LD   b,37
lasttrk1
         PUSH bc
         LD   e,0
         LD   hl,codebuff
         CALL readsect
         LD   hl,codebuff
         LD   bc,512*9
compare
         LD   a,(hl)
         INC  hl
         CP   #e5
         JR   nz,compare2
         DEC  bc
         LD   a,b
         OR   c
         JR   nz,compare
         POP  bc
         DEC  d
         DJNZ lasttrk1
         JR   compare3
compare2
         POP  bc
compare3
         LD   a,d
         INC  a
         LD   (lastt+1),a
         CALL motoroff
         XOR  a
seterr
         LD   (errorf),a
         RET  
copy                                    ; Copy Up to Track T
         DI   
         CALL motoron
         LD   de,0
         CALL movtrak
         LD   e,1
         CALL movtrak
         LD   hl,standard
         LD   de,XDPB
         LD   bc,6
         LDIR 
         LD   de,0
copy1
         PUSH de
         LD   hl,codebuff
         CALL readsect
         LD   hl,fo
         LD   e,1
         CALL setfo
         LD   c,0
copy2
         INC  c
         LD   a,c
         CP   11
         JR   z,baddisk
         CALL format
         CALL writsect
         CALL verify
         JR   c,copy2
         POP  de
         INC  d
         LD   a,d
lastt    CP   4
         JR   nz,copy1
;
creatbad                                ; Make Bad Format On Track 40
         LD   hl,badparam
         LD   de,XDPB
         LD   bc,6
         LDIR 
         LD   hl,badform
         LD   d,40
         LD   e,1
         CALL format
         JP   motoroff
verify
         LD   hl,verifyb
         LD   e,1
         CALL readsect
         LD   a,(readcomr+1)
         AND  #7f
         RET  z
         SCF  
         RET  
         PUSH de
         LD   hl,codebuff
         LD   bc,9*512
         LD   de,verifyb
verify1
         LD   a,(de)
         CP   (hl)
         JR   z,verify2
         POP  de
         SCF  
         RET  
verify2
         DEC  bc
         LD   a,b
         OR   c
         JR   nz,verify1
         POP  de
         OR   a
         RET  
setfo
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         LD   hl,fo
         LD   b,9
setfo1
         LD   (hl),d
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         DJNZ setfo1
         POP  hl
         POP  de
         POP  bc
         POP  af
         RET  
baddisk
         POP  de
         LD   a,#80
         LD   (errorf),a
         LD   a,d
         LD   (badtrack),a
         LD   bc,#fa7e
         XOR  a
         OUT  (c),a
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
readsect                                ; ENTRY HL=BUFFER E=DRIVE D=TRK C=SECTR
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl                        ; Preserve Registers
         PUSH hl
         LD   a,d
         LD   (readcomd+3),a
         LD   a,e
         LD   (readcomd+2),a
         CALL movtrak                   ; Move To Approprite Track
         LD   de,readcomd
         CALL ddfdccom                  ; Set Up Command
         POP  hl
         CALL ddfdcexc                  ; Get Bytes From EXECUTION PHASE
         LD   hl,readcomr
         CALL ddfdcres                  ; Get Result From Read Command
         POP  hl
         POP  de
         POP  bc
         POP  af
         RET  
writsect                                ; Entry HL=DATA ADDR D=TRK E=DRV C=SECT
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl                        ; Preserve Registers
         LD   a,d
         LD   (writcomd+3),a
         CALL movtrak                   ; Move To Track D
         LD   de,writcomd               ; Point To Command Data
         CALL ddfdccom                  ; Start COMMAND PHASE
         LD   hl,codebuff
         CALL ddfdcwri                  ; Write It To Disk
         LD   hl,writcomr               ; HL=Write Command Return
         CALL ddfdcres                  ; Call Up Result Phase
         POP  hl
         POP  de
         POP  bc
         POP  af                        ; Restore Registers
         RET                            ; Exit Routine
patchrw
         LD   a,c
         LD   (writcomd+5),a
         LD   (readcomd+5),a
         LD   a,b
         LD   (writcomd+7),a
         LD   (readcomd+7),a
         RET  
format                                  ; Entry:- HL=Header Info.Buff. D=Track
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl                        ; Preserve Registers
         LD   a,1
         LD   (drive),a
         LD   e,1
         CALL movtrak                   ; E=Drive
         PUSH hl                        ; Locate Drive Head To Correct Track
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
;
readid
         PUSH af                        ; Entry E=drive 0=A 1=B
         PUSH bc
         PUSH de
         LD   a,e
         LD   (Read_ID+2),a             ; Store Drive
         LD   hl,diskid
         PUSH hl
         LD   de,Read_ID
         CALL ddfdccom
         CALL ddfdcres
         POP  hl                        ; Exit Cond. HL=Disk Id, All Reg. Pres.
         POP  de
         POP  bc
         POP  af
         RET  
;
movtrak                                 ; On Entry D = Destination Track
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl                        ; Preserve Registers
         LD   a,e
         LD   (drive),a
         LD   a,d                       ; A = Track
         OR   a                         ; Is Destination Track 0
         JR   z,trak0                   ; If So Then Trak0
         CALL seek                      ; Give DDFDC SEEK Command
movtrak1                                ; Use This Since No DMA
         CALL senseint                  ; Has Drive Reached Destination ?
         LD   hl,sense
         LD   a,(hl)
         AND  3
         CP   e
         JR   nz,movtrak1
         LD   a,(hl)
         BIT  5,a
         JR   z,movtrak1                ; If Not Loop movtrak1
movtrake                                ; Quit Routine
         POP  hl
         POP  de
         POP  bc
         POP  af
         RET                            ; Preserved Registers
trak0
         PUSH de
         CALL recalib                   ; Recalibrate (Move To Track 0)
         POP  de
         JR   movtrak1
;
senseds
         LD   (drive),a
         LD   (SenseCde+2),a
         LD   de,SenseCde
         CALL ddfdccom
         LD   hl,sendst                 ; Pointer To Put Resultant Data
         CALL ddfdcres
         DEC  hl                        ; On Exit HL=Address Of Status Reg. 3
         RET                            ; Quit
;
recalib                                 ; Recalibrate
         LD   de,RECALCOM
         LD   a,(drive)
         LD   (RECALCOM+2),a
         JP   ddfdccom
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
seek                                    ; SEEK Entry D=Track
         PUSH de
         LD   a,d
         LD   (Seek_DT+3),a
         LD   a,e
         LD   (Seek_DT+2),a
         LD   de,Seek_DT
         CALL ddfdccom
         POP  de
         RET  
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
sense                                   ; Data from RESULT PHASE OF SNSE INT ST
         DEFB 0                         ; ST0
         DEFB 0                         ; Present Track Number
;
sendst   DEFB 0                         ; Status Register 3
;
formcode                                ; Format Track Data
         DEFB 6                         ; 6 Paramters
         DEFB #4d                       ; Code For Formatting
drive    DEFB 1                         ; Drive
         DEFB 2                         ; Size of Sectors 2 ^ (N+7)
         DEFB 9                         ; No. of Sector Per Track
         DEFB #2a                       ; Gap Length
         DEFB #e5                       ; Data Pattern = Filler Byte
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
SenseCde
         DEFB 2                         ; 2 Parameters
         DEFB 4                         ; Code For SENSE DRIVE STATUS
         DEFB 0                         ; Drive
;
Seek_DT                                 ; Seek Codes For Command
         DEFB 3                         ; 3 Parameters
         DEFB 15                        ; Command For Seek
         DEFB 0                         ; Drive
         DEFB 0                         ; Destination Track
;
SENSEINT DEFB 1                         ; One Parameter
         DEFB 8                         ; Command Code For SENSE INTERUPT STATE
;
Read_ID
         DEFB 2                         ; 2 Parameters
         DEFB #4a                       ; Command Number
         DEFB 0                         ; Drive
;
diskid                                  ; DISK ID Resultant Data
         DEFB 0                         ; ST0
         DEFB 0                         ; ST1
         DEFB 0                         ; ST2
         DEFB 0                         ; Track
         DEFB 0                         ; Head
         DEFB 0                         ; Sector
         DEFB 0                         ; Sector Size = 2 ^ N+7
;
RECALCOM DEFB 2                         ; 2 Parameters
         DEFB 7                         ; Command Code For RECALIBRATE
         DEFB 0                         ; Which Drive
;
writcomd                                ; Write Command Data
         DEFB 9                         ; 9 Parameters
         DEFB #45                       ; WRITE DATA Command Alter #49 Del. Dta
         DEFB 1                         ; Drive
         DEFB 0                         ; Track
         DEFB 0                         ; Head Number
         DEFB #c1                       ; Sector To Read
         DEFB 2                         ; Number Of Data Bytes Per Sector
         DEFB #c9                       ; End Of Track
         DEFB #2a                       ; Gap #3 - Generally #2a
         DEFB #ff                       ; Data Length - Sect Size < 256
;
writcomr                                ; Write Command Result Table
         DEFB 0                         ; Status Register 0
         DEFB 0                         ; Status Register 1
         DEFB 0                         ; Status Register 2
         DEFB 0                         ; Track Number
         DEFB 0                         ; Head Number
         DEFB 0                         ; Sector Number
         DEFB 0                         ; Sector Size
;
readcomd                                ; Read Command Data
         DEFB 9                         ; 9 Parameters
         DEFB #46                       ; READ DATA Command Alter To #4C Del.
         DEFB 0                         ; Drive
         DEFB 0                         ; Track
         DEFB 0                         ; Head Number
         DEFB 0                         ; Sector To Read
         DEFB 2                         ; Number Of Data Bytes Per Sector
         DEFB 0                         ; End Of Track
         DEFB #2a                       ; Gap #3 - Generally #2a
         DEFB #ff                       ; Data Length - Sect Size < 256
;
readcomr                                ; Read Command Result Table
         DEFB 0                         ; Status Register 0
         DEFB 0                         ; Status Register 1
         DEFB 0                         ; Status Register 2
         DEFB 0                         ; Track Number
         DEFB 0                         ; Head Number
         DEFB 0                         ; Sector Number
         DEFB 0                         ; Sector Size
;
XDPB                                    ; For My Own Use (Alternative XPB)
filler   DEFB #e5                       ; Filler Byte When Formatting
sect_trk DEFB 9                         ; Number Of Sectors Per Track
sectsize DEFB 2                         ; Size Of Sectors
gap3rw   DEFB #2a                       ; GAP #3 For Read/Write
gap3f    DEFB #52                       ; GAP #3 For Formatting
dataleng DEFB #ff
standard DEFB #e5,9,2,#2a,#52,#ff
badparam DEFB 0,30,0,5,5,#ff
errorf
         DEFB 0
badtrack DEFB 0
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
NODISK
         DEFB 12
         DEFM DISK MISSING IN DRIVE 
         DEFB 0
WP
         DEFB 12
         DEFM DESTINATION DISK IN DRIV
         DEFM E B: Is Write Protected. 
         DEFB 0
KEY
         DEFB 13,10,10
         DEFM Press A Key To Continue.
         DEFB 0
codebuff
         EQU  $
verifyb
         EQU  9*512+$
end
