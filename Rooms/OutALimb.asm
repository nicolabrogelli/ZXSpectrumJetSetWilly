;===========================================================================
; OutALimb.asm
;
; OutALimbLayout       Size 128 Byte, Start Byte   0
; OutALimbTile         Size  32 Byte, Start Byte 128
; OutALimbBackground   Size   9 Byte, Start Byte 160
; OutALimbFloor        Size   9 Byte, Start Byte 169
; OutALimbWall         Size   9 Byte, Start Byte 178
; OutALimbNasty        Size   9 Byte, Start Byte 187
; OutALimbRamp         Size   9 Byte, Start Byte 196
; OutALimbConveyor     Size   9 Byte, Start Byte 205
; OutALimbConveyorData Size   4 Byte, Start Byte 214
; OutALimbRampData     Size   4 Byte, Start Byte 218
; OutALimbBorderColor  Size   1 Byte, Start Byte 222
; OutALimbReserved     Size   4 Byte, Start Byte 223
; OutALimbItem         Size   8 Byte, Start Byte 227
; OutALimbDirection    Size   4 Byte, Start Byte 235
; OutALimbUnused       Size   1 Byte, Start Byte 239
; OutALimbEnemy1       Size   5 Byte, Start Byte 240
; OutALimbEnemy2       Size   5 Byte, Start Byte 245
; OutALimbEnemy3       Size   5 Byte, Start Byte 250
; OutALimbEnemy4       Size   5 Byte, Start Byte 255
; OutALimbEnemy5       Size   5 Byte, Start Byte 260
; OutALimbEnemy6       Size   5 Byte, Start Byte 265
; OutALimbEnemy7       Size   5 Byte, Start Byte 270
; OutALimbEnemy8       Size   5 Byte, Start Byte 275
; OutALimbPosWilly     Size   2 Byte, Start Byte 280
;
;===========================================================================

; Room layout for Room 2 (Out A Limb)
OutALimbLayout:
	DEFB 0,0,0,0,0,0,0,0	;Room layout
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,4,0,0,0,0
	DEFB 0,16,0,0,4,1,0,0
	DEFB 0,0,4,0,0,0,0,0
	DEFB 0,0,0,0,0,0,16,0
	DEFB 0,0,0,1,0,64,0,0
	DEFB 4,0,0,4,64,0,0,0
	DEFB 0,4,0,1,16,0,0,0
	DEFB 0,0,1,0,74,170,170,170
	DEFB 1,0,0,0,0,127,255,0
	DEFB 0,0,64,0,64,31,252,0
	DEFB 0,0,0,64,0,1,80,0

OutALimbTile:
    DEFM "        Out on a limb           "

OutALimbBackground:                    ; Background
    DEFB $07,0,0,0,0,0,0,0,0

OutALimbFloor:
    DEFB 4,1,30,6,122,26,232,104,160       ; Floor Solid

OutALimbWall:
    DEFB 66,7,255,252,56,24,16,32,0   ; Wall Solid

OutALimbNasty:
    DEFB 2,1,129,6,88,32,64,136,130  ; Nastry

OutALimbRamp:                          ; Ramp Solid
    DEFB 4,0,0,0,0,0,0,0,0              

OutALimbConveyor:                      ; Conveyor Solid
    DEFB 255,0,0,0,0,0,0,0,0

OutALimbConveyorData:
    DEFB 0
    DEFW 0
    DEFB 0

OutALimbRampData:
    DEFB 1
    DEFW 0
    DEFB 0

OutALimbBorderColor:
    DEFB 5

OutALimbReserved:
    DEFB MAGENTA, CYAN, YELLOW, NONE               ; Enemy colors: Enemy 1 (GREEN), Enemy 2 (RED), Enemy 3 (CYAN), Enemy 4 (WHITE)

OutALimbItem:
    DEFB 24,24,60,126,98,98,98,126

OutALimbDirection:
    DEFB 10		;Room to the left (The Bridge)
    DEFB 12		;Room to the right (None)
    DEFB BLOCK	;Room above (None)
    DEFB 9		;Room below (None)

OutALimbUnused:
    DEFB 0                        ; Padding byte to keep Enemy1 offset at 240

OutALimbEnemy1:
    DEFB $80, 2, 112, 56, 184        ; [Uccello (41160) - Horizzontal], Guardian = 45, Starts X=16, Y=32, Limit X=88
OutALimbEnemy2:
    DEFB $C0, 6, 96, 0, 104          ; [Faccia (41320) - vertical], Guardian = 25, Starts X=16, Y=32, Limit X=88
OutALimbEnemy3:
    DEFB $80, 1, 152, 80, 240         ; [Sega (41664) - vertical], Guardian = 88, Starts X=16, Y=32, Limit X=88
OutALimbEnemy4:
    DEFB 0, 0, 0, 0, 0               ; Empty slot
OutALimbEnemy5:
    DEFB 0, 0, 0, 0, 0
OutALimbEnemy6:
    DEFB 0, 0, 0, 0, 0
OutALimbEnemy7:
    DEFB 0, 0, 0, 0, 0
OutALimbEnemy8:
    DEFB 0, 0, 0, 0, 0

OutALimbPosWilly:
    db 200, 50                   ; Posizione di Willy
OutALimbEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE               ; Colori per nemici 5-8