         ORG  #a200
buffer   EQU  #1000                     ; Set Buffer Address 
start
         ENT  $
;
         LD   a,#c9
         LD   (start),a                 ; Ensure Don't reinitialise
         LD   hl,rsxwork
         LD   bc,rsxTable
         JP   #bcd1                     ; Initialise the new command.
;
; Get File Information
;
;        |FINFO,"Filename"
fileinfo
         LD   hl,filename               ; Buffer of filename
         OR   a
         JR   z,noname
         DEC  a
         RET  nz                        ; too many parameters passed
         CALL copyfnam                  ; CopyFileName to Buffer
noname
         LD   b,a                       ; Length of filename (0 or from Copy)
         LD   de,buffer                 ; Load Header Block into Buffer
         CALL #bc77                     ; Open the cassette
start1
         JR   nc,error                  ; Stream in use can not continue
         CALL printi1                   ; Print Information from File
         JR   nc,error
         JP   #bc7a                     ; Close the filestream
;
error
         LD   hl,msg5                   ; Stream Error So Quit
         JP   printmsg
;
printi1                                 ; Preserve Registers
         PUSH hl
         PUSH de
         PUSH bc
         PUSH af
; Preserve Registers we're going to use
;
         PUSH hl
         LD   a,(hl)
         CP   31
         JR   nc,nouser
         INC  hl
nouser
         LD   bc,16
         LD   de,msg6a
         LDIR                           ; Copy 16 Bytes of Filename
         LD   hl,msg6
         CALL printmsg                  ; Filename Printed
         POP  hl
         PUSH hl
;
         LD   hl,msg4                   ; What is the Filetype?
         CALL printmsg
         POP  ix                        ; Restore HL into IX
         LD   a,(ix+18)                 ; 18 Byte Offset for Filetype
         CALL print8
;
         LD   hl,msg1                   ; Where is File to be loaded?
         CALL printmsg
         LD   l,(ix+21)
         LD   h,(ix+22)
         CALL print16
;
         LD   hl,msg2
         CALL printmsg                  ; Length of Program
         LD   l,(ix+24)
         LD   h,(ix+25)
         CALL print16
;
         LD   hl,msg3                   ; Print Execution Address
         CALL printmsg
         LD   l,(ix+26)
         LD   h,(ix+27)
         CALL print16
         LD   hl,msg7
         CALL printmsg
         POP  af
         POP  bc
         POP  de
         POP  hl
         RET  
;
print16                                 ; Print Hex Address in HL to Screen
         LD   a,h
         CALL print8
         LD   a,l
print8
         PUSH af
         AND  #f0
         RRA  
         RRA  
         RRA  
         RRA  
         CALL print8a
         POP  af
print8a
         AND  #0f
         ADD  a,#30                     ; Add an ASCII Zero 
         CP   #3A
         JR   c,print8b
         ADD  a,7
print8b
         JP   #bb5a                     ; Print The Character
printmsg
         LD   a,(hl)
         OR   a
         RET  z
         INC  hl
         CALL #bb5a
         JR   printmsg
copyfnam
         LD   l,(ix+0)
         LD   h,(ix+1)                  ; Get Address of Filename Parameter
         LD   a,(hl)                    ; Get length
         CP   16                        ; 16 or less?
         JR   c,copyf1
         LD   a,16
copyf1
         INC  hl
         LD   e,(hl)
         INC  hl
         LD   d,(hl)                    ; DE = Address of Filetext
         LD   b,0
         LD   c,a
         EX   de,hl
         LD   de,filename
         LDIR                           ; Copy Filename to buffer
         LD   hl,filename
         SCF                            ; Set Carry = Good to Go  
         RET  
;
; RSX Stuff
;
rsxwork  DEFS 4,0                       ; RSX Work Table
rsxTable
         DEFW rsxcomm
         JP   fileinfo
rsxcomm
         DEFM FINF
         DEFB "O"+#80
         DEFB 0                         ; Null Terminated
filename DEFS 16,32
         DEFB 0,0                       ; Filler Not Needed
;
msg1     DEFB 13,10,32
         DEFM Start: 
         DEFB 0
msg2     DEFB 13,10
         DEFM Length: 
         DEFB 0
msg3     DEFB 13,10,32,32
         DEFM Exec: 
         DEFB 0
msg4     DEFB 13,10,32,32
         DEFM Type: 
         DEFB 0
msg5     DEFB 13,10
         DEFM **** Warning Str
         DEFM eam in use error ****
         DEFB 13,10,0
msg6     DEFB 13,10,13,10
         DEFM Filename:
         DEFB 32
msg6a
         DEFS 17,0
msg7     DEFB 13,10,0
