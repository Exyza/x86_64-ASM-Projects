 A program that uses a macro to transform integer values into their ascii string equivalent                                                                                                  
                                                                                                                                                                                              
; ******************************************************************************************                                                                                                  
;   Macro definition                                                                                                                                                                          
;   Macro is called with two arguments: the integer and the magic number                                                                                                                      
;   intToString <integer>, <magic number>, <uninitilized array>                                                                                                                               
                                                                                                                                                                                              
%macro intToString 3                                                                                                                                                                          
                                                                                                                                                                                              
;   Setting up the registers                                                                                                                                                                  
    mov rax, [%1]                                                                                                                                                                             
    mov rbx, [%2]                                                                                                                                                                             
    xor r13, r13                                                                                                                                                                              
                                                                                                                                                                                              
; quotient (rax)  = (myInt (rax, rsi) * MAGIC_NUMBER (rbx)) >> 67                                                                                                                             
; remainder = myInt (rsi) - (quotient * 10 (r14))                                                                                                                                             
; ^^^This will be looped                                                                                                                                                                      
                                                                                                                                                                                              
%%gettingDigits:                                                                                                                                                                              
    xor rdx, rdx                                                                                                                                                                              
    mov rsi, rax                    ; Saving the integer value into rsi for later use                                                                                                         
    mul rbx                         ; rax becomes the quotient                                                                                                                                
    mov rax, rdx                    ; Effectively shifts by 64                                                                                                                                
    shr rax, 3                      ; rax becomes the quotient, finishes the 67 bit shift                                                                                                     
%%remainder:                                                                                                                                                                                  
    mov rdi, rax                    ; rdi is used to store rax for further arithmetic                                                                                                         
    mov r14, 10                                                                                                                                                                               
    mul r14                                                                                                                                                                                   
    sub rsi, rax                    ; rsi (previous iterations myInt) is subtracted to find the remainder                                                                                     
    push rsi                                                                                                                                                                                  
    mov rax, rdi                                                                                                                                                                              
    inc r13
        cmp rdi, 0
    ja %%gettingDigits

%%stage2:
    xor rax, rax                    ; rax is where we will pop the number into
    xor rbx, rbx                    ; new counter for the index
    xor rcx, rcx                    ; register to hold the address of intString
    lea rcx, [%3]
%%intToString:
    pop rax
    add rax, '0'                    ; Hex value of '0x30', this is where 0-9 begins
    mov byte [rcx + rbx], al        ; Add the new hex-coded character into the memory address at the byte array intex [rbx]
    inc rbx                         ; Increment the index by 1
    dec r13                         ; Decrement the counter by 1
    cmp r13, 0                      ; Compare the counter to 0, if it is above, loop
    ja %%intToString
    mov byte [rcx + rbx], 0x0A      ; Add a new line to the end of the character array
    inc rbx                         ; Increment the index by one so a null byte (terminator) can be added
    mov byte [rcx + rbx], 0x00


%%printTime:                  ; Now we will print the number to the screen
    xor rax, rax
    mov rax, 1                  ; System call for writing
    xor rdi, rdi
    mov rdi, 1                  ; File descriptor for standard output
    xor rsi, rsi
    mov rsi, rcx                ; Location of the buffer is put into the second argument
    xor rdx, rdx
    mov rdx, rbx                ; Size of the buffer is put into the third argument
    syscall

%endmacro


; ******************************************************************************************
; Declaring data

section .bss

intString1 resb 10
intString2 resb 10
intString3 resb 10

section .data

EXIT_SUCCESS    equ 0
SYS_EXIT        equ 60
magic           dq 0xCCCCCCCCCCCCCCCD
myInt1          dq 1149
myInt2          dq 2000
myInt3          dq 40000

section .text
global _start
_start:

intToString myInt1, magic, intString1
intToString myInt2, magic, intString2
intToString myInt3, magic, intString3


last:
xor rax, rax
xor rdi, rdi
mov rdi, EXIT_SUCCESS
mov rax, SYS_EXIT
syscall
