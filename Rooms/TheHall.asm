;===========================================================================
; TheHall.asm  
;
; TheHallLayout       Size 128 Byte, Start Byte   0
; TheHallTile         Size  32 Byte, Start Byte 128
; TheHallBackground   Size   9 Byte, Start Byte 160
; TheHallFloor        Size   9 Byte, Start Byte 169
; TheHallWall         Size   9 Byte, Start Byte 178
; TheHallNasty        Size   9 Byte, Start Byte 187
; TheHallRamp         Size   9 Byte, Start Byte 196
; TheHallConveyor     Size   9 Byte, Start Byte 205
; TheHallConveyorData Size   4 Byte, Start Byte 214
; TheHallRampData     Size   4 Byte, Start Byte 218
; TheHallBorderColor  Size   1 Byte, Start Byte 222
; TheHallReserved     Size   4 Byte, Start Byte 223
; TheHallItem		    Size   8 Byte, Start Byte 227
; TheHallDirection    Size   4 Byte, Start Byte 235
; TheHallUnused       Size   1 Byte, Start Byte 239
; TheHallEnemy1		Size   5 Byte, Start Byte 240
; TheHallEnemy2		Size   5 Byte, Start Byte 245
; TheHallEnemy3		Size   5 Byte, Start Byte 250
; TheHallEnemy4		Size   5 Byte, Start Byte 255
; TheHallPosWilly     Size   2 Byte, Start Byte 280
;
;===========================================================================

; Room layout for Room  (The Hall)
TheHallLayout:           
	DEFB 0,0,0,0,0,0,0,0	;Room layout
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 170,170,170,170,170,170,170,170
	DEFB 0,0,0,0,0,40,0,0
	DEFB 0,0,0,0,0,40,0,0
	DEFB 0,0,0,0,0,40,0,0
	DEFB 0,0,0,0,0,40,0,0
	DEFB 0,0,0,0,0,40,0,0
	DEFB 0,0,0,0,0,40,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,192,192,48,0,0,0
	DEFB 170,170,170,170,170,170,170,170
	DEFB 170,170,170,170,170,170,170,170

TheHallTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "            The Hall            "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
TheHallBackground:
    DEFB 0,0,0,0,0,0,0,0,0	            		;Background

TheHallFloor:
    DEFB 71,255,170,119,170,119,170,85,170	    ;Floor Solid

TheHallWall:
    DEFB 58,32,16,14,193,48,9,198,32	    	;Wall Solid

TheHallNasty:
    DEFB 68,136,169,169,187,191,191,191,94	     ;Nasty

TheHallRamp:
    DEFB 7,192,192,48,48,12,12,3,3	        ;Ramp Solid

TheHallConveyor:
    DEFB 255,0,0,0,0,0,0,0,0	            ;Conveyor

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
TheHallConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
TheHallRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 24485	                            ;Location in the attribute buffer at 24064: (14,7)
    DEFB 6	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
TheHallBorderColor:
    DEFB 4	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
TheHallReserved:
    DEFB RED, YELLOW, YELLOW, 7                         ; Enemy colors: all WHITE (7)

;The next eight bytes are copied to 32993 and define the item graphic.
TheHallItem:
    DEFB 0,0,0,0,0,0,0,0	         ;Item graphic (unused)

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
TheHallDirection:
    DEFB 20	                        ;Room to the left (Ballroom East)
    DEFB 10	                        ;Room to the right (The Front Door)
    DEFB BLOCK	                        ;Room above (The Off Licence)
    DEFB BLOCK	                        ;Room below (The Off Licence)

TheHallUnused:
    DEFB 0                        ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
TheHallEnemy1:
    DEFB $80, 12, 40, 24, 240         ; [Maiale (41168) - horizzontal], Guardian = 26, Starts X=40, Y=24, Limit X=240
TheHallEnemy2:
    DEFB $C0, 16, 80, 48, 60          ; [Candelabro (41672) - horizzontal], Guardian = 89, Starts X=40, Y=24, Limit X=240
TheHallEnemy3:
    DEFB $80, 2, 72, 80, 136         ; [Ucello (41720) - horizzontal], Guardian = 26, Starts X=40, Y=24, Limit X=240
TheHallEnemy4:
    DEFB 0, 0, 0, 0, 0         ; Empty slot
TheHallEnemy5:
    DEFB 0, 0, 0, 0, 0
TheHallEnemy6:
    DEFB 0, 0, 0, 0, 0
TheHallEnemy7:
    DEFB 0, 0, 0, 0, 0
TheHallEnemy8:
    DEFB 0, 0, 0, 0, 0

TheHallPosWilly:
    db 50, 20                   ; Posizione di Willy
    
TheHallEnemyColors5_8:
    DEFB 2, 3, 4, 7               ; Colori per nemici 5-8