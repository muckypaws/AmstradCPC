;
hilocash                                ; Hi Lo Cash Gaming Function
         CALL cashfals
         CALL resetwl
hilocsh1
         CALL hilocont
         JR   nc,losthlc
         OR   a
         JR   z,hilocsh1
         CALL updatewl
         JR   nz,hilocsh1
losthlc
         LD   a,6
         LD   (functcnt),a
         SUB  a
         LD   (coinflsh),a
         JP   cashfal8
flshcoin                                ; Flash Current Coin Win Line
         LD   hl,count1
         INC  (hl)
         LD   a,(hl)
         SUB  20
         RET  c
         LD   (hl),a
         LD   hl,coingrid+5
coinsw1  EQU  $-2
         LD   a,(hl)
         LD   b,0
coinswap EQU  $-1
         LD   (coinswap),a
         LD   (hl),b
         JP   coincont
swapcn1
         LD   hl,(coinsw1)
         DEC  hl
         LD   (coinsw1),hl
         LD   a,(coinswap)
         OR   a
         RET  z
         INC  hl
         LD   (hl),a
         RET  
;
updatewl
         CALL swapcn1
         XOR  a
         LD   (coinswap),a
         DEC  a
         LD   hl,winlgrid+5
hilocsh2 EQU  $-2
         DEC  hl
         LD   (hl),a
         LD   (hilocsh2),hl
         PUSH hl
         CALL wingrid
         POP  hl
         LD   de,winlgrid
         AND  a
         SBC  hl,de
         RET  
resetwl
         LD   hl,winlgrid
         LD   b,6
         XOR  a
hilolp
         LD   (hl),a
         INC  hl
         DJNZ hilolp
         LD   (functcnt),a
         LD   (mean),a
         LD   (coinswap),a
         DEC  a
         LD   (suppress),a
         LD   (coinflsh),a
         LD   (hilocsh2),hl
         LD   hl,coingrid+5
         LD   (coinsw1),hl
         CALL coings
         JP   wingrid
;
*f,cashpot.adm
