;===========================================================================
; IAmSureIHaveSeenThiBefore.asm
;
; IAmSureIHaveSeenThiBeforeLayout       Size 128 Byte, Start Byte   0
; IAmSureIHaveSeenThiBeforeTile         Size  32 Byte, Start Byte 128
; IAmSureIHaveSeenThiBeforeBackground   Size   9 Byte, Start Byte 160
; IAmSureIHaveSeenThiBeforeFloor        Size   9 Byte, Start Byte 169
; IAmSureIHaveSeenThiBeforeWall         Size   9 Byte, Start Byte 178
; IAmSureIHaveSeenThiBeforeNasty        Size   9 Byte, Start Byte 187
; IAmSureIHaveSeenThiBeforeRamp         Size   9 Byte, Start Byte 196
; IAmSureIHaveSeenThiBeforeConveyor     Size   9 Byte, Start Byte 205
; IAmSureIHaveSeenThiBeforeConveyorData Size   4 Byte, Start Byte 214
; IAmSureIHaveSeenThiBeforeRampData     Size   4 Byte, Start Byte 218
; IAmSureIHaveSeenThiBeforeBorderColor  Size   1 Byte, Start Byte 222
; IAmSureIHaveSeenThiBeforeReserved     Size   4 Byte, Start Byte 223
; IAmSureIHaveSeenThiBeforeItem         Size   8 Byte, Start Byte 227
; IAmSureIHaveSeenThiBeforeDirection    Size   4 Byte, Start Byte 235
; IAmSureIHaveSeenThiBeforeUnused       Size   1 Byte, Start Byte 239
; IAmSureIHaveSeenThiBeforeEnemy1       Size   5 Byte, Start Byte 240
; IAmSureIHaveSeenThiBeforeEnemy2       Size   5 Byte, Start Byte 245
; IAmSureIHaveSeenThiBeforeEnemy3       Size   5 Byte, Start Byte 250
; IAmSureIHaveSeenThiBeforeEnemy4       Size   5 Byte, Start Byte 255
; IAmSureIHaveSeenThiBeforePosWilly     Size   2 Byte, Start Byte 280
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
    DEFB 8,0,0,0,0,0,0,0,0

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
    DEFB 4, 2, 5, 7               ; Enemy colors: Enemy 1 (GREEN), Enemy 2 (RED), Enemy 3 (CYAN), Enemy 4 (WHITE)

IAmSureIHaveSeenThiBeforeItem:
    DEFB 24,36,24,44,94,94,231,102

IAmSureIHaveSeenThiBeforeDirection:
	DEFB 16					;Room to the left (We must perform a Quirkafleeg)
	DEFB 14					;Room to the right (Rescue Esmerelda)
	DEFB $FF				;Room above (The Off Licence)
	DEFB $FF				;Room below (The Off Licence)

IAmSureIHaveSeenThiBeforeUnused:
    DEFB 0                        ; Padding byte to keep Enemy1 offset at 240

IAmSureIHaveSeenThiBeforeEnemy1:
    DEFB $80, 3, 140, 56, 230        ; Enemy 1 (Radar), horizontal, Starts X=40, Y=128, Limit X=180
IAmSureIHaveSeenThiBeforeEnemy2:
    DEFB $C0, 6, 60, 56, 106         ; Enemy 2 (Face), vertical, Starts X=100, Y=80, Limit Y=130
IAmSureIHaveSeenThiBeforeEnemy3:
    DEFB $C0, 9, 80, 16, 106         ; Enemy 3 (Ball), vertical, Starts X=60, Y=40, Limit Y=130
IAmSureIHaveSeenThiBeforeEnemy4:
    DEFB 0, 0, 0, 0, 0               ; Empty slot
IAmSureIHaveSeenThiBeforeEnemy5:
    DEFB 0, 0, 0, 0, 0
IAmSureIHaveSeenThiBeforeEnemy6:
    DEFB 0, 0, 0, 0, 0
IAmSureIHaveSeenThiBeforeEnemy7:
    DEFB 0, 0, 0, 0, 0
IAmSureIHaveSeenThiBeforeEnemy8:
    DEFB 0, 0, 0, 0, 0

IAmSureIHaveSeenThiBeforePosWilly:
    db 200, 50                   ; Posizione di Willy
IAmSureIHaveSeenThiBeforeEnemyColors5_8:
    DEFB 2, 3, 4, 7               ; Colori per nemici 5-8