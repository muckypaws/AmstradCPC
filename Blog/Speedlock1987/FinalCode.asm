;
; Reference Sample code for Speedlock 1987 Dizzy Hack Tutorial
; Created by Jason Brooks January 2024
;
; This is not optimised code, useful as a teaching aid.
; It's down to you new hacker to find the shortcuts and improve the code
;
; For example, you don't need the RSX code... |TAPE.IN |DISC.OUT
; 	  could be useful?
; The initial loader can be created in BASIC, saving bytes... etc.
; Think about how you utilise what you learn on other games with the
; same protection system? Or larger code base.
; See my blog www.muckypaws.com
;

         ORG  #a100
patch    EQU  #3a76
start
         ENT  $
         POP  hl
         LD   (adam),hl
         CALL #bd37
         LD   bc,#7fc0
         OUT  (c),c
         LD   hl,rsxtape
         CALL rsxset
         LD   b,0
         LD   de,#1000
         CALL load
;        Let's Hack!
hackstrt
         LD   a,#c3
         LD   hl,part1
         LD   (patch),a
         LD   (patch+1),hl
         LD   hl,#40
         PUSH hl
         LD   hl,#bb00
         PUSH hl
         JP   #3a4b
;
part1
         DI   
         LD   a,part2/256!#FB
         LD   (#4b),a
         LD   a,part2&255!#99
         LD   (#4e),a
         POP  af
         JP   decode1
part2
         LD   ix,#bf00
         LD   de,#47
         CALL #bc4e                     ; Load the Final Load Code
         LD   hl,part3
         LD   (#bf44),hl                ; Patch in our Save Code
         JP   #bf00
part3
         LD   hl,rsxdisc
         CALL rsxset
         LD   hl,fname1
         LD   ix,#c000
         LD   bc,0
         LD   de,#4000
         LD   a,fname1l                 ; Length
         CALL save
         LD   hl,fname2
         LD   ix,#40
         LD   de,#3862+#64ae
         LD   bc,#73b1
         LD   a,fname2l
         CALL save
adamide                                 ; Return to the IDE
         DI   
         PUSH bc
         LD   bc,#7fc4
         OUT  (c),c
         POP  bc
         JP   0
adam     EQU  $-2
;
load
         CALL #bc77
         LD   (loadlen),bc
         LD   (loadaddr),de
         LD   (loadhead),hl
         LD   (loadtype),a
         PUSH ix
         PUSH hl
         PUSH hl
         POP  ix
         LD   l,(ix+26)
         LD   h,(ix+27)
         LD   (loadexec),hl
         POP  hl
         POP  ix
         EX   de,hl
         CALL #bc83
         JP   #bc7a
;
;        HL = Filename
;         B = Length
save
         PUSH bc
         PUSH de
         PUSH ix
         LD   b,a
         LD   de,#c000
         CALL #bc8c
         POP  hl
         POP  de
         POP  bc
         LD   a,2                       ; Binary Files
         CALL #bc98
         JP   #bc8f                     ; Close the file
;
rsxset
         CALL #bcd4
         RET  nc
         LD   (farcall),hl
         LD   a,c
         LD   (farcall+2),a
         XOR  a
         RST  #18
         DEFW farcall
         RET  
loadaddr DEFW 0
loadlen  DEFW 0
loadhead DEFW 0
loadexec DEFW 0
loadtype DEFB 0
farcall
         DEFS 3,0
rsxtape  DEFM TAP
         DEFB "E"+#80
rsxdisc  DEFM DIS
         DEFB "C"+#80
fname1   DEFM DIZZY1.BIN
fname1l  EQU  $-fname1
fname2   DEFM DIZZY2.BIN
fname2l  EQU  $-fname2
;
decode1
         DI   
         LD   hl,#bb00
         PUSH hl
         LD   hl,#40
         LD   bc,#1ee
         LD   de,#bb00
         PUSH hl
         PUSH bc
;
         RRA  
         LD   R,A
         POP  BC
         POP  HL
         NOP  
         NOP  
         NOP  
         LD   A,I
         CALL PO,#AC00
         LD   A,R
         XOR  (HL)
         LD   (HL),A
         LDI  
         RET  PO
         DEC  SP
         DEC  SP
         RET  PE
;
