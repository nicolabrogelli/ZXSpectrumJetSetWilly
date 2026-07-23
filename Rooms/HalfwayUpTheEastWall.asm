;===========================================================================
; HalfwayUpTheEastWall.asm  
;
; HalfwayUpTheEastWallLayout            Size 128 Byte, Start Byte   0
; HalfwayUpTheEastWallTile              Size  32 Byte, Start Byte 128
; HalfwayUpTheEastWallBackground        Size   9 Byte, Start Byte 160
; HalfwayUpTheEastWallFloor             Size   9 Byte, Start Byte 169
; HalfwayUpTheEastWallWall              Size   9 Byte, Start Byte 178
; HalfwayUpTheEastWallNasty             Size   9 Byte, Start Byte 187
; HalfwayUpTheEastWallRamp              Size   9 Byte, Start Byte 196
; HalfwayUpTheEastWallConveyor          Size   9 Byte, Start Byte 205
; HalfwayUpTheEastWallConveyorData      Size   4 Byte, Start Byte 214
; HalfwayUpTheEastWallRampData          Size   4 Byte, Start Byte 218
; HalfwayUpTheEastWallBorderColor       Size   1 Byte, Start Byte 222
; HalfwayUpTheEastWallReserved          Size   4 Byte, Start Byte 223
; HalfwayUpTheEastWallItem		        Size   8 Byte, Start Byte 227
; HalfwayUpTheEastWallDirection         Size   4 Byte, Start Byte 235
; HalfwayUpTheEastWallUnused            Size   1 Byte, Start Byte 239
; HalfwayUpTheEastWallEnemy1		    Size   5 Byte, Start Byte 240
; HalfwayUpTheEastWallEnemy2		    Size   5 Byte, Start Byte 245
; HalfwayUpTheEastWallEnemy3		    Size   5 Byte, Start Byte 250
; HalfwayUpTheEastWallEnemy4		    Size   5 Byte, Start Byte 255
; HalfwayUpTheEastWallEnemy5		    Size   5 Byte, Start Byte 260
; HalfwayUpTheEastWallEnemy6		    Size   5 Byte, Start Byte 265
; HalfwayUpTheEastWallEnemy7		    Size   5 Byte, Start Byte 270
; HalfwayUpTheEastWallEnemy8		    Size   5 Byte, Start Byte 275
; HalfwayUpTheEastWallPosWilly          Size   2 Byte, Start Byte 280
; HalfwayUpTheEastWallEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (Halfway up the East Wall)
HalfwayUpTheEastWallLayout:           
	DEFB 160,0,10,0,0,0,0,0		;Room layout
	DEFB 160,0,10,0,0,0,0,0
	DEFB 160,0,10,0,0,0,0,0
	DEFB 160,8,0,0,0,0,0,0
	DEFB 128,10,0,0,0,0,0,0
	DEFB 128,26,128,0,0,0,0,0
	DEFB 160,0,32,0,0,0,0,0
	DEFB 160,0,40,0,0,0,0,0
	DEFB 160,74,170,0,0,0,0,0
	DEFB 160,10,170,0,0,0,0,0
	DEFB 160,16,10,0,0,0,0,0
	DEFB 164,0,10,0,0,0,0,0
	DEFB 160,0,10,0,0,0,0,0
	DEFB 160,4,10,0,0,0,0,0
	DEFB 160,0,10,0,0,0,0,0
	DEFB 160,0,26,0,0,0,0,0
	
HalfwayUpTheEastWallTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "Halfway up the East Wall        "    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
HalfwayUpTheEastWallBackground:                    
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

HalfwayUpTheEastWallFloor:
    DEFB 5,255,255,90,153,189,90,60,90      ; Floor Solid

HalfwayUpTheEastWallWall:
    DEFB 15,51,17,68,204,51,17,68,204  ; Wall Solid

HalfwayUpTheEastWallNasty:
    DEFB 255,0,0,0,0,0,0,0,0  ; Nastry

HalfwayUpTheEastWallRamp:
    DEFB 7,128,192,224,112,184,28,78,199            ; Ramp Solid

HalfwayUpTheEastWallConveyor:
    DEFB 7,0,0,0,0,0,0,0,0                      ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
HalfwayUpTheEastWallConveyorData:
    DEFB 1	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
HalfwayUpTheEastWallRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 24299                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 6	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
HalfwayUpTheEastWallBorderColor:
    DEFB 2	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
HalfwayUpTheEastWallReserved:
    DEFB CYAN, CYAN, RED, MAGENTA     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
HalfwayUpTheEastWallItem:
    DEFB 0,0,0,0,0,0,0,0	                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
HalfwayUpTheEastWallDirection:
	DEFB 33			;Room to the left (The Bathroom)
	DEFB BLOCK		;Room to the right (The Off Licence)
	DEFB 38			;Room above (Priests' Hole)
	DEFB 26			;Room below (East Wall Base)

HalfwayUpTheEastWallUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
HalfwayUpTheEastWallEnemy1:
    DEFB $80, 22, 192, 64, 240         ; [Frate (41496) - horizontal], Guardian = 67, Starts X=16, Y=32, Limit X=88
HalfwayUpTheEastWallEnemy2:
    DEFB 0, 0, 0, 0, 0
HalfwayUpTheEastWallEnemy3:
    DEFB 0, 0, 0, 0, 0
HalfwayUpTheEastWallEnemy4:
    DEFB 0, 0, 0, 0, 0
HalfwayUpTheEastWallEnemy5:
    DEFB 0, 0, 0, 0, 0
HalfwayUpTheEastWallEnemy6:
    DEFB 0, 0, 0, 0, 0
HalfwayUpTheEastWallEnemy7:
    DEFB 0, 0, 0, 0, 0
HalfwayUpTheEastWallEnemy8:
    DEFB 0, 0, 0, 0, 0

HalfwayUpTheEastWallPosWilly:
    db 25, 35                     ; Posizione di Willy
    
HalfwayUpTheEastWallEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8