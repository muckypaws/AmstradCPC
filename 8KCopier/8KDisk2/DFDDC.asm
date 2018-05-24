;
         ORG  #a000                     ; Alternative DDFDC Commands
         ENT  $                         ; Version 9.89
JacelocK                                ; JacelocK Protection System V2.89 (B)
         CALL motoron
         LD   de,0
         CALL movtrak
         CALL formatd
         CALL motoroff
         RET  
;
;
;
;
formatd                                 ; Format A Disk To DATA Format !
         LD   a,9
         LD   hl,data
         JR   formatt
formatv                                 ; Format A Disk To CPM Format !
         LD   a,9
         LD   hl,vendor
         JR   formatt
formati                                 ; Format A Disk To IBM Standard Format 
         LD   a,8
         LD   hl,IBM
formatt
         LD   (standard+1),a
         LD   de,fo
         LD   bc,9*4
         LDIR 
         LD   ix,#c000
         LD   a,(drive)
         LD   e,0
         LD   d,0
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
         LD   hl,fo
         LD   a,(drive)
         LD   e,a
         CALL format
         LD   (ix+0),%00111100
         INC  ix
         POP  de
         POP  bc
         INC  d
         DJNZ formatt1
bad                                     ; Create The Protected Format On Track 
         LD   hl,badparam               ; Point HL To Bad Parameters
         LD   de,XDPB
         LD   bc,6
         LDIR                           ; Copy Protection Parameters Into XDPB
         LD   a,(drive)
         LD   e,a
         LD   d,40
         CALL movtrak
         LD   hl,badform
         LD   a,(drive)
         LD   e,a
         LD   d,40
         CALL format
         LD   a,(drive)
         LD   e,a
         LD   d,0
         CALL movtrak                   ; Retract Drive Head To 0 Position
         LD   hl,message
         LD   d,40
         LD   a,(drive)
         LD   e,a
         LD   c,0
         CALL wdeldata
         RET  
;
initform                                ; Initialize Formatting Data
         PUSH bc
         LD   hl,fo+1
initf1
         LD   (hl),0
         INC  hl
         LD   (hl),a
         INC  hl
         LD   (hl),2
         INC  hl
         INC  hl
         INC  a
         DJNZ initf1
         LD   hl,standard
         LD   de,XDPB
         LD   bc,6
         LDIR 
         POP  bc
         LD   a,b
         LD   (sect_trk),a
         RET  
init
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
         POP  bc
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
;
rdelsect                                ; Read Deleted Sector
         LD   a,#4c                     ; Command Code For READ DELETED DATA
         LD   (readcomd+1),a            ; Store It
         CALL readsect                  ; Read In Sector
         LD   a,#46                     ; Command Code For READ DATA
         LD   (readcomd+1),a            ; Restore Command Code
         RET                            ; Exit 
readsect                                ; ENTRY HL=BUFFER E=DRIVE D=TRK C=SECTR
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl                        ; Preserve Registers
         CALL movtrak                   ; Move To Approprite Track
         PUSH hl
         LD   hl,readcomd+2
         CALL patchrwd                  ; Patch Read Data
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
wdeldata                                ; Write Deleted Data
         PUSH af                        ; Preserve AF
         LD   a,%1001001                ; Comand For WRITE DELETED DATA
         LD   (writcomd+1),a            ; Store Command In Data String
         CALL writsect                  ; Call Up Normal WRITE SECTOR
         LD   a,%1000101                ; Command For WRITE DATA
         LD   (writcomd+1),a            ; Restore Command In Data String
         POP  AF                        ; Restore AF
         RET                            ; Quit 
;
;                     **** WRITE DATA To TRACK & SECTOR ****
;
writsect                                ; Entry HL=DATA ADDR D=TRK E=DRV C=SECT
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl                        ; Preserve Registers
         CALL movtrak                   ; Move To Track D
         PUSH hl
         LD   hl,writcomd+2             ; Point To Command DATA Table
         CALL patchrwd                  ; Patch Write Data For TRACK & SECTOR
         LD   de,writcomd               ; Point To Command Data
         CALL ddfdccom                  ; Start COMMAND PHASE
         POP  hl                        ; Restore HL = DATA To Write
         CALL ddfdcwri                  ; Write It To Disk
         LD   hl,writcomr               ; HL=Write Command Return
         CALL ddfdcres                  ; Call Up Result Phase
         POP  hl
         POP  de
         POP  bc
         POP  af                        ; Restore Registers
         RET                            ; Exit Routine
;
;             **** PATCH READ WRITE DATA FOR READ/WRITE COMMAND ****
;
patchrwd                                ; Patch Read Write Data
         PUSH hl
         PUSH af
         LD   a,e                       ; A=Drive
         LD   (hl),a
         INC  hl
         INC  hl                        ; Point HL To Head Number
         LD   (hl),a                    ; Store Head Number
         DEC  hl                        ; Point To Track Data
         LD   a,d                       ; A = Track
         LD   (hl),a                    ; Store Track Number
         INC  hl
         INC  hl                        ; Point To Sector
         LD   a,c                       ; A = Sector
         LD   (hl),a                    ; Store It
         INC  hl
         INC  hl                        ; Point To End Of Track
         LD   (hl),a                    ; Store Sector
         DEC  hl                        ; Point To Sector Size
         LD   a,(sectsize)              ; Get Sector Size From XDPB
         LD   (hl),a                    ; Store It
         INC  hl
         INC  hl                        ; Point To Gap Length
         LD   a,(gap3rw)                ; A = Gap #3 For READ/WRITE
         LD   (hl),a                    ; Store It
         INC  hl                        ; Point To Data Length
         LD   a,(dataleng)              ; A=Sector Length
         LD   (hl),a                    ; Store It
         POP  af
         POP  hl
         RET  
;
;                        **** Format A Track Of Data ****
;
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
;
;                         **** Read Sector ID ****
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
;                        **** Move Drive Head To Track T ****
;
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
badparam DEFB 0,22,0,1,5,#ff
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
;
;                  **** COMMAND DATA FOR READ ID ****
;
Read_ID
         DEFB 2                         ; 2 Parameters
         DEFB #4a                       ; Command Number
         DEFB 0                         ; Drive
;
;                 **** RESULTANT DATA FROM READ ID ****
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
;                 **** COMMAND DATA FOR RECALIBRATE ****
;
RECALCOM DEFB 2                         ; 2 Parameters
         DEFB 7                         ; Command Code For RECALIBRATE
         DEFB 0                         ; Which Drive
;
;             **** COMMAND CODE FOR DDFDC WRITE SECTOR ****
;
writcomd                                ; Write Command Data
         DEFB 9                         ; 9 Parameters
         DEFB #45                       ; WRITE DATA Command Alter #49 Del. Dta
         DEFB 0                         ; Drive
         DEFB 0                         ; Track
         DEFB 0                         ; Head Number
         DEFB 0                         ; Sector To Read
         DEFB 0                         ; Number Of Data Bytes Per Sector
         DEFB 0                         ; End Of Track
         DEFB 0                         ; Gap #3 - Generally #2a
         DEFB #ff                       ; Data Length - Sect Size < 256
;
;         **** WRITE DATA RESULTANT BYTES FROM RESULT PHASE ****
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
;                 **** COMMAND DATA FOR READ SECTOR ****
;
readcomd                                ; Read Command Data
         DEFB 9                         ; 9 Parameters
         DEFB #46                       ; READ DATA Command Alter To #4C Del.
         DEFB 0                         ; Drive
         DEFB 0                         ; Track
         DEFB 0                         ; Head Number
         DEFB 0                         ; Sector To Read
         DEFB 0                         ; Number Of Data Bytes Per Sector
         DEFB 0                         ; End Of Track
         DEFB 0                         ; Gap #3 - Generally #2a
         DEFB #ff                       ; Data Length - Sect Size < 256
;
;        **** READ DATA RESULTANT BYTES FROM RESULT PHASE ****
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
;             **** Header Buffer For Formatting A Disk ****
;
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
         DEFB 0,0,0,6
         DEFB 1,1,1,5
         DEFB 2,2,2,6
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
         DEFM T   
         DEFB 40,0,0,0
message                                 ; Personal Messages To Would Be Hackers
;        **** Can Not Exceed 128 Bytes ****
         DEFM Mary Had A Little Lamb Sh
         DEFM e Took It To A Brothel ! 
         DEFM ... I Could Go Further Bu
         DEFM t That Could Be Jolly Cru
         DEFM de. Author Jason Brooks. 
         DEFM Company : JacesofT - TM.
         DEFM All Rights Reserved.
