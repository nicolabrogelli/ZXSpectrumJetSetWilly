;===========================================================================
; TreeTop.asm  
;
; TreeTopLayout       Size 128 Byte, Start Byte   0
; TreeTopTile         Size  32 Byte, Start Byte 128
; TreeTopBackground   Size   9 Byte, Start Byte 160
; TreeTopFloor        Size   9 Byte, Start Byte 169
; TreeTopWall         Size   9 Byte, Start Byte 178
; TreeTopNasty        Size   9 Byte, Start Byte 187
; TreeTopRamp         Size   9 Byte, Start Byte 196
; TreeTopConveyor     Size   9 Byte, Start Byte 205
; TreeTopConveyorData Size   4 Byte, Start Byte 214
; TreeTopRampData     Size   4 Byte, Start Byte 218
; TreeTopBorderColor  Size   1 Byte, Start Byte 222
; TreeTopReserved     Size   4 Byte, Start Byte 223
; TreeTopItem		    Size   8 Byte, Start Byte 227
; TreeTopDirection    Size   4 Byte, Start Byte 235
; TreeTopUnused       Size   1 Byte, Start Byte 239
; TreeTopEnemy1		Size   5 Byte, Start Byte 240
; TreeTopEnemy2		Size   5 Byte, Start Byte 245
; TreeTopEnemy3		Size   5 Byte, Start Byte 250
; TreeTopEnemy4		Size   5 Byte, Start Byte 255
; TreeTopPosWilly     Size   2 Byte, Start Byte 280
;
;===========================================================================

; Room layout for Room  (Tree Top)
TreeTopLayout:           
	DEFB 0,0,0,0,0,0,0,0	;Room layout
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,64,0,0,0
	DEFB 0,0,84,0,0,0,0,0
	DEFB 0,0,0,20,0,4,0,0
	DEFB 1,80,0,0,20,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,20,0,0
	DEFB 85,85,84,0,8,0,0,0
	DEFB 12,243,200,16,8,0,80,0
	DEFB 207,63,8,0,8,80,0,0
	DEFB 48,48,8,0,88,0,0,0

TreeTopTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "            Tree Top            "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
TreeTopBackground:
    DEFB 40,0,0,0,0,0,0,0,0	            		;Background

TreeTopFloor:
    DEFB 4,170,85,170,88,48,16,16,8	    ;Floor Solid

TreeTopWall:
    DEFB 22,165,40,82,85,85,73,162,181	    	;Wall Solid

TreeTopNasty:
    DEFB 66,137,74,18,52,24,52,82,145	     ;Nasty

TreeTopRamp:
    DEFB 7,64,0,16,0,4,0,1,0	        ;Ramp Solid

TreeTopConveyor:
    DEFB 255,0,0,0,0,0,0,0,0	            ;Conveyor

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
TreeTopConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
TreeTopRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 24527	                            ;Location in the attribute buffer at 24064: (14,7)
    DEFB 2	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
TreeTopBorderColor:
    DEFB 4	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
TreeTopReserved:
    DEFB 2, 3, 4, 7                         ; Enemy colors: all WHITE (7)

;The next eight bytes are copied to 32993 and define the item graphic.
TreeTopItem:
    DEFB 30,45,55,123,109,94,184,192	         ;Item graphic (unused)

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
TreeTopDirection:
	DEFB 13									;Room to the left (Out on a limb)
	DEFB 0									;Room to the right (The Off Licence)
	DEFB 0									;Room above (The Off Licence)
	DEFB 8									;Room below (Inside the MegaTrunk)

TreeTopUnused:
    DEFB 0                        ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
TreeTopEnemy1:
    DEFB $80, 0, 8, 76, 200         ; Enemy 1 (Uccello), horizontal, Starts X=8, Y=120, Limit X=200
TreeTopEnemy2:
    DEFB $80, 0, 80, 76, 180         ; Enemy 2 (Uccello), horizontal, Starts X=80, Y=80, Limit X=180
TreeTopEnemy3:
    DEFB $C0, 4, 120, 16, 76         ; Enemy 3 (Ufo), vertical, Starts X=120, Y=40, Limit Y=130
TreeTopEnemy4:
    DEFB 0, 0, 0, 0, 0         ; Empty slot
TreeTopEnemy5:
    DEFB 0, 0, 0, 0, 0
TreeTopEnemy6:
    DEFB 0, 0, 0, 0, 0
TreeTopEnemy7:
    DEFB 0, 0, 0, 0, 0
TreeTopEnemy8:
    DEFB 0, 0, 0, 0, 0

TreeTopPosWilly:
    db 50, 120                 ; Posizione di Willy    
TreeTopEnemyColors5_8:
    DEFB 2, 3, 4, 7               ; Colori per nemici 5-8