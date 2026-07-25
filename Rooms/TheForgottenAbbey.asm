;===========================================================================
; TheForgottenAbbey.asm
;
; TheForgottenAbbeyLayout       Size 128 Byte, Start Byte   0
; TheForgottenAbbeyTile         Size  32 Byte, Start Byte 128
; TheForgottenAbbeyBackground   Size   9 Byte, Start Byte 160
; TheForgottenAbbeyFloor        Size   9 Byte, Start Byte 169
; TheForgottenAbbeyWall         Size   9 Byte, Start Byte 178
; TheForgottenAbbeyNasty        Size   9 Byte, Start Byte 187
; TheForgottenAbbeyRamp         Size   9 Byte, Start Byte 196
; TheForgottenAbbeyConveyor     Size   9 Byte, Start Byte 205
; TheForgottenAbbeyConveyorData Size   4 Byte, Start Byte 214
; TheForgottenAbbeyRampData     Size   4 Byte, Start Byte 218
; TheForgottenAbbeyBorderColor  Size   1 Byte, Start Byte 222
; TheForgottenAbbeyReserved     Size   4 Byte, Start Byte 223
; TheForgottenAbbeyItem         Size   8 Byte, Start Byte 227
; TheForgottenAbbeyDirection    Size   4 Byte, Start Byte 235
; TheForgottenAbbeyUnused       Size   1 Byte, Start Byte 239
; TheForgottenAbbeyEnemy1       Size   5 Byte, Start Byte 240
; TheForgottenAbbeyEnemy2       Size   5 Byte, Start Byte 245
; TheForgottenAbbeyEnemy3       Size   5 Byte, Start Byte 250
; TheForgottenAbbeyEnemy4       Size   5 Byte, Start Byte 255
; TheForgottenAbbeyEnemy5       Size   5 Byte, Start Byte 260
; TheForgottenAbbeyEnemy6       Size   5 Byte, Start Byte 265
; TheForgottenAbbeyEnemy7       Size   5 Byte, Start Byte 270
; TheForgottenAbbeyEnemy8       Size   5 Byte, Start Byte 275
; TheForgottenAbbeyPosWilly     Size   2 Byte, Start Byte 280
;
;===========================================================================

; Room layout for Room  (The Forgotten Abbey)
TheForgottenAbbeyLayout:
	DEFB 170,170,170,170,170,170,170,170	;Room layout
	DEFB 170,170,170,170,170,170,170,170
	DEFB 160,0,48,0,192,0,192,10
	DEFB 160,0,0,0,0,0,0,10
	DEFB 160,0,0,0,0,0,0,10
	DEFB 168,0,0,0,0,0,0,10
	DEFB 160,0,0,0,0,0,0,10
	DEFB 160,0,0,0,0,0,0,10
	DEFB 160,0,0,0,48,0,0,10
	DEFB 160,0,0,0,0,0,0,26
	DEFB 165,0,0,0,0,0,0,10
	DEFB 80,5,85,85,85,85,85,90
	DEFB 80,0,0,0,0,0,0,10
	DEFB 168,0,0,0,0,0,0,0
	DEFB 170,0,0,0,0,0,0,0
	DEFB 170,170,170,170,170,170,170,170

TheForgottenAbbeyTile:
    DEFM "      The Forgotten Abbey       "

TheForgottenAbbeyBackground:                    ; Background
    DEFB 7,0,0,0,0,0,0,0,0

TheForgottenAbbeyFloor:
    DEFB 4,255,255,242,36,64,2,0,136       ; Floor Solid

TheForgottenAbbeyWall:
    DEFB 29,68,170,17,68,17,170,68,17   ; Wall Solid

TheForgottenAbbeyNasty:
    DEFB 66,24,60,126,153,153,126,66,60  ; Nastry

TheForgottenAbbeyRamp:                          ; Ramp Solid
    DEFB 7,128,64,224,48,168,212,34,137              ; Ramp Solid

TheForgottenAbbeyConveyor:                      ; Conveyor Solid
    DEFB 15,112,85,0,187,170,170,170,170                      ; Conveyor Solid

TheForgottenAbbeyConveyorData:
    DEFB 0
    DEFW 24292
    DEFB 26

TheForgottenAbbeyRampData:
    DEFB 0
    DEFW 24516
    DEFB 2

TheForgottenAbbeyBorderColor:
    DEFB 1

TheForgottenAbbeyReserved:
    DEFB GREEN, YELLOW, RED, WHITE     ; Enemy colors

TheForgottenAbbeyItem:
    DEFB 24,36,219,219,36,24,24,24

TheForgottenAbbeyDirection:
	ROOM RoomsListTable.TheWineCellarLayout     					;Room to the left (The Wine Cellar - non ancora creata)
	ROOM RoomsListTable.TheSecurityGuardLayout						;Room to the right (The Security Guard)
	DEFB BLOCK					                                    ;Room above (None)
	DEFB BLOCK					                                    ;Room below (None)


TheForgottenAbbeyUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

TheForgottenAbbeyEnemy1:
    DEFB $80, 22, 32, 40, 160        ; Enemy 1 (Frate), horizontal, Starts X=40, Y=128, Limit X=180
TheForgottenAbbeyEnemy2:
    DEFB $80, 22, 96, 40, 224         ; Enemy 2 (Face), vertical, Starts X=100, Y=80, Limit Y=130
TheForgottenAbbeyEnemy3:
    DEFB $80, 22, 72, 72, 160         ; Enemy 3 (Ball), vertical, Starts X=60, Y=40, Limit Y=130
TheForgottenAbbeyEnemy4:
    DEFB $80, 22, 154, 72, 189         ; Enemy 3 (Ball), vertical, Starts X=60, Y=40, Limit Y=130
TheForgottenAbbeyEnemy5:
    DEFB $80, 22, 40, 104, 96         ; Enemy 3 (Ball), vertical, Starts X=60, Y=40, Limit Y=130
TheForgottenAbbeyEnemy6:
    DEFB $80, 22, 88, 104, 144         ; Enemy 3 (Ball), vertical, Starts X=60, Y=40, Limit Y=130
TheForgottenAbbeyEnemy7:
    DEFB $80, 22, 128, 104, 184         ; Enemy 3 (Ball), vertical, Starts X=60, Y=40, Limit Y=130
TheForgottenAbbeyEnemy8:
    DEFB $80, 22, 184, 104, 240         ; Enemy 3 (Ball), vertical, Starts X=60, Y=40, Limit Y=130

TheForgottenAbbeyPosWilly:
    db 200, 104                     ; Posizione di Willy
TheForgottenAbbeyEnemyColors5_8:
    DEFB YELLOW, BLUE, GREEN, RED     ; Colori per nemici 5-8