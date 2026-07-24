;===========================================================================
; TheBow.asm  
;
; TheBowLayout            Size 128 Byte, Start Byte   0
; TheBowTile              Size  32 Byte, Start Byte 128
; TheBowBackground        Size   9 Byte, Start Byte 160
; TheBowFloor             Size   9 Byte, Start Byte 169
; TheBowWall              Size   9 Byte, Start Byte 178
; TheBowNasty             Size   9 Byte, Start Byte 187
; TheBowRamp              Size   9 Byte, Start Byte 196
; TheBowConveyor          Size   9 Byte, Start Byte 205
; TheBowConveyorData      Size   4 Byte, Start Byte 214
; TheBowRampData          Size   4 Byte, Start Byte 218
; TheBowBorderColor       Size   1 Byte, Start Byte 222
; TheBowReserved          Size   4 Byte, Start Byte 223
; TheBowItem		        Size   8 Byte, Start Byte 227
; TheBowDirection         Size   4 Byte, Start Byte 235
; TheBowUnused            Size   1 Byte, Start Byte 239
; TheBowEnemy1		    Size   5 Byte, Start Byte 240
; TheBowEnemy2		    Size   5 Byte, Start Byte 245
; TheBowEnemy3		    Size   5 Byte, Start Byte 250
; TheBowEnemy4		    Size   5 Byte, Start Byte 255
; TheBowEnemy5		    Size   5 Byte, Start Byte 260
; TheBowEnemy6		    Size   5 Byte, Start Byte 265
; TheBowEnemy7		    Size   5 Byte, Start Byte 270
; TheBowEnemy8		    Size   5 Byte, Start Byte 275
; TheBowPosWilly          Size   2 Byte, Start Byte 280
; TheBowEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (TheBow)
TheBowLayout:           
	DEFB 0,0,0,0,0,0,0,0	;Room layout
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,1,85,85
	DEFB 0,0,0,0,0,0,128,0
	DEFB 0,0,0,0,4,0,128,0
	DEFB 0,0,0,0,0,0,144,0
	DEFB 0,0,0,0,0,0,128,0
	DEFB 0,0,0,21,85,85,85,85
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 255,255,255,255,192,0,0,0
	
TheBowTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "             The Bow            "   ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
TheBowBackground:                    
    DEFB 7,0,0,0,0,0,0,0,0	            ;Background

TheBowFloor:
    DEFB 68,255,170,85,255,0,0,0,0   ; Floor Solid

TheBowWall:
    DEFB 61,201,201,201,201,201,201,201,201  ; Wall Solid

TheBowNasty:
    DEFB 79,64,130,82,0,0,0,0,0  ; Nastry

TheBowRamp:
    DEFB 7,128,64,32,16,8,4,2,1      ; Ramp Solid

TheBowConveyor:
    DEFB 14,255,170,170,0,170,255,0,0                 ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
TheBowConveyorData:
    DEFB 1	                                ;Direction (right)
    DEFW 24561	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 15	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
TheBowRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 24528                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 6	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
TheBowBorderColor:
    DEFB 5	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
TheBowReserved:
    DEFB CYAN, CYAN, NONE, NONE     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
TheBowItem:
    DEFB 72,57,38,218,91,100,156,18              ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
TheBowDirection:
	DEFB BLOCK	;Room to the left (The Off Licence)
	DEFB 59		;Room to the right (The Yacht)
	DEFB BLOCK	;Room above (The Off Licence)
	DEFB BLOCK	;Room below (The Off Licence)

TheBowUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
TheBowEnemy1:
    DEFB $80, 3, 176, 24, 235         ; [Frate (41496) - horizontal], Guardian = 67, Starts X=16, Y=32, Limit X=88
TheBowEnemy2:
    DEFB $80, 27, 136, 104, 235 
TheBowEnemy3:
    DEFB 0, 0, 0, 0, 0
TheBowEnemy4:
    DEFB 0, 0, 0, 0, 0
TheBowEnemy5:
    DEFB 0, 0, 0, 0, 0
TheBowEnemy6:
    DEFB 0, 0, 0, 0, 0
TheBowEnemy7:
    DEFB 0, 0, 0, 0, 0
TheBowEnemy8:
    DEFB 0, 0, 0, 0, 0

TheBowPosWilly:
    db 200, 104                     ; Posizione di Willy
    
TheBowEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8