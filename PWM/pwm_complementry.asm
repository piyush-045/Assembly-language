ORG 0000H
	
	
P1M1    EQU 0B3H
P1M2    EQU 0B4H
MOV P1M1, #00000000B
MOV P1M2, #11111111B


 //----PWM SETUP----//  
	
	PWM0CON0 EQU 0D8H  ;
	PWM0CON1 EQU 0DFH  ;
	PWM0PH EQU 0D1H    ;PWM0 PERIOD HIGH BYTE
	PWM0PL EQU 0D9H    ;PWM0 PERIOD LOW BYTE
	PWM0C0H EQU 0D2H   ;PWM0 CH0 DUTY HIGH 
	PWM0C0L EQU 0DAH 	;PWM0 CH0 DUTY LOW
	PWM0C1H EQU 0D3H   ;PWM0 CH1 DUTY HIGH 
	PWM0C1L EQU 0DBH   ;;PWM0 CH1 DUTY LOW 
		
	PIOCON0 EQU 0DEH
	
	TA EQU 0C7H
	CKCON EQU 08EH
	PWM0DTEN EQU 0F9H   ;
	PWM0DTCNT EQU 0FAH  ;
		
;	AUXR4 EQU 0A3H	
;	PWM2CON0 EQU 0C4H	
;    PWM2PH EQU 0B9H
;	PWM2PL EQU 0C1H
;	PWM2C0H EQU 0BAH
;	PWM2C0L EQU 0C2H

;	PWM3PH EQU 0C9H  
;	PWM3PL EQU 0D1H
;	PWM3C0H EQU 0CAH
;	PWM3C0L EQU 0D2H
;	AUXR5 EQU 0A4H
;	PIOCON2 EQU 0B7H  
;	PWM3CON0 EQU 0D4H	



ACALL PWM_CONFIG
ACALL PWM_START
HERE: SJMP HERE

;..........PWM SUBROUTINE(FUNCYION).........../

PWM_CONFIG: 
SETB PWM0CON0.4        ; 

MOV CKCON, #00H    ;
MOV PWM0CON1,#040H ; 0000 0(000) Prescal devide is 000 = 1/1 ANS ALSO COMPLEMENTRY PWM ENABLE

/*
System clock = 16 MHz
prescal devide is 000 = 1/1
So PWM CLOCK = 16MHZ/1 =16MHZ
Target Frequency = 10kHz

Period VALUE = PWM CLOCK/target frequncy*/

MOV PWM0PH,  #06H   ; High byte of PWM period (1599) ;10 KHZ FREOUNCY WITH PRESCALER 1
MOV PWM0PL,  #03FH  ; Low byte of PWM period

MOV	PWM0C0H, #03H   ;PWM0 CH0 DUTY HIGH   50% DUTY CYCLE 800
MOV	PWM0C0L ,#020H 	;PWM0 CH0 DUTY LOW
/*PWM0 CH0 AND PWM0 CH1 are the complementry chanales pairs
so only pwm0 ch0 needs config duty it will automatcaly generate complentry pwm on pwm0 ch1 ..no need to to config pwm0 ch1  */
		

; Step 6: Enable PWM0 output pin
MOV PIOCON0, #03H  ; Enable PWM0 at P1.2 ,P1.1 FOR COMPLEMENTRY
MOV TA,#0AAH
MOV TA,#055H
MOV PWM0DTEN, #01H 
MOV TA,#0AAH
MOV TA,#055H
MOV PWM0DTCNT, #010H     
                                 
RET

PWM_START: 
SETB PWM0CON0.6        ; PWM0CON0.6 = LOAD = 1
SETB PWM0CON0.7        ; PWM0CON0.7 = 1 = PWMRUN 
RET



END

/* Dead-Time Calculation
Dead-time = (PWM0DTCNT + 1) / Fsys

For example:

PWM0DTCNT = 0x10

Fsys = 16 MHz

Then:

Dead-time = (16 + 1) / 16 MHz = ~1.0625 µs   */
