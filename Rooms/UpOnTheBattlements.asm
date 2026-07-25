;===========================================================================
; UpOnTheBattlements.asm
;
; UpOnTheBattlementsLayout       Size 128 Byte, Start Byte   0
; UpOnTheBattlementsTile         Size  32 Byte, Start Byte 128
; UpOnTheBattlementsBackground   Size   9 Byte, Start Byte 160
; UpOnTheBattlementsFloor        Size   9 Byte, Start Byte 169
; UpOnTheBattlementsWall         Size   9 Byte, Start Byte 178
; UpOnTheBattlementsNasty        Size   9 Byte, Start Byte 187
; UpOnTheBattlementsRamp         Size   9 Byte, Start Byte 196
; UpOnTheBattlementsConveyor     Size   9 Byte, Start Byte 205
; UpOnTheBattlementsConveyorData Size   4 Byte, Start Byte 214
; UpOnTheBattlementsRampData     Size   4 Byte, Start Byte 218
; UpOnTheBattlementsBorderColor  Size   1 Byte, Start Byte 222
; UpOnTheBattlementsReserved     Size   4 Byte, Start Byte 223
; UpOnTheBattlementsItem         Size   8 Byte, Start Byte 227
; UpOnTheBattlementsDirection    Size   4 Byte, Start Byte 235
; UpOnTheBattlementsUnused       Size   1 Byte, Start Byte 239
; UpOnTheBattlementsEnemy1       Size   5 Byte, Start Byte 240
; UpOnTheBattlementsEnemy2       Size   5 Byte, Start Byte 245
; UpOnTheBattlementsEnemy3       Size   5 Byte, Start Byte 250
; UpOnTheBattlementsEnemy4       Size   5 Byte, Start Byte 255
; UpOnTheBattlementsEnemy5       Size   5 Byte, Start Byte 260
; UpOnTheBattlementsEnemy6       Size   5 Byte, Start Byte 275
; UpOnTheBattlementsEnemy7       Size   5 Byte, Start Byte 270
; UpOnTheBattlementsEnemy8       Size   5 Byte, Start Byte 275
; UpOnTheBattlementsPosWilly     Size   2 Byte, Start Byte 280
;
;===========================================================================

; Room layout for Room  (Up On The Battlements)
UpOnTheBattlementsLayout:
	DEFB 0,0,0,0,0,0,0,0	;Room layout
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 170,66,164,42,164,42,66,170
	DEFB 170,194,172,42,172,42,194,170
	DEFB 170,194,172,42,172,42,194,170
	DEFB 170,194,172,42,172,42,194,170
	DEFB 170,194,172,42,172,42,194,170
	DEFB 170,194,172,42,172,42,194,170
	DEFB 170,170,170,170,170,170,170,170

UpOnTheBattlementsTile:
    DEFM "      Up on the Battlements     "

UpOnTheBattlementsBackground:                    ; Background
    DEFB 7,0,0,0,0,0,0,0,0

UpOnTheBattlementsFloor:
    DEFB 4,128,192,224,176,144,148,214,119       ; Floor Solid

UpOnTheBattlementsWall:
    DEFB 14,0,127,127,99,107,99,127,127   ; Wall Solid

UpOnTheBattlementsNasty:
    DEFB 32,74,42,26,72,108,106,41,136  ; Nastry

UpOnTheBattlementsRamp:                          ; Ramp Solid
    DEFB 4,0,0,0,0,0,0,0,0              ; Ramp Solid

UpOnTheBattlementsConveyor:                      ; Conveyor Solid
    DEFB 66,40,170,10,0,85,85,85,255                      ; Conveyor Solid

UpOnTheBattlementsConveyorData:
    DEFB 0
    DEFW 24365
    DEFB 5

UpOnTheBattlementsRampData:
    DEFB 0
    DEFW 0
    DEFB 0

UpOnTheBattlementsBorderColor:
    DEFB 2

UpOnTheBattlementsReserved:
    DEFB 4, 2, 5, 7     ; Enemy colors

UpOnTheBattlementsItem:
    DEFB 24,36,24,44,94,94,231,102

UpOnTheBattlementsDirection:
	ROOM RoomsListTable.OntheRoofLayout		                ;Room to the left (On the Roof)
	ROOM RoomsListTable.WeMustPerformQuirkafleegLayout		;Room to the right (We must perform a Quirkafleeg)
	DEFB BLOCK	                                            ;Room above (The Off Licence)
	DEFB BLOCK	                                            ;Room below (The Off Licence)

UpOnTheBattlementsUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

UpOnTheBattlementsEnemy1:
    DEFB $C0, SOLDATO, 40, 40, 104        
UpOnTheBattlementsEnemy2:
    DEFB $D0, SOLDATO, 88, 44, 104          
UpOnTheBattlementsEnemy3:
    DEFB $E0, SOLDATO, 152, 48, 96       
UpOnTheBattlementsEnemy4:
    DEFB $F0, SOLDATO, 200, 32, 96        
UpOnTheBattlementsEnemy5:
    DEFB 0, 0, 0, 0, 0
UpOnTheBattlementsEnemy6:
    DEFB 0, 0, 0, 0, 0
UpOnTheBattlementsEnemy7:
    DEFB 0, 0, 0, 0, 0
UpOnTheBattlementsEnemy8:
    DEFB 0, 0, 0, 0, 0

UpOnTheBattlementsPosWilly:
    db 230, 56                     ; Posizione di Willy
UpOnTheBattlementsEnemyColors5_8:
    DEFB 2, 3, 4, 7     ; Colori per nemici 5-8