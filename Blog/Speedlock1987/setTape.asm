         ORG  #9f00                     ; Simple way to call |TAPE, |DISC
start
         ENT  $
         LD   hl,rsxdisk				; Command You Want to use.
setcmd                                  ; Set Command
         CALL #bcd4						; KL FIND COMMAND
         RET  nc                        ; Command Not Found Quit
         								; HL = Address In Memory of RSX
         								;  A = ROM
         LD   (jpaddr),hl               ; Routine Address
         LD   a,c
         LD   (jpaddr+2),a              ; Which ROM
         								; A = Number of Parameters required
         XOR  a                         ; Reset Number of Parameters to Passs
         RST  #18						; RST 3 (FAR CALL)
         DEFW jpaddr                    ; Far Call to Address Block Info
         RET  							; Return Control
;
; RST3 or RST #18 as Known requires an address table to
;				  make the jump in memory.
;
jpaddr   DEFW 0
         DEFB 0
;
; RSX Name to Search, Bit 7 is Set for Last Byte
rsxtape  DEFM TAP
         DEFB "E"+#80
rsxdisk
         DEFM DIS
         DEFB "C"+#80n
