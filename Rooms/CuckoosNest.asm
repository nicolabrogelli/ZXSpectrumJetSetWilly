;===========================================================================
; CuckoosNest.asm  
;
; CuckoosNestLayout       Size 128 Byte, Start Byte   0
; CuckoosNestTile         Size  32 Byte, Start Byte 128
; CuckoosNestBackground   Size   9 Byte, Start Byte 160
; CuckoosNestFloor        Size   9 Byte, Start Byte 169
; CuckoosNestWall         Size   9 Byte, Start Byte 178
; CuckoosNestNasty        Size   9 Byte, Start Byte 187
; CuckoosNestRamp         Size   9 Byte, Start Byte 196
; CuckoosNestConveyor     Size   9 Byte, Start Byte 205
; CuckoosNestConveyorData Size   4 Byte, Start Byte 214
; CuckoosNestRampData     Size   4 Byte, Start Byte 218
; CuckoosNestBorderColor  Size   1 Byte, Start Byte 222
; CuckoosNestReserved     Size   4 Byte, Start Byte 223
; CuckoosNestItem		    Size   8 Byte, Start Byte 227
; CuckoosNestDirection    Size   4 Byte, Start Byte 235
; CuckoosNestUnused       Size   1 Byte, Start Byte 239
; CuckoosNestEnemy1		Size   4 Byte, Start Byte 240
; CuckoosNestEnemy2		Size   4 Byte, Start Byte 244
; CuckoosNestEnemy3		Size   4 Byte, Start Byte 248
; CuckoosNestEnemy4		Size   4 Byte, Start Byte 252
; CuckoosNestPosWilly     Size   2 Byte, Start Byte 256
;
;===========================================================================

; Room layout for Room  (Master Bedroom)
CuckoosNestLayout:           
	DEFB 0,0,0,0,0,0,0,0	; Room layout
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,240,0,0,0
	DEFB 0,0,0,1,84,0,0,0
	DEFB 0,0,0,5,84,0,0,0
	DEFB 170,170,170,169,84,0,0,0
	DEFB 0,0,0,5,80,0,0,0
	DEFB 0,0,0,0,0,0,0,0

CuckoosNestTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "         Cuckoo's Nest          "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
CuckoosNestBackground:
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

CuckoosNestFloor:
    DEFB 4,4,3,201,216,48,54,35,1	    ;Floor Solid

CuckoosNestWall:
    DEFB 22,255,96,14,240,3,60,199,56	    ;Wall Solid

CuckoosNestNasty:
    DEFB 6,194,52,11,68,136,11,48,8	    ;Nasty

CuckoosNestRamp:
    DEFB 7,3,0,12,0,48,0,192,0	            ;Ramp Solid

CuckoosNestConveyor:
    DEFB 255,0,0,0,0,0,0,0,0	            ;Conveyor

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
CuckoosNestConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
CuckoosNestRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24461	                                ;Location in the attribute buffer at 24064: (14,7)
    DEFB 2	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
CuckoosNestBorderColor:
    DEFB 4	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
CuckoosNestReserved:
    DEFB 2, 3, 4, 7                         ; Enemy colors: all WHITE (7)

;The next eight bytes are copied to 32993 and define the item graphic.
CuckoosNestItem:
    DEFB 32,24,169,219,126,126,60,90	                ;Item graphic (unused)

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
CuckoosNestDirection:
	DEFB 8		;Room to the left (Inside the MegaTrunk)
	DEFB $FF	;Room to the right (The Off Licence)
	DEFB $FF	;Room above (The Off Licence)
	DEFB 2		;Room below (Under the MegaTree)

CuckoosNestUnused:
    DEFB 0                        ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
CuckoosNestEnemy1:
    DEFB $82, 8, 76, 200         ; Enemy 1 (Uccello), horizontal, Starts X=8, Y=120, Limit X=200
CuckoosNestEnemy2:
    DEFB $82, 80, 76, 180         ; Enemy 2 (Uccello), horizontal, Starts X=80, Y=80, Limit X=180
CuckoosNestEnemy3:
    DEFB $C5, 120, 16, 76        ; Enemy 3 (Ufo), vertical, Starts X=120, Y=40, Limit Y=130
CuckoosNestEnemy4:
    DEFB 0,0,0,0                  ; Empty slot
CuckoosNestEnemy5:
    DEFB 0,0,0,0
CuckoosNestEnemy6:
    DEFB 0,0,0,0
CuckoosNestEnemy7:
    DEFB 0,0,0,0
CuckoosNestEnemy8:
    DEFB 0,0,0,0

CuckoosNestPosWilly:
    db 30, 80                   ; Posizione di Willy
CuckoosNestEnemyColors5_8:
    DEFB 2, 3, 4, 7               ; Colori per nemici 5-8