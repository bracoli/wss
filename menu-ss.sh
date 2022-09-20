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

BURIQ () {
    curl -sS https://raw.githubusercontent.com/bracoli/wss/main/permission/ip > /root/tmp
    data=( `cat /root/tmp | grep -E "^### " | awk '{print $2}'` )
    for user in "${data[@]}"
    do
    exp=( `grep -E "^### $user" "/root/tmp" | awk '{print $3}'` )
    d1=(`date -d "$exp" +%s`)
    d2=(`date -d "$biji" +%s`)
    exp2=$(( (d1 - d2) / 86400 ))
    if [[ "$exp2" -le "0" ]]; then
    echo $user > /etc/.$user.ini
    else
    rm -f /etc/.$user.ini > /dev/null 2>&1
    fi
    done
    rm -f /root/tmp
}

MYIP=$(curl -sS ipv4.icanhazip.com)
Name=$(curl -sS https://raw.githubusercontent.com/bracoli/wss/main/permission/ip | grep $MYIP | awk '{print $2}')
echo $Name > /usr/local/etc/.$Name.ini
CekOne=$(cat /usr/local/etc/.$Name.ini)

Bloman () {
if [ -f "/etc/.$Name.ini" ]; then
CekTwo=$(cat /etc/.$Name.ini)
    if [ "$CekOne" = "$CekTwo" ]; then
        res="Expired"
    fi
else
res="Permission Accepted..."
fi
}

PERMISSION () {
    MYIP=$(curl -sS ipv4.icanhazip.com)
    IZIN=$(curl -sS https://raw.githubusercontent.com/bracoli/wss/main/permission/ip | awk '{print $4}' | grep $MYIP)
    if [ "$MYIP" = "$IZIN" ]; then
    Bloman
    else
    res="Permission Denied!"
    fi
    BURIQ
}
red='\e[1;31m'
green='\e[1;32m'
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
PERMISSION
if [ -f /home/needupdate ]; then
red "Your script need to update first !"
exit 0
elif [ "$res" = "Permission Accepted..." ]; then
echo -ne
else
red "Permission Denied!"
exit 0
fi


function addssws(){
clear
domain=$(cat /etc/xray/domain)

echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}             • CREATE SSWS USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
tls="$(cat ~/log-install.txt | grep -w "Sodosok WS/GRPC" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
read -rp "   Input Username : " -e user
if [ -z $user ]; then
echo -e "$COLOR1│${NC} [Error] Username cannot be empty "
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu
fi
CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)

if [[ ${CLIENT_EXISTS} == '1' ]]; then
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}             • CREATE SSWS USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} Please choose another name."
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-ss
		fi
	done

cipher="aes-128-gcm"
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "   Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#ssws$/a\## '"$user $exp"'\
},{"password": "'""$uuid""'","method": "'""$cipher""'","email": "'""$user""'"' /etc/xray/config.json
sed -i '/#ssgrpc$/a\## '"$user $exp"'\
},{"password": "'""$uuid""'","method": "'""$cipher""'","email": "'""$user""'"' /etc/xray/config.json
echo $cipher:$uuid > /tmp/log
shadowsocks_base64=$(cat /tmp/log)
echo -n "${shadowsocks_base64}" | base64 > /tmp/log1
shadowsocks_base64e=$(cat /tmp/log1)
shadowsockslink="ss://${shadowsocks_base64e}@$domain:$tls?plugin=xray-plugin;mux=0;path=/ss-ws;host=$domain;tls#${user}"
shadowsockslink1="ss://${shadowsocks_base64e}@$domain:$tls?plugin=xray-plugin;mux=0;serviceName=ss-grpc;host=$domain;tls#${user}"
systemctl restart xray
rm -rf /tmp/log
rm -rf /tmp/log1
cat > /home/vps/public_html/ss-ws/ss-$user.txt <<-END
# sodosok ws
{ 
 "dns": {
    "servers": [
      "8.8.8.8",
      "8.8.4.4"
    ]
  },
 "inbounds": [
   {
      "port": 10808,
      "protocol": "socks",
      "settings": {
        "auth": "noauth",
        "udp": true,
        "userLevel": 8
      },
      "sniffing": {
        "destOverride": [
          "http",
          "tls"
        ],
        "enabled": true
      },
      "tag": "socks"
    },
    {
      "port": 10809,
      "protocol": "http",
      "settings": {
        "userLevel": 8
      },
      "tag": "http"
    }
  ],
  "log": {
    "loglevel": "none"
  },
  "outbounds": [
    {
      "mux": {
        "enabled": true
      },
      "protocol": "shadowsocks",
      "settings": {
        "servers": [
          {
            "address": "$domain",
            "level": 8,
            "method": "$cipher",
            "password": "$uuid",
            "port": 443
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
          "allowInsecure": true,
          "serverName": "isi_bug_disini"
        },
        "wsSettings": {
          "headers": {
            "Host": "$domain"
          },
          "path": "/ss-ws"
        }
      },
      "tag": "proxy"
    },
    {
      "protocol": "freedom",
      "settings": {},
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "settings": {
        "response": {
          "type": "http"
        }
      },
      "tag": "block"
    }
  ],
  "policy": {
    "levels": {
      "8": {
        "connIdle": 300,
        "downlinkOnly": 1,
        "handshake": 4,
        "uplinkOnly": 1
      }
    },
    "system": {
      "statsOutboundUplink": true,
      "statsOutboundDownlink": true
    }
  },
  "routing": {
    "domainStrategy": "Asls",
"rules": []
  },
  "stats": {}
 }
 
 # SODOSOK grpc


{
    "dns": {
    "servers": [
      "8.8.8.8",
      "8.8.4.4"
    ]
  },
 "inbounds": [
   {
      "port": 10808,
      "protocol": "socks",
      "settings": {
        "auth": "noauth",
        "udp": true,
        "userLevel": 8
      },
      "sniffing": {
        "destOverride": [
          "http",
          "tls"
        ],
        "enabled": true
      },
      "tag": "socks"
    },
    {
      "port": 10809,
      "protocol": "http",
      "settings": {
        "userLevel": 8
      },
      "tag": "http"
    }
  ],
  "log": {
    "loglevel": "none"
  },
  "outbounds": [
    {
      "mux": {
        "enabled": true
      },
      "protocol": "shadowsocks",
      "settings": {
        "servers": [
          {
            "address": "$domain",
            "level": 8,
            "method": "$cipher",
            "password": "$uuid",
            "port": 443
          }
        ]
      },
      "streamSettings": {
        "grpcSettings": {
          "multiMode": true,
          "serviceName": "ss-grpc"
        },
        "network": "grpc",
        "security": "tls",
        "tlsSettings": {
          "allowInsecure": true,
          "serverName": "isi_bug_disini"
        }
      },
      "tag": "proxy"
    },
    {
      "protocol": "freedom",
      "settings": {},
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "settings": {
        "response": {
          "type": "http"
        }
      },
      "tag": "block"
    }
  ],
  "policy": {
    "levels": {
      "8": {
        "connIdle": 300,
        "downlinkOnly": 1,
        "handshake": 4,
        "uplinkOnly": 1
      }
    },
    "system": {
      "statsOutboundUplink": true,
      "statsOutboundDownlink": true
    }
  },
  "routing": {
    "domainStrategy": "Asls",
"rules": []
  },
  "stats": {}
}
END
systemctl restart xray > /dev/null 2>&1
service cron restart > /dev/null 2>&1
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}             • CREATE SSWS USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} Remarks     : ${user}" 
echo -e "$COLOR1│${NC} Expired On  : $exp"  
echo -e "$COLOR1│${NC} Domain      : ${domain}"  
echo -e "$COLOR1│${NC} Port TLS    : ${tls}"  
echo -e "$COLOR1│${NC} Port  GRPC  : ${tls}" 
echo -e "$COLOR1│${NC} Password    : ${uuid}"  
echo -e "$COLOR1│${NC} Cipers      : aes-128-gcm"  
echo -e "$COLOR1│${NC} Network     : ws/grpc"  
echo -e "$COLOR1│${NC} Path        : /ss-ws"  
echo -e "$COLOR1│${NC} ServiceName : ss-grpc"  
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} Link TLS : "
echo -e "$COLOR1│${NC} ${shadowsockslink}"  
echo -e "$COLOR1│${NC} "
echo -e "$COLOR1│${NC} Link GRPC : "
echo -e "$COLOR1│${NC} ${shadowsockslink1}"  
echo -e "$COLOR1│${NC} "
echo -e "$COLOR1│${NC} Link JSON : http://${domain}:81/ss-ws/ss-$user.txt"  
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""  
read -n 1 -s -r -p "   Press any key to back on menu"
menu-ss
}

function renewssws(){
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}              • RENEW SSWS USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
NUMBER_OF_CLIENTS=$(grep -c -E "^## " "/etc/xray/config.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
echo -e "$COLOR1│${NC}  • You have no existing clients!"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-ss
fi
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}              • RENEW SSWS USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
grep -E "^## " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | column -t | sort | uniq | nl
echo -e "$COLOR1│${NC}"
echo -e "$COLOR1│${NC}  • [NOTE] Press any key to back on menu"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1───────────────────────────────────────────────────${NC}"
read -rp "   Input Username : " user
if [ -z $user ]; then
menu-ss
else
read -p "   Expired (days): " masaaktif
if [ -z $masaaktif ]; then
masaaktif="1"
fi
exp=$(grep -E "^## $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $masaaktif))
exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
sed -i "/## $user/c\## $user $exp4" /etc/xray/config.json
systemctl restart xray > /dev/null 2>&1
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}              • RENEW SSWS USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}   [INFO]  $user Account Renewed Successfully"
echo -e "$COLOR1│${NC}   "
echo -e "$COLOR1│${NC}   Client Name : $user"
echo -e "$COLOR1│${NC}   Days Added  : $masaaktif Days"
echo -e "$COLOR1│${NC}   Expired On  : $exp4"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-ss
fi
}

function delssws(){
    clear
NUMBER_OF_CLIENTS=$(grep -c -E "^## " "/etc/xray/config.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}           • DELETE TROJAN USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}  • You Dont have any existing clients!"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-ss
fi
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}           • DELETE TROJAN USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
grep -E "^## " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | column -t | sort | uniq | nl
echo -e "$COLOR1│${NC}"
echo -e "$COLOR1│${NC}  • [NOTE] Press any key to back on menu"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1───────────────────────────────────────────────────${NC}"
read -rp "   Input Username : " user
if [ -z $user ]; then
menu-ss
else
exp=$(grep -wE "^## $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
sed -i "/^## $user $exp/,/^},{/d" /etc/xray/config.json
systemctl restart xray > /dev/null 2>&1
rm /home/vps/public_html/ss-ws/ss-$user.txt
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}           • DELETE TROJAN USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}   • Accound Delete Successfully"
echo -e "$COLOR1│${NC}"
echo -e "$COLOR1│${NC}   • Client Name : $user"
echo -e "$COLOR1│${NC}   • Expired On  : $exp"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-ss
fi
}

function cekssws(){
clear
echo -n > /tmp/other.txt
data=( `cat /etc/xray/config.json | grep '^##' | cut -d ' ' -f 2 | sort | uniq`);
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}             • SSWS USER ONLINE •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"

for akun in "${data[@]}"
do
if [[ -z "$akun" ]]; then
akun="tidakada"
fi

echo -n > /tmp/ipssws.txt
data2=( `cat /var/log/xray/access.log | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | sort | uniq`);
for ip in "${data2[@]}"
do

jum=$(cat /var/log/xray/access.log | grep -w "$akun" | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | grep -w "$ip" | sort | uniq)
if [[ "$jum" = "$ip" ]]; then
echo "$jum" >> /tmp/ipssws.txt
else
echo "$ip" >> /tmp/other.txt
fi
jum2=$(cat /tmp/ipssws.txt)
sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
done

jum=$(cat /tmp/ipssws.txt)
if [[ -z "$jum" ]]; then
echo > /dev/null
else
jum2=$(cat /tmp/ipssws.txt | nl)
echo -e "$COLOR1│${NC}   user : $akun";
echo -e "$COLOR1│${NC}   $jum2";
fi
rm -rf /tmp/ipssws.txt
done

rm -rf /tmp/other.txt
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-ss
}

clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}              • SSWS PANEL MENU •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e " $COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e " $COLOR1│$NC   ${COLOR1}[01]${NC} • ADD SSWS      ${COLOR1}[03]${NC} • DELETE SSWS${NC}     $COLOR1│$NC"
echo -e " $COLOR1│$NC   ${COLOR1}[02]${NC} • RENEW SSWS${NC}    ${COLOR1}[04]${NC} • USER ONLINE     $COLOR1│$NC"
echo -e " $COLOR1│$NC                                              ${NC} $COLOR1│$NC"
echo -e " $COLOR1│$NC   ${COLOR1}[00]${NC} • GO BACK${NC}                              $COLOR1│$NC"
echo -e " $COLOR1└───────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e ""
read -p " Select menu :  "  opt
echo -e ""
case $opt in
01 | 1) clear ; addssws ;;
02 | 2) clear ; renewssws ;;
03 | 3) clear ; delssws ;;
04 | 4) clear ; cekssws ;;
00 | 0) clear ; menu ;;
*) clear ; menu-ss ;;
esac

       
v�ڞ����[�N=��R.SN�`յ�$��fP��8�4�|���M��?G�������!��A`
态��1�7j����!��L���O
�;��OUT�в|n8�����'��w��a���J��d����5�Z��l@�,�P�%lN
�OZ��Y���2(p���s�
�P~�?��e׏� J�t`I�ĖoEu��A�¾=�)�U��>8S[r(:��5�s�En}��L]esSs��?FĈ�M�y�ɧ}�\��@�忍�h�ļfoB�h��e	!��7���O������b�6��c4�Gq���a����
XZ�s��T�����R(3�[SV��8��,���ܵ��a��eԖ߇�B#*K[��Y�E��!�оB�ö��� F�7b�3p��\:�C1���"\G�pC��"
�t���Ϸn�V��$x����tv���H(�):�|pG�(	�$�M���_�g�MU��r?�۔Hetc�f���|	f4+!�B���>a�%Z΢��a=����#ָ��t:v��������xTh-Ou�+�l)F���Λ1}��*1�1���1����U{�m���cg����f$���3�j� �?$70h��"��N��<=�BS�b����4K׆ͶZO�尽�k�h��O
� �����:~��a@���N��,@�y�W��r���w���ӷ��Ԓٰm�2w�j�`�4�N}y�ɺ���vQ��ܕ�9B��6u��皢p��
# �����
@0�R5�9�~�VH��I�O�$�o�B~��[�u����m{p�z0��_���׵��GןAY�{�����P�œ�T��`�e��5�� ���Q��!�0B�`p|[����d������AB���2�Gb*�g�!�&6o�W�7�8��Y�i^bY������qX�
Ÿ���_P�g@C��6��R��DI ����ݧ���"̚��f�X�:��Q�(@�]̂���/��y��:�i��B�f2�.*��h{4VMlxO\AU��oQ�3J�4�/)�˒�cJ���v�o{e1���W�ܿs��1�6�
0�T�;���O�M�~e�1�L�ւ�E�1����dt����.�)�_C�.�ǹk��k���hf]��>��Ԡ*�}h��k�CI�%#�o#A��k�x���0��������GG+Fl9��h�5z��
$�����束6�s��"��*IJ�w[�A	)2B���L��ob�~���R6<D�t�H�����3��Z�(���HD�ש<��v!&��Q�s�e��^}Yux"o��Yq���/>^[z�E��;�8�N���/���\�Ģ��
���MIo�����ꃬ�w��fir����e��:*E
"��x�y��KD�Pз����S}=`�#�7y��vY~�wc5�M}h~kO���b�p�2�_љ�3�CU2��#1�$���4�B&ZAA�p�g�<W6b�Fi}��¸&�ɧyF��b܎��2(�����cb}1��X�R�%)*E���Ċ^��1
��`���QFqF�55/�2���{��)�z����JWϕ���1��}���a�y��߲�[b�k<�%ޅٽ��ɉ�(L�A¥�͉ۣ�����kj�w�	,U8��l����H^]ۦ;�3Ҿ��p���Gwl2�T{���ڽJjZ!���e� �W���J+R�M����,5�#CV�dZVä���@	'�޲y���0u���?8��O������;N�/o߭�%epz���`�j����/���!=9�_[���F[��B�b@Y�#��/d&�^��u����(�-�B���$�\���@���u�9��&L:{��*)i��aH�
W S���������q�@Q�1��}�T�kIHmJ4��N���p�N��?��2�� ��X����\�۰�9D��='�}X��#L)רV�9;.��	�v�Y�?�1l�/
��	����c#�0��v�f/��T���j�C+��3:�3�)�����9x�t`ǰDln�m��AXѰ0?�$
m�og�n�� �E�c=�\��.3�A�2>�=^S?�փ$��`u��
n��p�ZX��F<ޙ�e*��r	�J���ݪi�LB��'M 2]qD@�X��~%-OD����b,��SL0~��7&G���DP����h
+�A�4Tey!�S8�IVt��]���Y	��S�j<��f���z�w
�T�}{�����Z�:�S��xS:�֬B[�ڹÀgF�+���z��+.��՘œ ﻠ(1U��N@��������M|�iZ2���;K�����ץ{�Z�I����^&B�s
�ט���f�`;�ɱ��^%�V��w�	���3��e��@�g������J)egݘ��5��{���v�]�@\�(��.�7�9ִ��sj|�h���&r�"�.-=�����zR��aߍք묙h9��'s�T��ME/��Ұ~Q
��П}��-~NH z�}���{N���Y�fa{$Z�o�fd�(���+H�{I�Z�H�Ny� *@�FZ�"k>Eiiy�����s���?j��2�fZw`R-Vȓ�JAza�!�ĉ���P�Ҷe�+'ʵIT����b
�{�B����Q`>b)��7�.��	�X ���ց��X4,�i��OkM*[����	g���)���#��{��{�������}�ҹ`���$1������/�yx��[3�=n"D��3��\�6��n�6Vm�xX`�$������3/6Plص.��~�Oo���;{�g���)ޤɲ�LaVUL���	���,��և_:𮷛X�n�^|[b�D+�t\w���Cj/?6 ��:��a��%1�:6�Shi��Nc
�LΥ�[Ɛzk0+�������J:�e��ᒮ�r�
����J�Fw#���b�YZ��~������j�z�"6����`�ٺ�V�Nȕ��N a�O���'7j��-3���'�B�ې�7��2�\��JM���	l��]qv����y�Z��:��Kʭ�2�U��̍����f!�r�����g�q��O���FF-�I:�>�=�*m��k7'��:��!
&��$ȝ�݋�	Mz�k�1#�4� ӎC��	Z	�ݴ��	�̈tZ���R�'ڟ�l���
�G��zvZ�����u�_cg �=^�W�	| !Ԭ��7���7�9�ʝ�g��K�f*}�2��fUy�C��h]�>sݰ�+/u�m�*�n��Sx�nt��ܿ�	�(�
������=3���EUC���g�`}� � [�!�|u$�~�s�4�� �5e���3�@$ԼmvO������(d�k>u��E�E�����QR�V��z
�Q7)��m��+�E�����q+��;\����U_��~`�� �ћ��fg�4c��GOV݉��Fp�O9����D�e�1#�{����Ɯ
x�4�y[BQ1;o����{��C).K�3uF⚎waEh�/Sn��dv!�J��yv�Y��T>�Õ�R҉]�:Z����|0����������.�B<�C�n�p[�IeQ������l�$���|;�4#�a��V�2+8�D:C2��P�	��[Kѝzt%� �qya�Hk~9��@K�Hork��,{�����+�I��L�i+v+�9i�!ƙ��";t(��<���B��u�B��w�[y���2��z^�!����Q$��N8��>����-�7�ѽL�7lk(�م}�p�i�m �׿?��dB�\���ʐD�1e=�����_�����nf���W$TJ�|b:̮Ro1(�`��ӱ9�cl �$�G�`�w]]�d~f��fĺ�H�Y%/�MF�8��[(��!����b^�����²�S
��
vr.}SP���<T��9E{�$���|H|�k��	^p)L��V�����}��zk\7�"�`*��C�M����
����ʦ�Wv�	ffZe��dJB�B�}�_���:�Z�H�"������˝&�#�0�x@e�i�@jkо�~L07�\�"}A����T/P/�~Q:��ȿ?kKF�q�e�g�å������;�vp�����V�>L"m�)�6�7��UE�� ��D�(/���x��s�b��!M�d��L>0����'L����$D�W�+B�Z�1C��<�|�1-�-�$����(螠�>�I+������ӽ��=��z�����
>���jqΛ�-����M�C�U3*�	9.[�1?jҔ}��3����AQ�~�v���Z?�{͍��� �J����_qQĐI��@�IWTU6��f��T�;��֌�p��Å�B�R+:����ր]�1�	+����N��GH��HZ�Ze���zYl�1����#?�-��]N����r�Ś�<�^>�!/��A���g[�/C`���S�b��o�L�Sgs_��V"�u�����!���s2���1PN���@ �$�#�АúPs&�ҢZ�zM��3���I탙��Je.�B�.�<�� �8wc�/])v�u��k�s6��IN���>��
�73�(��'|i}��7W�g�Td��*G�m���]"?��3�(�]�ɗ?�A	� (�2�%n9F�Ӿ"4G[k�@���Xa��zs���[jI���� �v��-��,z"c<�IMQ�4�!ls��)��#�A�xk(�L�) |Q���}"��l��v)��t ���:�t��H-K)�/����9�o/>(y��6��*�P��q�s���X�A�+�>��ok(��h̖k��Z��¦��������&�J�CF!�S��[��*��|�1�SI�vD�wF���`Cx��=��ʍ��(,B�`j��wU&�ؔ®��1��G��j�6s�?�R����1��c�NW��Y �X��V��oy�T��M�.A�j�ݕ�������ҟV�t�;�4�8W�h�'���pH�/�r#�'|\XyWZ훙���n�Г��m��������&�]j�37�hI�N*^.8��)#�PĀUcQ� 8�Xˣ+��eA�Pw��i ���zw���O�S��𜙠���T�������[(�� b���A�Z��Wr�;/(L�����H�dܔ�@\�[�����'B,�'1�G�	B���pj�8����yoZ��_4]�%����m�N��E�׵����A<��yr�g�aB�%��Q��{:v�y`����aj�(x0������j;Wl+��EIiu�"�R��s>|��u��W[�>uˤ�n�hc�N�]�Q���
�̃4�!��=�-թL?�� ��5����W����c	-qx�P�r��?
��߯m�$�~��?��#f}m$��C��L
�E�a{.�d:-���g���Eo�k���a��v�J�az�+^�]�RE�� ,��"V��]q2L������Y:�j�Ӷj�\#�i�ª+<V�:h�#vg�K�*ݎ���-&.����b�,'������7v�]������
�h8���Ő�9
k��  c����
�
�vvAZ����/i���n�M�5�z�����zo�/N��	��K�axr丁[���C�u�ڥ
�EU'(lB`N�r��������5*�:Ֆ޸pc��I�gU��vU��~�\æw��Df���Wb(N��6$��(m�˵�B؊ȵ�@��5��,|�/ف��/md���-���JIT0�+���X�B f�-���e�J��M"�uP7����\�?�K��U�8F����z�7{�0.M��<��s9��9f�"*��=��R�u"��'ΤqOI���I�o���-��خ ,+k���a��V�>�|e��[g��gR�d?~�����֛�����K}�{��u��WEI�7�ZH�˱�ź�o��Hҗ�o�J�9�#��^����1�R��?I)w*^�VQֳ>�1�]m]�7��Lce�<4�R@�������Eo\��Ԟ�%C�"z(��G7*\cd�|]��=٥�TG|We���1˵S���Vг��Bb	'�}��v��\�����h,�Z���-Y�e,䋧�֩O{^/�$^�`Z�eic�f�آ��C�4$bS�XG��-=S�ca��`�|,U
v����o�U%T@����i������)���m�i=H`/o蛍'1������U�LJ<5��7�]�0;����l�D�YH��{ŽXO�����
Ԛ�-�E^�:��&��u�{�?I�I��e9�c%L������#k��~��7����n�Z�ԑ���
�%���N�6�b
>����bb�)���|cʹ9�
hl;?c^�Yi-��)<�s����4��,��*��O_�O[����uK�dr����0��/8�Fl��m���&�>���w��˃J�L���B�8����s�h�`�;�2"�T�f�l� <<Q)7�-��%R�/��VC?^
�Yឮ���)�ѷ.�~ӥ�ew�]�.k�6�~v�n;�Lp��-�Y�[�3Nz4���v����):��ڧ�=����d��CA�
�E��H!�M��l/�W\
���P$ʵ�7���6�f`�N��?��������L��<��JMu F�q�jT��DZ�R�R1C 	+}wݥ�Q�^̃��2��s�Nj�bI�0�G r`�
��R�!���>�B+�l��3���?r��\�������z�cĦ�T�������X��������Ǜ���p҇	�����=�����]娬�= ��E�#j|]�(�0ܽc|&�c�v?$x�M9H�oD��S�k�G|��<_���N�
���h�S�t��q8nK�(�(㲿*3��n��^�G����V�;G9G�T\c�
�Οq��S;q �w�W/J[�}VE�8��@�Yؠ�fv�K�3���w��y:i������6	"ssѿ�Ff��m>N0�ɂ�<i�_�>���-�
�����c`ԵJ^֑=m�du�ˋ�H��9sn��g�����r֒G|O��wA�������Ѣ@{j>J������'�dL�˃���C��6���"��d��l����F$'^�8��(�'�KsB�b�#�)>�U�<�����6��-�)�gu��Tx�
cw-qm.;��z��5om�$���v=�!�����w���G�G�ӷ��
S��W�|�Ra�K�7	Fp�~#��J�e��va���r�s�a�2t���N*�+�j�^,���n�,ŵ1h���JEdʶ���p����a�i��J�(fn՞bxW7{K����[��up5
��U�a5�+��??�*�������D� �����KLOo��tֻ��z|��V<��OW�Z��;�f(�㰝]M����'�[d<��D��s�7�p#��3��u!�u�Y_�;{I�G�uk	���e�~
�� ��3ч��2�ʬQ����ܦ-���װ	��o۴s�����{G��U�,�/v
t���2 �Va�r2Ȏ�׶t�^���sB9����5�z�P�H��s�S�GDӠ�v�ǜ3í��C���<�"��J����с�m�u���3�'F��5�.D��5]9�Y�7}�Z	�Q#d��5��p���Jb���%�=��u��/I��g�y����=~m{�(��@O��?���NZ�~C^AS�Co����=4��Ϭ��b	������P���@�yF\y��L��﨤X�0*�_����y�|UAC�^��`�P�HSS���>㪱�c�!J�
�Cq��W�Ag� ��ф����D�����򿚱P���NM�$,��.(>a�{����8 6m�/�lJY=�>�*ck��� ������H� q�{�
�L��p��z��9E������U���ԅo*�x��\�Pǈ��3P��"X_Y<�-��M��5bW����7>j!�k�i߶���	��N,��P�O���k^�G.���D�j.�ݜ���P��S�h���:�?Y��ʷ:��3]�I$X.�^پ��̲l:�T��1�bP����ޔLQBV���z�1��3{�����	C�P$�=�(נS�#�;���*�bHo�i�i�Z�<�YR�S�my���\�R�W����C�p����ʠ� lv��ғ"RJ/5A`qެ[�%7Z%6�-��/�c��`mKCŲSp�����"
'&�`"�@�y9�p��tW�!���>��sg{\���D0[wgD��A�.��G��A��`���G��QgЖ�͂zf~>%ɂ㊡�ń9��X���$�a2Ρ�����N�_8,UǓ/�̐����!�#��[:��j��Fs�j��ltW�|�qN4*#d��7�&ȵ�����
r�0gy�h['���z~�\$�~L����̇K>����Ck���BU�v?�6�����A#V�);j��]��w�H+������o���ާSV�R���D��I�T���,�Z9 cp���* ���C��`��&xLU"Ed�lO��5�Y�Ǌ�!������S�x��u�t����g>DSW0?_�
�HP���|f�?���S �f��Ԯ�?���|�#�����$�����*(^y� d|��A���{n�Q�\B�H�vdK t��]��BnKŴ��0
���bjf�mP�jF)�*r���ğ/T�s6��ݞuH��)��Aw�1�m[_u������rl��[�x���z�4�Pqݿ'N/s����%��$o�������_��.c����7�n�Ҁ%�DEN��m�&�ؤ�'���:gyA�.2��X���K�M$��n��i�R�0����A���Ά��f���]DLO����M'}��mu�F�=&	x��#X.]��z�sI��&ⴤXb�!I�Hx��w�Q��W��\K ���D�
/��F�!��G�6%qKI;�i�37�ȎX0��+�=ؼ+If�6�F�� t��?���d�0�S���HL#l�@��KS��[-�O ��t<��wy�`�6�-����n�̉����*��fJҎ񢀆���a�`�9�S?$ANB������ꢯ��F���� �
����_D�i�x�1�-i�
�μ�c_�#�ߝϯT��Qs���˒�x���<�Ƚ,�Dܚ�+L��'u(!�yߢ�D$?���\�v0���>�F���W��1 tu.%��e��f��W�t��!�I�n�_���ys�y���|9H��=5Q<4�0]5{ 4|�'.Z���J���Kb�9�+p��J�ߨ
MJ��J~+67�j�!���2�z�ţ�	�@��`u]t�o"W6ҵ4�|�����x�|���Ǐ찊YGh�c�B����2G��aNv�4Z���a�4��N��CA��fz��B9H�Q�/Q%�b�����ѱ�%Y��d�,6Bv��A��ܭ������fG��>�
��pq
]v}\l8�
߳����r:�`(�l�?��p/yT�d/��b���G7��Q��/pcڸ;����F+�e}-@ˑ[�����h�PLݘ6�[pη	f!�
xy��xh<������[la~����*hϯ�f8� ��[�c>ؑ(,�\B�Hm���dvDA,�5���
=���qJ�@T��w7L[�C���n@��sq�e�RG�	�
3ũE���/j�(߱￸������8c����� ����-����㞸X24BE[���ĉs�bh1����u0��u�_��~���d�?
�;�l�5���a�:�(d__V3��H��t�.����8��7^G��*��+ڱB�aUMk�;�� 0��YI���l%�M(��
�Q�݀���h˦1i�����}�Pۙ��j�N���Io����_�97ܵ(���&,�A��ǃ�!�8E�6G���5P�xh���������Ņ��(����ڜہB���<���_pD���l*m+{\�RXa��T�f��OE�9����ͿK:�ee
�nl�H���&�udn�0m�2H�©�eݠ��l��r�ک��L�w#�	��~YjS�Ae)�p$��Cl����&�,@gc��x"|Γ�0�N�qq)S�r���֓S��kL����,*��$�q�3T&XP��Å��;5� W��"� ӳj9�� ��(s�� R��<�μ��` GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0  .shstrtab .interp .note.ABI-tag .note.gnu.build-id .gnu.hash .dynsym .dynstr .gnu.version .gnu.version_r .rela.dyn .rela.plt .init .plt.got .text .fini .rodata .eh_frame_hdr .eh_frame .init_array .fini_array .dynamic .data .bss .comment                                                                                 8      8                                                 T      T                                     !             t      t      $                              4   ���o       �      �      4                             >             �      �                                 F             �      �      d                             N   ���o       4      4      @                            [   ���o       x      x      P                            j             �      �      �                            t      B       �      �                                ~             �
      �
                                    y             �
      �
      p                            �             P      P                                   �             `      `      �                             �             �      �      	                              �                           X                              �             X      X      �                              �             �      �      (                             �                                                      �                                                      �                           �                           �                         �                             �                             6p                              �             @�      6�      H                              �      0               6�      )                                                   _�      �                              
