;===========================================================================
; TheOffLicence.asm
;
; TheOffLicenceLayout       Size 128 Byte, Start Byte   0
; TheOffLicenceTile         Size  32 Byte, Start Byte 128
; TheOffLicenceBackground   Size   9 Byte, Start Byte 160
; TheOffLicenceFloor        Size   9 Byte, Start Byte 169
; TheOffLicenceWall         Size   9 Byte, Start Byte 178
; TheOffLicenceNasty        Size   9 Byte, Start Byte 187
; TheOffLicenceRamp         Size   9 Byte, Start Byte 196
; TheOffLicenceConveyor     Size   9 Byte, Start Byte 205
; TheOffLicenceConveyorData Size   4 Byte, Start Byte 214
; TheOffLicenceRampData     Size   4 Byte, Start Byte 218
; TheOffLicenceBorderColor  Size   1 Byte, Start Byte 222
; TheOffLicenceReserved     Size   4 Byte, Start Byte 223
; TheOffLicenceItem         Size   8 Byte, Start Byte 227
; TheOffLicenceDirection    Size   4 Byte, Start Byte 235
; TheOffLicenceUnused       Size   1 Byte, Start Byte 239
; TheOffLicenceEnemy1       Size   4 Byte, Start Byte 240
; TheOffLicenceEnemy2       Size   4 Byte, Start Byte 244
; TheOffLicenceEnemy3       Size   4 Byte, Start Byte 248
; TheOffLicenceEnemy4       Size   4 Byte, Start Byte 252
; TheOffLicencePosWilly     Size   2 Byte, Start Byte 256
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
    DEFB 7,3,0,12,0,48,0,192,0              

TheOffLicenceConveyor:                      ; Conveyor Solid
    DEFB 67,51,255,51,0,255,0,170,0

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
    DEFB 4, 2, 5, 7               ; Enemy colors: Enemy 1 (GREEN), Enemy 2 (RED), Enemy 3 (CYAN), Enemy 4 (WHITE)

TheOffLicenceItem:
    DEFB 24,24,60,126,98,98,98,126

TheOffLicenceDirection:
    DEFB 1	;Room to the left (The Bridge)
    DEFB $FF	;Room to the right (None)
    DEFB $FF	;Room above (None)
    DEFB $FF	;Room below (None)

TheOffLicenceUnused:
    DEFB 0                        ; Padding byte to keep Enemy1 offset at 240

TheOffLicenceEnemy1:
    DEFB $80, 140, 56, 230        ; Enemy 1 (Radar), horizontal, Starts X=40, Y=128, Limit X=180
TheOffLicenceEnemy2:
    DEFB $C1, 60, 56, 106         ; Enemy 2 (Face), vertical, Starts X=100, Y=80, Limit Y=130
TheOffLicenceEnemy3:
    DEFB $C2, 80, 16, 106         ; Enemy 3 (Ball), vertical, Starts X=60, Y=40, Limit Y=130
TheOffLicenceEnemy4:
    DEFB 0,0,0,0                  ; Empty slot

TheOffLicencePosWilly:
    db 136, 104                   ; Posizione di Willy