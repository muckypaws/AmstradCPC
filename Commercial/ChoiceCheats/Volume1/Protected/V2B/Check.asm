;
         ORG  #5000
xoring                                  ; Xor Routines
         DI   
         LD   sp,#c000
         LD   bc,#7fc0
         OUT  (c),c
         LD   hl,(#bd17)
         LD   (#30),hl
         LD   hl,xor2
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
xor2     EQU  $-1
game
         DI   
         CALL motoron
idx
         LD   de,0
         CALL movtrak
         LD   de,#2800
         CALL movtrak
         LD   b,30
         LD   de,#200
         LD   c,40
idx1
         PUSH bc
         CALL readid
         POP  bc
         DEC  c
         JR   z,tt2
         LD   b,4
         LD   hl,diskid+3
         LD   de,gg
idx2
         LD   a,(de)
         CP   (hl)
         JR   nz,idx1
         INC  hl
         INC  de
         DJNZ idx2
         LD   b,32
         LD   de,#200
idx4
         PUSH bc
         PUSH de
         CALL readid
         LD   hl,diskid+3
         POP  de
         LDI  
         LDI  
         LDI  
         LDI  
         POP  bc
         DJNZ idx4
tt
         LD   hl,gg+4
         LD   de,#200
         LD   b,29*4-1
tt1
         LD   a,(de)
         CP   (hl)
         INC  hl
         INC  de
         JR   nz,tt2
         DJNZ tt1
         JP   execute
trtrtr
         DEFW #c763
         DEFB 7
tt2                                     ; Oh Dear Piracy Again
         DI   
         LD   hl,motoron
         LD   de,motoron+1
         LD   bc,#f000
         LD   (hl),0
         LDIR 
cols
         LD   a,#40
         LD   d,31
cols1
         LD   bc,#7f00
         OUT  (c),c
         OUT  (c),a
         LD   c,16
         OUT  (c),c
         OUT  (c),a
         INC  a
         DEC  d
         JR   nz,cols1
         JR   cols
;
motoron
         DI                             ; All Reg. Preserved
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
         RET                            ; Exit All Reg. Preserved
motoroff
         LD   bc,#fa7e
         XOR  a
         OUT  (c),a
         RET                            ; Quit All Reg. Intact
readid
         PUSH af                        ; Entry E=drive 0=A 1=B
         PUSH bc
         PUSH de
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
;               **** DDFDC EXECUTION PHASE SYSTEM TO DATA ****
;
ddfdcexc                                ; DDFDC Execution Phase - DATA IN
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
         JR   nz,ddfdexc0               ; If Not Finished Loop ddfdexc
         RET                            ; Else Quit
;
;              **** DDFDC EXECUTION PHASE DATA TO SYSTEM ****
;
ddfdcwri                                ; DDFDC Write Into Data Register
         LD   bc,#fb7e                  ; Point To MAIN STATUS REG
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
         JR   nz,ddfdcw1                ; Is All Output Finished ?
         RET                            ; Quit 
;
;                       **** DDFDC RESULTS PHASE ****
;
ddfdcres                                ; DDFDC Result Phase
         IN   a,(c)
         CP   #c0                       ; Is DDFDC Ready ?
         JR   c,ddfdcres                ; If Not Wait
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
         JR   nz,ddfdcres               ; If Not Loop ddfdcres
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
gg
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
;
message
         DEFM JacelocK Protection SYSTE
         DEFM M (C) 1989 JacesofT.
         DEFM Created By Jason Brooks.
         DEFM Hi Hacker Give Me A Bel
         DEFM l On (0602) 397351 
         DEFM PRIMITIVE SYSTEM V2.89(B)
basic
         LD   hl,#40
         LD   (hl),0
         OR   a
         JP   z,#e9bd
         DEC  a
         JP   z,#ea7d
         JP   #ea78
execute                                 ; Locate Code & Run It
         DI   
         LD   sp,#bff8
         LD   bc,#7f8b
         OUT  (c),c
         LD   hl,(#bd17)
         LD   a,h
         AND  #3f
         LD   h,a
         PUSH hl
         LD   hl,code2
         LD   c,#ff
         RET  
code2
         LD   hl,coding
         LD   de,#be80
dest     EQU  $-2
         LD   bc,#100
length   EQU  $-2
         LDIR 
         LD   a,0
filetype EQU  $-1
         BIT  1,a
         JR   nz,mc
         LD   hl,#abff
         LD   de,#40
         LD   c,7
         CALL #bcce
         LD   a,#c9
         LD   (#bdee),a
         LD   bc,#170
         LD   hl,(length)
         ADD  hl,bc
         LD   c,0
         CALL #b90f
         EX   de,hl
         LD   a,(#c002)
         OR   a
         LD   hl,#ae81
         JR   z,basicl1
         LD   sp,#bff8
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
         JR   basic
;
mc
         LD   hl,execute
         LD   de,execute+1
         LD   bc,mc1-execute
         LD   (hl),0
mc1
         LDIR 
         JP   0
gameexec EQU  $-2
thisone  EQU  $-xoring
coding   EQU  $
