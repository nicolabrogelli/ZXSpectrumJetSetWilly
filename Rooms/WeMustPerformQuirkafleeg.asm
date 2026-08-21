;===========================================================================
; WeMustPerformQuirkafleeg.asm
;
; WeMustPerformQuirkafleegLayout       Size 128 Byte, Start Byte   0
; WeMustPerformQuirkafleegTile         Size  32 Byte, Start Byte 128
; WeMustPerformQuirkafleegBackground   Size   9 Byte, Start Byte 160
; WeMustPerformQuirkafleegFloor        Size   9 Byte, Start Byte 169
; WeMustPerformQuirkafleegWall         Size   9 Byte, Start Byte 178
; WeMustPerformQuirkafleegNasty        Size   9 Byte, Start Byte 187
; WeMustPerformQuirkafleegRamp         Size   9 Byte, Start Byte 196
; WeMustPerformQuirkafleegConveyor     Size   9 Byte, Start Byte 205
; WeMustPerformQuirkafleegConveyorData Size   4 Byte, Start Byte 214
; WeMustPerformQuirkafleegRampData     Size   4 Byte, Start Byte 218
; WeMustPerformQuirkafleegBorderColor  Size   1 Byte, Start Byte 222
; WeMustPerformQuirkafleegReserved     Size   4 Byte, Start Byte 223
; WeMustPerformQuirkafleegItem         Size   8 Byte, Start Byte 227
; WeMustPerformQuirkafleegDirection    Size   4 Byte, Start Byte 235
; WeMustPerformQuirkafleegUnused       Size   1 Byte, Start Byte 239
; WeMustPerformQuirkafleegEnemy1       Size   5 Byte, Start Byte 240
; WeMustPerformQuirkafleegEnemy2       Size   5 Byte, Start Byte 245
; WeMustPerformQuirkafleegEnemy3       Size   5 Byte, Start Byte 250
; WeMustPerformQuirkafleegEnemy4       Size   5 Byte, Start Byte 255
; WeMustPerformQuirkafleegEnemy5       Size   5 Byte, Start Byte 260
; WeMustPerformQuirkafleegEnemy6       Size   5 Byte, Start Byte 265
; WeMustPerformQuirkafleegEnemy7       Size   5 Byte, Start Byte 270
; WeMustPerformQuirkafleegEnemy8       Size   5 Byte, Start Byte 275
; WeMustPerformQuirkafleegPosWilly     Size   2 Byte, Start Byte 280
;
;===========================================================================

; Room layout for Room  (We must perform a Quirkafleeg)
WeMustPerformQuirkafleegLayout:
	DEFB 0,0,0,0,0,0,0,0			;Room layout
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,1,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,1,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,1,0,0,0,0
	DEFB 170,0,170,170,170,170,2 ,170
	DEFB 170,64,0,0,0,0,2,170
	DEFB 170,64,0,0,0,0,2,170
	DEFB 170,64,0,0,0,0,2,170
	DEFB 170,64,0,0,0,0,2,170
	DEFB 170,64,0,0,0,0,2,170
	DEFB 170,127,255,255,255,255,254,170

WeMustPerformQuirkafleegTile:
    DEFM "  We must perform a Quirkafleeg "

WeMustPerformQuirkafleegBackground:                    ; Background
    DEFB 7,0,0,0,0,0,0,0,0

WeMustPerformQuirkafleegFloor:
    DEFB 56,51,187,221,204,85,153,221,238       ; Floor Solid

WeMustPerformQuirkafleegWall:
    DEFB 13,39,246,0,220,209,4,119,128   ; Wall Solid

WeMustPerformQuirkafleegNasty:
    DEFB 69,64,228,78,68,68,68,238,255  ; Nastry

WeMustPerformQuirkafleegRamp:                       ; Ramp Solid
    DEFB 7,128,64,32,48,168,100,34,17              ; Ramp Solid

WeMustPerformQuirkafleegConveyor:                   ; Conveyor Solid
    DEFB 66,40,170,10,0,85,85,85,255                       ; Conveyor Solid

WeMustPerformQuirkafleegConveyorData:
    DEFB 0
    DEFW 24360
    DEFB 0

WeMustPerformQuirkafleegRampData:
    DEFB 0
    DEFW 24356
    DEFB 1

WeMustPerformQuirkafleegBorderColor:
    DEFB 2

WeMustPerformQuirkafleegReserved:
    DEFB 4, 2, 5, 7     ; Enemy colors

WeMustPerformQuirkafleegItem:
    DEFB 24,36,24,44,94,94,231,102

WeMustPerformQuirkafleegDirection:
	ROOM RoomsListTable.UpOnTheBattlementsLayout			;Room to the left (We must perform a Quirkafleeg)
	ROOM RoomsListTable.IAmSureIHaveSeenThiBeforeLayout		;Room to the right (Rescue Esmerelda)
	ROOM RoomsListTable.WatchTowerLayout				    ;Room above (The Off Licence)
	DEFB BLOCK				                                 ;Room below (The Off Licence)

WeMustPerformQuirkafleegUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

WeMustPerformQuirkafleegEnemy1:
    DEFB $80, UCCELLO, 0, 32, 72
WeMustPerformQuirkafleegEnemy2:
    DEFB 0, 0, 0, 0, 0     
WeMustPerformQuirkafleegEnemy3:
    DEFB 0, 0, 0, 0, 0       
WeMustPerformQuirkafleegEnemy4:
    DEFB 0, 0, 0, 0, 0           
WeMustPerformQuirkafleegEnemy5:
    DEFB 0, 0, 0, 0, 0
WeMustPerformQuirkafleegEnemy6:
    DEFB 0, 0, 0, 0, 0
WeMustPerformQuirkafleegEnemy7:
    DEFB 0, 0, 0, 0, 0
WeMustPerformQuirkafleegEnemy8:
    DEFB 0, 0, 0, 0, 0

WeMustPerformQuirkafleegPosWilly:
    db 230, 56                     ; Posizione di Willy
WeMustPerformQuirkafleegEnemyColors5_8:
    DEFB 2, 3, 4, 7     ; Colori per nemici 5-8