#!/bin/bash

cat res/banner

# Solicitar entradas do usuário
read -p "Digite a interface de rede para o AP (ex: wlan0): " interface_ap
read -p "Digite o SSID para o AP falso: " ssid_ap
read -p "Digite a interface conectada à rede com acesso à internet (ex: eth0): " interface_internet
read -p "Digite o range DHCP (ex: 192.168.10.10,192.168.10.50): " dhcp_range

# Instalar as ferramentas necessárias
echo "Instalando ferramentas necessárias..."
apt install hostapd dnsmasq iptables -y

# Criar o arquivo de configuração do hostapd
echo "Configurando hostapd..."
cat <<EOT > /etc/hostapd/hostapd.conf
interface=$interface_ap
driver=nl80211
ssid=$ssid_ap
hw_mode=g
channel=6
ieee80211n=1
wmm_enabled=1
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0
EOT

# Configurar o hostapd para usar o arquivo de configuração
echo "Configurando hostapd para usar arquivo de configuração..."
echo 'DAEMON_CONF="/etc/hostapd/hostapd.conf"' >> /etc/default/hostapd

# Configurar o dnsmasq
echo "Configurando dnsmasq..."
cat <<EOT > /etc/dnsmasq.conf
interface=$interface_ap
dhcp-range=$dhcp_range,12h
dhcp-option=3,192.168.10.1
dhcp-option=6,192.168.10.1
server=8.8.8.8
log-queries
log-dhcp
EOT

# Definir endereço estático para a interface do AP
echo "Definindo IP estático para a interface $interface_ap..."
ip addr add 192.168.10.1/24 dev $interface_ap

# Habilitar redirecionamento de IP
echo "Habilitando redirecionamento de IP..."
sysctl -w net.ipv4.ip_forward=1

# Configurar IPTABLES para redirecionar o tráfego para a internet
echo "Configurando NAT com IPTABLES..."
iptables -t nat -A POSTROUTING -o $interface_internet -j MASQUERADE

# Iniciar serviços
echo "Iniciando serviços hostapd e dnsmasq..."
systemctl start hostapd
systemctl start dnsmasq

echo "O ponto de acesso falso está online e compartilhando a internet via $interface_internet."

# Analisar tráfego com Wireshark
echo "Você pode agora capturar o tráfego de rede com sua interface em modo monitor usando ferramentas como Wireshark."

# Exibir clientes conectados
echo "Use o comando 'arp' para ver os clientes conectados e realizar ARP spoofing."
