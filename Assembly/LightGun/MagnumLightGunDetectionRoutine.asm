                ORG     #8000
;
                JP      GetScreenCoords		      ; Get X,Y Co-Ordinates of LightGun                  
                JP      CheckTrigger   		      ; Check If Trigger Pressed               
XCoord:		      DEFB 0   			                  ; Store X Address (Each Represents two bytes)                          
YCoord:         DEFB 0				                  ; Store Y Address (Each Represents 8 Scan Lines)
Temp1:		      DEFW 0                          ; Work Area 1

GunFired:       DEFB 0				                  ; Flag for Trigger Pressed    
GetScreenCoords:                         
                LD      HL,&FFFF                
                LD      (XCoord),HL  		        ; Set X & Y To Invalid 255,255            
                CALL    &BC0B  			            ; Get The screen offset (Hardware Scroll)
						                                    ; HL = Current Offset, A = MSB of Base Address                 
                SRL     H 			                      
                RR      L                       ; HL = HL / 2
                LD      (ScreenOffset),HL  	    ; Store Half Value of Offset          
                SRL     A                       
                SRL     A                       ; A = A / 4
                OR      H        		            ; Or H	               
                LD      (BaseScreenAddress),A   ; Store Modified Screen Offset 	           
                CALL    &BD19        		        ; Call FrameFly Back (Wait for CRT to finish)
           
                DI                       	      ; Disable Interrupts       
                LD      B,&BC                   
                LD      A,&0C                   
                OUT     (C),A    		            ; Select CRT Register 12 (Display Address High)               
                LD      A, (BaseScreenAddress)  ; Get Base Screen Address             
                OR      &08                     ; Set Bit 4
                LD      B,&BD         		      ; Set Screen to Offset          
                OUT     (C),A                   ; Writing to #BDxx
                LD      C,&FF                   
                LD      DE,&FEE4
RequestReg16:                
                LD      B,&BC                   
                LD      A,&10                   ; Request CRT Register 16 (Light Pen Address High)
                OUT     (C),A         		          
                LD      B,&BF 
ReadRegister16:                  
                IN      A,(C)                   ; Read Register #BFxx
                LD      H,A                     ; Preserve CRT High Register Value
                AND     &08                     ; Is Bit 4 Set?
                JR      NZ,ReadLightPenLow 	    ; If Set, Read Register 17 (Light Pen Low Address)               
                DEC     IX   			              ; Waste Cycles                   
                INC     E        		               
                JR      NZ,ReadRegister16       ; Perform 26 Cycles... then 256
                INC     D                       
                LD      A,&05                   ; Perform 7 More Cycles 
                CP      D                       
                JR      NZ,ReadRegister16   	  ; Continue to Read Register 16		             
                INC     C                       
                JR      NZ, CalculatePosition	  ; Calculate Position of LightGun                
                EI                              ; Enable Interrupts
                RET                             ; Quit to Caller
ReadLightPenLow:
                LD      B,&BC  			                 
                LD      A,&11                   
                OUT     (C),A                   ; Request register #BCxx,17
                LD      B,&BF                   
                IN      L,(C)                   ; Read Register
                LD      IY,(RegisteredAddress)              
                LD      (RegisteredAddress),HL  ; H = High Address, L = Low Addres            
                LD      (Temp1),DE              ; Store DE in Temp Work Area (Not Used)
                INC     C                       
                LD      A,&0A                   
                CP      C                       ; Waste More Cycles until C = 10 (255 Iterations)
                JR      NZ,RequestReg16  
CalculatePosition:              
                DI                              
                LD      B,&BC                   
                LD      A,&0C                   
                OUT     (C),A        		        ; Request CRT Register 12 (Screen Base Address)           
                LD      A,(BaseScreenAddress)               
                AND     &F7                     
                LD      B,&BD                   
                OUT     (C),A    		            ; Write Screen Offset Address Back               
                CALL    CheckTrigger		        ; Has the Trigger Been Pressed?                   
                LD      A,(GunFired)               
                OR      A			                  ; Check Trigger Flag                     
                RET     Z    			              ; Quit if Not Pressed                   

                LD      HL,(RegisteredAddress) 	; Get Registered Address            
                CALL    Adjust                  ; Divide by 40 and Adjust for Half Screen Offset
                PUSH    AF                      ; A = Y COORD
                PUSH    IY                      
                POP     HL                      ; HL = IY
                CALL    Adjust                  ; Divide by 40 and adjust for screen offset 
                LD      (XCoord),A              ; Set X-Coord This time
                POP     AF                      ; Restore A
                CP      L                       
                RET     NC                      ; if A >= L then finish

                LD      (XCoord),A              ; Otherwise Store Lower Value
                RET         

; Inefficient Routine to work out Block X, Y Position of the Lightgun    
Adjust:
                LD      A,H                    	; Get High Address 
                AND     &03                 	  ; Mask first Two Bits   
                LD      H,A           		      ; For H to mask two low bits          
                LD      DE,&0003  		              
                SBC     HL,DE       		        ; Subtract 3 from HL            
                XOR     A    			              ; Reset A                   
                LD      DE,(ScreenOffset)      	; Load Screen Offset        
                SBC     HL,DE        		           
                JR      NC,Adjust2                
                LD      DE,&0400                
                ADD     HL,DE 			            ; Add #400
Adjust2:                  
                LD      DE,&0028   		          ; DE = 40 (Half Line Width)             
                XOR     A   
Adjust3:                    
                SBC     HL,DE        		        ; Subtract 40           
                JR      C,Adjust4      		           
                INC     A                       
                JR      Adjust3 		            ; Inefficient / 40 to find X-Coord
Adjust4:                  
                ADD     HL,DE    		            ; Add 40 back so not in fraction               
                LD      (YCoord),A           	  ; Store in Y-Coord    
                LD      A,L                   	; A = L  (Remainder)
                RET                             

; Check if Light Gun Trigger has been pressed

CheckTrigger:   CALL    &BD19       		        ; Wait for Frame Fly Back            
                DI                              ; Disable Interrupts
                LD      B,&BC                   
                LD      A,&11                   
                OUT     (C),A                   ; Write to CRT Register 17
                LD      B,&BF                   
                IN      A,(C)                   
                LD      E,A   			            ; Read Register Status                  
                LD      BC,&FBFE                
                LD      A,&7F                   
                OUT     (C),A   		            ; Send Low Signal to Light Gun                
                LD      A,&80                   
                OUT     (C),A                   ; Send Leading Edge Signal to Light Gun
                LD      B,&BF                   
                IN      A,(C)                   ; Read CRT Register 17 again
                EI                              ; Re-Enable Interrupts
                CP      E                       ; Was the OLD Register and New Register Equal?
                LD      A,&FF                   ; Set Fire Flag Status in Readiness
                JR      Z,&80F1         	      ; If Equal Jump to Write Flag        
                XOR     A                       ; Zero Out Flag
                LD      (GunFired),A            ; Write Flag
                RET                             ; Return to Caller

BaseScreenAddress: 	defb 0			                ; Base Screen Address
ScreenOffset:		defw 0			                    ; Define Screen Offset


RegisteredAddress: DEFW 0
