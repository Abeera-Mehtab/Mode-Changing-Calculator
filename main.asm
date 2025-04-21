.386
.model flat, stdcall
.stack 4096

ExitProcess PROTO, dwExitCode:DWORD
INCLUDE Irvine32.inc

.data
    ; Display messages
    msgArithmeticMode  BYTE "Arithmetic Mode: Can perform +, -, *, /", 0
    msgLogicalMode     BYTE "Logical Mode: Can perform AND, OR, NOT, XOR", 0
    msgEnterOperand1   BYTE "Enter operand 1: ", 0
    msgEnterOperand2   BYTE "Enter operand 2: ", 0
    msgEnterOperator   BYTE "Enter operator (+, -, *, /): ", 0
    msgResult          BYTE "Result: ", 0
    msgErrorDivByZero  BYTE "Error: Division by zero", 0
    msgInvalidInput    BYTE "Invalid input. Please enter valid operands and operator.", 0
    msgToggleMode      BYTE "Press 'M' to toggle to Logical Mode", 0
    msgExit            BYTE "Exiting Calculator...", 0

    ; Variables for operands, result, mode, etc.
    arithmeticOperand1 DWORD ?
    arithmeticOperand2 DWORD ?
    logicalOperand1  BYTE ?
    logicalOperand2  BYTE ?
    result DWORD ?
    mode BYTE 0      ; 0 = Arithmetic, 1 = Logical
    operator BYTE ?
    inputKey BYTE ?

.code

main:
    ; Set up initial mode as Arithmetic
    mov mode, 0

    ; Display welcome message for mode
    call displayModeMessage

    ; Start main loop
    startLoop:
        ; Continuously check for toggle mode and operator
        call checkToggleMode

        ; Get operand1 input
        call getOperand1
        ; Get operator input
        call getOperator
        ; If operation is NOT (Logical), only one operand is required
        cmp operator, '-'
        je getOperand2Not
        ; Get operand2 input
        call getOperand2

        ; Perform the calculation based on the mode
        cmp mode, 0   ; Arithmetic Mode?
        je performArithmetic
        cmp mode, 1   ; Logical Mode?
        je performLogical

        jmp startLoop

    getOperand1:
        ; Display message for operand1
        mov edx, offset msgEnterOperand1
        call WriteString
        ; Read operand1
        call ReadInt
        ; If in arithmetic mode, store in 32-bit, otherwise store in 8-bit for logical
        cmp mode, 0
        je storeArithmeticOperand1
        ; Logical Mode - Read as byte
        movzx eax, al
        mov logicalOperand1, al
        ret

    storeArithmeticOperand1:
        mov arithmeticOperand1, eax
        ret

    getOperand2:
        ; Display message for operand2
        mov edx, offset msgEnterOperand2
        call WriteString
        ; Read operand2
        call ReadInt
        ; Store in appropriate size based on mode
        cmp mode, 0
        je storeArithmeticOperand2
        ; Logical Mode - Read as byte
        movzx eax, al
        mov logicalOperand2, al
        ret

    storeArithmeticOperand2:
        mov arithmeticOperand2, eax
        ret

    getOperand2Not:
        ; For NOT operation, no second operand needed
        mov logicalOperand2, 0
        ret

    getOperator:
        ; Display message for operator
        mov edx, offset msgEnterOperator
        call WriteString
        ; Get the operator
        call ReadChar
        mov operator, al
        ret

    displayModeMessage:
        ; Check the mode and display appropriate message
        cmp mode, 0
        je displayArithmeticMsg
        cmp mode, 1
        je displayLogicalMsg

    displayArithmeticMsg:
        mov edx, offset msgArithmeticMode
        call WriteString
        ret

    displayLogicalMsg:
        mov edx, offset msgLogicalMode
        call WriteString
        ret

    performArithmetic:
        ; Perform arithmetic operations based on the operator
        cmp operator, '+' ; Addition
        je addOperands
        cmp operator, '-' ; Subtraction
        je subOperands
        cmp operator, '*' ; Multiplication
        je mulOperands
        cmp operator, '/' ; Division
        je divOperands
        jmp invalidOperator

    addOperands:
        ; Perform addition (32-bit)
        mov eax, arithmeticOperand1
        add eax, arithmeticOperand2
        mov result, eax
        call displayResult
        ret

    subOperands:
        ; Perform subtraction (32-bit)
        mov eax, arithmeticOperand1
        sub eax, arithmeticOperand2
        mov result, eax
        call displayResult
        ret

    mulOperands:
        ; Perform multiplication (32-bit)
        mov eax, arithmeticOperand1
        imul eax, arithmeticOperand2
        mov result, eax
        call displayResult
        ret

    divOperands:
        ; Perform division with check for zero
        cmp arithmeticOperand2, 0
        je divByZero
        mov eax, arithmeticOperand1
        xor edx, edx   ; Clear EDX for division
        div arithmeticOperand2
        mov result, eax
        call displayResult
        ret

    divByZero:
        ; Handle division by zero
        mov edx, offset msgErrorDivByZero
        call WriteString
        ret

    performLogical:
        ; Perform logical operations based on the operator
        cmp operator, '+' ; AND operation
        je andOperands
        cmp operator, '*' ; OR operation
        je orOperands
        cmp operator, '-' ; NOT operation
        je notOperand
        cmp operator, '/' ; XOR operation
        je xorOperands
        jmp invalidOperator

    andOperands:
        ; Perform AND operation (8-bit)
        mov al, logicalOperand1
        and al, logicalOperand2
        mov result, eax  ; Store result in 32-bit register
        call displayResult
        ret

    orOperands:
        ; Perform OR operation (8-bit)
        mov al, logicalOperand1
        or al, logicalOperand2
        mov result, eax  ; Store result in 32-bit register
        call displayResult
        ret

    notOperand:
        ; Perform NOT operation (one operand) (8-bit)
        mov al, logicalOperand1
        not al
        mov result, eax  ; Store result in 32-bit register
        call displayResult
        ret

    xorOperands:
        ; Perform XOR operation (8-bit)
        mov al, logicalOperand1
        xor al, logicalOperand2
        mov result, eax  ; Store result in 32-bit register
        call displayResult
        ret

    invalidOperator:
        ; Handle invalid operator input
        mov edx, offset msgInvalidInput
        call WriteString
        ret

    displayResult:
        ; Display result message
        mov edx, offset msgResult
        call WriteString
        ; Display the result value
        call WriteInt
        call Crlf
        ret

    checkToggleMode:
        ; Check if user pressed 'M' to toggle mode
        call ReadChar
        cmp al, 'M'
        je toggleMode
        ret

    toggleMode:
        ; Toggle between arithmetic and logical mode
        cmp mode, 0
        je setLogicalMode
        cmp mode, 1
        je setArithmeticMode

    setLogicalMode:
        mov mode, 1
        call displayLogicalMsg
        ret

    setArithmeticMode:
        mov mode, 0
        call displayArithmeticMsg
        ret

END main
