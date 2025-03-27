;|------------------------------------------------------------------|                                                                                                                         
;|           This program was written by Seth Reid                  |                                                                                                                         
;|              Date: 2025 - 03 - 25 (start)                        |                                                                                                                         
;|------------------------------------------------------------------|                                                                                                                         
                                                                                                                                                                                              
; To assemble and link properly, do the following:                                                                                                                                            
; yasm -g dwarf2 -f elf64 -o sumOfNumbers.o sumOfNumbers.s                                                                                                                                    
; ld -g -o sumOfNumbers sumOfNumbers.o                                                                                                                                                        
                                                                                                                                                                                              
;####################################################################                                                                                                                         
;                                                                                                                                                                                             
                                                                                                                                                                                              
section      .bss                                                                                                                                                                             
                                                                                                                                                                                              
;**********                                                                                                                                                                                   
;   Defining the uninitialized varaible                                                                                                                                                       
                                                                                                                                                                                              
sum1 resq 1                                                                                                                                                                                   
                                                                                                                                                                                              
section     .data                                                                                                                                                                             
                                                                                                                                                                                              
;**********                                                                                                                                                                                   
;   Defining the constants                                                                                                                                                                    
                                                                                                                                                                                              
EXIT_SUCCESS equ 0                  ; Code for a successful program exit                                                                                                                      
SYS_EXIT equ 60                     ; Code for the exit() systemcall                                                                                                                          
                                                                                                                                                                                              
;***********                                                                                                                                                                                  
;   Defining the data                                                                                                                                                                         
                                                                                                                                                                                              
numsToSum db 10, 20, 30, 40, 50, 60, 70, 80, 90                                                                                                                                               

;**********
;   Defining the start of the program 

section     .text
global _start
_start:

;**********
;   Setting up before the loop

lea rdx, [numsToSum]    ;This is the register that will hold the memory address where the values to be summed begin
xor rax, rax            ;This is the register that will hold the sum (for now)
xor rcx, rcx            ;This is the digitCount 

;**********
;   Looping

sumLoop:                ;Start of the loop
add al, byte [rdx + rcx]    ;Adding numsToSum[index] to rax
inc rcx                 ;Incrementing the counter & the index
cmp rcx, 9              ;Comparing the counter to the max number of variables in the array
jle sumLoop             ;Jumping if it is less than the numer in the array

;**********
;   Finishing out the program

mov [sum1], rax         ;Moving the sum into the proper variable

;**********
;   Making the system exit properly

mov rdi, EXIT_SUCCESS
mov rax, SYS_EXIT
syscall
