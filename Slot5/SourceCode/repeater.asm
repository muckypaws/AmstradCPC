;
repeater                                ; Mystery Gaming Function
         LD   hl,rept1
         CALL setupms
         XOR  a
         CALL gamec
         LD   a,47
         CALL scrmess
         CALL dspace
         LD   a,#ff
         CALL gamec
;LD   hl,#e690+#50
;LD   bc,#281c
;XOR  a
;CALL wipeout
         CALL repeat
         LD   a,48
         JR   c,bigm1
         RRCA 
bigm1
         LD   (lastwin),a
         CALL game0
         CALL incmoney
         JP   takeit1
;
*f,sound.adm
