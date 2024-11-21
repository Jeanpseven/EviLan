#!/bin/bash

# Exibe o banner
echo "  _____           _  _____           "
echo " |  __ \         | |/ ____|          "
echo " | |  | | ___  __| | (___   ___  ___ "
echo " | |  | |/ _ \/ _' |\___ \ / _ \/ __|"
echo " | |__| |  __/ (_| |____) |  __/ (__ "
echo " |_____/ \___|\__,_|_____/ \___|\___|"
echo "                                     "
echo "                                     "

# Solicita a entrada do usuário para a interface de rede, BSSID e canal
read -p "Digite a interface de rede (exemplo: wlan0, wlan1): " iface
read -p "Digite o BSSID da rede alvo (exemplo: 00:11:22:33:44:55): " bssid
read -p "Digite o canal da rede (padrão: 1): " channel

# Se o canal não for inserido, define o canal padrão como 1
if [ -z "$channel" ]; then
    channel=1
fi

# Verifica se a interface foi fornecida
if [ -z "$iface" ] || [ -z "$bssid" ]; then
    echo "Interface ou BSSID não inserido! Saindo..."
    exit 1
fi

# Executa o comando airodump-ng com os parâmetros fornecidos para capturar o handshake
sudo airodump-ng "$iface" --bssid "$bssid" --channel "$channel" -w handshake
