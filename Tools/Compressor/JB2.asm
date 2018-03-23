;
         ORG  #a000
start
         ENT  $
         LD   hl,message                ; HL Points to the Message Memory buffe
loop
         LD   a,(hl)                    ; load character in memory address poin
         OR   a                         ; Checking for a Zero Byte Loaded
         RET  z                         ; quit routine
         CALL #bb5a                     ; Firmware ROutine for Character Printi
         INC  hl                        ; Increment the memory address in HL
         JR   loop                      ; Repeat until Zero Byte Found
;
startv2
         LD   hl,message2               ; Load HL with Message BIt 7 Set
loop2
         LD   a,(hl)                    ; Load A with contents of memory in HL
         AND  #7f                       ; can use res 7,a
         CALL #bb5a                     ; Firmware Call to Print CHar
         LD   a,(hl)                    ; Reload A as destroyed in mask above
         BIT  7,a                       ; Check for Bit 7 set
         RET  nz                        ; Quit if set
         INC  hl                        ; increment memory pointer in HL
         JR   loop2                     ; loop back
message
         DEFM Hello, world!
         DEFB 0
message2
         DEFM Hello, World Bit 7 Se
         DEFB "t"+#80
