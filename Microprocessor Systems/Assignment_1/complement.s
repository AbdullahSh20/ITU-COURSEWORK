;Abdullah Jafar Mansour Shamout
;150200919
;HW1-Question2-part a
;complement.s
;Description:
;X_VAR: place the value wanted in it to calculate its 1's complement
;I load that value into R6
;I find the complement of that value and save it in R7
;R7 contains the 1's complement at the end of the code
		
		AREA input, DATA, READONLY			; Declaring an area where I set variable X to the value that I want to find its 1's complement
X_VAR	EQU	0xFF00F0A5, DATA
	

		AREA complement, CODE, READONLY		; Declaring area of code where I write the complement function
		ALIGN 4	                    		; Ensuring 32-bit alignment (4 bytes)
			
__maine  PROC                    	 		; Enable Debug
		EXPORT __maine               		; Making __main global, to access it from the startup file
		ENTRY                       		; Declaring an entry point to the code
			
		LDR R6, =X_VAR         				; Load the 32-bit constant value of the variable X into R6
		MVNS R7, R6                 		; Move the one's complement value of R6 into R7
		
STOP	B	STOP							; Infinite loop to stop the code at the end
		
		ALIGN 4	                    		; Ensuring 32-bit alignment (4 bytes)
		ENDP	                    		; Finishing function
		END                         		; Finishing assembly file
