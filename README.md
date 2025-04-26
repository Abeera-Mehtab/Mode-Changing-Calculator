# Mode-Changing Calculator

## 1. Introduction
This project focuses on designing a processor architecture for a basic calculator. The calculator supports both arithmetic and logical operations and interacts with input and output devices. Phase 1 involves the processor design, block diagram, hardware description, and interaction with I/O devices.

## 2. Processor Architecture

### 2.1 Block Diagram
The processor includes the following components:
- **Arithmetic Logic Unit (ALU)**: Handles arithmetic and logical operations (e.g., addition, subtraction, AND, OR).
- **Control Unit (CU)**: Decodes instructions and manages control signals.
- **Registers**: Temporary storage for operands and results.
- **Memory**: Stores program instructions and data.
- **I/O Interface**: Interfaces with input (keypad) and output (LCD display) devices.

### 2.2 Hardware Description
- **ALU**: Performs arithmetic and logical operations using basic logic gates and combinational circuits.
- **Control Unit**: Decodes keypad instructions and generates control signals.
- **Registers**: Stores operands, operator, and result.
- **Memory**: Stores program data for operations.

## 3. Interface Between Processor and I/O Devices

### 3.1 Input Devices: Keypad
- User inputs numbers, operators, and commands.
- Includes a reset button.

### 3.2 Output Devices: LCD Display
- Displays intermediate and final results, including error messages.

## 4. Supported Instructions
The processor supports the following instructions:
- Load, Store, Add, Sub, Multiply, Divide, AND, OR, XOR, NOT, Exit.

## 5. Algorithm and Code Design
This calculator operates in two modes:
1. **Arithmetic Mode**: Basic operations (+, -, *, /).
2. **Logical Mode**: Bitwise operations (AND, OR, XOR, NOT).

The program reads user inputs (two operands and an operator), performs the appropriate operation, and displays the result or error messages.

## 6. Hardware Design
### Components Overview
- **LM016L LCD**: 16x2 character LCD for displaying results.
- **PIC16LF877 Microcontroller**: Controls the calculator logic and manages I/O.
- **4x4 Matrix Keypad**: Used for user input.
- **Reset Button**: Resets the calculator.

### Pin Configuration
- **LM016L LCD**: Requires control and data lines for interfacing with the microcontroller.
- **PIC16LF877**: Manages input/output operations with peripherals like the keypad and LCD.

## 7. Summary
This project implements a simple calculator with both arithmetic and logical operation modes. It supports user input through a keypad and displays results on an LCD. The design includes an ALU, control unit, and memory, all integrated with the PIC16LF877 microcontroller.
