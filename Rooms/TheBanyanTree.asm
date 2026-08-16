;===========================================================================
; TheBanyanTree.asm  
;
; TheBanyanTreeLayout            Size 128 Byte, Start Byte   0
; TheBanyanTreeTile              Size  32 Byte, Start Byte 128
; TheBanyanTreeBackground        Size   9 Byte, Start Byte 160
; TheBanyanTreeFloor             Size   9 Byte, Start Byte 169
; TheBanyanTreeWall              Size   9 Byte, Start Byte 178
; TheBanyanTreeNasty             Size   9 Byte, Start Byte 187
; TheBanyanTreeRamp              Size   9 Byte, Start Byte 196
; TheBanyanTreeConveyor          Size   9 Byte, Start Byte 205
; TheBanyanTreeConveyorData      Size   4 Byte, Start Byte 214
; TheBanyanTreeRampData          Size   4 Byte, Start Byte 218
; TheBanyanTreeBorderColor       Size   1 Byte, Start Byte 222
; TheBanyanTreeReserved          Size   4 Byte, Start Byte 223
; TheBanyanTreeItem		        Size   8 Byte, Start Byte 227
; TheBanyanTreeDirection         Size   4 Byte, Start Byte 235
; TheBanyanTreeUnused            Size   1 Byte, Start Byte 239
; TheBanyanTreeEnemy1		    Size   5 Byte, Start Byte 240
; TheBanyanTreeEnemy2		    Size   5 Byte, Start Byte 245
; TheBanyanTreeEnemy3		    Size   5 Byte, Start Byte 250
; TheBanyanTreeEnemy4		    Size   5 Byte, Start Byte 255
; TheBanyanTreeEnemy5		    Size   5 Byte, Start Byte 260
; TheBanyanTreeEnemy6		    Size   5 Byte, Start Byte 265
; TheBanyanTreeEnemy7		    Size   5 Byte, Start Byte 270
; TheBanyanTreeEnemy8		    Size   5 Byte, Start Byte 275
; TheBanyanTreePosWilly          Size   2 Byte, Start Byte 280
; TheBanyanTreeEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (The Banyan Tree)
TheBanyanTreeLayout:           
	DEFB 0,0,0,160,0,0,0,0	;Room layout
	DEFB 0,0,0,160,0,0,0,0
	DEFB 0,0,0,144,0,0,0,0
	DEFB 0,0,0,148,0,0,0,0
	DEFB 0,0,0,149,80,0,0,0
	DEFB 0,0,0,129,4,0,0,0
	DEFB 0,0,0,1,4,0,0,0
	DEFB 0,0,0,0,4,0,0,0
	DEFB 0,0,0,128,0,0,0,0
	DEFB 0,0,0,130,0,0,0,0
	DEFB 0,8,32,130,8,0,0,0
	DEFB 0,8,32,130,8,0,0,0
	DEFB 170,170,170,170,170,170,90,170
	DEFB 170,170,0,0,0,0,90,170
	DEFB 170,170,0,0,0,0,90,170
	DEFB 170,170,85,85,85,85,90,170
	
TheBanyanTreeTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "       The Banyan Tree          "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
TheBanyanTreeBackground:                    
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

TheBanyanTreeFloor:
    DEFB 72,0,162,0,0,0,70,0,147      ; Floor Solid

TheBanyanTreeWall:
    DEFB 22,74,41,37,73,146,164,37,148  ; Wall Solid

TheBanyanTreeNasty:
    DEFB 14,165,90,165,90,165,90,165,90  ; Nastry

TheBanyanTreeRamp:
    DEFB 7,3,0,12,0,48,0,192,0            ; Ramp Solid

TheBanyanTreeConveyor:
    DEFB 255,0,0,0,0,0,0,0,0                      ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
TheBanyanTreeConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
TheBanyanTreeRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24420                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 8	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
TheBanyanTreeBorderColor:
    DEFB 2	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
TheBanyanTreeReserved:
    DEFB GREEN, MAGENTA, CYAN, YELLOW     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
TheBanyanTreeItem:
    DEFB 5,56,69,130,130,130,68,56	                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
TheBanyanTreeDirection:
	ROOM RoomsListTable.SwimmingPoolLayout				;Room to the left (Swimming Pool)
	ROOM RoomsListTable.TheNightmareRoomLayout				;Room to the right (The Nightmare Room)
	ROOM RoomsListTable.ABitOfTreeLayout				;Room above (A bit of tree)
	ROOM RoomsListTable.WestOfKitchenLayout				;Room below (West of Kitchen)

TheBanyanTreeUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
TheBanyanTreeEnemy1:
    DEFB $C0, IPNOSI, 80, 56, 80         
TheBanyanTreeEnemy2:
    DEFB $D0, DIAVOLETTO, 104, 40, 80   
TheBanyanTreeEnemy3:
    DEFB $F0, CHIP, 128, 40, 80   
TheBanyanTreeEnemy4:
    DEFB $80, SEGA, 152, 80, 235 
TheBanyanTreeEnemy5:
    DEFB 0, 0, 0, 0, 0
TheBanyanTreeEnemy6:
    DEFB 0, 0, 0, 0, 0
TheBanyanTreeEnemy7:
    DEFB 0, 0, 0, 0, 0
TheBanyanTreeEnemy8:
    DEFB 0, 0, 0, 0, 0

TheBanyanTreePosWilly:
    db 220, 78                     ; Posizione di Willy
    
TheBanyanTreeEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8