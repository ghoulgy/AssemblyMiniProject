TITLE try					(try.asm)

; Description:
; CHIAM YOONG JIEN A15CS0016
; Revision date:

INCLUDE Irvine32.inc
.data
	tajuk BYTE 'Assignments Processing', 0
	prompt BYTE 'Assignment ', 0
	space BYTE ': ', 0
	sum BYTE 'Total sum of assignments: ', 0
	waiting BYTE 'Assignment processing in progress ... 2 seconds', 0
	displayGrade BYTE 'Display assignment values and grades: ', 0
	lowest BYTE 'The lowest assignment value: ', 0
	biggest BYTE 'The highest assignment value: ', 0
	avg BYTE 'Average of the assignments: ', 0
	avgGrade BYTE '  Grade:', 0
	cont BYTE 'Do you want to continue (y/n)?', 0
	A BYTE ' A', 0
	B BYTE ' B', 0
	strC BYTE ' C', 0
	min DWORD ?
	max DWORD ?
	arrayInput REAL4 5 dup(?)
	b_arrayInput DWORD 5 dup(?)
	char REAL4 ?
	len = lengthof arrayInput
	e_lowest DWORD ?
	e_biggest DWORD ?
	Results  byte  "Results: "  , 0
	Greets byte 'Input Assignments scores:', 0

.code
main PROC

L1:
	call clrscr
	mov edx, OFFSET tajuk
	call WriteString
	call CRLF
	call userInput					;Ask for user input
	call lineDelay					;Processing time
	call printMarkGrade				;Print marks and grades
	call findMINMAX					;Print min and max value
	call sum_of_array				;Sum of array
	call averageMarks				;Average marks and grades
	mov edx, OFFSET cont			;Continue Programe
	call WriteString
	call ReadChar
	call WriteChar
	cmp al, 'y'
	JE L1
	cmp al, 'n'
	JE bye
	loop L1

	bye:
	call CRLF						;Continue Programe						
	exit
main ENDP

;-----------------------------------------------------------------
userInput PROC
;------------------------------------------------------------------
    mov ecx, 0						;Prompt user for integer entry
	mov eax, 0
	mov edx, OFFSET Greets
	call WriteString
	call CRLF

	mov esi, OFFSET arrayInput
	.while(ecx<len)
		mov edx, OFFSET prompt
		call WriteString
		mov eax, ecx
		add eax, 1
		call WriteDec
		mov edx, OFFSET space		
		call WriteString
		call ReadInt
		mov arrayInput[ecx*4] , eax
		inc ecx
	.endw								
	ret
userInput ENDP

;-----------------------------------------------------------------
lineDelay PROC
;------------------------------------------------------------------
	call CRLF
	mov edx, OFFSET waiting
	call WriteString
    mov eax, 2000
	call Delay
	call CRLF
	call CRLF
								
	ret
lineDelay ENDP

;-----------------------------------------------------------------
printMarkGrade PROC
;------------------------------------------------------------------
	mov edx, OFFSET displayGrade		;Print marks and grades
	call WriteString
	call CRLF
	mov ecx, 0
	mov eax, 0

	.while(ecx<len)
		mov edx, OFFSET prompt
		call WriteString
		mov eax, ecx
		add eax, 1
		call WriteDec
		mov edx, OFFSET space
		call WriteString
		mov eax, arrayInput[ecx*4]
		call WriteDec
		call compare
		call CRLF
		inc ecx
	.endw								;Print marks and grades
	call CRLF
	ret
printMarkGrade ENDP

;-----------------------------------------------------------------
compare PROC
;------------------------------------------------------------------
    cmp eax, 80
	JAE gradeA
	cmp eax, 50
	JAE gradeB
	cmp eax, 0
	JAE gradeC

	gradeA:
	mov edx, OFFSET A
	call WriteString
	ret

	gradeB:
	mov edx, OFFSET B
	call WriteString
	ret

	gradeC:
	mov edx, OFFSET strC
	call WriteString
	ret
compare ENDP

;-----------------------------------------------------------------
findMINMAX PROC
;------------------------------------------------------------------
	mov ecx, 0
	mov eax, arrayInput[ecx*4]
    mov e_lowest, eax
	mov e_biggest, eax

	.while(ecx<len)
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
	call WriteDec					;Lowest Value
	call CRLF
	mov edx, OFFSET biggest
	mov eax, e_biggest
	call WriteString
	call WriteDec					;Biggest Value
	call CRLF
	ret
findMINMAX ENDP



;-----------------------------------------------------------------
sum_of_array PROC
;------------------------------------------------------------------
	mov ecx, 0
	mov eax, 0
	mov eax, arrayInput[ecx*4]
	.while(ecx<len)
		inc ecx
		add eax, arrayInput[ecx*4]
	.endw
		mov edx, OFFSET sum				
		call WriteString					
		call WriteDec	
		call CRLF				
	ret
sum_of_array ENDP

;-----------------------------------------------------------------
averageMarks PROC
;------------------------------------------------------------------
	mov ecx, 0
	mov eax, 0
	mov eax, arrayInput[ecx*4]
	.while(ecx<len)
		inc ecx
		add eax, arrayInput[ecx*4]
	.endw

		mov edx, 0
		mov ecx, len
		div ecx
		mov edx, OFFSET avg
		call WriteString
		call writeDec
		mov edx, OFFSET avgGrade
		call WriteString
		call compare
		call CRLF
	ret
averageMarks ENDP

END main