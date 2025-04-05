;|----------------------------------------------------------------------|
;|                                                                      |
;|              This program was written by Seth Reid                   |
;|                       Happy April Fools                              |
;|                                                                      |
;|----------------------------------------------------------------------|

;   To assemble and link properly, do the following:
;   yasm -g dwarf2 -f elf64 -o unsigned.o unsigned.s
;   ld -g -o unsigned unsigned.o

;########################################################################
;Beginning of code

;********************
;   Section for our uninitialized array

section     .bss

intString resb 10           ; Each letter is one byte, so it is a resb array

;********************
;   Defining the varaibles that we will need 

section     .data

EXIT_SUCCESS    equ 0                       ; Code for a successful program exit
SYS_EXIT        equ 60                      ; Code for the exit() systemcall
magic           dq  0xCCCCCCCCCCCCCCCD      ; Magic number we will multiply by
myInt           dq  1149                    ; The integer to transition

;********************
;   Section where our code will run

section     .text
global _start
_start:

; Stage 1, looping over the integer and dividing it by 10 and extracting the remainder
; Formula for stage 1
; quotient (rax)  = (myInt (rax, rsi) * MAGIC_NUMBER (rbx)) >> 67
; remainder = myInt (rsi) - (quotient * 10 (r14))
stage1:
mov rax, [myInt]
mov rbx, [magic]
xor r13, r13

gettingDigits:
xor rdx, rdx
mov rsi, rax
mul rbx                         ; rax becomes the quotient
mov rax, rdx                    ; Effectively shifts by 64
shr rax, 3                      ; rax becomes the quotient, finishes the 67 bit shift
remainder:
mov rdi, rax                    ; rdi is used to store rax for further arithmetic
mov r14, 10
mul r14
sub rsi, rax                    ; rsi (previous iterations myInt) is subtracted to find the remainder
push rsi
mov rax, rdi
inc r13
cmp rdi, 0
ja gettingDigits

; Stage 2:
; r13 holds the number of characters
; pop digits off of the stack
; add to them 0x30
; put them into the array that will hold the string

stage2:
xor rax, rax                    ; rax is where we will pop the number into
xor rbx, rbx                    ; new counter for the index
xor rcx, rcx                    ; register to hold the address of intString
lea rcx, [intString]
intToString:
pop rax
add rax, '0'                    ; Hex value of '0x30', this is where 0-9 begins
mov byte [rcx + rbx], al        ; Add the new hex-coded character into the memory address at the byte array intex [rbx]
inc rbx                         ; Increment the index by 1
dec r13                         ; Decrement the counter by 1
cmp r13, 0                      ; Compare the counter to 0, if it is above, loop
ja intToString
mov byte [rcx + rbx], 0x0A      ; Add a new line to the end of the character array
inc rbx                         ; Increment the index by one so a null byte (terminator) can be added
mov byte [rcx + rbx], 0x00

printTime:                  ; Now we will print the number to the screen
xor rax, rax
mov rax, 1                  ; System call for writing
xor rdi, rdi
mov rdi, 1                  ; File descriptor for standard output
xor rsi, rsi
mov rsi, rcx                ; Location of the buffer is put into the second argument
xor rdx, rdx
mov rdx, rbx                ; Size of the buffer is put into the third argument
syscall

last:
xor rax, rax
xor rdi, rdi
mov rdi, EXIT_SUCCESS
mov rax, SYS_EXIT
syscall
