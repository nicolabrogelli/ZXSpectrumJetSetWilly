;===========================================================================
; TheWineCellar.asm  
;
; TheWineCellarLayout            Size 128 Byte, Start Byte   0
; TheWineCellarTile              Size  32 Byte, Start Byte 128
; TheWineCellarBackground        Size   9 Byte, Start Byte 160
; TheWineCellarFloor             Size   9 Byte, Start Byte 169
; TheWineCellarWall              Size   9 Byte, Start Byte 178
; TheWineCellarNasty             Size   9 Byte, Start Byte 187
; TheWineCellarRamp              Size   9 Byte, Start Byte 196
; TheWineCellarConveyor          Size   9 Byte, Start Byte 205
; TheWineCellarConveyorData      Size   4 Byte, Start Byte 214
; TheWineCellarRampData          Size   4 Byte, Start Byte 218
; TheWineCellarBorderColor       Size   1 Byte, Start Byte 222
; TheWineCellarReserved          Size   4 Byte, Start Byte 223
; TheWineCellarItem		        Size   8 Byte, Start Byte 227
; TheWineCellarDirection         Size   4 Byte, Start Byte 235
; TheWineCellarUnused            Size   1 Byte, Start Byte 239
; TheWineCellarEnemy1		    Size   5 Byte, Start Byte 240
; TheWineCellarEnemy2		    Size   5 Byte, Start Byte 245
; TheWineCellarEnemy3		    Size   5 Byte, Start Byte 250
; TheWineCellarEnemy4		    Size   5 Byte, Start Byte 255
; TheWineCellarEnemy5		    Size   5 Byte, Start Byte 260
; TheWineCellarEnemy6		    Size   5 Byte, Start Byte 265
; TheWineCellarEnemy7		    Size   5 Byte, Start Byte 270
; TheWineCellarEnemy8		    Size   5 Byte, Start Byte 275
; TheWineCellarPosWilly          Size   2 Byte, Start Byte 280
; TheWineCellarEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (TheWineCellar)
TheWineCellarLayout:           
    DEFB 0,0,0,0,0,12,2,170	;Room layout
    DEFB 0,0,0,0,0,0,2,170
    DEFB 85,64,0,0,0,0,2,170
    DEFB 0,0,0,0,0,0,0,42
    DEFB 0,0,0,0,0,0,0,42
    DEFB 170,168,0,65,0,21,86,170
    DEFB 170,0,0,0,0,0,0,42
    DEFB 170,0,0,0,0,0,0,42
    DEFB 170,168,0,65,0,85,86,170
    DEFB 160,0,0,0,0,0,0,42
    DEFB 160,0,0,0,0,0,0,42
    DEFB 170,168,0,65,1,85,85,85
    DEFB 170,0,0,195,3,0,0,0
    DEFB 170,0,0,0,0,0,10,170
    DEFB 170,168,0,0,0,0,42,170
    DEFB 170,170,170,170,170,170,170,170

TheWineCellarTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "        The Wine Cellar         "   ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
TheWineCellarBackground:                    
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

TheWineCellarFloor:
    DEFB 66,255,24,231,16,199,56,0,0     ; Floor Solid

TheWineCellarWall:
    DEFB 41,10,65,40,5,160,20,130,80  ; Wall Solid

TheWineCellarNasty:
    DEFB 70,36,36,36,90,219,189,195,126  ; Nastry

TheWineCellarRamp:
    DEFB 7,3,3,13,14,53,58,213,234         ; Ramp Solid

TheWineCellarConveyor:
    DEFB 13,170,85,170,85,170,85,170,85                   ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
TheWineCellarConveyorData:
    DEFB 1	                                ;Direction (right)
    DEFW 24475	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 5	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
TheWineCellarRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24536                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 2	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
TheWineCellarBorderColor:
    DEFB 4	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
TheWineCellarReserved:
    DEFB MAGENTA, YELLOW, GREEN, MAGENTA     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
TheWineCellarItem:
    DEFB 0,25,249,31,0,25,255,31                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
TheWineCellarDirection:
	ROOM RoomsListTable.ToolShedLayout		    ;Room to the left (Tool  Shed)
	ROOM RoomsListTable.TheForgottenAbbeyLayout	;Room to the right (The Forgotten Abbey)
	ROOM RoomsListTable.BackStairwayLayout		;Room above (Back Stairway)
	DEFB BLOCK	                                ;Room below (The Off Licence)

TheWineCellarUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
TheWineCellarEnemy1:
    DEFB $80, FRATE, 0, 24, 216    
TheWineCellarEnemy2:
    DEFB $80, FRATE, 32, 48, 216  
TheWineCellarEnemy3:
    DEFB $80, FRATE, 16, 72, 216 
TheWineCellarEnemy4:
    DEFB $80, SEGA, 56, 104, 176 
TheWineCellarEnemy5:
    DEFB 0, 0, 0, 0, 0
TheWineCellarEnemy6:
    DEFB 0, 0, 0, 0, 0
TheWineCellarEnemy7:
    DEFB 0, 0, 0, 0, 0
TheWineCellarEnemy8:
    DEFB 0, 0, 0, 0, 0

TheWineCellarPosWilly:
    db 180, 101                     ; Posizione di Willy
    
TheWineCellarEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8