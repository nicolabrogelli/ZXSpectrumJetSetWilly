;===========================================================================
; UnderTheMegaTree.asm  
;
; UnderTheMegaTreeLayout       Size 128 Byte, Start Byte   0
; UnderTheMegaTreeTile         Size  32 Byte, Start Byte 128
; UnderTheMegaTreeBackground   Size   9 Byte, Start Byte 160
; UnderTheMegaTreeFloor        Size   9 Byte, Start Byte 169
; UnderTheMegaTreeWall         Size   9 Byte, Start Byte 178
; UnderTheMegaTreeNasty        Size   9 Byte, Start Byte 187
; UnderTheMegaTreeRamp         Size   9 Byte, Start Byte 196
; UnderTheMegaTreeConveyor     Size   9 Byte, Start Byte 205
; UnderTheMegaTreeConveyorData Size   4 Byte, Start Byte 214
; UnderTheMegaTreeRampData     Size   4 Byte, Start Byte 218
; UnderTheMegaTreeBorderColor  Size   1 Byte, Start Byte 222
; UnderTheMegaTreeReserved     Size   4 Byte, Start Byte 223
; UnderTheMegaTreeItem		    Size   8 Byte, Start Byte 227
; UnderTheMegaTreeDirection    Size   4 Byte, Start Byte 235
; UnderTheMegaTreeUnused       Size   1 Byte, Start Byte 239
; UnderTheMegaTreeEnemy1		Size   5 Byte, Start Byte 240
; UnderTheMegaTreeEnemy2		Size   5 Byte, Start Byte 245
; UnderTheMegaTreeEnemy3		Size   5 Byte, Start Byte 250
; UnderTheMegaTreeEnemy4		Size   5 Byte, Start Byte 255
; UnderTheMegaTreePosWilly     Size   2 Byte, Start Byte 280
;
;===========================================================================

; Room layout for Room  (Under The MegaTree)
UnderTheMegaTreeLayout:           
    DEFB 0,3,255,207,252,0,0,0	
    DEFB 170,170,175,255,63,0,0,0
    DEFB 0,0,63,208,92,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 170,128,0,0,0,0,0,0
    DEFB 0,1,64,4,0,4,0,0
    DEFB 0,0,1,0,4,0,0,0
    DEFB 170,168,0,0,0,1,0,0
    DEFB 0,0,20,16,16,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 85,85,85,85,85,85,85,85

UnderTheMegaTreeTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "       Under the MegaTree       "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
UnderTheMegaTreeBackground:
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

UnderTheMegaTreeFloor:
    DEFB 68,215,179,117,109,92,24,8,4	    ;Floor Solid

UnderTheMegaTreeWall:
    DEFB 66,189,170,93,162,243,10,6,1	    ;Wall Solid

UnderTheMegaTreeNasty:
    DEFB 70,73,106,59,58,252,30,107,232	    ;Nasty

UnderTheMegaTreeRamp:
    DEFB 255,0,0,0,255,0,0,0,0	            ;Ramp Solid

UnderTheMegaTreeConveyor:
    DEFB 255,0,0,0,0,0,0,0,0	            ;Conveyor

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
UnderTheMegaTreeConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
UnderTheMegaTreeRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (14,7)
    DEFB 0	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
UnderTheMegaTreeBorderColor:
    DEFB 4	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
UnderTheMegaTreeReserved:
    DEFB CYAN, MAGENTA, RED, NONE                         ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
UnderTheMegaTreeItem:
    DEFB 129,66,36,24,60,24,60,195	                ;Item graphic (unused)

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
UnderTheMegaTreeDirection:
    DEFB 3	                                ;Room to the left (Gfx_At the Foot of the MegaTree)
    DEFB 1	                                ;Room to the right (The Bridge)
    DEFB 7                                  ;Room above (CuckoosNest)
    DEFB BLOCK                                ;Room below (None)

UnderTheMegaTreeUnused:
    DEFB 0                        ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
UnderTheMegaTreeEnemy1:
    DEFB $80, 13, 8, 104, 200         ; [Canguro (41216) - horizontal], Guardian = 32, Starts X=8, Y=104, Limit X=200
UnderTheMegaTreeEnemy2:
    DEFB $C0, 6, 112, 48, 87          ; [face (41296) - vertical, Guardian = 42, Starts X=120, Y=16, Limit Y=76
UnderTheMegaTreeEnemy3:
    DEFB $80, 12, 80, 30, 180         ; [Maiale (41168) - horizontal, Guardian = 26, Starts X=80, Y=80, Limit X=180
UnderTheMegaTreeEnemy4:
    DEFB 0, 0, 0, 0, 0        
UnderTheMegaTreeEnemy5:
    DEFB 0, 0, 0, 0, 0
UnderTheMegaTreeEnemy6:
    DEFB 0, 0, 0, 0, 0
UnderTheMegaTreeEnemy7:
    DEFB 0, 0, 0, 0, 0
UnderTheMegaTreeEnemy8:
    DEFB 0, 0, 0, 0, 0

UnderTheMegaTreePosWilly:
    db 200, 101                   ; Posizione di Willy
    
UnderTheMegaTreeEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE               ; Colori per nemici 5-8