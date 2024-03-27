from scapy.all import *

if __name__ == '__main__':
    load_layer("tls")

    conf.tls_session_enable = True
    conf.tls_nss_filename = "/home/beyza/Desktop/Intern_Tasks/Find_Best_Game/server.key"

    packets = rdpcap("/home/beyza/Desktop/Intern_Tasks/Find_Best_Game/best_game.pcap")

    # Display information about TLS packets
    for packet in packets:
        if TLS in packet:
            packet[TLS].show()



