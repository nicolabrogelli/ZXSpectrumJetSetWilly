;===========================================================================
; BackDoor.asm  
;
; BackDoorLayout            Size 128 Byte, Start Byte   0
; BackDoorTile              Size  32 Byte, Start Byte 128
; BackDoorBackground        Size   9 Byte, Start Byte 160
; BackDoorFloor             Size   9 Byte, Start Byte 169
; BackDoorWall              Size   9 Byte, Start Byte 178
; BackDoorNasty             Size   9 Byte, Start Byte 187
; BackDoorRamp              Size   9 Byte, Start Byte 196
; BackDoorConveyor          Size   9 Byte, Start Byte 205
; BackDoorConveyorData      Size   4 Byte, Start Byte 214
; BackDoorRampData          Size   4 Byte, Start Byte 218
; BackDoorBorderColor       Size   1 Byte, Start Byte 222
; BackDoorReserved          Size   4 Byte, Start Byte 223
; BackDoorItem		        Size   8 Byte, Start Byte 227
; BackDoorDirection         Size   4 Byte, Start Byte 235
; BackDoorUnused            Size   1 Byte, Start Byte 239
; BackDoorEnemy1		    Size   5 Byte, Start Byte 240
; BackDoorEnemy2		    Size   5 Byte, Start Byte 245
; BackDoorEnemy3		    Size   5 Byte, Start Byte 250
; BackDoorEnemy4		    Size   5 Byte, Start Byte 255
; BackDoorEnemy5		    Size   5 Byte, Start Byte 260
; BackDoorEnemy6		    Size   5 Byte, Start Byte 265
; BackDoorEnemy7		    Size   5 Byte, Start Byte 270
; BackDoorEnemy8		    Size   5 Byte, Start Byte 275
; BackDoorPosWilly          Size   2 Byte, Start Byte 280
; BackDoorEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (BackDoor)
BackDoorLayout:           
	DEFB 0,0,0,0,160,0,0,0	;Room layout
	DEFB 0,0,0,0,160,0,0,0
	DEFB 0,0,0,0,160,0,0,0
	DEFB 0,0,0,0,160,0,0,0
	DEFB 0,0,0,0,160,0,0,0
	DEFB 0,0,0,0,160,0,0,0
	DEFB 0,0,0,0,160,0,0,0
	DEFB 0,0,0,0,160,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,5,85,85,85,85
	DEFB 0,0,0,42,160,0,0,0
	DEFB 0,0,0,170,160,0,0,0
	DEFB 0,0,2,170,160,0,0,0
	DEFB 0,0,10,170,160,0,0,0
	
BackDoorTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "            Back Door           "   ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
BackDoorBackground:                    
    DEFB 7,0,0,0,0,0,0,0,0	            ;Background

BackDoorFloor:
    DEFB 3,255,255,255,170,85,170,85,0     ; Floor Solid

BackDoorWall:
    DEFB 38,105,210,165,75,150,45,90,180  ; Wall Solid

BackDoorNasty:
    DEFB 255,0,0,0,0,0,0,0,0  ; Nastry

BackDoorRamp:
    DEFB 7,3,3,13,15,54,61,218,244       ; Ramp Solid

BackDoorConveyor:
    DEFB 34,240,240,240,240,102,102,0,0                  ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
BackDoorConveyorData:
    DEFB 1	                                ;Direction (right)
    DEFW 24562	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 14	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
BackDoorRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24553                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 5	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
BackDoorBorderColor:
    DEFB 1	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
BackDoorReserved:
    DEFB NONE, NONE, NONE, NONE     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
BackDoorItem:
    DEFB 0,0,0,0,0,0,0,0                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
BackDoorDirection:
	DEFB BLOCK	;Room to the left (The Off Licence)
	ROOM RoomsListTable.BackStairwayLayout		;Room to the right (Back Stairway)
	ROOM RoomsListTable.WestBedroomLayout		;Room above (West Bedroom)
	ROOM RoomsListTable.ToolShedLayout		;Room below (Tool  Shed)

BackDoorUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
BackDoorEnemy1:
    DEFB 0, 0, 0, 0, 0
BackDoorEnemy2:
    DEFB 0, 0, 0, 0, 0
BackDoorEnemy3:
    DEFB 0, 0, 0, 0, 0
BackDoorEnemy4:
    DEFB 0, 0, 0, 0, 0
BackDoorEnemy5:
    DEFB 0, 0, 0, 0, 0
BackDoorEnemy6:
    DEFB 0, 0, 0, 0, 0
BackDoorEnemy7:
    DEFB 0, 0, 0, 0, 0
BackDoorEnemy8:
    DEFB 0, 0, 0, 0, 0

BackDoorPosWilly:
    db 200, 60                     ; Posizione di Willy
    
BackDoorEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8