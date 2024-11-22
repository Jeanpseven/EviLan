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

# Solicita a entrada do usuário para o BSSID, canal, arquivo de saída e interface
read -p "Digite a interface de rede (exemplo: wlan0): " iface
read -p "Digite o BSSID do roteador (exemplo: XX:XX:XX:XX:XX:XX): " bssid
read -p "Digite o canal do roteador (exemplo: 6): " channel
read -p "Digite o nome do arquivo de saída (exemplo: captura): " output_file

# Executa o comando airodump-ng para detectar dispositivos na rede
sudo airodump-ng --bssid "$bssid" --channel "$channel" --write "$output_file" "$iface"

echo "Detecção concluída. A saída foi salva no arquivo: ${output_file}-01.csv"
