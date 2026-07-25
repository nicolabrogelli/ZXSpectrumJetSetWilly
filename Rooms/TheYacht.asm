;===========================================================================
; TheYacht.asm  
;
; TheYachtLayout            Size 128 Byte, Start Byte   0
; TheYachtTile              Size  32 Byte, Start Byte 128
; TheYachtBackground        Size   9 Byte, Start Byte 160
; TheYachtFloor             Size   9 Byte, Start Byte 169
; TheYachtWall              Size   9 Byte, Start Byte 178
; TheYachtNasty             Size   9 Byte, Start Byte 187
; TheYachtRamp              Size   9 Byte, Start Byte 196
; TheYachtConveyor          Size   9 Byte, Start Byte 205
; TheYachtConveyorData      Size   4 Byte, Start Byte 214
; TheYachtRampData          Size   4 Byte, Start Byte 218
; TheYachtBorderColor       Size   1 Byte, Start Byte 222
; TheYachtReserved          Size   4 Byte, Start Byte 223
; TheYachtItem		        Size   8 Byte, Start Byte 227
; TheYachtDirection         Size   4 Byte, Start Byte 235
; TheYachtUnused            Size   1 Byte, Start Byte 239
; TheYachtEnemy1		    Size   5 Byte, Start Byte 240
; TheYachtEnemy2		    Size   5 Byte, Start Byte 245
; TheYachtEnemy3		    Size   5 Byte, Start Byte 250
; TheYachtEnemy4		    Size   5 Byte, Start Byte 255
; TheYachtEnemy5		    Size   5 Byte, Start Byte 260
; TheYachtEnemy6		    Size   5 Byte, Start Byte 265
; TheYachtEnemy7		    Size   5 Byte, Start Byte 270
; TheYachtEnemy8		    Size   5 Byte, Start Byte 275
; TheYachtPosWilly          Size   2 Byte, Start Byte 280
; TheYachtEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (TheYacht)
TheYachtLayout:           
	DEFB 0,0,0,0,0,0,0,0	;Room layout
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 85,96,0,0,0,0,0,0
	DEFB 0,32,0,0,0,0,0,0
	DEFB 0,32,0,0,0,0,0,0
	DEFB 0,32,0,0,0,0,0,0
	DEFB 0,32,3,3,0,192,0,0
	DEFB 85,106,170,170,170,129,85,85
	DEFB 1,0,0,0,2,129,0,0
	DEFB 1,0,0,0,2,129,0,0
	DEFB 1,0,0,0,2,129,0,0
	DEFB 1,0,0,0,2,128,0,0
	DEFB 170,170,170,170,170,128,0,0
	
TheYachtTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "           The Yacht            "   ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
TheYachtBackground:                    
    DEFB 7,0,0,0,0,0,0,0,0	            ;Background

TheYachtFloor:
    DEFB 6,187,221,221,238,0,0,0,0   ; Floor Solid

TheYachtWall:
    DEFB 61,187,119,238,221,187,119,238,221  ; Wall Solid

TheYachtNasty:
    DEFB 66,126,191,191,110,44,44,173,255  ; Nastry

TheYachtRamp:
    DEFB 7,128,64,32,16,8,4,2,1      ; Ramp Solid

TheYachtConveyor:
    DEFB 13,224,170,56,1,131,199,124,16                  ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
TheYachtConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 24565	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 11	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
TheYachtRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 24362                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 5	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
TheYachtBorderColor:
    DEFB 5	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
TheYachtReserved:
    DEFB MAGENTA, RED, NONE, NONE     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
TheYachtItem:
    DEFB 206,241,185,213,239,215,187,255               ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
TheYachtDirection:
	DEFB 60		;Room to the left (The Bow)
	DEFB 58		;Room to the right (The Beach)
	DEFB BLOCK	;Room above (The Off Licence)
	DEFB BLOCK	;Room below (The Off Licence)

TheYachtUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
TheYachtEnemy1:
    DEFB $80, 1, 32, 104, 112         
TheYachtEnemy2:
    DEFB $C0, 40, 168, 64, 104 
TheYachtEnemy3:
    DEFB 0, 0, 0, 0, 0
TheYachtEnemy4:
    DEFB 0, 0, 0, 0, 0
TheYachtEnemy5:
    DEFB 0, 0, 0, 0, 0
TheYachtEnemy6:
    DEFB 0, 0, 0, 0, 0
TheYachtEnemy7:
    DEFB 0, 0, 0, 0, 0
TheYachtEnemy8:
    DEFB 0, 0, 0, 0, 0

TheYachtPosWilly:
    db 60, 101                     ; Posizione di Willy
    
TheYachtEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8