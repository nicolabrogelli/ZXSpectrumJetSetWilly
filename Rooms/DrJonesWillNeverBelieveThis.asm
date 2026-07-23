;===========================================================================
; DrJonesWillNeverBelieveThis.asm  
;
; DrJonesWillNeverBelieveThisLayout            Size 128 Byte, Start Byte   0
; DrJonesWillNeverBelieveThisTile              Size  32 Byte, Start Byte 128
; DrJonesWillNeverBelieveThisBackground        Size   9 Byte, Start Byte 160
; DrJonesWillNeverBelieveThisFloor             Size   9 Byte, Start Byte 169
; DrJonesWillNeverBelieveThisWall              Size   9 Byte, Start Byte 178
; DrJonesWillNeverBelieveThisNasty             Size   9 Byte, Start Byte 187
; DrJonesWillNeverBelieveThisRamp              Size   9 Byte, Start Byte 196
; DrJonesWillNeverBelieveThisConveyor          Size   9 Byte, Start Byte 205
; DrJonesWillNeverBelieveThisConveyorData      Size   4 Byte, Start Byte 214
; DrJonesWillNeverBelieveThisRampData          Size   4 Byte, Start Byte 218
; DrJonesWillNeverBelieveThisBorderColor       Size   1 Byte, Start Byte 222
; DrJonesWillNeverBelieveThisReserved          Size   4 Byte, Start Byte 223
; DrJonesWillNeverBelieveThisItem		        Size   8 Byte, Start Byte 227
; DrJonesWillNeverBelieveThisDirection         Size   4 Byte, Start Byte 235
; DrJonesWillNeverBelieveThisUnused            Size   1 Byte, Start Byte 239
; DrJonesWillNeverBelieveThisEnemy1		    Size   5 Byte, Start Byte 240
; DrJonesWillNeverBelieveThisEnemy2		    Size   5 Byte, Start Byte 245
; DrJonesWillNeverBelieveThisEnemy3		    Size   5 Byte, Start Byte 250
; DrJonesWillNeverBelieveThisEnemy4		    Size   5 Byte, Start Byte 255
; DrJonesWillNeverBelieveThisEnemy5		    Size   5 Byte, Start Byte 260
; DrJonesWillNeverBelieveThisEnemy6		    Size   5 Byte, Start Byte 265
; DrJonesWillNeverBelieveThisEnemy7		    Size   5 Byte, Start Byte 270
; DrJonesWillNeverBelieveThisEnemy8		    Size   5 Byte, Start Byte 275
; DrJonesWillNeverBelieveThisPosWilly          Size   2 Byte, Start Byte 280
; DrJonesWillNeverBelieveThisEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (DrJonesWillNeverBelieveThis)
DrJonesWillNeverBelieveThisLayout:           
    DEFB 0,0,0,0,0,0,0,0	;Room layout
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,234,0,0,0,0
    DEFB 0,0,0,170,160,0,0,0
    DEFB 0,0,0,149,84,0,0,0
    DEFB 0,14,168,213,21,0,0,0
    DEFB 0,10,170,129,170,0,0,0
    DEFB 0,5,80,144,168,32,0,0
    DEFB 80,5,80,129,160,0,0,0
    DEFB 0,10,80,144,160,0,0,0
    DEFB 4,10,80,129,128,64,0,0
    DEFB 0,18,80,144,128,0,0,0
    DEFB 0,66,80,1,128,16,0,16
    DEFB 0,2,0,1,128,0,64,0
    DEFB 0,2,148,1,144,0,0,0
    DEFB 0,0,0,0,0,0,0,0
	
DrJonesWillNeverBelieveThisTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "Dr Jones will never believe this"   ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
DrJonesWillNeverBelieveThisBackground:                    
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

DrJonesWillNeverBelieveThisFloor:
    DEFB 2,254,85,42,170,85,170,170,255     ; Floor Solid

DrJonesWillNeverBelieveThisWall:
    DEFB 31,17,68,34,136,17,68,34,136  ; Wall Solid

DrJonesWillNeverBelieveThisNasty:
    DEFB 10,24,60,126,24,24,0,24,0  ; Nasty (Hazard graphic)

DrJonesWillNeverBelieveThisRamp:
    DEFB 5,64,144,36,72,18,36,9,2          ; Ramp Solid

DrJonesWillNeverBelieveThisConveyor:
    DEFB 38,165,0,165,0,170,255,255,85                   ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
DrJonesWillNeverBelieveThisConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 24544	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 32	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
DrJonesWillNeverBelieveThisRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 24408                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 5	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
DrJonesWillNeverBelieveThisBorderColor:
    DEFB 1	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
DrJonesWillNeverBelieveThisReserved:
    DEFB CYAN, CYAN, RED, MAGENTA     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
DrJonesWillNeverBelieveThisItem:
    DEFB 240,240,120,184,76,50,13,3                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
DrJonesWillNeverBelieveThisDirection:
	DEFB 41		;Room to the left (The Attic)
	DEFB 39		;Room to the right (Emergency Generator)
	DEFB 16		;Room above (We must perform a Quirkafleeg)
	DEFB BLOCK	;Room below (The Off Licence)

DrJonesWillNeverBelieveThisUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
DrJonesWillNeverBelieveThisEnemy1:
    DEFB $80, 22, 192, 64, 240         ; [Frate (41496) - horizontal], Guardian = 67, Starts X=16, Y=32, Limit X=88
DrJonesWillNeverBelieveThisEnemy2:
    DEFB 0, 0, 0, 0, 0
DrJonesWillNeverBelieveThisEnemy3:
    DEFB 0, 0, 0, 0, 0
DrJonesWillNeverBelieveThisEnemy4:
    DEFB 0, 0, 0, 0, 0
DrJonesWillNeverBelieveThisEnemy5:
    DEFB 0, 0, 0, 0, 0
DrJonesWillNeverBelieveThisEnemy6:
    DEFB 0, 0, 0, 0, 0
DrJonesWillNeverBelieveThisEnemy7:
    DEFB 0, 0, 0, 0, 0
DrJonesWillNeverBelieveThisEnemy8:
    DEFB 0, 0, 0, 0, 0

DrJonesWillNeverBelieveThisPosWilly:
    db 50, 80                     ; Posizione sicura di Willy sul pavimento
    
DrJonesWillNeverBelieveThisEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8