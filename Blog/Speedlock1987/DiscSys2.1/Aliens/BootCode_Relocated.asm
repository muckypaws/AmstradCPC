#2000   LD   HL,#100        210001
#2003   LD   DE,#2000       110020
#2006   LD   BC,#200        010002
#2009   LDIR                EDB0			; Original Code from #100 (Boot Sector |CPM)
#200B   LD   C,#FF          0EFF
#200D   LD   HL,#209D       219D20
#2010   CALL #BD16          CD16BD			; Control passed to #209D
;
; Seek Command, E = Drive, D = Track
;
#2013   LD   D,A            57
#2014   LD   E,#00          1E00			; E = 0 - Drive 0
#2016   RST  #18            DF				; FAR CALL #C045 ROM 7
#2017   DEFW #201A			1A20 			; Point to ROM Routine to Call
#2019   RET 				C9				; return control
#201A   DEFW #C045 			45C0			; ROM ADDRESS 
#201C   DEFB 7 				07 				; AMSDOS ROM

;
; Load Single Track of DATA 
;
#201D   CALL #206A          CD6A20			; Enable ROM 7 and Preserve State
#2020   CALL #2026          CD2620			; Load TRACK Data Routine
#2023   JP   #2076          C37620			; Restore Upper ROM Previous State
;
; Read Sector Routine
;
#2026   CALL #C976          CD76C9			; Drive Motor ON
#2029   CALL #C947          CD47C9			; Wait for DDFC Command Phase and Wait for Ready Signal
											; Sends Command 8 - Sense Interrupt State and waits
#202C   LD   BC,#FB7E       017EFB			
#202F   LD   A,#46          3E46
#2031   CALL #C95C          CD5CC9			; Send Read Command
#2034   XOR  A              AF
#2035   CALL #C95C          CD5CC9			; Send Drive 0
#2038   LD   A,(#2082)      3A8220			; Current Track
#203B   CALL #C95C          CD5CC9			; Send Track to Read
#203E   XOR  A              AF
#203F   CALL #C95C          CD5CC9			; Send Head Number - always 0
#2042   XOR  A              AF
#2043   CALL #C95C          CD5CC9			; Send Sector Number to Read
#2046   LD   A,#05          3E05
#2048   CALL #C95C          CD5CC9			; Send Number of Bytes per Sector (4K Bytes)
#204B   XOR  A              AF
#204C   CALL #C95C          CD5CC9			; Send End of Track (Sector Number to Read)
#204F   LD   A,#11          3E11
#2051   CALL #C95C          CD5CC9			; Send GAP#3 = #11 - 17 bytes... 
#2054   LD   A,#FF          3EFF			; 
#2056   DI                  F3
#2057   CALL #C95C          CD5CC9			; Data Length - Sector Size <256
#205A   PUSH IY             FDE5
#205C   POP  HL             E1				; HL = IY = Address to load data
#205D   CALL #C6E5          CDE5C6			; DDFDC Execute Command
#2060   EI                  FB
#2061   PUSH HL             E5
#2062   POP  IY             FDE1			; HL = Next Address to load data, IY = HL
#2064   CALL #206A          CD6A20			; Select ROM 7
#2067   JP   #C91C          C31CC9			; DDFDC Results Phase
;
; Select ROM 7 and Store Previously ROM State
;
#206A   PUSH BC             C5
#206B   LD   C,#07          0E07
#206D   CALL #B90F          CD0FB9			; Select ROM 7
#2070   LD   (#2080),BC     ED438020		; BC = Previously Selected ROM and State
#2074   POP  BC             C1
#2075   RET                 C9
;
;
;
#2076   PUSH BC             C5				; Preserve BC
#2077   LD   BC,(#2080)     ED4B8020		; Get previous ROM State
#207B   CALL #B918          CD18B9			; Restore Previous Upper ROM Select
#207E   POP  BC             C1				; Restore BC	
#207F   RET                 C9				; End Routine
;
;
;
#2080   DEFW 0				0000			; Previous ROM Select Store
;
;
;
#2082   DEFB 4              04			; Current Track to Load.
;
; Load data from Disk
;
#2083   PUSH BC             C5			; Preserve BC (Counter)
#2084   LD   A,(#2082)      3A8220		; Get the Track to load from (4) (Never initialised)
#2087   CALL #2013          CD1320		; Seek to Track 4 Passed in DE 
#208A   CALL #201D          CD1D20		; Load Track to memory.
#208D   LD   HL,#2082       218220		; Point to the current Track
#2090   INC  (HL)           34			; Increment the Track Counter
#2091   POP  BC             C1			; Restore Counter
#2092   DJNZ #2083          10EF		; Loop for B
#2094   RET                 C9			; End of Routine
;
;
;
#2095   LD   B,#BC          06BC
#2097   OUT  (C),D          ED51
#2099   INC  B              04
#209A   OUT  (C),E          ED59
#209C   RET                 C9
;
; Start of the Actual Loader Code
;
#209D   LD   C,#07          0E07			; Execution loader actual Start Address
#209F   CALL #BCCE          CDCEBC			; Initialise AMSDOS ROM
;
; Set Border to Black
;
#20A2   LD   BC,#00         010000
#20A5   CALL #BC38          CD38BC			; Set BORDER 0
;
; Set INK 0,0:INK1,26
;
#20A8   LD   BC,#00         010000
#20AB   XOR  A              AF	
#20AC   CALL #BC32          CD32BC			; INK 0,0
#20AF   LD   BC,#1A1A       011A1A
#20B2   LD   A,#01          3E01
#20B4   CALL #BC32          CD32BC			; INK 1,26
;
; Load the First Scrolling Screen... What bloody Cheats!
;
#20B7   LD   B,#04          0604
#20B9   LD   IY,#3000       FD210030
#20BD   CALL #2083          CD8320			; Load from Disk code at #3000
;
;
;

#20C0   LD   IY,#8000       FD210080
#20C4   LD   B,#01          0601
#20C6   CALL #2083          CD8320			; Load from disk code at #8000
;
#20C9   CALL #2111          CD1121			; Disable Upper and Lower ROM (Back to RAM)
;
#20CC   CALL #8000          CD0080			; Load title page Code (Scrolling Titles)
;
; Load Next Loading Screen (16kb into address #3000)
;
#20CF   LD   IY,#3000       FD210030
#20D3   LD   B,#04          0604
#20D5   CALL #2083          CD8320			; Load more Code to #3000
;
; Set System Colour Palette
;
#20D8   LD   HL,#2117       211721			; Set Inks from table located at #2117
#20DB   XOR  A              AF				; A = 0
#20DC   LD   C,(HL)         4E
#20DD   INC  HL             23
#20DE   LD   B,C            41				; BC = contents of HL
#20DF   PUSH AF             F5
#20E0   PUSH HL             E5
#20E1   CALL #BC32          CD32BC			; Set INK A,BC
#20E4   POP  HL             E1
#20E5   POP  AF             F1
#20E6   INC  A              3C				
#20E7   CP   #10            FE10
#20E9   JR   NZ,#20DC       20F1			; Loop until all inks set.
;
; Set Screen MODE
;
#20EB   XOR  A              AF
#20EC   CALL #BC0E          CD0EBC			; MODE 0
;
;
;
#20EF   CALL #2111          CD1121			; Disable Upper and Lower ROMS
#20F2   CALL #8000          CD0080			; Scroll the Screen up again
;
;
;
#20F5   LD   A,#0D          3E0D			; Protected Sector 13 Validation Check
#20F7   CALL #2127          CD2721			; Call Copy Protection Validation 
;
;
;
#20FA   LD   A,#0E          3E0E			; Set Next Track to 14 (Continue)
#20FC   LD   (#2082),A      328220			; Set the Address Where Current Track Stored
#20FF   LD   IY,#40         FD214000		; Load Next part of the Game at Address #40
#2103   LD   B,#01          0601			; Only one track to Load
#2105   CALL #2083          CD8320			; Load the Track	
#2108   LD   BC,#FA7E       017EFA
#210B   XOR  A              AF
#210C   OUT  (C),A          ED79			; Switch the Disk Motor Off
#210E   JP   #40            C34000			; Start the new loader code!
;
;
;
#2111   CALL #B903          CD03B9			; Disable Upper ROM
#2114   JP   #B909          C309B9			; Disable Lower ROM
;
;
;
#2117   NOP                 00
#2118   LD   A,(DE)         1A
#2119   LD   B,#14          0614
#211B   LD   DE,#112        111201
#211E   ADD  HL,DE          19
#211F   RRCA                0F
#2120   INC  BC             03
#2121   DJNZ #2130          100D
#2123   DEC  C              0D
#2124   LD   D,#0E          160E
#2126   DEC  C              0D
;
;
;
#2127   CALL #2013          CD1320			; Seek to Track Pointed to in A 
#212A   LD   DE,#40         114000
#212D   LD   B,#10          0610
#212F   PUSH BC             C5
#2130   PUSH DE             D5
#2131   CALL #206A          CD6A20			; Select ROM 7 
#2134   CALL #2167          CD6721			; Send Command READ ID to FDC Controller
#2137   CALL #2076          CD7620			; Restore ROM State
#213A   POP  DE             D1				; Restore DE
#213B   LD   HL,#BE4F       214FBE			; SEND ID Command Response Buffer
#213E   LD   BC,#04         010400			; Four Bytes from READ ID Command
#2141   LDIR                EDB0			; Copy info from Sector Info Buffer to Memory
											; Track, Head, Sector ID, Size
#2143   POP  BC             C1
#2144   DJNZ #212F          10E9			; Repeat 16 Times.
;
; Protection Check
;
#2146   LD   HL,#40         214000			; Start of Table where Sectors Read
#2149   LD   B,#10          0610			; Loop 16 Times
#214B   LD   DE,#04         110400			; Offset
#214E   LD   A,(HL)         7E				; Get Track Number from Sector ID (READ ID)
#214F   CP   #0F            FE0F			; Looking for Track 15 (Fake Track ID)
#2151   JR   Z,#215E        280B			; If Found Quit Loop
#2153   ADD  HL,DE          19				; Add offset of 4 (Next set of Sector IDs)
#2154   DJNZ #214E          10F8			; Loop 16 Times
#2156   LD   HL,#00         210000			; Still not Found?
#2159   LD   C,#00          0E00			; Time to Reset the System you Pirate!
#215B   CALL #BD16          CD16BD			; Reset the Amstrad (Equivalent of RST#00)
#215E   LD   B,#04          0604			; Now Check that all four bytes are the same Fake Sector info
#2160   CP   (HL)           BE				; Check for #0F, #0F, #0F, #0F
#2161   JR   NZ,#2156       20F3			; If Not Equal, Pirated Disk 
#2163   INC  HL             23				; HL = HL + 1, next byte in Sector ID Information
#2164   DJNZ #2160          10FA			; Continue to Loop
#2166   RET                 C9				; Yay! original disk... maybe ;p 
;
; Call Send ID to FDC Controller
;
#2167   CALL #C976          CD76C9			; Drive Motor ON
#216A   CALL #C947          CD47C9			; Wait for DDFDC to be ready.
#216D   LD   BC,#FB7E       017EFB
#2170   LD   A,#4A          3E4A
#2172   CALL #C95C          CD5CC9			; Send Command #4A - Read ID
#2175   XOR  A              AF
#2176   CALL #C95C          CD5CC9			; Drive Number 0 - A
#2179   JP   #C91C          C31CC9			; Get Results
