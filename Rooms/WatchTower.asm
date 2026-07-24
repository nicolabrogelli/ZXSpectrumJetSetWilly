;===========================================================================
; WatchTower.asm  
;
; WatchTowerLayout            Size 128 Byte, Start Byte   0
; WatchTowerTile              Size  32 Byte, Start Byte 128
; WatchTowerBackground        Size   9 Byte, Start Byte 160
; WatchTowerFloor             Size   9 Byte, Start Byte 169
; WatchTowerWall              Size   9 Byte, Start Byte 178
; WatchTowerNasty             Size   9 Byte, Start Byte 187
; WatchTowerRamp              Size   9 Byte, Start Byte 196
; WatchTowerConveyor          Size   9 Byte, Start Byte 205
; WatchTowerConveyorData      Size   4 Byte, Start Byte 214
; WatchTowerRampData          Size   4 Byte, Start Byte 218
; WatchTowerBorderColor       Size   1 Byte, Start Byte 222
; WatchTowerReserved          Size   4 Byte, Start Byte 223
; WatchTowerItem		        Size   8 Byte, Start Byte 227
; WatchTowerDirection         Size   4 Byte, Start Byte 235
; WatchTowerUnused            Size   1 Byte, Start Byte 239
; WatchTowerEnemy1		    Size   5 Byte, Start Byte 240
; WatchTowerEnemy2		    Size   5 Byte, Start Byte 245
; WatchTowerEnemy3		    Size   5 Byte, Start Byte 250
; WatchTowerEnemy4		    Size   5 Byte, Start Byte 255
; WatchTowerEnemy5		    Size   5 Byte, Start Byte 260
; WatchTowerEnemy6		    Size   5 Byte, Start Byte 265
; WatchTowerEnemy7		    Size   5 Byte, Start Byte 270
; WatchTowerEnemy8		    Size   5 Byte, Start Byte 275
; WatchTowerPosWilly          Size   2 Byte, Start Byte 280
; WatchTowerEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (WatchTower)
WatchTowerLayout:           
	DEFB 0,0,0,0,0,0,0,0	;Room layout
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,8,0,0,0,0,32,0
	DEFB 0,8,12,0,0,192,224,0
	DEFB 0,10,170,160,26,170,160,0
	DEFB 0,0,0,160,10,0,0,0
	DEFB 0,0,0,165,10,0,0,0
	DEFB 0,0,0,160,10,0,0,0
	DEFB 0,0,0,160,90,0,0,0
	
WatchTowerTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "          Watch Tower           "   ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
WatchTowerBackground:                    
    DEFB $0F,0,0,0,0,0,0,0,0	            ;Background

WatchTowerFloor:
    DEFB 6,255,255,170,85,170,85,0,0     ; Floor Solid

WatchTowerWall:
    DEFB 29,170,85,85,170,85,170,170,85  ; Wall Solid

WatchTowerNasty:
    DEFB 12,70,137,137,54,72,131,132,104  ; Nastry

WatchTowerRamp:
    DEFB 15,1,2,4,8,16,32,64,128         ; Ramp Solid

WatchTowerConveyor:
    DEFB 13,246,255,231,0,0,0,0,0                   ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
WatchTowerConveyorData:
    DEFB 1	                                ;Direction (right)
    DEFW 24204	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 2	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
WatchTowerRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24327                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 5	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
WatchTowerBorderColor:
    DEFB 5	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
WatchTowerReserved:
    DEFB MAGENTA, WHITE, NONE, NONE     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
WatchTowerItem:
    DEFB 116,56,102,191,191,157,66,60                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
WatchTowerDirection:
	DEFB BLOCK	;Room to the left (The Off Licence)
	DEFB BLOCK	;Room to the right (The Off Licence)
	DEFB BLOCK	;Room above (The Off Licence)
	DEFB 16		;Room below (We must perform a Quirkafleeg)

WatchTowerUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
WatchTowerEnemy1:
    DEFB $80, 14, 88, 72, 144
WatchTowerEnemy2:
    DEFB $80, 2, 72, 56, 235 
WatchTowerEnemy3:
    DEFB 0, 0, 0, 0, 0
WatchTowerEnemy4:
    DEFB 0, 0, 0, 0, 0
WatchTowerEnemy5:
    DEFB 0, 0, 0, 0, 0
WatchTowerEnemy6:
    DEFB 0, 0, 0, 0, 0
WatchTowerEnemy7:
    DEFB 0, 0, 0, 0, 0
WatchTowerEnemy8:
    DEFB 0, 0, 0, 0, 0

WatchTowerPosWilly:
    db 100, 70                     ; Posizione di Willy
    
WatchTowerEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8