%include "io.inc"

%define MAX_INPUT_SIZE 4096

section .bss
    expr: resb MAX_INPUT_SIZE

section .text
global CMAIN
CMAIN:    
PROLOG:
    push ebp
    mov ebp, esp

    GET_STRING expr, MAX_INPUT_SIZE
 
STRLEN:
    cld
    mov al, 0
    mov edi, expr
    repne scasb
    
    sub edi, expr
    dec edi
    
    mov ecx, edi
    mov edi, expr
    xor eax, eax
    mov ebx, 1
    
ITERATE:
    cmp byte [edi], ' '
    je SPACE
    
    cmp byte [edi], '+'
    je PLUS
    
    cmp byte [edi], '-'
    je SUBSTRACT
    
    cmp byte [edi], '*'
    je MULTIPLY
    
    cmp byte [edi], '/'
    je DIVIDE 
    
    mov edx, 10
    imul edx
    mov dl, [edi]
    sub edx, 48
    add eax, edx
  
    inc edi
    loop ITERATE
   
    jmp PRINT_RESULT
      
SPACE:
    imul ebx
    
    cmp byte [edi-1], '0'
    jl NO_EXTRA_ZERO_ON_STACK
    
    push eax
    
NO_EXTRA_ZERO_ON_STACK:
    mov ebx, 1
    xor eax, eax
    inc edi
    cmp ecx, 0
    jne ITERATE
    
PLUS:
    xor edx, edx
    pop esi
    pop eax
    
    add eax, esi
    push eax
    
    xor eax, eax
    inc edi
    cmp ecx, 0
    jne ITERATE

SUBSTRACT:
    cmp byte [edi+1], '0'
    jg IS_NEGATIVE_NUMBER

    xor edx, edx
    pop esi
    pop eax
    
    sub eax, esi
    push eax
    
    xor eax, eax
    mov ebx, 1
IS_NEGATIVE_NUMBER:
    mov ebx, -1
    
    inc edi
    cmp ecx, 0
    jne ITERATE

MULTIPLY:    
    xor edx, edx
    pop esi
    pop eax
    
    imul esi
    push eax
    
    xor eax, eax
    inc edi
    cmp ecx, 0
    jne ITERATE
    
DIVIDE:
    xor edx, edx
    pop esi
    pop eax

    cmp eax, 0
    jge POSITIVE_DIVIDE
    
    mov edx, 0xffffffff
    
POSITIVE_DIVIDE:  
    idiv esi
    push eax
    
    xor eax, eax
    inc edi
    cmp ecx, 0
    jne ITERATE
    
PRINT_RESULT:
    pop eax
    PRINT_DEC 4, eax
    
EPILOG:
    xor eax, eax
    pop ebp
    ret