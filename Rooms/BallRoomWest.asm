;===========================================================================
; BallRoomWest.asm  
;
; BallRoomWestLayout            Size 128 Byte, Start Byte   0
; BallRoomWestTile              Size  32 Byte, Start Byte 128
; BallRoomWestBackground        Size   9 Byte, Start Byte 160
; BallRoomWestFloor             Size   9 Byte, Start Byte 169
; BallRoomWestWall              Size   9 Byte, Start Byte 178
; BallRoomWestNasty             Size   9 Byte, Start Byte 187
; BallRoomWestRamp              Size   9 Byte, Start Byte 196
; BallRoomWestConveyor          Size   9 Byte, Start Byte 205
; BallRoomWestConveyorData      Size   4 Byte, Start Byte 214
; BallRoomWestRampData          Size   4 Byte, Start Byte 218
; BallRoomWestBorderColor       Size   1 Byte, Start Byte 222
; BallRoomWestReserved          Size   4 Byte, Start Byte 223
; BallRoomWestItem		        Size   8 Byte, Start Byte 227
; BallRoomWestDirection         Size   4 Byte, Start Byte 235
; BallRoomWestUnused            Size   1 Byte, Start Byte 239
; BallRoomWestEnemy1		    Size   5 Byte, Start Byte 240
; BallRoomWestEnemy2		    Size   5 Byte, Start Byte 245
; BallRoomWestEnemy3		    Size   5 Byte, Start Byte 250
; BallRoomWestEnemy4		    Size   5 Byte, Start Byte 255
; BallRoomWestEnemy5		    Size   5 Byte, Start Byte 260
; BallRoomWestEnemy6		    Size   5 Byte, Start Byte 265
; BallRoomWestEnemy7		    Size   5 Byte, Start Byte 270
; BallRoomWestEnemy8		    Size   5 Byte, Start Byte 275
; BallRoomWestPosWilly          Size   2 Byte, Start Byte 280
; BallRoomWestEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (Ballroom West)
BallRoomWestLayout:           
	db 0,0,0,0,0,0,0,10	;Room layout
	db 0,0,0,0,0,0,0,10
	db 0,0,0,0,0,0,0,10
	db 0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0
	db 85,85,85,85,85,85,85,85
	db 0,0,160,0,0,0,0,0
	db 0,0,160,0,0,0,0,0
	db 0,0,160,0,0,0,85,85
	db 0,0,160,0,0,0,0,0
	db 0,0,160,0,0,0,0,0
	db 0,0,160,0,0,0,0,0
	db 0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0
	db 85,85,85,85,85,85,85,85
	db 170,170,170,170,170,170,170,170

BallRoomWestTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "         Ballroom West          "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
BallRoomWestBackground:
    DEFB $0,0,0,0,0,0,0,0,0	            ;Background

BallRoomWestFloor:
    DEFB 50,170,168,173,175,32,170,85,85	    ;Floor Solid

BallRoomWestWall:
    DEFB 35,17,34,136,17,68,136,34,68	    ;Wall Solid

BallRoomWestNasty:
    DEFB 66,40,84,170,84,168,84,20,46	    ;Nasty

BallRoomWestRamp:
    DEFB 7,192,192,48,176,12,12,3,11	            ;Ramp Solid

BallRoomWestConveyor:
    DEFB 70,255,255,255,170,85,24,24,24	            ;Conveyor

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
BallRoomWestConveyorData:
    DEFB 1	                                ;Direction (right)
    DEFW 24496	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 12	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
BallRoomWestRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 24483                                  ;Location in the attribute buffer at 24064: (14,7)
    DEFB 4	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
BallRoomWestBorderColor:
    DEFB 1	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
BallRoomWestReserved:
    DEFB MAGENTA, CYAN, MAGENTA, NONE                        ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
BallRoomWestItem:
    DEFB 4,4,174,174,162,66,66,238	                ;Item graphic (unused)

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
BallRoomWestDirection:
	DEFB 22						;Room to the left (To the Kitchens    Main Stairway)
	DEFB 20						;Room to the right (Ballroom East)
	DEFB 27						;Room above (The Chapel)
	DEFB BLOCK					;Room below (The Off Licence)

BallRoomWestUnused:
    DEFB 0                        ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
BallRoomWestEnemy1:
    DEFB $80, 13, 128, 88, 208       ; [Canguro (41224) - horizontal],  Guardian - 33, Starts X=60, Y=0, Limit Y=104  
BallRoomWestEnemy2:
    DEFB $C0, 6, 112, 48, 96         ; [Face (41280) - vertical], Guardinan = 42, Starts X=60, Y=0, Limit Y=104
BallRoomWestEnemy3:
    DEFB $E0, 6, 48, 48, 87          ; [Face (41296) - vertical], Guardinan = 40, Starts X=60, Y=0, Limit Y=104
BallRoomWestEnemy4:
    DEFB 0, 0, 0, 0, 0       
BallRoomWestEnemy5:
     DEFB 0, 0, 0, 0, 0       
BallRoomWestEnemy6:
    DEFB 0, 0, 0, 0, 0
BallRoomWestEnemy7:
    DEFB 0, 0, 0, 0, 0
BallRoomWestEnemy8:
    DEFB 0, 0, 0, 0, 0

BallRoomWestPosWilly:
    db 50, 90                     ; Posizione di Willy
    
BallRoomWestEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE               ; Colori per nemici 5-8