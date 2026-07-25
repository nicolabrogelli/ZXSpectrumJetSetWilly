;===========================================================================
; TheOffLicence.asm
;
; TheOffLicenceLayout           Size 128 Byte, Start Byte   0
; TheOffLicenceTile             Size  32 Byte, Start Byte 128
; TheOffLicenceBackground       Size   9 Byte, Start Byte 160
; TheOffLicenceFloor            Size   9 Byte, Start Byte 169
; TheOffLicenceWall             Size   9 Byte, Start Byte 178
; TheOffLicenceNasty            Size   9 Byte, Start Byte 187
; TheOffLicenceRamp             Size   9 Byte, Start Byte 196
; TheOffLicenceConveyor         Size   9 Byte, Start Byte 205
; TheOffLicenceConveyorData     Size   4 Byte, Start Byte 214
; TheOffLicenceRampData         Size   4 Byte, Start Byte 218
; TheOffLicenceBorderColor      Size   1 Byte, Start Byte 222
; TheOffLicenceReserved         Size   4 Byte, Start Byte 223
; TheOffLicenceItem             Size   8 Byte, Start Byte 227
; TheOffLicenceDirection        Size   4 Byte, Start Byte 235
; TheOffLicenceUnused           Size   1 Byte, Start Byte 239
; TheOffLicenceEnemy1           Size   5 Byte, Start Byte 240
; TheOffLicenceEnemy2           Size   5 Byte, Start Byte 245
; TheOffLicenceEnemy3           Size   5 Byte, Start Byte 250
; TheOffLicenceEnemy4           Size   5 Byte, Start Byte 255
; TheOffLicenceEnemy5           Size   5 Byte, Start Byte 260
; TheOffLicenceEnemy6           Size   5 Byte, Start Byte 265
; TheOffLicenceEnemy7           Size   5 Byte, Start Byte 270
; TheOffLicenceEnemy8           Size   5 Byte, Start Byte 275
; TheOffLicencePosWilly         Size   2 Byte, Start Byte 280
; TheOffLicenceEnemyColors5_8   Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room 2 (The Off Licence)
TheOffLicenceLayout:
    DEFB  0,0,0,0,0,0,0,0	
    DEFB  0,0,0,0,0,0,0,0
    DEFB  0,0,0,0,0,0,0,0
    DEFB  0,0,0,170,170,170,170,170
    DEFB  0,0,0,128,0,0,0,2
    DEFB  0,0,0,128,0,0,0,2
    DEFB  0,0,0,140,0,0,0,2
    DEFB  0,0,0,128,0,0,0,2
    DEFB  0,0,0,128,0,0,0,2
    DEFB  0,0,0,128,0,0,0,2
    DEFB  0,0,0,128,0,0,0,2
    DEFB  0,0,0,170,0,0,2,170
    DEFB  0,0,0,0,0,0,0,2
    DEFB  0,0,0,0,0,0,0,2
    DEFB  0,0,0,0,0,0,0,2
    DEFB  85,85,85,85,85,85,85,85

TheOffLicenceTile:
    DEFM "         The Off Licence        "

TheOffLicenceBackground:                    ; Background
    DEFB $07,0,0,0,0,0,0,0,0

TheOffLicenceFloor:
    DEFB 68,255,222,108,136,18,64,4,0       ; Floor Solid

TheOffLicenceWall:
    DEFB 22,34,255,136,255,34,255,136,255   ; Wall Solid

TheOffLicenceNasty:
    DEFB 5,248,136,158,189,189,158,136,248  ; Nastry

TheOffLicenceRamp:                          ; Ramp Solid
    DEFB 7,3,0,12,0,48,0,192,0              ; Ramp Solid

TheOffLicenceConveyor:                      ; Conveyor Solid
    DEFB 67,51,255,51,0,255,0,170,0                      ; Conveyor Solid

TheOffLicenceConveyorData:
    DEFB 0
    DEFW 24371
    DEFB 12

TheOffLicenceRampData:
    DEFB 1
    DEFW 24535
    DEFB 4

TheOffLicenceBorderColor:
    DEFB 5

TheOffLicenceReserved:
    DEFB GREEN, RED, CYAN, NONE     ; Enemy colors

TheOffLicenceItem:
    DEFB 24,24,60,126,98,98,98,126

TheOffLicenceDirection:
    ROOM RoomsListTable.TheBridgeLayout	    ; Room to the left (The Bridge)
    DEFB BLOCK	                            ; Room to the right (None)
    DEFB BLOCK	                            ; Room above (None)
    DEFB BLOCK	                            ; Room below (None)

TheOffLicenceUnused:
    DEFB 0                          ; Padding byte to keep Enemy1 offset at 240

TheOffLicenceEnemy1:
    DEFB $80, 3, 140, 56, 230       ; [Radar (41056) - horizontal], Guardinan = 12, Starts X=140, Y=56, Limit X=230
TheOffLicenceEnemy2:
    DEFB $C0, 6, 60, 0, 104         ; [Face (41132) - vertical], Guardinan = 44, Starts X=60, Y=0, Limit Y=104
TheOffLicenceEnemy3:
    DEFB $C0, 9, 80, 8, 104         ; [Ball (41040) - vertical], Guardinan = 10, Starts X=80, Y=8, Limit Y=104
TheOffLicenceEnemy4:
    DEFB 0, 0, 0, 0, 0              
TheOffLicenceEnemy5:
    DEFB 0, 0, 0, 0, 0
TheOffLicenceEnemy6:
    DEFB 0, 0, 0, 0, 0
TheOffLicenceEnemy7:
    DEFB 0, 0, 0, 0, 0
TheOffLicenceEnemy8:
    DEFB 0, 0, 0, 0, 0

TheOffLicencePosWilly:
    db 136, 104                     ; Posizione di Willy

TheOffLicenceEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE     ; Colori per nemici 5-8