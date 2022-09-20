#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

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
clear
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
NC='\e[0m'
echo "XRAY Core Vmess / Vless"
echo "Trojan"
echo "Progress..."
sleep 3
#green() { echo -e "\\033[32;1m${*}\\033[0m"; }
#red() { echo -e "\\033[31;1m${*}\\033[0m"; }
#PERMISSION
#if [ "$res" = "Permission Accepted..." ]; then
#green "Permission Accepted.."
#else
#red "Permission Denied!"
#exit 0
#fi
#echo -e "
#"
date
echo ""
domain=$(cat /root/domain)
sleep 1
mkdir -p /etc/xray 
echo -e "[ ${green}INFO${NC} ] Checking... "
apt install iptables iptables-persistent -y
sleep 1
echo -e "[ ${green}INFO$NC ] Setting ntpdate"
ntpdate pool.ntp.org 
timedatectl set-ntp true
sleep 1
echo -e "[ ${green}INFO$NC ] Enable chronyd"
systemctl enable chronyd
systemctl restart chronyd
sleep 1
echo -e "[ ${green}INFO$NC ] Enable chrony"
systemctl enable chrony
systemctl restart chrony
timedatectl set-timezone Asia/Kuala_Lumpur
sleep 1
echo -e "[ ${green}INFO$NC ] Setting chrony tracking"
chronyc sourcestats -v
chronyc tracking -v
echo -e "[ ${green}INFO$NC ] Setting dll"
apt clean all && apt update
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
apt install socat cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
apt install zip -y
apt install curl pwgen openssl netcat cron -y


# install xray
sleep 1
echo -e "[ ${green}INFO$NC ] Downloading & Installing xray core"
domainSock_dir="/run/xray";! [ -d $domainSock_dir ] && mkdir  $domainSock_dir
chown www-data.www-data $domainSock_dir
# Make Folder XRay
mkdir -p /var/log/xray
mkdir -p /etc/xray
chown www-data.www-data /var/log/xray
chmod +x /var/log/xray
touch /var/log/xray/access.log
touch /var/log/xray/error.log
touch /var/log/xray/access2.log
touch /var/log/xray/error2.log
# / / Ambil Xray Core Version Terbaru

# Ambil Xray Core Version Terbaru
latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
# Installation Xray Core
# $latest_version
xraycore_link="https://github.com/XTLS/Xray-core/releases/download/v1.5.9/xray-linux-64.zip"
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version $latest_version



## crt xray
systemctl stop nginx
mkdir /root/.acme.sh
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc

# nginx renew ssl
echo -n '#!/bin/bash
/etc/init.d/nginx stop
"/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" &> /root/renew_ssl.log
/etc/init.d/nginx start
' > /usr/local/bin/ssl_renew.sh
chmod +x /usr/local/bin/ssl_renew.sh
if ! grep -q 'ssl_renew.sh' /var/spool/cron/crontabs/root;then (crontab -l;echo "15 03 */3 * * /usr/local/bin/ssl_renew.sh") | crontab;fi

mkdir -p /home/vps/public_html

# set uuid
uuid=$(cat /proc/sys/kernel/random/uuid)
# xray config
cat > /etc/xray/config.json << END
{
  "log" : {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "warning"
  },
  "inbounds": [
      {
      "listen": "127.0.0.1",
      "port": 10085,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    },
   {
     "listen": "/run/xray/vless_ws.sock",
     "protocol": "vless",
      "settings": {
          "decryption":"none",
            "clients": [
               {
                 "id": "${uuid}"                 
#vless
             }
          ]
       },
       "streamSettings":{
         "network": "ws",
            "wsSettings": {
                "path": "/vlessws"
          }
        }
     },
     {
     "listen": "/run/xray/vmess_ws.sock",
     "protocol": "vmess",
      "settings": {
            "clients": [
               {
                 "id": "${uuid}",
                 "alterId": 0
#vmess
             }
          ]
       },
       "streamSettings":{
         "network": "ws",
            "wsSettings": {
                "path": "/vmess"
          }
        }
     },
    {
      "listen": "/run/xray/trojan_ws.sock",
      "protocol": "trojan",
      "settings": {
          "decryption":"none",		
           "clients": [
              {
                 "password": "${uuid}"
#trojanws
              }
          ],
         "udp": true
       },
       "streamSettings":{
           "network": "ws",
           "wsSettings": {
               "path": "/trojan-ws"
            }
         }
     },
    {
         "listen": "127.0.0.1",
        "port": "30300",
        "protocol": "shadowsocks",
        "settings": {
           "clients": [
           {
           "method": "aes-128-gcm",
          "password": "${uuid}"
#ssws
           }
          ],
          "network": "tcp,udp"
       },
       "streamSettings":{
          "network": "ws",
             "wsSettings": {
               "path": "/ss-ws"
           }
        }
     },	
      {
        "listen": "/run/xray/vless_grpc.sock",
        "protocol": "vless",
        "settings": {
         "decryption":"none",
           "clients": [
             {
               "id": "${uuid}"
#vlessgrpc
             }
          ]
       },
          "streamSettings":{
             "network": "grpc",
             "grpcSettings": {
                "serviceName": "vless-grpc"
           }
        }
     },
     {
      "listen": "/run/xray/vmess_grpc.sock",
     "protocol": "vmess",
      "settings": {
            "clients": [
               {
                 "id": "${uuid}",
                 "alterId": 0
#vmessgrpc
             }
          ]
       },
       "streamSettings":{
         "network": "grpc",
            "grpcSettings": {
                "serviceName": "vmess-grpc"
          }
        }
     },
     {
        "listen": "/run/xray/trojan_grpc.sock",
        "protocol": "trojan",
        "settings": {
          "decryption":"none",
             "clients": [
               {
                 "password": "${uuid}"
#trojangrpc
               }
           ]
        },
         "streamSettings":{
         "network": "grpc",
           "grpcSettings": {
               "serviceName": "trojan-grpc"
         }
      }
   },
   {
    "listen": "127.0.0.1",
    "port": "30310",
    "protocol": "shadowsocks",
    "settings": {
        "clients": [
          {
             "method": "aes-128-gcm",
             "password": "${uuid}"
#ssgrpc
           }
         ],
           "network": "tcp,udp"
      },
    "streamSettings":{
     "network": "grpc",
        "grpcSettings": {
           "serviceName": "ss-grpc"
          }
       }
    }	
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  },
  "stats": {},
  "api": {
    "services": [
      "StatsService"
    ],
    "tag": "api"
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink" : true,
      "statsOutboundDownlink" : true
    }
  }
}
END
rm -rf /etc/systemd/system/xray.service.d
cat <<EOF> /etc/systemd/system/xray.service
Description=Xray Service
Documentation=https://github.com/xtls
After=network.target nss-lookup.target

[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE                                 AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target

EOF
cat > /etc/systemd/system/runn.service <<EOF
[Unit]
Description=Mampus-Anjeng
After=network.target

[Service]
Type=simple
ExecStartPre=-/usr/bin/mkdir -p /var/run/xray
ExecStart=/usr/bin/chown www-data:www-data /var/run/xray
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

#nginx config
cat >/etc/nginx/conf.d/xray.conf <<EOF
    server {
             listen 80;
             listen [::]:80;
             listen 443 ssl http2 reuseport;
             listen [::]:443 http2 reuseport;	
             server_name $domain;
             ssl_certificate /etc/xray/xray.crt;
             ssl_certificate_key /etc/xray/xray.key;
             ssl_ciphers EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
             ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;
             root /home/vps/public_html;
        }
EOF
sed -i '$ ilocation = /vlessws' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://unix:/run/xray/vless_ws.sock;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation = /vmess' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://unix:/run/xray/vmess_ws.sock;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation = /trojan-ws' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://unix:/run/xray/trojan_ws.sock;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation = /ss-ws' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:30300;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation /' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:700;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation ^~ /vless-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://unix:/run/xray/vless_grpc.sock;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation ^~ /vmess-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://unix:/run/xray/vmess_grpc.sock;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation ^~ /trojan-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://unix:/run/xray/trojan_grpc.sock;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation ^~ /ss-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://127.0.0.1:30310;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf


sleep 1
echo -e "[ ${green}INFO$NC ] Installing bbr.."
wget -q -O /usr/bin/bbr "https://raw.githubusercontent.com/kenDevXD/multiws/main/ssh/bbr.sh"
chmod +x /usr/bin/bbr
bbr >/dev/null 2>&1
rm /usr/bin/bbr >/dev/null 2>&1
echo -e "$yell[SERVICE]$NC Restart All service"
systemctl daemon-reload
sleep 1
echo -e "[ ${green}ok${NC} ] Enable & restart xray "
systemctl enable xray
systemctl restart xray
systemctl restart nginx
systemctl enable runn
systemctl restart runn

sleep 1
wget -q -O /usr/bin/auto-set "https://raw.githubusercontent.com/bracoli/wss/main/auto-set.sh" && chmod +x /usr/bin/auto-set 
wget -q -O /usr/bin/crtxray "https://raw.githubusercontent.com/bracoli/wss/main/crt.sh" && chmod +x /usr/bin/crtxray 
sleep 1
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
yellow "xray/Vmess"
yellow "xray/Vless"



mv /root/domain /etc/xray/ 
if [ -f /root/scdomain ];then
rm /root/scdomain > /dev/null 2>&1
fi
clear
rm -f ins-xray.sh  
`��9��p��nA"���_yCzJ$gn�Wj����{J����h$!L���g���*��D�<���>ImXl����`��!Y���{o�gd;�� ��l"�ވљfl휬N�@�\��_-���&���/|
�@Sq�c­bcj���_�?�ݴ9�w��p���Ð2=�_b� K��~�=�d�~
L 7�0F�l7�I8g�� ���gu���^C!C�7r,e�t�'�x&4�q8lA�[-V�+�= S���ZJ�܍x�r�$M#.F�y���$��To�c�h�j�O���}�;���;s�=;bkC�l޷���C��P}2<xX��CY�� X�g��.]�ɨ���5���\��H�8�H�I�&�HA�3��%�N��T��P�������$�a.����fm���%IUw��7���}��!�[CE���IBȩ^�32� �m��]��l�
���yZ?��ܻ*��
n��4(z���zH�d�(������X�)�Bz��4�,D0j7�_�J�y����dP�
��������Q�MYKm_a1��WgC(��;dj��$��)���}1=��eX1!�
��c���~.�Թ��U�� ?��eł�#�l���)�������r�2�����@�F<����
��}X6�V����Ȟd�<W	�E�g(�q�Yw�ue3��I�h���b\.*�a�@�,0@Բ]�>�U%��D�l�4������z���C�D%b\p��4�w����೨2T�^"��t�fP�<����@�w���77���f%}^M!5��
U�"X^���H���C����4Y�5ѰC�O�����H�5i�a�!z#��`Fu�rHP��j�ۻ�n��L�_�;ı@a��
<r��y&�kU=.X<"��T�o�
@{�������m�M}f�`�}���8KP��w8#O P�
h��T˄ϻT.'�u��4�,��=�
�%D��2C��:�LH3��n��"8��Sj@���j���C_ Y��hNv?F�@B)"���#�,{���;}�K	s�m^:稧A��Z
�-^h#��P�	�a�+�tdd��=��Y�:��y��H��(.����5����CH����	��{/,_W�N�꘹=�T�q�/��e��2OS|�9�3��
RG)���G��BW�c��:R2@B���Z=�����aٌ�r�[n�֠����|�����X�K����ڵ
I'Wƣ\�TO�פ�&����S�W\lw�'�6� ^��a����0�#��
2��2�)u��F%���j.�V����������j�}�f��ڎMdőkZ,m�f6�/�3U�����Y�q͢�W�{���I����?�GAa� dv�b"�㠻�����$Spc��4k��B(H�8ܙ?����9\у���a���5���q�2K��')��+<�
r��y�{FER-�/:Q?#o'�[q�l�	����$ �f���-���V�����n��6٦'��9�z�>p-���B=�ȢU������at�d�ؘΈ- C���\���/*+c�E��R�qZ�9o_�AO(��DpKKj���B��♵��R���|�I��B(*�,yx�ſA4���C;Y��K��u�>W�eWa�}�$8F.�~E��(�(xQ%b���v5�q'�L�߷
����[���]�i���JBS 4��j.\�q�Le�3�Ig��4L��7�/���q�k^q�>j�D_�W>6���6f��0m޺[r�����/>�ݙNʬ"�>mA��g�NA�yZ����d���o��v�؛���h�J)��;��w-Q=;�%]w}�z_��1&S7�[�s'}Q��Z��JMN��
����[�!!�-xp#�oI%����s4�f')H#6ێ���T��[�	���o/�)D�"�SB��!��1�)
I"*R��?s�+�����Q
r�xt<�9�����k�֔,ݼ�(��Jd���F-7��M�,P�~5n�"й�@�%���b���{�|QN�6$@8%��=sr������.�e�`a�(��f�'&;�_MD-	�_�����߂���q���A���1�Gɑ�1�\�O"�i�
����\���X���ek�����կ�ۼ�������ks�B�޸��I]�#��?�!�)�֠qo��/�&��Ӎ-n���K˃CI!6# !פ�燰θ���%:���s�;�۽�I�t��ߑ���+en��0��|,���
�γ5�{��/��_���!ڿIAU�a���覆�(�84������>A3���h\nmp8^���?w]�y o��i��CK؇��@�PP�Q79�[�k�i�h�z�t���A�hP�wߦ�N@*H�p�K���96aV��߶*�,�r>��7q��)�1����RJ��r�$3l����w�iu�����
j��I�-vM#�婶��X���Z~�n�v�L>��,}*h>
���S��ׅ�i�Dl�G�W��ky�.2�3X�%5"���7�>�i{�:}r����?5u{���$ T���v�)@x��������f�¸��LOH�E�uf� 
�zk���x6�	Sg�O�W������ �3f��"7��\�����ZQ�p@�J�r�;�@�ώ�r �������"� �a��Ƶ��R��ͮڠ|ۊ�fj��F9�<�-�G����ŪS?��1�8��GG,8s�nO�'�b;%��QL"&��Dޖ  '���<���\��`���^8���I<G#O'��lm��U�]�X���N3-)�x�bFMg�Ʌ��G����+�
gj�.,�����&f�2�&?���=�Ő�zk�_kM���� �1��3Ik�tf2�}����1��������i�L�s�GH}�s�g��]H�L�W	-���V��{�G���c�A�eg���J����Mx�|<�����"l�N5?�]�k��,J<W(t]J}QI�����I��8����O���UBQ��׻{0�,�Hb)�H���M
Y�N?h��Z��)L���I_��SB<�aw�"�iɼ�"�:=(~>ԣ}��Y#�Z?4V��� 
cF;�Fe�#י}�ܥU7ɏ^X��Z��/Id�ț�c����>�|p,�\4�d��EL͒L�7I�6M��=�����J�����õ���Mㆴ���]I\���k�F�c�̄��!��9�3o'�1]�>�x��/e�?DДب3������U����ít3�t�q��?�Q�7��p�6��2�v`�ύ�<�!it"����ro�̜]!� ]�]+�I�t��d	�� �+u��4��r���z �Ų����W�ym��Pe��A��+�~(��I�g�����H�M褡�Z�xUQ�6�o�q��'��5Y)�O��Dg~I��� 1r�|��^n((��n��Qr\����Y��#�)<S��lEX��^�|F��Qԇ�H}&�ۚ�z�*m�
���\��G{] 52�j6"������[��߮U����`z� ��J���G�I��
'�
���xͯY���ﯸ� 懡{&=��M=Ec?1W-۸��ۭ��g ҺX�l�
Wg
�Z`,�xG��@a:����l,���2(�w��-/�8�~E:��������r�˫]E��|�ݻ����G��)�����J�߸�
.={��:�
M����En�^�
�?��Z�G�r��*�17��u�I���
7)#�SE��	C�̭t��"a��j
�JR���V/w-urB�#�ǧZM;�H�΀�3�n��lD�H�^,��m�y`��.�q)
�e�=RK9	��
��!�dt
@�Qk5+�(X�K��P��/�{*ݱ�bE'���	��%<�55�tS1G�=��ư�����f�ˬaN#�O���Ĩag�#Z)����h%��3�v:'�������(TgV��P�8n��K����l�<[eSm:L�-(U_�1�v�_��:y��2R��=tz��S�|��h�Y5��#�.ud�J�o0C"S8�����:���/�bRwsI�dJ�?">1[�*¥;�'�v�+X��>Ix|%�b^��ƑN;� ��c��`f�@��l��!�BG9{�)�Yk�O�cD�\�mz������e�ݔ�O���j�m��AT����C̯&��/��R������w�\p����Қ�yuHʖ�#�;b�rx��6,�#���m�\�b�J�R���x�>���F��4�|���`kq�a 6�[�U���۬bb�T"���3+��f)���ύa��Q̈́�h�1T�����hO�'���%�M���2�?�x���;�+D�uuTt�)��8o���(�N�"q �O/����L߀4'���w�S�)3��0�ÊR="�j�T]���j�h�msР�Qb���C!��L�nGYri���<�u#�!牣�*���_ 
-�М��ڥ?�. ﯧ6 ���?� ц$D7�|B�����J��B��,Tx~bc�u *�������MEg����Ir�^�T���)�q���1�s~�d5Btr��;
��Uɏ�La���?���:4�����<�����p�_\c�g�W$iM
��
3�r��i����lqf�a����i�!Ix �.��^�W7+��t�'|}���R������s�x|��� ��;k�,�j1��i�b�	32/e�&�&Y���y�t��4~.ڭ��`�.n�F�A4�;��ࠠI�"d���Ynmw�8������y~��� �F��j$�1O1��,�~��K��0�N+k���)0B�����\l;�0K�]ĥϞ��R���,��	�R7$��]��Q=�e������8�3!4���m�uH���H�����TD��Y�g@6�
B%�z����]�-/��#�`
Wv��k($�~UXx���l��
��`|��G�x�C;�������&���PT g8u8i�.�ҩ��������i�(�Z�����.˂��W}f��C�Ax-A]����J�Tw):�Y��	.�&��r���-C8!K�Pe
���5c����-����.6�{���X2]�&�[�Boꝧ��Q���s���N)�Ng��[�$�{D��Ĭ�O��C�F����@�ǀ��yy�M�c����T=�M�p����#��h��v ���C�o��� �8S0S�ǯ5�)8#�굓r��(�v�t���_Yߝ���L},
q�"�b�2�t�"N��nwƭ��q�cy:2���&��pt5	k��h�����/v8{>�6�t
b؆3� ������R(�]��T���ޤ	��b��G��Քħj��jB���s��#i/;���
���9�[���|�FYY��X
�`��;�<���V��)��g���W�`^���y�T���[M�ED�;
`�������d�f�"#u@!Y
Y^#��I>�t&����+��1 �r�
П�[���_ne���/��@�f�w~-%/c\�.GS�2���~q'�WS6b#�3����N0��F�;�p��9�:,�#�y<�l�kA�Nq���6o��x���ދP�f�t���>[�=������+Sv?�����:�����I��|u��pZ�&�:Ca.M��?b�p���\�8�kM��(-���R�w�=�l�U�����1��$���B�;7��}y�n��Q�#����� �����7j�hg�rE;,��K��G��ٓ#H��\�j���E�4'/��Ψ�2n�N_�{��Ԇ
�{ǲM��P�0��5`H�R�>�`�6�V�aQTFe��x<��Ǟ�r�L�]-�]�������f ��)X���w�D��hf�zm�ҵ7����X�Lye�\�@B�/^8
2�F�_$�-������omQ!���Z)�#�V�S���v����Ǳl�ko�$� Ҋ�"4���#���L0��<=�6 E����a�>{I�z���~zB��q;uN�PL;�+8�KN�Ӿ���D ׯ���Yk �����S�@�~uQS��~����v��w�6 ��ٜj�q���.�*d3W����z0
�U>�s�ؼ��\���gY�!�Pǔ�Cp;	�$NtF ��S1]w��-e���n��'!�<J�~g�Fe���0��#f�e�OV�3'��
��Y�Z0�u��r�'�$z2CF���P�3�*�9�C�ӕ@�ɀ-{�c7j�����
Α�C�^��Rs��R1u����$�����G'���8��v��	O��Z ���e:�ߴ�EJnd�&��,Ǯ\H���̖b���JZ4U{���zo�z�d���M��e�eh�uy��|�(� =[�G�ԑGj��s.o�$6kQ6������ ����cן���:.�V�#g0!$��R��P%N��WreF�5�-=h.�DzYQ�.<���5x�&�WK�V7�r��7?�� �
8�#�1��)h����Ϝ�+��,�q�p	6�J&:�,s�r��0�@	d�c���a[۔�c-��P#I�0:BO]>�i Dx*ۗ4)V��FkW�����qSD�̶<�􅑸W���a�(�{�D���}GKU���W�1�K�- ����q�:nt��f0��Ƈ�_�t����-B�B���	i�(����y����w���!����nii���-�4h���2���[��(����r�M'c����U�F;���X���?ge3a�-�7����⑭���Q�9KY�cj�� E���$
���o0礄<����u/$�vW�5�в�@�*�Y&;V7�~�%@ Կ�ȍ�b���Yyޟ�H�@?���&��Z5�
fI�e��Jf��
��[F�}�!�w�%E���<��v2��1��I��P�^�be2.`Sq-�� ��W����k�'��8D�nEM���?�cP�~Ȳ	Ÿ�5�mr����o�0��_�4��������@d�1�c�=�D�7H�@�C@b@���2���q���?^O��� �y)��(�.���*�!��J�p�c,�N3w��ַ aͯʶ��Ý2�v��R)�-|��'�'�d2'
��h�0�rB��M�@s\n\�=�
����N�����?p�q���:�X`k��^�=դ�]�hbYx��FEg���s�.�͝���B�YO����v����mt�q�<>H�F��{�>|���"/K��L�i��&{]�6���
�\��jl���L.�0q���;���W�A\�r�|ͳ��(	�
p��#7b��!q������\� N��i�G��Z���+��=�p�	����Z:�	���Z�� ��Fp2t�t��q�^�n�Q��t@�`YwX���뻋ɝdX�RҶ?7�L�Y ��*���K��Uc(���;n���݌]~��h� �t �@A�#l�N"�%-?{�2����T8�4��b���/����>$W6�*�g�Q4z_�7���Mft���U�E�<�`���O��e�������������JQ�|n�e_5ѰK:+��Y{#s;�}�q�!�[%R��ḍ��KR��U��ļ�1wHfo�>����>EM�-�ñ���p����2�ʂL��r[�>#���qK�_A9Q�U6��(���6����D�51�ZG�%~'���9v�O�$?1�#�1�=E@��BLr��M#��-y���T���7U��9j�j��k�;�|�1�	�R�{_���=L��w�����;5x�[�Sl��"q�ڷ[��1�Фu�E��R6�]r]�"m�f���1ܮ�L��T���PޠN��:�@�7���?ڋu*��I��o�Վ��*}'�uT����1]:
�ݱ�� c�\|����%�KC	�⻯S+׊T���6�C�A?����q� �ק�=�u��|mo� ��N�i"5k@����ǳ�HF`5W�x�4���e�����"�Ř3)��r�P�{���Bk��kT2��f��^�� ���}����
v7���K̸�S��l4Xnq�g1�j���4��t�6���6Ӎ�KW?�A�������T�a�	��Ă������pXK�Oa�^\�g��qU���Ic.	����J����P�W\8o�od�e�S?��>���O�˳��E��)Li%�z�i�h3�u�m�`~Kw��RI����{�HM4 �6�n�8���m��
��بI9g�&ͮ[S������zַć�t���'Ef�{�����F3��Zt�_�٬�foĚ�����e�\A^OEn�_
c��~��F�|l��*�S�}��s�M�6� �£�)�t��=%� �HO�c8>1 ��D��U �h&��L���[��<����@��|ms��<@�I�6O�
y����R���I��I41��L��@����b�c��=q�Tl�"��DA*g!~¢}��ڨoU��.'�=ߨ�rs%��3��T��Y>��Y��1��t�+�w�*:6L�r�t�9�j:aӛ�W�c�Ε�\{L��@�Q��ZJ�
�&~�u���fj��O�
u'��̗�����%|��5rO�NI�Jp4��Hm�@��r~O���0�I�q[E���u�^�+��D=��&ϫ��.fC춄=���R��FZ4rl#i��y�
���Ǌ�{-�~m���X�KK�ݱC��W��P
������H��x��hj��gH0���z��U�D����^�_gbi��J=dC�ŨTm9�;�o 5�=g��
7��(�ZG�zF>��|�_d1~���VH[a�ݬ��X�d��kX��lag������N7����1p�C�z��>��Jq��L~�a@Y�@	]/��]��|՟.f;Т�M������)�w$+m��`��Hr��Ć��@��<@�R9&a��>R��2����EG,����J����y�eP ׽�Fʷ8�֘`g�6<�Bg*�I�¡�f�i��	 '���X�_��+~Mҥ�u��$W��I��i`��o�i�.;ę+z��Xg��;�O�N���"
�\2\��M|���V��X�#�l��軃=[k@�ϖ�,j�H�>�PI�!ś֤�O/��G~�"ig���x�y�Bz�.��F���*gD��c�o#�h�grQ��Y`8e�I��ٍ��c�DLgǃ �F ��8���odk+����,#?�%��`�w����w�K�п�}� `5ږB�>-��p79O}���J�gt@W5f�/WM\Q��
��ɼ�%��~��{��Bp��@��P�3h��J}��	6
�&�6P,)Bv�ӻ�ַ���^�=��9L?�͊���n���N��8��AI�Bu��^�,N���` Z:�&�ȓ�k�\�& ��5U���R�V��եR���Eu��$�@Ő!J����t�&����
l4u�;ŗ�N��S��H��f�uwj)��m�����á�T�)�\�=S[�gy�u䚯։��d򇳀@��X����^Q-g�,%dhE�P��↯�cxIA�������SK3�܈sa��m _��v}bT@X��8e���\̆N~�,��;��|S@YpZL4f΍��t�0��lţ	��k�uibT�YS/$t����>��.Wm_��
W�W��{0u�ڛ�u-��D��K;����W$܊'��OLk4TR�\8,�p9aL+u&�=dT�q*��rFwp�|�},(���"�L�[|UJF����_�f/�F6�����i*�)z���'�,���bN-�9���UkE��]%�̢:��|{�v����<��o
wHBc����gn�K��A��8�t�_�dS�e�'^B$���v$j��#����jz���e#k��G��虶�Of�֌�?A�&N�&}��ݚ�q�
� �������R^�/�S����%�]�dHP{�=�j��
���su�$.�0=g���X�y���oܔ��!p2����� �����_nP�w�v���N��Y�������ҹj��<xQNw�x`�!ᡪ�(|,I�ڠ�Ɂ\�v�2�����㫓B8x�b�S��$��1T��2f:I���o}G���\����n���`;է��\���Ǭ����w!����\x���-f��$��5i�N�
�����^,1[��z<����K�U}��H!n�jkۢt,��ɖ:i=���NaI���F�o� �h�K,��',���e=��Z�W|����23�R�RL�7
3��6�Y���t�8�QkL�sl�Ƹ����������ی���"2�Z���:�O :������Q�hL�C؁�s�-��8����a7 �6��N��ak�4�ĵ8Y�fWN�.���*�ݿ,@̡��/}����2<��X�Bs>�i�l(�ie
��ʜlyRQ�o�,*��mYn�eU�l��U #s�nfc��N>�4j�3�w�>�c��x3�V��D���Ƚ���K4�IP Ld���+�v�q�p �.��)�D?���n�&��f�IR@��Q��j�L0�EZ/����"�����
ca]�,!���_����S�K�z�~"R9�L�Ld��CS�eH�R�qSc`D�㾓aᛴN ��d�K+!����َA��F%S*��Ƃ@��@�l�����V�`=�:�  ��g�����a_`2�9�E�Wɮ*��d�Åfh�:`�?�s���ҝ
q�����v��b�V�܂�ɽOH���$.�� �;^˲]�0�𲔹o� r�D��<�PB8�g��)�����r�.(��@�K��IQ�\��[
�c����w��4 �S.�?9\�4�ׅ�3,��9[�2��t��uh2�6q�E����e�ޒrm��_� F쫻��1��M.��ڜf�� n��\~��^�KZ������_�Q��Ye�i�X7紶�qEt`�3Z�#l&���;��)���İ�{F��u�+�J�˷ִ���Cn[u�����UHB�I�'��Rg2���I�׍���Ǎq�T�ɖbi���FOq���G6��ˎi���!z�zxOoN��Ћ����3_	Ӕɣ^U��:�ط����Q�v���3_(L*p��K,���M8���)=5����tyk����������<��ў]wg1�G�Gn#R��℄
�v�k�P5Li��o]�S���7h��9�U\��j@�;�l���|��a����<�f�4v��2���0I��o2��@zz2���9�
�ϫ�Otdb�S�8��@���4�ι GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0  .shstrtab .interp .note.ABI-tag .note.gnu.build-id .gnu.hash .dynsym .dynstr .gnu.version .gnu.version_r .rela.dyn .rela.plt .init .plt.got .text .fini .rodata .eh_frame_hdr .eh_frame .init_array .fini_array .dynamic .data .bss .comment                                                                                  8      8                                                 T      T                                     !             t      t      $                              4   ���o       �      �      4                             >             �      �                                 F             �      �      d                             N   ���o       4      4      @                            [   ���o       x      x      P                            j             �      �      �                            t      B       �      �                                ~             �
      �
                                    y             �
      �
      p                            �             P      P                                   �             `      `      �                             �             �      �      	                              �                           X                              �             X      X      �                              �             �      �      (                             �                                                      �                                                      �                           �                           �                         �                             �                             �S                              �             �s      �s      H                              �      0               �s      )                                                   �s      �                              
