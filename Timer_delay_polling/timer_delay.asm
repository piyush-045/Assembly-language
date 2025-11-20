ORG 00H
		P1M1 EQU 0B3H
		P1M2 EQU 0B4H
		MOV P1M1,#00H
	    MOV P1M2,#0FFH
		
HERE:   CPL P1.0         ;TOGGEL LED/TOGGEL PIN FOR SQURE PULSES/PULSES
		ACALL DELAY     
		SJMP HERE
	
;DELAY USING TIMER SUBROUINE (FUNCTION)

/* 16 MHZ/12 = 1.3333 MHZ ...1/1.3333 MHZ = 0.75 us
   delay in ms (upto ~49.151 ms) as 16 bit timer 
   can have max value 65356 & 65536*0.75 =  49.151 ms
   
   HERE FOR 10 ms delay 10 ms/0.75 us = 13333 Timer value = 3415H (hex)
   For up counter FFFF- 3415 + 1 = CBEB
   SO TL0 = EB 
      TH0 = CB   
*/
DELAY:  MOV TMOD,#01      ;TIMER 0 ,MODE 1(16 BIT TIMER)
		MOV TL0,#0EBH    
		MOV TH0,#0CBH
		SETB TR0
AGAIN:	JNB TF0,AGAIN
		CLR TR0
		CLR TF0
		RET	
END
