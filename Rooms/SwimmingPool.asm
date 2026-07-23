;===========================================================================
; SwimmingPool.asm  
;
; SwimmingPoolLayout            Size 128 Byte, Start Byte   0
; SwimmingPoolTile              Size  32 Byte, Start Byte 128
; SwimmingPoolBackground        Size   9 Byte, Start Byte 160
; SwimmingPoolFloor             Size   9 Byte, Start Byte 169
; SwimmingPoolWall              Size   9 Byte, Start Byte 178
; SwimmingPoolNasty             Size   9 Byte, Start Byte 187
; SwimmingPoolRamp              Size   9 Byte, Start Byte 196
; SwimmingPoolConveyor          Size   9 Byte, Start Byte 205
; SwimmingPoolConveyorData      Size   4 Byte, Start Byte 214
; SwimmingPoolRampData          Size   4 Byte, Start Byte 218
; SwimmingPoolBorderColor       Size   1 Byte, Start Byte 222
; SwimmingPoolReserved          Size   4 Byte, Start Byte 223
; SwimmingPoolItem		        Size   8 Byte, Start Byte 227
; SwimmingPoolDirection         Size   4 Byte, Start Byte 235
; SwimmingPoolUnused            Size   1 Byte, Start Byte 239
; SwimmingPoolEnemy1		    Size   5 Byte, Start Byte 240
; SwimmingPoolEnemy2		    Size   5 Byte, Start Byte 245
; SwimmingPoolEnemy3		    Size   5 Byte, Start Byte 250
; SwimmingPoolEnemy4		    Size   5 Byte, Start Byte 255
; SwimmingPoolEnemy5		    Size   5 Byte, Start Byte 260
; SwimmingPoolEnemy6		    Size   5 Byte, Start Byte 265
; SwimmingPoolEnemy7		    Size   5 Byte, Start Byte 270
; SwimmingPoolEnemy8		    Size   5 Byte, Start Byte 275
; SwimmingPoolPosWilly          Size   2 Byte, Start Byte 280
; SwimmingPoolEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (Swimming Pool)
SwimmingPoolLayout:           
	DEFB 0,0,0,0,0,0,0,0	;Room layout
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 170,85,85,85,85,85,84,170
	DEFB 170,85,85,85,85,85,82,170
	DEFB 170,85,85,85,85,85,74,170
	DEFB 170,170,170,170,170,170,170,170
	
SwimmingPoolTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "          Swimming Pool         "    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
SwimmingPoolBackground:                    
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

SwimmingPoolFloor:
    DEFB 41,0,0,0,0,0,0,0,0      ; Floor Solid

SwimmingPoolWall:
    DEFB 58,68,68,187,68,68,68,187,68  ; Wall Solid

SwimmingPoolNasty:
    DEFB 255,0,0,0,0,0,0,0,0  ; Nastry

SwimmingPoolRamp:
    DEFB 7,3,3,15,15,63,63,255,255            ; Ramp Solid

SwimmingPoolConveyor:
    DEFB 255,0,0,0,0,0,0,0,0                      ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
SwimmingPoolConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
SwimmingPoolRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24537                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 3	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
SwimmingPoolBorderColor:
    DEFB 2	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
SwimmingPoolReserved:
    DEFB CYAN, CYAN, RED, MAGENTA     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
SwimmingPoolItem:
    DEFB 112,32,32,80,80,136,136,136	                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
SwimmingPoolDirection:
	DEFB 54				;Room to the left (West  Wing)
	DEFB 30				;Room to the right (The Banyan Tree)
	DEFB 37				;Room above (Orangery)
	DEFB 25				;Room below (Cold Store)

SwimmingPoolUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
SwimmingPoolEnemy1:
    DEFB $80, 22, 192, 64, 240         ; [Frate (41496) - horizontal], Guardian = 67, Starts X=16, Y=32, Limit X=88
SwimmingPoolEnemy2:
    DEFB 0, 0, 0, 0, 0
SwimmingPoolEnemy3:
    DEFB 0, 0, 0, 0, 0
SwimmingPoolEnemy4:
    DEFB 0, 0, 0, 0, 0
SwimmingPoolEnemy5:
    DEFB 0, 0, 0, 0, 0
SwimmingPoolEnemy6:
    DEFB 0, 0, 0, 0, 0
SwimmingPoolEnemy7:
    DEFB 0, 0, 0, 0, 0
SwimmingPoolEnemy8:
    DEFB 0, 0, 0, 0, 0

SwimmingPoolPosWilly:
    db 225, 80                     ; Posizione di Willy
    
SwimmingPoolEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8