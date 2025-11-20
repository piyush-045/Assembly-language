ORG 00H
        LJMP MAIN

;------------------------------------------
; Register definitions
P1M1      EQU 0B3H
P1M2      EQU 0B4H

PWMCON0   EQU 0D8H
PWMCON1   EQU 0DFH
PWMPH     EQU 0D1H
PWMPL     EQU 0D9H
PWM2H     EQU 0D4H
PWM2L     EQU 0DCH
PIOCON0   EQU 0DEH
CKCON     EQU 08EH

;------------------------------------------
MAIN:
        MOV P1M1, #11111110B    ; P1.0 push-pull
        MOV P1M2, #00000001B

        ACALL PWM_CONFIG
        ACALL PWM_START
        ACALL PLAY_TONE

HERE:   SJMP HERE

;------------------------------------------
PWM_CONFIG:
        SETB PWMCON0.4          ; Clear PWM counter
        MOV CKCON, #00H         ; SYSCLK = Fsys
        MOV PWMCON1, #03H       ; Prescaler = 8 (value = 3 ? (3+1)*2)

        MOV PIOCON0, #04H       ; Enable PWM0 CH2 at P1.0
        SETB PWMCON0.6          ; Trigger LOAD to update values
        RET

;------------------------------------------
PWM_START:
        SETB PWMCON0.7          ; Start PWM
        RET

;------------------------------------------
; Play 10 notes by changing frequency
PLAY_TONE:
        MOV DPTR, #NOTE_TABLE
        MOV R3, #10             ; 10 notes

NEXT_NOTE:
        CLR A
        MOVC A, @A+DPTR         ; Load PWMPH
        MOV PWMPH, A
        MOV R4, A               ; Save high byte to R4
        INC DPTR

        CLR A
        MOVC A, @A+DPTR         ; Load PWMPL
        MOV PWMPL, A
        MOV R5, A               ; Save low byte to R5
        INC DPTR

        ; Set 50% Duty Cycle = (PWMPH:PWMPL) / 2 ? R4:R5
        ACALL SET_DUTY_HALF

        ; Delay 100ms tone duration
        ACALL TONE_DELAY

        DJNZ R3, NEXT_NOTE

        CLR PWMCON0.7           ; Stop PWM
        RET

;------------------------------------------
; Set PWM2H:2L = 50% of PWMPH:PL
SET_DUTY_HALF:
        MOV A, R5
        CLR C
        RRC A
        MOV PWM2L, A

        MOV A, R4
        RRC A
        MOV PWM2H, A
        RET

;------------------------------------------
; Delay ~100ms
TONE_DELAY:
        MOV R2, #10
DL1:    MOV R1, #200
DL2:    MOV R0, #255
DL3:    DJNZ R0, DL3
        DJNZ R1, DL2
        DJNZ R2, DL1
        RET

;------------------------------------------
; PWMPH:PWMPL values for 10 musical notes (16-bit)
; Format: High byte, Low byte
NOTE_TABLE:
        DB 0x1D, 0xD1     ; C4 = 7633
        DB 0x1A, 0x93     ; D4 = 6803
        DB 0x17, 0xB5     ; E4 = 6061
        DB 0x16, 0x63     ; F4 = 5731
        DB 0x13, 0xEE     ; G4 = 5102
        DB 0x11, 0xC1     ; A4 = 4545
        DB 0x0F, 0xD2     ; B4 = 4050
        DB 0x0E, 0xEE     ; C5 = 3822
        DB 0x0D, 0x49     ; D5 = 3401
        DB 0x0B, 0xD6     ; E5 = 3030

END
