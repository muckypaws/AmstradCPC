;
cashfall                                ; Cashfalls Gaming Function
         CALL cashfals
         CALL coings
         CALL winlines
cashfal2
         CALL boing1
         CALL shiftc
         CALL coincont
         LD   a,200
time     EQU  $-1
         CALL cashfal4
         CALL framefly
         LD   hl,count
         DEC  (hl)
         JR   nz,cashfal2
         LD   (hl),15
         LD   hl,time
         DEC  (hl)
         JR   nz,cashfal2
         PUSH bc
cashfal5
         POP  de
cashfal8
         CALL bitmon
cf1jb
         CALL dpause
         CALL dpause
         CALL game0
         LD   hl,nowin
         CALL setupms
         LD   a,(lastwin)
         OR   a
         JR   nz,cf1fbc
         LD   a,80
         CALL scrmess
         CALL dspace
cf1fbc
         CALL incmoney
         CALL gameff
cf1fba
         JP   takeit1
cashfals
         LD   a,(mean)
         XOR  255
         LD   (coinc2),a
         LD   a,15
         LD   (count),a
         LD   a,29
         LD   (time),a
         LD   hl,#c050
         LD   bc,#28c8
         SUB  a
         JP   wipeout
cashfal4
         DEC  a
         RET  z
         EX   af,af
         LD   a,18
         CALL scankey
         JR   z,cashfal5
         CALL framefly
         EX   af,af
         JR   cashfal4
;
*f,coincont.adm
