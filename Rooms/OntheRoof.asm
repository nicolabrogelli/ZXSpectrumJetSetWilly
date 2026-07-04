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
; OntheRoofPosWilly     Size   2 Byte, Start Byte 280
;
;===========================================================================

; Room layout for Room  (Up On The Battlements)
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
    DEFB 68,0,0,0,0,0,0,0,0

OntheRoofFloor:
    DEFB 7,128,192,224,208,88,156,222,205       ; Floor Solid

OntheRoofWall:
    DEFB 38,17,248,7,8,240,15,208,63   ; Wall Solid

OntheRoofNasty:
    DEFB 70,85,153,221,204,85,153,221,204  ; Nastry

OntheRoofRamp:                          ; Ramp Solid
    DEFB 7,0,0,0,0,0,0,0,0              

OntheRoofConveyor:                      ; Conveyor Solid
    DEFB 10,240,240,240,255,255,0,0,255

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
    DEFB 4, 2, 5, 7               ; Enemy colors: Enemy 1 (GREEN), Enemy 2 (RED), Enemy 3 (CYAN), Enemy 4 (WHITE)

OntheRoofItem:
    DEFB 1,2,5,10,84,40,48,72

OntheRoofDirection:
	DEFB 48						;Room to the left (Nomen Luni)
	DEFB 17						;Room to the right (Up on the Battlements)
	DEFB 18						;Room above (On the Roof)
	DEFB $FF					;Room below (The Off Licence)

OntheRoofUnused:
    DEFB 0                        ; Padding byte to keep Enemy1 offset at 240

OntheRoofEnemy1:
    DEFB $80, 3, 140, 56, 230        ; Enemy 1 (Radar), horizontal, Starts X=40, Y=128, Limit X=180
OntheRoofEnemy2:
    DEFB $C0, 6, 60, 56, 106         ; Enemy 2 (Face), vertical, Starts X=100, Y=80, Limit Y=130
OntheRoofEnemy3:
    DEFB $C0, 9, 80, 16, 106         ; Enemy 3 (Ball), vertical, Starts X=60, Y=40, Limit Y=130
OntheRoofEnemy4:
    DEFB 0, 0, 0, 0, 0               ; Empty slot
OntheRoofEnemy5:
    DEFB 0, 0, 0, 0, 0
OntheRoofEnemy6:
    DEFB 0, 0, 0, 0, 0
OntheRoofEnemy7:
    DEFB 0, 0, 0, 0, 0
OntheRoofEnemy8:
    DEFB 0, 0, 0, 0, 0

OntheRoofPosWilly:
    db 200, 50                   ; Posizione di Willy
OntheRoofEnemyColors5_8:
    DEFB 2, 3, 4, 7               ; Colori per nemici 5-8