;===========================================================================
; UnderTheDrive.asm
;
; UnderTheDriveLayout       Size 128 Byte, Start Byte   0
; UnderTheDriveTile         Size  32 Byte, Start Byte 128
; UnderTheDriveBackground   Size   9 Byte, Start Byte 160
; UnderTheDriveFloor        Size   9 Byte, Start Byte 169
; UnderTheDriveWall         Size   9 Byte, Start Byte 178
; UnderTheDriveNasty        Size   9 Byte, Start Byte 187
; UnderTheDriveRamp         Size   9 Byte, Start Byte 196
; UnderTheDriveConveyor     Size   9 Byte, Start Byte 205
; UnderTheDriveConveyorData Size   4 Byte, Start Byte 214
; UnderTheDriveRampData     Size   4 Byte, Start Byte 218
; UnderTheDriveBorderColor  Size   1 Byte, Start Byte 222
; UnderTheDriveReserved     Size   4 Byte, Start Byte 223
; UnderTheDriveItem         Size   8 Byte, Start Byte 227
; UnderTheDriveDirection    Size   4 Byte, Start Byte 235
; UnderTheDriveUnused       Size   1 Byte, Start Byte 239
; UnderTheDriveEnemy1       Size   5 Byte, Start Byte 240
; UnderTheDriveEnemy2       Size   5 Byte, Start Byte 245
; UnderTheDriveEnemy3       Size   5 Byte, Start Byte 250
; UnderTheDriveEnemy4       Size   5 Byte, Start Byte 255
; UnderTheDrivePosWilly     Size   2 Byte, Start Byte 280
;
;===========================================================================

; Room layout for Room 2 (Under The Drive)
UnderTheDriveLayout:
	DEFB 160,0,0,0,0,0,170,170	;Room layout
	DEFB 160,0,0,0,0,0,170,170
	DEFB 160,0,0,0,0,0,170,170
	DEFB 160,0,0,0,0,5,170,170
	DEFB 168,0,0,0,0,0,170,170
	DEFB 170,0,0,0,16,0,2,170
	DEFB 170,128,0,0,0,80,0,170
	DEFB 170,160,0,0,0,0,0,10
	DEFB 170,168,0,0,80,0,0,0
	DEFB 170,170,0,0,0,192,0,0
	DEFB 170,170,128,0,0,0,0,0
	DEFB 170,170,160,0,0,0,0,0
	DEFB 170,170,168,0,0,0,0,0
	DEFB 170,170,170,0,0,0,0,0
	DEFB 170,170,170,128,48,12,12,0
	DEFB 170,170,170,170,170,170,170,170

UnderTheDriveTile:
	DEFM "          Under the Drive       "

UnderTheDriveBackground:                    ; Background
    DEFB $07,0,0,0,0,0,0,0,0

UnderTheDriveFloor:
    DEFB 6,255,255,165,88,36,66,32,0       ; Floor Solid

UnderTheDriveWall:
    DEFB 12,16,42,85,160,16,32,16,8   ; Wall Solid

UnderTheDriveNasty:
    DEFB 4,24,24,20,34,34,85,17,40  ; Nastry

UnderTheDriveRamp:                          
    DEFB 7,128,64,160,80,168,84,170,85              ; Ramp Solid

UnderTheDriveConveyor:                     
    DEFB 2,224,170,248,0,255,255,102,102                      ; Conveyor Solid

UnderTheDriveConveyorData:
    DEFB 0
    DEFW 24402
    DEFB 14

UnderTheDriveRampData:
    DEFB 0
    DEFW 24525
    DEFB 12

UnderTheDriveBorderColor:
    DEFB 4

UnderTheDriveReserved:
    DEFB YELLOW, CYAN, MAGENTA, NONE     ; Enemy colors

UnderTheDriveItem:
    DEFB 129,100,205,15,97,218,51,26

UnderTheDriveDirection:
	ROOM RoomsListTable.EntranceToHadesLayout			    ;Room to the left (Entrance to Hades)
	ROOM RoomsListTable.TreeRootLayout						;Room to the right (Tree Root)
	ROOM RoomsListTable.TheDriveLayout						;Room above (The Drive)
	DEFB BLOCK                          					;Room below (The Off Licence)

UnderTheDriveUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

UnderTheDriveEnemy1:
    DEFB $80, 2, 96, 88, 232        ; Enemy 1 (Radar), horizontal, Starts X=40, Y=128, Limit X=180
UnderTheDriveEnemy2:
    DEFB $C0, 15, 144, 0, 64         ; Enemy 2 (Face), vertical, Starts X=100, Y=80, Limit Y=130
UnderTheDriveEnemy3:
    DEFB $80, 8, 168, 64, 240         ; Enemy 3 (Ball), vertical, Starts X=60, Y=40, Limit Y=130
UnderTheDriveEnemy4:
    DEFB 0, 0, 0, 0, 0               ; Empty slot
UnderTheDriveEnemy5:
    DEFB 0, 0, 0, 0, 0
UnderTheDriveEnemy6:
    DEFB 0, 0, 0, 0, 0
UnderTheDriveEnemy7:
    DEFB 0, 0, 0, 0, 0
UnderTheDriveEnemy8:
    DEFB 0, 0, 0, 0, 0

UnderTheDrivePosWilly:
    db 200, 96                     ; Posizione sicura di Willy sul pavimento
UnderTheDriveEnemyColors5_8:
    DEFB 2, 3, 4, 7     ; Colori per nemici 5-8