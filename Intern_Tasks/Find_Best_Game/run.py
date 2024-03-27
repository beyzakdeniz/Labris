from scapy.layers.tls.cert import PrivKey
from scapy.layers.tls.session import *
from scapy.all import *

if __name__ == '__main__':

    load_layer("tls")
    
    pcap_file = "/home/beyza/Desktop/Intern_Tasks/Find_Best_Game/best_game.pcap"
    server_priv_key = "/home/beyza/Desktop/Intern_Tasks/Find_Best_Game/server.key"
    packets = rdpcap(pcap_file)

    key = PrivKey(server_priv_key)
    results = sniff(offline=packets, session=TLSSession(server_rsa_key=key))
    
    for index, r in enumerate(results):
        if r.haslayer('TLS'):
            print(r.show())

