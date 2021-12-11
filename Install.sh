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
    echo "Zabbix Installation Script"
    echo "Helpful hand to hypervisor installations"
    echo " "    
    echo "Made to be used in Ubuntu 20.04 and CentOS 8"
    echo " "
    echo " "
    echo " "
# BETA SCRIPT WARNING
    echo "Warning, this is a betta/test script. May have bugs"
    echo " "
    read -p "Press [ENTER] to continue"

# INPUT OF VARIABLES
    clear
    # Zabbix agent hostname catch - $hostname
        read -p 'Tell me the hostname of Zabbix Agent machine:  ' hostname

    # Zabbix server and server active ip catch - $ip
        read -p 'Now, i need the IP of Zabbix Server machine:  ' ip

    # Operational system selection - $system
        read -p 'Select the installation system [1 - Ubuntu 20.04 | 2 - CentOS 8]: ' system

# AGENT INSTALLATION
    clear

    if [ $system = "1" ]; then
        # Downloading repository
            echo "Downloading Repository..."
            wget https://repo.zabbix.com/zabbix/5.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.4-1+ubuntu20.04_all.deb
        
        # Installing repository
            echo "Installing Repository..."
            sudo dpkg -i zabbix-release_5.4-1+ubuntu20.04_all.deb
        
        # Updating operational system and installing the agent
            echo "Installing System Updates..."        
            sudo apt update
            sudo apt upgrade -y
            echo "Installing Zabbix Agent..."            
            sudo apt install zabbix-agent -y
    else
        if [ $system = "2" ]; then
            # Downloading repository
                echo "Downloading Repository..."
                rpm -Uvh https://repo.zabbix.com/zabbix/5.4/rhel/8/x86_64/zabbix-release-5.4-1.el8.noarch.rpm
                dnf clean all

            # Installing zabbix agent
                echo "Installing Zabbix Agent..."        
                dnf install zabbix-agent
        else
            clear
            echo "Invalid system selected, please select 1 for Ubuntu 20.04 or 2 for CentOS 8" >&2 
            exit 1
        fi
    fi

    # Creating correct config file
        sudo rm /etc/zabbix/zabbix_agentd.conf
        printf "Server=$ip\nServerActive=$ip\nHostname=$hostname" >> /etc/zabbix/zabbix_agentd.conf    
        sudo systemctl restart zabbix-agent
    # Enable auto start at system boot
        sudo systemctl enable zabbix-agent

# ENDING
    read -p "That's all folks! Script ended :)"
    clear
