;
; XOR Game - DiskSys 18.9.87 - Disassembly...
;     Documented by Jason "The Argonaut" Brooks 31/1/2024
;
;
; Game loads by using the |CPM Command, Loading Track 0, Sector #41
			 To Address #100, Amstrad is reinitialised and execution
			 starts at #100
;
# 100   DI                  F3				; Disable Interrupts
# 101   LD   BC,#FEE8       01E8FE
# 104   OUT  (C),C          ED49			; Check for Multiface Presence
# 106   LD   A,(#00)        3A0000
# 109   CP   #F3            FEF3			; Load first Byte (If Multiface enabled #F3 if not 01)
# 10B   JR   Z,#101         28F4			; If = #F3 (Multiface) keep looping until disabled.
# 10D   LD   C,#FF          0EFF
# 10F   LD   HL,#19A        219A01
# 112   CALL #BD16          CD16BD			; Initialise Program and start at Address #19A
;
; Current Track Variable in Memory.
;
# 115   DEFB 4              04				; Current Track to Read INIT at 4
;
; INK Colour Table Only first four bytes relevant though 16 used.
;
# 116 	DEFB 00, 05, #1A, 06				; INK 0,0:INK 1,5:INK 2,26:INK 3,6
;
; Seek to Track Pointed to in A
;
# 11A   LD   D,A            57				; D = Track = A
# 11B   LD   E,#00          1E00			; E = Drive = 0 = A:
# 11D   RST  #18            DF				; Far Call to Address data
# 11E   DEFW #0121			2101			; Pointer to FAR Call
# 120   RET 								; Return
;
; Far Call Address Data (#C045 - ROM 7)
;
# 121   DEFW #C045          45C0			; AMSDOS Jump to Seek Track
# 123   DEFB #07            07				; ROM 7 
;
; Read Sector from disk at current Track. IY = Load Address
;
# 124   CALL #C976          CD76C9			; Switch Drive Motor ON 
# 127   CALL #C947          CD47C9			; Wait for FDC to be Ready
# 12A   LD   BC,#FB7E       017EFB			; Data Port of FDC Controller
# 12D   LD   A,#46          3E46			; Command #46 - Read Sector 
# 12F   CALL #C95C          CD5CC9			; Send Command to FDC 
# 132   XOR  A              AF				; Drive Number = 0 - Drive A 
# 133   CALL #C95C          CD5CC9			; Send Command Parameter 1
# 136   LD   A,(#115)       3A1501			; Get Current Sector 
# 139   CALL #C95C          CD5CC9			; Send Command Parameter 2 
# 13C   XOR  A              AF				; Head = 0 
# 13D   CALL #C95C          CD5CC9			; Send Command Parameter 3
# 140   XOR  A              AF  			; Sector Number to Read (0)
# 141   CALL #C95C          CD5CC9			; Send Command Parameter 4
# 144   LD   A,#05          3E05			; Sector Size to Read, 5 = 4Kb 
# 146   CALL #C95C          CD5CC9			; Send Command Parameter 5
# 149   XOR  A              AF				; Last Sector to read (0 )
# 14A   CALL #C95C          CD5CC9			; Send Command Parameter 6
# 14D   LD   A,#11          3E11			; GAP #3 Size
# 14F   CALL #C95C          CD5CC9			; Send Command Parameter 7
# 152   LD   A,#FF          3EFF			; Data Length if <255 bytes.
# 154   DI                  F3				; Disable Interrupts for next bit
# 155   CALL #C95C          CD5CC9			; Send Command Parameter 8
# 158   PUSH IY             FDE5			; 
# 15A   POP  HL             E1				; HL = IY - Memory Address to load data
# 15B   CALL #C6E5          CDE5C6			; FDC Execute command.
# 15E   EI                  FB				; Re-enable Interrupts
# 15F   PUSH HL             E5				; HL Updated to point to next Memory
											; Address after loading sector
# 160   POP  IY             FDE1			; IY = HL (Next memory load address)
# 162   CALL #184           CD8401			; Select ROM 7
# 165   JP   #C91C          C31CC9			; Read FDC Results and complete command 
;
; Address #115 = Current Track to Seek to.
;
# 168   CALL #184           CD8401			; Select ROM 7
# 16B   CALL #124           CD2401			; Read Sector at Current Track
# 16E   CALL #190           CD9001			; Restore Previous ROM
# 171   LD   HL,#115        211501			; Pointer to Current Track 
# 174   INC  (HL)           34				; Increment Memory by 1
# 175   RET                 C9				; Finished
;
; Load data from multiple sectors.
;
# 176   PUSH BC             C5				; Preserve Loop Counter
# 177   LD   A,(#115)       3A1501			; Get Current Track to Seek
# 17A   CALL #11A           CD1A01			; Seek to Track A
# 17D   CALL #168           CD6801			; Read Sector 
# 180   POP  BC             C1				; Restore Counter 
# 181   DJNZ #176           10F3			; Loop until complete 
# 183   RET                 C9				; Return Control.
;
; Select ROM 7 and Store Previously ROM State
;
# 184   PUSH BC             C5
# 185   LD   C,#07          0E07
# 187   CALL #B90F          CD0FB9			; Select ROM 7
# 18A   LD   (#BF00),BC     ED4300BF		; Store Previously Selected ROM
# 18E   POP  BC             C1
# 18F   RET                 C9
;
; Restore Previous ROM State stored in #BF00 
;
# 190   PUSH BC             C5
# 191   LD   BC,(#BF00)     ED4B00BF		; Get Previous ROM State
# 195   CALL #B918          CD18B9			; And Restore It
# 198   POP  BC             C1
# 199   RET                 C9
;
; Initial Check for Multiface Complete, lets start the loader!
;
# 19A   LD   C,#07          0E07
# 19C   CALL #BCCE          CDCEBC			; Enable AMSDOS ROM
# 19F   LD   A,#01          3E01
# 1A1   CALL #BC0E          CD0EBC			; MODE 1
# 1A4   LD   BC,#00         010000
# 1A7   CALL #BC38          CD38BC			; BORDER 0
;
; Set the INKS Loop
;
# 1AA   LD   HL,#116        211601			; Pointer to Table of Colours
# 1AD   XOR  A              AF				; A = 0 (INK 0)
# 1AE   LD   C,(HL)         4E				; Load C with contents of HL (INK Colour)
# 1AF   INC  HL             23				; HL = HL + 1
# 1B0   PUSH HL             E5
# 1B1   PUSH AF             F5				; Preserve AF and HL, our INK Number and Pointer
# 1B2   LD   B,C            41				; B = C (Amstrad Supports Flashing Colours - Ensures no flashing)
# 1B3   CALL #BC32          CD32BC			; INK A,B,C 
# 1B6   POP  AF             F1	
# 1B7   POP  HL             E1				; Restore Registers
# 1B8   INC  A              3C				; A = A + 1
# 1B9   CP   #10            FE10			; Has A reached 16 yet?
# 1BB   JR   NZ,#1AE        20F1			; Loop Back until all inks are Set
;
; Load first section of code.
;
# 1BD   LD   B,#05          0605			; Five Sectors to load
# 1BF   LD   IY,#4000       FD210040		; Load Address #4000
# 1C3   CALL #176           CD7601			; Call Disk Routine to load sectors to memory 
;
; Each sector is 4kb in length. 5 sectors mean 20kb was loaded to Address
;		#4000-#8FFF
;
; Some code needs relocating from #8000 to #A000 so we'll move it.
;
# 1C6   LD   HL,#8000       210080			; Start address of Code to Move
# 1C9   LD   DE,#A000       1100A0			; Destination Address of Code to move
# 1CC   LD   BC,#240        014002			; Length of #240
# 1CF   LDIR                EDB0			; COPY Code 
# 1D1   CALL #A000          CD00A0			; Call code to load title screen
;
; Title page dealt with, now the game code.
;
# 1D4   LD   IY,#F00        FD21000F		; Address to load Sectors #F00
# 1D8   LD   B,#09          0609			; 9 * 4K Sectors (36864 Bytes)
# 1DA   CALL #176           CD7601			; Load Sectors from Disk to memory.
;
;
;
# 1DD   LD   A,#12          3E12			; Track 18
# 1DF   CALL #1F4           CDF401			; Call the Protection System Check
;
; Stop the drive from Spinning
;
# 1E2   LD   BC,#FA7E       017EFA			; Drive Motor
# 1E5   XOR  A              AF				; A = 0 (To Switch Motor Off)
# 1E6   OUT  (C),A          ED79			; Switch the Drive Motor Off
;
;
;
# 1E8   DI                  F3
# 1E9   LD   BC,#7F8D       018D7F
# 1EC   OUT  (C),C          ED49			; Disable Upper/Lower ROM
;
;
;
# 1EE   CALL #A000          CD00A0			; Call Another Routine
# 1F1   JP   #1000          C30010			; Start the Game Code.
;
; DiskSys Protection System Check
;
# 1F4   CALL #11A           CD1A01			; Seek to Track Pointed to in A 
# 1F7   LD   DE,#BF02       1102BF			; Start of Destination Buffer to
											; Copy Sector ID information
# 1FA   LD   B,#10          0610			; Loop Counter = 16 
# 1FC   PUSH BC             C5	
# 1FD   PUSH DE             D5				; Preserve BC and DE Registers.
# 1FE   CALL #184           CD8401			; Select Upper ROM 7
# 201   CALL #22C           CD2C02			; Send READ ID to FDC Controller 
# 204   CALL #190           CD9001			; Restore ROM to previous states
# 207   POP  DE             D1				; Restore DE (Destination to copy)
# 208   LD   HL,#BE4F       214FBE			; Firmware Memory Block containing 
											; Sector ID information
# 20B   LD   BC,#04         010400
# 20E   LDIR                EDB0			; Copy these four bytes to DE 
# 210   POP  BC             C1
# 211   DJNZ #1FC           10E9			; Restore BC and loop four times..
;
; Now Sector ID's are loaded into memory, DISKSYS Wants to check their presence.
; it is expecting the memory to be populated with :-
;	0,0,0,0, 1,1,1,1, 2,2,2,2 ... f,f,f,f 
; Though the order could change depending when the READ ID command started in 
; relation to the disk spinning in the drive
;
# 213   LD   HL,#BF02       2102BF			; Start of Sector ID Buffer Copied Above
# 216   LD   B,#10          0610			; Loop 16 times
# 218   LD   DE,#04         110400			; An Offset of Four (Four bytes copied above)
# 21B   LD   A,(HL)         7E				; A = Contents of memory at HL 
# 21C   CP   #0F            FE0F			; Does it contain #F? 
# 21E   JR   Z,#223         2803			; Found our interesting sector ID
											; Part 1 Check complete.
# 220   ADD  HL,DE          19				; otherwise add 4 to HL to point to 
# 221   DJNZ #21B           10F8			; The next block of Sectors and loop
;
; Secondary Check, make sure that the sector ID's all contain the same digits
; 		Some copiers would correct the fourth byte (Size) to be 0 meaning 128 Bytes 
;
# 223   LD   B,#04          0604			; Loop Counter 
# 225   CP   (HL)           BE				; A is already primed Compare with 
											; contents of HL 
# 226   JR   NZ,#213        20EB			; If Not Equal Jump to an infinite loop...
# 228   INC  HL             23				; HL = HL + 1
# 229   DJNZ #225           10FA			; Loop until B = 0
# 22B   RET                 C9				; Check Complete, all ok!
;
; Simple routine to call AMSDOS Rom to send the NED µPD765A Controller
; 		 The READ ID Command.  Basically scans the track for sector information.
;
; DiskSYS Works by having a track or more with malformed corrupt sector ID's
;         By scanning the track and reading the Sector ID Information
;		  It works out if the corrupt information is available
;         Since Copiers weren't meant to be able to copy this information.
;
# 22C   CALL #C976          CD76C9			; Drive Motor ON
# 22F   CALL #C947          CD47C9			; Wait for DDFCDC to Be Ready
# 232   LD   BC,#FB7E       017EFB			; Command Port 
# 235   LD   A,#4A          3E4A			; SEEK Command
# 237   CALL #C95C          CD5CC9			; Send Command to FDC Controller 
# 23A   XOR  A              AF				; Drive 0 Parameter
# 23B   CALL #C95C          CD5CC9			; Send Command to FDC Controller 
# 23E   JP   #C91C          C31CC9			; Get FDC Results
