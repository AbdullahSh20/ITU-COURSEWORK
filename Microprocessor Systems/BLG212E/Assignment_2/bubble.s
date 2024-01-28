;Abdullah Jafar Mansour Shamout
;150200919

				AREA INIT, DATA, READONLY		  ; Declare new data area to set variables
SysTick_CTRL    EQU    	0xE000E010    ; SYST_CSR -> SysTick Control and Status Register
SysTick_RELOAD  EQU    	0xE000E014    ; SYST_RVR -> SysTick Reload Value Register
SysTick_VAL     EQU    	0xE000E018    ; SYST_CVR -> SysTick Current Value Register
RELOAD			EQU		15311		  ; Value of reload if I consider the period as microseconds
START			EQU		0x7			  ; #0111 for setting the systick control
FINISH			EQU		0x4			  ; #0100 for turning off the systick timer and clearing the interrupt enable, I am not changing the clock though
PERIOD			EQU		957			  ; My period given in the excel sheet

ARRAY			DCD		0xa603e9e1,0xb38cf45a,0xf5010841,0x32477961,0x10bc09c5,0x5543db2b,0xd09b0bf1,0x2eef070e,0xe8e0e237,0xd6ad2467,0xc65a478b,0xbd7bbc07,0xa853c4bb,0xfe21ee08,0xa48b2364,0x40c09b9f,0xa67aff4e,0x86342d4a,0xee64e1dc,0x87cdcdcc,0x2b911058,0xb5214bbc,0xff4ecdd7,0x3da3f26,0xc79b2267,0x6a72a73a,0xd0d8533d,0x5a4af4a6,0x5c661e05,0xc80c1ae8,0x2d7e4d5a,0x84367925,0x84712f8b,0x2b823605,0x17691e64,0xea49cba,0x1d4386fb,0xb085bec8,0x4cc0f704,0x76a4eca9,0x83625326,0x95fa4598,0xe82d995e,0xc5fb78cb,0xaf63720d,0xeb827b5,0xcc11686d,0x18db54ac,0x8fe9488c,0xe35cf1,0xd80ec07d,0xbdfcce51,0x9ef8ef5c,0x3a1382b2,0xe1480a2a,0xfe3aae2b,0x2ef7727c,0xda0121e1,0x4b610a78,0xd30f49c5,0x1a3c2c63,0x984990bc,0xdb17118a,0x7dae238f,0x77aa1c96,0xb7247800,0xb117475f,0xe6b2e711,0x1fffc297,0x144b449f,0x6f08b591,0x4e614a80,0x204dd082,0x163a93e0,0xeb8b565a,0x5326831,0xf0f94119,0xeb6e5842,0xd9c3b040,0x9a14c068,0x38ccce54,0x33e24bae,0xc424c12b,0x5d9b21ad,0x355fb674,0xb224f668,0x296b3f6b,0x59805a5f,0x8568723b,0xb9f49f9d,0xf6831262,0x78728bab,0x10f12673,0x984e7bee,0x214f59a2,0xfb088de7,0x8b641c20,0x72a0a379,0x225fe86a,0xd98a49f3

				AREA CALCULATIONS, DATA, READWRITE
SORTED_ARRAY	SPACE	400			  ; 4-Bytes per value in array * 100 values = 400bytes
ELAPSED_TIMES	SPACE	400			  ; 4-Bytes per value in array * 100 values = 400bytes
SIZE			EQU		400			  ; 100 values per array each being 4 bytes

				AREA bubble, CODE, READONLY		; Delaring new code area to write the recursive power_func
				ALIGN 4	                    	; Ensuring 32-bit alignment (4 bytes)
				
__main			PROC							; Enable Debug
				EXPORT __main					; Make __main as global to access from startup file
				ENTRY 							; Declare as entry point
				
				BL Init_SysTick_Timer			; Calling the initialization function
				MOVS R7, #8						; Outer loop starting from 8, because it starts from 2 as an integer, but it takes 4 memory spaces so its 2*4 = 8
				
For_loop		LDR  R6, =SIZE					; Condition on when to finish the outer loop
				CMP	 R7,R6						; checking the for loop condition
				BGT	 DONE						; if we exceed the condition, then we are done and go to stopping the systick timer
				
				BL	 Save_Start_Time			; save the start time
				push {R7, R6}					; pushing the argument 'i' to the bubble sort function like its a parameter, also R7 will change there
				BL	 BubbleSort					; run the bubble sort algorithm for 'i' elements
				POP {R7, R6}					; popping back the value of R7
				BL	 Save_Execution_Time		; save the execution time for that run
				ADDS R7, R7, #4					; incrementing i by 1 which is 4 bytes
				B	 For_loop					; branching back to the for loop
				
DONE			BL Stop_SysTick_timer			; Calling the stoping of the systick timer function		

				LDR R0, =SORTED_ARRAY			; setting R0 to the sorted array position as requested in the question sheet
				LDR	R1, =ELAPSED_TIMES			; setting R1 to the times elapsed array position as requested in the question sheet
				
loop			B		loop					; infinite loop at the end while(1)

				ENDP							; Finish main function
					
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MY SUBROUTINES/FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Init_SysTick_Timer	PROC						; function for setting up the timer, it only uses R0-R3 so no need for pushing and popping from the stack according to ABI standards
				EXPORT Init_SysTick_Timer		; exporting the funciton
				LDR 	R0, =SysTick_CTRL		; loading the value of SysTick_CTRL
				LDR		R1, =SysTick_RELOAD		; loading the value of SysTick_RELOAD
				LDR		R2, =RELOAD				; loading the value of RELOAD
				LDR		R3, =START				; loading the value of START
				STR		R2, [R1]				; set the reload value
				STR		R3,	[R0]				; set the timer control
                BX      LR						; returning from function
				ENDP							; ending the function
					
Stop_SysTick_timer	PROC						; function for stopping the systick timer
				EXPORT Stop_SysTick_timer		; exporting the function
				LDR 	R0, =SysTick_CTRL		; loading the value of SysTick_CTRL
				LDR		R1, =FINISH				; loading the value of FINISH
				STR		R1, [R0]				; turning off the counter, and the interrupt, I am not changing the CLKSOURCE though
				BX		LR						; returning from function
				ENDP							; ending the function
									

Save_Start_Time	PROC							; function to save start time
				EXPORT Save_Start_Time			; exporting the function
				LDR		R0, =SysTick_VAL		; loading the value of SysTick_VAL
				LDR 	R5,	[R0]				; loading the current value of the timer
				MOV     R8, R5					; becasue I will use R5 later on, I am saving it in R8
                BX      LR						; returning from function
				ENDP							; ending the function
					
Save_Execution_Time PROC						; function for saving the execution time, it shouldnt call to save_Exectuion_Time per the C code given, but as discussed in the report it shows anomolies then
				EXPORT Save_Execution_Time		; exporting the function
				push 	{LR}					; pushing LR since I will branch to timer stoping and 
				BL		Stop_SysTick_timer		; stopping the timer for calculation, eventhough it was not specified in the psuedo C code given in the question, it is needed as it introduces irregularities
				LDR		R0, =SysTick_VAL		; getting address of time at the end
				LDR		R1, [R0]				; loading the value of the end time to R1
				MOV		R5, R8					; moving R8 back to R5 to use it
				CMP		R1, R5					; doing a comparision to see which way to subtract, since the sorting can start at a different time due to the shift by cutting the sort per subarray
				BGE		NORMAL					; doing a normal subtraction
				SUBS	R3, R5, R1				; subtracting the start value from the finish value
				B		CALC					; branching to CALC where I calculate the time. The period is already in microseconds, and I calculate the fractional time from the period that I am in currently in by shifting by 4 which is like dividing my reload by the CPU frequency
NORMAL			SUBS	R3, R1, R5				; subtracting finishing time from start time
CALC			LSRS	R3, R3, #4				; shifting by 4 logically because the values are unsigned and my cpu frequency is 16 which is like shifting by 4
				LDR		R6, =PERIOD				; loading my period to calculate the time according to how many interrupts I had
				MULS	R4, R6, R4				; getting the time as microseconds
				ADDS	R4, R3, R4				; final time taken is at R4
				SUBS	R7, R7, #8				; because we are starting from 8 I need to go back to 0 offset to start saving in memory
				LDR		R2, =ELAPSED_TIMES		; getting the elapsed times array position
				STR		R4,[R2,R7]				; storing the time there
				ADDS	R7,R7, #8				; fixing the value of R7 to what it was
				MOVS	R4, #0					; moving 0 to R4 to reset it for next count
				BL		Init_SysTick_Timer		; calling back the initialization since I stopped it but it can be removed
                ;BX      LR						; returning from function can be used if we remove the push LR and branches to timer functions
				POP		{PC}					; returning from function
				ENDP
					
COPY			PROC							; Copy array function
				EXPORT COPY						; exporting the function
				MOVS R0, #0						; starting the copying from the 0th index
				LDR R1, =ARRAY					; getting the first address for the array
				LDR R2, =SORTED_ARRAY			; getting the first address for the array that will be sorted
COPYING			CMP R0, R7						; comparing for the condition of how many elements we need to copy
				BGE STOP						; if we pass the condition, we should stop
				LDR R3, [R1, R0]				; if we didnt pass the condition, we should load the value at index i which is at R0 to R3
				STR R3, [R2, R0]				; save the value from R3 to the array to be sorted with offset i
				ADDS R0, R0, #4					; offset is added with 4 bytes which is an increment by 1
				B COPYING						; branching back to copying
STOP			BX		LR						; going out of the function
				ENDP							; ending the function
					
BubbleSort		PROC							; bubble sort function
				EXPORT BubbleSort				; exporting the bubble sort function
				PUSH{LR}						; pushing LR because I will branch to copy as a part of bubbleSort
				BL	COPY						; if we arent done we go to copy the subarray that we need
				MOVS R0, #0						; index of outer loop
Loop1			CMP	R0, R7						; condition checking for outer loop, R7 is taken from main function
				BGE	End_Sort					; if the condition fails we finished
				
				MOVS R1, #0						; second index for the second loop
				SUBS R7, R7, #4					; decrementing by 4 since we want size - 1
				
Loop2			CMP	R1, R7						; second comparision
				BGE End_Loop1					; if it fails we finished this loop
				
				LDR	R2, =SORTED_ARRAY			; getting the address of the array we want to sort to
				
				LDR R3, [R2, R1]				; loading it into R3 with offset R1
				ADDS R1, R1, #4					; incrementing the offset
				LDR R5, [R2, R1]				; getting the value after
				SUBS R1, R1, #4					; decrementing the offset not to mess it up
				
				CMP	R3, R5						; comparing the values fetched
				BHI Swap						; branching if higher unsigned
				B	NoSwap						; else branch to no swap
				
Swap			STR	R5, [R2, R1]				; swapping the values by saving them in the new array
				ADDS R1, R1, #4					; incrementing the offset to store the next value
				STR R3, [R2, R1]				; storing R3 with the new offset
				SUBS R1, R1, #4					; setting R1 back to its originall value
				
NoSwap			ADDS R1, R1, #4					; incrementing R1
				B Loop2							; going back to the loop
				
End_Loop1		ADDS R7, R7, #4					; incrementing R7 back to what it was
				ADDS R0, R0, #4					; incrementing the index
				B Loop1							; branching back to loop1
				
End_Sort		POP{PC}							; returning from function
				ENDP
					
				ALIGN 4							; Ensuring 32-bit alignment (4 bytes)
				END								; Finish assembly file