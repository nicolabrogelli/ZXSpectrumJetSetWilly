;===========================================================================
; TopLanding.asm  
;
; TopLandingLayout            Size 128 Byte, Start Byte   0
; TopLandingTile              Size  32 Byte, Start Byte 128
; TopLandingBackground        Size   9 Byte, Start Byte 160
; TopLandingFloor             Size   9 Byte, Start Byte 169
; TopLandingWall              Size   9 Byte, Start Byte 178
; TopLandingNasty             Size   9 Byte, Start Byte 187
; TopLandingRamp              Size   9 Byte, Start Byte 196
; TopLandingConveyor          Size   9 Byte, Start Byte 205
; TopLandingConveyorData      Size   4 Byte, Start Byte 214
; TopLandingRampData          Size   4 Byte, Start Byte 218
; TopLandingBorderColor       Size   1 Byte, Start Byte 222
; TopLandingReserved          Size   4 Byte, Start Byte 223
; TopLandingItem		        Size   8 Byte, Start Byte 227
; TopLandingDirection         Size   4 Byte, Start Byte 235
; TopLandingUnused            Size   1 Byte, Start Byte 239
; TopLandingEnemy1		    Size   5 Byte, Start Byte 240
; TopLandingEnemy2		    Size   5 Byte, Start Byte 245
; TopLandingEnemy3		    Size   5 Byte, Start Byte 250
; TopLandingEnemy4		    Size   5 Byte, Start Byte 255
; TopLandingEnemy5		    Size   5 Byte, Start Byte 260
; TopLandingEnemy6		    Size   5 Byte, Start Byte 265
; TopLandingEnemy7		    Size   5 Byte, Start Byte 270
; TopLandingEnemy8		    Size   5 Byte, Start Byte 275
; TopLandingPosWilly          Size   2 Byte, Start Byte 280
; TopLandingEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (Top Landing)
TopLandingLayout:           
	DEFB 170,170,170,170,170,170,170,170	;Room layout
	DEFB 170,170,170,170,170,170,170,170
	DEFB 160,0,0,0,0,0,0,10
	DEFB 160,0,0,0,0,0,0,0
	DEFB 165,80,85,5,85,85,0,0
	DEFB 160,0,0,0,0,0,170,170
	DEFB 160,0,0,0,0,0,0,10
	DEFB 160,0,0,0,0,0,0,10
	DEFB 165,80,85,5,85,0,0,10
	DEFB 160,0,0,0,0,0,0,10
	DEFB 160,0,0,0,0,0,0,10
	DEFB 160,0,0,0,0,0,0,10
	DEFB 165,80,85,5,64,0,0,10
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 85,85,85,85,85,5,85,85
	
TopLandingTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "          Top Landing           "   ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
TopLandingBackground:                    
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

TopLandingFloor:
    DEFB 6,255,170,85,255,0,0,0,0      ; Floor Solid

TopLandingWall:
    DEFB 26,105,144,144,105,150,105,105,150  ; Wall Solid

TopLandingNasty:
    DEFB 255,0,0,0,0,0,0,0,0  ; Nastry

TopLandingRamp:
    DEFB 7,7,2,60,8,112,32,192,128           ; Ramp Solid

TopLandingConveyor:
    DEFB 7,0,0,0,0,0,0,0,0                      ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
TopLandingConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
TopLandingRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24433                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 7	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
TopLandingBorderColor:
    DEFB 1	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
TopLandingReserved:
    DEFB CYAN, CYAN, RED, MAGENTA     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
TopLandingItem:
    DEFB 24,36,164,202,149,10,21,10	                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
TopLandingDirection:
	DEFB 35			;Room to the left (Master Bedroom)
	DEFB 33			;Room to the right (The Bathroom)
	DEFB 40			;Room above (Dr Jones will never believe this)
	DEFB 28			;Room below (First Landing)

TopLandingUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
TopLandingEnemy1:
    DEFB $80, 22, 192, 64, 240         ; [Frate (41496) - horizontal], Guardian = 67, Starts X=16, Y=32, Limit X=88
TopLandingEnemy2:
    DEFB 0, 0, 0, 0, 0
TopLandingEnemy3:
    DEFB 0, 0, 0, 0, 0
TopLandingEnemy4:
    DEFB 0, 0, 0, 0, 0
TopLandingEnemy5:
    DEFB 0, 0, 0, 0, 0
TopLandingEnemy6:
    DEFB 0, 0, 0, 0, 0
TopLandingEnemy7:
    DEFB 0, 0, 0, 0, 0
TopLandingEnemy8:
    DEFB 0, 0, 0, 0, 0

TopLandingPosWilly:
    db 200, 104                     ; Posizione di Willy
    
TopLandingEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8