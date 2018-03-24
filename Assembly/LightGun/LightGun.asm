
;
         ORG  #a000
start
         ENT  $
         CALL lgunf
         LD   a,(lgfired)
         OR   a
         JR   z,start
         RET  
;
lgunf
;
         CALL #bd19
         DI   
         LD   B,#BC
         LD   A,#11
         OUT  (C),A
         LD   B,#BF
         IN   A,(C)
         LD   E,A
         LD   BC,#FBFE
         LD   A,#7F
         OUT  (C),A
         LD   A,#80
         OUT  (C),A
         LD   A,#80
         OUT  (C),A
         LD   B,#BF
         IN   A,(C)
         EI   
         CP   E
         LD   A,#FF
         JR   Z,R1030
         XOR  A
R1030    LD   (lgfired),A
         RET  
getlg
         LD   hl,#ffff
         LD   a,#30
         LD   (l19bb),hl
         LD   (l19ba),a
         CALL #bd19
         DI   
         LD   B,#BC
         LD   A,#0C
         OUT  (C),A
         LD   A,(l19ba)
         OR   #08
         LD   B,#BD
         OUT  (C),A
         LD   C,#FF
         LD   DE,#FEE4
RF7A     LD   B,#BC
         LD   A,#10
         OUT  (C),A
         LD   B,#BF
RF82
         IN   A,(C)
         LD   H,A
         AND  #08
         JR   NZ,RF99
         DEC  IX
         INC  E
         JR   NZ,RF82
         INC  D
         LD   A,#05
         CP   D
         JR   NZ,RF82
         INC  C
         JR   NZ,RFB4
         EI   
         RET  
RF99     LD   B,#BC
         LD   A,#11
         OUT  (C),A
         LD   B,#BF
         IN   L,(C)
         LD   IY,(l19C1)
         LD   (l19C1),HL
         LD   (l19BD),DE
         INC  C
         LD   A,#0A
         CP   C
         JR   NZ,RF7A
RFB4     DI   
         LD   B,#BC
         LD   A,#0C
         OUT  (C),A
         LD   A,(l19ba)
         AND  #F7
         LD   B,#BD
         OUT  (C),A
         LD   A,(l19B8)
         OR   A
         EI   
         LD   HL,(l19C1)
         CALL WFE0
         PUSH AF
         PUSH IY
         POP  HL
         CALL WFE0
         LD   (l19bb),A
         POP  AF
         CP   L
         RET  NC
         LD   (l19bb),A
         RET  
;
WFE0
         LD   A,H
         AND  #03
         LD   H,A
         LD   DE,#03
         SBC  HL,DE
         XOR  A
         LD   DE,(l19bf)
         SBC  HL,DE
         JR   NC,RFF6
         LD   DE,#400
         ADD  HL,DE
RFF6     LD   DE,#28
         XOR  A
RFFA     SBC  HL,DE
         JR   C,R1001
         INC  A
         JR   RFFA
R1001    ADD  HL,DE
         LD   (l19BC),A
         LD   A,L
         RET  
;
lgfired  DEFB 0
;
l19B8    DEFB 0
l19ba    DEFB 0
l19bb    DEFW 0
l19BC    DEFB 0
l19BD    DEFW 0
l19bf    DEFW 0
l19C1    DEFW 0
finish
