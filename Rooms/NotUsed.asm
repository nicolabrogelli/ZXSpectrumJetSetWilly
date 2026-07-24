;===========================================================================
; NotUsed.asm  
;
; NotUsedLayout            Size 128 Byte, Start Byte   0
; NotUsedTile              Size  32 Byte, Start Byte 128
; NotUsedBackground        Size   9 Byte, Start Byte 160
; NotUsedFloor             Size   9 Byte, Start Byte 169
; NotUsedWall              Size   9 Byte, Start Byte 178
; NotUsedNasty             Size   9 Byte, Start Byte 187
; NotUsedRamp              Size   9 Byte, Start Byte 196
; NotUsedConveyor          Size   9 Byte, Start Byte 205
; NotUsedConveyorData      Size   4 Byte, Start Byte 214
; NotUsedRampData          Size   4 Byte, Start Byte 218
; NotUsedBorderColor       Size   1 Byte, Start Byte 222
; NotUsedReserved          Size   4 Byte, Start Byte 223
; NotUsedItem		        Size   8 Byte, Start Byte 227
; NotUsedDirection         Size   4 Byte, Start Byte 235
; NotUsedUnused            Size   1 Byte, Start Byte 239
; NotUsedEnemy1		    Size   5 Byte, Start Byte 240
; NotUsedEnemy2		    Size   5 Byte, Start Byte 245
; NotUsedEnemy3		    Size   5 Byte, Start Byte 250
; NotUsedEnemy4		    Size   5 Byte, Start Byte 255
; NotUsedEnemy5		    Size   5 Byte, Start Byte 260
; NotUsedEnemy6		    Size   5 Byte, Start Byte 265
; NotUsedEnemy7		    Size   5 Byte, Start Byte 270
; NotUsedEnemy8		    Size   5 Byte, Start Byte 275
; NotUsedPosWilly          Size   2 Byte, Start Byte 280
; NotUsedEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (NotUsed)
NotUsedLayout:           
	DEFB 170,10,170,170,170,170,170,170	;Room layout
	DEFB 170,10,170,170,170,170,170,170
	DEFB 170,10,170,170,170,170,170,170
	DEFB 170,10,160,170,170,170,170,170
	DEFB 170,10,160,170,0,160,0,10
	DEFB 170,10,160,170,0,160,0,10
	DEFB 170,10,160,0,0,160,0,10
	DEFB 170,10,160,0,0,160,0,10
	DEFB 0,0,5,0,0,160,0,10
	DEFB 0,0,0,0,0,0,0,10
	DEFB 0,0,0,0,0,0,0,42
	DEFB 0,0,0,1,85,85,64,170
	DEFB 0,0,0,0,0,0,2,170
	DEFB 0,0,0,0,0,0,10,170
	DEFB 0,12,3,3,0,48,42,170
	DEFB 170,170,170,170,170,170,170,170
	
NotUsedTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "           Not  Used            "   ;Room name
         
;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
NotUsedBackground:                    
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

NotUsedFloor:
    DEFB 6,255,255,0,0,0,0,0,0     ; Floor Solid

NotUsedWall:
    DEFB 10,102,153,36,36,119,136,141,114  ; Wall Solid

NotUsedNasty:
    DEFB 2,28,42,95,125,190,254,210,124  ; Nastry

NotUsedRamp:
    DEFB 67,3,2,13,2,49,8,213,34         ; Ramp Solid

NotUsedConveyor:
    DEFB 4,238,170,56,255,255,16,16,56                   ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
NotUsedConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 24384	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 13	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
NotUsedRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24536                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 6	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
NotUsedBorderColor:
    DEFB 1	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
NotUsedReserved:
    DEFB CYAN, CYAN, RED, MAGENTA     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
NotUsedItem:
    DEFB 2,29,34,94,190,124,56,16                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
NotUsedDirection:
	DEFB 45				;Room to the left (Under the Drive)
	DEFB 47				;Room to the right ([)
	DEFB 3				;Room above (At the Foot of the MegaTree)
	DEFB BLOCK			;Room below (The Off Licence)

NotUsedUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
NotUsedEnemy1:
    DEFB $C0, 0, 32, 0, 64         ; [Frate (41496) - horizontal], Guardian = 67, Starts X=16, Y=32, Limit X=88
NotUsedEnemy2:
    DEFB $C0, 6, 104, 48, 96 
NotUsedEnemy3:
    DEFB $80, 13, 120, 72, 184 
NotUsedEnemy4:
    DEFB 0, 0, 0, 0, 0
NotUsedEnemy5:
    DEFB 0, 0, 0, 0, 0
NotUsedEnemy6:
    DEFB 0, 0, 0, 0, 0
NotUsedEnemy7:
    DEFB 0, 0, 0, 0, 0
NotUsedEnemy8:
    DEFB 0, 0, 0, 0, 0

NotUsedPosWilly:
    db 200, 101                     ; Posizione di Willy
    
NotUsedEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8