;===========================================================================
; TheAttic.asm  
;
; TheAtticLayout            Size 128 Byte, Start Byte   0
; TheAtticTile              Size  32 Byte, Start Byte 128
; TheAtticBackground        Size   9 Byte, Start Byte 160
; TheAtticFloor             Size   9 Byte, Start Byte 169
; TheAtticWall              Size   9 Byte, Start Byte 178
; TheAtticNasty             Size   9 Byte, Start Byte 187
; TheAtticRamp              Size   9 Byte, Start Byte 196
; TheAtticConveyor          Size   9 Byte, Start Byte 205
; TheAtticConveyorData      Size   4 Byte, Start Byte 214
; TheAtticRampData          Size   4 Byte, Start Byte 218
; TheAtticBorderColor       Size   1 Byte, Start Byte 222
; TheAtticReserved          Size   4 Byte, Start Byte 223
; TheAtticItem		        Size   8 Byte, Start Byte 227
; TheAtticDirection         Size   4 Byte, Start Byte 235
; TheAtticUnused            Size   1 Byte, Start Byte 239
; TheAtticEnemy1		    Size   5 Byte, Start Byte 240
; TheAtticEnemy2		    Size   5 Byte, Start Byte 245
; TheAtticEnemy3		    Size   5 Byte, Start Byte 250
; TheAtticEnemy4		    Size   5 Byte, Start Byte 255
; TheAtticEnemy5		    Size   5 Byte, Start Byte 260
; TheAtticEnemy6		    Size   5 Byte, Start Byte 265
; TheAtticEnemy7		    Size   5 Byte, Start Byte 270
; TheAtticEnemy8		    Size   5 Byte, Start Byte 275
; TheAtticPosWilly          Size   2 Byte, Start Byte 280
; TheAtticEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (TheAttic)
TheAtticLayout:           
	DEFB 0,0,0,0,0,0,0,0	;Room layout
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,192,3,0,0,0,0,0
	DEFB 85,149,86,80,0,0,0,0
	DEFB 160,0,0,0,0,0,0,0
	DEFB 164,0,0,0,5,0,0,5
	DEFB 160,0,0,0,0,0,0,0
	DEFB 164,0,0,0,0,80,0,0
	DEFB 160,0,0,0,0,0,0,0
	DEFB 164,0,0,0,0,4,0,0
	DEFB 160,0,0,0,0,0,0,0
	DEFB 164,3,0,192,192,0,0,0
	DEFB 85,101,149,150,85,149,86,89
	
TheAtticTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "          The Attic             "   ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
TheAtticBackground:                    
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

TheAtticFloor:
    DEFB 22,206,255,0,231,0,127,0,251     ; Floor Solid

TheAtticWall:
    DEFB 30,238,17,108,146,17,201,34,156  ; Wall Solid

TheAtticNasty:
    DEFB 68,36,18,68,170,85,170,91,255  ; Nastry

TheAtticRamp:
    DEFB 255,0,0,0,0,0,0,0,0         ; Ramp Solid

TheAtticConveyor:
    DEFB 66,240,170,60,170,85,170,85,170                   ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
TheAtticConveyorData:
    DEFB 1	                                ;Direction (right)
    DEFW 24344	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 4	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
TheAtticRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 0                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 0	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
TheAtticBorderColor:
    DEFB 1	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
TheAtticReserved:
    DEFB CYAN, CYAN, RED, MAGENTA     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
TheAtticItem:
    DEFB 17,34,51,68,85,102,119,136                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
TheAtticDirection:
	ROOM RoomsListTable.UnderTheRoofLayout		;Room to the left (Under the Roof)
	ROOM RoomsListTable.DrJonesWillNeverBelieveThisLayout		;Room to the right (Dr Jones will never believe this)
	DEFB BLOCK	;Room above (The Off Licence)
	ROOM RoomsListTable.TopLandingLayout		;Room below (Top Landing)

TheAtticUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
TheAtticEnemy1:
    DEFB $80, 38, 96, 64, 144         ; [Frate (41496) - horizontal], Guardian = 67, Starts X=16, Y=32, Limit X=88
TheAtticEnemy2:
    DEFB 0, 0, 0, 0, 0
TheAtticEnemy3:
    DEFB 0, 0, 0, 0, 0
TheAtticEnemy4:
    DEFB 0, 0, 0, 0, 0
TheAtticEnemy5:
    DEFB 0, 0, 0, 0, 0
TheAtticEnemy6:
    DEFB 0, 0, 0, 0, 0
TheAtticEnemy7:
    DEFB 0, 0, 0, 0, 0
TheAtticEnemy8:
    DEFB 0, 0, 0, 0, 0

TheAtticPosWilly:
    db 200, 101                     ; Posizione di Willy
    
TheAtticEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8