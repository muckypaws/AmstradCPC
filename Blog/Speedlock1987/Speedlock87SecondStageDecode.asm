#B11F   LD   HL,#2020       212020
#B122   JR   NZ,#B144       2020
#B124   JR   NZ,#B146       2020
#B126   JR   NZ,#B148       2020
#B128   JR   NZ,#B14A       2020
#B12A   JR   NZ,#B14C       2020
#B12C   JR   NZ,#B14E       2020
#B12E   LD   HL,#FF02       2102FF
#B131   LD   (BC),A         02
#B132   XOR  #01            EE01
#B134   LD   B,B            40
#B135   NOP                 00
#B136   NOP                 00
#B137   XOR  #01            EE01
#B139   LD   B,B            40
#B13A   NOP                 00
#B13B   NOP                 00
#B13C   NOP                 00
#B13D   NOP                 00
#B13E   NOP                 00
#B13F   NOP                 00
#B140   NOP                 00
#B141   NOP                 00
#B142   NOP                 00
#B143   NOP                 00
#B144   NOP                 00
#B145   NOP                 00
#B146   NOP                 00
#B147   RRA                 1F
#B148   LD   R,A            ED4F
#B14A   POP  BC             C1
#B14B   POP  HL             E1
#B14C   LD   D,H            54
#B14D   LD   E,L            5D
#B14E   EX   (SP),HL        E3
#B14F   LD   A,I            ED57
#B151   CALL PO,#AC00       E400AC
#B154   LD   A,R            ED5F
#B156   XOR  (HL)           AE
#B157   LD   (HL),A         77
#B158   LDI                 EDA0
#B15A   RET  PO             E0
#B15B   DEC  SP             3B
#B15C   DEC  SP             3B
#B15D   RET  PE             E8
#B15E   NOP                 00
#B15F   INC  BC             03
