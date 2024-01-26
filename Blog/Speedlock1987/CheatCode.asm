                ;; JavaCPC disassembled binary
                ;; disassembled from #9FE8 to #A017
                ;; Tue Jan 23 17:44:50 GMT 2024

                ORG     #9FE8

                LD      HL,&0040                ;;9FE8:   !@.     21 40 00
                PUSH    HL                      ;;9FEB:   .       E5
                LD      HL,&BB00                ;;9FEC:   !..     21 00 BB
                PUSH    HL                      ;;9FEF:   .       E5
                JP      &3A4B                   ;;9FF0:   .K:     C3 4B 3A
                LD      A,&5B                   ;;9FF3:   >[      3E 5B
                LD      (&004B),A               ;;9FF5:   2K.     32 4B 00
                LD      A,&99                   ;;9FF8:   >.      3E 99
                LD      (&004E),A               ;;9FFA:   2N.     32 4E 00
                DI                              ;;9FFD:   .       F3
                POP     AF                      ;;9FFE:   .       F1
                RET                             ;;9FFF:   .       C9

                DI                              ;;A000:   .       F3
                LD      IX,&BF00                ;;A001:   .!..    DD 21 00 BF
                LD      DE,&0046                ;;A005:   .F.     11 46 00
                CALL    &BB67                   ;;A008:   .g.     CD 67 BB
                LD      HL,&A014                ;;A00B:   !..     21 14 A0
                LD      (&BF44),HL              ;;A00E:   "D.     22 44 BF
                JP      &BF00                   ;;A011:   ...     C3 00 BF
                CALL    &BD37                   ;;A014:   .7.     CD 37 BD
                JP      &7381                   ;;A017:   ..s     C3 81 73
