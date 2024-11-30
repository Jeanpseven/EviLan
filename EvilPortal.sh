#!/bin/bash

# Solicitar entradas do usuário
read -p "Digite a interface de rede para o AP (ex: wlan0): " interface_ap
read -p "Digite o SSID para o AP falso: " ssid_ap
read -p "Digite a interface conectada à rede com acesso à internet (ex: eth0): " interface_internet
read -p "Digite o range DHCP (ex: 192.168.10.10,192.168.10.50): " dhcp_range
read -p "Digite o conteúdo para a página index.html (ex: '<h1>Bem-vindo ao portal</h1>'): " pagina_web

# Instalar as ferramentas necessárias
echo "Instalando ferramentas necessárias..."
apt install hostapd dnsmasq iptables apache2 -y

# Criar o arquivo de configuração do hostapd
echo "Configurando hostapd...(/etc/hostapd/hostapd.conf)"
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
echo "Configurando dnsmasq...(/etc/dnsmasq.conf)"
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

# Criar a página web index.html
echo "Configurando a página web...(/var/www/html/index.html)"
echo "$pagina_web" > /var/www/html/index.html

# Configurar redirecionamento com Apache
echo "Configurando o Apache para o captive portal...(/etc/apache2/sites-available/000-default.conf)"
cat <<EOT > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
        # Redirecionamento para Android
        Redirect "/generate_204" http://192.168.10.1/index.html

        # Redirecionamento para dispositivos Apple
        Redirect "/hotspot-detect.html" http://192.168.10.1/index.html

        # Configuração de ErrorDocument como fallback
        ErrorDocument 404 /index.html

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOT

# Reiniciar os serviços
echo "Reiniciando hostapd e apache2..."
systemctl restart hostapd
systemctl restart apache2

# Configurar redirecionamento para o servidor web
echo "Configurando IPTABLES para redirecionar tráfego HTTP/HTTPS para o portal..."
iptables -t nat -A PREROUTING -i $interface_ap -p tcp --dport 80 -j DNAT --to-destination 192.168.10.1:80
iptables -t nat -A PREROUTING -i $interface_ap -p tcp --dport 443 -j DNAT --to-destination 192.168.10.1:80

echo "Portal captivo configurado com sucesso. O tráfego HTTP/HTTPS será redirecionado para a página personalizada."
