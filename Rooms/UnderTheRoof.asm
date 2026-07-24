;===========================================================================
; UnderTheRoof.asm  
;
; UnderTheRoofLayout            Size 128 Byte, Start Byte   0
; UnderTheRoofTile              Size  32 Byte, Start Byte 128
; UnderTheRoofBackground        Size   9 Byte, Start Byte 160
; UnderTheRoofFloor             Size   9 Byte, Start Byte 169
; UnderTheRoofWall              Size   9 Byte, Start Byte 178
; UnderTheRoofNasty             Size   9 Byte, Start Byte 187
; UnderTheRoofRamp              Size   9 Byte, Start Byte 196
; UnderTheRoofConveyor          Size   9 Byte, Start Byte 205
; UnderTheRoofConveyorData      Size   4 Byte, Start Byte 214
; UnderTheRoofRampData          Size   4 Byte, Start Byte 218
; UnderTheRoofBorderColor       Size   1 Byte, Start Byte 222
; UnderTheRoofReserved          Size   4 Byte, Start Byte 223
; UnderTheRoofItem		        Size   8 Byte, Start Byte 227
; UnderTheRoofDirection         Size   4 Byte, Start Byte 235
; UnderTheRoofUnused            Size   1 Byte, Start Byte 239
; UnderTheRoofEnemy1		    Size   5 Byte, Start Byte 240
; UnderTheRoofEnemy2		    Size   5 Byte, Start Byte 245
; UnderTheRoofEnemy3		    Size   5 Byte, Start Byte 250
; UnderTheRoofEnemy4		    Size   5 Byte, Start Byte 255
; UnderTheRoofEnemy5		    Size   5 Byte, Start Byte 260
; UnderTheRoofEnemy6		    Size   5 Byte, Start Byte 265
; UnderTheRoofEnemy7		    Size   5 Byte, Start Byte 270
; UnderTheRoofEnemy8		    Size   5 Byte, Start Byte 275
; UnderTheRoofPosWilly          Size   2 Byte, Start Byte 280
; UnderTheRoofEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (UnderTheRoof)
UnderTheRoofLayout:           
	DEFB 0,0,0,255,255,255,255,240	;Room layout
	DEFB 0,0,0,0,195,252,48,0
	DEFB 0,0,0,3,243,252,252,0
	DEFB 0,0,0,0,0,240,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 170,85,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,160,0,1,64,0
	DEFB 0,0,80,160,1,0,0,0
	DEFB 85,80,0,160,64,0,0,0
	DEFB 84,0,1,160,0,0,0,0
	DEFB 0,0,0,160,0,64,0,0
	
UnderTheRoofTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "         Under the Roof         "   ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
UnderTheRoofBackground:                    
    DEFB $0F,0,0,0,0,0,0,0,0	            ;Background

UnderTheRoofFloor:
    DEFB 12,181,170,85,74,37,66,1,2     ; Floor Solid

UnderTheRoofWall:
    DEFB 30,102,182,109,187,102,185,109,182  ; Wall Solid

UnderTheRoofNasty:
    DEFB 245,102,170,95,188,99,172,107,164  ; Nastry

UnderTheRoofRamp:
    DEFB 15,1,2,4,40,16,40,64,128         ; Ramp Solid

UnderTheRoofConveyor:
    DEFB 14,165,170,189,102,102,102,102,102                   ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
UnderTheRoofConveyorData:
    DEFB 1	                                ;Direction (right)
    DEFW 24268	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 20	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
UnderTheRoofRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24260                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 7	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
UnderTheRoofBorderColor:
    DEFB 2	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
UnderTheRoofReserved:
    DEFB CYAN, WHITE, NONE, NONE     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
UnderTheRoofItem:
    DEFB 255,255,255,255,255,255,255,255                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
UnderTheRoofDirection:
	DEFB 43			;Room to the left (Conservatory Roof)
	DEFB 41			;Room to the right (The Attic)
	DEFB 48			;Room above (Nomen Luni)
	DEFB 36			;Room below (A bit of tree)

UnderTheRoofUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
UnderTheRoofEnemy1:
    DEFB $80, 38, 96, 64, 144         ; [Frate (41496) - horizontal], Guardian = 67, Starts X=16, Y=32, Limit X=88
UnderTheRoofEnemy2:
    DEFB $80, 30, 0, 72, 48
UnderTheRoofEnemy3:
    DEFB 0, 0, 0, 0, 0
UnderTheRoofEnemy4:
    DEFB 0, 0, 0, 0, 0
UnderTheRoofEnemy5:
    DEFB 0, 0, 0, 0, 0
UnderTheRoofEnemy6:
    DEFB 0, 0, 0, 0, 0
UnderTheRoofEnemy7:
    DEFB 0, 0, 0, 0, 0
UnderTheRoofEnemy8:
    DEFB 0, 0, 0, 0, 0

UnderTheRoofPosWilly:
    db 15, 40                     ; Posizione di Willy
    
UnderTheRoofEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8