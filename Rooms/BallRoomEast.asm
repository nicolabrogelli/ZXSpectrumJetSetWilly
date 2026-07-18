;===========================================================================
; BallRoomEast.asm  
;
; BallRoomEastLayout            Size 128 Byte, Start Byte   0
; BallRoomEastTile              Size  32 Byte, Start Byte 128
; BallRoomEastBackground        Size   9 Byte, Start Byte 160
; BallRoomEastFloor             Size   9 Byte, Start Byte 169
; BallRoomEastWall              Size   9 Byte, Start Byte 178
; BallRoomEastNasty             Size   9 Byte, Start Byte 187
; BallRoomEastRamp              Size   9 Byte, Start Byte 196
; BallRoomEastConveyor          Size   9 Byte, Start Byte 205
; BallRoomEastConveyorData      Size   4 Byte, Start Byte 214
; BallRoomEastRampData          Size   4 Byte, Start Byte 218
; BallRoomEastBorderColor       Size   1 Byte, Start Byte 222
; BallRoomEastReserved          Size   4 Byte, Start Byte 223
; BallRoomEastItem		        Size   8 Byte, Start Byte 227
; BallRoomEastDirection         Size   4 Byte, Start Byte 235
; BallRoomEastUnused            Size   1 Byte, Start Byte 239
; BallRoomEastEnemy1		    Size   5 Byte, Start Byte 240
; BallRoomEastEnemy2		    Size   5 Byte, Start Byte 245
; BallRoomEastEnemy3		    Size   5 Byte, Start Byte 250
; BallRoomEastEnemy4		    Size   5 Byte, Start Byte 255
; BallRoomEastEnemy5		    Size   5 Byte, Start Byte 260
; BallRoomEastEnemy6		    Size   5 Byte, Start Byte 265
; BallRoomEastEnemy7		    Size   5 Byte, Start Byte 270
; BallRoomEastEnemy8		    Size   5 Byte, Start Byte 275
; BallRoomEastPosWilly          Size   2 Byte, Start Byte 280
; BallRoomEastEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (Ballroom East)
BallRoomEastLayout:           
    DEFB 160,64,10,0,0,0,0,0	;Room layout
    DEFB 160,64,10,0,0,0,0,0
    DEFB 160,64,10,0,0,0,0,0
    DEFB 0,64,0,0,0,0,0,0
    DEFB 0,64,0,0,0,0,0,0
    DEFB 85,85,90,10,170,170,170,170
    DEFB 0,0,16,0,0,0,0,0
    DEFB 0,0,16,0,0,0,0,0
    DEFB 0,0,21,85,85,85,85,85
    DEFB 0,0,16,0,0,0,0,0
    DEFB 0,0,16,0,0,0,0,0
    DEFB 0,0,16,0,0,0,0,0
    DEFB 0,0,16,0,0,0,0,0
    DEFB 0,0,16,0,0,0,0,0
    DEFB 170,170,170,170,170,170,170,170
    DEFB 170,170,170,170,170,170,170,170

BallRoomEastTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "         Ballroom East          "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
BallRoomEastBackground:                    ; Background
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

BallRoomEastFloor:
    DEFB 6,170,85,34,68,34,68,34,68       ; Floor Solid

BallRoomEastWall:
    DEFB 15,68,68,255,17,17,255,85,170   ; Wall Solid

BallRoomEastNasty:
    DEFB 255,0,0,0,0,0,0,0,0  ; Nastry

BallRoomEastRamp:
    DEFB 255,0,0,0,0,0,0,0,0              ; Ramp Solid

BallRoomEastConveyor:
    DEFB 255,0,0,0,0,0,0,0,0                      ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
BallRoomEastConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
BallRoomEastRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 0                                  ;Location in the attribute buffer at 24064: (14,7)
    DEFB 0	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
BallRoomEastBorderColor:
    DEFB 2	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
BallRoomEastReserved:
    DEFB NONE, MAGENTA, CYAN, YELLOW     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
BallRoomEastItem:
    DEFB 129,129,66,36,24,24,24,231	                ;Item graphic (unused)

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
BallRoomEastDirection:
    DEFB 21	        ;Room to the left (Ballroom West)
    DEFB 11	        ;Room to the right (The Hall)
    DEFB 26	        ;Room above (East Wall Base)
    DEFB BLOCK	        ;Room below (The Off Licence)

BallRoomEastUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
BallRoomEastEnemy1:
    DEFB 0, 0, 0, 0, 0
BallRoomEastEnemy2:
    DEFB $C0, 6, 40, 48, 87         ; [Face (41296) - vertical], Guardinan = 42, Starts X=60, Y=0, Limit Y=104
BallRoomEastEnemy3:
    DEFB $E0, 6, 56, 48, 96         ; [Face (41280) - vertical], Guardinan = 40, Starts X=60, Y=0, Limit Y=104
BallRoomEastEnemy4:
    DEFB $C0, 6, 88, 72, 96         ; [Face (41288) - vertical], Guardinan = 41, Starts X=60, Y=0, Limit Y=104
BallRoomEastEnemy5:
     DEFB $80, 2, 112, 80, 232        ; [Uccello (41128) - horizzontal], Guardinan = 21, Starts X=60, Y=0, Limit Y=104
BallRoomEastEnemy6:
    DEFB 0, 0, 0, 0, 0
BallRoomEastEnemy7:
    DEFB 0, 0, 0, 0, 0
BallRoomEastEnemy8:
    DEFB 0, 0, 0, 0, 0

BallRoomEastPosWilly:
    db 200, 85                     ; Posizione di Willy
    
BallRoomEastEnemyColors5_8:
    DEFB MAGENTA, NONE, NONE, NONE     ; Colori per nemici 5-8