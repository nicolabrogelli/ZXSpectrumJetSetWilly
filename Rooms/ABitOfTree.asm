;===========================================================================
; ABitOfTree.asm  
;
; ABitOfTreeLayout            Size 128 Byte, Start Byte   0
; ABitOfTreeTile              Size  32 Byte, Start Byte 128
; ABitOfTreeBackground        Size   9 Byte, Start Byte 160
; ABitOfTreeFloor             Size   9 Byte, Start Byte 169
; ABitOfTreeWall              Size   9 Byte, Start Byte 178
; ABitOfTreeNasty             Size   9 Byte, Start Byte 187
; ABitOfTreeRamp              Size   9 Byte, Start Byte 196
; ABitOfTreeConveyor          Size   9 Byte, Start Byte 205
; ABitOfTreeConveyorData      Size   4 Byte, Start Byte 214
; ABitOfTreeRampData          Size   4 Byte, Start Byte 218
; ABitOfTreeBorderColor       Size   1 Byte, Start Byte 222
; ABitOfTreeReserved          Size   4 Byte, Start Byte 223
; ABitOfTreeItem		        Size   8 Byte, Start Byte 227
; ABitOfTreeDirection         Size   4 Byte, Start Byte 235
; ABitOfTreeUnused            Size   1 Byte, Start Byte 239
; ABitOfTreeEnemy1		    Size   5 Byte, Start Byte 240
; ABitOfTreeEnemy2		    Size   5 Byte, Start Byte 245
; ABitOfTreeEnemy3		    Size   5 Byte, Start Byte 250
; ABitOfTreeEnemy4		    Size   5 Byte, Start Byte 255
; ABitOfTreeEnemy5		    Size   5 Byte, Start Byte 260
; ABitOfTreeEnemy6		    Size   5 Byte, Start Byte 265
; ABitOfTreeEnemy7		    Size   5 Byte, Start Byte 270
; ABitOfTreeEnemy8		    Size   5 Byte, Start Byte 275
; ABitOfTreePosWilly          Size   2 Byte, Start Byte 280
; ABitOfTreeEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (A Bit Of Tree)
ABitOfTreeLayout:           
	DEFB 0,0,0,160,0,0,0,3	;Room layout
	DEFB 0,0,0,160,0,0,0,3
	DEFB 0,0,0,160,0,0,0,3
	DEFB 0,0,0,160,0,0,0,3
	DEFB 0,0,16,160,0,64,0,3
	DEFB 0,0,0,160,0,0,0,3
	DEFB 0,20,0,160,0,1,64,3
	DEFB 0,0,16,160,0,0,0,3
	DEFB 0,0,0,160,0,0,0,3
	DEFB 0,0,20,160,0,0,64,3
	DEFB 85,80,0,165,64,0,0,3
	DEFB 0,0,0,160,0,0,1,3
	DEFB 0,0,0,160,0,0,64,3
	DEFB 0,0,0,160,5,0,0,3
	DEFB 0,0,0,160,0,0,0,3
	DEFB 0,0,1,164,0,0,0,3
	
ABitOfTreeTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "    A bit of tree               "   ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
ABitOfTreeBackground:                    
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

ABitOfTreeFloor:
    DEFB 4,173,82,41,0,1,2,0,0      ; Floor Solid

ABitOfTreeWall:
    DEFB 30,214,107,102,219,105,107,217,109  ; Wall Solid

ABitOfTreeNasty:
    DEFB 2,21,0,170,85,170,0,21,10  ; Nastry

ABitOfTreeRamp:
    DEFB 68,3,8,36,16,64,32,128,128          ; Ramp Solid

ABitOfTreeConveyor:
    DEFB 255,0,0,0,0,0,0,0,0                     ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
ABitOfTreeConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
ABitOfTreeRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24372                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 2	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
ABitOfTreeBorderColor:
    DEFB 5	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
ABitOfTreeReserved:
    DEFB YELLOW, MAGENTA, NONE, NONE     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
ABitOfTreeItem:
    DEFB 0,0,0,0,0,0,0,0                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
ABitOfTreeDirection:
	ROOM RoomsListTable.OrangeryLayout		;Room to the left (Orangery)
	ROOM RoomsListTable.MastreBedRoomLayout		;Room to the right (Master Bedroom)
	ROOM RoomsListTable.UnderTheRoofLayout		;Room above (Under the Roof)
	ROOM RoomsListTable.TheBanyanTreeLayout		;Room below (The Banyan Tree)

ABitOfTreeUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
ABitOfTreeEnemy1:
    DEFB $80, UCCELLO, 0, 16, 80         
ABitOfTreeEnemy2:
    DEFB $C0, CHIP, 56, 40, 80       
ABitOfTreeEnemy3:
    DEFB 0, 0, 0, 0, 0
ABitOfTreeEnemy4:
    DEFB 0, 0, 0, 0, 0
ABitOfTreeEnemy5:
    DEFB 0, 0, 0, 0, 0
ABitOfTreeEnemy6:
    DEFB 0, 0, 0, 0, 0
ABitOfTreeEnemy7:
    DEFB 0, 0, 0, 0, 0
ABitOfTreeEnemy8:
    DEFB 0, 0, 0, 0, 0

ABitOfTreePosWilly:
    db 25, 65                     ; Posizione di Willy
    
ABitOfTreeEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8