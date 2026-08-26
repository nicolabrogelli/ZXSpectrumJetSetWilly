;===========================================================================
; TheFrontDoor.asm  
;
; TheFrontDoorLayout            Size 128 Byte, Start Byte   0
; TheFrontDoorTile              Size  32 Byte, Start Byte 128
; TheFrontDoorBackground        Size   9 Byte, Start Byte 160
; TheFrontDoorFloor             Size   9 Byte, Start Byte 169
; TheFrontDoorWall              Size   9 Byte, Start Byte 178
; TheFrontDoorNasty             Size   9 Byte, Start Byte 187
; TheFrontDoorRamp              Size   9 Byte, Start Byte 196
; TheFrontDoorConveyor          Size   9 Byte, Start Byte 205
; TheFrontDoorConveyorData      Size   4 Byte, Start Byte 214
; TheFrontDoorRampData          Size   4 Byte, Start Byte 218
; TheFrontDoorBorderColor       Size   1 Byte, Start Byte 222
; TheFrontDoorReserved          Size   4 Byte, Start Byte 223
; TheFrontDoorItem		        Size   8 Byte, Start Byte 227
; TheFrontDoorDirection         Size   4 Byte, Start Byte 235
; TheFrontDoorUnused            Size   1 Byte, Start Byte 239
; TheFrontDoorEnemy1		    Size   5 Byte, Start Byte 240
; TheFrontDoorEnemy2		    Size   5 Byte, Start Byte 245
; TheFrontDoorEnemy3		    Size   5 Byte, Start Byte 250
; TheFrontDoorEnemy4		    Size   5 Byte, Start Byte 255
; TheFrontDoorEnemy5		    Size   5 Byte, Start Byte 260
; TheFrontDoorEnemy6		    Size   5 Byte, Start Byte 265
; TheFrontDoorEnemy7		    Size   5 Byte, Start Byte 270
; TheFrontDoorEnemy8		    Size   5 Byte, Start Byte 275
; TheFrontDoorPosWilly          Size   2 Byte, Start Byte 280
; TheFrontDoorEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (The Front Door)
TheFrontDoorLayout:           
	DEFB 0,0,0,0,0,0,0,0	;Room layout
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 170,170,170,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 85,0,0,0,0,0,0,0
	DEFB 170,0,0,0,0,0,0,0

TheFrontDoorTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "         The Front Door         "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
TheFrontDoorBackground:                    ; Background
    DEFB 47,0,0,0,0,0,0,0,0	            		;Background

TheFrontDoorFloor:
    DEFB 71,255,170,119,170,119,170,85,170       ; Floor Solid

TheFrontDoorWall:
    DEFB 58,32,16,14,193,48,9,198,32   ; Wall Solid

TheFrontDoorNasty:
    DEFB 255,0,0,0,0,0,0,0,0  ; Nastry

TheFrontDoorRamp:
    DEFB 47,192,64,176,80,172,84,171,85              ; Ramp Solid

TheFrontDoorConveyor:
    DEFB 255,0,0,0,0,0,0,0,0                      ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
TheFrontDoorConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
TheFrontDoorRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: none
    DEFB 0	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
TheFrontDoorBorderColor:
    DEFB 2	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
TheFrontDoorReserved:
    DEFB RED, NONE, NONE, NONE     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
TheFrontDoorItem:
    DEFB 12,28,28,30,27,63,120,255	         ;Item graphic (unused)

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
TheFrontDoorDirection:
	ROOM RoomsListTable.TheHallLayout				    ;Room to the left (The Hall)
	ROOM RoomsListTable.OnABranchOverTheDriveLayout		;Room to the right (On a Branch Over the Drive)
	ROOM RoomsListTable.TheOffLicenceLayout				;Room above (The Off Licence)
	ROOM RoomsListTable.TheSecurityGuardLayout			;Room below (The Security Guard)

TheFrontDoorUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
TheFrontDoorEnemy1:
    DEFB $80, UCCELLO, 8, 50, 200  
TheFrontDoorEnemy2:
    DEFB 0, 0, 0, 0, 0              ; Empty slot
TheFrontDoorEnemy3:
    DEFB 0, 0, 0, 0, 0              ; Empty slot
TheFrontDoorEnemy4:
    DEFB 0, 0, 0, 0, 0              ; Empty slot
TheFrontDoorEnemy5:
    DEFB 0, 0, 0, 0, 0
TheFrontDoorEnemy6:
    DEFB 0, 0, 0, 0, 0
TheFrontDoorEnemy7:
    DEFB 0, 0, 0, 0, 0
TheFrontDoorEnemy8:
    DEFB 0, 0, 0, 0, 0

TheFrontDoorPosWilly:
    db 50, 24                     ; Posizione di Willy
TheFrontDoorEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8