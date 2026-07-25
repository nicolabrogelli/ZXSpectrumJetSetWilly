;===========================================================================
; EmergencyGenerator.asm  
;
; EmergencyGeneratorLayout            Size 128 Byte, Start Byte   0
; EmergencyGeneratorTile              Size  32 Byte, Start Byte 128
; EmergencyGeneratorBackground        Size   9 Byte, Start Byte 160
; EmergencyGeneratorFloor             Size   9 Byte, Start Byte 169
; EmergencyGeneratorWall              Size   9 Byte, Start Byte 178
; EmergencyGeneratorNasty             Size   9 Byte, Start Byte 187
; EmergencyGeneratorRamp              Size   9 Byte, Start Byte 196
; EmergencyGeneratorConveyor          Size   9 Byte, Start Byte 205
; EmergencyGeneratorConveyorData      Size   4 Byte, Start Byte 214
; EmergencyGeneratorRampData          Size   4 Byte, Start Byte 218
; EmergencyGeneratorBorderColor       Size   1 Byte, Start Byte 222
; EmergencyGeneratorReserved          Size   4 Byte, Start Byte 223
; EmergencyGeneratorItem		        Size   8 Byte, Start Byte 227
; EmergencyGeneratorDirection         Size   4 Byte, Start Byte 235
; EmergencyGeneratorUnused            Size   1 Byte, Start Byte 239
; EmergencyGeneratorEnemy1		    Size   5 Byte, Start Byte 240
; EmergencyGeneratorEnemy2		    Size   5 Byte, Start Byte 245
; EmergencyGeneratorEnemy3		    Size   5 Byte, Start Byte 250
; EmergencyGeneratorEnemy4		    Size   5 Byte, Start Byte 255
; EmergencyGeneratorEnemy5		    Size   5 Byte, Start Byte 260
; EmergencyGeneratorEnemy6		    Size   5 Byte, Start Byte 265
; EmergencyGeneratorEnemy7		    Size   5 Byte, Start Byte 270
; EmergencyGeneratorEnemy8		    Size   5 Byte, Start Byte 275
; EmergencyGeneratorPosWilly          Size   2 Byte, Start Byte 280
; EmergencyGeneratorEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (EmergencyGenerator)
EmergencyGeneratorLayout:           
    DEFB 0,0,0,0,0,0,0,10	;Room layout
    DEFB 0,0,0,0,0,0,0,10
    DEFB 0,0,0,0,0,0,0,10
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,5,0,0,0,0,80,10
    DEFB 0,5,0,0,0,0,80,3
    DEFB 0,5,0,0,0,0,80,3
    DEFB 0,5,0,0,0,0,80,3
    DEFB 0,5,0,0,0,0,80,3
    DEFB 0,42,128,0,0,2,168,3
    DEFB 0,40,128,0,0,2,40,3
    DEFB 0,170,170,170,170,170,170,3
    DEFB 0,170,42,138,162,168,170,3
    DEFB 0,170,170,170,170,170,170,3
    DEFB 170,170,170,170,170,170,170,170
	
EmergencyGeneratorTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "       Emergency Generator      "   ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
EmergencyGeneratorBackground:                    
    DEFB $0f,0,0,0,0,0,0,0,0	            ;Background

EmergencyGeneratorFloor:
    DEFB 47,102,102,102,102,102,102,102,102      ; Floor Solid

EmergencyGeneratorWall:
    DEFB 51,191,21,0,81,251,81,0,21  ; Wall Solid

EmergencyGeneratorNasty:
    DEFB 13,255,63,3,31,127,31,3,63  ; Nasty (Lightning/Hazard graphic)

EmergencyGeneratorRamp:
    DEFB 15,3,0,12,0,48,0,192,0          ; Ramp Solid

EmergencyGeneratorConveyor:
    DEFB 22,170,84,170,84,40,16,40,16                   ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
EmergencyGeneratorConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 24425	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 14	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
EmergencyGeneratorRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24402                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 6	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
EmergencyGeneratorBorderColor:
    DEFB 2	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
EmergencyGeneratorReserved:
    DEFB MAGENTA, NONE, NONE, NONE     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
EmergencyGeneratorItem:
    DEFB 0,0,0,0,0,0,0,0                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
EmergencyGeneratorDirection:
	ROOM RoomsListTable.DrJonesWillNeverBelieveThisLayout		;Room to the left (Dr Jones will never believe this)
	ROOM RoomsListTable.PriestsHoleLayout		;Room to the right (Priests' Hole)
	ROOM RoomsListTable.RescueEsmereldaLayout		;Room above (Rescue Esmerelda)
	DEFB BLOCK	;Room below (The Off Licence)

EmergencyGeneratorUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
EmergencyGeneratorEnemy1:
    DEFB $80, 12, 40, 24, 240         ; [Frate (41496) - horizontal], Guardian = 67, Starts X=16, Y=32, Limit X=88
EmergencyGeneratorEnemy2:
    DEFB 0, 0, 0, 0, 0
EmergencyGeneratorEnemy3:
    DEFB 0, 0, 0, 0, 0
EmergencyGeneratorEnemy4:
    DEFB 0, 0, 0, 0, 0
EmergencyGeneratorEnemy5:
    DEFB 0, 0, 0, 0, 0
EmergencyGeneratorEnemy6:
    DEFB 0, 0, 0, 0, 0
EmergencyGeneratorEnemy7:
    DEFB 0, 0, 0, 0, 0
EmergencyGeneratorEnemy8:
    DEFB 0, 0, 0, 0, 0

EmergencyGeneratorPosWilly:
    db 20, 104                     ; Posizione sicura di Willy sul pavimento
    
EmergencyGeneratorEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8