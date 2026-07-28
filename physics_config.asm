;===========================================================================
; physics_config.asm
;
; Configurazioni globali per la fisica del salto e del movimento in Jet Set Willy.
; Tutti i parametri di default della fisica possono essere personalizzati qui.
; Possono anche essere sovrascritti via riga di comando con sjasmplus
; (es. -DDEFAULT_JUMP_STRENGTH=5 -DDEFAULT_GRAVITY_PRESET=1).
;===========================================================================

; --- Forza del Salto di Default (Altezza iniziale) ---
; Definisce l'impulso verticale iniziale per il salto quando la stanza non specifica un valore personalizzato.
; Valori tipici:
;   6 = Salto standard (Jet Set Willy originale)
;   5 = Salto medio/corto
;   4 = Salto corto
    IFNDEF DEFAULT_JUMP_STRENGTH
DEFAULT_JUMP_STRENGTH EQU 6
    ENDIF

; Alias per compatibilità con il codice esistente
JUMP_STRENGTH: EQU DEFAULT_JUMP_STRENGTH

; --- Preset Gravità di Default ---
; Definisce il comportamento della gravità per le stanze che non hanno un valore personalizzato.
; Presets:
;   0 = Gravità 0.5 (leggera)
;   1 = Gravità 0.75 (standard JSW)
;   2 = Gravità 1.0 (pesante)
;   3 = Gravità 0.25 (molto leggera)
;   4 = Gravità 0.0 (nessuna gravità)
    IFNDEF DEFAULT_GRAVITY_PRESET
DEFAULT_GRAVITY_PRESET EQU 1
    ENDIF

; --- Velocità Massima di Caduta ---
; Limite massimo per la velocità di caduta verso il basso (in pixel/frame)
    IFNDEF MAX_FALL_SPEED
MAX_FALL_SPEED EQU 12
    ENDIF

; --- Gravità Base ---
    IFNDEF GRAVITY
GRAVITY EQU 1
    ENDIF
