#!/bin/bash

#remove namespace if it exists
echo -e "remove namespace if it exists\n"
ip netns del client1 
ip netns del client2 
ip netns del server 
ip netns del firewall
ip link delete vh

#create namespaces
echo -e "create namespaces\n"
ip netns add client1
ip netns add client2
ip netns add server
ip netns add firewall

#create veth
echo -e "create veth\n"
ip link add vc1 type veth peer name vfw1
ip link add vc2 type veth peer name vfw2
ip link add vsr type veth peer name vfw3
ip link add vh type veth peer name vfwh

#setup veth link 
echo -e "setup veth link\n"
ip link set vc1 up
ip link set vc2 up
ip link set vsr up 
ip link set vfw1 up
ip link set vfw2 up
ip link set vfw3 up
ip link set vh up
ip link set vfwh up

#add peers to namespaces
echo -e "add peers to namespaces\n"
ip link set vc1 netns client1
ip link set vc2 netns client2
ip link set vsr netns server
ip link set vfw1 netns firewall
ip link set vfw2 netns firewall
ip link set vfw3 netns firewall
ip link set vfwh netns firewall

#setup loopback interface
echo -e "setup loopback interface\n"
ip netns exec client1 ip link set lo up
ip netns exec client2 ip link set lo up
ip netns exec server ip link set lo up
ip netns exec firewall ip link set lo up

#bring up to interfaces
echo -e "bring up to interfaces\n"
ip -n client1 link set dev vc1 up
ip -n client2 link set dev vc2 up
ip -n server link set dev vsr up
ip -n firewall link set dev vfw1 up
ip -n firewall link set dev vfw2 up
ip -n firewall link set dev vfw3 up
ip -n firewall link set dev vfwh up
ip link set dev vh up

#provide ip to each interface (+1 because .0 is not valid)
echo -e "provide ip to each interface\n"
ip -n client1 addr add 192.0.2.2/26 dev vc1
ip -n client2 addr add 192.0.2.66/26 dev vc2
ip -n server addr add 192.0.2.130/26 dev vsr

#provide ip to fw
echo -e "provide ip to fw\n"
ip -n firewall addr add 192.0.2.3/26 dev vfw1
ip -n firewall addr add 192.0.2.67/26 dev vfw2
ip -n firewall addr add 192.0.2.131/26 dev vfw3
ip -n firewall addr add 192.0.2.195/26 dev vfwh

#provide ip to host-to-firewall
echo -e "provide ip to host-to-firewall\n"
ip addr add 192.0.2.194/26 dev vh 

#test connectivity
echo -e "test connectivity\n"
echo "firewall ping"
ip netns exec firewall ping -c 3 192.0.2.2
: <<'END_COMMENT'
echo "client1 ping"
ip netns exec client1 ping -c 3 192.0.2.3
echo "client2 ping"
ip netns exec client2 ping -c 3 192.0.2.67
echo "server ping"
ip netns exec server ping -c 3 192.0.2.131
END_COMMENT

#add routes for namespaces
echo -e "add route for namespaces\n"
#outward
ip -n client1 route add default via 192.0.2.3 dev vc1
ip -n client2 route add default via 192.0.2.67 dev vc2
ip -n server route add default via 192.0.2.131 dev vsr
ip -n firewall route add default via 192.0.2.194 dev vfwh



echo -e "AAAAA\n"
#inward
ip -n firewall route add 192.0.2.2 dev vfw1
ip -n firewall route add 192.0.2.66 dev vfw2
ip -n firewall route add 192.0.2.130 dev vfw3

echo -e "BBBBB\n"
ip -n firewall route add 192.0.2.0/26 via 192.0.2.2 dev vfw1
ip -n firewall route add 192.0.2.64/26 via 192.0.2.66 dev vfw2
ip -n firewall route add 192.0.2.128/26 via 192.0.2.130 dev vfw3

#setup host-to-firewall ip
echo -e "setup host-to-firewall routes\n"
ip route add 192.0.2.195 dev vh
ip route add 192.0.2.0/26 via 192.0.2.195 dev vh
ip route add 192.0.2.64/26 via 192.0.2.195 dev vh
ip route add 192.0.2.128/26 via 192.0.2.195 dev vh


#enable IP forwarding
echo -e "enable ip forwarding\n"
sysctl -w net.ipv4.ip_forward=1
ip netns exec client1 sysctl -w net.ipv4.ip_forward=1
ip netns exec client2 sysctl -w net.ipv4.ip_forward=1
ip netns exec server sysctl -w net.ipv4.ip_forward=1
ip netns exec firewall sysctl -w net.ipv4.ip_forward=1

#alternative
bash -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'



#flush nat rules
echo -e "flush nat rules and masquarade\n"
#ip netns exec firewall iptables -t nat -F

#ip netns exec firewall iptables -t nat -A POSTROUTING -s 192.0.2.128/26 -o vh -j MASQUERADE

iptables -A FORWARD -i eno1 -j ACCEPT
iptables -A FORWARD -o eno1 -j ACCEPT

iptables -t nat -A POSTROUTING -o eno1 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 192.0.2.0/26 -o eno1 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 192.0.2.64/26 -o eno1 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 192.0.2.128/26 -o eno1 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 192.0.2.192/26 -o eno1 -j MASQUERADE

: <<'END_COMMENT'

ip -n client1 route add 192.0.2.195 dev vc1
ip -n client2 route add 192.0.2.195 dev vc2
ip -n server route add 192.0.2.195 dev vc3


#serve HTTP service inside the server (start a web server on IP address 192.0.2.130 and port 80)
echo -e "serve HTTP service inside the server"
ip netns exec server python3 -m http.server -b 192.0.2.130 80






END_COMMENT
