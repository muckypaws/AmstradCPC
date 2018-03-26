         ORG  #9000
compress
         ENT  $
         LD   de,256
         CALL #bbab                     ; Switch Off UDG's
         LD   hl,#a000
         LD   de,"0"
         CALL #bbab                     ; Copy Char. Table Into #A000
         LD   de,256
         CALL #bbab                     ; Switch Off UDG's
reducev
         LD   ix,#a000                  ; IX=UDG TABLE
         LD   iy,#a000                  ; IY=SPRITE TABLE FOR SHRUNKEN CHARS.
         LD   c,#2b                     ; First Shrink Chars. Vert.
reducev1                                ; Converts From 8 Bytes Vertically
         LD   b,2                       ; To 5 Bytes Vertically
         CALL convertv                  ; Copy First 2 Bytes Of Char Into IY
         INC  ix                        ; Skip 3rd Byte
         LD   b,2
         CALL convertv                  ; Copy 4th 'n 5th Bytes Into IY
         INC  ix                        ; Skip 6th Byte
         LD   b,1
         CALL convertv                  ; Copy 7th Byte Into IY
         INC  ix                        ; Point IX to Next Char.
         DEC  c                         ; C=C-1
         JR   nz,reducev1               ; Loop #2B Times
         JR   converth                  ; Jump To CONVERTH Routine
convertv
         LD   a,(ix+0)                  ; Let A=contents of IX
         LD   (iy+0),a                  ; Let IY = A
         INC  ix                        ; IX=IX+1
         INC  iy                        ; IY=IY+1
         DJNZ convertv                  ; Loop no. in B times
         RET                            ; And Quit
converth                                ; Convert Horizontally from 8 - 3 Bytes
         LD   ix,#a000                  ; Let IX=Character Data
         LD   iy,sprite                 ; Let IY=Destination Sprite Data
         LD   c,#2b                     ; No. Of Characters To Convert
conv1
         LD   a,(ix+3)
         LD   b,5
         BIT  7,a
         JR   nz,conv4
conv2
         LD   a,(ix+0)
         AND  a
         SLA  a
         LD   (iy+0),a
         INC  ix
         INC  iy
         DJNZ conv2
conv3
         DEC  c
         JR   nz,conv1
         JR   print
conv4
         LD   a,(ix+0)
         AND  #e0
         LD   d,a
         LD   a,(ix+0)
         AND  #e
         AND  a
         SLA  a
         OR   d
         LD   (iy+0),a
         INC  ix
         INC  iy
         DJNZ conv4
         JR   conv3
tidyup
         LD   ix,sprite                 ; Convert 6 bits to 3
         LD   b,#2b*5                   ; No Of Characters
tidy1
         LD   a,(ix+0)
         BIT  6,a
         JR   nz,set67
         LD   d,%00111111
         AND  d
tidy2
         BIT  4,a
         JR   nz,set45
         LD   d,%11001111
         AND  d
tidy3
         BIT  2,a
         JR   nz,set23
         LD   d,%11110011
         AND  d
tidy4
         INC  ix
         DJNZ tidy1
         RET  
set67
         SET  7,a
         SET  6,a
         JR   tidy2
set45
         SET  5,a
         SET  4,a
         JR   tidy3
set23
         SET  3,a
         SET  2,a
         JR   tidy4
print
         LD   a,1
         CALL #bc0e
         LD   hl,#c000                  ; Let HL=Destination Address Of Sprite
         LD   ix,#a000                  ; Let IX=Sprite Table
         LD   c,#2b                     ; Let C=Number Of Characters to Print
print4
         PUSH hl                        ; Store HL
print2
         LD   b,5                       ; 5 Bytes to the sprite
print1
         LD   a,(ix+0)                  ; A=Byte From Sprite Table
         LD   (hl),a                    ; Store A in screen Memory
         INC  ix                        ; IX=IX+1  Point To Next Byte Of Sprite
         LD   de,#800                   ; Let DE=Screen Offset
         ADD  hl,de                     ; Point HL to next pixel line down
         JR   nc,print3                 ; If HL<#FFFF then Branch to print3
         LD   de,#c050                  ; DE=Screen offset for next line down
         ADD  hl,de                     ; Add 'em
print3
         DJNZ print1                    ; Loop 5 Times
         POP  hl                        ; Restore HL
         INC  hl                        ; Increment HL to Next Byte to Right
         DEC  c                         ; C=C-1
         JR   nz,print4                 ; Loop 43 Times
         CALL #bb18
         RET                            ; And Quit.
sprite                                  ; Location Of Sprite Table
         DEFS #2b*5,0
