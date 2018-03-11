;
shiftc                                  ; Shift Coins Down
         LD   hl,coingrid+4
         LD   b,5
shiftc1
         LD   a,(hl)
         INC  hl
         LD   (hl),a
         DEC  hl
         DEC  hl
         DJNZ shiftc1
         INC  hl
shiftc2
         CALL random
         AND  7
         JR   z,shiftc2
         CP   7
         JR   z,shiftc2
         LD   b,(hl)
         CP   b
         JR   z,shiftc2
         LD   r,a
         LD   (hl),a
         RET  
coings                                  ; Set Up Coin Grid !
         LD   hl,coingrid
         LD   b,6
coings1
         PUSH bc
         CALL shiftc
         POP  bc
         DJNZ coings1
         RET  
random
         LD   a,r
         XOR  12
random1  EQU  $-1
         RRCA 
         XOR  7
         RLCA 
         XOR  l
         RRCA 
         XOR  b
         RRCA 
         RRCA 
         LD   (random1),a
         CCF  
         RET  nz
         INC  a
         RET  
winlines                                ; Get Winning Lines On Cash Falls
         LD   a,(mean)
         OR   a
         LD   b,3
         JR   z,winlna
         LD   b,1
winlna
         CALL random
         AND  1
         ADD  a,b
         AND  7
         LD   (winl3),a
         LD   hl,winlgrid
         LD   a,r
         INC  a
         LD   b,6
         LD   c,0
winln1
         LD   d,0
         RRCA 
         LD   (hl),d
         JR   nc,winl2
         DEC  d
         LD   (hl),d
         INC  c
winl2
         INC  hl
         DJNZ winln1
         LD   a,c
         CP   3
winl3    EQU  $-1
         JR   nz,winlines
wingrid                                 ; Draw Up WIN Graphics
         CALL framefly
         LD   de,#c0fc
         CALL setcs
         LD   hl,winlgrid
         LD   de,#500                   ; Start Adrress
         LD   b,6                       ; 6 Winning Lines
wingrid1
         PUSH bc
         PUSH de
         PUSH hl
         CALL bc1d
         PUSH hl
         LD   de,wing
         CALL getspad
         POP  hl
         PUSH hl
         LD   bc,#c00
         LD   a,15
         CALL decomp
         POP  de
         POP  hl
         PUSH hl
         LD   a,(hl)
         OR   a
         JR   z,wingrid2
         EX   de,hl
         LD   bc,#c0f
         LD   a,#c0
         CALL swichgwa
wingrid2
         POP  hl
         POP  de
         CALL updatecd
         POP  bc
         INC  hl
         DJNZ wingrid1
coincont                                ; Coin Control Program
         CALL framefly
         LD   hl,coingrid               ; Point To Coin Grid
         LD   de,14                     ; DE = X Y Scr Co-ords
         LD   b,6
coinc1                                  ; Coin Control 1
         PUSH de
         PUSH bc
         CALL poundc
         POP  bc
         POP  de
         CALL updatecd
         INC  hl
         DJNZ coinc1
         RET  
tenps64                                 ; Display 4 * 6 Rows Of 10 Ps
         CALL framefly
         LD   hl,potcash                ; Point To Cash Pot Flags
         LD   de,2
         LD   c,6
tenps64a
         PUSH de
         LD   b,4
tenps64b
         PUSH bc
         CALL tensc
         INC  hl
         POP  bc
         DJNZ tenps64b
         POP  de
         CALL updatecd
         DEC  c
         JR   nz,tenps64a
         RET  
poundc
         PUSH hl
         LD   a,1
coinc2   EQU  $-1
         OR   a
         JR   z,fiftyc
         LD   hl,p1l
         LD   (coi1),hl
         LD   hl,p1
         LD   (coi2),hl
         LD   a,2
         LD   (coia),a
         POP  hl
         CALL coinpnd
         JR   twentyc
fiftyc
         LD   hl,p50l
         LD   (coi1),hl
         LD   hl,p50
         LD   (coi2),hl
         LD   a,2
         LD   (coia),a
         POP  hl
         CALL coinpnd
twentyc
         PUSH hl
         LD   hl,p20l
         LD   (coi1),hl
         LD   hl,p20
         LD   (coi2),hl
         LD   a,4
         LD   (coia),a
         POP  hl
         CALL coinpnd
tensc
         PUSH hl
         LD   hl,p10l
         LD   (coi1),hl
         LD   hl,p10
         LD   (coi2),hl
         LD   a,1
         LD   (coia),a
         POP  hl
coinpnd
         PUSH de
         PUSH hl
         CALL bc1d
         POP  de
         PUSH de
         PUSH hl
         LD   a,(de)
         AND  4
coia     EQU  $-1
         LD   de,p1l
coi1     EQU  $-2
         JR   nz,coinpnd1
         LD   de,p1
coi2     EQU  $-2
coinpnd1
         CALL getspad
         POP  hl
         CALL coinprnt
         POP  hl
         POP  de
updatecn                                ; Update Coin Address
         LD   a,9
         ADD  a,e
         LD   e,a
         RET  
updatecd
         LD   a,#21
         ADD  a,d
         LD   d,a
         RET  
coinprnt                                ; Display Coin
         EX   de,hl
         LD   b,8
         LD   c,27
         JP   Generals
getspad                                 ; Get Sprite Address From Table
         LD   hl,sprload
         PUSH hl
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         POP  hl
         ADD  hl,de
         EX   de,hl
         RET                            ; Exit DE=Sprite Address
bc1d
         PUSH de
         LD   a,d
         AND  7
         ADD  a,a
         ADD  a,a
         ADD  a,a
         LD   c,a
         LD   a,d
         LD   h,0
         AND  #f8
         RRCA 
         RRCA 
         RRCA 
         LD   e,a
         ADD  a,a
         ADD  a,a
         ADD  a,e
         ADD  a,a
         LD   l,a
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         LD   a,h
         ADD  a,c
         LD   h,a
         POP  de
         PUSH de
         LD   d,0
         ADD  hl,de
         LD   a,#50                     ;#50
         ADD  a,l
         LD   l,a
         ADC  a,h
         SUB  l
         OR   #c0
         LD   h,a
         POP  de
         RET  
bitmon                                  ; Calculate Winnings From BIT Map Table
         XOR  a
         LD   (lastwin),a
         LD   de,winlgrid
         LD   hl,coingrid
         LD   b,6
bitmon1
         LD   a,(de)
         OR   a
         CALL nz,bitmon2
         INC  de
         INC  hl
         DJNZ bitmon1
         RET  
bitmon2
         LD   a,(lastwin)
         LD   c,a
         LD   a,(hl)
         BIT  0,a
         CALL nz,bitm10p
         LD   a,(hl)
         BIT  1,a
         CALL nz,bitm501p
         LD   a,(hl)
         BIT  2,a
         RET  z
         INC  c
bitm10p
         INC  c
         LD   a,c
bitm10pb
         LD   (lastwin),a
         RET  
bitm501p
         LD   a,(coinc2)
         OR   a
         LD   a,10
         JR   nz,bm501pa
         RRA  
bm501pa
         ADD  a,c
         LD   c,a
         JR   bitm10pb
;
*f,numberun.adm
