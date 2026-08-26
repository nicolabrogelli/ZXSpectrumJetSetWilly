;===========================================================================
; audio.asm
;
; Gestione degli effetti sonori e della musica di sottofondo per il beeper.
;===========================================================================

; -------------------------------------------------------------------
; Audio_UpdateJumpSound
;
; Gestisce la riproduzione dell'effetto sonoro del salto frame-by-frame.
; Viene chiamata una volta per frame nel ciclo principale.
; -------------------------------------------------------------------
Audio_UpdateJumpSound:
    push af
    push bc
    push de
    push hl

    ; Controlla se il suono è attivo (note < 18)
    ld   a, (Audio_jump_sound_note)
    cp   18                        ; Ci sono 18 note (0..17)
    jr   nc, .done                 ; Se >= 18, non stiamo riproducendo

    ; Carica la nota corrente da suonare
    ld   e, a
    ld   d, 0
    ld   hl, Audio_JumpSoundDelays
    add  hl, de
    ld   a, (hl)                   ; A = delay della nota corrente
    ld   d, a                      ; D = delay della nota

    ; Suona la nota: 15 cicli
    ld   b, 15
.note_loop:
    ; Speaker ON
    ld   a, (room_border_color)
    or   $10
    out  ($fe), a
    ld   c, d
.d1:
    dec  c
    jr   nz, .d1

    ; Speaker OFF
    ld   a, (room_border_color)
    and  $ef
    out  ($fe), a
    ld   c, d
.d2:
    dec  c
    jr   nz, .d2

    djnz .note_loop

    ; Passa alla nota successiva
    ld   a, (Audio_jump_sound_note)
    inc  a
    ld   (Audio_jump_sound_note), a

.done:
    pop  hl
    pop  de
    pop  bc
    pop  af
    ret

Audio_JumpSoundDelays:
    db 51, 45, 38, 32, 25, 19, 12, 6, 12, 19, 25, 32, 38, 45, 51, 58, 64, 71

    IF ENABLE_MUSIC != 0
; -------------------------------------------------------------------
; Audio_UpdateMusic
;
; Gestisce la riproduzione della musica di sottofondo frame-by-frame.
; Riproduce "If I Were a Rich Man" fedele alla routine originale di Jet Set Willy:
; - Tabella di 64 note (128 burst per ciclo completo)
; - Cadenza temporizzata a 2 frame per burst (80ms) per rispettare il tempo reale
; - Generazione tono con ciclo beeper originale (768 passaggi)
; - Variazione dinamica dell'intonazione in base alle vite rimaste
; -------------------------------------------------------------------
Audio_UpdateMusic:
    push af
    push bc
    push de
    push hl

    ; Gestione del tempo (suona 1 burst ogni 2 frame = 80ms per frame rate a 25FPS)
    ld   a, (Audio_music_frame_counter)
    dec  a
    ld   (Audio_music_frame_counter), a
    jr   nz, .done

    ld   a, 2                     ; Reimposta contatore a 2 frame
    ld   (Audio_music_frame_counter), a

    ; Incrementa l'indice delle note (0..127) e calcola l'offset nota (0..63)
    ld   a, (Audio_music_note_idx)
    inc  a
    ld   (Audio_music_note_idx), a
    and  126                      ; Maschera bit 1..6 (2 burst per nota)
    rrca                          ; A = indice nota nella tabella (0..63)
    ld   e, a
    ld   d, 0
    ld   hl, Audio_MusicTune
    add  hl, de

    ; Variazione di intonazione in base alle vite rimaste (come nell'originale)
    ld   a, (willy_lives)         ; Vite di Willy (0..7)
    cp   8
    jr   c, .lives_ok
    ld   a, 7
.lives_ok:
    rlca
    rlca
    sub  28
    neg                           ; A = 28 - (willy_lives * 4) -> 0 a 7 vite
    add  a, (hl)                  ; A = ritardo tono base + offset vite
    ld   d, a                     ; D = periodo semionda

    ; Generazione del tono con il beeper (768 passaggi identici all'originale)
    ld   a, (room_border_color)
    and  $07                      ; Mantiene i bit del bordo hardware puliti
    ld   e, d                     ; E = contatore semionda
    ld   b, 0                     ; B = 0 (256 iterazioni djnz)
    ld   c, 3                     ; C = 3 (3 * 256 = 768 passaggi totali, ~8.7ms)
.tone_loop:
    out  ($fe), a                 ; 11 T-states
    dec  e                        ; 4 T-states
    jr   nz, .no_toggle           ; 12 T-states
    ld   e, d                     ; 4 T-states
    xor  $18                      ; 7 T-states (toggle EAR bit 4 e MIC bit 3)
.no_toggle:
    djnz .tone_loop               ; 13 T-states
    dec  c                        ; 4 T-states
    jr   nz, .tone_loop           ; 12 T-states

    ; Ripristina speaker OFF mantenendo il colore del bordo
    ld   a, (room_border_color)
    and  $07
    out  ($fe), a

.done:
    pop  hl
    pop  de
    pop  bc
    pop  af
    ret

Audio_MusicTune:
    ; Spartito originale in-game "If I Were a Rich Man" (64 note)
    db 86, 96, 86, 96, 102, 102, 128, 128, 128, 128, 102, 96, 86, 96, 86, 96
    db 102, 96, 86, 76,  72,  76,  72,  76,  86,  86,  86,  86, 86, 86, 86, 86
    db  64, 64, 64, 64,  68,  68,  76,  76,  86,  96, 102,  96, 86, 86, 102, 102
    db  81, 86, 96, 86,  81,  81,  96,  96,  64,  64,  64,  64, 64, 64, 64, 64

; -------------------------------------------------------------------
; Audio_PlayTitleNote
;
; Suona una nota della melodia del titolo (Moonlight Sonata).
; HL = puntatore al byte della nota in Audio_TitleMusicSheet
; Ritorna:
;   Z flag SET   -> Tasto ENTER premuto (interrompi e avvia il gioco)
;   Z flag RESET -> Nota completata regolarmente senza pressione di ENTER
; -------------------------------------------------------------------
Audio_PlayTitleNote:
    push bc
    push de
    push hl

    ld   e, (hl)               ; E = ritardo periodo nota
    ld   d, e                  ; D = contatore ritardo
    ld   b, 0                  ; B = 0 (256 iterazioni djnz)
    ld   c, 100                ; C = 100 passaggi di ciclo (50 alti, 50 bassi)
    xor  a                     ; Bordo nero, speaker off

.tone_loop:
    out  ($fe), a              ; 11 T-states
    dec  d                     ; 4 T-states
    jr   nz, .no_toggle        ; 12 T-states
    ld   d, e                  ; 4 T-states
    xor  $18                   ; 7 T-states (toggle EAR bit 4 e MIC bit 3)
.no_toggle:
    djnz .tone_loop            ; 13 T-states

    ; A metà nota (C = 50), dimezza la frequenza (raddoppia E) e controlla ENTER
    ex   af, af'
    ld   a, c
    cp   50
    jr   nz, .no_octave_drop
    rl   e                     ; Scala di un'ottava verso il basso

    ; Controllo reattivo di ENTER a metà nota (Porta $BFFE, Bit 0)
    ld   a, $bf
    in   a, ($fe)
    rra
    jr   nc, .enter_hit        ; Carry = 0 -> tasto premuto!

.no_octave_drop:
    ex   af, af'
    dec  c
    jr   nz, .tone_loop

    ; Controllo a fine nota
    xor  a
    out  ($fe), a              ; Spegne lo speaker
    ld   a, $bf
    in   a, ($fe)
    rra
    jr   nc, .enter_hit_clean

    ; Nota completata senza tasti premuti
    pop  hl
    pop  de
    pop  bc
    or   1                     ; Forza flag NZ (Zero = 0)
    ret

.enter_hit:
    ex   af, af'
.enter_hit_clean:
    xor  a
    out  ($fe), a              ; Spegne lo speaker
    pop  hl
    pop  de
    pop  bc
    cp   a                     ; Forza flag Z (Zero = 1)
    ret

Audio_TitleMusicSheet:
    ; Melodia dello start screen (Moonlight Sonata - Beethoven, come in JSW originale)
    db 81, 60, 51, 81, 60, 51, 81, 60, 51, 81, 60, 51, 81, 60, 51, 81
    db 60, 51, 81, 60, 51, 81, 60, 51, 76, 60, 51, 76, 60, 51, 76, 57
    db 45, 76, 57, 45, 81, 64, 45, 81, 60, 51, 81, 60, 54, 91, 64, 54
    db 102, 81, 60, 81, 60, 51, 81, 60, 51, 40, 60, 40, 40, 54, 45, 81
    db 54, 45, 81, 54, 45, 40, 54, 40, 40, 60, 51, 81, 60, 51, 38, 60
    db 45, 76, 60, 45, 40, 64, 51, 81, 64, 51, 45, 64, 54, 32, 64, 54
    db 61, 121, 61, 255

; -------------------------------------------------------------------
; Audio_PlayGameOverFootSound
;
; Genera l'effetto sonoro originale a frequenza crescente durante la
; discesa del Piede nella schermata di Game Over (come in music/game-over.ogg).
; Input: B = coordinata Y del Piede (0..96)
; -------------------------------------------------------------------
Audio_PlayGameOverFootSound:
    push af
    push bc
    push de

    ; Calcola il ritardo del semionda E = 255 - (2 * Y)
    ld   a, b                  ; A = Y (0..96)
    add  a, a                  ; A = 2 * Y (0..192)
    cpl                        ; A = 255 - (2 * Y) -> da 255 (tono grave) a 63 (tono acuto)
    ld   e, a                  ; E = periodo delay semionda

    xor  a                     ; A = 0 (bordo nero, speaker low)
    ld   c, 64                 ; C = 64 semicicli di commutazione beeper

.sound_loop:
    out  ($fe), a              ; Output beeper
    xor  $18                   ; Toggle EAR (bit 4) e MIC (bit 3)
    ld   b, e                  ; B = delay semionda
.d1:
    djnz .d1
    dec  c
    jr   nz, .sound_loop

    ; Spegne lo speaker
    xor  a
    out  ($fe), a

    pop  de
    pop  bc
    pop  af
    ret
    ELSE
Audio_UpdateMusic:
    ret
Audio_PlayTitleNote:
    or   1
    ret
Audio_PlayGameOverFootSound:
    halt
    ret
    ENDIF

; -------------------------------------------------------------------
; Audio_PlayCollectSound
;
; Genera un breve effetto sonoro (beep) tramite il buzzer
; dello ZX Spectrum utilizzando il port $FE quando viene raccolto un oggetto.
; -------------------------------------------------------------------
Audio_PlayCollectSound:
    push bc
    push de

    ld   b, 120
.sound_loop:
    ld   a, (room_border_color)
    or   $10               ; speaker ON
    out  ($fe), a

    ld   c, 60
.d1:
    dec  c
    jr   nz, .d1

    ld   a, (room_border_color)
    and  $ef              ; speaker OFF
    out  ($fe), a

    ld   c, 60
.d2:
    dec  c
    jr   nz, .d2

    djnz .sound_loop

    pop  de
    pop  bc
    ret
