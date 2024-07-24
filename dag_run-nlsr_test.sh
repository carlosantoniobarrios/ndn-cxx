#! /bin/bash


#----- THIS ONLY NEEDS TO BE RUN ONCE --------------------
#cd ~/ndn/ndn-cxx
#./waf clean
#./waf
#sudo ./waf install
#nfd-start
#---------------------------------------------------------



username=cabeee

lenovoWiFiIP=192.168.20.143
lenovoETHIP=192.168.20.144
jetsonETHIP=192.168.20.145
rPi4ETHIP=192.168.20.146
rPi4WiFiIP=192.168.20.147
rtr1ETHIP=192.168.20.150
rtr1WiFiIP=192.168.20.151
rtr2ETHIP=192.168.20.152
rtr2WiFiIP=192.168.20.153
rtr3ETHIP=192.168.20.154
rtr3WiFiIP=192.168.20.155

lenovoETHMAC=d8:cb:8a:bc:a3:94
rPi4ETHMAC=d8:3a:dd:2e:c5:1f
rtr1ETHMAC=b8:27:eb:19:bf:bf
rtr1USBETHMAC=a0:ce:c8:cf:24:17
rtr2ETHMAC=b8:27:eb:be:80:60
rtr2USBETHMAC=00:50:b6:58:01:ed
rtr3ETHMAC=b8:27:eb:13:9e:0a
rtr3USBETHMAC=00:14:d1:b0:24:ed
jetsonETHMAC=00:00:00:00:00:01
jetsonUSBETHMAC=00:10:60:b1:f1:1b

lenovoETHinterface=eno1
rPi4ETHinterface=eth0
rtr1ETHinterface=eth0
rtr1USBETHinterface=enxa0cec8cf2417
rtr2ETHinterface=eth0
rtr2USBETHinterface=enx0050b65801ed
rtr3ETHinterface=eth0
rtr3USBETHinterface=enx0014d1b024ed
jetsonETHinterface=eth0
jetsonUSBETHinterface=eth1

sleep=0.1

#clear


# to run <command> remotely:
#ssh <username>@<ip_address> "nohup <command> >/dev/null 2>/dev/null </dev/null &"
# or
#ssh <username>@<ip_address> "<command> >/dev/null 2>&1 &"

# stop NFD on all devices to clear caches and forwarding table entries
ssh ${username}@${rPi4WiFiIP} "nfd-stop >/dev/null 2>&1 &"
ssh ${username}@${rtr1WiFiIP} "nfd-stop >/dev/null 2>&1 &"
ssh ${username}@${jetsonETHIP} "nfd-stop >/dev/null 2>&1 &"

# start NFD on all devices
ssh ${username}@${rPi4WiFiIP} "nfd-start >/dev/null 2>&1 &"
ssh ${username}@${rtr1WiFiIP} "nfd-start >/dev/null 2>&1 &"
ssh ${username}@${jetsonETHIP} "nfd-start >/dev/null 2>&1 &"


# create the faces
sleep ${sleep}; ssh ${username}@${rPi4WiFiIP} "nfdc face create remote ether://[${rtr1ETHMAC}] local dev://${rPi4ETHinterface} persistency permanent >/dev/null 2>&1 &"
sleep ${sleep}; ssh ${username}@${rtr1WiFiIP} "nfdc face create remote ether://[${rPi4ETHMAC}] local dev://${rtr1ETHinterface} persistency permanent >/dev/null 2>&1 &"
sleep ${sleep}; ssh ${username}@${rtr1WiFiIP} "nfdc face create remote ether://[${jetsonUSBETHMAC}] local dev://${rtr1USBETHinterface} persistency permanent >/dev/null 2>&1 &"
sleep ${sleep}; ssh ${username}@${jetsonETHIP} "nfdc face create remote ether://[${rtr1USBETHMAC}] local dev://${jetsonUSBETHinterface} persistency permanent >/dev/null 2>&1 &"


# add routes for all the PREFIXes to all nodes
#sleep ${sleep}; ssh ${username}@${rPi4WiFiIP} "nfdc route add /interCACHE ether://[${rtr1ETHMAC}] >/dev/null 2>&1 &"

#sleep ${sleep}; ssh ${username}@${rtr1WiFiIP} "nfdc route add /interCACHE ether://[${rtr1ETHMAC}] >/dev/null 2>&1 &"
#sleep ${sleep}; ssh ${username}@${rtr1WiFiIP} "nfdc route add /interCACHE/sensor ether://[${jetsonUSBETHMAC}] >/dev/null 2>&1 &"
#sleep ${sleep}; ssh ${username}@${rtr1WiFiIP} "nfdc route add /interCACHE/service2 ether://[${jetsonUSBETHMAC}] >/dev/null 2>&1 &"
#sleep ${sleep}; ssh ${username}@${rtr1WiFiIP} "nfdc route add /interCACHE/service4 ether://[${jetsonUSBETHMAC}] >/dev/null 2>&1 &"

#sleep ${sleep}; ssh ${username}@${jetsonETHIP} "nfdc route add /interCACHE ether://[${jetsonUSBETHMAC}] >/dev/null 2>&1 &"
#sleep ${sleep}; ssh ${username}@${jetsonETHIP} "nfdc route add /interCACHE/service1 ether://[${rtr1USBETHMAC}] >/dev/null 2>&1 &"
#sleep ${sleep}; ssh ${username}@${jetsonETHIP} "nfdc route add /interCACHE/service3 ether://[${rtr1USBETHMAC}] >/dev/null 2>&1 &"





# 4 DAG - interCACHE Forwarder
# start producer application
#sleep ${sleep}; ssh ${username}@${jetsonETHIP} "~/ndn/ndn-cxx/build/examples/cabeee-custom-app-producer /interCACHE /sensor >/dev/null 2>&1 &"
# start forwarder application(s)
#sleep ${sleep}; ssh ${username}@${rtr1WiFiIP} "~/ndn/ndn-cxx/build/examples/cabeee-dag-forwarder-app /interCACHE /service1 >/dev/null 2>&1 &"
#sleep ${sleep}; ssh ${username}@${jetsonETHIP} "~/ndn/ndn-cxx/build/examples/cabeee-dag-forwarder-app /interCACHE /service2 >/dev/null 2>&1 &"
#sleep ${sleep}; ssh ${username}@${rtr1WiFiIP} "~/ndn/ndn-cxx/build/examples/cabeee-dag-forwarder-app /interCACHE /service3 >/dev/null 2>&1 &"
#sleep ${sleep}; ssh ${username}@${jetsonETHIP} "~/ndn/ndn-cxx/build/examples/cabeee-dag-forwarder-app /interCACHE /service4 >/dev/null 2>&1 &"







sleep ${sleep}; ssh ${username}@${rPi4WiFiIP} "sudo nlsr -f ~/ndn/NLSR/nlsr.conf >/dev/null 2>&1 &"
sleep ${sleep}; ssh ${username}@${jetsonETHIP} "sudo nlsr -f ~/ndn/NLSR/nlsr.conf >/dev/null 2>&1 &"
sleep ${sleep}; ssh ${username}@${rtr1WiFiIP} "sudo nlsr -f ~/ndn/NLSR/nlsr.conf >/dev/null 2>&1 &"




sleep 1


# start consumer application (not in the background, so that we see the final print statements)
#sleep ${sleep}; ssh ${username}@${rPi4WiFiIP} "~/mini-ndn/dl/ndn-cxx/build/examples/cabeee-custom-app-consumer /interCACHE ~/mini-ndn/workflows/4dag.json 0"







# stop NFD on all devices
#ssh ${username}@${rPi4WiFiIP} "nfd-stop >/dev/null 2>&1 &"
#ssh ${username}@${rtr1WiFiIP} "nfd-stop >/dev/null 2>&1 &"
#ssh ${username}@${jetsonETHIP} "nfd-stop >/dev/null 2>&1 &"



