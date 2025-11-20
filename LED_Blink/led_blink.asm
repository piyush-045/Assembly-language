ORG 00H
	
		LED BIT P1.0
		P1M1 EQU 0B3H       //EQU is like Macro
		P1M2 EQU 0B4H
		MOV P1M1,#0FEH      //Output mode push-pull M1=0 selaction FE=1111 1110 means P1.0 = 0 
		MOV P1M2,#01H       //Output mode push-pull M2=1 selaction FE=0000 0001 means P1.0 = 1
	
	/*or else
	MOV 0B3H,#0FEH 
	MOV 0B4H,#01H */
	
WHILE:	SETB LED           //Set bit
		ACALL DELAY
	  //CLR LED          //Clear bit
	 // OR
    	CPL LED            //Complement (toggel) status
    	ACALL DELAY
    	SJMP WHILE
	
;DELAY SUBROUTINE

DELAY:  MOV R7,#100
D1:		MOV R6,#156
D2:		MOV R5,#255
D3: 	DJNZ R5,D3
		DJNZ R6,D2
		DJNZ R7,D1
		RET
END
	
	