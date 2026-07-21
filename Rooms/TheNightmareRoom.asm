;===========================================================================
; TheNightmareRoom.asm  
;
; TheNightmareRoomLayout            Size 128 Byte, Start Byte   0
; TheNightmareRoomTile              Size  32 Byte, Start Byte 128
; TheNightmareRoomBackground        Size   9 Byte, Start Byte 160
; TheNightmareRoomFloor             Size   9 Byte, Start Byte 169
; TheNightmareRoomWall              Size   9 Byte, Start Byte 178
; TheNightmareRoomNasty             Size   9 Byte, Start Byte 187
; TheNightmareRoomRamp              Size   9 Byte, Start Byte 196
; TheNightmareRoomConveyor          Size   9 Byte, Start Byte 205
; TheNightmareRoomConveyorData      Size   4 Byte, Start Byte 214
; TheNightmareRoomRampData          Size   4 Byte, Start Byte 218
; TheNightmareRoomBorderColor       Size   1 Byte, Start Byte 222
; TheNightmareRoomReserved          Size   4 Byte, Start Byte 223
; TheNightmareRoomItem		        Size   8 Byte, Start Byte 227
; TheNightmareRoomDirection         Size   4 Byte, Start Byte 235
; TheNightmareRoomUnused            Size   1 Byte, Start Byte 239
; TheNightmareRoomEnemy1		    Size   5 Byte, Start Byte 240
; TheNightmareRoomEnemy2		    Size   5 Byte, Start Byte 245
; TheNightmareRoomEnemy3		    Size   5 Byte, Start Byte 250
; TheNightmareRoomEnemy4		    Size   5 Byte, Start Byte 255
; TheNightmareRoomEnemy5		    Size   5 Byte, Start Byte 260
; TheNightmareRoomEnemy6		    Size   5 Byte, Start Byte 265
; TheNightmareRoomEnemy7		    Size   5 Byte, Start Byte 270
; TheNightmareRoomEnemy8		    Size   5 Byte, Start Byte 275
; TheNightmareRoomPosWilly          Size   2 Byte, Start Byte 280
; TheNightmareRoomEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (First Landing)
TheNightmareRoomLayout:           
	DEFB 0,0,0,0,0,0,0,10	;Room layout
	DEFB 0,0,0,0,0,0,0,10
	DEFB 0,0,0,0,0,0,0,10
	DEFB 0,0,0,0,0,0,0,10
	DEFB 0,0,0,0,0,0,0,10
	DEFB 0,0,4,0,64,4,0,10
	DEFB 0,0,0,16,0,0,0,10
	DEFB 0,1,0,0,1,0,0,10
	DEFB 0,0,4,0,0,4,0,10
	DEFB 0,0,0,16,0,0,0,10
	DEFB 0,0,0,0,1,0,4,10
	DEFB 0,0,4,0,0,4,0,10
	DEFB 170,168,0,16,0,0,0,10
	DEFB 170,170,0,0,0,0,0,0
	DEFB 170,170,128,0,0,0,0,0
	DEFB 170,170,170,170,170,170,170,170
	
TheNightmareRoomTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "       The Nightmare Room       "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
TheNightmareRoomBackground:                    
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

TheNightmareRoomFloor:
    DEFB 68,255,165,82,36,66,34,64,4      ; Floor Solid

TheNightmareRoomWall:
    DEFB 51,0,42,84,0,0,162,69,0  ; Wall Solid

TheNightmareRoomNasty:
    DEFB 69,66,153,102,161,159,129,102,90  ; Nastry

TheNightmareRoomRamp:
    DEFB 7,128,192,160,240,248,92,186,2             ; Ramp Solid

TheNightmareRoomConveyor:
    DEFB 65,255,90,255,255,170,85,170,85                      ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
TheNightmareRoomConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 24315	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 1	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
TheNightmareRoomRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 24521                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 3	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
TheNightmareRoomBorderColor:
    DEFB 2	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
TheNightmareRoomReserved:
    DEFB CYAN, MAGENTA, YELLOW, RED     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
TheNightmareRoomItem:
    DEFB 172,174,1,173,173,2,172,88	                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
TheNightmareRoomDirection:
	DEFB 30				;Room to the left (The Banyan Tree)
	DEFB 28				;Room to the right (First Landing)
	DEFB BLOCK			;Room above (The Off Licence)
	DEFB BLOCK			;Room below (The Off Licence)

TheNightmareRoomUnused:
    DEFB $15                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
TheNightmareRoomEnemy1:
    DEFB $C0, 34, 64, 0, 80         ; [Vecchia (41520) - horizontal], Guardian = 67, Starts X=16, Y=32, Limit X=88
TheNightmareRoomEnemy2:
    DEFB $D0, 34, 88, 0, 104         ; [Vecchia (41520) - horizontal], Guardian = 67, Starts X=16, Y=32, Limit X=88
TheNightmareRoomEnemy3:
    DEFB $E0, 35, 112, 0, 96         ; [Vecchia (41520) - horizontal], Guardian = 67, Starts X=16, Y=32, Limit X=88
TheNightmareRoomEnemy4:
    DEFB $F0, 34, 136, 8, 104         ; [Vecchia (41520) - horizontal], Guardian = 67, Starts X=16, Y=32, Limit X=88
TheNightmareRoomEnemy5:
    DEFB $C0, 34, 160, 0, 80         ; [Vecchia (41520) - horizontal], Guardian = 67, Starts X=16, Y=32, Limit X=88
TheNightmareRoomEnemy6:
    DEFB $D0, 34, 184, 0, 104         ; [Vecchia (41520) - horizontal], Guardian = 67, Starts X=16, Y=32, Limit X=88
TheNightmareRoomEnemy7:
    DEFB $E0, 34, 224, 0, 104         ; [Vecchia (41520) - horizontal], Guardian = 67, Starts X=16, Y=32, Limit X=88
TheNightmareRoomEnemy8:
    DEFB 0, 0, 0, 0, 0

TheNightmareRoomPosWilly:
    db 200, 101                     ; Posizione di Willy
    
TheNightmareRoomEnemyColors5_8:
    DEFB CYAN, MAGENTA, NONE, NONE     ; Colori per nemici 5-8