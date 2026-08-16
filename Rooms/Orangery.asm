;===========================================================================
; Orangery.asm  
;
; OrangeryLayout            Size 128 Byte, Start Byte   0
; OrangeryTile              Size  32 Byte, Start Byte 128
; OrangeryBackground        Size   9 Byte, Start Byte 160
; OrangeryFloor             Size   9 Byte, Start Byte 169
; OrangeryWall              Size   9 Byte, Start Byte 178
; OrangeryNasty             Size   9 Byte, Start Byte 187
; OrangeryRamp              Size   9 Byte, Start Byte 196
; OrangeryConveyor          Size   9 Byte, Start Byte 205
; OrangeryConveyorData      Size   4 Byte, Start Byte 214
; OrangeryRampData          Size   4 Byte, Start Byte 218
; OrangeryBorderColor       Size   1 Byte, Start Byte 222
; OrangeryReserved          Size   4 Byte, Start Byte 223
; OrangeryItem		        Size   8 Byte, Start Byte 227
; OrangeryDirection         Size   4 Byte, Start Byte 235
; OrangeryUnused            Size   1 Byte, Start Byte 239
; OrangeryEnemy1		    Size   5 Byte, Start Byte 240
; OrangeryEnemy2		    Size   5 Byte, Start Byte 245
; OrangeryEnemy3		    Size   5 Byte, Start Byte 250
; OrangeryEnemy4		    Size   5 Byte, Start Byte 255
; OrangeryEnemy5		    Size   5 Byte, Start Byte 260
; OrangeryEnemy6		    Size   5 Byte, Start Byte 265
; OrangeryEnemy7		    Size   5 Byte, Start Byte 270
; OrangeryEnemy8		    Size   5 Byte, Start Byte 275
; OrangeryPosWilly          Size   2 Byte, Start Byte 280
; OrangeryEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (Orangery)
OrangeryLayout:           
	DEFB 0,0,0,0,0,0,0,0	;Room layout
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,1,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,64,0,16,0
	DEFB 0,0,0,0,0,4,0,64
	DEFB 0,0,0,0,0,0,0,0
	DEFB 160,0,0,4,0,0,0,0
	DEFB 0,0,0,0,1,0,0,0
	DEFB 0,32,0,64,0,0,5,0
	DEFB 0,36,0,0,64,0,0,85
	DEFB 0,32,0,0,0,0,16,0
	DEFB 0,32,1,0,0,0,0,0
	DEFB 0,32,0,0,0,64,0,0
	DEFB 170,170,0,1,64,0,0,0
	
OrangeryTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "            Orangery            "   ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
OrangeryBackground:                    
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

OrangeryFloor:
    DEFB 4,165,74,36,2,4,0,2,0      ; Floor Solid

OrangeryWall:
    DEFB 22,21,85,85,36,37,85,73,34  ; Wall Solid

OrangeryNasty:
    DEFB 6,130,65,62,106,183,25,37,68  ; Nastry

OrangeryRamp:
    DEFB 5,1,2,4,0,16,32,64,128          ; Ramp Solid

OrangeryConveyor:
    DEFB 38,198,170,168,42,89,36,0,0                    ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
OrangeryConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 24412	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 4	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
OrangeryRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24480                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 14	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
OrangeryBorderColor:
    DEFB 6	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
OrangeryReserved:
    DEFB CYAN, RED, NONE, NONE     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
OrangeryItem:
    DEFB 2,20,46,85,42,69,42,20                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
OrangeryDirection:
	ROOM RoomsListTable.WestWingRoofLayout				;Room to the left (West Wing Roof)
	ROOM RoomsListTable.ABitOfTreeLayout				;Room to the right (A bit of tree)
	ROOM RoomsListTable.ConservatoryRoofLayout				;Room above (Conservatory Roof)
	ROOM RoomsListTable.SwimmingPoolLayout				;Room below (Swimming Pool)

OrangeryUnused:
    DEFB $0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
OrangeryEnemy1:
    DEFB $C0, IPNOSI, 160, 0, 96  
OrangeryEnemy2:
    DEFB $C0, FACCIA_PALLA, 72, 64, 104
OrangeryEnemy3:
    DEFB 0, 0, 0, 0, 0
OrangeryEnemy4:
    DEFB 0, 0, 0, 0, 0
OrangeryEnemy5:
    DEFB 0, 0, 0, 0, 0
OrangeryEnemy6:
    DEFB 0, 0, 0, 0, 0
OrangeryEnemy7:
    DEFB 0, 0, 0, 0, 0
OrangeryEnemy8:
    DEFB 0, 0, 0, 0, 0

OrangeryPosWilly:
    db 5, 48                     ; Posizione di Willy
    
OrangeryEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8