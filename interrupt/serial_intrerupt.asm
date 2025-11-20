; ======== UART (Serial) Interrupt Assembly Example =========

ORG 0000H
LJMP MAIN           ; Reset vector ? Main program

ORG 0023H           ; UART Interrupt Vector (Serial Interrupt)
LJMP SERIAL_ISR     ; Jump to UART ISR

ORG 0030H           ; Main program
MAIN:

    ; -------- Initialize UART ------------
    MOV TMOD, #20H      ; Timer1 Mode2 (8-bit auto-reload) for baud rate
    MOV TH1, #0D4H      ; Baud rate 9600 (for 16 MHz crystal)
    MOV TL1, #0D4H      ; Load timer values
    SETB TR1            ; Start Timer1

    MOV SCON, #50H      ; Serial Mode 1 (8-bit UART), REN=1 (Receiver Enable)
                        ; SM0=0, SM1=1, REN=1
    SETB ES             ; Enable Serial Interrupt
    SETB EA             ; Enable global interrupts

    MOV P1, #00H        ; Clear Port 1 (LEDs OFF)

MAIN_LOOP:
    SJMP MAIN_LOOP      ; Infinite loop

; -------- UART Serial Interrupt Service Routine --------

/*THIS IS LIKE IF.....ELSE CONDITION .....
HERE IT WILL FIRST CHECK IF RI FLAG IS GENERATED OR NOT   
ELSE..IT WILL CHECK TI FLAG   */

SERIAL_ISR:
    JNB RI, CHECK_TI    ; Check if RI is set (Receive Interrupt)

    ; --- Data Received ---
    CLR RI              ; Clear Receive Interrupt flag
    MOV A, SBUF         ; Move received data into Accumulator
    MOV P1, A           ; Output received byte to Port 1 (LEDs)

    SJMP EXIT_ISR

CHECK_TI:
    JNB TI, EXIT_ISR    ; Check if TI is set (Transmit complete)
    
    ; --- Transmission completed ---
    CLR TI              ; Clear Transmit Interrupt flag
    ; You can add code to send next byte if needed.

EXIT_ISR:
    RETI                ; Return from Interrupt

END
