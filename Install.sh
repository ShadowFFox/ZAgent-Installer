#!/bin/bash

# Zabbix Agent installation script
# Made by Shady Iceyrn (Felipe Martins)
# Helpful hand to hypervisor installations


# ROOT USER CHECK
    if ! [ $(id -u) = 0 ]; then
        echo "The script need to be run as root." >&2
        exit 1
    fi

    if [ $SUDO_USER ]; then
        real_user=$SUDO_USER
    else
        real_user=$(whoami)
    fi

# STARTUP TEXT
    clear
    echo "Zabbix Installation Script (Ubuntu 20.04)"
    echo "Helpful hand to hypervisor installations"
    echo " "    
    echo "Made to be used in Ubuntu 20.04"
    echo " "
    echo " "
    echo " "
# BETA SCRIPT WARNING
    echo "Warning, this is a betta/test script. May have bugs"

# INPUT OF VARIABLES
    # Zabbix agent hostname catch - $hostname
        read -p 'Tell me the hostname of Zabbix Agent machine:  ' hostname

    # Zabbix server and server active ip catch - $ip
        read -p 'Now, i need the IP of Zabbix Server machine:  ' ip

# AGENT INSTALLATION
    
    # Downloading repository
        wget https://repo.zabbix.com/zabbix/5.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.4-1+ubuntu20.04_all.deb
    
    # Installing repository
        sudo dpkg -i zabbix-release_5.4-1+ubuntu20.04_all.deb
    
    # Updating operational system and installing the agent
        sudo apt update
        sudo apt upgrade -y
        sudo apt install zabbix-agent -y

    # Creating correct config file
        sudo rm /etc/zabbix/zabbix_agentd.conf
        printf "Server=$ip\nServerActive=$ip\nHostname=$hostname" >> /etc/zabbix/zabbix_agentd.conf    
    
    # Enable auto start at system boot
        sudo systemctl restart zabbix-agent
        sudo systemctl enable zabbix-agent
    
    # Removing junk .deb downloaded file
        rm ~/zabbix-release_5.4-1+ubuntu20.04_all.deb