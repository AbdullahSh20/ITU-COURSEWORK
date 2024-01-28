;Abdullah Jafar Mansour Shamout
;150200919
;HW1-Question2-part b
;power.s
;Description:
;my function looks like y = x ^ a
;X_VAR: value of the base
;A_VAR: value of the power
;R3 will contain the result Y

		AREA input, DATA, READONLY		; Declare new data area to set variables
X_VAR	EQU	2, DATA						; setting base to 2
A_VAR	EQU	4, DATA						; setting power to 4
; so normally I would have 2^4 = 16 which is 10 in hexadecimal

		AREA power_func, CODE, READONLY	; Delaring new code area to write the recursive power_func
		ALIGN 4	                    	; Ensuring 32-bit alignment (4 bytes)

__mainc  PROC							; Enable Debug
		EXPORT __mainc					; Make __main as global to access from startup file
		ENTRY 							; Declare as entry point

		LDR R1, =X_VAR					; set the base value into R1
		LDR R2, =A_VAR					; set the power value into R2
		BL	power						; call the power function. Its like power(x, a) in C

stop	B	stop						; infinite loop to stop the program

;my actual function code
power	PUSH {LR}						; since the function is called recursively, I am pushing my return addresses to the stack as it will be overwritten by the recursive calls
		CMP R2, #0						; checking if we reached the base condition. "Is the power parameter equal to 0", if it is jump to DONE
		BEQ	DONE						; jump to DONE. I check first then subtract as the exponent could be 0.
		SUBS R2, R2, #1					; editing the power parameter to recall recursively
		BL power						; if the power parameter didnt fit our condition, call the function recursively with the new parameter

		MULS R3, R1, R3					; here I do the multiplication between the base "R1" and the value that I get from doing recursion at "R3"
		POP {PC}						; this pop to pc either returns me to the first function call if the recursions are done, or returns me to the multiplication process
		
DONE	MOVS R3, #1						; Here I set the base condition which is like "return 1;" in C
		POP {PC}						; I go back to the function and do as many multiplication as many times as I called the function "recursion of values"
										; If the exponent was 0 at the start then this POP would return me to the first function call thus going to the infinite loop

		ALIGN 4
		ENDP							; Finish function
		END								; Finish assembly file