;===========================================================================
; PriestsHole.asm  
;
; PriestsHoleLayout            Size 128 Byte, Start Byte   0
; PriestsHoleTile              Size  32 Byte, Start Byte 128
; PriestsHoleBackground        Size   9 Byte, Start Byte 160
; PriestsHoleFloor             Size   9 Byte, Start Byte 169
; PriestsHoleWall              Size   9 Byte, Start Byte 178
; PriestsHoleNasty             Size   9 Byte, Start Byte 187
; PriestsHoleRamp              Size   9 Byte, Start Byte 196
; PriestsHoleConveyor          Size   9 Byte, Start Byte 205
; PriestsHoleConveyorData      Size   4 Byte, Start Byte 214
; PriestsHoleRampData          Size   4 Byte, Start Byte 218
; PriestsHoleBorderColor       Size   1 Byte, Start Byte 222
; PriestsHoleReserved          Size   4 Byte, Start Byte 223
; PriestsHoleItem		        Size   8 Byte, Start Byte 227
; PriestsHoleDirection         Size   4 Byte, Start Byte 235
; PriestsHoleUnused            Size   1 Byte, Start Byte 239
; PriestsHoleEnemy1		    Size   5 Byte, Start Byte 240
; PriestsHoleEnemy2		    Size   5 Byte, Start Byte 245
; PriestsHoleEnemy3		    Size   5 Byte, Start Byte 250
; PriestsHoleEnemy4		    Size   5 Byte, Start Byte 255
; PriestsHoleEnemy5		    Size   5 Byte, Start Byte 260
; PriestsHoleEnemy6		    Size   5 Byte, Start Byte 265
; PriestsHoleEnemy7		    Size   5 Byte, Start Byte 270
; PriestsHoleEnemy8		    Size   5 Byte, Start Byte 275
; PriestsHolePosWilly          Size   2 Byte, Start Byte 280
; PriestsHoleEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (PriestsHole)
PriestsHoleLayout:           
	DEFB 160,0,10,0,0,0,0,0	;Room layout
	DEFB 160,0,10,0,0,0,0,0
	DEFB 160,0,10,0,0,0,0,0
	DEFB 0,0,10,0,0,0,0,0
	DEFB 0,0,10,0,0,0,0,0
	DEFB 165,0,90,0,0,0,0,0
	DEFB 160,0,10,0,0,0,0,0
	DEFB 161,0,10,0,0,0,0,0
	DEFB 160,0,74,0,0,0,0,0
	DEFB 160,0,10,0,0,0,0,0
	DEFB 161,0,0,0,0,0,0,0
	DEFB 160,0,0,0,0,0,0,0
	DEFB 160,0,90,0,0,0,0,0
	DEFB 160,0,10,0,0,0,0,0
	DEFB 160,64,10,0,0,0,0,0
	DEFB 160,1,10,0,0,0,0,0
	
PriestsHoleTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "         Priests' Hole          "   ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
PriestsHoleBackground:                    
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

PriestsHoleFloor:
    DEFB 6,85,85,93,215,112,0,0,0      ; Floor Solid

PriestsHoleWall:
    DEFB 42,34,17,68,136,34,17,68,136  ; Wall Solid

PriestsHoleNasty:
    DEFB 255,0,0,0,0,0,0,0,0  ; Nastry

PriestsHoleRamp:
    DEFB 255,0,0,0,0,0,0,0,0          ; Ramp Solid

PriestsHoleConveyor:
    DEFB 255,0,0,0,0,0,0,0,0                    ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
PriestsHoleConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
PriestsHoleRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 0                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 0	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
PriestsHoleBorderColor:
    DEFB 2	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
PriestsHoleReserved:
    DEFB CYAN, CYAN, RED, MAGENTA     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
PriestsHoleItem:
    DEFB 191,191,187,177,187,187,191,191                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
PriestsHoleDirection:
	DEFB 39		;Room to the left (Emergency Generator)
	DEFB BLOCK	;Room to the right (The Off Licence)
	DEFB 60		;Room above (The Bow)
	DEFB 32 	;Room below (Halfway up the East Wall)

PriestsHoleUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
PriestsHoleEnemy1:
    DEFB $80, 22, 192, 64, 240         ; [Frate (41496) - horizontal], Guardian = 67, Starts X=16, Y=32, Limit X=88
PriestsHoleEnemy2:
    DEFB 0, 0, 0, 0, 0
PriestsHoleEnemy3:
    DEFB 0, 0, 0, 0, 0
PriestsHoleEnemy4:
    DEFB 0, 0, 0, 0, 0
PriestsHoleEnemy5:
    DEFB 0, 0, 0, 0, 0
PriestsHoleEnemy6:
    DEFB 0, 0, 0, 0, 0
PriestsHoleEnemy7:
    DEFB 0, 0, 0, 0, 0
PriestsHoleEnemy8:
    DEFB 0, 0, 0, 0, 0

PriestsHolePosWilly:
    db 25, 25                     ; Posizione di Willy
    
PriestsHoleEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8