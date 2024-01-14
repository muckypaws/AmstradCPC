SCR_INK_SET     EQU #BC32
KM_TEST_KEY     equ #BB1E
INK1            equ %11110000
INK2            equ %00001111
INK3            equ %11111111
INK0            equ 0

;
; Very simplistic Fast PLOT Routine for MODE 1 
;    initialise the screen lookup table, and then simply use :-
;
;       LD HL,X-Position     (Value between 0-319)
;       LD DE,Y-Position     (Value Between 0-199)
;       LD A,INK             (Use values above) from Full MODE 1 mask.
;       CALL PLOTPOINT       ; Plot the point
;
; Very rudimentary error checking for range of x,y for speed.
;

        ORG  #9000
        ENT  $
        CALL scrcalc               ; Set up Screen Index Table (Mandatory)
;
;
; Simple Tests to show code.
;
;
        ld hl,0
        ld de,0
        ld a,INK3
        call plotPoint
        ld hl,319
        ld de,0
        ld a,INK3
        call plotPoint
        ld hl,0
        ld de,199
        ld a,INK3
        call plotPoint
        ld hl,319
        ld de,199
        ld a,INK3
        call plotPoint

        ld hl,1
        ld de,0
        ld a,INK2
        call plotPoint
        ld hl,318
        ld de,0
        ld a,INK2
        call plotPoint
        ld hl,1
        ld de,199
        ld a,INK2
        call plotPoint
        ld hl,318
        ld de,199
        ld a,INK2
        call plotPoint


        ld hl,2
        ld de,0
        ld a,INK1
        call plotPoint
        ld hl,317
        ld de,0
        ld a,INK1
        call plotPoint
        ld hl,2
        ld de,199
        ld a,INK1
        call plotPoint
        ld hl,317
        ld de,199
        ld a,INK1
        call plotPoint

        ; Wait for space Key and then delete first pixel point on each corner
        ; Test overwrite pixel works when INK=0
loop
        ld A,47
        call KM_TEST_KEY
        jr z,loop

        ld hl,0
        ld de,0
        ld a,INK0
        call plotPoint
        ld hl,319
        ld de,0
        ld a,INK0
        call plotPoint
        ld hl,0
        ld de,199
        ld a,INK0
        call plotPoint
        ld hl,319
        ld de,199
        ld a,INK0
        jp plotPoint          ; For testing could have left this out and run into routine below... 


;
;       HL = X Position (0-319)
;       DE = Y Position (0-199)
;        A = Full Mode 1 INK Byte, 1 = (%00001111), 2= (%11110000), 3 = (%11111111)
;
plotPoint
        ld d,0              ; ensure D = 0 since only LSB is required.
        ld bc,320           ; Limit
        or A                ; Reset Carry
        sbc hl,bc
        ret nc              ; X Out of Bounds
        add hl,bc           ; Restore HL
        ex de,hl            ; HL = Y-Position
        ld bc,200
        or A
        sbc hl,bc
        ret nc              ; Quit if out of bounds.
        add hl,bc
        ex de,hl            ; Restore
;
; Simple Bounds Check Complete
; 
        push af
        call calcplot       ; Get Physical Screen address and Mask
        pop af
        and C               ; Get Plot Point actual
        ld e,a              ; Preserve in E
        ld a,c 
        xor #ff             ; inverse mask
        ld d,a
        ld a,(hl)           ; Get Current Screen Byte
        and D               ; Mask retaining existing data except for new plot nibbles.
        or e                ; apply plot point
        ld (hl),A
        ret

; Frame Flyback without Calling #BD19
; Optimised Hardware Version
;
framefly
         PUSH af
         PUSH bc            ; Preserve Registers
         LD   b,#f5         
framefl1
         IN   a,(c)
         RRA  
         JR   nc,framefl1
         POP  bc
         POP  af
         RET
;
; Pre-populate the screen address table for #c000
; 
scrcalc
         LD   hl,#c000              ; Top Left of Screen #C000
         LD   ix,calcaddr           ; Start of Screen Calc Table
         LD   b,200                 ; 200 Lines
scrcalc1
         LD   (ix+0),l
         LD   (ix+1),h              ; Write to the Table
         LD   a,h
         ADD  a,8
         LD   h,a                   ; add #800 to next line
         JR   nc,scrcalc2           
         LD   de,#c050              ; A Carry? Then add the offset #c050
         ADD  hl,de                 ; Point HL to the next screen address
scrcalc2
         INC  ix
         INC  ix                    ; Point to next entry in the Table
         DJNZ scrcalc1              ; Repeat for all 200 lines.
         RET                        ; That's all folks.
;
; Calculate the Screen Address Per X, Y coordinate.  (MODE 1)
;       HL = X Position (0-320)
;       DE = Y Position (0-199)
; Returns
;       HL = Screen Address Physical
;        C = Byte Mask
;        A = Byte Mask
calcplot                                ; Calculate Relative Screen address
         PUSH hl                        ; Preserve HL
         EX   de,hl                     ; HL Now contains Y Address
         ADD  hl,hl                     ; HL * 2
         LD   de,calcaddr               ; Start of Screen Coordinates Table
         ADD  hl,de                     ; Add Offset (Y*2) Points to Screen Line
         LD   e,(hl)
         INC  hl
         LD   d,(hl)                    ; DE = Screen Line Address (Left Side of Screen)
         POP  hl                        ; Restore HL
         LD   a,%10001000               ; Mask Byte Set (MODE 1)
                                        ; Simple way to calculate where in the pixel to write data.
         SRL  h
         RR   l                         ; HL/2
         JR   nc,calcplt2               ; Carry Flag Set?
         RRCA                           ; Shift Mask >> 
calcplt2
         SRL  h
         RR   l                         ; HL/4
         JR   nc,calcplt3
         RRCA 
         RRCA                           ; Shift Mask Twice
calcplt3
         ADD  hl,de                     ; HL = Screen Address
         LD   c,a 
         RET                            ; A = Mask to Use (MODE 1)

;
; Tables and Memory Storage
; 

; Screen Address Table for Left Hand Column Starting with Top Left, working Down.
calcaddr DEFS 400,0
