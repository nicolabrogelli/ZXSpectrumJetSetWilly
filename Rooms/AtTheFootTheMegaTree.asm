;===========================================================================
; AtTheFootTheMegaTree.asm  
;
; AtTheFootTheMegaTreeLayout            Size 128 Byte, Start Byte   0
; AtTheFootTheMegaTreeTile              Size  32 Byte, Start Byte 128
; AtTheFootTheMegaTreeBackground        Size   9 Byte, Start Byte 160
; AtTheFootTheMegaTreeFloor             Size   9 Byte, Start Byte 169
; AtTheFootTheMegaTreeWall              Size   9 Byte, Start Byte 178
; AtTheFootTheMegaTreeNasty             Size   9 Byte, Start Byte 187
; AtTheFootTheMegaTreeRamp              Size   9 Byte, Start Byte 196
; AtTheFootTheMegaTreeConveyor          Size   9 Byte, Start Byte 205
; AtTheFootTheMegaTreeConveyorData      Size   4 Byte, Start Byte 214
; AtTheFootTheMegaTreeRampData          Size   4 Byte, Start Byte 218
; AtTheFootTheMegaTreeBorderColor       Size   1 Byte, Start Byte 222
; AtTheFootTheMegaTreeReserved          Size   4 Byte, Start Byte 223
; AtTheFootTheMegaTreeItem		        Size   8 Byte, Start Byte 227
; AtTheFootTheMegaTreeDirection         Size   4 Byte, Start Byte 235
; AtTheFootTheMegaTreeUnused            Size   1 Byte, Start Byte 239
; AtTheFootTheMegaTreeEnemy1		    Size   5 Byte, Start Byte 240
; AtTheFootTheMegaTreeEnemy2		    Size   5 Byte, Start Byte 245
; AtTheFootTheMegaTreeEnemy3		    Size   5 Byte, Start Byte 250
; AtTheFootTheMegaTreeEnemy4		    Size   5 Byte, Start Byte 255
; AtTheFootTheMegaTreeEnemy5		    Size   5 Byte, Start Byte 260
; AtTheFootTheMegaTreeEnemy6		    Size   5 Byte, Start Byte 265
; AtTheFootTheMegaTreeEnemy7		    Size   5 Byte, Start Byte 270
; AtTheFootTheMegaTreeEnemy8		    Size   5 Byte, Start Byte 275
; AtTheFootTheMegaTreePosWilly          Size   2 Byte, Start Byte 280
; AtTheFootTheMegaTreeEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (At The Foot The MegaTree)
AtTheFootTheMegaTreeLayout:           
    DEFB 48,195,8,0,8,0,0,0	
    DEFB 48,195,8,0,10,170,170,170
    DEFB 48,195,8,0,8,0,0,0
    DEFB 48,195,8,1,88,0,0,0
    DEFB 48,195,9,0,10,170,170,170
    DEFB 48,195,8,20,0,0,0,0
    DEFB 48,195,8,0,0,0,0,0
    DEFB 48,195,9,0,26,170,170,170
    DEFB 48,195,8,0,8,0,0,0
    DEFB 48,195,8,0,88,0,0,0
    DEFB 48,3,9,64,8,0,0,0
    DEFB 0,0,8,0,8,0,0,0
    DEFB 0,0,8,0,8,0,0,0
    DEFB 0,0,0,0,80,0,0,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 85,85,85,85,85,85,85,85

AtTheFootTheMegaTreeTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "  At the Foot of the MegaTree   "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
AtTheFootTheMegaTreeBackground:                    ; Background
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

AtTheFootTheMegaTreeFloor:
    DEFB 4,240,249,191,31,12,16,40,68       ; Floor Solid

AtTheFootTheMegaTreeWall:
    DEFB 22,171,171,173,170,170,174,85,85   ; Wall Solid

AtTheFootTheMegaTreeNasty:
    DEFB 6,110,116,56,30,110,116,56,30  ; Nastry

AtTheFootTheMegaTreeRamp:
    DEFB 7,192,0,48,0,12,0,3,0              ; Ramp Solid

AtTheFootTheMegaTreeConveyor:
    DEFB 255,0,0,0,0,0,0,0,0                      ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
AtTheFootTheMegaTreeConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
AtTheFootTheMegaTreeRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 24463                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 3	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
AtTheFootTheMegaTreeBorderColor:
    DEFB 4	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
AtTheFootTheMegaTreeReserved:
    DEFB CYAN, CYAN, RED, MAGENTA     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
AtTheFootTheMegaTreeItem:
    DEFB 64,160,92,34,33,34,20,8	                ;Item graphic (unused)

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
AtTheFootTheMegaTreeDirection:
    DEFB 4	                                ;Room to the left (The Drive)
    DEFB 2	                                ;Room to the right (Under the MegaTree)
    DEFB 8	                                ;Room above (Inside the MegaTrunk)
    DEFB BLOCK                                ;Room below (None)

AtTheFootTheMegaTreeUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
AtTheFootTheMegaTreeEnemy1:
    DEFB $C0, 7, 16, 32, 88         ; [Scimmia (41008) - vertical], Guardian = 6, Starts X=16, Y=32, Limit X=88
AtTheFootTheMegaTreeEnemy2:
    DEFB $C0, 7, 40, 16, 80         ; [Scimmia (41016) - vertical], Guardian = 7, Starts X=40, Y=16, Limit X=80
AtTheFootTheMegaTreeEnemy3:
    DEFB $C0, 7, 64, 19, 88         ; [Scimmia (41024) - vertical], Guardian = 8, Starts X=64, Y=19, Limit X=88
AtTheFootTheMegaTreeEnemy4:
    DEFB $80, 1, 32, 104, 112       ; [Sega (41384) - vertical], Guardian = 53, Starts X=32, Y=104, Limit X=112
AtTheFootTheMegaTreeEnemy5:
    DEFB 0, 0, 0, 0, 0
AtTheFootTheMegaTreeEnemy6:
    DEFB 0, 0, 0, 0, 0
AtTheFootTheMegaTreeEnemy7:
    DEFB 0, 0, 0, 0, 0
AtTheFootTheMegaTreeEnemy8:
    DEFB 0, 0, 0, 0, 0

AtTheFootTheMegaTreePosWilly:
    db 200, 104                     ; Posizione di Willy
    
AtTheFootTheMegaTreeEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8