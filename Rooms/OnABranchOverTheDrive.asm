;===========================================================================
; OnABranchOverTheDrive.asm  
;
; OnABranchOverTheDriveLayout       Size 128 Byte, Start Byte   0
; OnABranchOverTheDriveTile         Size  32 Byte, Start Byte 128
; OnABranchOverTheDriveBackground   Size   9 Byte, Start Byte 160
; OnABranchOverTheDriveFloor        Size   9 Byte, Start Byte 169
; OnABranchOverTheDriveWall         Size   9 Byte, Start Byte 178
; OnABranchOverTheDriveNasty        Size   9 Byte, Start Byte 187
; OnABranchOverTheDriveRamp         Size   9 Byte, Start Byte 196
; OnABranchOverTheDriveConveyor     Size   9 Byte, Start Byte 205
; OnABranchOverTheDriveConveyorData Size   4 Byte, Start Byte 214
; OnABranchOverTheDriveRampData     Size   4 Byte, Start Byte 218
; OnABranchOverTheDriveBorderColor  Size   1 Byte, Start Byte 222
; OnABranchOverTheDriveReserved     Size   4 Byte, Start Byte 223
; OnABranchOverTheDriveItem		    Size   8 Byte, Start Byte 227
; OnABranchOverTheDriveDirection    Size   4 Byte, Start Byte 235
; OnABranchOverTheDriveUnused       Size   1 Byte, Start Byte 239
; OnABranchOverTheDriveEnemy1		Size   4 Byte, Start Byte 240
; OnABranchOverTheDriveEnemy2		Size   4 Byte, Start Byte 244
; OnABranchOverTheDriveEnemy3		Size   4 Byte, Start Byte 248
; OnABranchOverTheDriveEnemy4		Size   4 Byte, Start Byte 252
; OnABranchOverTheDrivePosWilly     Size   2 Byte, Start Byte 256
;
;===========================================================================

; Room layout for Room  (On A Branch Over The Drive)
OnABranchOverTheDriveLayout:           
	DEFB 0,0,0,0,0,0,0,0	;Room layout
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,60,0,0,0,0,0
	DEFB 0,0,253,80,0,0,0,0
	DEFB 0,0,63,192,5,85,85,85
	DEFB 0,0,0,0,15,191,59,192
	DEFB 0,0,0,0,3,240,59,0
	DEFB 0,0,0,0,0,0,15,0
	DEFB 0,0,0,80,0,0,0,0
	DEFB 0,80,0,0,0,0,0,0
	DEFB 0,0,5,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0
	DEFB 0,0,0,0,0,0,0,0

OnABranchOverTheDriveTile:
;The next 32 bytes are copied to 32896 and specify the room name.
    DEFM "   On a Branch Over the Drive   "	    ;Room name

;The next 54 bytes are copied to 32928 and contain the attributes and graphic data for the tiles used to build the room.
OnABranchOverTheDriveBackground:
    DEFB $07,0,0,0,0,0,0,0,0	            ;Background

OnABranchOverTheDriveFloor:
    DEFB 10,31,243,225,96,48,44,64,128	    ;Floor Solid

OnABranchOverTheDriveWall:
    DEFB 74,9,18,10,31,228,8,8,8	    	;Wall Solid

OnABranchOverTheDriveNasty:
    DEFB 12,66,41,84,38,135,35,42,4	    	;Nasty

OnABranchOverTheDriveRamp:
    DEFB 15,5,2,4,8,80,32,64,128	        ;Ramp Solid

OnABranchOverTheDriveConveyor:
    DEFB 255,0,0,0,0,0,0,0,0	            ;Conveyor

;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
OnABranchOverTheDriveConveyorData:
    DEFB 0	                                ;Direction (right)
    DEFW 0	                                ;Location in the attribute buffer at 24064: (15,12)
    DEFB 0	                                ;Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
OnABranchOverTheDriveRampData:
    DEFB 1	                                ;Direction (up to the right)
    DEFW 24389	                            ;Location in the attribute buffer at 24064: (14,7)
    DEFB 4	                                ;Length

;The next byte is copied to 32990 and specifies the border colour.
OnABranchOverTheDriveBorderColor:
    DEFB 4	                                ;Border colour

;The next two bytes are copied to 32991, but are not used.
OnABranchOverTheDriveReserved:
    DEFB 2, 3, 4, 7                         ; Enemy colors: all WHITE (7)

;The next eight bytes are copied to 32993 and define the item graphic.
OnABranchOverTheDriveItem:
    DEFB 48,60,79,67,130,134,228,252	         ;Item graphic (unused)

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
OnABranchOverTheDriveDirection:
	DEFB 10									;Room to the left (The Front Door)
	DEFB 8									;Room to the right (Inside the MegaTrunk)
	DEFB 13									;Room above (Out on a limb)
	DEFB 4									;Room below (The Drive)

OnABranchOverTheDriveUnused:
    DEFB 0                        ; Padding byte to keep Enemy1 offset at 240

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
OnABranchOverTheDriveEnemy1:
    DEFB $80, 8, 76, 200         ; Enemy 1 (Uccello), horizontal, Starts X=8, Y=120, Limit X=200
OnABranchOverTheDriveEnemy2:
    DEFB $80, 80, 76, 180         ; Enemy 2 (Uccello), horizontal, Starts X=80, Y=80, Limit X=180
OnABranchOverTheDriveEnemy3:
    DEFB $C4, 120, 16, 76        ; Enemy 3 (Ufo), vertical, Starts X=120, Y=40, Limit Y=130
OnABranchOverTheDriveEnemy4:
    DEFB 0,0,0,0                  ; Empty slot

OnABranchOverTheDrivePosWilly:
    db 200, 30                   ; Posizione di Willy