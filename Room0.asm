; Room layout
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


db 0,0,0,0,0,0,0,0,0	                ; Background
db 68,255,222,108,136,18,64,4,0	        ; Floor
db 22,34,255,136,255,34,255,136,255	    ; Wall
db 5,248,136,158,189,189,158,136,248	; Nasty
db 7,3,0,12,0,48,0,192,0	            ; Ramp
db 67,51,255,51,0,255,0,170,0	        ; Conveyor


; he next four bytes are copied to 32982 and specify the direction, location and length of the conveyor.
DEFB 0	                                ; Direction (left)
DEFW 24371	                            ; Location in the attribute buffer at 24064: (9,19)
DEFB 12	                                ; Length

;The next four bytes are copied to 32986 and specify the direction, location and length of the ramp.
DEFB 1	                                ; Direction (up to the right)
DEFW 24535	                            ; Location in the attribute buffer at 24064: (14,23)
DEFB 4	                                ; Length

;The next byte is copied to 32990 and specifies the border colour.
DEFB 5	                                ; Border colour

;The next two bytes are copied to 32991, but are not used.
DEFB 0,160	                            ; Unused

;The next eight bytes are copied to 32993 and define the item graphic.
;item00
DEFB 24,24,60,126,98,98,98,126	        ; Item graphic

;The next four bytes are copied to 33001 and specify the rooms to the left, to the right, above and below.
DEFB 1	                                ; Room to the left (The Bridge)
DEFB 0	                                ; Room to the right (The Off Licence)
DEFB 0	                                ; Room above (The Off Licence)
DEFB 0	                                ; Room below (The Off Licence)

;The next three bytes are copied to 33005, but are not used.
DEFB 0,0,0	                            ; Unused

;The next eight pairs of bytes are copied to 33008 and specify the entities (ropes, arrows, guardians) in this room.
DEFB 10,138                             ; Guardian no. 10 (vertical), base sprite 4, x=10 (41040)
DEFB 12,29                              ; Guardian no. 12 (horizontal), base sprite 0, initial x=29 (41056)
DEFB 44,39                              ; Guardian no. 44 (vertical), base sprite 1, x=7 (41312)
DEFB 255,0                              ; Terminator (41976)
DEFB 0,0	                            ; Nothing (40960)
DEFB 0,0	                            ; Nothing (40960)
DEFB 0,0	                            ; Nothing (40960)
DEFB 0,0	                            ; Nothing (40960)
