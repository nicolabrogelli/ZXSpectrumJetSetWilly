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
    DEFB 1
    DEFB 0
    DEFB 0
    DEFB 0

TheOffLicenceUnused:
    DEFB 0                        ; Padding byte to keep Enemy1 offset at 240

TheOffLicenceEnemy1:
    DEFB $80, 140, 80, 230        ; Enemy 1 (Radar), horizontal, Starts X=40, Y=128, Limit X=180
TheOffLicenceEnemy2:
    DEFB $C1, 60, 80, 130         ; Enemy 2 (Face), vertical, Starts X=100, Y=80, Limit Y=130
TheOffLicenceEnemy3:
    DEFB $C2, 80, 40, 130         ; Enemy 3 (Ball), vertical, Starts X=60, Y=40, Limit Y=130
TheOffLicenceEnemy4:
    DEFB 0,0,0,0                  ; Empty slot
