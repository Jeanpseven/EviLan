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

# Solicita a entrada do usuário para a interface e o endereço do roteador
read -p "Digite a interface de rede (exemplo: eth0, wlan0): " iface
read -p "Digite o endereço do roteador (exemplo: 192.168.1.1): " router

# Executa o comando netdiscover para escanear a rede
echo "Iniciando a varredura na rede $router/24..."
sudo netdiscover -i "$iface" -r "$router"/24
