;===========================================================================
; EastWallBase.asm  
;
; EastWallBase Layout            Size 128 Byte, Start Byte   0
; EastWallBase Tile              Size  32 Byte, Start Byte 128
; EastWallBase Background        Size   9 Byte, Start Byte 160
; EastWallBase Floor             Size   9 Byte, Start Byte 169
; EastWallBase Wall              Size   9 Byte, Start Byte 178
; EastWallBase Nasty             Size   9 Byte, Start Byte 187
; EastWallBase Ramp              Size   9 Byte, Start Byte 196
; EastWallBase Conveyor          Size   9 Byte, Start Byte 205
; EastWallBase ConveyorData      Size   4 Byte, Start Byte 214
; EastWallBase RampData          Size   4 Byte, Start Byte 218
; EastWallBase BorderColor       Size   1 Byte, Start Byte 222
; EastWallBase Reserved          Size   4 Byte, Start Byte 223
; EastWallBase Item		         Size   8 Byte, Start Byte 227
; EastWallBase Direction         Size   4 Byte, Start Byte 235
; EastWallBase Unused            Size   1 Byte, Start Byte 239
; EastWallBase Enemy1		     Size   5 Byte, Start Byte 240
; EastWallBase Enemy2		     Size   5 Byte, Start Byte 245
; EastWallBase Enemy3		     Size   5 Byte, Start Byte 250
; EastWallBase Enemy4		     Size   5 Byte, Start Byte 255
; EastWallBase Enemy5		     Size   5 Byte, Start Byte 260
; EastWallBase Enemy6		     Size   5 Byte, Start Byte 265
; EastWallBase Enemy7		     Size   5 Byte, Start Byte 270
; EastWallBase Enemy8		     Size   5 Byte, Start Byte 275
; EastWallBase PosWilly          Size   2 Byte, Start Byte 280
; EastWallBase EnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (West Of Kitchen)
EastWallBaseLayout:           
	DEFB 160,0,10,0,0,0,0,0	;Room layout
	DEFB 160,0,10,0,0,0,0,0
	DEFB 160,0,10,0,0,0,0,0
	DEFB 160,0,10,0,0,0,0,0
	DEFB 160,0,26,0,0,0,0,0
	DEFB 160,4,10,0,0,0,0,0
	DEFB 160,0,10,0,0,0,0,0
	DEFB 164,0,10,0,0,0,0,0
	DEFB 160,4,0,0,0,0,0,0
	DEFB 160,0,0,0,0,0,0,0
	DEFB 160,0,26,0,0,0,0,0
	DEFB 160,16,10,0,0,0,0,0
	DEFB 160,0,10,0,0,0,0,0
	DEFB 160,4,10,0,0,0,0,0
	DEFB 160,0,26,0,0,0,0,0
	DEFB 160,64,10,0,0,0,0,0

EastWallBaseTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "         East Wall Base         "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
EastWallBaseBackground:                    ; Background
    DEFB 7,0,0,0,0,0,0,0,0	            ;Background

EastWallBaseFloor:
    DEFB 5,91,164,164,85,10,0,0,0       ; Floor Solid

EastWallBaseWall:
    DEFB 38,89,37,38,217,41,214,84,150   ; Wall Solid

EastWallBaseNasty:
    DEFB 255,0,0,0,0,0,0,0,0  ; Nastry

EastWallBaseRamp:
    DEFB 255,0,0,0,0,0,0,0,0              ; Ramp Solid

EastWallBaseConveyor:
    DEFB 255,0,0,0,0,0,0,0,0                      ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
EastWallBaseConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
EastWallBaseRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 0                                  ;Location in the attribute buffer at 24064: (14,7)
    DEFB 0	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
EastWallBaseBorderColor:
    DEFB 5	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
EastWallBaseReserved:
    DEFB RED, MAGENTA, NONE, NONE     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
EastWallBaseItem:
    DEFB 0,0,0,0,0,0,0,0	                ;Item graphic (unused)

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
EastWallBaseDirection:
	DEFB 27					;Room to the left (The Chapel)
	DEFB BLOCK				;Room to the right (The Off Licence)
	DEFB 32					;Room above (Halfway up the East Wall)
	DEFB 20					;Room below (Ballroom East)

EastWallBaseUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
EastWallBaseEnemy1:
    DEFB $C0, 6, 56, 0, 104
EastWallBaseEnemy2:
    DEFB $C0, 32, 24, 0, 96         
EastWallBaseEnemy3:
    DEFB 0, 0, 0, 0, 0          
EastWallBaseEnemy4:
    DEFB 0, 0, 0, 0, 0  
EastWallBaseEnemy5:
    DEFB 0, 0, 0, 0, 0  
EastWallBaseEnemy6:
    DEFB 0, 0, 0, 0, 0
EastWallBaseEnemy7:
    DEFB 0, 0, 0, 0, 0
EastWallBaseEnemy8:
    DEFB 0, 0, 0, 0, 0

EastWallBasePosWilly:
    db 20, 20                     ; Posizione di Willy
    
EastWallBaseEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8