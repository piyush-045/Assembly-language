ORG 00H
	 
; Step 0: Define addresses
P1M1    EQU 0B3H
P1M2    EQU 0B4H
MOV P1M1, #0FBH    ; P1.2 output mode (push-pull)
MOV P1M2, #04H

PWMCON0 EQU 0D8H
PWMCON1 EQU 0DFH
PWMPH   EQU 0D1H
PWMPL   EQU 0D9H
PWM0L   EQU 0DAH						
PWM0H   EQU 0D2H
PIOCON0 EQU 0DEH
CKCON   EQU 8EH
PWMRUN  EQU 0DFH



ACALL PWM_CONFIG
ACALL PWM_START
HERE: SJMP HERE

;..........PWM SUBROUTINE(FUNCYION).........../

PWM_CONFIG: 
SETB 0D8H.4        ; PWMCON0.4 = CLRPWM = 1 (reset counter)

MOV CKCON, #00H    ; System clock
;MOV PWMCON1,#00H ; 0000 0(000) Prescal devide is 000 = 1/1
MOV PWMCON1,#04H ; 0000 0(100) Prescal devide is 100 = 1/16

/*
System clock = 16 MHz
prescal devide is 000 = 1/1
So PWM CLOCK = 16MHZ/1 =16MHZ
Target Frequency = 10kHz

Period VALUE = PWM CLOCK/target frequncy

But N76E003 PWM is 16-bit, so:

Period register = counts - 1 = 1599 (0x063F)
Period setting:
PWMPH = 06H
PWMPL = 3FH

For 50% Duty:
Duty = 800 (0x0320)
PWM0H = 03H
PWM0L = 20H  */

;MOV PWMPH,  #06H   ; High byte of PWM period (1599) ;10 KHZ FREOUNCY WITH PRESCALER 1
;MOV PWMPL,  #03FH  ; Low byte of PWM period
;MOV PWM0H, #03H    ; High byte of duty cycle (800)
;MOV PWM0L, #020H   ; Low byte of duty cycle

MOV PWMPH,  #00H   ; High byte of PWM period (199) ; 5 KHZ FREOUNCY WITH PRESCALER 16
MOV PWMPL,  #0C7H  ; Low byte of PWM period
MOV PWM0H, #00H    ; High byte of duty cycle (100)
MOV PWM0L, #064H   ; Low byte of duty cycle

; Step 6: Enable PWM0 output pin
MOV PIOCON0, #01H  ; Enable PWM0 at P1.2

; Step 7: Trigger LOAD to update period/duty
SETB 0D8H.6        ; PWMCON0.6 = LOAD = 1

; Wait for LOAD auto-clear (Hardware clears LOAD automatically)
; (OPTIONAL: You can monitor PWMCON0.6 until it becomes 0)
; Step 8: Clear CLRPWM to allow counters to run
CLR 0D8H.4         ; PWMCON0.4 = CLRPWM = 0
RET

PWM_START: 
; Step 9: Start PWM
SETB 0D8H.7        ; PWMCON0.7 = 1 = PWMRUN 
RET

PWM_STOP:
CLR 0D8H.7        ; PWMCON0.7 = 0 = PWMSTOP
RET


END
