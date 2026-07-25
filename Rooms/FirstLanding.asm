;===========================================================================
; FirstLanding.asm  
;
; FirstLandingLayout            Size 128 Byte, Start Byte   0
; FirstLandingTile              Size  32 Byte, Start Byte 128
; FirstLandingBackground        Size   9 Byte, Start Byte 160
; FirstLandingFloor             Size   9 Byte, Start Byte 169
; FirstLandingWall              Size   9 Byte, Start Byte 178
; FirstLandingNasty             Size   9 Byte, Start Byte 187
; FirstLandingRamp              Size   9 Byte, Start Byte 196
; FirstLandingConveyor          Size   9 Byte, Start Byte 205
; FirstLandingConveyorData      Size   4 Byte, Start Byte 214
; FirstLandingRampData          Size   4 Byte, Start Byte 218
; FirstLandingBorderColor       Size   1 Byte, Start Byte 222
; FirstLandingReserved          Size   4 Byte, Start Byte 223
; FirstLandingItem		        Size   8 Byte, Start Byte 227
; FirstLandingDirection         Size   4 Byte, Start Byte 235
; FirstLandingUnused            Size   1 Byte, Start Byte 239
; FirstLandingEnemy1		    Size   5 Byte, Start Byte 240
; FirstLandingEnemy2		    Size   5 Byte, Start Byte 245
; FirstLandingEnemy3		    Size   5 Byte, Start Byte 250
; FirstLandingEnemy4		    Size   5 Byte, Start Byte 255
; FirstLandingEnemy5		    Size   5 Byte, Start Byte 260
; FirstLandingEnemy6		    Size   5 Byte, Start Byte 265
; FirstLandingEnemy7		    Size   5 Byte, Start Byte 270
; FirstLandingEnemy8		    Size   5 Byte, Start Byte 275
; FirstLandingPosWilly          Size   2 Byte, Start Byte 280
; FirstLandingEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (First Landing)
FirstLandingLayout:           
	DEFB 160,0,0,0,0,0,160,0	;Room layout
	DEFB 160,0,0,0,0,0,160,0
	DEFB 160,0,0,0,0,0,160,0
	DEFB 160,0,0,0,0,0,160,48
	DEFB 160,0,0,0,0,0,160,252
	DEFB 160,0,0,0,0,0,160,48
	DEFB 160,0,0,0,0,0,160,48
	DEFB 160,0,0,0,0,0,160,48
	DEFB 160,0,0,0,0,0,160,0
	DEFB 160,0,0,0,0,0,160,0
	DEFB 160,0,0,0,0,0,160,0
	DEFB 160,0,0,0,0,0,160,0
	DEFB 160,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,170,170
	DEFB 85,85,85,85,85,80,170,170

FirstLandingTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "        First Landing           "    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
FirstLandingBackground:                    
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

FirstLandingFloor:
    DEFB 4,255,170,85,128,93,148,93,128      ; Floor Solid

FirstLandingWall:
    DEFB 86,34,85,0,85,136,85,0,34  ; Wall Solid

FirstLandingNasty:
    DEFB 86,126,129,165,153,153,165,129,126  ; Nasty

FirstLandingRamp:
    DEFB 7,3,3,12,12,48,48,192,192              ; Ramp Solid

FirstLandingConveyor:
    DEFB 255,0,0,0,0,0,0,0,0                      ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
FirstLandingConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
FirstLandingRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24521                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 15	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
FirstLandingBorderColor:
    DEFB 3	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
FirstLandingReserved:
    DEFB YELLOW, NONE, NONE, NONE     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
FirstLandingItem:
    DEFB 16,48,56,108,198,198,108,16	                ;Item graphic

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
FirstLandingDirection:
	ROOM RoomsListTable.TheNightmareRoomLayout				;Room to the left (The Nightmare Room)
	ROOM RoomsListTable.TheChapelLayout				;Room to the right (The Chapel)
	ROOM RoomsListTable.TopLandingLayout				;Room above (Top Landing)
	ROOM RoomsListTable.TotheKitchensMainStairwayLayout				;Room below (To the Kitchens    Main Stairway)

FirstLandingUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
FirstLandingEnemy1:
    DEFB $80, FRATE, 192, 96, 240  
FirstLandingEnemy2:
    DEFB 0, 0, 0, 0, 0
FirstLandingEnemy3:
    DEFB 0, 0, 0, 0, 0
FirstLandingEnemy4:
    DEFB 0, 0, 0, 0, 0
FirstLandingEnemy5:
    DEFB 0, 0, 0, 0, 0
FirstLandingEnemy6:
    DEFB 0, 0, 0, 0, 0
FirstLandingEnemy7:
    DEFB 0, 0, 0, 0, 0
FirstLandingEnemy8:
    DEFB 0, 0, 0, 0, 0

FirstLandingPosWilly:
    db 200, 95                     ; Posizione di Willy
    
FirstLandingEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8