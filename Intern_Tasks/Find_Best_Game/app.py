from scapy.all import *
from scapy.layers.tls import *

if __name__ == '__main__':
	
	load_layer("tls")

	conf.tls_session_enable = True
	conf.tls_nss_filename = "/home/beyza/Desktop/Intern_Tasks/Find_Best_Game/server.key"

	packets = rdpcap("/home/beyza/Desktop/Intern_Tasks/Find_Best_Game/best_game.pcap")

	# Display the HTTP GET query
	
	print("summmary\n\n")
	packets[11][TLS].summary()
	print("show\n\n")
	packets[11][TLS].show()
	print("show2\n\n")
	packets[11][TLS].show2()
	print("sprintf\n\n")
	packets[11][TLS].sprintf("{Raw:%Raw.load%\n}")

	print("raw\n\n")
	raw(packets[11][TLS])
	print("hexdump\n\n")
	hexdump(packets[11][TLS])
	print("ls\n\n")
	ls(packets[11][TLS])

