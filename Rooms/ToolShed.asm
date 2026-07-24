;===========================================================================
; ToolShed.asm  
;
; ToolShedLayout            Size 128 Byte, Start Byte   0
; ToolShedTile              Size  32 Byte, Start Byte 128
; ToolShedBackground        Size   9 Byte, Start Byte 160
; ToolShedFloor             Size   9 Byte, Start Byte 169
; ToolShedWall              Size   9 Byte, Start Byte 178
; ToolShedNasty             Size   9 Byte, Start Byte 187
; ToolShedRamp              Size   9 Byte, Start Byte 196
; ToolShedConveyor          Size   9 Byte, Start Byte 205
; ToolShedConveyorData      Size   4 Byte, Start Byte 214
; ToolShedRampData          Size   4 Byte, Start Byte 218
; ToolShedBorderColor       Size   1 Byte, Start Byte 222
; ToolShedReserved          Size   4 Byte, Start Byte 223
; ToolShedItem		        Size   8 Byte, Start Byte 227
; ToolShedDirection         Size   4 Byte, Start Byte 235
; ToolShedUnused            Size   1 Byte, Start Byte 239
; ToolShedEnemy1		    Size   5 Byte, Start Byte 240
; ToolShedEnemy2		    Size   5 Byte, Start Byte 245
; ToolShedEnemy3		    Size   5 Byte, Start Byte 250
; ToolShedEnemy4		    Size   5 Byte, Start Byte 255
; ToolShedEnemy5		    Size   5 Byte, Start Byte 260
; ToolShedEnemy6		    Size   5 Byte, Start Byte 265
; ToolShedEnemy7		    Size   5 Byte, Start Byte 270
; ToolShedEnemy8		    Size   5 Byte, Start Byte 275
; ToolShedPosWilly          Size   2 Byte, Start Byte 280
; ToolShedEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (ToolShed)
ToolShedLayout:           
	DEFB 0,0,2,170,160,0,0,0	;Room layout
	DEFB 0,0,10,170,160,0,0,0
	DEFB 0,0,42,170,170,170,170,170
	DEFB 0,0,0,0,192,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,170
	DEFB 0,0,0,0,0,0,0,170
	DEFB 0,0,0,0,0,0,0,170
	DEFB 170,168,0,65,0,64,42,170
	DEFB 170,168,0,0,0,0,42,170
	DEFB 170,168,0,0,0,0,106,170
	DEFB 170,168,17,0,16,0,42,170
	DEFB 170,168,0,0,0,64,42,170
	DEFB 170,168,0,0,0,0,106,170
	DEFB 170,168,0,0,0,0,42,170
	DEFB 170,170,170,170,170,170,170,170
	
ToolShedTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "           Tool  Shed           "   ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
ToolShedBackground:                    
    DEFB 7,0,0,0,0,0,0,0,0	            ;Background

ToolShedFloor:
    DEFB 5,90,255,34,68,34,64,0,0     ; Floor Solid

ToolShedWall:
    DEFB 30,85,170,68,34,85,170,68,34  ; Wall Solid

ToolShedNasty:
    DEFB 6,4,4,4,136,80,32,16,8  ; Nastry

ToolShedRamp:
    DEFB 7,3,3,12,12,48,48,192,192         ; Ramp Solid

ToolShedConveyor:
    DEFB 68,224,170,0,102,102,102,102,102                   ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
ToolShedConveyorData:
    DEFB 1	                                ;Direction (right)
    DEFW 24551	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 18	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
ToolShedRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24291                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 8	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
ToolShedBorderColor:
    DEFB 5	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
ToolShedReserved:
    DEFB CYAN, CYAN, RED, MAGENTA     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
ToolShedItem:
    DEFB 24,24,24,24,24,155,127,59                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
ToolShedDirection:
	DEFB 58		;Room to the left (The Beach)
	DEFB 49		;Room to the right (The Wine Cellar)
	DEFB 53		;Room above (Back Door)
	DEFB BLOCK	;Room below (The Off Licence)

ToolShedUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
ToolShedEnemy1:
    DEFB $C0, 0, 32, 0, 64         ; [Frate (41496) - horizontal], Guardian = 67, Starts X=16, Y=32, Limit X=88
ToolShedEnemy2:
    DEFB $C0, 6, 104, 48, 96 
ToolShedEnemy3:
    DEFB $80, 13, 120, 72, 184 
ToolShedEnemy4:
    DEFB $C0, 41, 200, 32, 80 
ToolShedEnemy5:
    DEFB 0, 0, 0, 0, 0
ToolShedEnemy6:
    DEFB 0, 0, 0, 0, 0
ToolShedEnemy7:
    DEFB 0, 0, 0, 0, 0
ToolShedEnemy8:
    DEFB 0, 0, 0, 0, 0

ToolShedPosWilly:
    db 100, 101                     ; Posizione di Willy
    
ToolShedEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8