TITLE try					(try.asm)

; Description:
; CHIAM YOONG JIEN A15CS0016 SCSR
; Revision date:

INCLUDE Irvine32.inc
.data
	t_space byte 35 DUP(' '), 0
	tajuk byte 'Array Processor', 0
	Greets byte 'Enter the number of elements in the array (between 8 and 15) :  ', 0
	prompt BYTE 'Array Element ', 0
	space BYTE ': ', 0
	waiting byte 'Array processing in progress бн 5 seconds', 0
	Results  byte  "The results:"  , 0
	lowest BYTE 'The smallest value in the array: ', 0
	biggest BYTE 'The largest value in the array: ', 0
	sum BYTE 'Total sum of array: ', 0
	sumneg BYTE 'The sum of negative numbers: ', 0
	sumpos BYTE 'The sum of positive numbers: ',0
	arrayInput SDWORD 15 DUP(?)
	inputSize DWORD ?
	negative SDWORD 0
	positive SDWORD 0
	e_lowest SDWORD ?
	e_biggest SDWORD ?
	
	
.code
main PROC
	
	call header
	call userInput
	call lineDelay
	call findMinMax
	call sumPosNeg
	exit
main ENDP

;-----------------------------------------------------------------
header PROC
;------------------------------------------------------------------
	mov edx, OFFSET t_space
	call WriteString
	mov edx, OFFSET tajuk
	call WriteString
	call CRLF
	call CRLF

	ret
header ENDP

;-----------------------------------------------------------------
userInput PROC
;------------------------------------------------------------------
	mov edx, OFFSET Greets
	call WriteString
	call ReadInt
	CMP eax, 8
	JL bye
	CMP eax, 15
	JG bye
	mov inputSize, eax
	mov ecx, 0
	.while(ecx<inputSize)
		mov edx, OFFSET prompt
		call WriteString
		mov eax, ecx
		add eax, 1
		call WriteDec
		mov edx, OFFSET space
		call WriteString
		call ReadInt
		mov arrayInput[ecx*4] , eax
		add ecx, 1
	.endw
	call CRLF
	
	ret
	bye:		
		invoke ExitProcess,0 
userInput ENDP

;-----------------------------------------------------------------
lineDelay PROC
;------------------------------------------------------------------
	mov edx, OFFSET waiting
	call WriteString
	mov eax, 5000
	call DELAY
	call CRLF
	call CRLF

	ret
lineDelay ENDP

;-----------------------------------------------------------------
findMinMax PROC
;------------------------------------------------------------------
	mov edx, OFFSET Results
	call WriteString
	call CRLF
	mov ecx, 0
	mov eax, arrayInput[ecx*4]
    mov e_lowest, eax
	mov e_biggest, eax

	.while(ecx<inputSize)
		mov eax, arrayInput[ecx*4]
		cmp e_lowest, eax
		JL newmax

		mov e_lowest, eax
	newmax:
		cmp e_biggest, eax
		JG done

		mov e_biggest, eax
	done:
		inc ecx
	.endw

	mov edx, OFFSET lowest
	mov eax, e_lowest
	call WriteString
	call WriteInt					;Lowest Value
	call CRLF
	mov edx, OFFSET biggest
	mov eax, e_biggest
	call WriteString
	call WriteDec					;Biggest Value
	call CRLF

	ret
findMinMax ENDP

;-----------------------------------------------------------------
sumPosNeg PROC
;------------------------------------------------------------------
	mov ecx, 0
	mov eax, 0
	mov eax, arrayInput[ecx*4]
	.while(ecx<inputSize)
		inc ecx
		add eax, arrayInput[ecx*4]
	.endw
		mov edx, OFFSET sum				
		call WriteString					
		call WriteDec	
		call CRLF

	mov ecx, 0
	mov eax, 0
	.while(ecx<inputSize)
		mov eax, arrayInput[ecx*4]
		CMP eax, 0
		JL negSum
		CMP eax, 0
		JG posSum
		
		negSum:
			add negative, eax
			JMP next
		posSum:
			add positive, eax
			JMP next
		next:
		inc ecx
	.endw								

	mov edx, OFFSET sumneg
	call WriteString
	mov eax, negative
	call WriteInt
	call CRLF
	mov edx, OFFSET sumpos
	call WriteString
	mov eax, positive
	call WriteDec
	call CRLF
	
	ret
sumPosNeg ENDP

END main
