;===========================================================================
; BackStairway.asm  
;
; BackStairwayLayout            Size 128 Byte, Start Byte   0
; BackStairwayTile              Size  32 Byte, Start Byte 128
; BackStairwayBackground        Size   9 Byte, Start Byte 160
; BackStairwayFloor             Size   9 Byte, Start Byte 169
; BackStairwayWall              Size   9 Byte, Start Byte 178
; BackStairwayNasty             Size   9 Byte, Start Byte 187
; BackStairwayRamp              Size   9 Byte, Start Byte 196
; BackStairwayConveyor          Size   9 Byte, Start Byte 205
; BackStairwayConveyorData      Size   4 Byte, Start Byte 214
; BackStairwayRampData          Size   4 Byte, Start Byte 218
; BackStairwayBorderColor       Size   1 Byte, Start Byte 222
; BackStairwayReserved          Size   4 Byte, Start Byte 223
; BackStairwayItem		        Size   8 Byte, Start Byte 227
; BackStairwayDirection         Size   4 Byte, Start Byte 235
; BackStairwayUnused            Size   1 Byte, Start Byte 239
; BackStairwayEnemy1		    Size   5 Byte, Start Byte 240
; BackStairwayEnemy2		    Size   5 Byte, Start Byte 245
; BackStairwayEnemy3		    Size   5 Byte, Start Byte 250
; BackStairwayEnemy4		    Size   5 Byte, Start Byte 255
; BackStairwayEnemy5		    Size   5 Byte, Start Byte 260
; BackStairwayEnemy6		    Size   5 Byte, Start Byte 265
; BackStairwayEnemy7		    Size   5 Byte, Start Byte 270
; BackStairwayEnemy8		    Size   5 Byte, Start Byte 275
; BackStairwayPosWilly          Size   2 Byte, Start Byte 280
; BackStairwayEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (BackStairway)
BackStairwayLayout:           
	DEFB 0,0,0,0,10,170,170,170		;Room layout
	DEFB 0,0,0,0,42,170,170,170
	DEFB 0,0,0,0,85,85,85,85
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,21,85,85,85,85
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,5,85,85,85,85,85
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 85,84,85,85,85,85,85,85
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 85,85,85,85,85,85,85,85
	
BackStairwayTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "         Back Stairway          "   ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
BackStairwayBackground:                    
    DEFB 7,0,0,0,0,0,0,0,0	            ;Background

BackStairwayFloor:
    DEFB 67,255,68,68,255,17,17,255,0     ; Floor Solid

BackStairwayWall:
    DEFB 30,21,241,143,168,138,248,31,21  ; Wall Solid

BackStairwayNasty:
    DEFB 255,0,0,0,0,0,0,0,0  ; Nastry

BackStairwayRamp:
    DEFB 71,3,1,12,4,48,16,192,64        ; Ramp Solid

BackStairwayConveyor:
    DEFB 255,0,0,0,0,0,0,0,0                  ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
BackStairwayConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
BackStairwayRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24546                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 16	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
BackStairwayBorderColor:
    DEFB 2	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
BackStairwayReserved:
    DEFB CYAN, CYAN, RED, NONE     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
BackStairwayItem:
    DEFB 0,0,0,0,0,0,0,0                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
BackStairwayDirection:
	DEFB 53		;Room to the left (Back Door)
	DEFB 25		;Room to the right (Cold Store)
	DEFB 54		;Room above (West  Wing)
	DEFB 49		;Room below (The Wine Cellar)

BackStairwayUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
BackStairwayEnemy1:
    DEFB $80, 4, 80, 104, 235         
BackStairwayEnemy2:
    DEFB $80, 28, 96, 48, 192 
BackStairwayEnemy3:
    DEFB $C0, 15, 24, 0, 64 
BackStairwayEnemy4:
    DEFB 0, 0, 0, 0, 0
BackStairwayEnemy5:
    DEFB 0, 0, 0, 0, 0
BackStairwayEnemy6:
    DEFB 0, 0, 0, 0, 0
BackStairwayEnemy7:
    DEFB 0, 0, 0, 0, 0
BackStairwayEnemy8:
    DEFB 0, 0, 0, 0, 0

BackStairwayPosWilly:
    db 100, 101                     ; Posizione di Willy
    
BackStairwayEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8