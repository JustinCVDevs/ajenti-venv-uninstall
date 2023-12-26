#!/bin/bash

msg()
{
    message=$1
    echo
    # Bold and green font
    echo -e "\e[1m\e[92m$message\e[39m\e[0m"
    echo
}

msg ":: Uninstalling Ajenti"

# Stop Ajenti service if it's running
if systemctl is-active --quiet ajenti; then
    systemctl stop ajenti
fi

# Remove Ajenti service
if [ -e /etc/systemd/system/ajenti.service ]; then
    systemctl disable ajenti
    rm /etc/systemd/system/ajenti.service
    systemctl daemon-reload
fi

# Remove Upstart service
if [ -e /etc/init/ajenti.conf ]; then
    rm /etc/init/ajenti.conf
fi

# Remove sysvinit service
if [ -e /etc/init.d/ajenti ]; then
    /etc/init.d/ajenti stop
    rm /etc/init.d/ajenti
fi

# Deactivate and remove virtual environment
if [ -d /opt/ajenti ]; then
    source /opt/ajenti/bin/activate
    deactivate
    rm -rf /opt/ajenti
fi

# Uninstall Ajenti packages$PYTHON3 -m pip uninstall -y ajenti-panel ajenti.plugin.core ajenti.plugin.dashboard ajenti.plugin.settings ajenti.plugin.plugins ajenti.plugin.notepad ajenti.plugin.terminal ajenti.plugin.filemanager ajenti.plugin.packages ajenti.plugin.services

msg ":: Ajenti has been uninstalled"

# Remove any remnants from $PATH
export PATH=$(echo $PATH | sed -e 's/:\/opt\/ajenti\/bin//')

msg ":: Complete"

