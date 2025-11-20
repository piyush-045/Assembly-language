ORG 0000H

; --- Register Definitions ---
P1M1       EQU 0B3H
P1M2       EQU 0B4H
PWMCON0    EQU 0D8H
PWMCON1    EQU 0DFH
PWMPH      EQU 0D1H
PWMPL      EQU 0D9H
PWM2H      EQU 0D4H
PWM2L      EQU 0DCH
PIOCON0    EQU 0DEH
CKCON      EQU 8EH

; --- Initialize P1.0 as Push-Pull Output ---
MOV P1M1, #00H
MOV P1M2, #00H
ORL P1M1, #00000000B
ORL P1M2, #00000001B   ; P1.0 push-pull

; --- Main Program ---
MAIN:
        ACALL PWM_CONFIG
        ACALL MISSION_MELODY
HERE:   SJMP HERE

; --- PWM Configuration ---
PWM_CONFIG:
        SETB PWMCON0.4          ; Clear counter
        MOV CKCON, #00H
        MOV PWMCON1, #03H       ; Prescaler = Fsys / 8
        MOV PIOCON0, #04H       ; Enable PWM2 on P1.0
        SETB PWMCON0.7          ; Start PWM
        RET

; --- Play Mission: Impossible Melody ---
MISSION_MELODY:
        MOV DPTR, #MISSION_TABLE
        MOV R5, #MELODY_LEN

NEXT_NOTE:
        CLR A
        MOVC A, @A+DPTR
        MOV PWMPH, A
        MOV R7, A
        INC DPTR

        CLR A
        MOVC A, @A+DPTR
        MOV PWMPL, A
        MOV R6, A
        INC DPTR

        ; 50% Duty = Period / 2
        CLR C
        MOV A, R7
        RRC A
        MOV PWM2H, A
        MOV A, R6
        RRC A
        MOV PWM2L, A

        SETB PWMCON0.6
        ACALL TONE_DELAY

        DJNZ R5, NEXT_NOTE
        CLR PWMCON0.7
        RET

; --- Tone Delay (~100ms adjustable) ---
TONE_DELAY:
        MOV R2, #14
DL1:    MOV R1, #180
DL2:    MOV R0, #255
DL3:    DJNZ R0, DL3
        DJNZ R1, DL2
        DJNZ R2, DL1
        RET

; --- Note Table (first 12 notes of "Mission: Impossible") ---
; Format: PWMPH, PWMPL (16-bit period)
MISSION_TABLE:
        DB 0x13, 0xEE   ; G4
        DB 0x0F, 0xD2   ; B4
        DB 0x13, 0xEE   ; G4
        DB 0x0F, 0xD2   ; B4
        DB 0x13, 0xEE   ; G4
        DB 0x0E, 0xEE   ; C5
        DB 0x13, 0xEE   ; G4
        DB 0x0F, 0xD2   ; B4
        DB 0x13, 0xEE   ; G4
        DB 0x0F, 0xD2   ; B4
        DB 0x13, 0xEE   ; G4
        DB 0x0E, 0xEE   ; C5

MELODY_LEN EQU 12

END
