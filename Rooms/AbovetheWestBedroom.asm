;===========================================================================
; AbovetheWestBedroom.asm  
;
; AbovetheWestBedroomLayout            Size 128 Byte, Start Byte   0
; AbovetheWestBedroomTile              Size  32 Byte, Start Byte 128
; AbovetheWestBedroomBackground        Size   9 Byte, Start Byte 160
; AbovetheWestBedroomFloor             Size   9 Byte, Start Byte 169
; AbovetheWestBedroomWall              Size   9 Byte, Start Byte 178
; AbovetheWestBedroomNasty             Size   9 Byte, Start Byte 187
; AbovetheWestBedroomRamp              Size   9 Byte, Start Byte 196
; AbovetheWestBedroomConveyor          Size   9 Byte, Start Byte 205
; AbovetheWestBedroomConveyorData      Size   4 Byte, Start Byte 214
; AbovetheWestBedroomRampData          Size   4 Byte, Start Byte 218
; AbovetheWestBedroomBorderColor       Size   1 Byte, Start Byte 222
; AbovetheWestBedroomReserved          Size   4 Byte, Start Byte 223
; AbovetheWestBedroomItem		        Size   8 Byte, Start Byte 227
; AbovetheWestBedroomDirection         Size   4 Byte, Start Byte 235
; AbovetheWestBedroomUnused            Size   1 Byte, Start Byte 239
; AbovetheWestBedroomEnemy1		    Size   5 Byte, Start Byte 240
; AbovetheWestBedroomEnemy2		    Size   5 Byte, Start Byte 245
; AbovetheWestBedroomEnemy3		    Size   5 Byte, Start Byte 250
; AbovetheWestBedroomEnemy4		    Size   5 Byte, Start Byte 255
; AbovetheWestBedroomEnemy5		    Size   5 Byte, Start Byte 260
; AbovetheWestBedroomEnemy6		    Size   5 Byte, Start Byte 265
; AbovetheWestBedroomEnemy7		    Size   5 Byte, Start Byte 270
; AbovetheWestBedroomEnemy8		    Size   5 Byte, Start Byte 275
; AbovetheWestBedroomPosWilly          Size   2 Byte, Start Byte 280
; AbovetheWestBedroomEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (AbovetheWestBedroom)
AbovetheWestBedroomLayout:           
	DEFB 0,0,0,0,0,0,0,0	;Room layout
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,21,85
	DEFB 0,0,0,0,0,0,208,0
	DEFB 0,0,0,0,0,3,16,0
	DEFB 0,0,0,0,0,12,16,0
	DEFB 0,0,0,0,0,48,16,0
	DEFB 0,0,0,0,1,85,85,85
	DEFB 0,0,0,0,3,0,0,0
	DEFB 0,0,4,0,12,0,0,0
	DEFB 0,0,0,0,160,0,0,0
	DEFB 0,0,16,0,160,85,85,64
	
AbovetheWestBedroomTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "   Above the West Bedroom       "   ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
AbovetheWestBedroomBackground:                    
    DEFB 7,0,0,0,0,0,0,0,0	            ;Background

AbovetheWestBedroomFloor:
    DEFB 4,247,170,85,239,0,0,0,0    ; Floor Solid

AbovetheWestBedroomWall:
    DEFB 35,170,85,170,85,170,85,170,85  ; Wall Solid

AbovetheWestBedroomNasty:
    DEFB 6,48,96,192,128,0,0,0,0  ; Nastry

AbovetheWestBedroomRamp:
    DEFB 7,1,0,6,9,19,6,108,152      ; Ramp Solid

AbovetheWestBedroomConveyor:
    DEFB 255,0,0,0,0,0,0,0,0                  ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
AbovetheWestBedroomConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
AbovetheWestBedroomRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24497                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 8	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
AbovetheWestBedroomBorderColor:
    DEFB 2	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
AbovetheWestBedroomReserved:
    DEFB CYAN, RED, NONE, NONE     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
AbovetheWestBedroomItem:
    DEFB 8,16,32,33,18,172,64,32                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
AbovetheWestBedroomDirection:
	DEFB BLOCK	;Room to the left (The Off Licence)
	ROOM RoomsListTable.WestWingRoofLayout		;Room to the right (West Wing Roof)
	DEFB BLOCK	;Room above (The Off Licence)
	ROOM RoomsListTable.WestBedroomLayout		;Room below (West Bedroom)

AbovetheWestBedroomUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
AbovetheWestBedroomEnemy1:
    DEFB $C0, VECCHIA, 88, 16, 80        
AbovetheWestBedroomEnemy2:
    DEFB $D0, PALAZZO, 112, 0, 80 
AbovetheWestBedroomEnemy3:
    DEFB 0, 0, 0, 0, 0
AbovetheWestBedroomEnemy4:
    DEFB 0, 0, 0, 0, 0
AbovetheWestBedroomEnemy5:
    DEFB 0, 0, 0, 0, 0
AbovetheWestBedroomEnemy6:
    DEFB 0, 0, 0, 0, 0
AbovetheWestBedroomEnemy7:
    DEFB 0, 0, 0, 0, 0
AbovetheWestBedroomEnemy8:
    DEFB 0, 0, 0, 0, 0

AbovetheWestBedroomPosWilly:
    db 220, 50                       ; Posizione di Willy
    
AbovetheWestBedroomEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8