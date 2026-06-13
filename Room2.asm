; Room layout
Room0Layout:
db  0,0,0,0,0,0,0,0	
db  0,0,0,0,0,0,0,0
db  0,0,0,0,0,0,0,0
db  0,0,0,170,170,170,170,170
db  0,0,0,128,0,0,0,2
db  0,0,0,128,0,0,0,2
db  0,0,0,140,0,0,0,2
db  0,0,0,128,0,0,0,2
db  0,0,0,128,0,0,0,2
db  0,0,0,128,0,0,0,2
db  0,0,0,128,0,0,0,2
db  0,0,0,170,0,0,2,170
db  0,0,0,0,0,0,0,2
db  0,0,0,0,0,0,0,2
db  0,0,0,0,0,0,0,2
db  85,85,85,85,85,85,85,85

Room0Tile:
DEFM "         The Off Licence        "	    ;Room name

Room0Background:
db 0,0,0,0,0,0,0,0,0	                ; Background

Room0Floor:
db 68,255,222,108,136,18,64,4,0	        ; Floor

Room0Wall:
db 22,34,255,136,255,34,255,136,255	    ; Wall

Room0Nasty:
db 5,248,136,158,189,189,158,136,248	; Nasty

Room0Ramp:
db 7,3,0,12,0,48,0,192,0	            ; Ramp

Room0Conveyor:
db 67,51,255,51,0,255,0,170,0	        ; Conveyor


;The next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
Room0ConveyorData:
DEFB 0	                                ; Direction (left)
DEFW 24371	                            ; Location in the attribute buffer at 24064: (9,19)
DEFB 12	                                ; Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
Room0RampData:
DEFB 1	                                ; Direction (up to the right)
DEFW 24535	                            ; Location in the attribute buffer at 24064: (14,23)
DEFB 4	                                ; Length

;The next byte is copied to 32990 and specifies the border colour.
Room0BorderColor:
DEFB 5	                                ; Border colour

;The next two bytes are copied to 32991, but are not used.
Room0Reserved:
DEFB 0,160	                            ; Unused

;The next eight bytes are copied to 32993 and define the item graphic.
Room0Item:
DEFB 24,24,60,126,98,98,98,126	        ; Item graphic

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
Room0Direction:
DEFB 1	                                ; Room to the left (The Bridge)
DEFB 0	                                ; Room to the right (The Off Licence)
DEFB 0	                                ; Room above (The Off Licence)
DEFB 0	                                ; Room below (The Off Licence)

;The next three bytes are copied to 33005, but are not used.
Room0Unused:
DEFB 0,0,0	                            ; Unused

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
Room0Enemy1:
DEFB 10,138                             ; Guardian no. 10 (vertical), base sprite 4, x=10 (41040)
Room0Enemy2:
DEFB 12,29                              ; Guardian no. 12 (horizontal), base sprite 0, initial x=29 (41056)

Room0Enemy3:
DEFB 44,39                              ; Guardian no. 44 (vertical), base sprite 1, x=7 (41312)

Room0Enemy4:
DEFB 255,0                              ; Terminator (41976)

Room0Enemy5:
DEFB 0,0	                            ; Nothing (40960)

Room0Enemy6:
DEFB 0,0	                            ; Nothing (40960)

Room0Enemy7:
DEFB 0,0	                            ; Nothing (40960)

Room0Enemy8:
DEFB 0,0	                            ; Nothing (40960)
