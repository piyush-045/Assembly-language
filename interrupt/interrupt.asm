ORG 0000H
		LJMP MAIN
		
;ISR FOR TIMER 1 
ORG 001BH
		DJNZ R0,START
		CPL P1.0
		MOV R0,#28
		MOV TL1,#00H
		MOV TH1,#00H
START:	RETI
;MAIN PROGRAM
ORG 0030H
MAIN:
		P1M1 EQU 0B3H       //EQU is like Macro
		P1M2 EQU 0B4H
		MOV P1M1,#0FEH      //Output mode push-pull M1=0 selaction FE=1111 1110 means P1.0 = 0 
		MOV P1M2,#01H       //Output mode push-pull M2=1 selaction FE=0000 0001 means P1.0 = 1
		
		MOV TMOD,10H
		MOV IE,#88H
		MOV R0,#28
		MOV TL1,#00H
		MOV TH1,#00H
		SETB TR1
HERE:	SJMP HERE 

END 
		
	