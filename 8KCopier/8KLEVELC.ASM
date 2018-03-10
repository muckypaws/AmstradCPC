;
         ORG  #9000                     ; Alternative DDFDC Commands
         ENT  $                         ; Version 9.89
datafull                                ; Disk Formats On Destination Drive
         LD   a,#c1
         JR   full42
vendfull
         LD   a,#41
full42                                  ; Full Format
         LD   (ftype),a
         CALL motoron
         LD   d,0
         LD   b,41
full42a
         PUSH de
         PUSH bc
         LD   d,b
         LD   a,#c1
ftype    EQU  $-1
         CALL form
         POP  bc
         POP  de
         RET  c
         DEC  b
         BIT  7,b
         JR   z,full42a
         JP   motoroff
copy                                    ; Start ID Copy From Track 9
         CALL copy1
         LD   hl,again
         CALL print
yn
         LD   a,43
         CALL #bb1e
         JR   nz,copy
         LD   a,46
         CALL #bb1e
         JR   z,yn
         RST  0
copy1
         LD   hl,copp1
         LD   de,coppp
         LD   bc,10
         LDIR 
         LD   a,(dest)
         ADD  a,"A"
         LD   (insertd1),a
         CALL search
         LD   a,7
         LD   (trackcnt),a
         CALL cheek
         CALL nz,ind
         LD   ix,scanblck
loop
         CALL readin
         JP   c,motoroff
         PUSH ix
         CALL writein
         JP   c,motoroff
         POP  ix
         LD   a,(trackcnt)
         CP   trackend
         JP   z,motoroff
         JR   loop
readin                                  ; Read-In Sector
         CALL cheek
         CALL z,ins
readina
         LD   iy,trkwrite
         LD   hl,#40
         LD   (memlock),hl
readin1                                 ; Only Enter Here After Scan !!!
         LD   a,(ix+0)
         OR   a
         RET  z
         BIT  7,a
         JR   nz,readinq
         LD   (iy+0),a                  ; Store Track Read
         INC  iy
         LD   d,a
         LD   e,0
         LD   hl,(memlock)
         LD   b,9
         LD   c,#41
loop1
         LD   d,(ix+0)
         CALL readsect
         RET  c
         INC  c
         LD   de,#200
         ADD  hl,de
         DJNZ loop1
         LD   (memlock),hl
readinq                                 ; Update Counter And Check End
         INC  ix
         LD   (iy+0),0
         LD   a,(trackcnt)
         INC  a
         LD   (trackcnt),a
         CP   trackend
         RET  z
         LD   a,h
         CP   #90
         RET  z
         JR   readin1
cheek
         LD   a,(source)
         LD   b,a
         LD   a,(dest)
         CP   b
         RET  
writein                                 ; Writeout A Track
         CALL cheek
         CALL z,ind
         LD   ix,trkwrite
         LD   hl,#40
         LD   (memlock),hl
writein1
         LD   a,(ix+0)
         OR   a
         RET  z
         LD   d,a
         LD   a,#41
         CALL form
         RET  c
         LD   hl,(memlock)
         LD   c,#41
         LD   b,9
writein2
         LD   d,(ix+0)
         CALL writsect
         RET  c
         INC  c
         LD   de,#200
         ADD  hl,de
         DJNZ writein2
         LD   (memlock),hl
         INC  ix
         JR   writein1
search                                  ; Find Standard Sectors
         CALL ins
         LD   hl,scanning
         CALL print
         CALL motoron
         LD   ix,scanblck
         LD   b,41-6
         LD   d,7
search1
         PUSH bc
         PUSH de
         LD   e,0
         CALL movtrak
         JR   c,end
         CALL pause
         LD   a,(source)
         LD   e,a
         CALL readid
         LD   a,(diskid+6)
         CP   2
         POP  de
         POP  bc
         LD   (ix+0),d
         JR   z,search2
         LD   (ix+0),#ff
search2
         INC  ix
         INC  d
         DJNZ search1
         LD   de,0
         JP   movtrak
end
         POP  de
         POP  bc
         SCF  
         RET  
pause
         LD   b,15
pause1
         CALL #bd19
         DJNZ pause1
         DI   
         RET  
ins
         LD   hl,inserts
         CALL print
         JR   space
ind
         LD   hl,insertd
         CALL print
space
         LD   a,47
         CALL #bb1e
         JR   z,space
space1
         LD   a,47
         CALL #bb1e
         JR   nz,space1
         RET  
form                                    ; Formatter
         PUSH de                        ; D=Track E=Drive
         BIT  7,a                       ; Enter A=#C1 or A=#41 For Format
         LD   hl,data
         JR   nz,form1
         LD   hl,vendor
form1
         LD   de,fo
         LD   bc,4*9
         LDIR 
         POP  de
         LD   a,e
         LD   (drive),a
         LD   hl,fo
         CALL settrk
         JP   format
settrk                                  ; Entry D = Track
         PUSH hl
         PUSH bc
         CALL printtrk
         LD   b,9
settrk1
         LD   (hl),d
         INC  hl
         INC  hl
         INC  hl
         INC  hl
         DJNZ settrk1
         POP  bc
         POP  hl
         RET                            ; Exit All Reg. Intact.
printtrk
         PUSH hl
         LD   a,d
         LD   hl,track
decimal
         LD   c,10
         CALL dec2
         LD   (ft),a
         LD   a,c
         LD   c,1
         CALL dec2
         LD   (ft+1),a
         CALL print
         POP  hl
         RET  
dec2
         LD   b,0
dec1
         SUB  c
         INC  b
         JR   nc,dec1
         ADD  a,c
         DEC  b
         LD   c,a
         LD   a,#30
         ADD  a,b
         RET  
wend                                    ; Is Disk Write Protected ?
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
wend1
         DI   
         CALL senseds
         AND  a
         BIT  6,(hl)
         JR   z,wend2
         LD   a,(drive)
         ADD  a,"A"
         LD   (wp),a
         LD   hl,wprotmes
         CALL print
         CALL return
         DI   
         JR   nc,wend1
         POP  hl
         POP  de
         POP  bc
         POP  af
         SCF  
         RET  
wend2
         POP  hl
         POP  de
         POP  bc
         POP  af
         OR   a
         RET  
isdrive                                 ; Is Disk In Drive Present ?
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         LD   (drive),a                 ; Entry A = Drive To Test.
isdrivea
         DI   
         CALL senseds                   ; Sense Drive Status !
         AND  a
         BIT  5,(hl)
         JR   nz,isd1
         LD   a,(drive)
         ADD  a,"A"
         LD   (notp),a
         LD   hl,message
         CALL print
         CALL return
         DI   
         JR   nc,isdrivea
         POP  hl
         POP  de
         POP  bc
         POP  af
         SCF  
         RET  
isd1
         DI   
         POP  hl
         POP  de
         POP  bc
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
print
         LD   a,(hl)
         OR   a
         DI   
         RET  z
         INC  hl
         CALL #bb5a
         JR   print
return                                  ; Is Return / Escape Pressed
         LD   a,18
         CALL #bb1e
         RET  nz
         LD   a,6
         CALL #bb1e
         RET  nz
         LD   a,66
         CALL #bb1e
         SCF  
         RET  nz
         JR   return
readsect                                ; ENTRY HL=BUFFER E=DRIVE D=TRK C=SECTR
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl                        ; Preserve Registers
         LD   a,(source)
         LD   e,a
         CALL isdrive
         JR   c,ner
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
ner
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
         LD   a,(dest)
         LD   e,a
         CALL movtrak                   ; Move To Track D
         CALL wend
         JR   c,wendwrit
         PUSH hl
         LD   hl,writcomd+2             ; Point To Command DATA Table
         CALL patchrwd                  ; Patch Write Data For TRACK & SECTOR
         LD   de,writcomd               ; Point To Command Data
         CALL ddfdccom                  ; Start COMMAND PHASE
         POP  hl                        ; Restore HL = DATA To Write
         CALL ddfdcwri                  ; Write It To Disk
         LD   hl,writcomr               ; HL=Write Command Return
         CALL ddfdcres                  ; Call Up Result Phase
wendwrit
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
;LD   (hl),a                    ; Store
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
format                                  ; Entry:- HL=Header Info.Buff. D=Track
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl                        ; Preserve Registers
         AND  a
         LD   a,(dest)
         LD   e,a
         LD   (drive),a                 ; Which Drive
         CALL isdrive
         JR   c,ne
         CALL wend
         JR   c,ne
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
ne
         POP  hl
         POP  de
         POP  bc
         POP  af
         SCF  
         RET  
;
readid
         PUSH af                        ; Entry E=drive 0=A 1=B
         PUSH bc
         PUSH de
         LD   a,e
         LD   (Read_ID+2),a             ; Store Drive
         CALL isdrive
         JR   c,readidd
         LD   hl,diskid
         PUSH hl
         LD   de,Read_ID
         CALL ddfdccom
         CALL ddfdcres
readidd
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
         CALL isdrive
         JR   c,ne
         LD   a,d                       ; A = Track
         OR   a                         ; Is Destination Track 0
         JR   z,trak0                   ; If So Then Trak0
         CALL seek                      ; Give DDFDC SEEK Command
movtrak1                                ; Use This Since No DMA
         CALL senseint                  ; Has Drive Reached Destination ?
         LD   a,(drive)
         LD   e,a
         LD   hl,sense
         LD   a,(hl)
         AND  3
         CP   e
         JR   nz,movtrak1
         BIT  5,(hl)
         JR   z,movtrak1
movtrake                                ; Quit Routine
         POP  hl
         POP  de
         POP  bc
         POP  af
         RET                            ; Preserved Registers
trak0
trak0a
         PUSH de
         CALL recalib                   ; Recalibrate (Move To Track 0)
         POP  de
         JR   movtrak1
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
         LD   (Seek_DT+3),a
         LD   a,(drive)
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
drive    DEFB 0                         ; Drive
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
XDPB
filler   DEFB #e5                       ; Filler Byte When Formatting
sect_trk DEFB 9                         ; Number Of Sectors Per Track
sectsize DEFB 2                         ; Size Of Sectors
gap3rw   DEFB #2a                       ; GAP #3 For Read/Write
gap3f    DEFB #52                       ; GAP #3 For Formatting
dataleng DEFB #ff
standard DEFB #e5,9,2,#2a,#52,#ff
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
         DEFB 0                         ; Drive
         DEFB 0                         ; Track
         DEFB 0                         ; Head Number
         DEFB 0                         ; Sector To Read
         DEFB 0                         ; Number Of Data Bytes Per Sector
         DEFB 0                         ; End Of Track
         DEFB 0                         ; Gap #3 - Generally #2a
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
         DEFB 0                         ; Number Of Data Bytes Per Sector
         DEFB 0                         ; End Of Track
         DEFB 0                         ; Gap #3 - Generally #2a
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
source   DEFB 0                         ; Source Drive
dest     DEFB 0                         ; Destination Drive
;
again    DEFB 12,13,10
         DEFM Do You Wish To Make Anoth
         DEFM er Copy ? Y/N
         DEFB 13,10,10,0
message  DEFB 13,10
         DEFM Disk In Drive 
notp     DEFB "A"
         DEFM : Is Missing.
         DEFB 13,10,10
         DEFM RETURN - Try Again 
         DEFM ESCAPE - To Quit.
         DEFB 13,10
         DEFB 0
wprotmes
         DEFB 13,10
         DEFM Disk In Drive 
wp       DEFB "A"
         DEFM : Is Write Protected.
         DEFB 13,10,10
         DEFM RETURN - Try Again 
         DEFM ESCAPE - To Quit.
         DEFB 13,10
         DEFB 0
track
         DEFB 13,10
coppp
         DEFM Formatting Track : 
ft       DEFM 00
         DEFB 13,11,0
copp1
         DEFM Creating  
inserts                                 ; Insert Source Disk
         DEFB 13,10,10
         DEFM Insert Speedlock Source D
         DEFM isk In Drive A: 
         DEFM Press Space.
         DEFB 13,0
insertd
         DEFB 13,10,10
         DEFM Insert Destination Disk 
         DEFM In Drive 
insertd1 EQU  $
         DEFB "A"
         DEFM :  Press Space.
         DEFB 13,0
scanning DEFB 13,10,10
         DEFM Scanning Source Disk.....
         DEFB 13,10,0
copycnt  DEFB 0                         ; Copy Counter
trackcnt DEFB 0                         ; Track Counter
scanblck                                ; Scan Block
         DEFS 42,0
trackend EQU  42
memlock  DEFW #40
trkwrite DEFS 10,0                      ; What Tracks Have I Written To ?
