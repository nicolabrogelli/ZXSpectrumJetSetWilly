; Room layout for the TEST level with its platforms and floor
Room99Layout:
    DEFB 0,0,0,0,0,0,0,0          ; Row 0
    DEFB 0,0,0,0,0,0,0,0          ; Row 1
    DEFB 0,0,0,0,0,0,0,0          ; Row 2
    DEFB 0,0,0,0,0,0,0,0          ; Row 3
    DEFB 0,0,0,0,0,0,0,0          ; Row 4
    DEFB 0,0,0,0,0,0,0,0          ; Row 5
    DEFB 0,0,0,0,0,0,0,0          ; Row 6
    DEFB 0,0,0,0,0,0,0,0          ; Row 7
    DEFB 0,0,0,0,0,0,0,0          ; Row 8
    DEFB 1,85,85,64,0,85,85,80    ; Row 9 (Platform 3: cols 3..12; Platform 2: cols 20..29)
    DEFB 0,0,0,0,0,0,0,0          ; Row 10
    DEFB 0,0,0,0,0,0,0,0          ; Row 11
    DEFB 0,0,85,85,85,85,0,0      ; Row 12 (Platform 1: cols 8..23)
    DEFB 0,0,0,0,0,0,0,0          ; Row 13
    DEFB 0,0,0,0,0,0,0,0          ; Row 14
    DEFB 85,85,85,85,85,85,85,85  ; Row 15 (Floor: cols 0..31)

Room99Tile:
; 32 bytes for the room name
    DEFM "          TEST LEVEL            "

; Attributes and graphic data for the tiles (1 byte attribute + 8 bytes bitmap)
Room99Background:
    DEFB $07, 0,0,0,0,0,0,0,0

Room99Floor:
    DEFB $02, 255, 136, 255, 34, 255, 136, 255, 36

Room99Wall:
    DEFB $06, 34,119,34,136,34,119,34,136

Room99Nasty:
    DEFB $02, 248,136,158,189,189,158,136,248

Room99Ramp:
    DEFB $07, 3,3,12,13,50,55,194,200

Room99Conveyor:
    DEFB $05, 1,64,4,70,79,121,240,249

; Conveyor specs (direction, location, length)
Room99ConveyorData:
    DEFB 0
    DEFW 0
    DEFB 0

; Ramp specs (direction, location, length)
Room99RampData:
    DEFB 0
    DEFW 0
    DEFB 0

; Border color
Room99BorderColor:
    DEFB 0                        ; Black border

; Reserved bytes
Room99Reserved:
    DEFB 0,0

; Item graphic
Room99Item:
    DEFB 0,0,0,0,0,0,0,0          ; No item defined yet

; Room connections (left, right, above, below)
Room99Direction:
    DEFB 1                        ; Left: The Bridge (Room 1)
    DEFB 2                        ; Right: The Off Licence (Room 2)
    DEFB 0                        ; Above: Self
    DEFB 0                        ; Below: Self

; Unused
Room99Unused:
    DEFB 0,0,0

; Room entities slots (ropes, arrows, guardians)
Room99Enemy1:
    DEFB $80, 24, 128, 231        ; Enemy 1 (Lametta), horizontal, Starts X=24, Y=128, Limit X=231
Room99Enemy2:
    DEFB $81, 160, 80, 224        ; Enemy 2 (Egg), horizontal, Starts X=160, Y=80, Limit X=224
Room99Enemy3:
    DEFB $82, 64, 104, 176        ; Enemy 3 (Robot), horizontal, Starts X=64, Y=104, Limit X=176
Room99Enemy4:
    DEFB 0,0,0,0                  ; Empty slot
