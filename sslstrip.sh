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

# Define as portas padrão
portainicial=80
portadestino=8080

# Solicita a entrada do usuário caso deseje usar portas diferentes
read -p "Digite a porta inicial (padrão 80): " user_portainicial
read -p "Digite a porta de destino (padrão 8080): " user_portadestino

# Se o usuário não inserir valores, usa os padrões
portainicial=${user_portainicial:-$portainicial}
portadestino=${user_portadestino:-$portadestino}

# Exibe as configurações
echo "Configurando o redirecionamento de porta:"
echo "Porta inicial: $portainicial"
echo "Porta de destino: $portadestino"

# Executa o comando iptables para redirecionar o tráfego TCP
sudo iptables -t nat -A PREROUTING -p tcp --dport "$portainicial" -j REDIRECT --to-port "$portadestino"

# Exibe uma mensagem de sucesso
echo "Redirecionamento configurado com sucesso de porta $portainicial para porta $portadestino."
