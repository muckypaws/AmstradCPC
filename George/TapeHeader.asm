         ORG  #a000
buffer   EQU  #1000                     ; Set Buffer Address 
start
         ENT  $
;
         LD   b,0
         LD   de,buffer                 ; Load Header Block into Buffer
         CALL #bc77                     ; Open the cassette
start1
         JR   nc,error                  ; Stream in use can not continue
         CALL printi1                   ; Print Information from File
         ;  LD   hl,buffer                 ; Force the load address
         ; CALL #bc83                     ; Load the File
         ; JR   nc,error
         JP   #bc7a                     ; Close the filestream     
;
error
         LD   hl,msg5                   ; Stream Error So Quit
         JR   printmsg
;
printi1                                 ; Preserve Registers
         PUSH hl
         PUSH de
         PUSH bc
         PUSH af
; Preserve Registers we're going to use
;
         PUSH hl
         LD   hl,msg6                   ; Display File Name
         CALL printmsg                  ; normally < 16 chars
         POP  hl
         PUSH hl
         CALL printmsg                  ; Filename Printed
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
         LD   l,(ix+19)
         LD   h,(ix+20)
         CALL print16
;
         LD   hl,msg3                   ; Print Execution Address
         CALL printmsg
         LD   l,(ix+26)
         LD   h,(ix+27)
         CALL print16
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
         DEFB 13,10
         DEFB 0
msg5     DEFB 13,10
         DEFM **** Warning Str
         DEFM eam in use error ****
         DEFB 13,10,0
msg6     DEFB 13,10,13,10
         DEFM Filename:
         DEFB 0
