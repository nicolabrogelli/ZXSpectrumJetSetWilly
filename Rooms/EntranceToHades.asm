;===========================================================================
; EntranceToHades.asm
;
; EntranceToHadesLayout       Size 128 Byte, Start Byte   0
; EntranceToHadesTile         Size  32 Byte, Start Byte 128
; EntranceToHadesBackground   Size   9 Byte, Start Byte 160
; EntranceToHadesFloor        Size   9 Byte, Start Byte 169
; EntranceToHadesWall         Size   9 Byte, Start Byte 178
; EntranceToHadesNasty        Size   9 Byte, Start Byte 187
; EntranceToHadesRamp         Size   9 Byte, Start Byte 196
; EntranceToHadesConveyor     Size   9 Byte, Start Byte 205
; EntranceToHadesConveyorData Size   4 Byte, Start Byte 214
; EntranceToHadesRampData     Size   4 Byte, Start Byte 218
; EntranceToHadesBorderColor  Size   1 Byte, Start Byte 222
; EntranceToHadesReserved     Size   4 Byte, Start Byte 223
; EntranceToHadesItem         Size   8 Byte, Start Byte 227
; EntranceToHadesDirection    Size   4 Byte, Start Byte 235
; EntranceToHadesUnused       Size   1 Byte, Start Byte 239
; EntranceToHadesEnemy1       Size   4 Byte, Start Byte 240
; EntranceToHadesEnemy2       Size   4 Byte, Start Byte 244
; EntranceToHadesEnemy3       Size   4 Byte, Start Byte 248
; EntranceToHadesEnemy4       Size   4 Byte, Start Byte 252
; EntranceToHadesPosWilly     Size   2 Byte, Start Byte 256
;
;===========================================================================

EntranceToHadesLayout:
    DEFB 160,0,0,0,0,0,0,0	;Room layout
    DEFB 160,0,0,0,0,0,0,0
    DEFB 160,0,0,21,4,85,0,0
    DEFB 160,0,0,16,68,67,0,0
    DEFB 160,0,0,16,68,84,0,0
    DEFB 160,0,0,16,68,64,0,0
    DEFB 160,0,0,21,4,85,0,0
    DEFB 160,0,0,12,12,48,0,0
    DEFB 160,0,0,0,0,0,0,0
    DEFB 160,1,1,4,20,21,4,16
    DEFB 160,1,69,17,17,4,17,16
    DEFB 160,1,17,17,20,4,17,16
    DEFB 160,1,49,17,17,4,21,16
    DEFB 160,1,1,4,17,4,17,21
    DEFB 160,3,3,12,51,12,51,12
    DEFB 160,0,0,0,0,0,0,0

EntranceToHadesTile:
    DEFM "       Entrance to Hades        "

EntranceToHadesBackground:                    ; Background
    DEFB 52,0,0,0,0,0,0,0,0

EntranceToHadesFloor:
    DEFB 163,160,20,130,80,10,65,40,5      ; Floor Solid

EntranceToHadesWall:
    DEFB 99,187,187,56,187,187,187,131,187   ; Wall Solid

EntranceToHadesNasty:
    DEFB 50,191,92,88,48,40,88,72,232  ; Nastry

EntranceToHadesRamp:                          ; Ramp Solid
    DEFB 7,64,64,16,16,4,4,1,1            

EntranceToHadesConveyor:                      ; Conveyor Solid
    DEFB 255,0,0,0,0,0,0,0,0

EntranceToHadesConveyorData:
    DEFB 0
    DEFW 0
    DEFB 0

EntranceToHadesRampData:
    DEFB 0
    DEFW 0
    DEFB 0

EntranceToHadesBorderColor:
    DEFB 2                        ; Red border

EntranceToHadesReserved:
    DEFB 4, 2, 5, 7               ; Enemy colors

EntranceToHadesItem:
    DEFB 0,0,0,0,0,0,0,0

EntranceToHadesDirection:
    DEFB 14                        ;Room to the left (Rescue Esmerelda)
    DEFB 5	                       ;Room to the right (The Security Guard)
    DEFB 0	                       ;Room above (The Off Licence)
    DEFB 0	                       ;Room below (The Off Licence)

EntranceToHadesUnused:
    DEFB 0                        ; Padding byte to keep Enemy1 offset at 240

EntranceToHadesEnemy1:
    DEFB 0,0,0,0                  ; Empty slot
EntranceToHadesEnemy2:
    DEFB 0,0,0,0                  ; Empty slot
EntranceToHadesEnemy3:
    DEFB 0,0,0,0                  ; Empty slot
EntranceToHadesEnemy4:
    DEFB 0,0,0,0                  ; Empty slot
EntranceToHadesEnemy5:
    DEFB 0,0,0,0
EntranceToHadesEnemy6:
    DEFB 0,0,0,0
EntranceToHadesEnemy7:
    DEFB 0,0,0,0
EntranceToHadesEnemy8:
    DEFB 0,0,0,0

EntranceToHadesPosWilly:
    db 136, 30                   ; Willy starting position