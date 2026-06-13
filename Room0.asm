; Room layout for the TEST level with its platforms and floor
Room0Layout:
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

Room0Tile:
; 32 bytes for the room name
    DEFM "          TEST LEVEL            "

; Attributes and graphic data for the tiles (1 byte attribute + 8 bytes bitmap)
Room0Background:
    DEFB $07, 0,0,0,0,0,0,0,0

Room0Floor:
    DEFB $02, 255, 136, 255, 34, 255, 136, 255, 36

Room0Wall:
    DEFB $06, 70,34,119,34,136,34,119,34,136

Room0Nasty:
    DEFB $02, 5,248,136,158,189,189,158,136,248

Room0Ramp:
    DEFB $07, 7,3,3,12,13,50,55,194,200

Room0Conveyor:
    DEFB $05, 44,1,64,4,70,79,121,240,249

; Conveyor specs (direction, location, length)
Room0ConveyorData:
    DEFB 0
    DEFW 0
    DEFB 0

; Ramp specs (direction, location, length)
Room0RampData:
    DEFB 0
    DEFW 0
    DEFB 0

; Border color
Room0BorderColor:
    DEFB 0                        ; Black border

; Reserved bytes
Room0Reserved:
    DEFB 0,0

; Item graphic
Room0Item:
    DEFB 0,0,0,0,0,0,0,0          ; No item defined yet

; Room connections (left, right, above, below)
Room0Direction:
    DEFB 1                        ; Left: The Bridge (Room 1)
    DEFB 2                        ; Right: The Off Licence (Room 2)
    DEFB 0                        ; Above: Self
    DEFB 0                        ; Below: Self

; Unused
Room0Unused:
    DEFB 0,0,0

; Room entities slots (ropes, arrows, guardians)
Room0Enemy1:
    DEFB 255,0                    ; Terminator (end of active list)

Room0Enemy2:
    DEFB 0,0

Room0Enemy3:
    DEFB 0,0

Room0Enemy4:
    DEFB 0,0

Room0Enemy5:
    DEFB 0,0

Room0Enemy6:
    DEFB 0,0

Room0Enemy7:
    DEFB 0,0

Room0Enemy8:
    DEFB 0,0
