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

# Solicita a entrada do usuário para o arquivo .cap e a wordlist
read -p "Digite o caminho para o arquivo .cap: " capfile
read -p "Digite o caminho para a wordlist: " wordlist

# Verifica se os arquivos foram fornecidos e existem
if [ ! -f "$capfile" ]; then
    echo "Arquivo .cap não encontrado! Saindo..."
    exit 1
fi

if [ ! -f "$wordlist" ]; then
    echo "Wordlist não encontrada! Saindo..."
    exit 1
fi

# Executa o comando aircrack-ng para tentar crackear o handshake
sudo aircrack-ng "$capfile" -w "$wordlist"
