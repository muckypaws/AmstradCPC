;
         ORG  #9000
settable
         ENT  $
         LD   hl,table
         XOR  a
         LD   b,2
sett1
         LD   (hl),a
         INC  hl
         INC  a
         JR   nz,sett1
         DEC  a
sett2
         LD   (hl),a
         INC  hl
         DEC  a
         JR   nz,sett2
         LD   hl,table
         LD   (tablea),hl
         CALL seta
         LD   hl,table+256
         LD   (tablea),hl
         CALL seta
         LD   hl,table+128
         LD   (tablea),hl
seta
         CALL settx
         CALL settx
settx
         LD   a,#ff
         LD   (maxlimit),a
sett3
         LD   a,(maxlimit)
         CP   2
         RET  c
;JR   c,sett4
         CALL randswap
         JR   sett3
sett4
         LD   a,13
         CALL #bb5a
         LD   a,10
         CALL #bb5a
sett5
         PUSH af
         LD   a,(maxlimit)
         CALL printa
         CALL getrand
         CALL printa
         LD   a,32
         CALL #bb5a
         POP  af
         DEC  a
         JR   nz,sett5
         RET  
getrand                                 ; Get A Random Number
         LD   a,(maxlimit)
         CP   2
         JR   nc,randswap
         LD   a,#ff
         LD   (maxlimit),a
         LD   a,(randoffs)
         INC  a
         LD   (randoffs),a
         LD   e,a
         LD   d,0
         LD   hl,table
         ADD  hl,de
         LD   (tablea),hl
randswap
         LD   hl,rs1
         INC  (hl)
         LD   a,r
         RRCA 
         ADD  a,0
rs1      EQU  $-1
         LD   l,a
         LD   h,0
         LD   a,(maxlimit)
         CALL divide                    ; A = Remainder Within Limit !
         LD   e,a
         LD   d,0
         LD   a,(maxlimit)
         DEC  a
         LD   (maxlimit),a
         LD   hl,(tablea)
         ADD  hl,de
         EX   de,hl
         LD   a,(maxlimit)
         LD   c,a
         LD   b,0
         LD   hl,(tablea)
         ADD  hl,bc
         LD   b,(hl)
         LD   a,(de)
         LD   (hl),a
         LD   a,b
         LD   (de),a
         RET  
printa
         PUSH af
         RRCA 
         RRCA 
         RRCA 
         RRCA 
         CALL printa1
         POP  af
printa1
         AND  15
         CP   10
         JR   c,printa2
         ADD  a,7
printa2
         ADD  a,#30
         JP   #bb5a
;
multiply                                ; Entry : E, A = Multiplicands  HL=RESU
         PUSH bc
         PUSH de
         LD   hl,0
         LD   d,l
         LD   b,8
mult1
         ADD  hl,hl
         RLA  
         JR   nc,mult2
         ADD  hl,de
mult2
         DJNZ mult1
         POP  de
         POP  bc
         RET  
;
divide                                  ; Entry : HL = Dividend, A = Divisor
         PUSH bc
         LD   c,a
         XOR  a
         LD   b,16
divide1
         ADD  hl,hl
         RLA  
         CP   c
         JR   c,divide2
         SUB  c
         INC  l
divide2
         DJNZ divide1
         POP  bc
         RET                            ; Exit HL = Result, A = Remainder
;
maxlimit DEFB 0                         ; Maximum Limit In Random Numbers
randoffs DEFB 0
;
tablea   DEFW table
table    DEFS 512,0
;
