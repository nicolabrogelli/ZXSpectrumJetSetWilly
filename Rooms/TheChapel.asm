;===========================================================================
; TheChapel.asm  
;
; TheChapel Layout            Size 128 Byte, Start Byte   0
; TheChapel Tile              Size  32 Byte, Start Byte 128
; TheChapel Background        Size   9 Byte, Start Byte 160
; TheChapel Floor             Size   9 Byte, Start Byte 169
; TheChapel Wall              Size   9 Byte, Start Byte 178
; TheChapel Nasty             Size   9 Byte, Start Byte 187
; TheChapel Ramp              Size   9 Byte, Start Byte 196
; TheChapel Conveyor          Size   9 Byte, Start Byte 205
; TheChapel ConveyorData      Size   4 Byte, Start Byte 214
; TheChapel RampData          Size   4 Byte, Start Byte 218
; TheChapel BorderColor       Size   1 Byte, Start Byte 222
; TheChapel Reserved          Size   4 Byte, Start Byte 223
; TheChapel Item		         Size   8 Byte, Start Byte 227
; TheChapel Direction         Size   4 Byte, Start Byte 235
; TheChapel Unused            Size   1 Byte, Start Byte 239
; TheChapel Enemy1		     Size   5 Byte, Start Byte 240
; TheChapel Enemy2		     Size   5 Byte, Start Byte 245
; TheChapel Enemy3		     Size   5 Byte, Start Byte 250
; TheChapel Enemy4		     Size   5 Byte, Start Byte 255
; TheChapel Enemy5		     Size   5 Byte, Start Byte 260
; TheChapel Enemy6		     Size   5 Byte, Start Byte 265
; TheChapel Enemy7		     Size   5 Byte, Start Byte 270
; TheChapel Enemy8		     Size   5 Byte, Start Byte 275
; TheChapel PosWilly          Size   2 Byte, Start Byte 280
; TheChapel EnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (The Chapel)
TheChapelLayout:           
	DEFB 0,0,0,0,0,0,0,10	;Room layout
	DEFB 0,0,0,0,0,0,0,10
	DEFB 0,0,0,0,0,0,0,10
	DEFB 0,0,0,0,0,0,0,10
	DEFB 0,0,0,0,0,0,0,10
	DEFB 0,0,0,0,0,0,0,10
	DEFB 0,0,0,0,0,0,0,10
	DEFB 0,0,0,0,0,0,128,26
	DEFB 0,0,0,0,0,2,128,26
	DEFB 0,0,0,0,0,10,128,26
	DEFB 0,0,0,0,0,42,128,26
	DEFB 0,0,0,0,0,170,128,26
	DEFB 0,0,0,0,0,0,0,26
	DEFB 0,0,0,0,0,0,0,26
	DEFB 170,170,170,170,170,170,160,170
	DEFB 170,170,170,170,170,170,160,170

TheChapelTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "           The Chapel           "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
TheChapelBackground:
    DEFB 7,0,0,0,0,0,0,0,0	            ;Background

TheChapelFloor:
    DEFB 13,73,73,73,73,73,73,73,73	    ;Floor Solid

TheChapelWall:
    DEFB 22,168,37,0,37,168,64,221,64	    ;Wall Solid

TheChapelNasty:
    DEFB 66,40,84,170,85,170,40,40,40	    ;Nasty

TheChapelRamp:
    DEFB 7,3,0,12,0,48,0,192,0	            ;Ramp Solid

TheChapelConveyor:
    DEFB 7,0,10,189,255,0,170,85,170           ;Conveyor

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
TheChapelConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
TheChapelRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24497                                  ;Location in the attribute buffer at 24064: (14,7)
    DEFB 7	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
TheChapelBorderColor:
    DEFB 2	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
TheChapelReserved:
    DEFB GREEN, GREEN, GREEN, MAGENTA                        ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
TheChapelItem:
    DEFB 16,48,56,108,198,198,108,16	                ;Item graphic (unused)

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
TheChapelDirection:
	ROOM RoomsListTable.FirstLandingLayout				;Room to the left (First Landing)
	ROOM RoomsListTable.EastWallBaseLayout				;Room to the right (East Wall Base)
	ROOM RoomsListTable.TheBathroomLayout				;Room above (The Bathroom)
	ROOM RoomsListTable.BallRoomWestLayout				;Room below (Ballroom West)

TheChapelUnused:
    DEFB 0                        ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
TheChapelEnemy1:
    DEFB $C0, 23, 216, 0, 88         ; FaceHellHL (Top-Right)
TheChapelEnemy2:
    DEFB $C0, 24, 200, 0, 88         ; FaceHellHR (Top-Left)
TheChapelEnemy3:
    DEFB $C0, 25, 208, 16, 104         ; FaceHellLL (Bottom-Center)       
TheChapelEnemy4:
    DEFB $80, 22, 0, 96, 120         
TheChapelEnemy5:
     DEFB $C0, 32, 48, 56, 80
TheChapelEnemy6:
    DEFB $C0, 33, 136, 40, 80   
TheChapelEnemy7:
    DEFB 0, 0, 0, 0, 0
TheChapelEnemy8:
    DEFB 0, 0, 0, 0, 0

TheChapelPosWilly:
    db 200, 95                     ; Posizione di Willy
    
TheChapelEnemyColors5_8:
    DEFB GREEN, CYAN, NONE, NONE               ; Colori per nemici 5-8