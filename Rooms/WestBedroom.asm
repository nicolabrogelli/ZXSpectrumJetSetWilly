;===========================================================================
; WestBedroom.asm  
;
; WestBedroomLayout            Size 128 Byte, Start Byte   0
; WestBedroomTile              Size  32 Byte, Start Byte 128
; WestBedroomBackground        Size   9 Byte, Start Byte 160
; WestBedroomFloor             Size   9 Byte, Start Byte 169
; WestBedroomWall              Size   9 Byte, Start Byte 178
; WestBedroomNasty             Size   9 Byte, Start Byte 187
; WestBedroomRamp              Size   9 Byte, Start Byte 196
; WestBedroomConveyor          Size   9 Byte, Start Byte 205
; WestBedroomConveyorData      Size   4 Byte, Start Byte 214
; WestBedroomRampData          Size   4 Byte, Start Byte 218
; WestBedroomBorderColor       Size   1 Byte, Start Byte 222
; WestBedroomReserved          Size   4 Byte, Start Byte 223
; WestBedroomItem		        Size   8 Byte, Start Byte 227
; WestBedroomDirection         Size   4 Byte, Start Byte 235
; WestBedroomUnused            Size   1 Byte, Start Byte 239
; WestBedroomEnemy1		    Size   5 Byte, Start Byte 240
; WestBedroomEnemy2		    Size   5 Byte, Start Byte 245
; WestBedroomEnemy3		    Size   5 Byte, Start Byte 250
; WestBedroomEnemy4		    Size   5 Byte, Start Byte 255
; WestBedroomEnemy5		    Size   5 Byte, Start Byte 260
; WestBedroomEnemy6		    Size   5 Byte, Start Byte 265
; WestBedroomEnemy7		    Size   5 Byte, Start Byte 270
; WestBedroomEnemy8		    Size   5 Byte, Start Byte 275
; WestBedroomPosWilly          Size   2 Byte, Start Byte 280
; WestBedroomEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (WestBedroom)
WestBedroomLayout:           
	DEFB 0,0,4,0,160,64,0,0		;Room layout
	DEFB 0,0,0,0,160,64,0,0
	DEFB 0,0,16,0,160,64,0,0
	DEFB 0,0,0,0,160,64,0,21
	DEFB 0,0,4,0,160,64,0,0
	DEFB 0,0,0,0,160,64,0,0
	DEFB 0,0,0,16,160,64,0,0
	DEFB 0,0,0,0,160,64,0,0
	DEFB 0,0,4,0,0,64,0,0
	DEFB 0,0,0,0,0,64,0,0
	DEFB 0,0,16,0,0,64,0,0
	DEFB 0,0,8,0,0,64,0,0
	DEFB 0,0,9,85,85,85,85,85
	DEFB 0,0,10,170,160,0,0,0
	DEFB 0,0,0,0,160,0,0,0
	DEFB 0,0,0,0,160,0,0,0
	
WestBedroomTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "    West Bedroom                "   ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
WestBedroomBackground:                    
    DEFB 7,0,0,0,0,0,0,0,0	            ;Background

WestBedroomFloor:
    DEFB 6,170,85,130,65,130,65,130,65     ; Floor Solid

WestBedroomWall:
    DEFB 13,168,85,168,86,207,46,38,193  ; Wall Solid

WestBedroomNasty:
    DEFB 255,0,0,0,0,0,0,0,0  ; Nastry

WestBedroomRamp:
    DEFB 255,0,0,0,0,0,0,0,0       ; Ramp Solid

WestBedroomConveyor:
    DEFB 66,165,255,189,170,85,186,69,131                  ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
WestBedroomConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 24186	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 3	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
WestBedroomRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 0                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 0	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
WestBedroomBorderColor:
    DEFB 5	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
WestBedroomReserved:
    DEFB CYAN, RED, NONE, NONE     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
WestBedroomItem:
    DEFB 0,0,0,0,0,0,0,0                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
WestBedroomDirection:
	DEFB BLOCK	                                        ;Room to the left (The Off Licence)
	ROOM RoomsListTable.WestWingLayout		            ;Room to the right (West  Wing)
	ROOM RoomsListTable.AbovetheWestBedroomLayout		;Room above (Above the West Bedroom)
	ROOM RoomsListTable.BackDoorLayout		            ;Room below (Back Door)

WestBedroomUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
WestBedroomEnemy1:
    DEFB $C0, 0, 88, 0, 64         
WestBedroomEnemy2:
    DEFB $D0, 41, 112, 0, 80 
WestBedroomEnemy3:
    DEFB 0, 0, 0, 0, 0
WestBedroomEnemy4:
    DEFB 0, 0, 0, 0, 0 
WestBedroomEnemy5:
    DEFB 0, 0, 0, 0, 0
WestBedroomEnemy6:
    DEFB 0, 0, 0, 0, 0
WestBedroomEnemy7:
    DEFB 0, 0, 0, 0, 0
WestBedroomEnemy8:
    DEFB 0, 0, 0, 0, 0

WestBedroomPosWilly:
    db 160, 50                     ; Posizione di Willy
    
WestBedroomEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8