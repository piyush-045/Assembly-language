; ========== External Interrupt ==========

ORG 0000H       ; Reset vector
LJMP MAIN       ; Jump to main program

ORG 0003H       ; External Interrupt 0 Vector (INT0)
LJMP INT0_ISR   ; Jump to the INT0 Interrupt Service Routine

; ---- Other interrupt vectors are not used, so no need to define

ORG 0030H       ; Main program starts from here
MAIN:

	P1M1 EQU 0B3H       //EQU is like Macro
	P1M2 EQU 0B4H
	MOV P1M1,#0FEH      //Output mode push-pull M1=0 selaction FE=1111 1110 means P1.0 = 0 
	MOV P1M2,#01H       //Output mode push-pull M2=1 selaction FE=0000 0001 means P1.0 = 1
    ; Initialize ports
    

    ; Interrupt Configuration
    SETB EX0          ; Enable External Interrupt 0
    SETB EA           ; Enable global interrupts
	CLR P1.0
    ; Configure INT0 for edge-triggered
    SETB IT0           ; CLR IT0 (IT0=0)   Level triggered (FALLING)
                      ; SETB IT0 (IT0=1)   EDGE triggered (FALLING)

MAIN_LOOP:
    SJMP MAIN_LOOP    ; Infinite loop

; ----- INT0 Interrupt Service Routine -----
INT0_ISR:
    CPL P1.0          ; Toggle LED on P1.0
    RETI              ; Return from interrupt

; ===========================================
END
