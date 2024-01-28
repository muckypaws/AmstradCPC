#BB00   LD   B,D            42
#BB01   LD   D,L            55
#BB02   LD   B,A            47
#BB03   LD   A,(HL)         7E
#BB04   LD   C,A            4F
#BB05   LD   B,(HL)         46
#BB06   LD   B,(HL)         46
#BB07   DEC  SP             3B
#BB08   DEC  SP             3B
#BB09*  LD   H,#BC          FD26BC
#BB0C*  LD   L,#C0          FD2EC0
#BB0F   EX   (SP),IY        FDE3
#BB11   LD   BC,#46         014600
#BB14   ADD  IY,BC          FD09
#BB16*  LD   E,L            FD5D
#BB18*  LD   D,H            FD54
#BB1A   LD   L,E            6B
#BB1B   LD   H,D            62
#BB1C   LD   BC,#1A8        01A801
#BB1F   LD   A,I            ED57
#BB21   CALL PO,#AC00       E400AC
#BB24   LD   A,R            ED5F
#BB26   XOR  (HL)           AE
#BB27   LD   (HL),A         77
#BB28   LDI                 EDA0
#BB2A   RET  PO             E0
#BB2B   DEC  SP             3B
#BB2C   DEC  SP             3B
#BB2D   RET  PE             E8
#BB2E   LD   B,#7F          067F
#BB30   LD   A,#10          3E10
#BB32   OUT  (C),A          ED79
#BB34   LD   A,#54          3E54
#BB36   OUT  (C),A          ED79
#BB38   RET  C              D8
#BB39   LD   B,#F6          06F6
#BB3B   XOR  A              AF
#BB3C   OUT  (C),A          ED79
#BB3E   LD   (IX+#00),#00   DD360000
#BB42   DEC  IX             DD2B
#BB44   JR   #BB3E          18F8
#BB46   DEC  A              3D
#BB47   JR   NZ,#BB46       20FD
#BB49   AND  A              A7
#BB4A   INC  H              24
#BB4B   RET  Z              C8
#BB4C   LD   B,#F5          06F5
#BB4E   IN   A,(C)          ED78
#BB50   XOR  C              A9
#BB51   AND  #80            E680
#BB53   JR   Z,#BB4A        28F5
#BB55   LD   B,#7F          067F
#BB57   LD   A,#10          3E10
#BB59   OUT  (C),A          ED79
#BB5B   LD   A,C            79
#BB5C   CPL                 2F
#BB5D   LD   C,A            4F
#BB5E   LD   A,C            79
#BB5F   RRA                 1F
#BB60   LD   A,#2A          3E2A
#BB62   RLA                 17
#BB63   OUT  (C),A          ED79
#BB65   SCF                 37
#BB66   RET                 C9
#BB67   LD   B,#F6          06F6
#BB69   LD   A,#10          3E10
#BB6B   OUT  (C),A          ED79
#BB6D   LD   HL,#BB2E       212EBB
#BB70   PUSH HL             E5
#BB71   LD   B,#F5          06F5
#BB73   IN   A,(C)          ED78
#BB75   AND  #80            E680
#BB77   LD   C,A            4F
#BB78   CALL #BB46          CD46BB
#BB7B   JR   NC,#BB78       30FB
#BB7D   LD   HL,#415        211504
#BB80   DJNZ #BB80          10FE
#BB82   DEC  HL             2B
#BB83   LD   A,H            7C
#BB84   OR   L              B5
#BB85   JR   NZ,#BB80       20F9
#BB87   LD   A,#0A          3E0A
#BB89   CALL #BB46          CD46BB
#BB8C   JR   NC,#BB78       30EA
#BB8E   LD   H,#C4          26C4
#BB90   LD   A,#1C          3E1C
#BB92   CALL #BB46          CD46BB
#BB95   JR   NC,#BB78       30E1
#BB97   LD   A,#DA          3EDA
#BB99   CP   H              BC
#BB9A   JR   C,#BB8E        38F2
#BB9C   LD   H,#C4          26C4
#BB9E   LD   A,#1C          3E1C
#BBA0   CALL #BB46          CD46BB
#BBA3   JR   NC,#BB78       30D3
#BBA5   LD   A,#DA          3EDA
#BBA7   CP   H              BC
#BBA8   JR   C,#BB8E        38E4
#BBAA   LD   IY,#BCBC       FD21BCBC
#BBAE   LD   L,(IY+#00)     FD6E00
#BBB1   LD   H,#C4          26C4
#BBB3   LD   A,#1C          3E1C
#BBB5   CALL #BB46          CD46BB
#BBB8   JR   NC,#BB78       30BE
#BBBA   LD   A,#D7          3ED7
#BBBC   CP   H              BC
#BBBD   JR   NC,#BB9C       30DD
#BBBF   INC  L              2C
#BBC0   JR   NZ,#BBB1       20EF
#BBC2   LD   H,#70          2670
#BBC4   LD   A,#1C          3E1C
#BBC6   CALL #BB46          CD46BB
#BBC9   JR   NC,#BB78       30AD
#BBCB   LD   A,#1C          3E1C
#BBCD   CALL #BB46          CD46BB
#BBD0   JR   NC,#BB78       30A6
#BBD2   LD   A,H            7C
#BBD3   CP   #CD            FECD
#BBD5   JR   NC,#BBE5       300E
#BBD7   CP   #9C            FE9C
#BBD9   JR   NC,#BBAA       30CF
#BBDB   INC  IY             FD23
#BBDD*  LD   A,L            FD7D
#BBDF   CP   #C0            FEC0
#BBE1   JR   NZ,#BBAE       20CB
#BBE3   JR   #BBAA          18C5
#BBE5   LD   A,#0B          3E0B
#BBE7   LD   H,#B0          26B0
#BBE9   LD   L,#08          2E08
#BBEB   LD   A,#0B          3E0B
#BBED   JR   #BBF1          1802
#BBEF   LD   A,#0C          3E0C
#BBF1   CALL #BB46          CD46BB
#BBF4   RET  NC             D0
#BBF5   NOP                 00
#BBF6   NOP                 00
#BBF7   LD   A,#0E          3E0E
#BBF9   CALL #BB46          CD46BB
#BBFC   RET  NC             D0
#BBFD   LD   A,#C5          3EC5
#BBFF   CP   H              BC
#BC00   RL   L              CB15
#BC02   LD   H,#B0          26B0
#BC04   JP   NC,#BBEF       D2EFBB
#BC07   LD   A,#1D          3E1D
#BC09   CP   L              BD
#BC0A   JP   NZ,#BB39       C239BB
#BC0D   NOP                 00
#BC0E   XOR  A              AF
#BC0F   EX   AF,AF          08
#BC10   LD   H,#C4          26C4
#BC12   LD   L,#01          2E01
#BC14   LD   A,#08          3E08
#BC16   JR   #BC2B          1813
#BC18   LD   (IX+#00),L     DD7500
#BC1B   INC  IX             DD23
#BC1D   DEC  DE             1B
#BC1E   LD   H,#C4          26C4
#BC20   LD   L,#01          2E01
#BC22   LD   L,#01          2E01
#BC24   NOP                 00
#BC25   LD   A,#05          3E05
#BC27   JR   #BC2B          1802
#BC29   LD   A,#0B          3E0B
#BC2B   CALL #BB46          CD46BB
#BC2E   RET  NC             D0
#BC2F   PUSH HL             E5
#BC30   LD   A,#0E          3E0E
#BC32   CALL #BB46          CD46BB
#BC35   POP  HL             E1
#BC36   RET  NC             D0
#BC37   LD   A,#CD          3ECD
#BC39   CP   H              BC
#BC3A   RL   L              CB15
#BC3C   LD   H,#C4          26C4
#BC3E   JP   NC,#BC29       D229BC
#BC41   EX   AF,AF          08
#BC42   XOR  L              AD
#BC43   EX   AF,AF          08
#BC44   LD   A,D            7A
#BC45   OR   E              B3
#BC46   JR   NZ,#BC18       20D0
#BC48   EX   AF,AF          08
#BC49   CP   #01            FE01
#BC4B   RET                 C9
#BC4C   PUSH IX             DDE5
#BC4E   CALL #BB67          CD67BB
#BC51   LD   HL,#8000       210080
#BC54   LD   B,#FF          06FF
#BC56   PUSH BC             C5
#BC57   LD   E,#00          1E00
#BC59   LD   C,E            4B
#BC5A   LD   D,#FF          16FF
#BC5C   LD   B,#F5          06F5
#BC5E   IN   A,(C)          ED78
#BC60   AND  #80            E680
#BC62   XOR  C              A9
#BC63   JR   Z,#BCB6        2851
#BC65   INC  E              1C
#BC66   LD   A,C            79
#BC67   CPL                 2F
#BC68   AND  #80            E680
#BC6A   LD   C,A            4F
#BC6B   DEC  D              15
#BC6C   JP   NZ,#BC5C       C25CBC
#BC6F   LD   (HL),E         73
#BC70   INC  HL             23
#BC71   POP  BC             C1
#BC72   DJNZ #BC56          10E2
#BC74   LD   HL,#00         210000
#BC77   LD   DE,#8032       113280
#BC7A   LD   B,#32          0632
#BC7C   PUSH BC             C5
#BC7D   LD   A,(DE)         1A
#BC7E   LD   B,#00          0600
#BC80   LD   C,A            4F
#BC81   ADD  HL,BC          09
#BC82   INC  DE             13
#BC83   POP  BC             C1
#BC84   DJNZ #BC7C          10F6
#BC86   PUSH HL             E5
#BC87   LD   HL,#00         210000
#BC8A   LD   DE,#80CD       11CD80
#BC8D   LD   B,#32          0632
#BC8F   PUSH BC             C5
#BC90   LD   A,(DE)         1A
#BC91   LD   B,#00          0600
#BC93   LD   C,A            4F
#BC94   ADD  HL,BC          09
#BC95   INC  DE             13
#BC96   POP  BC             C1
#BC97   DJNZ #BC8F          10F6
#BC99   POP  BC             C1
#BC9A   LD   A,H            7C
#BC9B   CP   #02            FE02
#BC9D   JR   NC,#BCB2       3013
#BC9F   AND  A              A7
#BCA0   SBC  HL,BC          ED42
#BCA2   LD   BC,#32         013200
#BCA5   AND  A              A7
#BCA6   SBC  HL,BC          ED42
#BCA8   RET  C              D8
#BCA9   ADD  HL,BC          09
#BCAA   LD   BC,#FFCD       01CDFF
#BCAD   AND  A              A7
#BCAE   SBC  HL,BC          ED42
#BCB0   RET  NC             D0
#BCB1   INC  A              3C
#BCB2   LD   (#BCBB),A      32BBBC
#BCB5   RET                 C9
#BCB6   NOP                 00
#BCB7   NOP                 00
#BCB8   JP   #BC6B          C36BBC
#BCBB   NOP                 00
#BCBC   LD   E,#22          1E22
#BCBE   INC  H              24
#BCBF   LD   H,#DD          26DD
#BCC1   LD   HL,#BF00       2100BF
#BCC4   LD   DE,#47         114700
#BCC7   CALL #BC4C          CD4CBC
#BCCA   LD   IX,#C000       DD2100C0
#BCCE   NOP                 00
#BCCF   NOP                 00
#BCD0   NOP                 00
#BCD1   NOP                 00
#BCD2   NOP                 00
#BCD3   NOP                 00
#BCD4   NOP                 00
#BCD5   NOP                 00
#BCD6   NOP                 00
#BCD7   NOP                 00
#BCD8   NOP                 00
#BCD9   NOP                 00
#BCDA   NOP                 00
#BCDB   NOP                 00
#BCDC   NOP                 00
#BCDD   NOP                 00
#BCDE   NOP                 00
#BCDF   NOP                 00
#BCE0   NOP                 00
#BCE1   NOP                 00
#BCE2   NOP                 00
#BCE3   NOP                 00
#BCE4   NOP                 00
#BCE5   NOP                 00
#BCE6   NOP                 00
#BCE7   NOP                 00
#BCE8   NOP                 00
#BCE9   NOP                 00
#BCEA   NOP                 00
#BCEB   NOP                 00
#BCEC   NOP                 00
#BCED   NOP                 00
#BCEE   ADD  A,C            81
