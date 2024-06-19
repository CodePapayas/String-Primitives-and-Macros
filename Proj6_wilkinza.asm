TITLE String Primitives and MACROS     (Proj6_wilkinza.asm)

; Author: Zachary Wilkins-Olson
; Last Modified: 03.18.2024
; OSU email address: wilkinza@oregonstate.com
; Course number/section:   CS271 Section 400
; Project Number:  6               Due Date: 3.17.2024
; Description: A program that takes 10 signed integers and converts them from ASCII to integers stored in an array using readVal. 
;			  It then returns the integers converted back to ASCII as list, sum, and truncated average. It then says goodbye.

INCLUDE Irvine32.inc

BUFFER	  EQU	    12
ARRAYSIZE EQU		10
LO		  EQU		-2147483648
HI		  EQU		2147483647

mDisplayString MACRO given_string

;-----------------------------------
;                                  
; mDisplayString MACRO given_string
;                                  
; Displays a given string          
;                                  
; Parameters:                      
;   - given_string: The string to  
;                   be displayed   
;                                  
; Registers affected:              
;   - EDX: Used to hold the address
;          of the string           
;                                  
; Procedure calls:                 
;   - WriteString                  
;                                    
;                                  
;-----------------------------------

	PUSH			EDX
	MOV				EDX, given_string
	CALL			WriteString
	POP				EDX
ENDM

mGetString	   MACRO given_prompt, input_buffer, buffer_size, count

;-----------------------------------
;                                  
; mGetString MACRO given_prompt,   
;                   input_buffer,  
;                   buffer_size,   
;                   count          
;                                  
; Prompts the user for input and   
; reads a string from the console  
;                                  
; Parameters:                      
;   - given_prompt: The prompt     
;                   string         
;   - input_buffer: The buffer to  
;                   store the input
;   - buffer_size: The size of the 
;                  input buffer    
;   - count: The variable to store 
;            the number of         
;            characters read       
;                                  
; Registers affected:              
;   - EDX: Used to hold the address
;          of the prompt string and
;          input buffer            
;   - ECX: Used to hold the buffer 
;          size                    
;   - EAX: Used to store the number
;          of characters read      
;                                  
; Procedure calls:                 
;   - WriteString                  
;   - ReadString                   
;                                  
;-----------------------------------

	MOV				EDX, given_prompt
	CALL			WriteString
	MOV				EDX, input_buffer
	MOV				ECX, buffer_size
	CALL			ReadString
	MOV				count, EAX
ENDM


.data
	intro1			BYTE	"Welcome to String Primitives and Macros!               Author: Zachary Wilkins-Olson", 0
	intro2			BYTE	"Please enter ten (10) integers. They can be signed or unsigned, but they must fit in a 32bit reg!", 0
	prompt1			BYTE	"Your numbers, please:  ", 0
	invalid			BYTE	"Sorry, but this entry is invalid. Please try again.", 0
	display_str		BYTE	"You entered the following numbers: ", 0
	sum_string		BYTE	"This is the sum of your entered numbers: ", 0
	avg_string		BYTE	"And this is your average: ", 0
	farewell		BYTE	"It's been a journey! Bye!", 0
	space_comma		BYTE	", ", 0
	input_length	SDWORD	?
	user_array		SDWORD  BUFFER DUP(?)
	new_user_arr	BYTE	BUFFER DUP(?)
	output_string	BYTE	BUFFER DUP(?)
	input_buffer	BYTE	BUFFER DUP(?)

	

.code


main PROC

;-----------------------------------
;                                  
; main PROC                        
;                                  
; The main procedure of the program
;                                  
; Description:                     
;   - Calls the introduction       
;     procedure to display the     
;     intro strings                
;   - Prompts the user to enter    
;     integers and stores them in  
;     an array using the readVal   
;     procedure                    
;   - Displays the entered integers
;     using the writeVal procedure 
;   - Calculates and displays the  
;     sum of the integers          
;   - Calculates and displays the  
;     average of the integers      
;   - Displays a farewell message  
;   - Exits the program            
;                                  
; Registers used:                  
;   - ECX: Loop counter            
;   - ESI: Array pointer           
;   - EAX: Accumulator for sum and 
;          average calculation     
;   - EDX: Pointer to output string
;                                  
; Memory usage:                    
;   - user_array: Array to store   
;                 the user input   
;   - output_string: Buffer for    
;                    storing the   
;                    converted     
;                    integer string
;                                  
; Procedure calls:                 
;   - introduction                 
;   - readVal                      
;   - writeVal                     
;   - CrLf                         
;   - ExitProcess                  
;                                  
;-----------------------------------

	PUSH			OFFSET intro1
	PUSH			OFFSET intro2
	CALL			introduction
	MOV				ECX, ARRAYSIZE
	MOV				ESI, OFFSET user_array
	PUSH			ESI
	; Collect input from the user
_inputLoop:
	CMP				ECX, 0
	JE				_loopEnd
	PUSH			ESI
	PUSH			OFFSET invalid
	PUSH			OFFSET input_length
    PUSH			OFFSET input_buffer
    PUSH			OFFSET prompt1
    CALL			readVal
	ADD				ESI, 4
	LOOP			_inputLoop
_loopEnd:
	POP				ESI
	MOV				ECX, ARRAYSIZE
	CALL			CrLf
	mDisplayString	OFFSET display_str
	CALL			CrLf
	; Display the integers the user entered, including unary symbol if needed
_displayLoop:
	CMP				ECX, 0
	JE				_endDisplayLoop
	PUSH			DWORD PTR [ESI]
	PUSH			OFFSET output_string
	CALL			writeVal
	ADD				ESI, 4
	LOOP			_displayLoop
_endDisplayLoop:
	MOV				ECX, ARRAYSIZE
	MOV				ESI, OFFSET user_array
	XOR				EAX, EAX
	CALL			CrLf
	mDisplayString	OFFSET sum_string
	; Display sum of the users input
_displaySumLoop:
	ADD				EAX, [ESI]
	ADD				ESI, 4
	LOOP			_displaySumLoop
	PUSH			EAX
	LEA				EDX, output_string
	PUSH			EDX
	CALL			writeVal
	MOV				ECX, ARRAYSIZE
	MOV				ESI, OFFSET user_array
	XOR				EAX, EAX
	CALL			CrLf
	mDisplayString	OFFSET avg_string
	; Display average of the users input
_displayAvgLoop:
	ADD				EAX, [ESI]
	ADD				ESI, 4
	LOOP			_displayAvgLoop
	XOR				EDX, EDX
	MOV				ECX, ARRAYSIZE
	IDIV			ECX
	PUSH			EAX
	LEA				EDX, output_string
	PUSH			EDX
	CALL			writeVal
	CALL			CrLf
	CALL			CrLf
	; Say goodbye
	mDisplayString	OFFSET farewell
	CALL			CrLf
	CALL			CrLf
		Invoke ExitProcess,0		
main ENDP

introduction PROC

;-----------------------------------
;                                  
; introduction PROC                
;                                  
; Displays two strings passed as   
; parameters.                      
;                                  
; Receives:                        
;   - [EBP+8] : First string       
;   - [EBP+12]: Second string      
;                                  
; Returns: None                    
;                                  
; Registers used:                  
;   - EDX                          
;                                  
; Description:                     
;   Displays the second string     
;   followed by the first string,  
;   each on a new line.            
;                                         
;                                  
;-----------------------------------

	PUSH			EBP
	MOV				EBP, ESP
	PUSH			EDX
	MOV				EDX, [EBP+12]
	mDisplayString	EDX
	CALL			CrLf
	MOV				EDX, [EBP+8]
	mDisplayString	EDX
	CALL			CrLf
	POP				EDX
	POP				EBP
	RET				8
introduction ENDP

readVal PROC

;---------------------------------------
;                                      
; readVal PROC                         
;                                      
; Reads a string of digits and         
; converts it to a signed integer.     
;                                      
; Receives:                            
;   - [EBP+8]  : Prompt string         
;   - [EBP+12] : Input buffer          
;   - [EBP+16] : Buffer size           
;   - [EBP+20] : Error message         
;   - [EBP+24] : Output integer        
;                                      
; Returns: None                        
;                                      
; Registers used:                      
;   - EAX, EBX, ECX, EDX, EDI, ESI     
;                                      
; Description:                         
;   Prompts the user to enter a string 
;   of digits. Validates and converts  
;   the input to a signed integer.     
;   Handles positive and negative      
;   numbers, overflow, and invalid     
;   input. Stores the converted value  
;   in the output integer location.    
;                                        
;                                      
;---------------------------------------

    PUSH            EBP
    MOV             EBP, ESP
	PUSH			EAX
	PUSH			EBX
	PUSH			ECX
	PUSH			EDX
	PUSH			EDI
	PUSH			ESI
	mGetString		[EBP+8], [EBP+12], BUFFER, [EBP+16]
	; Prepare EBX for accumulation and prepare ECX and ESI as the counter and storage, respectively
_startingLoop:
	XOR				EBX, EBX
	MOV				ECX, [EBP+16]
	MOV				ESI, [EBP+12]
_validateNext:
	XOR				EAX, EAX
	LODSB
_validateSign:
	CMP				AL, 43
	JE				_positiveSymbol
	CMP				AL, 45
	JE				_negativeSymbol
_positiveSymbol:
	CMP				AL, 43
	JNE				_noSignPos
	XOR				EAX, EAX
	DEC				ECX
	LODSB
_noSignPos:
	CMP				AL, 48
	JB				_errorLoop
	CMP				AL, 57
	JA				_errorLoop
	SUB				AL, 48
	PUSH			EAX
	MOV				EAX, EBX
	MOV				EDX, 10
	MUL				EDX
	JO				_overflowError
	MOV				EBX, EAX
	POP				EAX
	MOVZX			EDX, AL
	ADD				EBX, EDX
	JMP				_nextPositiveInt
	_nextPositiveInt:
		LODSB
		LOOP			_positiveSymbol
		JMP				_storeConvertedNumber
_negativeSymbol:
	CMP				AL, 45
	JNE				_noSignNeg
	XOR				EAX, EAX
	DEC				ECX
	LODSB
	_noSignNeg:
	CMP				AL, 47
	JL				_errorLoop
	CMP				AL, 57
	JG				_errorLoop
	SUB				AL, 48
	PUSH			EAX
	MOV				EAX, EBX
	MOV				EDX, 10
	IMUL			EDX
	JO				_overflowError
	MOV				EBX, EAX
	POP				EAX
	MOVZX			EDX, AL
	ADD				EBX, EDX
	JO				_errorLoop
	CMP				ECX, 0
	JE				_lastNegativeInt
	_nextNegativeInt:
		LODSB
		_lastNegativeInt:
		LOOP			_negativeSymbol
		CMP				EBX, LO
		JA				_errorLoop
		NEG				EBX
		MOV				EDX, 1
		JMP				_finalSave
_storeConvertedNumber:
	CMP				EBX, LO
	JA				_errorLoop
	CMP				EDX, 0
	JGE				_positiveSymbolTest
	JMP				_finalSave
_positiveSymbolTest:
	CMP				EBX, HI
	JA				_errorLoop
_finalSave:
    MOV     EAX, EBX
    MOV     EDI, [EBP+24]
	STOSD
	CALL			CrLf
	JMP				_finishAndReturn
_overFlowError:
	POP				EAX
_errorLoop:
	MOV				EDX, [EBP+20]
	mDisplayString	EDX
	CALL			CrLf
	mGetString		[EBP+8], [EBP+12], BUFFER, [EBP+16]
	CALL			CrLf
	JMP				_startingLoop
_finishAndReturn:
	POP				ESI
	POP				EDI
	POP				EDX
	POP				ECX
	POP				EBX
	POP				EAX
	MOV				ESP, EBP
	POP				EBP
	RET				20

readVal ENDP

writeVal PROC

;---------------------------------------
;                                      
; writeVal PROC                        
;                                      
; Converts a signed 32-bit integer to  
; a string and displays it.            
;                                      
; Receives:                            
;   - [EBP+8] : Pointer to buffer      
;   - [EBP+12]: Signed 32-bit integer  
;                                      
; Returns: None                        
;                                      
; Registers used:                      
;   - EAX, EBX, ECX, EDX, EDI          
;                                      
; Description:                         
;   Converts the signed integer to a   
;   string of digits, handling both    
;   positive and negative numbers.     
;   Displays the converted string.     
;                                              
;                                      
;---------------------------------------

	PUSH			EBP
	MOV				EBP, ESP
	PUSH			EAX
	PUSH			EBX
	PUSH			ECX
	PUSH			EDX
	PUSH			EDI
	MOV				EAX, [EBP+12]
	MOV				EDI, [EBP+8]
	CMP				EAX, 0
	JGE				_outerConversionLoop
	NEG				EAX
	PUSH			EAX
	MOV				AL, 45
	STOSB
	POP				EAX
	; Set ECX to 0 for int count, begin converting to ASCII
_outerConversionLoop:
	MOV				ECX, 0
	_innerConversionLoop:
		INC				ECX
		MOV				EDX, 0
		MOV				EBX, 10
		DIV				EBX
		ADD				EDX, 48
		PUSH			EDX
		CMP				EAX, 0
		JNE				_innerConversionLoop
	; POP each value off the stack and print it
_storeConvertedValue:
	POP				EAX
	STOSB
	LOOP			_storeConvertedValue
	MOV				AL, 0
	STOSB
	MOV				EDX, [EBP+8]
	mDisplayString	EDX
	CALL			CrLf
	POP				EDI
	POP				EDX
	POP				ECX
	POP				EBX
	POP				EAX
	MOV				ESP, EBP
	POP				EBP
	RET				8
writeVal ENDP


END main
