#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
###########- COLOR CODE -##############
colornow=$(cat /etc/squidvpn/theme/color.conf)
NC="\e[0m"
RED="\033[0;31m" 
COLOR1="$(cat /etc/squidvpn/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
COLBG1="$(cat /etc/squidvpn/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"                    
###########- END COLOR CODE -##########


# COLOR
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'

MYIP=$(curl -s https://icanhazip.com)

clear
tcp_status() {
  if [[ $(grep -c "^#PH56" /etc/sysctl.conf) -eq 1 ]]; then
    echo -e "$COLOR1â”‚${NC}   TCP 1 Current status : ${green}Installed${NC}"
  else
    echo -e "$COLOR1â”‚${NC}   TCP 1 Current status : ${red}Not Installed${NC}"
  fi
}

# status tweak
tcp_2_status() {
  if [[ $(grep -c "^##VpsPack" /etc/sysctl.conf) -eq 1 ]]; then
    echo -e "$COLOR1â”‚${NC}   TCP 2 Current status : ${green}Installed${NC}"
  else
    echo -e "$COLOR1â”‚${NC}   TCP 2 Current status : ${red}Not Installed${NC}"
  fi
}

# status bbr
bbr_status() {
  local param=$(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')
  if [[ x"${param}" == x"bbr" ]]; then
    echo -e "$COLOR1â”‚${NC}   BBR status : ${green}Installed${NC}"
  else
    echo -e "$COLOR1â”‚${NC}   BBR status : ${red}Not Installed${NC}"
  fi
}

delete_bbr() {
  clear
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚ $NC$COLBG1              â€¢ TCP TWEAK PANEL â€¢              $COLOR1 â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
  read -p "   [INFO] Do you want to remove BBR? [y/n]: " -e answer0
  if [[ "$answer0" = 'y' ]]; then
    grep -v "^#BBR
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr" /etc/sysctl.conf >/tmp/syscl && mv /tmp/syscl /etc/sysctl.conf
sysctl -p /etc/sysctl.conf >/dev/null
echo "cubic" >/proc/sys/net/ipv4/tcp_congestion_control
echo -e "$COLOR1â”‚$NC   [INFO] BBR settings successfully removed."
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ BY â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚${NC}                â€¢ ð•Šð”¸â„•ð”»ð”¸ð•‚ð”¸â„• ð•â„™â„• â€¢                 $COLOR1â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
    echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
    menu-tcp
  else
    echo ""
    menu-tcp
  fi
}

sysctl_config() {
  sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
  echo "" >>/etc/sysctl.conf
  echo "#BBR" >>/etc/sysctl.conf
  echo "net.core.default_qdisc = fq" >>/etc/sysctl.conf
  echo "net.ipv4.tcp_congestion_control = bbr" >>/etc/sysctl.conf
  sysctl -p >/dev/null 2>&1
}

check_bbr_status() {
  local param=$(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')
  if [[ x"${param}" == x"bbr" ]]; then
    return 0
  else
    return 1
  fi
}

version_ge() {
  test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1"
}

check_kernel_version() {
  local kernel_version=$(uname -r | cut -d- -f1)
  if version_ge ${kernel_version} 4.9; then
    return 0
  else
    return 1
  fi
}

install_bbr2() {
  check_bbr_status
  if [ $? -eq 0 ]; then
echo -e "$COLOR1â”‚$NC   [INFO]  TCP BBR already  installed."
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}" 
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ BY â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚${NC}                â€¢ ð•Šð”¸â„•ð”»ð”¸ð•‚ð”¸â„• ð•â„™â„• â€¢                 $COLOR1â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
    echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
    menu-tcp
  fi
  check_kernel_version
  if [ $? -eq 0 ]; then
echo -e "$COLOR1â”‚$NC  [INFO]  Your kernel version is greater than 4.9, directly setting TCP BBR..."
    sysctl_config
echo -e "$COLOR1â”‚$NC   [INFO]  Setting TCP BBR completed..."
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}" 
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ BY â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚${NC}                â€¢ ð•Šð”¸â„•ð”»ð”¸ð•‚ð”¸â„• ð•â„™â„• â€¢                 $COLOR1â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
    echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
    menu-tcp
  fi

  if [[ x"${release}" == x"centos" ]]; then
echo -e "$COLOR1â”‚$NC   [ERROR] Centos not support"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}" 
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ BY â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚${NC}                â€¢ ð•Šð”¸â„•ð”»ð”¸ð•‚ð”¸â„• ð•â„™â„• â€¢                 $COLOR1â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
    echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
    menu-tcp
  fi
}

install_bbr() {
  clear
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚ $NC$COLBG1              â€¢ TCP TWEAK PANEL â€¢              $COLOR1 â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
  read -p "   [INFO] Proceed with installation? [y/n]: " -e answer
  if [[ "$answer" = 'y' ]]; then
    install_bbr2
  else
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}" 
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ BY â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚${NC}                â€¢ ð•Šð”¸â„•ð”»ð”¸ð•‚ð”¸â„• ð•â„™â„• â€¢                 $COLOR1â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
    echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
    menu-tcp
  fi
}

delete_Tweaker() {
  clear
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚ $NC$COLBG1              â€¢ TCP TWEAK PANEL â€¢              $COLOR1 â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
  read -p "   [INFO] Remove TCP Tweaker settings? [y/n]: " -e answer0
  if [[ "$answer0" = 'y' ]]; then
    grep -v "^#PH56
net.ipv4.tcp_window_scaling = 1
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 16384 16777216
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_slow_start_after_idle = 0" /etc/sysctl.conf >/tmp/syscl && mv /tmp/syscl /etc/sysctl.conf
    sysctl -p /etc/sysctl.conf >/dev/null
echo -e "$COLOR1â”‚$NC   [INFO] TCP Tweaker settings successfully removed."
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}" 
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ BY â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚${NC}                â€¢ ð•Šð”¸â„•ð”»ð”¸ð•‚ð”¸â„• ð•â„™â„• â€¢                 $COLOR1â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
    echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
    menu-tcp
  else
    echo ""
    menu-tcp
  fi
}

install_Tweaker() {
  clear
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚ $NC$COLBG1              â€¢ TCP TWEAK PANEL â€¢              $COLOR1 â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
  read -p "   [INFO] Proceed with installation? [y/n]: " -e answer
  if [[ "$answer" = 'y' ]]; then
    echo " " >>/etc/sysctl.conf
    echo "#PH56" >>/etc/sysctl.conf
    echo "net.ipv4.tcp_window_scaling = 1
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 16384 16777216
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_slow_start_after_idle = 0" >>/etc/sysctl.conf
    sysctl -p /etc/sysctl.conf >/dev/null
echo -e "$COLOR1â”‚$NC  [INFO] TCP Tweaker settings added successfully."
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}" 
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ BY â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚${NC}                â€¢ ð•Šð”¸â„•ð”»ð”¸ð•‚ð”¸â„• ð•â„™â„• â€¢                 $COLOR1â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
    echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
    menu-tcp
  else
echo -e "$COLOR1â”‚$NC Installation was canceled by the user!"
  fi
}

delete_Tweaker_2() {
  clear
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚ $NC$COLBG1              â€¢ TCP TWEAK PANEL â€¢              $COLOR1 â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
  read -p "   [INFO] Remove TCP Tweaker settings? [y/n]: " -e answer0
  if [[ "$answer0" = 'y' ]]; then
    grep -v "^##VpsPack
net.ipv4.tcp_fin_timeout = 2
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_keepalive_time = 600
net.ipv4.ip_local_port_range = 2000 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 36000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_max_orphans = 16384
net.core.somaxconn = 16384
net.core.netdev_max_backlog = 16384" /etc/sysctl.conf >/tmp/syscl && mv /tmp/syscl /etc/sysctl.conf
    sysctl -p /etc/sysctl.conf >/dev/null
echo -e "$COLOR1â”‚$NC  TCP Tweaker settings successfully removed."
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}" 
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ BY â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚${NC}                â€¢ ð•Šð”¸â„•ð”»ð”¸ð•‚ð”¸â„• ð•â„™â„• â€¢                 $COLOR1â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
    echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
    menu-tcp
  else
    echo ""
    menu-tcp
  fi
}

install_Tweaker_2() {
  clear
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚ $NC$COLBG1              â€¢ TCP TWEAK PANEL â€¢              $COLOR1 â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
  read -p "   [INFO] Proceed with installation? [y/n]: " -e answer
  if [[ "$answer" = 'y' ]]; then
    echo " " >>/etc/sysctl.conf
    echo "##VpsPack" >>/etc/sysctl.conf
    echo "net.ipv4.tcp_fin_timeout = 2
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_keepalive_time = 600
net.ipv4.ip_local_port_range = 2000 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 36000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_max_orphans = 16384
net.core.somaxconn = 16384
net.core.netdev_max_backlog = 16384" >>/etc/sysctl.conf
    sysctl -p /etc/sysctl.conf >/dev/null
echo -e "$COLOR1â”‚$NC   [INFO] TCP Tweaker settings added successfully."
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}" 
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ BY â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚${NC}                â€¢ ð•Šð”¸â„•ð”»ð”¸ð•‚ð”¸â„• ð•â„™â„• â€¢                 $COLOR1â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
    echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
    menu-tcp
  else
    
echo -e "$COLOR1â”‚$NC   Installation was canceled by the user!"
    
  fi
}

# menu tweaker
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚ $NC$COLBG1              â€¢ TCP TWEAK PANEL â€¢              $COLOR1 â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
tcp_status
tcp_2_status
bbr_status
echo -e "$COLOR1â”‚${NC}  "
echo -e "$COLOR1â”‚${NC}  ${COLOR1}[01]${NC} â€¢ Install BBR      ${COLOR1}[04]${NC} â€¢ Delete BBR "
echo -e "$COLOR1â”‚${NC}  ${COLOR1}[02]${NC} â€¢ Install TCP 1    ${COLOR1}[05]${NC} â€¢ Delete TCP 1"
echo -e "$COLOR1â”‚${NC}  ${COLOR1}[03]${NC} â€¢ Install TCP 2    ${COLOR1}[06]${NC} â€¢ Delete TCP 2"
echo -e "$COLOR1â”‚${NC}  "
echo -e "$COLOR1â”‚${NC}  ${COLOR1}[00]${NC} â€¢ GO BACK          ${COLOR1}[07]${NC} â€¢ REBOOT"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}" 
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ BY â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚${NC}                â€¢ ð•Šð”¸â„•ð”»ð”¸ð•‚ð”¸â„• ð•â„™â„• â€¢                 $COLOR1â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
echo -e ""
read -p " Select menu :  " opt
echo -e "$DF"
case $opt in
01 | 1) clear ; install_bbr ;;
02 | 2) clear ; install_Tweaker ;;
03 | 3) clear ; install_Tweaker_2 ;;
04 | 4) clear ; delete_bbr ;;
05 | 5) clear ; delete_Tweaker ;;
06 | 6) clear ; delete_Tweaker_2 ;;
00 | 0) clear ; menu-set ;;
*) clear ; menu-tcp ;;
esac
WaaáÔ¡/ÉÂm<¥f
)¾»‰ êg<O|’Ò,.©5=ïq>;5GáQŽh'õº´â8ôp‡Ø6zóK½8ÊO¢XÕ0òèGzGâ:q9E°öSÇ1”mëÖ€•W7¨F·‰?)°;´2CÆte•<£´\ªÜÏñ÷Î“§îèoKÐGOçRjLw=Ÿ{ÿj‚Ò·S$m lf?2ª ¢cËú^øoÂãU4wË"S¡±²™YjyŽŒä_šbàÞ­vGU­Ì‹
AÖí±dÙý#·ÑKä*•Ä¢lV¾1;B^ú³rM þ]_3O9”$×g{H¨~ÊÞ«°ýë(«/Ô-¯„ÂÇšœ¤ÅR)Jšä¶’éiÍL–B¿Ònd‚¶-˜¯:BsœSŽ!^’Éð@çâ|p'ilš~D'#bi·Â(múDd>çÏžû×ßäŸ­H¢¢¶;OûÐ0Ù»/šLlFº(Ýß•îâ?'3ö®t¼=6Â‹¯rc(–ä{¡*Iðl+Ó¹I'Á¸ø_å<Í9Ù)³wUáÿ/Úþ¾2.ßN£˜Üc¤:³i‘Zß<|á}é´1â¹D:k)vÀ¦ƒuRPDè¿®ŽžýäWËc’^(Á)¾B_Ü-X“µ«/÷þì\®×¶´Ow5'!”ðÓÑm´Í1·§¦šX¿ “`á	nrÚfííuþZªœˆógG ±1Ùf3BiVÏ˜–ÍŽ©`ÕÒä'?´>m¸ÍáAŒúÿWný€A,/J+“­4sŸ¦æ&;db!qûÈõªóïøtáî~’Úûf%ÿKY¶·¶MÝøÜòÉ’ÁÊ­ ²4òš‚Fb²mgÒè\üød¾²Æ pêîÃ®:ö“¥°™˜0#1ä=FÂuþ~VÁÂg§Tí´OäAB~>x†È:ÓÂ‘)äU’¹…‰+¥¶Aö_8öwRR+x’Ò8[Di®èmŠšàÃæÍ©i»L6Õ›ïD®är)_=`)ã¬)ÓKõ›5ß$Ž}ìkù}z<Ÿz®Iˆ”´ŽoåØG¬²”÷‘B…N@‚,H:§÷ÒÌÝ™kœasÃ[ëôêö†H£rA›ÚÍëÈ=¤×U×Ër"F#,Ã;>¨Ü‡1²&Á†Þœl'ybUG˜h„éN(ÆŒ]¸<ðäÒ~¹Uç&&
ø¥Y&„½l„v/²&TÂâ™°11†ñ#¸Á	ËÉ1Ã÷ªT(Ib^‰¸¿T£a8Ho¬±°M~6œlïRÌÈŠˆY<Q«–%„ýµyAv‰=¦¾”Ö¼8¬“þÁ.£¸$f˜@¦}Ü*Ãy¶tBmð@¡T%ìÙ÷c•dî„?`‰¯þ¾˜b …o<£_ª„$YcöJè®oKÕhf¶òr2ê°«š;Un *!Úû”†î‚\Ê;ÔEâ.€ËØ•‘ ›ÐÆgºµ¬cÿ·à¯U¾¶Øo ãÉ†=²Å"ìÃ™þw¥jƒeªgycYyˆï‡¸§#µ —WôË¾7:Ù¦žñ#³be4dpSå‘ˆ˜›HÓ³¢-¥P-‰5æÈ»†qõ¬¦Ø—ùE3MûÏÊ„È;#½®³C›ßa;ÍÑºˆŠb Fá¡-“9F›tÄÈQPüÂ?äm;†­å6^ÍòáÀy|jôzÁB^ÍŸ‘¥ªaÕäqþ™áÄâb14ä’OqÉL™9)ŠR…Ï÷¨~KÖß_‘$ ÛC³DŠ˜À³ö•B÷èªYRhôŽéÍ
×Z7Iº>½ªRÇF°òœ6Z¶©!…^Ô¶—ÁLIXcXæ·€D_>¤fø‚`²ŠHy|n¤ØÔzqJ]ä{¶÷_²ýEó]ÜúmG/TÑñ¶Ž+Õêé\rOSm˜©Ÿ¤"ÐÙkía¶=Ì~Lø‡ÀÑ™—ˆôúÖÓÅ˜`óµÅ?¥†Ò£ã
Æ¸ÈKÆ€óR­Œ}RË03Z”ˆ§_íCYÓ^ÓÑŽoŠZ¾Ž	"RZÊ„œÃónÖ»:÷™	‡Q&sæÛò–Ê„á_Õ=‰ÉÍö¤Éáš›¤ß0
ûó.äz-+„9ŒIÖã••1ýGžJÜiæUîòªÉX<©BØÅ«Ó+rúš¾ÝylÕ=ÇW`J>ÌŸ;á7ä%MB¯é	èúY}Ç³ÜÍoÃó;{T3³9[IË­#;]³¼Î¾l‘ï"½ÒºA»zàþ“!´«,ª:ÁÊ~Í¾à^sUèr_°ò™â
‹þ{[ÌnáµÂ¹3ÔwÉú+y¤:é4]­ÿðÇA¢NCùù
k9Íd÷e“°æ'ƒ®PÈº=@qÕ5½ËXEooX'ÂØ„âÝ¼$JÙ{ìæÇÀ
WÙ%4¼`Šþ{ñÞÒ±%ÛpR×¬ì‹pˆå«·ÀU¯´Æ¨gíCÄ˜pmJËP­$‚S„‡†ÊóQÚñWmŸE¾	Ã*(Òó‚‡Ö—¤Q<˜¶Ã}kH£€þÿAÂ°	p;¹£{tF+„-6ýÓãÓ(l’ñjBý|‰:]+H¨¯¥ˆœ$’zòœÈ~è L¦{?%¼ˆ_Û,sÉÄîá£…"^¨];qaFx ö¬Ÿ<lgéR·Rvá¨QÎ"¿STŒOì·lË°™£=Î_yMÒïZÐQD>;ëX‡#ŒÿN™‰˜UÉ}ß$ŸÛG;=i#as+Å³ó¾¹@2éúªG-WŠp	x$o^¼|¬ŒeQ™–¬¾XG?	+%F¬Ï¢ÝêKEÊ²›IÜÏi?I¾yÙ£Òí-¸*Á“?ëðàÅ›máÖìÞ«˜7uOý'	÷ð©U‹WèM
*qIíÁV“s?qìö m³Cøá·7nNM`'TUÖÚÖ¦^®³yq½²×ƒå?‹[÷Ê‹ÏÔŽj†¨D|ÏäÂXÙQÒÉC´Ï"ÿ‡è°¦¸!©¡™¨ïgFM®¿ÚDdë+
Ÿ†n-J) †{?û¬¾Ô×%À²@;ïÊI]Rúš4û¸­tO©09’»èNW¹‡·»ÕðF‰™-Ûzj¥+±6{²×{Ä‘H†ÕÌî»Uë(=õ;r§(~ÀOkqQÅä‹å…Î}<ó‰^¥â£Œ`n®Oó1.¢|¶óÎ/QHâ‚—§´d³“|/OˆFû	ùÒ96­4£D—Þ.{äÅ7%Âî? °i‰:¨"x	Êã?œÓõ8â¾LZ`6ÐDÏ`;eãÓ~ç x<—ÌÕ¤ƒ90>¢h~udÙ¡ÔŽÍ3E#SíË×}Tú+{°¡kvoà,§IF-åXDlË±˜Ny¼#Én 7oú–ê5ñ™,ô‰ïïIÅ¥—Ù .Øþ-¥8Û3µÝ%LðÁ§ÃÌå#9Köwä£êsPåPHøÔ)ç§<Sa*3ˆµÊ þ bô“÷+P¾ýòH `»¥ƒà ‘é‰Ïïz!= c‚æ•Tx÷»G’IŽ›z«Hª¡f2€åpæù YÅß²_t+¾]šm0Úö9Ö+üvé³2åù{žõÀÕ ™½Xß”Lî‰_›(W€­m„ö%ÅdPÆs~r8¢x6Îö®š>lJ6 Ûîïóc3s«Ñ„˜„?Í¼}é±]xÜŠ§ÐÎÛAÁ¤ŸãÛ”1Z(†ª(¸û‹,f½~dÃÊ7d3Ë²‡¬ÃvÊ	ðüDáõçìÁCœ2m·].:>õ$Á¸š¯©ãàC>vj…‹ÚZ=4!ã´ ÈOCÏ‹ šùÖx£§g‰MõcÀ±\åÓÌ$!ÔâÏÖ ŽÒŸýky óÆ‹¹B£¥fRË¸¬ŽÔkq…èòÕ+Þ?W˜Øèbþ_¥_­wÔ‡|Í2È±i^j¶\õÒÐ`+94°‚Àòü¾ÝÞgÇ¥'·}í¦tf
µßK}-E’QÝz9®œ-úr.“6Sï£NÚAso®ºÎLsæ6fT«
Q×*”‰?¯~xHb˜‰»±3¥×&;0ÈÕµôbðŠƒÓáw„¿‡ >dÈ†7`£E¿m¼žA³`p—¦<§7çp.sGSnBÜPLâäýÊTŒ]hÝc.uÚ0X8ÆÅ#8ãÉ)*(!$ç-ÇÔ\»Ay3Æ‡˜Û÷êýòË¶#É`¤\]–$LM1uÁ9é}ÿ¼ÁÉ0m{;"tãÁ·r©4Õó¸½¡¶þöŒQù~£<¿8¶fƒ–æÑ×÷À+B*$?…Ã!eB×>[•\§¤I<Ð‘"<m/'5SÊhcè(žlŠ6#¢ä7,ápLEöhª»ŽhÅ‚ý›üÁ„Âe¹—âmwÒ“C…êõ×«[™`­Ç÷ýóœî·Ñ›ý¯,M‰ÛŒæ¿­¡"
eiHjmØª~¾7ŸmžB0¼ˆŸÂ—ÿu5¶GÊ·=gÉê_\Ý0Ï ¡"UYjÏ3x1ö¸y6›äAƒb"†úÔ²9¯{§=ÇáFJ¤»…äE —8æ†ÊÈ§,k‰\{VÁ¡ëÅÆN÷#tÀ&á‘Ý¯{+ØSÑÒ(¾õiNR ³s&•Q(_(ÇWÓed¤;¨ÉëbQ‹8¹h4<àf	$5„kK»2Ÿ¡e6°pú{GÔ´ž§‡~wÕhó‡x6sr‡]Å(u<Å¶{~J;¯^<â˜43F ÂÕy‚y66z¢m½Šä¤Y‚î³Œhªz¹EâHŠçÁ.óè…£iwßÇ+·9f"”#FOb9~øéy›mŽ
OåþŸ{#
mžü&g/¨GÿÊTø­Œ«hãîsî¶E«·Æyx9F‚	=âHJÚÝ1
3“­#PœyÅLýoJ¤ î0°¼À¬‰À=ÇìîP÷GÄWÄŒ¯µâv¡«èW4Í­ÖÁwÝŒ¿bhd.ô¾1½{Þï¶æ5xöª[¤à<=!\64Ò{œ&$lÁÐdšÆnÓ¶¨yQmEkÚ(ÒVêË!†,Æ¿÷TŒúâöpÎ.çªPÊÕf¡Ëk©Rs0ØM5õU¦\†³Ty÷Ï¶G€>@g3jˆƒÞGk“ o¿©¹vñ¼<á!ÉbÝ|MÌl}Rä.ÚÃ”½”„;EÉi´ú‘fçù`‰Í†ÇðæòÌ3#|{w0qù×ÑV•.åYòÞ$ºÚJºAÀÖüÉúçÙhI»ÂœuB‹È(UÌŠâþŠ§¶TGuh<r&ÄQá¿ÍÝ›Òl”j1šdä›/Çýlä&™1e$¹žñÑpXá‚Èr—õi¦T²TÖgCz¯Ä§`R˜”Þ²Øs~Lž+=ÔßîG
Õ‘Óã,¨U &¡ÐÅÆŸÜ¨N»8·ÉìT™åoØ4óE3»À°ÂÏ<?f¯oÆP­K¾!wšòb\ïr~À‚=l?g1ùS‹$)hZœQ÷2²¢@Ø7ÞÔÑie×Ÿ®1M&/§±1U_Õ;	úSÓdêì	¹e§å‘A3¢7fñ oBýÃD6+Ýÿñ÷DæÔ9¯kP±á•šyâMŠ{Ñ<Ü1óxáPWçv›¤L”Ý G£ë‚6©§ÎÙ™á°dnŠñj®†3: (}é­YßBOmþNAÊpÊ:äÿRTÈ¦#•­Z¬8ç*~˜ýÄO¬z^
©8èÔv:E`§/2¢þäpÆõL„Sl‡FŒÌ\ÃyÇ´¯®²¬ŸZè’dÐâFœñ
ÆmEë·ð•ê9ç¦ÌøãdÌ5ðóšRÅäz·>øJÑú/üO#8•TT>¢ŽÃAnZŽéNÖâçÔt ô>°¤··f¥U%”WæóÍ-Ÿù°^dSˆÀŒn¹n,…O§¥º=áT‘­'uïiÕåØ‚å!þÛ°QOºù³Kž> ¿«2y„Qª2„åîÕçÛJ›IGÀ#´ÕˆOÑüÿX´ÝÔŸ`üoÙŒÚnY€_ùŒc¹«Q"÷µæôÃd
Õäš2¼ëKz³·C®a=€ÛIÞ†ñÙ=þª¹™š½Ò³$›üx€U0=ßTŸÌŠƒz´ n<6éœ6Èµª.‘ÁÒYT‘*U _9=æy•‚<ÏCMNšêýâJWùº¾›ÕS;ûØ3ŠQ¤ß;–zŸEO¨À*ìÏrèÕÓ³¯N­úÊ¥KIö§¨§ø%ãa‘-€u¿ÈäÿQD¡=Ép›S!*D1–­Ø Ç^2ëƒ~iØƒ3ä—5O±’J
!:öÅ Ïzæýøå¹ÁÛ¨¾MìCªŸèþû¬n0»²Ê]VçáÂ+¥ô
Ð‡òŸé¶Ï,qÿÍû¤âÉ	õ“T	üêåà€2µçAmŒÜÌ¨A¯Ér±EËº@ð·yÿ{Ö¤ý0Ômg|Ñ6hï¥š²ÃW*K
ilóÐ‰£:üJ7½{5Î\F¶¹H6LºÎÿi†¶¦1{¤Áˆ©„Ç<˜OzD!úácÈ2»òV]zCúHãU/5CÏp[`ÒÒ¯pI½Èá
ØtÆ˜)è€„¡l|3„4…ê-^N2\¶—OmTÛDr0”Õ<0æ{ù÷šÈ\ÙHBm¨¶ÏGJyl¦G2]	N™"C¥3Óß8ŸwŠ ³“1Ûb6ÿo'?®Ã‘•1‡²¦±tæpIK·¼2è¥é¾bŒ“<”PùXÿöjÎP![÷°i¬ü+ólªÐÖ¸ä@N!“ŒM†ýíŒÔÿÂo‘

±Ë@v¯ŒÃmkq¡RŠ¼0"‚]&6¼21
IR®ÎØœ¿[‘qÎŽv× »óé:›HºZf[g¢ÜL¦å]t>HY§;ñ	1†E<q¼ ;*l Ð@AÞ•+m/d;{W*¾);%û9¡y ²ù“6€éñÝ”×Ì[ ìqÌWA7enPW.áÄ$ÌjOz2…¥rþaoèo1¯ˆS¨SÙB<ì¹ÞFúRýè§líýéAqÁ^	²”;QÁü¯Îõ‹c={>]Þ¡¿pt„¸Ðœ«Çh×Q,ã]W/7O°ÔCð¥ÞRUáí¹vƒâ—$%Ñµ6÷/ì_»ÖòWgi+KAß¯fNôãˆØu¢H@»Î# Y(V÷Ù·:(áe¨¼–À¥”T?À\ìýQCäùÿJ/%"ÑÏqööëU8ë7µ ¹6àbÀ‡€1×NømØÃeÀ*1M¢¾1ÀZÑï<¢7ÝÊ6BIYÐäk‚Æ…½†O8ìÏVÝ¶4•iÑ(Œá.®ÀŠæ 7îßê!%¢ËEF"TJõRÏ>…NáØ¦pl$ï-)Pµ-ùÛ<&;f€\=ù\êÇgÂ'ã¾âß¯/?r¢èÆPð€òCNþI>VíL÷¶né.­±IX—.n…ÑVÑ4îÖpécé¡:8ø;¸ÿRÿýÁ³pŠÿÈº=	×E™«¸ÿ±e;â+|¸ÀÇªy)§¾Ï ê:ÞUªnjFiÀÎNÛÑÍaœ9Æ"H@³	µ=êŠè‘©E¿<ì,lÞâ^³úéíkZÙ	)píE&yˆ²Ÿ”–ù×Î>+îõš.Òƒ´"'$"CMmÞ˜ˆ¬iÍˆä§SféBŽ=“)vëùç3ÐÍp¹­I"Þ0e÷e93Ãóµô÷,»”E¢ÔD>ûÇÆLx•ì¹5Ê,/	ù.xƒ)´z–È«ÚR#ˆUíûÇ´ê¤"÷ƒsoÎ–?ÁuÁÆ³ñwt|a¹IôT¸0[H^…ÛÜI ™±¯
Á(ÿƒ+™ŒÀ}"¿_fO¨o±^CÚÿxœèy¡‘—vpéYØfžÁ›¡ô‰dÁ÷’¿æ6nPmý!kàVCL¾#
ú?%"Oÿv ÍœÔí¯=Xi¶s¾R¯õÝæ±?eöãßJìœ" •-Yµ=²°Iq<|5Œ¸=¿$fõ&ú¯Ï¿úø¥\?¬;óÃ`1|…åûŽ¥©d®‡U%i22…ÜIW'%TjÆŽÕmUÇËÇÌŽ‹íàš%F²n]+ÄÉ¬ÌÔ=bT7&0sÈGH®O,Ç­}ãã»÷Òùü 
7ÓNý… QÀ’‚ö2~kŽãz³?Öƒ¥ö‡–0â*5X*(®î­ÈAUÉ›f= Ð`wPžJs@­—¢˜^k¿$¦ËüÊS…»±q•ÿ¨ÄZ¤T³<‰àãÆç[í6˜•QçoÓrÖ“ßž”ay´‘ìÆÔm¥›aä$¼Ä_Tlƒ ³66M_»åÄ»ï ²,ö)M.Í‚|¢…íŠžkûÜgø%PÌbëhI¢².!ŠQ”A K÷ækPœAiÑåOi’Š?­¨Íˆw¤C$ñê;}†Šy|ž)¿»¾PžÄ¯‰G«„¡øÚßF÷¹÷˜!'ÉóNÃ›bî«˜„ñÊ}&pDªà?ˆV¤|•'GV‰²š“8Á%bØÕÁYÔZeK2r°ç·³eB´j<ærD,Ü®¾»µ¸¶bÙ+ñj*ñ@Þ^h¾&9€…Ý™nö“ÂŸß¬ÚöÙC ý¦xkƒúœ[_GëµÀ&x™õI’„¹	Ê®Q½B4ÛM¹÷gì…ÚýöÛ4ØÚm-?åY]ö§ÉO™AžBºŠuøÂMô.<)ìòµ˜ùI(V/ö2­÷×ãÂI«÷ÔßÊ%ZS†…¯±¶
ƒ}òÈúq¹&Ÿ#†@5¼;t2zk· Î%¹béÇ}¹îU]Ý}Q‘±‰˜¹™ r±=gÞGèLT;
ÏMTf*8²Š³FyÉ_´{Ká¬jþˆ*Ø¥*²5“ÑðÐ}ÿÒÒö><ÄÍÍË_âkúÌ‘dº„ÃcõÓ}Q\Ë‚–ä†ÎbÅG®@ìl/~£“¦›ªvµ`=wßf<YŒ_mè‘-NyfH´Hœ%kU4Â"ã D4„ø¶ý¥þ­;/h0?58;¨Ë¦¹Ê&ÕëuÅK­+BšE%#ì¨·"Buè ¨BSWÌ€u«¿$…]Ã”S‚Å‰‚zaú-w·|Ï*à„>Z;€?Ó$D&àªP…£\Ùx¦†À»Ä]Úƒ–²â˜ÀFæ‘æÂ t”6ÃðYctkc‘hhˆòZ:#Õ‹áÔ”úõïÎÇúýåR¿¬;å
œ/G»ÿˆNò~¸$ŒjÂ¸}®ÊúÙ‡—ŠÝ#7{«ÛW¡cñsüÊ1Ó†4A±ô'Ì0\*kÁäÒøW«á>i³!ýtÒ>x/8NÂš”õIY~ª«#]óaBJ¢ÎªN‰ŠIš iÅ…áâ†—lZ	§ÖŸ"Š¡ó>Û¾‘ÌäHšÖ¨ÀÄPIËä=|(LÖa–Y²xšG-Á ¢“‹¾|	TÆBu¤±o‹þ"Ly¡#"µü_aeÝò^u Æ/è`§³ðëWgˆßûñ_°Áª ”†¾ŠRI@ZÔŽÓ÷ÛOŽ¦ÈLŽ«rC7ñž£Æ…\F˜7Oß	·ŸeÉœ$<?sá¶Ù*çb°ƒé$S
×¸úÙEˆ,Õ[Q9g¡ýßžÓ¹\ úÂ‘ü˜8x—ñNgŽ.v·7Ð$~e-qò´÷E@õÞNmUz)3ÃþýÅôÊÐD™šúšâ'Åm¬ä ä­–›u(!´M}mçé‚ßÛ‡Q·Ï”i{@›½ZŠõŽŸ5»òôÿ«l3­7bìIº{à¸2E@/½6GùøótNÕegqBt ëkW½šûÛf4èð7~¶,ÿ`°s3åªÖíNô²fS<‡”†R:am“ß—¿¬M¾»—ÞM(iè§P ³D°iÔy‡î'Çr”ð?åÊ5Qåh-’µE ÈVfa°¥Õn3†õèå¥Ð9VÞÐÉÚ(hX£q;½®	åÇçVëG /ƒÆ.Ç¸ÕT7e}aVÀ¤ŸHQ{NG©š,JÌéê«FV´Q, £~¦ùb…òJ>J€¾!e9»lÝñúeí 1¶™äâÊ9{â#r>åðà
HEoseý2S—Äùû`ŽåÊ…RüT1øF«Iì‚N¥)¡'ä]À} )>™‘´.LONw¬>ÈÍIf¾”ýÎ•O/èF¸-ÂÃFUBÂy6ó‚Ql;E¶pÖ9ŸxL‚€îáê Ôj®wÐP`Å«æ¦˜zYù³´GX¾P?ú?;öMä¯[u’=û$ZÀ\rq;¬Ê´è×Â³6çb…ÖÍl“?–šavKS0'†I1”ÒèWKÃ%¯ú v0Ó0ís<O« K¨m‚Â¨E¿úÇ½}à%ˆþ5‰têÛªC@NÐ˜©f{Ïƒ”x_Cüsnù¾˜‚;ŠR.3jÑ@ÏÜŽx‡¸z7QÒ,(zw[•*æø¸WŽ·']0Âä•±uÒ^à?ML=ç¬Jjá$YL"SÉ·W6–Aõas1ú·ü(Ë‡ö-nž6¤\T¤åôCçµþÔïYø)TXDuÃ´? [ÎH³{;üê&°¥Ùu¹Ø
ß>u Ò\Áë¦e@ž®j‰KÃE"F«ÿÊ]@„àêØ¸w¹	%!*ÞB´Ñ6ß$¾=‚1I-Ýê*wö4z‘??ÅsÈaA\¶Žo=á·_\zOB|[¿¸bŒù0ÌZý<a2Ù¦Zœš¬œ98À}55å,TèÔo¡aÆ¡¨†Çµ6GÖÄím˜í!Ò1`ÖÑƒ*xÀø€sùc9¢Ëta<þpàÈÃ4ŽYP8Í|_è›0ÆR¸[d”Åº´Üp'_»•»‰“:?,§ê€².ÛÁKœ÷=Ä»€[žÁÔˆÕc:?×K!ÄogNë‚!˜/¼hRÈËÇ°…üû `m²_üNVqB+Œ¤Ó¢¢˜WpýN
Ð¤
"‡(cN´Î¦®Dªk[Óu=ÜMõBaŒ:ðVÓ‚€¡çÛ»w*¥¤CÛ“¦†È’Q)9q'±F”‰²d»ÒZî50}¹vòSƒjSdÊ4âÐMÝ0ù«|˜šélfõŒ œÐ¾î”ë(ƒ\_O ­ÁL:i·À»YÏcTT#Õ.q/é¨8xœÝ˜Ë³¸Óg¡¢9JQ@XÒ¬»£™è¢*?óR:ºâQÍ‘RT d]éã	HtÌ2J÷ÊNâ·FÕ¡ 2.tVÂ×¾ödªS}&§Y}Ì^œ§¿†3ç–J÷4ëE±+vU­)\à¤ØßÚ$aÍ}IÈ€P"×k¬á
MW½aªÍÁî8™¶ß/2E«DÂþa…}ÿ( É!@×ÈÉ³¢8\ÐRD?†xYáÙþTç`I‡ÈóSjªk
8þc{îR¹ÍàÕÆ®®p»ÿ—ë”Ý> cÚK*C/{Ôö49šØš@¹‰DQ˜žXdõì=VíHî¡°ŽövY¬¹osl|DEë§Ä¹§äs6\#ŸHÓÈUfàÙLùíèÑ$Æm¢Hr0ÍÁ¡·E$QµËGò$òÑGJÁˆ&ìNU­oeLèCV¹OÜïB?A¹ÏâùÃà»¤niªØYÁR¯Üƒ€u Ü5çâÖô”ðJ`RÌ‚¹? ñ¬sGl$üsw)¦3L\»Ø>‰ïD®»ž GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0  .shstrtab .interp .note.ABI-tag .note.gnu.build-id .gnu.hash .dynsym .dynstr .gnu.version .gnu.version_r .rela.dyn .rela.plt .init .plt.got .text .fini .rodata .eh_frame_hdr .eh_frame .init_array .fini_array .dynamic .data .bss .comment                                                                              8      8                                                 T      T                                     !             t      t      $                              4   öÿÿo       ˜      ˜      4                             >             Ð      Ð                                 F             Ð      Ð      d                             N   ÿÿÿo       4      4      @                            [   þÿÿo       x      x      P                            j             È      È      ð                            t      B       ¸      ¸                                ~             È
      È
                                    y             à
      à
      p                            „             P      P                                                `      `                                   “             ð      ð      	                              ™                           X                              ¡             X      X      „                              ¯             à      à      (                             ¹                                                      Å                                                      Ñ                           ð                           ˆ                         ð                             Ú                             ¡K                              à             Àk      ¡k      H                              å      0               ¡k      )                                                   Êk      î                              