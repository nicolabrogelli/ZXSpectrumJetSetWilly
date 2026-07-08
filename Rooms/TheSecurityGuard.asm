;===========================================================================
; TheSecurityGuard.asm  
;
; TheSecurityGuardLayout            Size 128 Byte, Start Byte   0
; TheSecurityGuardTile              Size  32 Byte, Start Byte 128
; TheSecurityGuardBackground        Size   9 Byte, Start Byte 160
; TheSecurityGuardFloor             Size   9 Byte, Start Byte 169
; TheSecurityGuardWall              Size   9 Byte, Start Byte 178
; TheSecurityGuardNasty             Size   9 Byte, Start Byte 187
; TheSecurityGuardRamp              Size   9 Byte, Start Byte 196
; TheSecurityGuardConveyor          Size   9 Byte, Start Byte 205
; TheSecurityGuardConveyorData      Size   4 Byte, Start Byte 214
; TheSecurityGuardRampData          Size   4 Byte, Start Byte 218
; TheSecurityGuardBorderColor       Size   1 Byte, Start Byte 222
; TheSecurityGuardReserved          Size   4 Byte, Start Byte 223
; TheSecurityGuardItem		        Size   8 Byte, Start Byte 227
; TheSecurityGuardDirection         Size   4 Byte, Start Byte 235
; TheSecurityGuardUnused            Size   1 Byte, Start Byte 239
; TheSecurityGuardEnemy1		    Size   5 Byte, Start Byte 240
; TheSecurityGuardEnemy2		    Size   5 Byte, Start Byte 245
; TheSecurityGuardEnemy3		    Size   5 Byte, Start Byte 250
; TheSecurityGuardEnemy4		    Size   5 Byte, Start Byte 255
; TheSecurityGuardEnemy5		    Size   5 Byte, Start Byte 260
; TheSecurityGuardEnemy6		    Size   5 Byte, Start Byte 265
; TheSecurityGuardEnemy7		    Size   5 Byte, Start Byte 270
; TheSecurityGuardEnemy8		    Size   5 Byte, Start Byte 275
; TheSecurityGuardPosWilly          Size   2 Byte, Start Byte 280
; TheSecurityGuardEnemyColors5_8    Size   4 Byte, Start Byte 282
;
;===========================================================================

; Room layout for Room  (The Security Guard)
TheSecurityGuardLayout:           
    DEFB 128,0,0,0,0,0,0,0
    DEFB 160,0,0,0,0,0,0,0
    DEFB 168,0,0,0,0,0,0,0
    DEFB 170,0,0,0,0,0,0,0
    DEFB 170,128,0,0,0,0,0,0
    DEFB 170,160,0,0,0,0,0,0
    DEFB 168,0,0,0,0,0,0,0
    DEFB 168,0,0,0,0,0,0,0
    DEFB 168,21,84,16,65,84,21,85
    DEFB 168,42,168,32,130,168,42,170
    DEFB 0,0,168,32,130,168,42,170
    DEFB 0,0,168,32,130,168,40,0
    DEFB 0,0,168,32,130,168,40,0
    DEFB 0,0,0,0,0,0,0,0
    DEFB 0,0,0,0,0,0,0,42
    DEFB 160,10,170,170,170,170,170,170

TheSecurityGuardTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "       The Security Guard       "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
TheSecurityGuardBackground:
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

TheSecurityGuardFloor:
    DEFB 4,255,255,170,85,170,85,170,85	    ;Floor Solid

TheSecurityGuardWall:
    DEFB 13,14,198,149,176,54,134,192,237	;Wall Solid

TheSecurityGuardNasty:
    DEFB 255,0,0,0,0,0,0,0,0	            ;Nasty

TheSecurityGuardRamp:
    DEFB 7,224,64,32,16,14,4,2,1	        ;Ramp Solid

TheSecurityGuardConveyor:
    DEFB 66,111,0,183,0,170,85,170,85	    ;Conveyor

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
TheSecurityGuardConveyorData:
    DEFB 1	                                ;Direction (right)
    DEFW 24509	                            ;Location in the attribute buffer at 24064: (15,12)
    DEFB 3	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
TheSecurityGuardRampData:
    DEFB 0	                                ;Direction (up to the right)
    DEFW 24296                              ;Location in the attribute buffer at 24064: (14,7)
    DEFB 8	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
TheSecurityGuardBorderColor:
    DEFB 4	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
TheSecurityGuardReserved:
    DEFB RED, GREEN, YELLOW, RED                         ; Enemy colors: all WHITE (7)

;The next eight bytes are copied to 32993 and define the item graphic.
TheSecurityGuardItem:
    DEFB 64,160,92,34,33,34,20,8	                ;Item graphic (unused)

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
TheSecurityGuardDirection:
    DEFB 19	                                ;Room to the left (The Forgotten Abbey)
    DEFB 4	                                ;Room to the right (The Drive)
    DEFB 10	                                ;Room above (The Front Door)
    DEFB 6	                                ;Room below (Entrance to Hades)

TheSecurityGuardUnused:
    DEFB 0                        ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
TheSecurityGuardEnemy1:
    DEFB $C0, 11, 88, 40, 104          ; [Soldato (40976) - horizontal], Guardian = 2, Starts X=88, Y=40, Limit X=104
TheSecurityGuardEnemy2:
    DEFB $D0, 11, 113, 44, 104         ; [Soldato (40984) - horizontal], Guardina = 3, Starts X=113, Y=44, Limit X=104
TheSecurityGuardEnemy3:
    DEFB $E0, 11, 136, 44, 104         ; [Soldato (40984) - horizontal], Guardina = 3, Starts X=136, Y=44, Limit X=104
TheSecurityGuardEnemy4:
    DEFB $F0, 11, 184, 48, 96          ; [Soldato (40992) - horizontal], Guardina = 3, Starts X=184, Y=48, Limit X=96
TheSecurityGuardEnemy5:
    DEFB 0, 0, 0, 0, 0
TheSecurityGuardEnemy6:
    DEFB 0, 0, 0, 0, 0
TheSecurityGuardEnemy7:
    DEFB 0, 0, 0, 0, 0
TheSecurityGuardEnemy8:
    DEFB 0, 0, 0, 0, 0

TheSecurityGuardPosWilly:
    db 200, 101                         ; Posizione di Willy

TheSecurityGuardEnemyColors5_8:
    DEFB NONE, NONE, NONE, NONE               ; Colori per nemici 5-8