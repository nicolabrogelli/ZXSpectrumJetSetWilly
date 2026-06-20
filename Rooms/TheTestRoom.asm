;===========================================================================
; TheTestRoom.asm
;
; TheTestRoomLayout       Size 128 Byte, Start Byte   0
; TheTestRoomTile         Size  32 Byte, Start Byte 128
; TheTestRoomBackground   Size   9 Byte, Start Byte 160
; TheTestRoomFloor        Size   9 Byte, Start Byte 169
; TheTestRoomWall         Size   9 Byte, Start Byte 178
; TheTestRoomNasty        Size   9 Byte, Start Byte 187
; TheTestRoomRamp         Size   9 Byte, Start Byte 196
; TheTestRoomConveyor     Size   9 Byte, Start Byte 205
; TheTestRoomConveyorData Size   4 Byte, Start Byte 214
; TheTestRoomRampData     Size   4 Byte, Start Byte 218
; TheTestRoomBorderColor  Size   1 Byte, Start Byte 222
; TheTestRoomReserved     Size   4 Byte, Start Byte 223
; TheTestRoomItem         Size   8 Byte, Start Byte 227
; TheTestRoomDirection    Size   4 Byte, Start Byte 235
; TheTestRoomUnused       Size   1 Byte, Start Byte 239
; TheTestRoomEnemy1       Size   4 Byte, Start Byte 240
; TheTestRoomEnemy2       Size   4 Byte, Start Byte 244
; TheTestRoomEnemy3       Size   4 Byte, Start Byte 248
; TheTestRoomEnemy4       Size   4 Byte, Start Byte 252
; TheTestRoomPosWilly     Size   2 Byte, Start Byte 256
;
;===========================================================================

; Room layout for the TEST level with its platforms and floor
TheTestRoomLayout:
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

TheTestRoomTile:
; 32 bytes for the room name
    DEFM "          TEST LEVEL            "

; Attributes and graphic data for the tiles (1 byte attribute + 8 bytes bitmap)
TheTestRoomBackground:
    DEFB $07, 0,0,0,0,0,0,0,0

TheTestRoomFloor:
    DEFB $02, 255, 136, 255, 34, 255, 136, 255, 36

TheTestRoomWall:
    DEFB $06, 34,119,34,136,34,119,34,136

TheTestRoomNasty:
    DEFB $02, 248,136,158,189,189,158,136,248

TheTestRoomRamp:
    DEFB $07, 3,3,12,13,50,55,194,200

TheTestRoomConveyor:
    DEFB $05, 1,64,4,70,79,121,240,249

; Conveyor specs (direction, location, length)
TheTestRoomConveyorData:
    DEFB 0
    DEFW 0
    DEFB 0

; Ramp specs (direction, location, length)
TheTestRoomRampData:
    DEFB 0
    DEFW 0
    DEFB 0

; Border color
TheTestRoomBorderColor:
    DEFB 5                        ; Black border

; Reserved bytes
TheTestRoomReserved:
    DEFB 7, 7, 7, 7               ; Enemy colors: all WHITE (7)

TheTestRoomItem:
    DEFB 24,60,126,255,255,126,60,24          ; Diamond graphic for the item

; Room connections (left, right, above, below)
TheTestRoomDirection:
    DEFB 1                        ; Left: The Bridge (Room 1)
    DEFB 2                        ; Right: The Off Licence (Room 2)
    DEFB 0                        ; Above: Self
    DEFB 0                        ; Below: Self

TheTestRoomUnused:
    DEFB 0                        ; Padding byte to keep Enemy1 offset at 240

; Room entities slots (ropes, arrows, guardians)
TheTestRoomEnemy1:
    DEFB $80, 24, 104, 231        ; Enemy 1 (Lametta), horizontal, Starts X=24, Y=104, Limit X=231
TheTestRoomEnemy2:
    DEFB $81, 160, 56, 224        ; Enemy 2 (Egg), horizontal, Starts X=160, Y=56, Limit X=224
TheTestRoomEnemy3:
    DEFB $82, 64, 80, 176        ; Enemy 3 (Robot), horizontal, Starts X=64, Y=80, Limit X=176
TheTestRoomEnemy4:
    DEFB 0,0,0,0                  ; Empty slot

TheTestRoomPosWilly:
    db 136, 104                   ; Posizione di Willy