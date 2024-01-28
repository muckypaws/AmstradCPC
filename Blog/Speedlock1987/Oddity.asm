                ;; JavaCPC disassembled binary
                ;; disassembled from #BC4C to #BCB5
                ;; Sat Jan 27 16:46:45 GMT 2024

                ORG     #BC4C

                PUSH    IX                      ;;BC4C:   ..      DD E5
                CALL    &BB67                   ;;BC4E:   .g.     CD 67 BB
                LD      HL,&8000                ;;BC51:   !..     21 00 80
                LD      B,&FF                   ;;BC54:   ..      06 FF
                PUSH    BC                      ;;BC56:   .       C5
                LD      E,&00                   ;;BC57:   ..      1E 00
                LD      C,E                     ;;BC59:   K       4B
                LD      D,&FF                   ;;BC5A:   ..      16 FF
                LD      B,&F5                   ;;BC5C:   ..      06 F5
                IN      A,(C)                   ;;BC5E:   .x      ED 78
                AND     &80                     ;;BC60:   ..      E6 80
                XOR     C                       ;;BC62:   .       A9
                JR      Z,&BCB6                 ;;BC63:   (Q      28 51
                INC     E                       ;;BC65:   .       1C
                LD      A,C                     ;;BC66:   y       79
                CPL                             ;;BC67:   /       2F
                AND     &80                     ;;BC68:   ..      E6 80
                LD      C,A                     ;;BC6A:   O       4F
                DEC     D                       ;;BC6B:   .       15
                JP      NZ,&BC5C                ;;BC6C:   .\.     C2 5C BC
                LD      (HL),E                  ;;BC6F:   s       73
                INC     HL                      ;;BC70:   #       23
                POP     BC                      ;;BC71:   .       C1
                DJNZ    &BC56                   ;;BC72:   ..      10 E2
                LD      HL,&0000                ;;BC74:   !..     21 00 00
                LD      DE,&8032                ;;BC77:   .2.     11 32 80
                LD      B,&32                   ;;BC7A:   .2      06 32
                PUSH    BC                      ;;BC7C:   .       C5
                LD      A,(DE)                  ;;BC7D:   .       1A
                LD      B,&00                   ;;BC7E:   ..      06 00
                LD      C,A                     ;;BC80:   O       4F
                ADD     HL,BC                   ;;BC81:   .       09
                INC     DE                      ;;BC82:   .       13
                POP     BC                      ;;BC83:   .       C1
                DJNZ    &BC7C                   ;;BC84:   ..      10 F6
                PUSH    HL                      ;;BC86:   .       E5
                LD      HL,&0000                ;;BC87:   !..     21 00 00
                LD      DE,&80CD                ;;BC8A:   ...     11 CD 80
                LD      B,&32                   ;;BC8D:   .2      06 32
                PUSH    BC                      ;;BC8F:   .       C5
                LD      A,(DE)                  ;;BC90:   .       1A
                LD      B,&00                   ;;BC91:   ..      06 00
                LD      C,A                     ;;BC93:   O       4F
                ADD     HL,BC                   ;;BC94:   .       09
                INC     DE                      ;;BC95:   .       13
                POP     BC                      ;;BC96:   .       C1
                DJNZ    &BC8F                   ;;BC97:   ..      10 F6
                POP     BC                      ;;BC99:   .       C1
                LD      A,H                     ;;BC9A:   |       7C
                CP      &02                     ;;BC9B:   ..      FE 02
                JR      NC,&BCB2                ;;BC9D:   0.      30 13
                AND     A                       ;;BC9F:   .       A7
                SBC     HL,BC                   ;;BCA0:   .B      ED 42
                LD      BC,&0032                ;;BCA2:   .2.     01 32 00
                AND     A                       ;;BCA5:   .       A7
                SBC     HL,BC                   ;;BCA6:   .B      ED 42
                RET     C                       ;;BCA8:   .       D8

                ADD     HL,BC                   ;;BCA9:   .       09
                LD      BC,&FFCD                ;;BCAA:   ...     01 CD FF
                AND     A                       ;;BCAD:   .       A7
                SBC     HL,BC                   ;;BCAE:   .B      ED 42
                RET     NC                      ;;BCB0:   .       D0

                INC     A                       ;;BCB1:   <       3C
                LD      (&BCBB),A               ;;BCB2:   2..     32 BB BC
                RET                             ;;BCB5:   .       C9

