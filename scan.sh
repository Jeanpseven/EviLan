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

# Solicita a entrada do usuário para a interface de rede
read -p "Digite a interface de rede (exemplo: wlan0, wlan1): " iface

# Verifica se a interface está disponível
if [ -z "$iface" ]; then
    echo "Nenhuma interface foi inserida! Saindo..."
    exit 1
fi

# Executa o comando airodump-ng com a interface fornecida
sudo airodump-ng "$iface"
