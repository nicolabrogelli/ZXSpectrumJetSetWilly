;===========================================================================
; TotheKitchensMainStairway.asm  
;
; TotheKitchensMainStairwayLayout            Size 128 Byte, Start Byte   0
; TotheKitchensMainStairwayTile              Size  32 Byte, Start Byte 128
; TotheKitchensMainStairwayBackground        Size   9 Byte, Start Byte 160
; TotheKitchensMainStairwayFloor             Size   9 Byte, Start Byte 169
; TotheKitchensMainStairwayWall              Size   9 Byte, Start Byte 178
; TotheKitchensMainStairwayNasty             Size   9 Byte, Start Byte 187
; TotheKitchensMainStairwayRamp              Size   9 Byte, Start Byte 196
; TotheKitchensMainStairwayConveyor          Size   9 Byte, Start Byte 205
; TotheKitchensMainStairwayConveyorData      Size   4 Byte, Start Byte 214
; TotheKitchensMainStairwayRampData          Size   4 Byte, Start Byte 218
; TotheKitchensMainStairwayBorderColor       Size   1 Byte, Start Byte 222
; TotheKitchensMainStairwayReserved          Size   4 Byte, Start Byte 223
; TotheKitchensMainStairwayItem		         Size   8 Byte, Start Byte 227
; TotheKitchensMainStairwayDirection         Size   4 Byte, Start Byte 235
; TotheKitchensMainStairwayUnused            Size   1 Byte, Start Byte 239
; TotheKitchensMainStairwayEnemy1		     Size   5 Byte, Start Byte 240
; TotheKitchensMainStairwayEnemy2		     Size   5 Byte, Start Byte 245
; TotheKitchensMainStairwayEnemy3		     Size   5 Byte, Start Byte 250
; TotheKitchensMainStairwayEnemy4		     Size   5 Byte, Start Byte 255
; TotheKitchensMainStairwayEnemy5		     Size   5 Byte, Start Byte 260
; TotheKitchensMainStairwayEnemy6		     Size   5 Byte, Start Byte 265
; TotheKitchensMainStairwayEnemy7		     Size   5 Byte, Start Byte 270
; TotheKitchensMainStairwayEnemy8		     Size   5 Byte, Start Byte 275
; TotheKitchensMainStairwayPosWilly          Size   2 Byte, Start Byte 280
; TotheKitchensMainStairwayEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (To the Kitchens Main Stairway)
TotheKitchensMainStairwayLayout:           
	db 0,0,128,0,0,0,0,0	;Room layout
	db 0,0,128,0,0,0,0,0
	db 0,0,128,0,0,0,0,0
	db 0,0,0,0,0,0,3,0
	db 0,0,0,0,0,0,0,0
	db 0,1,149,85,85,80,0,85
	db 0,0,128,0,0,0,0,0
	db 0,0,128,0,0,0,0,0
	db 165,85,133,0,0,0,0,0
	db 160,0,128,0,0,0,85,64
	db 160,0,128,0,1,64,0,0
	db 0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0
	db 170,170,170,170,170,170,170,170
	db 170,170,170,170,170,170,170,170

TotheKitchensMainStairwayTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "To the Kitchens    Main Stairway"	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
TotheKitchensMainStairwayBackground:
    DEFB 15,0,0,0,0,0,0,0,0	            ;Background

TotheKitchensMainStairwayFloor:
    DEFB 13,255,255,0,255,0,0,0,0	    ;Floor Solid

TotheKitchensMainStairwayWall:
    DEFB 58,0,21,191,21,0,81,251,81	    ;Wall Solid

TotheKitchensMainStairwayNasty:
    DEFB 77,24,90,189,25,126,153,36,36	    ;Nasty

TotheKitchensMainStairwayRamp:
    DEFB 15,192,128,48,32,12,8,3,2	            ;Ramp Solid

TotheKitchensMainStairwayConveyor:
    DEFB 107,240,170,120,255,170,85,170,85            ;Conveyor

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
TotheKitchensMainStairwayConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 24334	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 2	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
TotheKitchensMainStairwayRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 24447                                  ;Location in the attribute buffer at 24064: (14,7)
    DEFB 12	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
TotheKitchensMainStairwayBorderColor:
    DEFB 4	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
TotheKitchensMainStairwayReserved:
    DEFB NONE, YELLOW, CYAN, MAGENTA                        ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
TotheKitchensMainStairwayItem:
    DEFB 64,160,240,248,252,122,37,2	                ;Item graphic (unused)

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
TotheKitchensMainStairwayDirection:
	DEFB 23					;Room to the left (The Kitchen)
	DEFB 21					;Room to the right (Ballroom West)
	DEFB 28					;Room above (First Landing)
	DEFB BLOCK				;Room below (The Off Licence)

TotheKitchensMainStairwayUnused:
    DEFB 0                        ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
TotheKitchensMainStairwayEnemy1:
    DEFB 0, 0, 0, 0, 0
TotheKitchensMainStairwayEnemy2:
    DEFB $80, 3, 104, 24, 168          ; [Radar (41688) - horizzontal], Guardinan = 42, Starts X=60, Y=0, Limit Y=104
TotheKitchensMainStairwayEnemy3:
    DEFB 0, 0, 0, 0, 0                  
TotheKitchensMainStairwayEnemy4:
    DEFB $80, 10, 16, 72, 48           ; [Double Ball (41704) - horizzontal], Guardinan = 41, Starts X=60, Y=0, Limit Y=104
TotheKitchensMainStairwayEnemy5:
    DEFB $80, 4, 0, 96, 240            ; [Uovo (41712) - horizzontal], Guardinan = 21, Starts X=60, Y=0, Limit Y=104
TotheKitchensMainStairwayEnemy6:
    DEFB $80, 2, 72, 80, 136           ; [Uccello (41720) - horizzontal], Guardinan = 21, Starts X=60, Y=0, Limit Y=104  
TotheKitchensMainStairwayEnemy7:
    DEFB $80, 27, 0, 24, 88
TotheKitchensMainStairwayEnemy8:
    DEFB $80, 28, 96, 48, 192

TotheKitchensMainStairwayPosWilly:
    db 200, 90                     ; Posizione di Willy
    
TotheKitchensMainStairwayEnemyColors5_8:
    DEFB GREEN, YELLOW, MAGENTA, WHITE               ; Colori per nemici 5-8