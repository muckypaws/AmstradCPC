;
currcomb DEFS 8,0                       ; Nudge Win Combination
n5       DEFB 0
n4       DEFB 0
n3       DEFB 0
n2       DEFB 0
n1       DEFB 0
mid      EQU  15
coingrid                                ; Coin Matrix
         DEFB 1,2,3,4,5,6
winlgrid
         DEFS 6,0
potcash  DEFS 24,255
wing     EQU  184
p10      EQU  186
p20      EQU  188
p50      EQU  190
p1       EQU  192
ptoken   EQU  194
p10l     EQU  196
p20l     EQU  198
p50l     EQU  200
p1l      EQU  202
ptokenl  EQU  204
einktble
         DEFB 0,#c0,#c,#cc,#30,#f0,#3c
         DEFB #fc,3,#c3,15,#cf,#33,#f3
         DEFB #3f,#ff
functab                                 ; Gaming Functions Table
         DEFW mystery
         DEFW spinawin
         DEFW skilcash
         DEFW cashfall
         DEFW numberun
         DEFW hilocash
         DEFW cashpot
         DEFW nudge
         DEFW repeater
repeatlc EQU  #df38+#51
repeatad                                ; Repeat Address Table
         DEFW repeatlc,repeatlc+5
         DEFW repeatlc+10,repeatlc+15
         DEFW repeatlc+20
nowin                                   ; If No NUDGES WIN
         DEFB 3
         DEFM ?SORRY?NO?WIN...?
         DEFB #ff
youvewun                                ; Message For Amount Won.
         DEFB 3
         DEFM ??CONGRATULATIONS?YOU'VE?
         DEFM WON??-??
         DEFB 11
wunm
         DEFS 80,"?"
         DEFB #ff
spaces   EQU  $-2
think                                   ; For Nudges When > 5
         DEFB 11
         DEFM ?THINKING...???
         DEFB #ff
spinawm
         DEFB 11
         DEFM ??HIT?START?TO?WIN?THE?SP
         DEFM IN..
         DEFB #ff
rept1
         DEFB 11
         DEFM ??HIT?RETURN?FOR?>2.40?OR
         DEFM ?
         DEFM >4.80?REPEATERS?N?FOR?BIG
         DEFM ?MONEY
         DEFB #ff
numbr1
         DEFB 11
         DEFM ?HIT?THE?HOLD?BUTTONS?
         DEFB 2
         DEFM 2?-?4
         DEFB 11
         DEFM ?TO?GET?THE?NUMBERS?FOR?X
         DEFM TRA?CASH?@@@
         DEFB #ff
game1
         DEFB 2
         DEFM ??MYSTERY?LOST.
         DEFB #ff
game2
         DEFB 2
         DEFM ??SPIN-A-WIN?LOST.
         DEFB #ff
game3
         DEFB 2
         DEFM ??SKILL?CASH?LOST.
         DEFB #ff
game4
         DEFB 5
         DEFM ??CASH-FALLS?LOST.
         DEFB #ff
game5
         DEFB 11
         DEFM ??NUMBERS?RUN?LOST.
         DEFB #ff
game6
         DEFB 11
         DEFM ??HI/LO?CASH?LOST.
         DEFB #ff
regstr                                  ; Register Display Key String
         DEFB 50,58,52,60
game7
         DEFB 11
         DEFM ??CASH?POT?LOST.
         DEFB #ff
game8
         DEFB 11
         DEFM ??NUDGES?LOST.
         DEFB #ff
game9
         DEFB 15
         DEFM ??REPEATERS?LOST.
         DEFB #ff
lost1    DEFB 2
         DEFM ??HE?HE?HE?YOU'VE?LOST?TH
         DEFM E?GAMBLE??FOOLS?AND?THERE
         DEFM ?MONEY?@@@
         DEFB #ff
lost2
         DEFB 2
         DEFM ??HA?HA?HA?THAT?WILL?TEAC
         DEFM H?YOU?TO?GAMBLE
         DEFB #ff
lost3
         DEFB 3
         DEFM ??THERE'S?ONLY?ONE?WINNER
         DEFM ,?
         DEFM ?AND?THAT?JUST?HAPPENS?TO
         DEFM ?BE?ME...
         DEFB #ff
lost4
         DEFB 3
         DEFM ??ONCE?AGAIN?YOU?LOSE?TO?
         DEFM ME,?
         DEFM HAVE?YOU?CONSIDERED?GA
         DEFM MBLERS?ANONYMOUS?@@@
         DEFB #ff
lost5
         DEFB 3
         DEFM ??YOU?ARE?BROKE
         DEFM ??AND?YOU?ARE?IN?DEBT?
         DEFM TO?THE?BANK.
         DEFB #FF
hicon                                   ; Hi-Score Congratulations
         DEFB 11
         DEFM BY?THE?WAY
         DEFM ?YOU?WALK?AWAY
         DEFM ?WITH?TODAY'S?HIGHEST?WIN
         DEFM ?@@@
         DEFB #ff
byebye                                  ; Ta For Playing Sucker !
         DEFB 11
         DEFM ?THANK?YOU?FOR?PLAYING?
         DEFB 2
         DEFM SLOT?5?
         DEFB 11
         DEFM I?HOPE?TO?SEE?YOU?AGAIN?S
         DEFM OON?...???
         DEFB #FF
hello
         DEFB 11
         DEFM ?EXCELLENT?TO?SEE?YOU?...
         DEFB #ff
info     DEFB 3
         DEFM ??MACHINE?CURRENTLY?ON?
         DEFB 5
ppc      DEFM ??
         DEFB 3
         DEFM ?PERCENT?PAYOUT.?MACH
         DEFM INES?MEAN?STATUS?IS?
         DEFB 5,"O"
pms      DEFM ???
         DEFB 3
         DEFM MEGA?CASH?SUPRESSION?IS?
         DEFB 5,"O"
pms1     DEFM ???
         DEFB 3
         DEFM ...
         DEFB #ff
gamelt   DEFW game1,game2,game3,game4
         DEFW game5,game6,game7,game8
         DEFW game9
funcadtb                                ; Function Screen Address Table
         DEFW #ce40,#f550,#dcb0,#c410
         DEFW #eb20,#d280,#f990,#e0f0
         DEFW #c850
row1off  EQU  0
row2off  EQU  #e
row3off  EQU  #1c
row1len  EQU  #e
row2len  EQU  #1c-#e
row3len  EQU  #28-#1c
row1bf   DEFS 9,0
row2bf   DEFS 9,0
row3bf   DEFS 9,0
row1bfo  DEFS 9,0
row2bfo  DEFS 9,0
row3bfo  DEFS 9,0
hilofs                                  ; Hilo Offsets
         DEFB 1,2,4,6,9,12,18
         DEFB 35,34,32,30,27,24,18
hiloscad                                ; HI / LO Screen Address Table
         DEFW #c173,#c973,#d973,#e973
         DEFW #c1c3,#d9c3,#ca13
gwsat    DEFB #48,#e8,#89,#2a,#ca,#6b
         DEFB #c,#ac,#4d,#ed,#8e,#2f
gtrail   DEFB 0,1,2
gtrailo  DEFW 0
         DEFB 7,8,9,10,11
gmoney   DEFB 48,24,20,18,16,14,12,10
         DEFB 8,6,4,0
gwin     DEFB 0                         ; Gamble High Screen Addre
gwun     DEFB 0
glose    DEFB 0                         ; Gamble Low ScrADD
trailfo  DEFS 12,0                      ; Original Trail Flags
trailfc  DEFS 12,0                      ; Trail Flag Control
lose     EQU  $-1
gtimings
         DEFB 0,1,3,5,7,9,11,12,13,14
         DEFB 15,15
wintable
         DEFB 6,8,6,6,16,10,18,10,48
         DEFB 24,8,20,10,12
winlbuff DEFS 9,0                       ; 3*3 Win Line Buffers
reeldtb                                 ; Reel Directions Table
         DEFB 0,%11111,%10101,%1010
         DEFB %10001,%100,%1110,0
count    DEFB 6
count1   DEFB 6
count2   DEFW 0
losttble                                ; Table For LOST MESSAGES
         DEFW lost1,lost2,lost3
         DEFW lost4,lost5
reel1spd DEFB 1                         ; Reel Speeds
reel2spd DEFB 2                         ; Reel 2 Speed
reel3spd DEFB 3                         ; Reel 3 Speed
reel4spd DEFB 4                         ; Reel 4 Speed
reel5spd DEFB 5                         ; Reel 5 Spd
holdt    DEFW #ec12,#cdaf,#eefd
         DEFW #ef0a,#ef17
reeloffs                                ; Reel Speed Offsets
         DEFB 1,2,4,6,12,18
         DEFB 35,34,32,30,24,18
nudgesac                                ; Reel Nudge accelleration Sequence
         DEFB 1,1,1,1,1,1,1,1,2,2,2,2
         DEFB 3,3,4,3,1,1
reelofs1
         DEFB 1,2,4,6,12,18
         DEFB 71,70,68,66,60,54
reelofs2
         DEFB 1,2,4,6,12,18
         DEFB 107,106,104,102,96,90
DigitalN DEFW #70,0
hscore   DEFB 0,5,1,1
hardinks DEFB 20,4,21,28,24,29,12,5
         DEFB 13,22,6,23,30,0,31
         DEFB 14,7,15,18,2,19,26,25
         DEFB 27,10,3,11
inks     DEFB 0,6,15,25,22,18,12,1,2
         DEFB 5,11,26,24,4,3,7
sprload  EQU  #40
dig1     DEFW #c00a,#c011,#c01a,#c021
accelsqn                                ; Acceleration Sequence
         DEFB 1,1,1,1,2,2,2,3,3,4,5
reel1sad                                ; Reel 1 Screen Address Table For Scrol
         DEFW #dbc2
         DEFW #d3c2,#cbc2,#fb72
         DEFW #eb72,#fb22,#cb22
reel1sau
         DEFW #c282
         DEFW #ca82,#da82,#ea82
         DEFW #dad2,#cb22
reel2sad
         DEFW #fd0f
         DEFW #f50f,#ed0f,#dd0f
         DEFW #cd0f,#dcbf,#ec6f
reel2sau
         DEFW #c28f,#ca8f,#da8f
         DEFW #ea8f,#dadf,#cb2f
reel3sad
         DEFW #deac
         DEFW #d6ac,#ceac,#fe5c
         DEFW #ee5c,#fe0c,#ce0c
reel3sau
         DEFW #c29c,#ca9c,#da9c
         DEFW #ea9c,#daec,#cb3c
reel4sad
         DEFW #deb9
         DEFW #d6b9,#ceb9,#fe69
         DEFW #ee69,#fe19,#ce19
reel4sau
         DEFW #e3e9,#ebe9,#fbe9
         DEFW #cc39,#fc39,#ec89
reel5sad
         DEFW #dec6
         DEFW #d6c6,#cec6,#fe76
         DEFW #ee76,#fe26,#ce26
reel5sau
         DEFW #c586,#cd86,#dd86
         DEFW #ed86,#ddd6,#ce26
reel1bfd DEFS 11*36,0
reel2bfd DEFS 11*36,0
reel3bfd DEFS 11*36,0
reel4bfd DEFS 11*36,0
reel5bfd DEFS 11*36,0
moved1   DEFB 0
moved2   DEFB 0
moved3   DEFB 0
moved4   DEFB 0
moved5   DEFB 0
reel1adp DEFW 0
reel2adp DEFW 0
reel3adp DEFW 0
reel4adp DEFW 0
reel5adp DEFW 0
roff     EQU  35*11
nfrtpr   EQU  29                        ; Number Of Fruits Per Reel
ree1adpf EQU  roff+reel1bfd
ree2adpf EQU  roff+reel2bfd
ree3adpf EQU  roff+reel3bfd
ree4adpf EQU  roff+reel4bfd
ree5adpf EQU  roff+reel5bfd
ree1aupf EQU  reel1bfd
ree2aupf EQU  reel2bfd
ree3aupf EQU  reel3bfd
ree4aupf EQU  reel4bfd
ree5aupf EQU  reel5bfd
reelt1
         DEFB 104,24,16,8,80,96,16,24
         DEFB 88,40,0,16,32,72,104,16
         DEFB 8,16,56,24,80,32,8,0,16
         DEFB 48,24,80,40
reelt2
         DEFB 16,68,8,88,107,18,96,8,25
         DEFB 16,32,1,24,56,74,16,56
         DEFB 97,0,16,11,48,83,0,89,16
         DEFB 80,42,24
reelt3
         DEFB 41,16,24,9,72,56,91,96,16
         DEFB 0,8,16,40,2,80,48,16,4
         DEFB 56,64,16,24,104,88,24,81
         DEFB 16,48,32
reelt4
         DEFB 64,80,3,24,16,96,28,16,74
         DEFB 105,80,0,91,16,49,24,32
         DEFB 16,67,16,8,82,32,28,72
         DEFB 104,17,56,40
reelt5
         DEFB 72,32,16,24,8,96,88,56,16
         DEFB 24,40,0,8,16,32,80,104,24
         DEFB 16,0,8,40,96,56,16,24
         DEFB 80,48,88
rel1addd EQU  reelt1+mid
rel2addd EQU  reelt2+mid
rel3addd EQU  reelt3+mid
rel4addd EQU  reelt4+mid+1
rel5addd EQU  reelt5+mid+2
rel1addu EQU  reelt1+mid+2
rel2addu EQU  reelt2+mid+3
rel3addu EQU  reelt3+mid+4
rel4addu EQU  reelt4+mid+4
rel5addu EQU  reelt5+mid+4
welcomem                                ; Welcome Message
         DEFB 1
         DEFM ????WELCOME?TO?
         DEFB 11
         DEFM SLOT?
         DEFB 3
         DEFM 5
         DEFB 1
         DEFM ?
         DEFM FRUIT?MACHINE?SIMULATOR??
         DEFB 11
         DEFM WRITTEN?BY?-?
         DEFB 3
         DEFM THE?ARGONAUT?
         DEFB 11
         DEFM -?
         DEFB 2
         DEFM (C)?1990?JACESOFT?SOFTWAR
         DEFM E?LTD,??
         DEFB 5
         DEFM WELL?AS?YOU?CAN?SEE?THIS?
         DEFM FRUIT?MACHINE?SIMULATOR?IS
         DEFM ?SLIGHTLY?DIFFERENT?TO?TH
         DEFM E?CONVENTIONAL?ONES?C
         DEFM URRENTLY?SEEN?ON?THE?MARK
         DEFM ET?
         DEFB 4
         DEFM THIS?HAS?5?REELS?STAGGERE
         DEFM D?IN?3?SETS?OF?THREE?
         DEFB 1
         DEFM THEREFORE?WITH?3?WINLINES
         DEFM ?YOU?SHOULD?NOT?LOSE?@@@??
         DEFB 10
         DEFM TO?PLAY?THE?GAME?SIMPLY?P
         DEFM RESS?THE?=
         DEFB 5
         DEFM P
         DEFB 10
         DEFM <?KEY???
         DEFB 2
         DEFM TO?SPIN?THE?REELS?PRESS?=
         DEFB 5
         DEFM RETURN
         DEFB 2
         DEFM <?
         DEFB 4
         DEFM TO?HOLD?THE?REELS?PRESS?K
         DEFM EYS?=
         DEFB 10
         DEFM 1?-?5?
         DEFB 4
         DEFM <?
         DEFB 12
         DEFM SHOULD?YOU?FIND?THAT?YOU?
         DEFM HAVE?WON?THEN?YOU?HAVE?THE
         DEFM ?OPTION?OF?GAMBLING?YOUR?W
         DEFM INNINGS?FOR?A?LARGER?AMOUN
         DEFM T,?THE?CONSEQUENCE?OF?THE
         DEFM ?GAMBLE?IS?THAT?THERE?IS?T
         DEFM HE?POSSIBILITY?YOU?COULD?L
         DEFM OSE?ALL?OF?YOUR?WINNINGS?O
         DEFM R?ONLY?A?SMALL?PORTION.??
         DEFB 11
         DEFM NO?MORE?THAN?>4.80?MAY?BE
         DEFM ?WON?FROM?THIS?MACHINE?IN?
         DEFM ANY?ONE?GAME?@??
         DEFB 1
         DEFM TO?GAMBLE?YOUR?WINNINGS?P
         DEFM RESS?=
         DEFB 3
         DEFM RETURN
         DEFB 1
         DEFM <?TO?COLLECT?PRESS?=
         DEFB 3
         DEFM C?OR?T
         DEFB 1
         DEFM <
         DEFB 12
         DEFM ?WELL?NOW?THE?INTRODUCTIO
         DEFM N?IS?OVER?TIME?FOR?ANOTHER
         DEFM ?ONE?OF?THOSE?LONG?BORING
         DEFM ?SCROLLING?MESSAGES?FULL?
         DEFM OF?USELESS?INFORMATION,?
         DEFB 1
         DEFM DID?YOU?KNOW?
         DEFB 2
         DEFM THAT?THERE?IS?A?SYSTEM?TO
         DEFM ?BEAT?FRUIT?MACHINES?FOUN
         DEFM D?IN?AMUSEMENT?ARCADES?,
         DEFM PUBS,?AND?CLUBS?ETC.,??
         DEFB 11
         DEFM ONE?THING?YOU?MUST?ALWAYS
         DEFM ?REMEMBER?IS?THAT?A?MACHI
         DEFM NE?WILL?ONLY?GIVE?YOU?AS?M
         DEFM UCH?AS?IT?WANTS?:?
         DEFB 3
         DEFM THE?BEST?TIME?TO?GO?ON?A?
         DEFM MACHINE?IS?AFTER?SOME?UNFO
         DEFM RTUNATE?SOLE?HAS?PUT?>5?TO
         DEFM ?>10?INTO?IT?AND?WALKED?AW
         DEFM AY?WITH?NOTHING?THIS?MEANS
         DEFM ?THAT?THE?MACHINE?HAS?BEEN
         DEFM ?PRIMED?AND?THE?POSSIBILIT
         DEFM Y?OF?YOU?WINNING?IS?GREAT
         DEFM ER?
         DEFB 5
         DEFM ALSO?ALMOST?ALWAYS?GAMBLE
         DEFM ?YOUR?WINNINGS?DON'T?BOTH
         DEFM ER?TIMING?SEQUENCES?BECAU
         DEFM SE?NO?MATTER?WHEN?YOU?PRE
         DEFM SS?THE?GAMBLE?BUTTON?THE?
         DEFM MACHINE?WILL?GIVE?YOU?WHA
         DEFM T?
         DEFB 1
         DEFM IT
         DEFB 5
         DEFM ?WANTS?TO?GIVE?NOT?WHAT?Y
         DEFM OU?WANT?IT?TO?STOP?ON
         DEFB 3
         DEFM ?ALSO?TRY?AND?HOLD?NUMBER
         DEFM S?-?IF?THE?MACHINE?HAS?THE
         DEFM M?-?AS?EVERY?ONE?COUNTS
         DEFB 4
         DEFM ?TRY?AND?TAKE?YOUR?MYSTE
         DEFM RY?PRIZES?AS?SOMETIMES?IT?
         DEFM WILL?GIVE?YOU?AS?MUCH?AS?>
         DEFM 2?ALTHOUGH?MORE?OFTEN?THAN
         DEFM ?NOT?IT?WILL?GIVE?YOU?40P?
         DEFB 1
         DEFM ANY?WAY?ENOUGH?OF?THAT?.?
         DEFM IF?YOU?LIKE?THIS?GAME?THEN
         DEFM ?PLEASE?LET?US?KNOW,?IF?YO
         DEFM U?HAVE?WRITTEN?A?GOOD?QUAL
         DEFM ITY?ARCADE?GAME?THEN?SEND?
         DEFM IT?TO?US?FOR?EVALUATION,?O
         DEFM THER?PROGRAMS?IN?OUR?TITL
         DEFM ES?INCLUDE?
         DEFB 2
         DEFM CHOICE?CHEATS?1-5?
         DEFB 11
         DEFM THESE?ARE?SMALL?PROGRAMS?
         DEFM TO?ENABLE?YOU?TO?COMPLETE?
         DEFM MANY?OF?THE?COMMERCIAL?GAM
         DEFM ES?ON?THE?MARKET?AND?ARE?A
         DEFM N?ESSENTIAL?PIECE?OF?GEAR.
         DEFM ??ALSO?I?MAKE?NO?APOLOGIES
         DEFM ?FOR?THE?PATHETIC?SOUND?TH
         DEFM AT?ACCOMPANIES?THIS?GAME?B
         DEFM ECAUSE?I?CAN?NOT?WRITE?SOU
         DEFM ND?ROUTINES?AND?AM?NOT?MUS
         DEFM ICALLY?MINDED?HOWEVER?I?AM
         DEFM ?LOOKING?FOR?SOMEONE?THAT?
         DEFM CAN?WRITE?SOUND?IN?MACHIN
         DEFM E?CODE?PREFERABLY?NOT?USIN
         DEFM G?FIRMWARE,?IF?YOU?CAN?THE
         DEFM N?PLEASE?CONTACT?ME??C/O
         DEFM ?1ST?CHOICE?SOFTWARE?LTD.?
         DEFM 4?PAUL?ROW?TEMPLE?LANE?,?
         DEFM LITTLEBOROUGH,?LANCS,?OL15
         DEFM ?9QG???
         DEFB #ff
;
