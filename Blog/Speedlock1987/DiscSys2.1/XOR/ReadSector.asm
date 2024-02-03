         ORG  #a000
start
         ENT  $
         LD   hl,readcomm			; Point to RSX Command to Search
         CALL #bcd4					; Firmware Find RSX
         RET  nc					; Quit if not found
         LD   a,c					; A = ROM Command Found
         LD   (readsect),hl			; Address Routine found
         LD   (readsect+2),a		; ROM Command Found (Needed for RST#18)
         LD   de,0					; D = Drive, E = Head/Side
         LD   c,#41					; C = Sector Number
         LD   hl,#100				; HL = Memory Address to Load Sector
;
; Read Sector and Return
;         
readit
         RST  #18					; Perform RST#18
         DEFW readsect				; Point to the FARCALL Table
         RET  						; Return Control
readcomm DEFB #84					; READ Sector Hidden RSX Command
readsect DEFS 3,0					; Buffer for FAR Call Address and ROM
