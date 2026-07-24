;===========================================================================
; NomenLuni.asm  
;
; NomenLuniLayout            Size 128 Byte, Start Byte   0
; NomenLuniTile              Size  32 Byte, Start Byte 128
; NomenLuniBackground        Size   9 Byte, Start Byte 160
; NomenLuniFloor             Size   9 Byte, Start Byte 169
; NomenLuniWall              Size   9 Byte, Start Byte 178
; NomenLuniNasty             Size   9 Byte, Start Byte 187
; NomenLuniRamp              Size   9 Byte, Start Byte 196
; NomenLuniConveyor          Size   9 Byte, Start Byte 205
; NomenLuniConveyorData      Size   4 Byte, Start Byte 214
; NomenLuniRampData          Size   4 Byte, Start Byte 218
; NomenLuniBorderColor       Size   1 Byte, Start Byte 222
; NomenLuniReserved          Size   4 Byte, Start Byte 223
; NomenLuniItem		        Size   8 Byte, Start Byte 227
; NomenLuniDirection         Size   4 Byte, Start Byte 235
; NomenLuniUnused            Size   1 Byte, Start Byte 239
; NomenLuniEnemy1		    Size   5 Byte, Start Byte 240
; NomenLuniEnemy2		    Size   5 Byte, Start Byte 245
; NomenLuniEnemy3		    Size   5 Byte, Start Byte 250
; NomenLuniEnemy4		    Size   5 Byte, Start Byte 255
; NomenLuniEnemy5		    Size   5 Byte, Start Byte 260
; NomenLuniEnemy6		    Size   5 Byte, Start Byte 265
; NomenLuniEnemy7		    Size   5 Byte, Start Byte 270
; NomenLuniEnemy8		    Size   5 Byte, Start Byte 275
; NomenLuniPosWilly          Size   2 Byte, Start Byte 280
; NomenLuniEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (NomenLuni)
NomenLuniLayout:           
	DEFB 0,0,0,0,0,0,0,0	;Room layout
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,10,170,0,0
	DEFB 0,0,0,1,10,170,0,80
	DEFB 0,0,0,0,0,160,0,0
	DEFB 0,0,1,80,0,160,64,0
	DEFB 0,0,0,0,4,160,0,10
	DEFB 0,0,0,0,0,160,0,42
	DEFB 0,0,0,0,64,160,10,162
	DEFB 0,0,0,0,1,160,33,66
	DEFB 0,0,0,0,0,160,0,10
	DEFB 0,0,0,170,170,170,170,162
	DEFB 0,0,0,170,170,170,170,162
	
NomenLuniTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "           Nomen Luni           "   ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
NomenLuniBackground:                    
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

NomenLuniFloor:
    DEFB 13,255,34,68,136,85,34,0,0     ; Floor Solid

NomenLuniWall:
    DEFB 243,170,112,170,108,177,95,170,85  ; Wall Solid

NomenLuniNasty:
    DEFB 6,85,162,85,152,28,42,69,138  ; Nastry

NomenLuniRamp:
    DEFB 7,3,0,12,0,52,10,196,0         ; Ramp Solid

NomenLuniConveyor:
    DEFB 255,0,0,0,0,0,0,0,0                   ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
NomenLuniConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
NomenLuniRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24553                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 5	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
NomenLuniBorderColor:
    DEFB 2	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
NomenLuniReserved:
    DEFB CYAN, CYAN, RED, MAGENTA     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
NomenLuniItem:
    DEFB 18,18,18,18,18,18,18,18                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
NomenLuniDirection:
	DEFB BLOCK	;Room to the left (The Off Licence)
	DEFB 18		;Room to the right (On the Roof)
	DEFB BLOCK	;Room above (The Off Licence)
	DEFB 42		;Room below (Under the Roof)

NomenLuniUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
NomenLuniEnemy1:
    DEFB $80, 22, 192, 64, 240         ; [Frate (41496) - horizontal], Guardian = 67, Starts X=16, Y=32, Limit X=88
NomenLuniEnemy2:
    DEFB 0, 0, 0, 0, 0
NomenLuniEnemy3:
    DEFB 0, 0, 0, 0, 0
NomenLuniEnemy4:
    DEFB 0, 0, 0, 0, 0
NomenLuniEnemy5:
    DEFB 0, 0, 0, 0, 0
NomenLuniEnemy6:
    DEFB 0, 0, 0, 0, 0
NomenLuniEnemy7:
    DEFB 0, 0, 0, 0, 0
NomenLuniEnemy8:
    DEFB 0, 0, 0, 0, 0

NomenLuniPosWilly:
    db 150, 80                     ; Posizione di Willy
    
NomenLuniEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8