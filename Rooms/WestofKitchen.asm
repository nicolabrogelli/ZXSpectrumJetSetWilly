;===========================================================================
; WestOfKitchen .asm  
;
; WestOfKitchen Layout            Size 128 Byte, Start Byte   0
; WestOfKitchen Tile              Size  32 Byte, Start Byte 128
; WestOfKitchen Background        Size   9 Byte, Start Byte 160
; WestOfKitchen Floor             Size   9 Byte, Start Byte 169
; WestOfKitchen Wall              Size   9 Byte, Start Byte 178
; WestOfKitchen Nasty             Size   9 Byte, Start Byte 187
; WestOfKitchen Ramp              Size   9 Byte, Start Byte 196
; WestOfKitchen Conveyor          Size   9 Byte, Start Byte 205
; WestOfKitchen ConveyorData      Size   4 Byte, Start Byte 214
; WestOfKitchen RampData          Size   4 Byte, Start Byte 218
; WestOfKitchen BorderColor       Size   1 Byte, Start Byte 222
; WestOfKitchen Reserved          Size   4 Byte, Start Byte 223
; WestOfKitchen Item		         Size   8 Byte, Start Byte 227
; WestOfKitchen Direction         Size   4 Byte, Start Byte 235
; WestOfKitchen Unused            Size   1 Byte, Start Byte 239
; WestOfKitchen Enemy1		     Size   5 Byte, Start Byte 240
; WestOfKitchen Enemy2		     Size   5 Byte, Start Byte 245
; WestOfKitchen Enemy3		     Size   5 Byte, Start Byte 250
; WestOfKitchen Enemy4		     Size   5 Byte, Start Byte 255
; WestOfKitchen Enemy5		     Size   5 Byte, Start Byte 260
; WestOfKitchen Enemy6		     Size   5 Byte, Start Byte 265
; WestOfKitchen Enemy7		     Size   5 Byte, Start Byte 270
; WestOfKitchen Enemy8		     Size   5 Byte, Start Byte 275
; WestOfKitchen PosWilly          Size   2 Byte, Start Byte 280
; WestOfKitchen EnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (West Of Kitchen)
WestOfKitchenLayout:           
	DEFB 0,0,1,0,0,0,0,0	;Room layout
	DEFB 0,0,1,0,0,0,0,0
	DEFB 0,0,1,0,0,0,0,0
	DEFB 0,0,1,0,0,0,0,0
	DEFB 0,0,1,0,0,0,0,0
	DEFB 0,0,1,0,16,5,84,21
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 160,0,0,0,0,4,0,21
	DEFB 168,0,0,0,21,0,80,0
	DEFB 170,0,0,80,0,0,0,0
	DEFB 170,128,0,0,0,0,0,0
	DEFB 170,160,0,0,21,5,84,21
	DEFB 170,168,0,0,0,0,0,0
	DEFB 170,170,0,0,0,0,0,0
	DEFB 170,170,170,170,170,170,170,170

WestOfKitchenTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "    West of Kitchen             "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
WestOfKitchenBackground:
    DEFB 7,0,0,0,0,0,0,0,0	            ;Background

WestOfKitchenFloor:
    DEFB 5,255,189,165,165,165,66,0,0	    ;Floor Solid

WestOfKitchenWall:
    DEFB 34,9,66,144,36,9,66,144,36	    ;Wall Solid

WestOfKitchenNasty:
    DEFB 255,0,0,0,0,0,0,0,0	    ;Nasty

WestOfKitchenRamp:
    DEFB 71,192,64,176,80,172,84,171,85	            ;Ramp Solid

WestOfKitchenConveyor:
    DEFB 66,240,85,170,85,85,170,42,8           ;Conveyor

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
WestOfKitchenConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 24470	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 5	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
WestOfKitchenRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 24520                                  ;Location in the attribute buffer at 24064: (14,7)
    DEFB 7	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
WestOfKitchenBorderColor:
    DEFB 1	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
WestOfKitchenReserved:
    DEFB NONE, MAGENTA, CYAN, YELLOW                        ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
WestOfKitchenItem:
    DEFB 0,0,0,0,0,0,0,0	                ;Item graphic (unused)

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
WestOfKitchenDirection:
	DEFB 25						;Room to the left (Cold Store)
	DEFB 23						;Room to the right (The Kitchen)
	DEFB 30						;Room above (The Banyan Tree)
	DEFB BLOCK					;Room below (The Off Licence)

WestOfKitchenUnused:
    DEFB 0                        ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
WestOfKitchenEnemy1:
    DEFB $C0, 29, 72, 0, 104
WestOfKitchenEnemy2:
    DEFB $E0, 29, 112, 0, 104         
WestOfKitchenEnemy3:
    DEFB $C0, 29, 160, 0, 104         
WestOfKitchenEnemy4:
    DEFB $E0, 29, 216, 0, 104         
WestOfKitchenEnemy5:
    DEFB 0, 0, 0, 0, 0
WestOfKitchenEnemy6:
    DEFB 0, 0, 0, 0, 0
WestOfKitchenEnemy7:
    DEFB 0, 0, 0, 0, 0
WestOfKitchenEnemy8:
    DEFB 0, 0, 0, 0, 0

WestOfKitchenPosWilly:
    db 200, 104                     ; Posizione di Willy
    
WestOfKitchenEnemyColors5_8:
    DEFB MAGENTA, NONE, NONE, NONE               ; Colori per nemici 5-8