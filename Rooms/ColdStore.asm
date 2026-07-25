;===========================================================================
; ColdStore.asm  
;
; ColdStore Layout            Size 128 Byte, Start Byte   0
; ColdStore Tile              Size  32 Byte, Start Byte 128
; ColdStore Background        Size   9 Byte, Start Byte 160
; ColdStore Floor             Size   9 Byte, Start Byte 169
; ColdStore Wall              Size   9 Byte, Start Byte 178
; ColdStore Nasty             Size   9 Byte, Start Byte 187
; ColdStore Ramp              Size   9 Byte, Start Byte 196
; ColdStore Conveyor          Size   9 Byte, Start Byte 205
; ColdStore ConveyorData      Size   4 Byte, Start Byte 214
; ColdStore RampData          Size   4 Byte, Start Byte 218
; ColdStore BorderColor       Size   1 Byte, Start Byte 222
; ColdStore Reserved          Size   4 Byte, Start Byte 223
; ColdStore Item		         Size   8 Byte, Start Byte 227
; ColdStore Direction         Size   4 Byte, Start Byte 235
; ColdStore Unused            Size   1 Byte, Start Byte 239
; ColdStore Enemy1		     Size   5 Byte, Start Byte 240
; ColdStore Enemy2		     Size   5 Byte, Start Byte 245
; ColdStore Enemy3		     Size   5 Byte, Start Byte 250
; ColdStore Enemy4		     Size   5 Byte, Start Byte 255
; ColdStore Enemy5		     Size   5 Byte, Start Byte 260
; ColdStore Enemy6		     Size   5 Byte, Start Byte 265
; ColdStore Enemy7		     Size   5 Byte, Start Byte 270
; ColdStore Enemy8		     Size   5 Byte, Start Byte 275
; ColdStore PosWilly          Size   2 Byte, Start Byte 280
; ColdStore EnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (Cold Store)
ColdStoreLayout:           
	DEFB 0,3,0,0,0,0,0,0	    ;Room layout
	DEFB 0,0,0,48,0,0,192,0
	DEFB 84,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,192,3,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 85,85,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 85,80,0,0,0,0,10,170
	DEFB 0,0,0,0,0,0,10,170
	DEFB 0,0,0,0,0,0,10,170
	DEFB 85,80,0,0,0,0,10,170
	DEFB 0,0,48,0,0,20,10,170
	DEFB 0,0,0,0,0,0,10,170
	DEFB 0,0,0,0,0,0,10,170
	DEFB 85,85,85,85,85,85,90,170

ColdStoreTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "           Cold Store           "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
ColdStoreBackground:                    ; Background
    DEFB 14,0,0,0,0,0,0,0,0	            ;Background

ColdStoreFloor:
    DEFB 13,255,255,85,170,85,170,0,0       ; Floor Solid

ColdStoreWall:
    DEFB 34,146,82,74,73,41,37,164,146   ; Wall Solid

ColdStoreNasty:
    DEFB 79,32,34,20,216,27,40,68,4  ; Nastry

ColdStoreRamp:
    DEFB 255,0,0,0,0,0,0,0,0              ; Ramp Solid

ColdStoreConveyor:
    DEFB 255,0,0,0,0,0,0,0,0                      ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
ColdStoreConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
ColdStoreRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 0                                  ;Location in the attribute buffer at 24064: (14,7)
    DEFB 0	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
ColdStoreBorderColor:
    DEFB 1	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
ColdStoreReserved:
    DEFB YELLOW, WHITE, CYAN, MAGENTA     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
ColdStoreItem:
    DEFB 112,140,114,250,239,173,37,33	                ;Item graphic (unused)

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
ColdStoreDirection:
	ROOM RoomsListTable.BackStairwayLayout						;Room to the left (Back Stairway)
	ROOM RoomsListTable.WestOfKitchenLayout						;Room to the right (West of Kitchen)
	ROOM RoomsListTable.SwimmingPoolLayout						;Room above (Swimming Pool)
	DEFB BLOCK					;Room below (The Off Licence)

ColdStoreUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
ColdStoreEnemy1:
    DEFB $80, 31, 0, 104, 192
ColdStoreEnemy2:
    DEFB $80, 30, 0, 72, 40         
ColdStoreEnemy3:
    DEFB $80, 31, 0, 48, 48         
ColdStoreEnemy4:
    DEFB $80, 30, 0, 24, 72         
ColdStoreEnemy5:
    DEFB 0, 0, 0, 0, 0 
ColdStoreEnemy6:
    DEFB 0, 0, 0, 0, 0
ColdStoreEnemy7:
    DEFB 0, 0, 0, 0, 0
ColdStoreEnemy8:
    DEFB 0, 0, 0, 0, 0

ColdStorePosWilly:
    db 200, 104                     ; Posizione di Willy
    
ColdStoreEnemyColors5_8:
    DEFB MAGENTA, NONE, NONE, NONE     ; Colori per nemici 5-8