;===========================================================================
; OnTopOfTheHouse.asm  
;
; OnTopOfTheHouseLayout            Size 128 Byte, Start Byte   0
; OnTopOfTheHouseTile              Size  32 Byte, Start Byte 128
; OnTopOfTheHouseBackground        Size   9 Byte, Start Byte 160
; OnTopOfTheHouseFloor             Size   9 Byte, Start Byte 169
; OnTopOfTheHouseWall              Size   9 Byte, Start Byte 178
; OnTopOfTheHouseNasty             Size   9 Byte, Start Byte 187
; OnTopOfTheHouseRamp              Size   9 Byte, Start Byte 196
; OnTopOfTheHouseConveyor          Size   9 Byte, Start Byte 205
; OnTopOfTheHouseConveyorData      Size   4 Byte, Start Byte 214
; OnTopOfTheHouseRampData          Size   4 Byte, Start Byte 218
; OnTopOfTheHouseBorderColor       Size   1 Byte, Start Byte 222
; OnTopOfTheHouseReserved          Size   4 Byte, Start Byte 223
; OnTopOfTheHouseItem		        Size   8 Byte, Start Byte 227
; OnTopOfTheHouseDirection         Size   4 Byte, Start Byte 235
; OnTopOfTheHouseUnused            Size   1 Byte, Start Byte 239
; OnTopOfTheHouseEnemy1		    Size   5 Byte, Start Byte 240
; OnTopOfTheHouseEnemy2		    Size   5 Byte, Start Byte 245
; OnTopOfTheHouseEnemy3		    Size   5 Byte, Start Byte 250
; OnTopOfTheHouseEnemy4		    Size   5 Byte, Start Byte 255
; OnTopOfTheHouseEnemy5		    Size   5 Byte, Start Byte 260
; OnTopOfTheHouseEnemy6		    Size   5 Byte, Start Byte 265
; OnTopOfTheHouseEnemy7		    Size   5 Byte, Start Byte 270
; OnTopOfTheHouseEnemy8		    Size   5 Byte, Start Byte 275
; OnTopOfTheHousePosWilly          Size   2 Byte, Start Byte 280
; OnTopOfTheHouseEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (OnTopOfTheHouse)
OnTopOfTheHouseLayout:           
	DEFB 0,0,0,0,0,0,0,0	;Room layout
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 146,0,0,0,4,0,0,0
	DEFB 144,0,0,0,16,0,0,0
	DEFB 144,0,0,0,64,0,0,0
	DEFB 146,0,0,1,0,0,0,0
	DEFB 146,128,0,4,0,0,0,0
	DEFB 146,160,130,16,0,0,0,0
	DEFB 146,170,170,64,0,0,0,0
	DEFB 146,170,170,0,0,0,0,0
	DEFB 16,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 170,170,170,0,0,0,0,0
	
OnTopOfTheHouseTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "         On top of the house    "   ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
OnTopOfTheHouseBackground:                    
    DEFB $0F,0,0,0,0,0,0,0,0	            ;Background

OnTopOfTheHouseFloor:
    DEFB 14,160,64,128,0,0,0,0,0     ; Floor Solid

OnTopOfTheHouseWall:
    DEFB 75,81,170,0,170,21,170,0,170  ; Wall Solid

OnTopOfTheHouseNasty:
    DEFB 255,0,0,0,0,0,0,0,0  ; Nastry

OnTopOfTheHouseRamp:
    DEFB 15,1,3,6,13,26,52,104,208         ; Ramp Solid

OnTopOfTheHouseConveyor:
    DEFB 255,0,0,0,0,0,0,0,0                   ; Conveyor Solid

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
OnTopOfTheHouseConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
OnTopOfTheHouseRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24396                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 6	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
OnTopOfTheHouseBorderColor:
    DEFB 3	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
OnTopOfTheHouseReserved:
    DEFB CYAN, CYAN, RED, MAGENTA     ; Enemy colors

;The next eight bytes are copied to 32993 and define the item graphic.
OnTopOfTheHouseItem:
    DEFB 0,0,24,20,26,53,107,208                ;Item graphic 

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
OnTopOfTheHouseDirection:
	ROOM RoomsListTable.RescueEsmereldaLayout		;Room to the left (Rescue Esmerelda)
	DEFB BLOCK	;Room to the right (The Off Licence)
	DEFB BLOCK	;Room above (The Off Licence)
	ROOM RoomsListTable.PriestsHoleLayout		;Room below (Priests' Hole)

OnTopOfTheHouseUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
OnTopOfTheHouseEnemy1:
    DEFB $C0, ONDA, 160, 0, 64   
OnTopOfTheHouseEnemy2:
    DEFB 0, 0, 0, 0, 0
OnTopOfTheHouseEnemy3:
    DEFB 0, 0, 0, 0, 0
OnTopOfTheHouseEnemy4:
    DEFB 0, 0, 0, 0, 0
OnTopOfTheHouseEnemy5:
    DEFB 0, 0, 0, 0, 0
OnTopOfTheHouseEnemy6:
    DEFB 0, 0, 0, 0, 0
OnTopOfTheHouseEnemy7:
    DEFB 0, 0, 0, 0, 0
OnTopOfTheHouseEnemy8:
    DEFB 0, 0, 0, 0, 0

OnTopOfTheHousePosWilly:
    db 10, 104                     ; Posizione di Willy
    
OnTopOfTheHouseEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8