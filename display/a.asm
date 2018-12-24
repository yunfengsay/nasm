 section .text 
    global _start 

_start: xor  ecx, ecx 
     push rcx     ; Applications default return value 
     mov  cl, V_Size 
     push rcx 
     mov  ebx, Values 
     push rbx 

    Next: 
     or  byte [ebx], 64 
     inc  ebx 
     loop Next 

     pop  rsi 
     pop  rdx 
     pop  rax 
     inc  al 
     mov  edi, eax 
     syscall 

     mov  edi, eax 
     dec  edi 
     mov  eax, edi 
     mov  al, 60 
     syscall 

     section .data  
Values:  db  1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 26, 18, 12, 20, 19, 11 
V_Size  equ  $ - Values 
