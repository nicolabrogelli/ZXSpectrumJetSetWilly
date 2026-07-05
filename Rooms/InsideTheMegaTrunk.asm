;===========================================================================
; InsideTheMegaTrunk.asm  
;
; InsideTheMegaTrunkLayout       Size 128 Byte, Start Byte   0
; InsideTheMegaTrunkTile         Size  32 Byte, Start Byte 128
; InsideTheMegaTrunkBackground   Size   9 Byte, Start Byte 160
; InsideTheMegaTrunkFloor        Size   9 Byte, Start Byte 169
; InsideTheMegaTrunkWall         Size   9 Byte, Start Byte 178
; InsideTheMegaTrunkNasty        Size   9 Byte, Start Byte 187
; InsideTheMegaTrunkRamp         Size   9 Byte, Start Byte 196
; InsideTheMegaTrunkConveyor     Size   9 Byte, Start Byte 205
; InsideTheMegaTrunkConveyorData Size   4 Byte, Start Byte 214
; InsideTheMegaTrunkRampData     Size   4 Byte, Start Byte 218
; InsideTheMegaTrunkBorderColor  Size   1 Byte, Start Byte 222
; InsideTheMegaTrunkReserved     Size   4 Byte, Start Byte 223
; InsideTheMegaTrunkItem		 Size   8 Byte, Start Byte 227
; InsideTheMegaTrunkDirection    Size   4 Byte, Start Byte 235
; InsideTheMegaTrunkUnused       Size   1 Byte, Start Byte 239
; InsideTheMegaTrunkEnemy1		 Size   5 Byte, Start Byte 240
; InsideTheMegaTrunkEnemy2		 Size   5 Byte, Start Byte 245
; InsideTheMegaTrunkEnemy3		 Size   5 Byte, Start Byte 250
; InsideTheMegaTrunkEnemy4		 Size   5 Byte, Start Byte 255
; InsideTheMegaTrunkPosWilly     Size   2 Byte, Start Byte 280
;
;===========================================================================

; Room layout for Room  (Inside The MegaTrunk)
InsideTheMegaTrunkLayout:           
	DEFB 0,0,8,0,8,0,0,0	;Room layout
	DEFB 0,0,8,0,8,0,0,0
	DEFB 0,0,8,0,8,0,0,0
	DEFB 0,0,8,1,64,0,0,0
	DEFB 0,0,9,0,0,0,0,0
	DEFB 0,0,0,0,26,170,128,0
	DEFB 0,0,0,5,8,0,0,0
	DEFB 170,170,168,0,8,0,0,0
	DEFB 48,195,9,0,8,0,0,0
	DEFB 48,195,8,0,88,0,0,0
	DEFB 48,195,8,0,8,0,0,0
	DEFB 48,195,8,5,0,0,0,0
	DEFB 48,195,8,0,0,0,0,0
	DEFB 48,195,9,0,10,170,170,170
	DEFB 48,195,8,0,8,0,0,0
	DEFB 48,195,8,0,88,0,0,0

InsideTheMegaTrunkTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "      Inside the MegaTrunk      "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
InsideTheMegaTrunkBackground:
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

InsideTheMegaTrunkFloor:
    DEFB 4,245,250,191,31,38,20,34,16	    ;Floor Solid

InsideTheMegaTrunkWall:
    DEFB 22,171,171,173,170,170,174,85,85	;Wall Solid

InsideTheMegaTrunkNasty:
    DEFB 6,110,116,56,30,110,116,56,30	    ;Nasty

InsideTheMegaTrunkRamp:
    DEFB 7,64,0,16,0,4,0,1,0	            ;Ramp Solid

InsideTheMegaTrunkConveyor:
    DEFB 255,0,0,0,0,0,0,0,0	            ;Conveyor

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
InsideTheMegaTrunkConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
InsideTheMegaTrunkRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 24315	                                ;Location in the attribute buffer at 24064: (14,7)
    DEFB 3	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
InsideTheMegaTrunkBorderColor:
    DEFB 4	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
InsideTheMegaTrunkReserved:
    DEFB MAGENTA, MAGENTA, MAGENTA, RED                         ; Enemy colors: all WHITE (7)

;The next eight bytes are copied to 32993 and define the item graphic.
InsideTheMegaTrunkItem:
    DEFB  0,0,0,0,0,0,0,0	                ;Item graphic (unused)

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
InsideTheMegaTrunkDirection:
	DEFB 9									;Room to the left (On a Branch Over the Drive)
	DEFB 7									;Room to the right (Cuckoo's Nest)
	DEFB 12									;Room above (Tree Top)
	DEFB 3									;Room below (Gfx_At the Foot of the MegaTree)

InsideTheMegaTrunkUnused:
    DEFB 0                                  ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
InsideTheMegaTrunkEnemy1:
    DEFB $C0, 7, 16, 110, 65         ; Enemy 1 (Scimmia), vertical, Starts X=8, Y=120, Limit X=200
InsideTheMegaTrunkEnemy2:
    DEFB $C0, 7, 40, 110, 65         ; Enemy 2 (Scimmia), vertical, Starts X=80, Y=80, Limit X=180
InsideTheMegaTrunkEnemy3:
    DEFB $C0, 7, 64, 110, 65         ; Enemy 3 (Scimmia), vertical, Starts X=120, Y=40, Limit Y=130
InsideTheMegaTrunkEnemy4:
    DEFB $C0, 6, 94, 10, 100         ; Enemy 4 (Faccia)
InsideTheMegaTrunkEnemy5:
    DEFB $80, 2, 1, 40, 100         ; Enemy 5 (Uccello) 
InsideTheMegaTrunkEnemy6:           
    DEFB $80, 2, 230, 87, 150         ; Enemy 6 (Uccello)
InsideTheMegaTrunkEnemy7:
    DEFB 0, 0, 0, 0, 0         ; Enemy 7 (Fiore)
InsideTheMegaTrunkEnemy8:
    DEFB 0, 0, 0, 0, 0

InsideTheMegaTrunkPosWilly:
    db 200, 85                             ; Posizione di Willy

InsideTheMegaTrunkEnemyColors5_8:
    DEFB CYAN, GREEN, 4, 7               ; Colori per nemici 5-8