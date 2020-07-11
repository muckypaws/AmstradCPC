
;
         ORG  #4000                     ; 6128+ Converter Written By J. Brooks 
start                                   ; (C) 1991 JacesofT Software Ltd.
         ENT  $
         LD   hl,cpm
         CALL rsx
         LD   de,#c1a9
         AND  a
         SBC  hl,de
         RET  nz
         LD   hl,ctrlc
         CALL rsx
         LD   (#9952),hl
         LD   hl,ctrld
         CALL rsx
         LD   (#99e6),hl
         LD   hl,ctrla
         CALL rsx
         LD   (#9c69),hl
         LD   hl,ctrli
         CALL rsx
         LD   (#9c6c),hl
         LD   hl,ctrlg
         CALL rsx
         LD   (#9c6f),hl
         LD   hl,ctrle
         CALL rsx
         LD   (#9c72),hl
         LD   hl,#c9d8
         LD   (#a037),hl
         LD   (#a054),hl
;
         LD   hl,#c988
         LD   (#a086),hl
         LD   (#a08a),hl
         LD   (#a090),hl
         LD   (#a096),hl
         LD   (#a09c),hl
         LD   (#a0a2),hl
         LD   (#a0a8),hl
;
         LD   (#a0cc),hl
;
         LD   hl,#c985
         LD   (#a0ad),hl
;
         LD   hl,#c935
         LD   (#a0bf),hl
;
         LD   hl,#c6ec
         LD   (#a0d8),hl
;
         LD   hl,ctrlf
         CALL rsx
         LD   (#a175),hl
;
         LD   hl,#cac9
         LD   (#a185),hl
         LD   (#a1b1),hl
         LD   (#a1ba),hl
         LD   (#a1c2),hl
         LD   (#a1ed),hl
         LD   (#a1f5),hl
         LD   (#a1fd),hl
;
         LD   hl,ctrld
         CALL rsx
         LD   (#a347),hl
         RET  
;
ctrla    DEFB #81
ctrlb    DEFB #82
ctrlc    DEFB #83
ctrld    DEFB #84
ctrle    DEFB #85
ctrlf    DEFB #86
ctrlg    DEFB #87
ctrlh    DEFB #88
ctrli    DEFB #89
rsx      EQU  #bcd4
;
         DEFM Conversion By JASON BROO
         DEFM KS (C) 1991 JacesofT. Fo
         DEFM r GOLDMARK SYSTEMS.  
cpm      DEFM CP
         DEFB "M"+#80
