; Room layout for Room 2 (The Off Licence)
Room0Layout:
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

Room0Tile:
    DEFM "         The Off Licence        "

Room0Background:
    DEFB 0,0,0,0,0,0,0,0,0

Room0Floor:
    DEFB 68,255,222,108,136,18,64,4,0

Room0Wall:
    DEFB 22,34,255,136,255,34,255,136,255

Room0Nasty:
    DEFB 5,248,136,158,189,189,158,136,248

Room0Ramp:
    DEFB 7,3,0,12,0,48,0,192,0

Room0Conveyor:
    DEFB 67,51,255,51,0,255,0,170,0

Room0ConveyorData:
    DEFB 0
    DEFW 24371
    DEFB 12

Room0RampData:
    DEFB 1
    DEFW 24535
    DEFB 4

Room0BorderColor:
    DEFB 5

Room0Reserved:
    DEFB 0,160

Room0Item:
    DEFB 24,24,60,126,98,98,98,126

Room0Direction:
    DEFB 1
    DEFB 0
    DEFB 0
    DEFB 0

Room0Unused:
    DEFB 0,0,0

Room0Enemy1:
    DEFB $82, 40, 128, 180        ; Enemy 1 (Robot), horizontal, Starts X=40, Y=128, Limit X=180
Room0Enemy2:
    DEFB $80, 100, 80, 200        ; Enemy 2 (Lametta), horizontal, Starts X=100, Y=80, Limit X=200
Room0Enemy3:
    DEFB $81, 60, 104, 160        ; Enemy 3 (Egg), horizontal, Starts X=60, Y=104, Limit X=160
Room0Enemy4:
    DEFB 0,0,0,0                  ; Empty slot
