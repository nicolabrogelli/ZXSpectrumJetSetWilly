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
    DEFB 0,0,0,0,0,0,0,0,0

TheForgottenAbbeyFloor:
    DEFB 4,255,255,242,36,64,2,0,136       ; Floor Solid

TheForgottenAbbeyWall:
    DEFB 29,68,170,17,68,17,170,68,17   ; Wall Solid

TheForgottenAbbeyNasty:
    DEFB 66,24,60,126,153,153,126,66,60  ; Nastry

TheForgottenAbbeyRamp:                          ; Ramp Solid
    DEFB 7,128,64,224,48,168,212,34,137             

TheForgottenAbbeyConveyor:                      ; Conveyor Solid
    DEFB 15,112,85,0,187,170,170,170,170

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
    DEFB 4, 2, 5, 7               ; Enemy colors: Enemy 1 (GREEN), Enemy 2 (RED), Enemy 3 (CYAN), Enemy 4 (WHITE)

TheForgottenAbbeyItem:
    DEFB 24,36,219,219,36,24,24,24

TheForgottenAbbeyDirection:
	DEFB 49						;Room to the left (The Wine Cellar)
	DEFB 5						;Room to the right (The Security Guard)
	DEFB $FF					;Room above (The Off Licence)
	DEFB $FF					;Room below (The Off Licence)


TheForgottenAbbeyUnused:
    DEFB 0                        ; Padding byte to keep Enemy1 offset at 240

TheForgottenAbbeyEnemy1:
    DEFB $80, 3, 140, 56, 230        ; Enemy 1 (Radar), horizontal, Starts X=40, Y=128, Limit X=180
TheForgottenAbbeyEnemy2:
    DEFB $C0, 6, 60, 56, 106         ; Enemy 2 (Face), vertical, Starts X=100, Y=80, Limit Y=130
TheForgottenAbbeyEnemy3:
    DEFB $C0, 9, 80, 16, 106         ; Enemy 3 (Ball), vertical, Starts X=60, Y=40, Limit Y=130
TheForgottenAbbeyEnemy4:
    DEFB 0, 0, 0, 0, 0               ; Empty slot
TheForgottenAbbeyEnemy5:
    DEFB 0, 0, 0, 0, 0
TheForgottenAbbeyEnemy6:
    DEFB 0, 0, 0, 0, 0
TheForgottenAbbeyEnemy7:
    DEFB 0, 0, 0, 0, 0
TheForgottenAbbeyEnemy8:
    DEFB 0, 0, 0, 0, 0

TheForgottenAbbeyPosWilly:
    db 200, 50                   ; Posizione di Willy
TheForgottenAbbeyEnemyColors5_8:
    DEFB 2, 3, 4, 7               ; Colori per nemici 5-8