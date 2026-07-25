;===========================================================================
; TheKitchen.asm  
;
; TheKitchenLayout            Size 128 Byte, Start Byte   0
; TheKitchenTile              Size  32 Byte, Start Byte 128
; TheKitchenBackground        Size   9 Byte, Start Byte 160
; TheKitchenFloor             Size   9 Byte, Start Byte 169
; TheKitchenWall              Size   9 Byte, Start Byte 178
; TheKitchenNasty             Size   9 Byte, Start Byte 187
; TheKitchenRamp              Size   9 Byte, Start Byte 196
; TheKitchenConveyor          Size   9 Byte, Start Byte 205
; TheKitchenConveyorData      Size   4 Byte, Start Byte 214
; TheKitchenRampData          Size   4 Byte, Start Byte 218
; TheKitchenBorderColor       Size   1 Byte, Start Byte 222
; TheKitchenReserved          Size   4 Byte, Start Byte 223
; TheKitchenItem		         Size   8 Byte, Start Byte 227
; TheKitchenDirection         Size   4 Byte, Start Byte 235
; TheKitchenUnused            Size   1 Byte, Start Byte 239
; TheKitchenEnemy1		     Size   5 Byte, Start Byte 240
; TheKitchenEnemy2		     Size   5 Byte, Start Byte 245
; TheKitchenEnemy3		     Size   5 Byte, Start Byte 250
; TheKitchenEnemy4		     Size   5 Byte, Start Byte 255
; TheKitchenEnemy5		     Size   5 Byte, Start Byte 260
; TheKitchenEnemy6		     Size   5 Byte, Start Byte 265
; TheKitchenEnemy7		     Size   5 Byte, Start Byte 270
; TheKitchenEnemy8		     Size   5 Byte, Start Byte 275
; TheKitchenPosWilly          Size   2 Byte, Start Byte 280
; TheKitchenEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (The Kitchen)
TheKitchenLayout:           
	DEFB 0,0,0,0,0,0,0,0	;Room layout
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 84,21,65,80,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,4,0,0,0
	DEFB 84,21,64,0,0,0,0,42
	DEFB 0,0,1,80,0,0,0,170
	DEFB 0,0,0,0,0,0,2,170
	DEFB 0,0,0,0,0,0,0,0
	DEFB 84,21,65,80,0,0,0,0
	DEFB 0,0,0,0,21,0,0,0
	DEFB 0,0,0,0,0,2,170,170
	DEFB 170,170,170,170,170,170,170,170

TheKitchenTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "          The Kitchen           "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
TheKitchenBackground:                    ; Background
    DEFB 7,0,0,0,0,0,0,0,0	            ;Background

TheKitchenFloor:
    DEFB 4,254,1,125,133,129,129,129,1       ; Floor Solid

TheKitchenWall:
    DEFB 77,66,165,90,36,36,90,165,66   ; Wall Solid

TheKitchenNasty:
    DEFB 255,0,0,0,0,0,0,0,0  ; Nastry

TheKitchenRamp:
    DEFB 71,3,0,12,0,48,0,192,0              ; Ramp Solid

TheKitchenConveyor:
    DEFB 255,0,0,0,0,0,0,0,0                      ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
TheKitchenConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
TheKitchenRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24534                                  ;Location in the attribute buffer at 24064: (14,7)
    DEFB 7	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
TheKitchenBorderColor:
    DEFB 4	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
TheKitchenReserved:
    DEFB MAGENTA, YELLOW, GREEN, MAGENTA     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
TheKitchenItem:
    DEFB 32,64,160,24,22,9,8,4	                ;Item graphic (unused)

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
TheKitchenDirection:
	ROOM RoomsListTable.WestOfKitchenLayout		            ;Room to the left (West of Kitchen)
	ROOM RoomsListTable.TotheKitchensMainStairwayLayout		;Room to the right (To the Kitchens    Main Stairway)
	DEFB BLOCK	                                            ;Room above (The Off Licence)
	DEFB BLOCK	                                            ;Room below (The Off Licence)

TheKitchenUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
TheKitchenEnemy1:
    DEFB $C0, 29, 24, 8, 104
TheKitchenEnemy2:
    DEFB $E0, 29, 72, 0, 104         ; [Face (41296) - vertical], Guardinan = 42, Starts X=60, Y=0, Limit Y=104
TheKitchenEnemy3:
    DEFB $C0, 29, 120, 0, 104         ; [Face (41280) - vertical], Guardinan = 40, Starts X=60, Y=0, Limit Y=104
TheKitchenEnemy4:
    DEFB $E0, 29, 160, 0, 104         ; [Face (41288) - vertical], Guardinan = 41, Starts X=60, Y=0, Limit Y=104
TheKitchenEnemy5:
     DEFB 0, 0, 0, 0, 0
TheKitchenEnemy6:
    DEFB 0, 0, 0, 0, 0
TheKitchenEnemy7:
    DEFB 0, 0, 0, 0, 0
TheKitchenEnemy8:
    DEFB 0, 0, 0, 0, 0

TheKitchenPosWilly:
    db 100, 104                     ; Posizione di Willy
    
TheKitchenEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8