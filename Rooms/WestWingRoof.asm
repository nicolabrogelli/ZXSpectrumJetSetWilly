;===========================================================================
; WestWingRoof.asm  
;
; WestWingRoofLayout            Size 128 Byte, Start Byte   0
; WestWingRoofTile              Size  32 Byte, Start Byte 128
; WestWingRoofBackground        Size   9 Byte, Start Byte 160
; WestWingRoofFloor             Size   9 Byte, Start Byte 169
; WestWingRoofWall              Size   9 Byte, Start Byte 178
; WestWingRoofNasty             Size   9 Byte, Start Byte 187
; WestWingRoofRamp              Size   9 Byte, Start Byte 196
; WestWingRoofConveyor          Size   9 Byte, Start Byte 205
; WestWingRoofConveyorData      Size   4 Byte, Start Byte 214
; WestWingRoofRampData          Size   4 Byte, Start Byte 218
; WestWingRoofBorderColor       Size   1 Byte, Start Byte 222
; WestWingRoofReserved          Size   4 Byte, Start Byte 223
; WestWingRoofItem		        Size   8 Byte, Start Byte 227
; WestWingRoofDirection         Size   4 Byte, Start Byte 235
; WestWingRoofUnused            Size   1 Byte, Start Byte 239
; WestWingRoofEnemy1		    Size   5 Byte, Start Byte 240
; WestWingRoofEnemy2		    Size   5 Byte, Start Byte 245
; WestWingRoofEnemy3		    Size   5 Byte, Start Byte 250
; WestWingRoofEnemy4		    Size   5 Byte, Start Byte 255
; WestWingRoofEnemy5		    Size   5 Byte, Start Byte 260
; WestWingRoofEnemy6		    Size   5 Byte, Start Byte 265
; WestWingRoofEnemy7		    Size   5 Byte, Start Byte 270
; WestWingRoofEnemy8		    Size   5 Byte, Start Byte 275
; WestWingRoofPosWilly          Size   2 Byte, Start Byte 280
; WestWingRoofEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (WestWingRoof)
WestWingRoofLayout:           
	DEFB 0,0,0,0,0,0,0,0	Room layout
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 85,160,0,0,0,0,0,0
	DEFB 0,160,48,48,12,12,3,0
	DEFB 0,165,85,85,85,85,85,85
	DEFB 0,160,0,0,0,0,0,0
	DEFB 0,160,0,0,0,0,0,0
	DEFB 80,160,0,0,0,0,0,0
	DEFB 0,160,0,0,0,0,0,0
	DEFB 1,160,0,0,0,0,0,0
	DEFB 0,160,0,0,0,0,0,0
	DEFB 4,165,85,85,85,85,85,5
	
WestWingRoofTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "         West Wing Roof         "   ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
WestWingRoofBackground:                    
    DEFB 7,0,0,0,0,0,0,0,0	            ;Background

WestWingRoofFloor:
    DEFB 3,255,170,255,164,164,167,228,60     ; Floor Solid

WestWingRoofWall:
    DEFB 37,225,132,30,72,225,132,30,72  ; Wall Solid

WestWingRoofNasty:
    DEFB 66,24,60,126,255,175,85,58,16  ; Nastry

WestWingRoofRamp:
    DEFB 7,3,0,12,0,48,0,192,0      ; Ramp Solid

WestWingRoofConveyor:
    DEFB 255,0,0,0,0,0,0,0,0                  ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
WestWingRoofConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
WestWingRoofRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24572                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 4	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
WestWingRoofBorderColor:
    DEFB 1	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
WestWingRoofReserved:
    DEFB CYAN, CYAN, RED, MAGENTA     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
WestWingRoofItem:
    DEFB 0,0,0,10,13,60,242,192                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
WestWingRoofDirection:
	DEFB 57		;Room to the left (Above the West Bedroom)
	DEFB 37		;Room to the right (Orangery)
	DEFB BLOCK	;Room above (The Off Licence)
	DEFB 54		;Room below (West  Wing)

WestWingRoofUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
WestWingRoofEnemy1:
    DEFB $C0, 0, 32, 0, 64         ; [Frate (41496) - horizontal], Guardian = 67, Starts X=16, Y=32, Limit X=88
WestWingRoofEnemy2:
    DEFB $C0, 6, 104, 48, 96 
WestWingRoofEnemy3:
    DEFB $80, 13, 120, 72, 184 
WestWingRoofEnemy4:
    DEFB $C0, 41, 200, 32, 80 
WestWingRoofEnemy5:
    DEFB 0, 0, 0, 0, 0
WestWingRoofEnemy6:
    DEFB 0, 0, 0, 0, 0
WestWingRoofEnemy7:
    DEFB 0, 0, 0, 0, 0
WestWingRoofEnemy8:
    DEFB 0, 0, 0, 0, 0

WestWingRoofPosWilly:
    db 100, 101                     ; Posizione di Willy
    
WestWingRoofEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8