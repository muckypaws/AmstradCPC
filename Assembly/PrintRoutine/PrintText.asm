         ORG  #9000
printout ENT  $
         CALL calcscr                   ; Calculate physical Screen Co-ordinate
         LD   de,256
         CALL #bbab                     ; Switch Off Any Existing UDG'S
         LD   hl,chart                  ; HL=Pointer Of CHARacterTable
         LD   de,32                     ; First Character to use=SPACE
         CALL #bbab                     ; Enable UDG's
         LD   hl,message                ; Point HL to Message to print
         LD   bc,#0101                  ; Co-ordinates 1,1
         CALL printit                   ; Print up Message
         RET                            ; And Quit!
;
calcscr                                 ; Calculate Physical Screen Coords
         PUSH ix
         PUSH af
         PUSH bc
         PUSH de
         PUSH hl                        ; Preserve Registers
         LD   hl,199                    ; HL = Topmost Byte
         LD   b,#c8                     ; Number of Bytes Down
         LD   ix,spritet                ; IX=SPRITE Table to store Coords
calc1
         PUSH bc                        ; Store Loop Counter
         PUSH hl                        ; Store Height
         LD   de,0                      ; DE=Left most byte
         CALL #bc1d                     ; calculate screen co-ordinates
         LD   (ix+0),l
         LD   (ix+1),h                  ; Store HL in IX
         INC  ix
         INC  ix                        ; IX=IX+2
         POP  hl                        ; Restore HL
         DEC  hl                        ; HL=HL-1
         POP  bc                        ; Restore Loop Counter
         DJNZ calc1                     ; B=B-1 if B<>0 then loop calc1
         POP  hl
         POP  de
         POP  bc
         POP  af
         POP  ix                        ; Restore Registers so no Corruption
         RET                            ; Quit Routine 
;
printit                                 ; Routine To Print up a Message
         PUSH hl
         PUSH de
         PUSH bc
         PUSH af                        ; Preserve Registers
printit1                                ; On Entry :- 
         PUSH hl                        ; HL=Pointer To Message
         PUSH bc                        ; B=No. Of Bytes Down From Top Left
         PUSH hl
         LD   de,spritet-2              ; Location of Screen Bytes
         LD   h,0                       ; Reset H
         LD   l,b                       ; Let L=B
         ADD  hl,hl                     ; HL=HL*2
         ADD  hl,de                     ; HL=HL+DE (DE=SPRITE TABLE)
         PUSH hl
         POP  ix                        ; Restore HL into IX
         LD   e,(ix+0)
         LD   d,(ix+1)                  ; DE=Physical Screen Byte
         EX   de,hl                     ; DE=HL, HL=DE
         DEC  c
         LD   d,0                       ; Reset D
         LD   e,c                       ; E=C
         ADD  hl,de                     ; Add Screen Byte + Offset
         EX   de,hl                     ; DE=HL, HL=DE
         POP  hl
print2
         LD   a,(hl)                    ; Let A=part of message.
         SUB  32                        ; Minus Minimum Charcter
         JR   c,print3                  ; If Termination byte<32 then print3
         PUSH hl
         PUSH de                        ; Preserve HL & DE
         LD   de,chart                  ; DE=Location CHARacter Table
         LD   h,0                       ; Reset H
         LD   l,a                       ; L=Character from message
         ADD  hl,hl                     ; HL=HL*2
         ADD  hl,hl                     ; HL=HL*2 = HL*4
         ADD  hl,hl                     ; HL=HL*2 = HL*8
         ADD  hl,de                     ; HL=HL+CHART
         LD   a,(count)                 ; Let A=Count - Which Byte ?
         LD   e,a                       ; Let E=A
         LD   d,0                       ; Reset D
         ADD  hl,de                     ; Add Character table + offset
         LD   a,(flag)                  ; A=Flag
         LD   b,15                      ; Mask For And
         OR   a                         ; Is A=0 or A>0
         JR   nz,print5                 ; If A>0 then print5
         LD   b,%11110000               ; Mask For logical AND
print5
         POP  de                        ; Restore DE=Screen Byte to store data
         LD   a,(hl)                    ; Let A=Byte of char matrix of letter
         AND  b                         ; And With Mask = 1 Nibble of Char
         LD   (de),a                    ; Store Result in DE
         POP  hl                        ; Restore HL=Message Pointer
         LD   a,(flag)                  ; Let A=Flag
         XOR  1                         ; Flip Bit 0
         LD   (flag),a                  ; Let Flag=A
         OR   a                         ; Is Flag=0 ?
         JR   nz,print6                 ; If Non Zero Don't Inc Message pointer
         INC  hl                        ; Message Pointer=Pointer+1
print6
         INC  de                        ; Screen Offset=Offset+1
         JR   print2                    ; Loop to Print
print3                                  ; Check to see if We've Finished Print.
         LD   a,(count)                 ; Let A=Count
         INC  a                         ; Let A=A+1
         LD   (count),a                 ; Let Count=A
         CP   8                         ; Have We Finished ?
         JR   z,print4                  ; If So Restore Register & Quit
         POP  bc                        ; Restore BC=XY Co-ords
         INC  b                         ; Y=Y+1
         POP  hl                        ; Restore Mess. Pointer to start - text
         JR   printit1                  ; Loop to Printit1
print4
         POP  bc
         POP  hl                        ; Restore unwanted registers
         XOR  a
         LD   (count),a                 ; Reset Counter
         POP  af
         POP  bc
         POP  de
         POP  hl                        ; Restore Registers
         RET                            ; And Quit  
;
message
         DEFM This is a Test Message
         DEFB 32
         DEFM To See My Routine Print 
         DEFM In Pretty Colours.
         DEFB 0
count    DEFB 0
flag     DEFB 0
spritet  DEFS #190,0
chart    EQU  #8000
