;===========================================================================
; items.asm
;===========================================================================

; -------------------------------------------------------------------
; Tabella Globale degli Oggetti (Items)
; Ciascun item occupa 5 byte:
;   Byte 0: ID della stanza (0 = Test Room, 1 = The Bridge, 2 = The Off Licence, 3 = Master Bedroom, 4 = Under the MegaTree, 5 = At TheFoot The Mega Tree, 6 = The Drive, 7 = The Security Guard)
;   Byte 1: X colonna dello schermo (0..31)
;   Byte 2: Y riga dello schermo (3..18)
;   Byte 3: Attributo colore (es. $C6 per Giallo Flashing, $C5 per Cyan Flashing)
;   Byte 4: Stato (0 = Attivo/Non raccolto, 1 = Raccolto)
; La tabella termina con $FF
;
; La tabella riposrta solamente le stanza in cui effettivamente ci sono degli oggetti le altre sono omesse
;
; Tabella dei colori, se aggiungiamo $C davanti al colore questo diventa lampeggiante
; 1 - BLUE
; 2 - RED
; 3 - MAGENTA
; 4 - GREEN
; 5 - CYAN
; 6 - YELLOW
; 7 - WHITE
; -------------------------------------------------------------------
ItemsTable:
    ; Stanza 0 (The Off Licence)
    db 0, 30, 4, YELLOW, 0              ; Oggetto 1 alla colonna X=30,  riga Y=4, YELLOW, (Stato: 0=attivo)    
    db 0, 29, 4, CYAN, 0                ; Oggetto 2 alla colonna X=29,  riga Y=4, CYAN, (Stato: 0=attivo)      
    db 0, 28, 4, GREEN, 0               ; Oggetto 4 alla colonna X=28,  riga Y=4, GREEN, (Stato: 0=attivo)      
    db 0, 27, 4, MAGENTA, 0             ; Oggetto 5 alla colonna X=27,  riga Y=4, GREEN, (Stato: 0=attivo)   
    db 0, 26, 4, YELLOW, 0              ; Oggetto 6 alla colonna X=26,  riga Y=4, YELLOW, (Stato: 0=attivo)      
    db 0, 25, 4, CYAN, 0                ; Oggetto 7 alla colonna X=25,  riga Y=4, CYAN, (Stato: 0=attivo)   
    db 0, 24, 4, GREEN, 0               ; Oggetto 8 alla colonna X=24,  riga Y=4, GREEN, (Stato: 0=attivo)      
    db 0, 23, 4, MAGENTA, 0             ; Oggetto 9 alla colonna X=23,  riga Y=4, MAGENTA, (Stato: 0=attivo)   
    db 0, 22, 4, YELLOW, 0              ; Oggetto 10 alla colonna X=22, riga Y=4, YELLOW, (Stato: 0=attivo)      
    db 0, 21, 4, CYAN, 0                ; Oggetto 11 alla colonna X=21, riga Y=4, CYAN, (Stato: 0=attivo)   
    db 0, 20, 4, GREEN, 0               ; Oggetto 12 alla colonna X=20, riga Y=4, GREEN, (Stato: 0=attivo)      
    db 0, 19, 4, MAGENTA, 0             ; Oggetto 13 alla colonna X=19, riga Y=4, MAGENTA, (Stato: 0=attivo)  
    
    ; Stanza 1 (The Bridge)
    
    ; Stanza 2 (Master Bedroom)

    ; Stanza 3 (Under the MegaTree)
    db 3, 22, 0, MAGENTA, 0             ; Oggetto 1 alla colonna X=22, riga Y=0, MAGENTA, (Stato: 0=attivo)  

    ; Stanza 4 (At The Foot TheMega Tree)
    db 4, 1, 11, MAGENTA, 0             ; Oggetto 1 alla colonna X=1, riga Y=11, MAGENTA, (Stato: 0=attivo)  
    db 4, 4, 10, GREEN, 0               ; Oggetto 3 alla colonna X=4, riga Y=10, GREEN, (Stato: 0=attivo)  
    db 4, 7, 11, CYAN, 0                ; Oggetto 3 alla colonna X=7, riga Y=11, CYAN, (Stato: 0=attivo)  

    ; Stanza 5 (The Drive)

    ; Stanza 6 (The Security Guard)

    ; Stanza 7 (The Bathroom)
    db 7, 23, 13, CYAN, 0                ; Oggetto 1 alla colonna X=7, riga Y=13, CYAN, (Stato: 0=attivo)  

    db $FF                        ; Fine tabella

; -------------------------------------------------------------------
; DetermineCurrentRoomID
;
; Determina l'ID numerico della stanza corrente confrontando
; il puntatore room_ptr con gli indirizzi dei layout delle stanze.
;
; Se viene trovata una corrispondenza:
;   A = ID della stanza
;   current_room = A
;
; Mappatura:
;   0 = The Off Licence
;   1 = The Bridge
;   2 = Master Bedroom
;   3 = Under The Mega Tree
;   4 = At The Foot Of The Mega Tree
;   5 = The Drive
;   6 = The Security Guard
;   7 = The Bathroom
;
; Se nessuna stanza corrisponde viene impostato:
;   current_room = 0
; -------------------------------------------------------------------
DetermineCurrentRoomID:

    ; Salva i registri utilizzati
    push hl
    push de

    ; ---------------------------------------------------------------
    ; Confronto con TheBridgeLayout
    ; ---------------------------------------------------------------
    ld   hl, (room_ptr)
    ld   de, TheBridgeLayout
    or   a
    sbc  hl, de
    jr   nz, .not_bridge

    ld   a, 1               ; Room ID = 1
    jr   .set_room

.not_bridge:

    ; ---------------------------------------------------------------
    ; Confronto con TheOffLicenceLayout
    ; ---------------------------------------------------------------
    ld   hl, (room_ptr)
    ld   de, TheOffLicenceLayout
    or   a
    sbc  hl, de
    jr   nz, .not_office

    ld   a, 0               ; Room ID = 0
    jr   .set_room

.not_office:

    ; ---------------------------------------------------------------
    ; Confronto con MastreBedRoomLayout
    ; ---------------------------------------------------------------
    ld   hl, (room_ptr)
    ld   de, MastreBedRoomLayout
    or   a
    sbc  hl, de
    jr   nz, .not_masterbed

    ld   a, 2               ; Room ID = 2
    jr   .set_room

.not_masterbed:

    ; ---------------------------------------------------------------
    ; Confronto con UnderTheMegaTreeLayout
    ; ---------------------------------------------------------------
    ld   hl, (room_ptr)
    ld   de, UnderTheMegaTreeLayout
    or   a
    sbc  hl, de
    jr   nz, .not_undertree

    ld   a, 3               ; Room ID = 3
    jr   .set_room

.not_undertree:

    ; ---------------------------------------------------------------
    ; Confronto con AtTheFootTheMegaTreeLayout
    ; ---------------------------------------------------------------
    ld   hl, (room_ptr)
    ld   de, AtTheFootTheMegaTreeLayout
    or   a
    sbc  hl, de
    jr   nz, .not_foottree

    ld   a, 4               ; Room ID = 4
    jr   .set_room

.not_foottree:

    ; ---------------------------------------------------------------
    ; Confronto con TheDriveLayout
    ; ---------------------------------------------------------------
    ld   hl, (room_ptr)
    ld   de, TheDriveLayout
    or   a
    sbc  hl, de
    jr   nz, .not_thedrive

    ld   a, 5               ; Room ID = 5
    jr   .set_room

.not_thedrive:

    ; ---------------------------------------------------------------
    ; Confronto con TheSecurityGuardLayout
    ; ---------------------------------------------------------------
    ld   hl, (room_ptr)
    ld   de, TheSecurityGuardLayout
    or   a
    sbc  hl, de
    jr   nz, .not_securityguard

    ld   a, 6               ; Room ID = 6
    jr   .set_room

.not_securityguard:

    ; ---------------------------------------------------------------
    ; Confronto con TheBathroomLayout
    ; ---------------------------------------------------------------
    ld   hl, (room_ptr)
    ld   de, TheBathroomLayout
    or   a
    sbc  hl, de
    jr   nz, .unknown

    ld   a, 7               ; Room ID = 7
    jr   .set_room

.unknown:

    ; Nessuna corrispondenza trovata.
    ; Imposta la stanza di default.
    ld   a, 0

.set_room:

    ; Salva l'ID della stanza corrente
    ld   (current_room), a

    ; Ripristina i registri
    pop  de
    pop  hl

    ret

; -------------------------------------------------------------------
; DrawRoomItems
;
; Disegna tutti gli oggetti attivi appartenenti alla stanza corrente.
;
; Operazioni eseguite:
;   1. Azzera la griglia items_grid.
;   2. Svuota la cache degli oggetti attivi.
;   3. Scansiona ItemsTable.
;   4. Per ogni item della stanza corrente:
;        - verifica se è già stato raccolto
;        - disegna la grafica
;        - aggiorna items_grid
;        - memorizza l'item nella cache current_room_items
;   5. Aggiorna num_room_items.
;
; Record ItemsTable:
;   +0  Room ID
;   +1  X (colonna)
;   +2  Y (riga)
;   +3  Colore
;   +4  Collected flag
;
; Cache current_room_items:
;   +0  Colonna
;   +1  Riga
;   +2  Colore
;   +3  Collected flag ptr (Low)
;   +4  Collected flag ptr (High)
;
; Ogni record cache occupa 5 byte.
; -------------------------------------------------------------------
DrawRoomItems:

    ; Salva tutti i registri utilizzati
    push hl
    push de
    push bc
    push ix
    push iy

    ; ---------------------------------------------------------------
    ; Azzera items_grid (32 x 16 = 512 byte)
    ; ---------------------------------------------------------------
    ld   hl, items_grid
    ld   de, items_grid + 1
    ld   (hl), 0
    ld   bc, 511
    ldir

    ; ---------------------------------------------------------------
    ; Nessun item attivo nella stanza
    ; ---------------------------------------------------------------
    xor  a
    ld   (num_room_items), a

    ; IY punta alla cache degli item attivi
    ld   iy, current_room_items

    ; ---------------------------------------------------------------
    ; Recupera il puntatore alla bitmap dell'oggetto associato
    ; alla stanza corrente.
    ;
    ; room_ptr + OFFSET_ITEM_GRAPHIC
    ; ---------------------------------------------------------------
    ld   hl, (room_ptr)
    ld   de, OFFSET_ITEM_GRAPHIC
    add  hl, de

    push hl
    pop  ix                ; IX = bitmap item

    ; ---------------------------------------------------------------
    ; Inizio scansione della tabella degli item
    ; ---------------------------------------------------------------
    ld   hl, ItemsTable

.loop:

    ; ---------------------------------------------------------------
    ; Legge il Room ID del record corrente
    ; ---------------------------------------------------------------
    ld   a, (hl)

    ; $FF indica fine tabella
    cp   $FF
    jr   z, .done

    ; ---------------------------------------------------------------
    ; Verifica se l'item appartiene alla stanza corrente
    ; ---------------------------------------------------------------
    ld   d, a

    ld   a, (current_room)
    cp   d
    jr   nz, .next_item

    ; ---------------------------------------------------------------
    ; Legge i dati dell'item
    ; ---------------------------------------------------------------

    inc  hl
    ld   c, (hl)           ; X (colonna)

    inc  hl
    ld   b, (hl)           ; Y (riga)

    inc  hl
    ld   e, (hl)           ; Colore

    inc  hl
    ld   a, (hl)           ; Collected flag

    ; Se diverso da zero l'item è già stato raccolto
    or   a
    jr   nz, .next_no_inc

    ; ---------------------------------------------------------------
    ; Disegna l'item sullo schermo
    ;
    ; B = Row
    ; C = Column
    ; HL = bitmap pointer
    ; E = Color
    ; ---------------------------------------------------------------
    push hl

    push ix
    pop  hl

    call DrawItemGraphic

    pop  hl                ; ritorna al flag collected

    ; ---------------------------------------------------------------
    ; Aggiorna items_grid
    ;
    ; Calcolo:
    ;   offset = Row * 32 + Col
    ; ---------------------------------------------------------------
    push hl
    push de

    ld   h, 0
    ld   l, b              ; HL = Row

    add  hl, hl            ; *2
    add  hl, hl            ; *4
    add  hl, hl            ; *8
    add  hl, hl            ; *16
    add  hl, hl            ; *32

    ld   d, 0
    ld   e, c              ; DE = Col

    add  hl, de            ; Row*32 + Col

    ld   de, items_grid
    add  hl, de            ; puntatore nella griglia

    pop  de                ; ripristina colore

    ld   (hl), e           ; salva colore cella

    pop  hl

    ; ---------------------------------------------------------------
    ; Salva l'item nella cache della stanza
    ;
    ; Questo evita di dover scansionare tutta ItemsTable
    ; durante il controllo delle collisioni.
    ; ---------------------------------------------------------------

    ld   (iy+0), c         ; Colonna
    ld   (iy+1), b         ; Riga
    ld   (iy+2), e         ; Colore

    ; Salva il puntatore al flag "collected"
    ld   (iy+3), l         ; Low byte
    ld   (iy+4), h         ; High byte

    ; Passa al record successivo della cache
    ld   bc, 5
    add  iy, bc

    ; Incrementa il numero di item attivi
    ld   a, (num_room_items)
    inc  a
    ld   (num_room_items), a

    jr   .next_no_inc

.next_item:

    ; ---------------------------------------------------------------
    ; L'item non appartiene alla stanza corrente.
    ; Salta i campi del record:
    ;   X
    ;   Y
    ;   Color
    ;   Collected
    ; ---------------------------------------------------------------
    inc  hl
    inc  hl
    inc  hl
    inc  hl

.next_no_inc:

    ; ---------------------------------------------------------------
    ; Avanza al record successivo
    ; (prossimo Room ID)
    ; ---------------------------------------------------------------
    inc  hl
    jr   .loop

.done:

    ; Ripristina i registri
    pop  iy
    pop  ix
    pop  de
    pop  bc
    pop  hl

    ret

; -------------------------------------------------------------------
; DrawItemGraphic
;
; Disegna un oggetto 8x8 pixel sullo schermo dello ZX Spectrum
; utilizzando una bitmap di 8 byte e un attributo colore.
;
; Input:
;   B = Riga attributi (3..18)
;   C = Colonna attributi (0..31)
;   HL = Puntatore alla bitmap dell'oggetto (8 byte)
;   E = Attributo colore
;
; Output:
;   Nessuno
;
; Registri preservati:
;   BC, DE, HL
; -------------------------------------------------------------------
DrawItemGraphic:

    ; Salva i registri originali
    push bc
    push de
    push hl

    ; ---------------------------------------------------------------
    ; Calcolo indirizzo bitmap dello Spectrum
    ;
    ; Ogni item occupa una cella attributi (8x8 pixel).
    ;
    ; Formula:
    ;   High = $40 + (Row AND $18)
    ;   Low  = (Row AND 7) * 32 + Col
    ;
    ; DE conterrà l'indirizzo della prima scanline.
    ; ---------------------------------------------------------------

    ld   a, b
    and  $18
    add  a, $40
    ld   d, a              ; Byte alto indirizzo video

    ld   a, b
    and  7                 ; Riga interna al blocco da 8

    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8
    add  a, a              ; *16
    add  a, a              ; *32

    add  a, c              ; + colonna

    ld   e, a              ; Byte basso indirizzo video

    ; ---------------------------------------------------------------
    ; Disegno bitmap
    ;
    ; Copia 8 byte consecutivi nella memoria video.
    ; Ogni byte rappresenta una scanline da 8 pixel.
    ; ---------------------------------------------------------------

    push bc                ; Conserva Row e Col

    ld   b, 8              ; Numero scanline

.line_loop:

    ld   a, (hl)           ; Legge scanline bitmap
    ld   (de), a           ; Scrive nella memoria video

    inc  d                 ; Scanline successiva
    inc  hl                ; Byte bitmap successivo

    dec  b
    jr   nz, .line_loop

    pop  bc                ; Ripristina Row e Col

    ; ---------------------------------------------------------------
    ; Calcolo indirizzo attributo
    ;
    ; Formula:
    ;   AttrAddr = $5800 + Row * 32 + Col
    ;
    ; HL conterrà l'indirizzo della cella attributi.
    ; ---------------------------------------------------------------

    ld   h, 0
    ld   l, b              ; HL = Row

    add  hl, hl            ; *2
    add  hl, hl            ; *4
    add  hl, hl            ; *8
    add  hl, hl            ; *16
    add  hl, hl            ; *32

    ld   a, c              ; A = Colonna

    add  a, l
    ld   l, a

    jr   nc, .no_carry
    inc  h

.no_carry:

    ; HL = Row * 32 + Col

    ld   de, $5800
    add  hl, de            ; HL = indirizzo attributi

    ; ---------------------------------------------------------------
    ; Recupera il colore originale dallo stack.
    ;
    ; Layout stack:
    ;   HL originale
    ;   DE originale (E = colore)
    ;   BC originale
    ; ---------------------------------------------------------------

    pop  bc                ; Recupera HL originale
    pop  de                ; Recupera DE originale

    ; ---------------------------------------------------------------
    ; Scrive l'attributo colore
    ; ---------------------------------------------------------------

    ld   a, e              ; A = colore
    ld   (hl), a           ; Scrive nella RAM attributi

    ; ---------------------------------------------------------------
    ; Ripristina HL e BC originali
    ; ---------------------------------------------------------------

    push bc
    pop  hl                ; HL originale

    pop  bc                ; BC originale

    ret

; -------------------------------------------------------------------
; RestoreBackgroundCell
;
; Ripristina il contenuto originale di una cella della stanza.
; Viene utilizzata principalmente quando un item viene raccolto:
; invece di lasciare un "buco", la routine ridisegna il tile
; originale presente nella mappa della stanza.
;
; Input:
;   B = Row (3..18)
;   C = Col (0..31)
;
; Utilizza:
;   room_ptr -> struttura dati della stanza corrente
;   GetCellFromUnpacked -> restituisce il tipo di cella
;   DrawTile -> ridisegna il tile selezionato
;
; Tipi di cella:
;   0 = Background
;   1 = Floor
;   2 = Wall
;   3 = Nasty
; -------------------------------------------------------------------
RestoreBackgroundCell:

    ; Salva tutti i registri utilizzati
    push iy
    push bc
    push de
    push hl
    push ix

    ; ---------------------------------------------------------------
    ; Conserva Row e Col in IY.
    ;
    ; Dopo la chiamata a GetCellFromUnpacked e i calcoli successivi
    ; BC potrebbe essere modificato.
    ; ---------------------------------------------------------------
    push bc
    pop  iy                ; IYH = Row, IYL = Col

    ; ---------------------------------------------------------------
    ; Determina quale tipo di cella è presente nella posizione
    ; specificata.
    ;
    ; Input:
    ;   B = Row
    ;   C = Col
    ;
    ; Output:
    ;   A = tipo cella
    ; ---------------------------------------------------------------
    ld   a, b

    call GetCellFromUnpacked

    ; ---------------------------------------------------------------
    ; Recupera il puntatore alla stanza corrente.
    ;
    ; DE = base della struttura stanza
    ; ---------------------------------------------------------------
    ld   de, (room_ptr)

    ; ---------------------------------------------------------------
    ; Seleziona il tile corretto in base al tipo di cella.
    ;
    ; A = 0 -> Background
    ; A = 1 -> Floor
    ; A = 2 -> Wall
    ; A = 3 -> Nasty
    ; ---------------------------------------------------------------

    or   a
    jr   nz, .not_bg

    ; Background
    ld   hl, OFFSET_BG
    add  hl, de
    jr   .draw_cell

.not_bg:

    dec  a
    jr   nz, .not_floor

    ; Floor
    ld   hl, OFFSET_FLOOR
    add  hl, de
    jr   .draw_cell

.not_floor:

    dec  a
    jr   nz, .not_wall

    ; Wall
    ld   hl, OFFSET_WALL
    add  hl, de
    jr   .draw_cell

.not_wall:

    ; Nasty
    ld   hl, OFFSET_NASTY
    add  hl, de

.draw_cell:

    ; ---------------------------------------------------------------
    ; HL punta ora alla grafica del tile da ridisegnare.
    ;
    ; DrawTile si aspetta:
    ;   IX = puntatore tile
    ;   B  = Row
    ;   C  = Col
    ; ---------------------------------------------------------------
    push hl
    pop  ix

    ; Ripristina Row e Col salvati in IY
    push iy
    pop  bc

    ; Disegna il tile originale
    call DrawTile

    ; ---------------------------------------------------------------
    ; Ripristina i registri salvati
    ; ---------------------------------------------------------------
    pop  ix
    pop  hl
    pop  de
    pop  bc
    pop  iy

    ret

; -------------------------------------------------------------------
; CheckWillyItemCollision
;
; Verifica se Willy collide con un item utilizzando il controllo
; di sovrapposizione tra rettangoli (Bounding Box Collision).
;
; Input:
;   A = ItemX (colonna attributi 0..31)
;   H = ItemY (riga attributi 3..18)
;
; Coordinate item:
;   Ogni item occupa una cella da 8x8 pixel.
;
; Coordinate Willy:
;   Willy occupa un rettangolo di 16x16 pixel.
;
; Output:
;   Carry Set   = collisione rilevata
;   Carry Clear = nessuna collisione
;
; Registri preservati:
;   BC, DE, HL
; -------------------------------------------------------------------
CheckWillyItemCollision:

    ; Salva i registri utilizzati
    push bc
    push de
    push hl

    ; ---------------------------------------------------------------
    ; Calcola il bounding box orizzontale dell'item
    ;
    ; ItemLeft  = ItemX * 8
    ; ItemRight = ItemLeft + 7
    ;
    ; E = ItemLeft
    ; D = ItemRight
    ; ---------------------------------------------------------------
    ld   l, a              ; L = ItemX

    ld   a, l
    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8

    ld   e, a              ; E = ItemLeft

    add  a, 7
    ld   d, a              ; D = ItemRight

    ; ---------------------------------------------------------------
    ; Recupera la posizione corrente di Willy
    ;
    ; B = WillyY
    ; C = WillyX
    ; ---------------------------------------------------------------
    ld   bc, (PlayerPos)

    ; ---------------------------------------------------------------
    ; Primo test:
    ;
    ; WillyLeft <= ItemRight
    ;
    ; Se Willy è completamente a destra dell'item
    ; non può esserci collisione.
    ; ---------------------------------------------------------------
    ld   a, c              ; A = WillyLeft

    cp   d                 ; WillyLeft vs ItemRight

    jr   z, .x_ok
    jr   c, .x_ok

    jr   .no_collision

.x_ok:

    ; ---------------------------------------------------------------
    ; Secondo test:
    ;
    ; WillyRight >= ItemLeft
    ;
    ; WillyRight = WillyX + 7
    ; ---------------------------------------------------------------
    add  a, 7

    cp   e                 ; WillyRight vs ItemLeft

    jr   z, .y_check
    jr   nc, .y_check

    jr   .no_collision

.y_check:

    ; ---------------------------------------------------------------
    ; Recupera ItemY dal valore originale di HL
    ;
    ; H contiene la riga dell'item.
    ; ---------------------------------------------------------------
    pop  hl
    push hl

    ; ---------------------------------------------------------------
    ; Calcola il bounding box verticale dell'item
    ;
    ; ItemTop    = ItemY * 8
    ; ItemBottom = ItemTop + 7
    ;
    ; E = ItemTop
    ; D = ItemBottom
    ; ---------------------------------------------------------------
    ld   a, h

    add  a, a              ; *2
    add  a, a              ; *4
    add  a, a              ; *8

    ld   e, a              ; ItemTop

    add  a, 7
    ld   d, a              ; ItemBottom

    ; ---------------------------------------------------------------
    ; Primo test verticale:
    ;
    ; WillyTop <= ItemBottom
    ; ---------------------------------------------------------------
    ld   a, b              ; WillyTop

    cp   d

    jr   z, .y_ok
    jr   c, .y_ok

    jr   .no_collision

.y_ok:

    ; ---------------------------------------------------------------
    ; Secondo test verticale:
    ;
    ; WillyBottom >= ItemTop
    ;
    ; WillyBottom = WillyY + 15
    ; ---------------------------------------------------------------
    add  a, 15

    cp   e

    jr   z, .collision
    jr   nc, .collision

    jr   .no_collision

.collision:

    ; ---------------------------------------------------------------
    ; Collisione rilevata
    ; ---------------------------------------------------------------
    pop  hl
    pop  de
    pop  bc

    scf                    ; Carry = 1

    ret

.no_collision:

    ; ---------------------------------------------------------------
    ; Nessuna collisione
    ; ---------------------------------------------------------------
    pop  hl
    pop  de
    pop  bc

    or   a                 ; Carry = 0

    ret

; -------------------------------------------------------------------
; CheckRoomItemsCollision
;
; Controlla se Willy entra in collisione con uno degli item
; attivi presenti nella stanza corrente.
;
; Per ogni item:
;   - verifica che appartenga alla stanza corrente
;   - verifica che non sia già stato raccolto
;   - esegue il test di collisione con Willy
;
; Se l'item viene raccolto:
;   - imposta il flag "collected"
;   - rimuove l'item dalla cache items_grid
;   - incrementa il contatore degli oggetti raccolti
;   - aggiorna l'HUD
;   - ripristina il tile di sfondo
;   - riproduce il suono di raccolta
;
; Formato record ItemsTable:
;   +0 RoomID
;   +1 X
;   +2 Y
;   +3 Color
;   +4 Collected
;
; Fine tabella:
;   RoomID = $FF
; -------------------------------------------------------------------
CheckRoomItemsCollision:

    ; Salva i registri utilizzati
    push hl
    push de
    push bc

    ; Inizio scansione della tabella degli item
    ld   hl, ItemsTable

.loop:

    ; ---------------------------------------------------------------
    ; Legge il Room ID dell'item corrente
    ; ---------------------------------------------------------------
    ld   a, (hl)

    ; $FF indica fine tabella
    cp   $FF
    jr   z, .done

    ; ---------------------------------------------------------------
    ; Verifica se l'item appartiene alla stanza corrente
    ; ---------------------------------------------------------------
    ld   d, a              ; D = RoomID item

    ld   a, (current_room)
    cp   d

    ; Se appartiene a un'altra stanza salta il record
    jr   nz, .next_item

    ; ---------------------------------------------------------------
    ; Legge coordinate e stato dell'item
    ; ---------------------------------------------------------------

    inc  hl
    ld   c, (hl)           ; C = X

    inc  hl
    ld   b, (hl)           ; B = Y

    inc  hl                ; salta Color

    inc  hl                ; punta a Collected

    ld   a, (hl)

    ; ---------------------------------------------------------------
    ; Item già raccolto?
    ; ---------------------------------------------------------------
    or   a
    jr   nz, .next_no_inc

    ; ---------------------------------------------------------------
    ; Test collisione Willy ↔ Item
    ;
    ; Input richiesto:
    ;   A = ItemX
    ;   H = ItemY
    ; ---------------------------------------------------------------
    ld   a, c

    push hl                ; salva puntatore al flag Collected

    ld   h, b

    call CheckWillyItemCollision

    pop  hl

    ; Nessuna collisione
    jr   nc, .next_no_inc

    ; ===============================================================
    ; ITEM RACCOLTO
    ; ===============================================================

    ; ---------------------------------------------------------------
    ; Marca l'item come raccolto
    ; ---------------------------------------------------------------
    ld   (hl), 1

    ; ---------------------------------------------------------------
    ; Rimuove l'item dalla cache items_grid
    ;
    ; Calcolo:
    ;   offset = Row * 32 + Col
    ; ---------------------------------------------------------------
    push hl
    push de

    ld   h, 0
    ld   l, b              ; HL = Row

    add  hl, hl            ; *2
    add  hl, hl            ; *4
    add  hl, hl            ; *8
    add  hl, hl            ; *16
    add  hl, hl            ; *32

    ld   e, c
    ld   d, 0

    add  hl, de            ; Row*32 + Col

    ld   de, items_grid
    add  hl, de

    ; La cella non contiene più un item
    ld   (hl), 0

    pop  de
    pop  hl

    ; ---------------------------------------------------------------
    ; Conserva il puntatore all'entry corrente
    ; poiché le routine successive possono alterare HL.
    ; ---------------------------------------------------------------
    push hl

    ; ---------------------------------------------------------------
    ; Aggiorna il numero di oggetti raccolti
    ; ---------------------------------------------------------------
    ld   a, (items_collected)

    inc  a

    ld   (items_collected), a

    ; ---------------------------------------------------------------
    ; Aggiorna il contatore visualizzato a schermo
    ; ---------------------------------------------------------------
    call UpdateItemsCollectedDisplay

    ; ---------------------------------------------------------------
    ; Ripristina il tile originale della stanza
    ; eliminando la grafica dell'item.
    ;
    ; Input:
    ;   B = Row
    ;   C = Col
    ; ---------------------------------------------------------------
    call RestoreBackgroundCell

    ; ---------------------------------------------------------------
    ; Riproduce il suono di raccolta
    ; ---------------------------------------------------------------
    call PlayCollectSound

    ; Ripristina il puntatore alla tabella
    pop  hl

    ; Continua con il record successivo
    jr   .next_no_inc

.next_item:

    ; ---------------------------------------------------------------
    ; Salta i campi del record:
    ;   X
    ;   Y
    ;   Color
    ;   Collected
    ; ---------------------------------------------------------------
    inc  hl
    inc  hl
    inc  hl
    inc  hl

.next_no_inc:

    ; ---------------------------------------------------------------
    ; Avanza al record successivo.
    ;
    ; Dopo Collected troviamo il RoomID dell'item seguente.
    ; ---------------------------------------------------------------
    inc  hl

    jr   .loop

.done:

    ; Ripristina i registri
    pop  bc
    pop  de
    pop  hl

    ret

; -------------------------------------------------------------------
; PlayCollectSound
;
; Genera un breve effetto sonoro (beep) tramite il buzzer
; dello ZX Spectrum utilizzando il port $FE.
;
; Il suono viene prodotto alternando ON/OFF del bit 4
; (speaker) con un semplice delay software.
;
; Effetto risultante:
;   beep breve tipo "pickup item"
; -------------------------------------------------------------------
PlayCollectSound:

    ; Salva registri utilizzati
    push bc
    push de

    ; ---------------------------------------------------------------
    ; Numero di cicli del beep (durata complessiva del suono)
    ; ---------------------------------------------------------------
    ld   b, 120

.sound_loop:

    ; ---------------------------------------------------------------
    ; SPEAKER ON
    ;
    ; Legge il colore del bordo corrente e attiva il bit 4
    ; per pilotare lo speaker.
    ; ---------------------------------------------------------------
    ld   a, (room_border_color)
    or   $10               ; bit 4 = 1 → speaker ON

    out  ($fe), a         ; scrive sul port ULA

    ; ---------------------------------------------------------------
    ; Delay (mezzo periodo)
    ; Loop software a consumo CPU
    ; ---------------------------------------------------------------
    ld   c, 60

.d1:
    dec  c
    jr   nz, .d1

    ; ---------------------------------------------------------------
    ; SPEAKER OFF
    ;
    ; Mantiene il colore del bordo ma disattiva lo speaker
    ; ---------------------------------------------------------------
    ld   a, (room_border_color)
    and  $ef              ; bit 4 = 0 → speaker OFF

    out  ($fe), a

    ; ---------------------------------------------------------------
    ; Secondo delay (mezzo periodo)
    ; Completa l’onda quadra
    ; ---------------------------------------------------------------
    ld   c, 60

.d2:
    dec  c
    jr   nz, .d2

    ; ---------------------------------------------------------------
    ; Ripete fino a completare il numero di cicli
    ; ---------------------------------------------------------------
    djnz .sound_loop

    ; Ripristina registri salvati
    pop  de
    pop  bc

    ret

; -------------------------------------------------------------------
; CheckActiveItemAtCell
;
; Verifica in modo rapido se esiste un item attivo (non raccolto)
; nella cella specificata della griglia items_grid.
;
; Questa routine usa una lookup diretta su una mappa 32x16,
; evitando la scansione della ItemsTable.
;
; Input:
;   B = Colonna (0..31)
;   C = Riga (0..15)
;
; Output:
;   Carry Set   = item presente nella cella
;   Carry Clear = nessun item
;
; Nota:
;   HL NON è restituito valido (commento originale non corretto:
;   la routine non punta a ItemsTable).
; -------------------------------------------------------------------
CheckActiveItemAtCell:

    ; Salva registri usati
    push de
    push hl

    ; ---------------------------------------------------------------
    ; Calcolo indice lineare nella griglia 32x16:
    ;
    ; offset = Row * 32 + Col
    ; ---------------------------------------------------------------
    ld   h, 0
    ld   l, c              ; HL = Row

    add  hl, hl            ; *2
    add  hl, hl            ; *4
    add  hl, hl            ; *8
    add  hl, hl            ; *16
    add  hl, hl            ; *32

    ; Aggiunge la colonna
    ld   e, b
    ld   d, 0
    add  hl, de            ; HL = Row*32 + Col

    ; ---------------------------------------------------------------
    ; Accesso alla griglia degli item attivi
    ; ---------------------------------------------------------------
    ld   de, items_grid
    add  hl, de            ; HL = address cella

    ; ---------------------------------------------------------------
    ; Controllo presenza item
    ;
    ; items_grid contiene:
    ;   0 = nessun item
    ;   >0 = item attivo (colore o flag)
    ; ---------------------------------------------------------------
    ld   a, (hl)
    or   a
    jr   z, .not_active

    ; ---------------------------------------------------------------
    ; Item trovato
    ; ---------------------------------------------------------------
    pop  hl
    pop  de

    scf                    ; Carry = 1
    ret

.not_active:

    ; ---------------------------------------------------------------
    ; Nessun item nella cella
    ; ---------------------------------------------------------------
    pop  hl
    pop  de

    or   a                 ; Carry = 0
    ret
