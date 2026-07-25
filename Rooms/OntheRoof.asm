;===========================================================================
; OntheRoof.asm
;
; OntheRoofLayout       Size 128 Byte, Start Byte   0
; OntheRoofTile         Size  32 Byte, Start Byte 128
; OntheRoofBackground   Size   9 Byte, Start Byte 160
; OntheRoofFloor        Size   9 Byte, Start Byte 169
; OntheRoofWall         Size   9 Byte, Start Byte 178
; OntheRoofNasty        Size   9 Byte, Start Byte 187
; OntheRoofRamp         Size   9 Byte, Start Byte 196
; OntheRoofConveyor     Size   9 Byte, Start Byte 205
; OntheRoofConveyorData Size   4 Byte, Start Byte 214
; OntheRoofRampData     Size   4 Byte, Start Byte 218
; OntheRoofBorderColor  Size   1 Byte, Start Byte 222
; OntheRoofReserved     Size   4 Byte, Start Byte 223
; OntheRoofItem         Size   8 Byte, Start Byte 227
; OntheRoofDirection    Size   4 Byte, Start Byte 235
; OntheRoofUnused       Size   1 Byte, Start Byte 239
; OntheRoofEnemy1       Size   5 Byte, Start Byte 240
; OntheRoofEnemy2       Size   5 Byte, Start Byte 245
; OntheRoofEnemy3       Size   5 Byte, Start Byte 250
; OntheRoofEnemy4       Size   5 Byte, Start Byte 255
; OntheRoofEnemy5       Size   5 Byte, Start Byte 260
; OntheRoofEnemy6       Size   5 Byte, Start Byte 265
; OntheRoofEnemy7       Size   5 Byte, Start Byte 270
; OntheRoofEnemy8       Size   5 Byte, Start Byte 275
; OntheRoofPosWilly     Size   2 Byte, Start Byte 280
;
;===========================================================================

; Room layout for Room  (On the Roof )
OntheRoofLayout:
	DEFB 0,0,0,0,0,0,0,0	;Room layout
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,10,64
	DEFB 0,0,0,0,0,0,10,208
	DEFB 170,64,0,0,0,0,10,170
	DEFB 170,192,0,0,0,0,10,170
	DEFB 170,192,0,0,0,0,10,170
	DEFB 170,144,0,0,0,0,10,170
	DEFB 170,176,0,0,0,0,10,170
	DEFB 170,176,10,64,0,0,10,170
	DEFB 170,170,170,170,170,170,170,170

OntheRoofTile:
    DEFM "          On the Roof           "

OntheRoofBackground:                    ; Background
    DEFB 71,0,0,0,0,0,0,0,0

OntheRoofFloor:
    DEFB 7,128,192,224,208,88,156,222,205       ; Floor Solid

OntheRoofWall:
    DEFB 38,17,248,7,8,240,15,208,63   ; Wall Solid

OntheRoofNasty:
    DEFB 70,85,153,221,204,85,153,221,204  ; Nastry

OntheRoofRamp:                          ; Ramp Solid
    DEFB 7,0,0,0,0,0,0,0,0              ; Ramp Solid

OntheRoofConveyor:                      ; Conveyor Solid
    DEFB 10,240,240,240,255,255,0,0,255                      ; Conveyor Solid

OntheRoofConveyorData:
    DEFB 1
    DEFW 24558
    DEFB 8

OntheRoofRampData:
    DEFB 0
    DEFW 0
    DEFB 0

OntheRoofBorderColor:
    DEFB 2

OntheRoofReserved:
    DEFB CYAN, NONE, NONE, NONE     ; Enemy colors

OntheRoofItem:
    DEFB 1,2,5,10,84,40,48,72

OntheRoofDirection:
	ROOM RoomsListTable.NomenLuniLayout						;Room to the left (Nomen Luni)
	ROOM RoomsListTable.UpOnTheBattlementsLayout						;Room to the right (Up on the Battlements)
	ROOM RoomsListTable.OntheRoofLayout						;Room above (On the Roof)
	DEFB $FF					;Room below (The Off Licence)

OntheRoofUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

OntheRoofEnemy1:
    DEFB $80, CANGURO, 112, 104, 192  
OntheRoofEnemy2:
    DEFB 0, 0, 0, 0, 0  
OntheRoofEnemy3:
    DEFB 0, 0, 0, 0, 0  
OntheRoofEnemy4:
    DEFB 0, 0, 0, 0, 0           
OntheRoofEnemy5:
    DEFB 0, 0, 0, 0, 0
OntheRoofEnemy6:
    DEFB 0, 0, 0, 0, 0
OntheRoofEnemy7:
    DEFB 0, 0, 0, 0, 0
OntheRoofEnemy8:
    DEFB 0, 0, 0, 0, 0

OntheRoofPosWilly:
    db 200, 101                     ; Posizione di Willy
OntheRoofEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8