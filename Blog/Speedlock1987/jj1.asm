
.COPYRIGHT 1985 MICRO-APPLICATION.
.DAMS.

         ORG  #a000
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
         LD   hl,#abff
         LD   de,#40
         LD   bc,#b0ff
         JP   #3a43
;
part1
         XOR  a
         LD   (#4b),a
         LD   (#4e),a
         JP   decode1
part2
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
         LD   de,#c000
         CALL #bc8c
         LD   hl,(loadaddr)
         LD   de,(loadlen)
         LD   bc,(loadexec)
         LD   a,(loadtype)
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
;
decode1
         DI   
         LD   a,2
         LD   hl,part2
         PUSH hl
         LD   hl,#40
         LD   de,#bb00
         LD   bc,#1ee
         PUSH hl
         PUSH bc
         OR   a
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
ÿ
Text:26869         End:27833             964 Bytes
Hmem:36153

.COPYRIGHT 1985 MICRO-APPLICATION.
.DAMS.

         ORG  #a000
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
         XOR  a
         LD   (#4b),a
         LD   (#4e),a
         POP  af
         JP   decode1
part2
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
         LD   de,#c000
         CALL #bc8c
         LD   hl,(loadaddr)
         LD   de,(loadlen)
         LD   bc,(loadexec)
         LD   a,(loadtype)
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
;
decode1
         LD   hl,part2
         PUSH hl
         LD   hl,#40
         LD   de,#bb00
         LD   bc,#1ee
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
ÿ
Text:#68F5         End:#6CB3           # 3BE Bytes
Hmem:#8D39
