ORG 0000H
	
		SFRS EQU 091H
		ADCCON0 EQU 0E8H
		ADCCON1	EQU 0E1H
		AINDIDS1 EQU 099H
		ADCF EQU 0EFH
		ADCS EQU 0EEH
		ADCRH EQU 0C3H
		ADCRL EQU 0C2H
		ADCEN EQU 0E1H		
		MOV SFRS,#02H						;Port 2 P2M1,P2M2 MODE SELACTION REGISTERS ON PAGE 2
		MOV 089H,#11111111B                 ;P2.3 input mode for adc CH.11,P2.4 input mode adc CH.12
		MOV 08AH,#00000000B                     
		MOV SFRS,#0H

MAIN:
		ACALL ADC
HERE:	SJMP HERE



ADC:                               ;ADC2 CH.11 
		LCALL ADC_SETUP                 ;P23
		//LCALL DELAY_100US
		CLR ADCF               	            
		SETB ADCS              	            
LABEL1: JNB ADCF,LABEL1        	    
		MOV A,ADCRH                        ;
		SWAP A
		MOV R4,A
		ANL A,#0FH
		MOV R6,A
		MOV A,R4
		ANL A,#0F0H
		MOV R7,ADCRL
		ORL A,R7
		MOV R7,A
        RET                       

ADC_SETUP:
		ANL ADCCON0,#11110011B              ;OFF CH.12
		ORL ADCCON0,#00001011B              ;SET CH.11  Pin 2.3
		CLR EA
		MOV SFRS,#02H
		MOV AINDIDS1,#0H
		ORL AINDIDS1,#08H
		MOV SFRS,#0H
		SETB EA
		ORL ADCCON1,#01H                 
		RET	

		
END