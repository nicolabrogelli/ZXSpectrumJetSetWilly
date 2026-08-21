;===========================================================================
; OutALimb.asm
;
; OutALimbLayout            Size 128 Byte, Start Byte   0
; OutALimbTile              Size  32 Byte, Start Byte 128
; OutALimbBackground        Size   9 Byte, Start Byte 160
; OutALimbFloor             Size   9 Byte, Start Byte 169
; OutALimbWall              Size   9 Byte, Start Byte 178
; OutALimbNasty             Size   9 Byte, Start Byte 187
; OutALimbRamp              Size   9 Byte, Start Byte 196
; OutALimbConveyor          Size   9 Byte, Start Byte 205
; OutALimbConveyorData      Size   4 Byte, Start Byte 214
; OutALimbRampData          Size   4 Byte, Start Byte 218
; OutALimbBorderColor       Size   1 Byte, Start Byte 222
; OutALimbReserved          Size   4 Byte, Start Byte 223
; OutALimbItem              Size   8 Byte, Start Byte 227
; OutALimbDirection         Size   4 Byte, Start Byte 235
; OutALimbUnused            Size   1 Byte, Start Byte 239
; OutALimbEnemy1            Size   5 Byte, Start Byte 240
; OutALimbEnemy2            Size   5 Byte, Start Byte 245
; OutALimbEnemy3            Size   5 Byte, Start Byte 250
; OutALimbEnemy4            Size   5 Byte, Start Byte 255
; OutALimbEnemy5            Size   5 Byte, Start Byte 260
; OutALimbEnemy6            Size   5 Byte, Start Byte 265
; OutALimbEnemy7            Size   5 Byte, Start Byte 270
; OutALimbEnemy8            Size   5 Byte, Start Byte 275
; OutALimbPosWilly          Size   2 Byte, Start Byte 280
; OutALimbEnemyColors5_8    Size   4 Byte, Start Byte 282
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
    DEFB 4,0,0,0,0,0,0,0,0              ; Ramp Solid

OutALimbConveyor:                      ; Conveyor Solid
    DEFB 255,0,0,0,0,0,0,0,0                      ; Conveyor Solid

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
    DEFB MAGENTA, CYAN, YELLOW, NONE     ; Enemy colors

OutALimbItem:
    DEFB 96,184,190,93,90,53,42,21

OutALimbDirection:
    ROOM RoomsListTable.TheFrontDoorLayout		;Room to the left (The Bridge)
    ROOM RoomsListTable.TreeTopLayout		;Room to the right (None)
    DEFB BLOCK	;Room above (None)
    ROOM RoomsListTable.OnABranchOverTheDriveLayout		;Room below (None)

OutALimbUnused:
    DEFB $16                          ; Salto = 6 (standard JSW), Gravità = 0.75 (Standard) - Permette di raggiungere la foglia verde a Y=1

OutALimbEnemy1:
    DEFB $80, UCCELLO, 80, 56, 190  
OutALimbEnemy2:
    DEFB $C0, FACCIA, 96, 0, 104   
OutALimbEnemy3:
    DEFB $80, SEGA, 152, 80, 240    
OutALimbEnemy4:
    DEFB 0, 0, 0, 0, 0              
OutALimbEnemy5:
    DEFB 0, 0, 0, 0, 0
OutALimbEnemy6:
    DEFB 0, 0, 0, 0, 0
OutALimbEnemy7:
    DEFB 0, 0, 0, 0, 0
OutALimbEnemy8:
    DEFB 0, 0, 0, 0, 0

OutALimbPosWilly:
    db 200, 48                     ; Posizione di Willy
OutALimbEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8