;|------------------------------------------------------------------|                                                                                                      
;|           This program was written by Seth Reid                  |                                                                                                      
;|              Date: 2025 - 03 - 29 (start)                        |                                                                                                      
;|------------------------------------------------------------------|                                                                                                      
                                                                                                                                                                           
; To assemble and link properly, do the following:                                                                                                                         
; yasm -g dwarf2 -f elf64 -o sumPlusMax.o sumPlusMax.s                                                                                                                     
; ld -g -o sumPlusMax sumPlusMax.o                                                                                                                                         
                                                                                                                                                                           
;####################################################################                                                                                                      
;                                                                                                                                                                          
                                                                                                                                                                           
section      .bss                                                                                                                                                          
                                                                                                                                                                           
;**********                                                                                                                                                                
;   Defining the uninitialized varaible                                                                                                                                    
                                                                                                                                                                           
sum1 resb 1                                                                                                                                                                
max1 resb 1                                                                                                                                                                
min1 resb 1                                                                                                                                                                
                                                                                                                                                                           
section     .data                                                                                                                                                          
                                                                                                                                                                           
;**********                                                                                                                                                                
;   Defining the constants                                                                                                                                                 
                                                                                                                                                                           
EXIT_SUCCESS equ 0                  ; Code for a successful program exit                                                                                                   
SYS_EXIT equ 60                     ; Code for the exit() systemcall                                                                                                       
                                                                                                                                                                           
;***********                                                                                                                                                               
;   Defining the data                                                                                                                                                      
                                                                                                                                                                           
numsToSum db 33, 20, 30, 40, 50, 11, 10, 60, 70, 80, 90                                                                                                                    
                                                                                                                                                                           
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
xor r15, r15            ;This is the register to hold max                                                                                                                  
xor r14, r14            ;This is the register to hold min                                   
mov r15b, byte [rdx+rcx]                                               
mov r14b, byte [rdx+rcx]                 

sumLoop:                    ;Start of the loop
add al, byte [rdx + rcx]    ;Adding array[index] to rax
cmp r15b, byte [rdx + rcx]          ;Comparing r15 to array[index]
jae cont1                   ;If r15 (current max) is greater than or equal to the current index, continute
mov r15b, byte [rdx + rcx]          ;Otherwise make the current max the current index
cont1:
cmp r14b, byte [rdx + rcx]
jbe cont2                   ;Jump to cont2 if the current min is below or equal to array[index]
mov r14b, byte [rdx + rcx]          ;Otherwise, make the min value equal to the curent index
cont2:
inc rcx                     ;Incrementing the counter & the index
cmp rcx, 11                 ;Comparing the counter to the max number of variables in the array
jb sumLoop                 ;Jumping if it is less than the numer in the array

;**********
;   Finishing out the program

finalTouch:
mov [sum1], al         ;Moving the sum into the proper variable
mov [max1], r15b         ;Moving the max from r15 to the proper variable
mov [min1], r14b         ;Moving the min from r14 to the proper variable

;**********
;   Making the system exit properly

exitTime:
mov rdi, EXIT_SUCCESS
mov rax, SYS_EXIT
syscall
