;
         ORG  #100                      ; Fast Text Routines For Mode 2 Screens
start                                   ; Start Of Program, Initialize Data
         ENT  $
         CALL scrsetup                  ; Set Up Screen Look Up Table
         CALL textset                   ; Set Up ASCII Characters
         LD   hl,0
         CALL prlocate
         LD   hl,message
         CALL print
         RET  
print
         LD   a,(hl)
         OR   a
         RET  z
         INC  hl
         CALL printchr
         JR   print
prlocate                                ; Locate Command
         LD   (currenty),hl
         PUSH de
         PUSH hl
         LD   a,l
         RLCA 
         LD   l,a
         LD   h,0
         LD   de,scrdest
         ADD  hl,de
         LD   e,(hl)
         INC  hl
         LD   d,(hl)
         POP  hl
         LD   l,h
         LD   h,0
         ADD  hl,de
         POP  de
         LD   (screenxy),hl
         RET  
printchr                                ; Print Character At Current Cursor
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl
         CP   32
         JP   c,controlc                ; If < 32 Then Control Codes Branch
         SUB  32
         LD   l,a
         LD   h,0
         ADD  hl,hl
         ADD  hl,hl
         ADD  hl,hl
         LD   de,charactr
         ADD  hl,de                     ; Calculate 
         EX   de,hl                     ; DE=Part Of Char Matrix To Copy
         LD   hl,(screenxy)             ; HL=Screen Address
         PUSH hl
         LD   b,8
         LD   a,(inverse)
         LD   c,a
printch1
         LD   a,(de)
         XOR  c
         LD   (hl),a
         LD   a,h
         ADD  a,8
         LD   h,a
         JR   nc,printch2
         PUSH bc
         LD   bc,#c050
         ADD  hl,bc
         POP  bc
printch2
         INC  de
         DJNZ printch1
         POP  hl
printch4
         INC  hl
         LD   (screenxy),hl
         LD   hl,currentx
         LD   a,(hl)
         INC  a
         CP   80
         LD   (hl),a
         JR   nz,printchx
         LD   (hl),0
         DEC  hl
         LD   a,(hl)
         INC  a
         CP   25
         LD   (hl),a
         JR   nz,printch3
         LD   (hl),0
printch3
         LD   hl,(currenty)
preturn1
         CALL prlocate
         LD   (screenxy),hl
printchx
         POP  hl
         POP  de
         POP  bc
         POP  af
         RET                            ; Return All Registers INTACT
preturn
         LD   h,0
pdownlne
         INC  l
         LD   a,l
         JR   nz,preturn1
         LD   l,0
         JR   preturn1
pforward                                ; Move Cursor Along One
         LD   hl,(screenxy)             ; Routine Already In Print !
         JR   printch4
pbackspc                                ; Print Back Space
         DEC  h
         LD   a,h
         CP   #ff
         JR   nz,preturn1
         LD   h,79
pupline
         DEC  l
         LD   a,l
         CP   #ff
         JR   nz,preturn1
         LD   l,24
         JR   preturn1
clearscr
         PUSH hl
         LD   a,(inverse)
         LD   hl,#c000
         LD   de,#c001
         LD   bc,#3fff
         LD   (hl),a
         LDIR 
         POP  hl
         JR   preturn1
pinvert
         LD   a,(inverse)
         CPL  
         LD   (inverse),a
         JR   preturn1
controlc
         LD   hl,(currenty)
         SUB  8
         JR   c,preturn1                ; Anything below CHR$(8) rejected
         JR   z,pbackspc                ; CHR$(8)
         DEC  a                         ; CHR$(9) ?
         JR   z,pforward
         DEC  a                         ; CHR$(10) ?
         JR   z,pdownlne
         DEC  a                         ; CHR$(11) ?
         JR   z,pupline
         DEC  a                         ; CHR$(12) ?
         JR   z,clearscr
         DEC  a                         ; CHR$(13) ?
         JR   z,preturn
         CP   11
         JR   z,pinvert
         JR   preturn1
textset                                 ; Initialize Amsdos Character Set
         LD   de,256
         LD   hl,charactr
         CALL #bbab
         LD   de,32
         LD   hl,charactr
         JP   #bbab
scrsetup
         LD   ix,scrdest
         LD   hl,#c000
         LD   de,#50
         LD   b,25
scrstup1
         LD   (ix+0),l
         LD   (ix+1),h
         INC  ix
         INC  ix
scrstup2
         ADD  hl,de
         DJNZ scrstup1
         RET  
message
         DEFB 12
         DEFM This is merely A Test to 
         DEFM see if this routine 
         DEFM works.
         DEFB 13
         DEFM And Apparently It Does !
         DEFB 10,10,10
         DEFM "Hello"
         DEFB 11
         DEFM "It Works"
         DEFB 8,8,8,8,8
         DEFM "jason"
         DEFB 13,13,13,13,13
         DEFB 24
         DEFM Well Done You've Done It 
         DEFB "!",24
         DEFB 0
currenty DEFB 0
currentx DEFB 0
screenxy DEFW #c000                     ; Initial Screen Address To Print
inverse  DEFB 0                         ; Inverse On If #FF Off If 0
scrdest  DEFS 50,0                      ; Reserve A 400 Byte Lookup Table
charactr DEFS 256-32*8,0
