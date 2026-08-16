;===========================================================================
; WestWing.asm  
;
; WestWingLayout            Size 128 Byte, Start Byte   0
; WestWingTile              Size  32 Byte, Start Byte 128
; WestWingBackground        Size   9 Byte, Start Byte 160
; WestWingFloor             Size   9 Byte, Start Byte 169
; WestWingWall              Size   9 Byte, Start Byte 178
; WestWingNasty             Size   9 Byte, Start Byte 187
; WestWingRamp              Size   9 Byte, Start Byte 196
; WestWingConveyor          Size   9 Byte, Start Byte 205
; WestWingConveyorData      Size   4 Byte, Start Byte 214
; WestWingRampData          Size   4 Byte, Start Byte 218
; WestWingBorderColor       Size   1 Byte, Start Byte 222
; WestWingReserved          Size   4 Byte, Start Byte 223
; WestWingItem		        Size   8 Byte, Start Byte 227
; WestWingDirection         Size   4 Byte, Start Byte 235
; WestWingUnused            Size   1 Byte, Start Byte 239
; WestWingEnemy1		    Size   5 Byte, Start Byte 240
; WestWingEnemy2		    Size   5 Byte, Start Byte 245
; WestWingEnemy3		    Size   5 Byte, Start Byte 250
; WestWingEnemy4		    Size   5 Byte, Start Byte 255
; WestWingEnemy5		    Size   5 Byte, Start Byte 260
; WestWingEnemy6		    Size   5 Byte, Start Byte 265
; WestWingEnemy7		    Size   5 Byte, Start Byte 270
; WestWingEnemy8		    Size   5 Byte, Start Byte 275
; WestWingPosWilly          Size   2 Byte, Start Byte 280
; WestWingEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (WestWing)
WestWingLayout:           
	DEFB 0,160,0,0,0,0,0,0	;Room layout
	DEFB 0,160,0,0,0,0,0,0
	DEFB 0,160,0,0,0,0,0,0
	DEFB 85,160,0,0,0,0,0,0
	DEFB 0,160,0,0,0,0,0,0
	DEFB 0,160,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 85,85,85,80,0,85,85,85
	DEFB 0,0,0,0,2,170,170,170
	DEFB 0,0,0,0,10,170,170,170
	DEFB 0,0,0,0,42,170,170,170
	
WestWingTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "           West  Wing           "   ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
WestWingBackground:                    
    DEFB 7,0,0,0,0,0,0,0,0	            ;Background

WestWingFloor:
    DEFB 65,249,255,63,213,170,21,74,132     ; Floor Solid

WestWingWall:
    DEFB 39,172,174,1,173,173,2,172,232  ; Wall Solid

WestWingNasty:
    DEFB 255,0,0,0,0,0,0,0,0  ; Nastry

WestWingRamp:
    DEFB 7,3,3,12,12,48,48,192,192       ; Ramp Solid

WestWingConveyor:
    DEFB 255,0,0,0,0,0,0,0,0                  ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
WestWingConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
WestWingRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24560                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 16	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
WestWingBorderColor:
    DEFB 1	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
WestWingReserved:
    DEFB CYAN, YELLOW, RED, NONE     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
WestWingItem:
    DEFB 0,0,0,0,0,0,0,0                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
WestWingDirection:
	ROOM RoomsListTable.WestBedroomLayout			;Room to the left (West Bedroom)
	ROOM RoomsListTable.SwimmingPoolLayout			;Room to the right (Swimming Pool)
	ROOM RoomsListTable.WestWingRoofLayout			;Room above (West Wing Roof)
	ROOM RoomsListTable.BackStairwayLayout			;Room below (Back Stairway)

WestWingUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
WestWingEnemy1:
    DEFB $C0, MURO, 112, 0, 96       
WestWingEnemy2:
    DEFB $D0, CANDELABRO, 32, 40, 56 
WestWingEnemy3:
    DEFB $B0, UCCELLO, 0, 80, 80 
WestWingEnemy4:
    DEFB 0, 0, 0, 0, 0
WestWingEnemy5:
    DEFB 0, 0, 0, 0, 0
WestWingEnemy6:
    DEFB 0, 0, 0, 0, 0
WestWingEnemy7:
    DEFB 0, 0, 0, 0, 0
WestWingEnemy8:
    DEFB 0, 0, 0, 0, 0

WestWingPosWilly:
    db 80, 60                     ; Posizione di Willy
    
WestWingEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8