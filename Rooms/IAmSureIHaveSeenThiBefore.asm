;===========================================================================
; IAmSureIHaveSeenThiBefore.asm
;
; IAmSureIHaveSeenThiBeforeLayout           Size 128 Byte, Start Byte   0
; IAmSureIHaveSeenThiBeforeTile             Size  32 Byte, Start Byte 128
; IAmSureIHaveSeenThiBeforeBackground       Size   9 Byte, Start Byte 160
; IAmSureIHaveSeenThiBeforeFloor            Size   9 Byte, Start Byte 169
; IAmSureIHaveSeenThiBeforeWall             Size   9 Byte, Start Byte 178
; IAmSureIHaveSeenThiBeforeNasty            Size   9 Byte, Start Byte 187
; IAmSureIHaveSeenThiBeforeRamp             Size   9 Byte, Start Byte 196
; IAmSureIHaveSeenThiBeforeConveyor         Size   9 Byte, Start Byte 205
; IAmSureIHaveSeenThiBeforeConveyorData     Size   4 Byte, Start Byte 214
; IAmSureIHaveSeenThiBeforeRampData         Size   4 Byte, Start Byte 218
; IAmSureIHaveSeenThiBeforeBorderColor      Size   1 Byte, Start Byte 222
; IAmSureIHaveSeenThiBeforeReserved         Size   4 Byte, Start Byte 223
; IAmSureIHaveSeenThiBeforeItem             Size   8 Byte, Start Byte 227
; IAmSureIHaveSeenThiBeforeDirection        Size   4 Byte, Start Byte 235
; IAmSureIHaveSeenThiBeforeUnused           Size   1 Byte, Start Byte 239
; IAmSureIHaveSeenThiBeforeEnemy1           Size   5 Byte, Start Byte 240
; IAmSureIHaveSeenThiBeforeEnemy2           Size   5 Byte, Start Byte 245
; IAmSureIHaveSeenThiBeforeEnemy3           Size   5 Byte, Start Byte 250
; IAmSureIHaveSeenThiBeforeEnemy4           Size   5 Byte, Start Byte 255
; IAmSureIHaveSeenThiBeforeEnemy5           Size   5 Byte, Start Byte 260
; IAmSureIHaveSeenThiBeforeEnemy6           Size   5 Byte, Start Byte 265
; IAmSureIHaveSeenThiBeforeEnemy7           Size   5 Byte, Start Byte 270
; IAmSureIHaveSeenThiBeforeEnemy8           Size   5 Byte, Start Byte 275
; IAmSureIHaveSeenThiBeforePosWilly         Size   2 Byte, Start Byte 280
; IAmSureIHaveSeenThiBeforeEnemyColors5_8   Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (I am sure I have seen this before)
IAmSureIHaveSeenThiBeforeLayout:
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

IAmSureIHaveSeenThiBeforeTile:
    DEFM "I'm sure I've seen this before.."

IAmSureIHaveSeenThiBeforeBackground:                    ; Background
    DEFB $0F,0,0,0,0,0,0,0,0

IAmSureIHaveSeenThiBeforeFloor:
    DEFB 12,128,64,32,80,72,84,82,85       ; Floor Solid

IAmSureIHaveSeenThiBeforeWall:
    DEFB 83,102,102,102,0,102,102,102,102   ; Wall Solid

IAmSureIHaveSeenThiBeforeNasty:
    DEFB 76,81,85,84,85,21,85,69,85  ; Nastry

IAmSureIHaveSeenThiBeforeRamp:                          ; Ramp Solid
    DEFB 12,0,0,0,0,0,0,0,0              

IAmSureIHaveSeenThiBeforeConveyor:                      ; Conveyor Solid
    DEFB 255,0,0,0,0,0,0,0,0

IAmSureIHaveSeenThiBeforeConveyorData:
    DEFB 0
    DEFW 0
    DEFB 0

IAmSureIHaveSeenThiBeforeRampData:
    DEFB 0
    DEFW 0
    DEFB 0

IAmSureIHaveSeenThiBeforeBorderColor:
    DEFB 3

IAmSureIHaveSeenThiBeforeReserved:
    DEFB WHITE, MAGENTA, CYAN, CYAN               ; Enemy colors

IAmSureIHaveSeenThiBeforeItem:
    DEFB 24,36,24,44,94,94,231,102

IAmSureIHaveSeenThiBeforeDirection:
	DEFB 16					;Room to the left (We must perform a Quirkafleeg)
	DEFB 14					;Room to the right (Rescue Esmerelda)
	DEFB BLOCK				;Room above (The Off Licence)
	DEFB BLOCK				;Room below (The Off Licence)

IAmSureIHaveSeenThiBeforeUnused:
    DEFB 0                        ; Padding byte to keep Enemy1 offset at 240

IAmSureIHaveSeenThiBeforeEnemy1:
    DEFB $C0, 11, 40, 48, 96          ; [Soldato (40992) - vertical], Guardian = 4, Starts X=40, Y=48, Limit X=96
IAmSureIHaveSeenThiBeforeEnemy2:
    DEFB $D0, 11, 88, 44, 104          ; [Soldato (40984) - vertical], Guardina = 3, Starts X=88, Y=44, Limit X=104
IAmSureIHaveSeenThiBeforeEnemy3:
    DEFB $E0, 11, 152, 32, 96          ; [Soldato (41000) - vertical], Guardina = 5, Starts X=152, Y=32, Limit X=96
IAmSureIHaveSeenThiBeforeEnemy4:
    DEFB $F0, 11, 200, 48, 96          ; [Soldato (40992) - vertical], Guardina = 2, Starts X=200, Y=48, Limit X=96
IAmSureIHaveSeenThiBeforeEnemy5:
    DEFB $80, 2, 0, 32, 72            ; [Uccello (40992) - veritcal], Guardina = 13, Starts X=0, Y=32, Limit X=72
IAmSureIHaveSeenThiBeforeEnemy6:
    DEFB 0, 0, 0, 0, 0
IAmSureIHaveSeenThiBeforeEnemy7:
    DEFB 0, 0, 0, 0, 0
IAmSureIHaveSeenThiBeforeEnemy8:
    DEFB 0, 0, 0, 0, 0

IAmSureIHaveSeenThiBeforePosWilly:
    db 200, 50                   ; Posizione di Willy
IAmSureIHaveSeenThiBeforeEnemyColors5_8:
    DEFB CYAN, NONE, NONE, NONE               ; Colori per nemici 5-8