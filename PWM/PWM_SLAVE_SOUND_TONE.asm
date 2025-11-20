ORG 00H

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
	
; --- Initialize P1.0 as push-pull output ---
			
MOV P1M1, #00H   ; P1.0 = output
MOV P1M2, #00H   ; P1.0 = push-pull
ORL P1M1, #00000000B   ; P1.0 = output
ORL P1M2, #11111111B   ; P1.0 = push-pull

			
; --- Main Program ---
MAIN:    
            ACALL PWM_CONFIG
            ACALL SA_RE_GA_MA_MELODY   ; Play melody before starting PWM loop

HERE:       SJMP HERE

; --- PWM Configuration ---
PWM_CONFIG:
            SETB PWMCON0.4         ; Clear counter
            MOV CKCON, #00H        ; System clock base config
            MOV PWMCON1, #03H      ; Prescaler = Fsys / 8
            MOV PIOCON0, #04H      ; Enable PWM0 CH2 on P1.0
			SETB PWMCON0.7
            RET

; --- Play Melody ---
SA_RE_GA_MA_MELODY:
            MOV DPTR, #NOTE_TABLE  ; Note period values
            MOV R5, #10            ; 10 notes

NEXT_NOTE:
            CLR A
            MOVC A, @A+DPTR
            MOV PWMPH, A
            MOV R7, PWMPH             ; Store for division
            INC DPTR

            CLR A
            MOVC A, @A+DPTR
            MOV PWMPL, A
            MOV R6, PWMPL              ; Store for division
            INC DPTR

            ; --- 16-bit divide period by 2 for 50% duty ---
            CLR C
            MOV A,R7
            RRC A
            MOV R7,A
            RRC A
            MOV R6,A
            MOV PWM2H, R7
            MOV PWM2L, R6
			
            
            SETB PWMCON0.6          ; Reload PWM period and duty 
            ACALL TONE_DELAY
			DJNZ R5, NEXT_NOTE   ; TONE_DELAY       ; 100ms tone
			CLR PWMCON0.7

            RET

; --- Tone Delay (approx. 100ms) ---
TONE_DELAY:
            MOV R2, #15   ; Adjusted delay for better note distinction
DL1:        MOV R1, #180
DL2:        MOV R0, #255
DL3:        DJNZ R0, DL3
            DJNZ R1, DL2
            DJNZ R2, DL1
            RET

; Format: PWMPH, PWMPL (16-bit period)
NOTE_TABLE:
            DB 0x1D, 0xD1   ; Sa (C4)
            DB 0x1A, 0x93   ; Re (D4)
            DB 0x17, 0xB5   ; Ga (E4)
            DB 0x16, 0x63   ; Ma (F4)
            DB 0x13, 0xEE   ; Pa (G4)
            DB 0x11, 0xC1   ; Dha (A4)
            DB 0x0F, 0xD2   ; Ni (B4)
            DB 0x0E, 0xEE   ; Sa (C5)
            DB 0x0D, 0x49   ; Re (D5)
            DB 0x0B, 0xD6   ; Ga (E5)

END