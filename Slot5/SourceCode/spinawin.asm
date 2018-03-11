;
spinawin                                ; Spin A Win Gaming Function
         LD   a,#ff
         LD   (winner),a
         LD   (gamblet),a
         INC  a
         LD   (getret+1),a
         CALL gamec
         LD   hl,spinawm
         CALL setupms
         LD   a,80
         CALL scrmess
         CALL dspace
spinwg1
         LD   a,r
         AND  3
         INC  a
         CP   4
         JR   z,spinwg1
         LD   (spinwc),a
         LD   a,0
spinwc   EQU  $-1
spinw1
         CALL getret
         CALL resetgc
         CALL getwin
         CALL gamble
         CALL incmoney
         CALL cleartf
         CALL checkmon
         RET  z
         LD   hl,spinwc
         DEC  (hl)
         JR   nz,spinw1
spinw2
         JP   takeit1
;
*f,skilcash.adm
