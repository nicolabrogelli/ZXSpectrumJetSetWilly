; Room layout for Room 2 (The Off Licence)
Room2Layout:
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

Room2Tile:
    DEFM "         The Off Licence        "

Room2Background:
    DEFB 0,0,0,0,0,0,0,0,0

Room2Floor:
    DEFB 68,255,222,108,136,18,64,4,0

Room2Wall:
    DEFB 22,34,255,136,255,34,255,136,255

Room2Nasty:
    DEFB 5,248,136,158,189,189,158,136,248

Room2Ramp:
    DEFB 7,3,0,12,0,48,0,192,0

Room2Conveyor:
    DEFB 67,51,255,51,0,255,0,170,0

Room2ConveyorData:
    DEFB 0
    DEFW 24371
    DEFB 12

Room2RampData:
    DEFB 1
    DEFW 24535
    DEFB 4

Room2BorderColor:
    DEFB 5

Room2Reserved:
    DEFB 0,160

Room2Item:
    DEFB 24,24,60,126,98,98,98,126

Room2Direction:
    DEFB 1
    DEFB 0
    DEFB 0
    DEFB 0

Room2Unused:
    DEFB 0,0,0

Room2Enemy1:
    DEFB $82, 40, 128, 180        ; Enemy 1 (Robot), horizontal, Starts X=40, Y=128, Limit X=180
Room2Enemy2:
    DEFB $80, 100, 80, 200        ; Enemy 2 (Lametta), horizontal, Starts X=100, Y=80, Limit X=200
Room2Enemy3:
    DEFB $81, 60, 104, 160        ; Enemy 3 (Egg), horizontal, Starts X=60, Y=104, Limit X=160
Room2Enemy4:
    DEFB 0,0,0,0                  ; Empty slot
