;===========================================================================
; TheBeach.asm  
;
; TheBeachLayout            Size 128 Byte, Start Byte   0
; TheBeachTile              Size  32 Byte, Start Byte 128
; TheBeachBackground        Size   9 Byte, Start Byte 160
; TheBeachFloor             Size   9 Byte, Start Byte 169
; TheBeachWall              Size   9 Byte, Start Byte 178
; TheBeachNasty             Size   9 Byte, Start Byte 187
; TheBeachRamp              Size   9 Byte, Start Byte 196
; TheBeachConveyor          Size   9 Byte, Start Byte 205
; TheBeachConveyorData      Size   4 Byte, Start Byte 214
; TheBeachRampData          Size   4 Byte, Start Byte 218
; TheBeachBorderColor       Size   1 Byte, Start Byte 222
; TheBeachReserved          Size   4 Byte, Start Byte 223
; TheBeachItem		        Size   8 Byte, Start Byte 227
; TheBeachDirection         Size   4 Byte, Start Byte 235
; TheBeachUnused            Size   1 Byte, Start Byte 239
; TheBeachEnemy1		    Size   5 Byte, Start Byte 240
; TheBeachEnemy2		    Size   5 Byte, Start Byte 245
; TheBeachEnemy3		    Size   5 Byte, Start Byte 250
; TheBeachEnemy4		    Size   5 Byte, Start Byte 255
; TheBeachEnemy5		    Size   5 Byte, Start Byte 260
; TheBeachEnemy6		    Size   5 Byte, Start Byte 265
; TheBeachEnemy7		    Size   5 Byte, Start Byte 270
; TheBeachEnemy8		    Size   5 Byte, Start Byte 275
; TheBeachPosWilly          Size   2 Byte, Start Byte 280
; TheBeachEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (TheBeach)
TheBeachLayout:           
	DEFB 0,0,0,0,0,0,0,0	;Room layout
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,170,170
	DEFB 0,0,0,0,0,0,170,170
	DEFB 170,160,0,0,0,0,170,170
	DEFB 0,0,0,0,0,0,170,170
	DEFB 0,0,0,0,0,0,170,170
	DEFB 0,0,0,0,0,0,170,170
	DEFB 0,5,213,117,93,117,170,170
	DEFB 0,21,85,85,85,85,170,170
	
TheBeachTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "            The Beach           "   ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
TheBeachBackground:                    
    DEFB 13,0,0,0,0,0,0,0,0	            ;Background

TheBeachFloor:
    DEFB 50,0,0,64,4,0,16,0,1    ; Floor Solid

TheBeachWall:
    DEFB 42,68,0,146,36,128,40,130,80  ; Wall Solid

TheBeachNasty:
    DEFB 48,66,129,231,129,90,126,60,66  ; Nastry

TheBeachRamp:
    DEFB 14,1,3,7,15,30,55,127,251      ; Ramp Solid

TheBeachConveyor:
    DEFB 44,78,170,0,64,64,68,170,255                  ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
TheBeachConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 24544	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 5	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
TheBeachRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24517                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 1	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
TheBeachBorderColor:
    DEFB 2	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
TheBeachReserved:
    DEFB CYAN, CYAN, RED, MAGENTA     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
TheBeachItem:
    DEFB 4,5,11,11,23,55,111,239               ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
TheBeachDirection:
	DEFB 59		;Room to the left (The Yacht)
	DEFB 51		;Room to the right (Tool  Shed)
	DEFB 58		;Room above (The Beach)
	DEFB BLOCK	;Room below (The Off Licence)

TheBeachUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
TheBeachEnemy1:
    DEFB $C0, 0, 32, 0, 64         ; [Frate (41496) - horizontal], Guardian = 67, Starts X=16, Y=32, Limit X=88
TheBeachEnemy2:
    DEFB $C0, 6, 104, 48, 96 
TheBeachEnemy3:
    DEFB $80, 13, 120, 72, 184 
TheBeachEnemy4:
    DEFB $C0, 41, 200, 32, 80 
TheBeachEnemy5:
    DEFB 0, 0, 0, 0, 0
TheBeachEnemy6:
    DEFB 0, 0, 0, 0, 0
TheBeachEnemy7:
    DEFB 0, 0, 0, 0, 0
TheBeachEnemy8:
    DEFB 0, 0, 0, 0, 0

TheBeachPosWilly:
    db 100, 80                     ; Posizione di Willy
    
TheBeachEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8