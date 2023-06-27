section .data
    plaintext db 0x12, 0x34, 0x56, 0x78, 0x9a, 0xbc, 0xde, 0xf0, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88
    firstkey db 0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c ; used for encryption
    secondkey db 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff, 0x00  ; used for decryption
    zerokey db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

section .text
    global _start

_start:
    ; Load plaintext and key into registers
    movdqu xmm0, [plaintext]

    ;prepare the key expansion for the encryption keys
    movdqu xmm1, [firstkey]

    aeskeygenassist xmm2, xmm1, 0x01
    aeskeygenassist xmm3, xmm1, 0x02
    aeskeygenassist xmm4, xmm1, 0x04
    aeskeygenassist xmm5, xmm1, 0x08

   ;prepare the key expansion for the decryption keys
    movdqu xmm7, [secondkey]

    aeskeygenassist xmm8, xmm7, 0x01
    aeskeygenassist xmm9, xmm8, 0x02
    aeskeygenassist xmm10, xmm9, 0x04
    aeskeygenassist xmm11, xmm10, 0x08

    movdqu xmm13, [zerokey]

    movdqu xmm0, [plaintext]
    ; Perform AES encryption
    aesenc xmm0, xmm2       ; Round 1
    aesenc xmm0, xmm3       ; Round 2
    aesenc xmm0, xmm4       ; Round 3
    aesenclast xmm0, xmm5   ; Round 5

    movdqu xmm14, xmm0      ; Store the output for XOR
 
   ;add invmixcolumns for more security as an extra step
    aesenclast xmm0, xmm13
    aesdec xmm0, xmm13

   ;actual decryption rounds
    aesdec xmm0, xmm8       ; Round 1
    aesdec xmm0, xmm9       ; Round 2
    aesdec xmm0, xmm10      ; Round 3
    aesdeclast xmm0, xmm11  ; Round 5

    movdqu xmm15, xmm0      ; Store the output for XOR
    ; xxm14 will contain the output to the prf
    xorps xmm14, xmm15

    mov eax, 1          ; System call number for exit
    xor ebx, ebx        ; Exit status 0
    int 0x80            ; Perform the system call
