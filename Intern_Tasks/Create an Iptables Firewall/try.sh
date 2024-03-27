#!/bin/bash

#remove namespace if it exists
echo -e "remove namespace if it exists\n"
ip netns del client1 
ip netns del client2 
ip netns del server 
ip netns del firewall

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

#setup veth link 
echo -e "setup veth link\n"
ip link set vc1 up
ip link set vc2 up
ip link set vsr up 
ip link set vfw1 up
ip link set vfw2 up
ip link set vfw3 up

#connect the global namespace to the created namespaces
echo -e "connect the global namespace to the created namespaces\n"
ip link set vc1 netns client1
ip link set vc2 netns client2
ip link set vsr netns server
ip link set vfw1 netns firewall
ip link set vfw2 netns firewall
ip link set vfw3 netns firewall


#bring up to interfaces
echo -e "bring up to interfaces\n"
ip -n client1 link set vc1 up
ip -n client2 link set vc2 up
ip -n server link set vsr up
ip -n firewall link set vfw1 up
ip -n firewall link set vfw2 up
ip -n firewall link set vfw3 up

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



#test connectivity
echo -e "test connectivity\n"
echo "firewall ping"
ip netns exec firewall ping 192.0.2.2
echo "client1 ping"
ip netns exec client1 ping 192.0.2.3
echo "client2 ping"
ip netns exec client2 ping 192.0.2.67
echo "server ping"
ip netns exec server ping 192.0.2.131



: <<'END_COMMENT'

#setup loopback interface
echo -e "setup loopback interface\n"
ip -n client1 link set lo up
ip -n client2 link set lo up
ip -n server link set lo up
ip -n firewall link set lo up

#check ip address
echo -e "check ip address\n"
ip -n client1 addr
ip -n client2 addr
ip -n server addr
ip -n firewall addr


#check routing table
echo -e "check routing table\n"
ip netns exec client1 route
ip netns exec client2 route
ip netns exec server route
ip netns exec firewall route

#execute commands in a given namespaces and view links
echo -e "execute commands in a given namespaces and view links\n"
ip -n client1 link list
ip -n client2 link list
ip -n server link list
ip -n firewall link list

END_COMMENT
