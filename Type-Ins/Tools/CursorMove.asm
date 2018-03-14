         ORG  #a000                     ; Routine to move cursor ( [  ] )
cursor                                  ; Around the screen
         ENT  $
move
         LD   a,1
         CALL #bc0e
getkey
         CALL display
         LD   a,47
         CALL #bb1e                     ; Check for space
         RET  nz                        ; If so Exit
         LD   a,71                      ; Check for left - Z
         CALL #bb1e
         JR   nz,left
         LD   a,63                      ; Check for right - X
         CALL #bb1e
         JR   nz,right
         LD   a,19                      ; Check for up - ;
         CALL #bb1e
         JR   nz,up
         LD   a,22                      ; Check for Down - \
         CALL #bb1e
         JR   nz,down
         JR   getkey                    ; If non of these then loop.
left                                    ; Move Cursor left - if possible
         LD   a,(x)
         CP   1
         JR   z,getkey
         CALL erase
         LD   a,(x)
         SUB  5
         LD   (x),a
         JR   getkey
right
         LD   a,(x)
         CP   36
         JR   z,getkey
         CALL erase
         LD   a,(x)
         ADD  a,5
         LD   (x),a
         JR   getkey
up
         LD   a,(y)
         CP   1
         JR   z,getkey
         CALL erase
         LD   a,(y)
         DEC  a
         LD   (y),a
         JR   getkey
down
         LD   a,(y)
         CP   24
         JR   z,getkey
         CALL erase
         LD   a,(y)
         INC  a
         LD   (y),a
         JR   getkey
display                                 ; Display Cursor
         LD   hl,coords
         CALL print
         LD   hl,CURSOR
         JP   print
erase                                   ; Erase current Cursor position.
         LD   hl,coords
         CALL print
         LD   hl,blank
         JP   print
print
         LD   a,(hl)
         OR   a
         RET  z
         INC  hl
         CALL #bb5a
         JR   print
coords
         DEFB 31
x        DEFB 01
y        DEFB 01
         DEFB 0
CURSOR
         DEFM [
         DEFB 9,9
         DEFM ]
         DEFB 0
blank    DEFB 32,9,9,32
