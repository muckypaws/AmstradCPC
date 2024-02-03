;
; XOR Game - DiskSys 18.9.87 - Protection Loader and Hack
;     Documented by Jason "The Argonaut" Brooks 2/2/2024
;
; In ADAM, load to RAMBank, OUT &7F00,196:RUN"ADAM"
;
; Once in ADAM, change the top of memory address using 
;
; m#7a00
;
; This ensures the ADAM return code is located below #8000 otherwise you'll crash.

         ORG  #a400
start
         ENT  $
         DI   							; Disable Interrupts
         POP  hl						; Get Return Address
         LD   (adam),hl					; Set Jump Address for Later			
         LD   bc,#7fc0
         OUT  (c),c						; Switch ADAM out and Standard Memory In
         LD   hl,readcomm
         CALL #bcd4						; Get Address of Read Sector RSX
         RET  nc						; Not found, off we pop 
         LD   a,c						; A = ROM Number (7)
         LD   (readsect),hl				; Address of ROM Routine
         LD   (readsect+2),a			; Store ROM 
         LD   de,0						; Track 0, Head 0
         LD   c,#41						; Sector #41
         LD   hl,#100					; Load to Memory Address #100
         CALL readit					; Read the Sector
         LD   a,#c3
         LD   hl,control
         LD   (#1df),a					; Patch the loader code to return control
         LD   (#1e0),hl                 ; to us!
         JP   #100						; Execute the loader code.
;
; Pass control to us.
;
control
         DI   							; Disable Interrupts 
         LD   a,#c9
         LD   (#213),a					; Patch the Protection Load Code 
         LD   a,18						; A = Track to Load 
         CALL #1f4						; Call routines to load dodgy sector info
         EI   							; Enable interrupts 
         LD   a,1
         LD   bc,#1a1a
         CALL #bc32						; INK 1,26 
         CALL #bd19
         CALL #bd19						; Needed otherwise ADAM INK will be Purple
         DI   							; Swap ADAM Back into memory 
         ld a,#21
         ld (#213),a 					; Restore Byte
         LD   bc,#7fc4
         OUT  (c),c
         JP   0							; Jump back to ADAM and our control
adam     EQU  $-2
readit
         RST  #18
         DEFW readsect
         RET  
readcomm DEFB #84
readsect DEFS 3,0
