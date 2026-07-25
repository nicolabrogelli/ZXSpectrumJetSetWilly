;===========================================================================
; ConservatoryRoof.asm  
;
; ConservatoryRoofLayout            Size 128 Byte, Start Byte   0
; ConservatoryRoofTile              Size  32 Byte, Start Byte 128
; ConservatoryRoofBackground        Size   9 Byte, Start Byte 160
; ConservatoryRoofFloor             Size   9 Byte, Start Byte 169
; ConservatoryRoofWall              Size   9 Byte, Start Byte 178
; ConservatoryRoofNasty             Size   9 Byte, Start Byte 187
; ConservatoryRoofRamp              Size   9 Byte, Start Byte 196
; ConservatoryRoofConveyor          Size   9 Byte, Start Byte 205
; ConservatoryRoofConveyorData      Size   4 Byte, Start Byte 214
; ConservatoryRoofRampData          Size   4 Byte, Start Byte 218
; ConservatoryRoofBorderColor       Size   1 Byte, Start Byte 222
; ConservatoryRoofReserved          Size   4 Byte, Start Byte 223
; ConservatoryRoofItem		        Size   8 Byte, Start Byte 227
; ConservatoryRoofDirection         Size   4 Byte, Start Byte 235
; ConservatoryRoofUnused            Size   1 Byte, Start Byte 239
; ConservatoryRoofEnemy1		    Size   5 Byte, Start Byte 240
; ConservatoryRoofEnemy2		    Size   5 Byte, Start Byte 245
; ConservatoryRoofEnemy3		    Size   5 Byte, Start Byte 250
; ConservatoryRoofEnemy4		    Size   5 Byte, Start Byte 255
; ConservatoryRoofEnemy5		    Size   5 Byte, Start Byte 260
; ConservatoryRoofEnemy6		    Size   5 Byte, Start Byte 265
; ConservatoryRoofEnemy7		    Size   5 Byte, Start Byte 270
; ConservatoryRoofEnemy8		    Size   5 Byte, Start Byte 275
; ConservatoryRoofPosWilly          Size   2 Byte, Start Byte 280
; ConservatoryRoofEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (ConservatoryRoof)
ConservatoryRoofLayout:           
	DEFB 0,0,0,0,0,0,0,0	;Room layout
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,42,170,170
	DEFB 0,0,0,0,0,48,195,12
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,80,0
	DEFB 0,0,0,0,0,0,5,85
	DEFB 0,0,0,0,0,4,0,0
	
ConservatoryRoofTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "        Conservatory Roof       "   ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
ConservatoryRoofBackground:                    
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

ConservatoryRoofFloor:
    DEFB 4,172,83,42,208,138,36,34,4     ; Floor Solid

ConservatoryRoofWall:
    DEFB 5,247,239,0,0,0,102,102,0  ; Wall Solid

ConservatoryRoofNasty:
    DEFB 67,218,213,127,46,17,31,10,27  ; Nastry

ConservatoryRoofRamp:
    DEFB 7,1,2,4,16,8,32,64,128         ; Ramp Solid

ConservatoryRoofConveyor:
    DEFB 255,0,0,0,0,0,0,0,0                   ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
ConservatoryRoofConveyorData:
    DEFB 1	                                ;Direction (right)
    DEFW 24506	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 6	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
ConservatoryRoofRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24556                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 9	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
ConservatoryRoofBorderColor:
    DEFB 5	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
ConservatoryRoofReserved:
    DEFB RED, YELLOW, NONE, NONE     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
ConservatoryRoofItem:
    DEFB 4,24,248,60,126,96,96,126                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
ConservatoryRoofDirection:
	DEFB BLOCK		;Room to the left (The Off Licence)
	ROOM RoomsListTable.UnderTheRoofLayout			;Room to the right (Under the Roof)
	DEFB BLOCK		;Room above (The Off Licence)
	ROOM RoomsListTable.OrangeryLayout			;Room below (Orangery)

ConservatoryRoofUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
ConservatoryRoofEnemy1:
    DEFB $80, PINZA_GHIACCIO, 136, 88, 235  
ConservatoryRoofEnemy2:
    DEFB $80, TRONCHESE, 128, 40, 235
ConservatoryRoofEnemy3:
    DEFB 0, 0, 0, 0, 0
ConservatoryRoofEnemy4:
    DEFB 0, 0, 0, 0, 0
ConservatoryRoofEnemy5:
    DEFB 0, 0, 0, 0, 0
ConservatoryRoofEnemy6:
    DEFB 0, 0, 0, 0, 0
ConservatoryRoofEnemy7:
    DEFB 0, 0, 0, 0, 0
ConservatoryRoofEnemy8:
    DEFB 0, 0, 0, 0, 0

ConservatoryRoofPosWilly:
    db 200, 40                     ; Posizione di Willy
    
ConservatoryRoofEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8