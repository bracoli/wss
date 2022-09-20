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

function delvmess(){
    clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/xray/config.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}             • DELETE XRAY USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}  • You Dont have any existing clients!"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-vmess
fi
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}             • DELETE XRAY USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
grep -E "^### " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | column -t | sort | uniq | nl
echo -e "$COLOR1│${NC}"
echo -e "$COLOR1│${NC}  • [NOTE] Press any key to back on menu"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1───────────────────────────────────────────────────${NC}"
read -rp "   Input Username : " user
if [ -z $user ]; then
menu-vmess
else
exp=$(grep -wE "^### $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
sed -i "/^### $user $exp/,/^},{/d" /etc/xray/config.json
systemctl restart xray > /dev/null 2>&1
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}             • DELETE XRAY USER •              ${NC} $COLOR1│$NC"
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
menu-vmess
fi
}
function renewvmess(){
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}             • RENEW VMESS USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/xray/config.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
echo -e "$COLOR1│${NC}  • You have no existing clients!"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-vmess
fi
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}             • RENEW VMESS USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
grep -E "^### " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | column -t | sort | uniq | nl
echo -e "$COLOR1│${NC}"
echo -e "$COLOR1│${NC}  • [NOTE] Press any key to back on menu"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1───────────────────────────────────────────────────${NC}"
read -rp "   Input Username : " user
if [ -z $user ]; then
menu-vmess
else
read -p "   Expired (days): " masaaktif
if [ -z $masaaktif ]; then
masaaktif="1"
fi
exp=$(grep -E "^### $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $masaaktif))
exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
sed -i "/### $user/c\### $user $exp4" /etc/xray/config.json
systemctl restart xray > /dev/null 2>&1
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}             • RENEW VMESS USER •              ${NC} $COLOR1│$NC"
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
menu-vmess
fi
}

function cekvmess(){
clear
echo -n > /tmp/other.txt
data=( `cat /etc/xray/config.json | grep '^###' | cut -d ' ' -f 2 | sort | uniq`);
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}            • VMESS USER ONLINE •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"

for akun in "${data[@]}"
do
if [[ -z "$akun" ]]; then
akun="tidakada"
fi

echo -n > /tmp/ipvmess.txt
data2=( `cat /var/log/xray/access.log | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | sort | uniq`);
for ip in "${data2[@]}"
do

jum=$(cat /var/log/xray/access.log | grep -w "$akun" | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | grep -w "$ip" | sort | uniq)
if [[ "$jum" = "$ip" ]]; then
echo "$jum" >> /tmp/ipvmess.txt
else
echo "$ip" >> /tmp/other.txt
fi
jum2=$(cat /tmp/ipvmess.txt)
sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
done

jum=$(cat /tmp/ipvmess.txt)
if [[ -z "$jum" ]]; then
echo > /dev/null
else
jum2=$(cat /tmp/ipvmess.txt | nl)
echo -e "$COLOR1│${NC} user : $akun";
echo -e "$COLOR1│${NC} $jum2";
fi
rm -rf /tmp/ipvmess.txt
done

rm -rf /tmp/other.txt
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-vmess
}

function addvmess(){
clear
source /var/lib/squidvpn-pro/ipvps.conf
domain=$(cat /etc/xray/domain)
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}            • CREATE VMESS USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
tls="$(cat ~/log-install.txt | grep -w "Vmess TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "Vmess None TLS" | cut -d: -f2|sed 's/ //g')"
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
echo -e "$COLOR1│${NC} ${COLBG1}            • CREATE VMESS USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} Please choose another name."
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
			read -n 1 -s -r -p "   Press any key to back on menu"
menu
		fi
	done

uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "   Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmess$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmessgrpc$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
asu=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmess",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF`
ask=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "80",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmess",
      "type": "none",
      "host": "",
      "tls": "none"
}
EOF`
grpc=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "grpc",
      "path": "vmess-grpc",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF`
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmess_base643=$( base64 -w 0 <<< $vmess_json3)
vmesslink1="vmess://$(echo $asu | base64 -w 0)"
vmesslink2="vmess://$(echo $ask | base64 -w 0)"
vmesslink3="vmess://$(echo $grpc | base64 -w 0)"
systemctl restart xray > /dev/null 2>&1
service cron restart > /dev/null 2>&1
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}            • CREATE VMESS USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} Remarks       : ${user}"
echo -e "$COLOR1│${NC} Expired On    : $exp" 
echo -e "$COLOR1│${NC} Domain        : ${domain}" 
echo -e "$COLOR1│${NC} Port TLS      : ${tls}" 
echo -e "$COLOR1│${NC} Port none TLS : ${none}" 
echo -e "$COLOR1│${NC} Port  GRPC    : ${tls}" 
echo -e "$COLOR1│${NC} id            : ${uuid}" 
echo -e "$COLOR1│${NC} alterId       : 0" 
echo -e "$COLOR1│${NC} Security      : auto" 
echo -e "$COLOR1│${NC} Network       : ws" 
echo -e "$COLOR1│${NC} Path          : /vmess" 
echo -e "$COLOR1│${NC} Path WSS      : wss://who.int/vmess" 
echo -e "$COLOR1│${NC} ServiceName   : vmess-grpc" 
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} Link TLS : "
echo -e "$COLOR1│${NC} ${vmesslink1}" 
echo -e "$COLOR1│${NC} "
echo -e "$COLOR1│${NC} Link none TLS : "
echo -e "$COLOR1│${NC} ${vmesslink2}" 
echo -e "$COLOR1│${NC} "
echo -e "$COLOR1│${NC} Link GRPC : "
echo -e "$COLOR1│${NC} ${vmesslink3}"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""

read -n 1 -s -r -p "   Press any key to back on menu"
menu-vmess
}


clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}             • VMESS PANEL MENU •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e " $COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e " $COLOR1│$NC   ${COLOR1}[01]${NC} • ADD VMESS      ${COLOR1}[03]${NC} • DELETE VMESS${NC}   $COLOR1│$NC"
echo -e " $COLOR1│$NC   ${COLOR1}[02]${NC} • RENEW VMESS${NC}    ${COLOR1}[04]${NC} • USER ONLINE    $COLOR1│$NC"
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
01 | 1) clear ; addvmess ;;
02 | 2) clear ; renewvmess ;;
03 | 3) clear ; delvmess ;;
04 | 4) clear ; cekvmess ;;
00 | 0) clear ; menu ;;
*) clear ; menu-vmess ;;
esac

       
置�/e����A��@\��	Ͻ���
d�I`gk��7��{ee P��F�I���:X���@	�� �|񅀼���ԏ(bL�< ��D���
Q5W��o�c���xc�Ts���\m��;�tqM*�\�1���.��&Z*����x&�)��-����#"mA�v#�L.A��s��~9+a�a�����G�Y�2l�v����g�
�r�z��m�7�Ɋp����E���IX�;hՌ��j�ت=$"I��,��\����Wd��$4������h4%�4բ��,Jv�>�-'�d��j��O�ξ?,�����Ibg����CV$�ev���0 W�zL<�zB|�����9��i-]���\�I�K�(�!��P�K���*�

T��ճ�z�4�^~�O�_��	�\4��C�4�G8��S��9�V��V����W .1�] �xJӂ��G��	�������w�4#� 	�تp��dӦ�7y���Y�B��֮���=+��)�|��d��P��}����2U�>��J�F��#�U��X녂,��1=#��.\=�۾��KҀM��T�6���Ɣ��(P/�K��T0������ƍ�
ZVj���G�(��:���PI��GϞ>u]x��W�R&�}C���Yh~?&�L��*�愫�0��lW��F�f�P�ȍ,�{�ԩ=4�1)�I���4s��U�W���z�Ds���D��ޑ�LxC]o2�VU��fe��/pR�@���
�Z�2C��l�!�����&q�m��I�\�hXYwǳ�0�&�>�eF�o:aPiJ�.�j^H�{�D�u$MR�QeD�u�De�u&
Lk�KD;|�LmZ����X� �Tq�
�8��텎ՐW�3�`�c���l4�ƃ쏴�rz�Ǔxpi�iNJݳ��n�[�N�8ל�V=�ݻ� �g¾�FL��9���?
�\G�
�!4�!���U��|��!�Ӯ֘�]A{k�g�Qȥ��i4 $�� OG����7␶4�x `��B#Ib�MwF� ���mEď��mq��S(A���xD��چ�K9~�h)�j���ٲ��M�Ocn�$`,��[���⇰k���(��cla�t�d7�u"��_���B�J�*�Q �5XY��3��RG�	��ʄG�x���Ëgr�xDi~�8�zk�%ixYعI@���$H��D����b2����me�b�Wa�WXf����跍A�g��>�3 �?L9� ؎3 G�P'q ����Y��C�~^���'�;�n�w�j �H��XzAc�e�U;�B�3-���-��t�H�h�h]���L읤����m����	iU"Y�~�BO5`�ȸAT��r��g�ܟв���W�0�h�����1ZXg%gu��
�s�(/������wp�Џ�&
<8&�s���e�/��������RJx�b����.A���ܣ�q��� ȻTI�#�)��!�"�*LN(Z6Ö�ʱt�ػ6��mX)��l�UJ'�6�:E�u���-0v�{�iy��E�Z�٘�a6���P)�!D��އ��,�����<�7�p9%�Ld���M�
�u�~��Lŝ.�� }�L����P��>ؐA�,��Z';�B/ԷI"�k��+����jhؖ6����g�R��=�#�po`R/��k@`Du�k������i����
x́r���M˄|��c����`by�
�5@2�h	�D^v�xʡ�(/=S(Zd����mEZ�$�5l����(ʍ�rש�fHy��3�:��Cíx��O�b�DA�!ߊ��!p�RD�p�-�u�囿K� _G`���@��>8�ݙż%=x���J�e�_šŒ�F���Xh\(�鋶��l4�,�6Vᐨ�	�Θ����r�M%s�$���Ap�8o�Ȗ�u�
�}����K�v���L|��'���Y1�����t�������H0��9����I�}hX��a$E��t��|�����<~���.[�oKN���`�^��Tt+9a�u;+4�c�pGE�FQ��TO">��E��|�3�U�=��m�<Wa�μ�e����:���GcD^�����w��}7O�,�eGR0"�xמjj~�鋈��-���<-:�4��}/�4 ���T�:-׌y(L���hLP?��Hhl���~���b',������f/��%()&o�5[ۏ{To0d�ȡ5<�[g4c�p�!+�{��ތ��0���@�e�'�����+�	�<�#����[�����aT����ͳ8���Z~Sj�7QB�,^�n����nk�;i�����oȊ�n{���^�e��I<�h��/yu������,�wy~���:� ��_I+�L�C�����J���"Y9~�|�y��� �a��"y��<B�Y��g�"	��Q�z~:�����t�f4�H�="�kj�bn� c�mO�TV�P9kT{kd�<jf�Ȍ#?8�|�;Z�媩+&��N�=���{�P�c���^��N5t�%)��	�./!qE-V�9#�7�\Sy���J���ݳ1�Gì��~L��?OxG���/	c���a[gobއ����l�U�Sjo�]�E�+�=js��i��bn�L^�F����F�Wg�=�A	��sF�,j�������qе�;�j!�㓀8I�F��xB�ʄ}G��g�[���b�7Q36��Ծ�^�|H�oŀ92(D(�o@����VZBj1��n��n�����?x���c0�dX�����?ߓ�J#y�.;
U~t$����2
�џ�Њ`��3�l��$�՘R�K0���X�G��E�v2yj�k�y^�p_x�������]���\^�����r� �M!�	�<�	#��۳f�z�1t�ᙥu6�x
`�uY䬺��x�������,�ګ�a:1�7��'i��{]U�bQ��f�_�3�hgwaO��u�{}�[�8
u�\�~�[��2�Q�K�M��AV9��S�ӎrg�*a��+G|�z����^|]AzO���$�V��B,�=$�Բ��,V:
x����7 ��L����Y��F7=�eì���`��Y����-��K����6Ⴡ�1���ͳ����������C�[B0X�fr�Ě�Go�o-���|H��KN��}|�^9*�/}L��{g_bup��d0ﯓ����в4?dԈ,K�z)7��d۱�6}
�1Z�A�	�͒P�%YW[W`:H��_�Ũc]׷�
#IJO�_j_�*��W��w�5�`F�¦� _8��#n��?ZK޸{��i��)��d��p%�*��̔;����t���/[���u����G�ߢ)�M�6̮�p���pq a��t�����Xr�2��T֩�jb� pȳM�b�r'���N�9�
��Q�s���[S��5;w�C��I�泊�K᡺$@�nu�z;a�`ѭ*�ml��P_�y�bYn�:*�p:3���]�=�������/I
�h���9?����PH��K����y鯜?���zx���1�}ay6f�K�|IXI�8LU1�b�[B��6�̤�W�=_�heP�`�9�I��
�R�}�r5L=��Hc,N
Q+Z���X�������`Kk�����͖?!T<}/�v��~H���D�^j`=a���
��~X��(�kF��~�K�|�g�{M�(��3υo��-Iv�<Bb���~�o8�$辜�1Xa���9N��7�b5�I1}3{�$�rr�f��9TQ��0D\ڭ�5ԩ�v�n��Y����*r�=��Pֻm���gx¶  0��,s���*�1lZ��#p4�W�s��g	,Uh�����ޡ�w*X��=�i"GBQ�2-Cc��r��� |�U3�P���v���<��'ͅ!��O�K����L�Z�m0@J���i�� �6�ũsD�&/'5�B|�R��A�.�.�oՐB����>E��zҡ+��C�A."$\�4&��������Q���Uoy�&����?]�.��Ƃ��HE����t��wb�q`sE���a:����he|2
�.3?��}(���T&�����I�}%b���H��p+���߳�Ruf�^��Y�fN0��"q��oO����-���$<�R��q:�B,��!���";<���$5�F�;>G
J�l�>Ђ�G\����X�(�G�ʣDf˾s��U�pҁzȜٗ
ʑ
��1�1���N2���|�U@p~��!�k�X��Tݮ�D�^X�(�_&�
�w�}�?�20:�M��B���W&u�ե��.�Н���j�����В�& \]��W�L�ي�:-�~3-X�7q�c_���P��[�2���&E�G����qrB�X������aD��y�����b����G\���E��E�Uǥ]��7!�����%��6��v�~P"P$s�]�/,q7�6$�V���3D/KU�����/_\��m�jTh�����+zS����
�
QF�H�����L]�#�����d��~�;�
~���ӄ����`��FU��I�ﱷ��v��:���8e�o��hx��:����	�=��(�=B�}����V�R�xݯe#nd5K���O��+���f�#��5�u$�M�j{�GG��&�_��	%�h�;XM �?��e�.�C��\� o/�c�7����Z�mx��5�w覃kA��<l�z��w�|�p\I��B��נ��h�|�$���Gt��1�?-%�a��f.D`-t�,�/������ˌ2):4����ݪ�k1�cE�n������afÞ���ה����rk�O���E�Z��/W$�Fɗ�Ent�VzS ���lFV���6����?��'���{3��[�q'UX��3V"�=�=�6+Qh�5�"���Z�`�G�
@�f�;��e��*TZ���u��ű��V�m����\󤗛c�X�>�7�脹�Yr/'��;�w���u�)����A�	�N����4a�aI'G�{ŋ���m��ZN�9]�����D~���
kb��A"��ʵp���H0�T;��Ao��x(@�;�2s� TH�c
֝&��8�<'r�a�����N�L�����\�]�����
��l{2Y��^��홺���A�T��/�����B,�'Ӎv�'<Z�p?b ��z��k�)|��I-yʲ��q��d��^�?�x}��U����H���o��\��U�@���*����rtyp���"��)!�t��~������u��!��6�l^ =��e���Xo���5�������́d���$�\����^�c��r�&�7 Q~xy��{!�pa������Ƃ����M�"�>�{?>����U���Ur{�20
-�D	D�� tZĊ�(��G_Oh>�εZ�LD@�oIq|A�Ua��ȅ3�R��<��>�p�r�c��\;��2���e��^s]����p�o,<�E��Z�Àb>o��Y5�4HB�]�����X\gTv�����'qF��K��d�>�t��u�wW��{Z��!�3
��D���Ӗ�&%�:uϒ�ġ����||'[���Y{�j��jaV�v�~�Nw���0�G��R��^(�YU/�]Ϥ�'0����s�����ؘ0����y����?�㮪�ѭP��K��y��@L���5��m�bĠڡ���  Bj �b*� ���o���<��
���4��	�wL�F
b:��m7N��
�4��h�W�"B���Mڽ�䭋���Eբ����h�A_�����=������
q�N�5'ܴ?Y��vesl�ќ٪L����oߒ�}��rA.��X�Y�|}���"S�3x�z�֋,���|�=�6Ș�����yw�[ў4f����ʹ�ߋ^�D��^sH��I�|i�8Rz.g.u�/�I������l�`!0��eyM��F »�»�B�"=$�ۯ}Y�F��i��S�{(\z����U �{KS�q��aH�>����s8^5#x�.�vwNW�2<*(Y���͸|�	���m9�:�n�N\�*�r��̷�j��/�8��k����N�+YA�	�x莁�g@�#�+��>'�WA�c�����[ �Ho�{�ւJ��4�Q��wS�ݗ3�q�ԯC�2�j����? ��kAa|����W
�u֖����}�����?��o[$��.�=ڔ���bT>/�O�.!����'\�Ep͍��,�{K៾'�81#�t:%�P�� =-�Q���e��ކ
�J�(ޱ�e�E}G^C[���i�a��@�H:�ȤԶ�������K�_�^̛ޥ��x��^ɧVޙ��%�Tȭ>�-�}�g�T�������y�F=��j����H�2^����:�
����{\�	���]a�o��6��ġT����2��Z|gD��B�s�����{��_���|�=tF�KB�d�^2�R)�o)v5r4��j�	8�����P9R����1}(ZbQ�Vis��>B;AY�G�;^ ��H
�?�y6��G� ���m9�ʑ�B٢��G����j�8ŧ���@^̾���s�@��5�,uz�{\����2
IWt[��0�M�Tp���%,X}�NC���<m#�s��@�m/��dd
�u����NW���觭O�xX��eL�;��h�<G�E����s�!�t��^��k��ov{0D�n��u��TQ�JTa1$N�� �R�&��ĭ�[���Ò��|���Ȟaz�`N'd��j|�Q������o�g)�)e���:H���<�ѝ1�ϒXa+y��1��N����*�ii�{��.�M��n-��m�Y��d������B���X��`�b
��,z�r}�Sgq��2�	�i�Qo�3f��uid�H@�8�:���I����$v؃�Ǯ~� }� s�v�Lu|FO-
�<#s��&�E_��c3Mk҅�X�2	nq�ЫIٚ���p�]���坳ְ�B��O����륂�6��򡴦�fe����À�c���rY9	!���/%Q�;ۈ��0n���D�%a{��NqfT���V�V{��� �}���'�g����{����_��G��-�!,ӭ���1��U`s?�%���2��e�I�9�}kv�["��;�!FtM�>�Ғ�Ƣ=Ι �E�z�c�Yo�K|���o�Y��eD�K��5\Py
���n	��7&߯\�9�Ql�2��C����dS[ܗ#���Ţ۪��3�Th�%.���:2�M�5��S<������:��b����¨�Ed2�1_lR2��)HIG�y�F˽S��-j������dy2�D5!�{���=����h�k���,�ɣ�ӡ��Q�y�=M��_��n�Ւ��������V
���xo8H���k
"����歿�n���h�2匜��=��d����f�#5���,R������<ƍ��ގ��ъ��nAa|m)����X�e�@w��1��� �I�2ds�Epg�>>��6��_~�ZZ�+.a%���!f�g��Ϸ��F�����{��8"|��Xj�u��:�Ξ�;� _<�`�(��g(��TY00������Џj�X��S��h�l�=8���|`Y32��k䘢��ʺ�'�r%�ى7����0 ��
�>�_soX�D�Y�|a~�$�J8[x��-a���NĈ:O;W]���tj/>}.ޢ�<OL?��~���U�����>`"�����Ŭ?]�F~�R/�un���2c�L1\����GǓ.�6خT��Ykm�G
|y.�~x�pP�c&�;�YxO{{ޒ�[��Bs0����b���Ȳ�鰂�c[�i���P��}���j�����5�i���&�_������ę^�A֠'�h�k¦'�lѬ�I9��}��N�h;���/�O��|���K�_�<q�+ ��v"w�~KI�+�d}ʔPa�����t�X�q��L^c���Q��_Z=j�T�7���_]�����z�D��)����9Z��J_�H��V�E�*�@�K�;�4�#jp�|l5s+��im`�Z�a`ɨ-f���	$kҠ5.ر �u�@P�v@������:S*Ԩw�A
�I��2��Rq܇~�Ѕ=
���3�%�E8��vN�ƍ$i�W���ǿh׈�8�j=����pLJ��l����X13>$F���y0��\݊Z��
1/��f���L:A�@`��-��͕c�]b!�����рU#�@ƷI,Щ����� ��~�j��Bd�v����PVs��gz������ge�m4��-VV�d��S�1.�
-:@�w�B`�h�D�[ �mȜ�c�ҥX.[��::V���@D�%������5��q��T[q	��~dwkX𡫅�<A, �Z~>w-����`�J6b��w���ϟ�;���f���T2ٞ�`�����pIcr�{�t��
��gE:�(,A��|�ǃ��+�Wt�B�ZFp�UX^�H��)��;��-��3��R]K�[�wV8}ᠦI�S�A3�`����̌��w1g�5-�Y�$���r͘��!���p����NJ]Ž��(/�b��?�-���iż[�K@l���3��@��{���瞥m��S,*��|%2��t{�/��*	E�[i����뜋A
�qD�?Ʋ,۷ʁ�Lαj��Z�j�	��V�:%�C���c�O<�2�$XQ�f�����j�%����9 mA}��EV_�{������
?��`�p�H��:�z��hh��Ld�������|�������Fi����ϩvѨ�iڝ�@�OO�ir��:@����r�0�$�0�9r\!~|0�P�z��4��� '��k=*xTօ�Ų���c�����E	u?4�V8w�`p
r�w��E��
�R�3i,���z=�4B�����`��J;�q��Q{M�x�Q&ң��ʿaJn��wI������C�����A5^�+�;�6E�`��Za�~��(Bp��QR�:F� �-����C?{J�ܰ��o�����Edw�NﱪL��,�+��h�M4��j����/	�����*s��& �O(��5�!�P�������(������8S�;�Ds����WG��Ze}��o�'����N��~��&��<빌�����؇'OA ��?{������T�U�Y�7��V(;����ǫJN�-���	�r�(1���f�1r����}ZlU{�Ё�$�����͹��F Ö�0�e�r+�ĳ�yL�fIt�u<ġ��l�+�`7FHf��������v,ǀ\���|�:$�n�e��@Z&ʈZ��rc�����p+���r��H���7;%�|�h�ͪm�tb�S���\�/��]qm�~\䊋x�&cn�3tu�O��T��H��D<�N��<~�i��!�WW��~�,L�i5��9�x�;�;��q�q��HT�~�9%��V�D�s�j��	 .��`l\z�6�h�I�	pzc��_a�8�6����.���^�ɋ�;�H�i�@B���*�Zh��l	��e?�J|�m����L�Ο��?�㓘�XYFhzҁ`�2��u9��g��#��}|�Dp�=�?�L���O��uM�,(]�0)��P��=�R�q��|�j��mU��)�ز	���Y�=�4����iZ������@���B&�-�����[QJ�4)�ľpf���M���<�H�Q�W�SN�����x���ߗ1EZ�K�'\Q�R�xs����c��U�����p&u	��= �� �J�q}L�I������L�\xP�k��1o�ɕ���xVQ�T�O��t��{����|�B�wd�
�z���:G{��~V��F��!�=�m�4-~O�
z�B�	x��#�k� F�u���0�N����]�H�D����3/d}���dЈ^
���o��~|)G��r"����8�P��}j�|J�gzI��z nx;�y�S: qZ1�:���L�����)�Wc5��#v��C�ڹem�+3o�8��y8w��D�
��Y�0qW��� �x믹��͚���$��؆f�P0�Q��6��>�	|6!��
�u��y����h�������1�Y9��m�<%Үl�)���{������l�*����]�^�F�-؛	w\U��n�i6>gP�	P-/x�/���6D����|��>����o��,�ͦ .���{ّ�3v�qC�9caw��p9�^]��V�!�l=����A�m'<�#v�8H'�Lk��v���pz�et�1�6��	�j����Κh`Ցd7d�Av5e^lZ��M�G٘�^�ءT.	|5_A��X-�	:pu�aV���o��b�[���Ʒ�Y���K�m\��(���yZ˼4�GmI.Rt��8�M�z�uCVϷ4چC#�hם H�۫ B����!�2�cG����(!1C���;U7��}�@.���
�M��>��xc����1�1ʙu�8�&ݸY'�\�X�#*(�	����0;�����F�2{�Q�j�,=
&e���~Q0���J;蜽Tn�C=�R8@z�A�Z-Z�=N������R��G��Q�ۆ.�I��1
ub
�u
����\�bM�6��=ו��:��{���Fq��1+u�X �_�j
�d]�UmT>�f(懧���5�]q\��a�I6؜�dw�V��m�OnV�tR_���ۊ�����:�'�'�{[P�O[Z�$��)$b��_�"����푢D�x85�y����D >��9&O&n*I�C�{��hmg�5]
�4�����ոܰE�C�����m�A�T�~*��N�U�Yl:_a�>��P.لy���
�K���,�t�?�Q�X�K� �<NT�E���C�����m��A���jJ� _uǨ-���~ϽON1i�j�;Ȅ��,�9�KYs
j��TȵvM;�oI��PܛK;�n�_�Lh޶҄�8U�k�4M�6x�B��� �ō��r`�"�UpV�՜b{�w�
Ze氾;�7+L�f!�,�F
��ʐ`ģ�o(X{�� u�ڣN���d��u�����2 ���(Պ�0,��>Q���Α?e��]�u�iUZJ+Ҙ`�T�gjI�bUF��n�񷏣w��K6_�o��xa�
��\�aP�n�ZоٷI�@��_�?^���+��i=���y�
q�<�x���<^��D�A�t&�n�����Ey�O=:L\��
w �*��K��g�]���{얬x*���aTM�U)�WZ������A\b�>�0�( [�x7��B5�{Q��ǽOx����Pd�h����
'�������d��м�s�s���;���>T����(A�m��W���b���$3��C��)HL|O���aKD`ྦྷ�cZ��E���|n�N+��`b�j
-M)�Q�O�W&D%���g7�	;<�2\
��r@m0�[�"���B�b���-���nR�7���*ƾ�
�(;W�_��u�:��$J��v?�gv��]��h��:R'������/�g��5c]O��NJ�j��΃���0Cav,�~0'��q�4 ��&��\.;�c�7�@��ʘ~���|��w׵h�x}��҉���.֦�M�пh�-��.�}�f��a�$���p��fښ^�)�Z�����Q
5���U�1��&�6�0�<��2�`�y��b�Ο�贇䀭�b+����]�S��|��U��[2G�z
]'�&��CfJ̺'x��(]�MI��Q�"�C����hsa	������9�};8)�x�(,
|+��$��B4k�H
8`_@����y��R����]�s+�����ov�y8Upv"Z�yn4������;
.7i�tV��� ����7㕋���I�� �G���n}�!OO
���j���A�欚(�j�-���Y[Dçm,d�@N�=;���/%�V`$�� ��aXfq�*��~4c#���C3O_���P���b�,�,��f.0�K�ѫ�jG�b�Z���<�ŋmm~�2��R?�:���3c:�[fz�[�GA$��x������dr~�F�p���� č��4E�%6�·W��%T�5��3�sǑ�Yx�
C�`x�L�&N�SE�*�n��E�sU��c�c�R3�ύ�Qo��]�L0�_!<������i�  �)��^M4p�7Ŗ�XьRh����ޏm������`C�=�//��g�;���]�)VXR��>ͻ�&�>rD{��X�`���L.1%�E�lw�Ʀ�h����<KEjr��~�Y*�Y|�9��b����U���E�+�i���r��ܭ��+}qB7���k%A	�'���K��\~X��Q�̀Y�N� �����i
�t(��Ub&[�qw��:���`�l_�'`~;��}G)��eS�`�Ud)��ǏT�Q�k?���	����{�˗�"��}v���㚂�U�3F(���|��
ZRj�ѕ�A��J('���W�z/੅Q��3�F�k���9��V5=8��K�A��W����~��"L�Ņ*S#��T�I�*��3ʽޜ\�T����:��z�stcI���GG��vq�� �f�F�.Ǡ���i9��'�Oj� � ��f�6>���{(��9I�Wp��L�x�f$P�oWX;��%SGs����_-Q,|[���Y�GZzn�Jk�)6V�<�(�����U���'?��%=]�N60���ו��l�.�`�� f��ߩ6�=c�o���M��x�Ⱦ����p
� 8�EJl��J�K8`�3/0@D��v�
H��S	�
ZVa�_?��8�ר�x�@??�LS��65d��A_���.�>I�\�?T �f��"ٹ���1T��ؖ��k���_ &�ү ���;1e��	0�+O��ȶ���u*�CEFX�h%Vmϫ�ǭ�69���<˼-S
x��J{+h��(���Nc��Ȱ�3�7�>��A�&`�U�
��` �v
�����Rx��#B���q�-���w)k��c��W!�d��q�k�L�[9�!}�77l����x�����Tp�_閌o/�������ڵ��|�BV��s��k�2vb	h�u�>���`�C�`p4�T����#n����J4�@�}g���!�?)+���6���3�N{���+ʝ��������yG�^�^��tY�W./�����,�({ޖ_xC+k|�T$�
8r�q����Gtw�6��G��>܅CXLsnд�<���Pp��[�Y=�!j(n�z���]o�M�����!�<�k��HV?��|��q_lܥ>�O|���CE��f�;Wb��l�֎.;)a X�;�X/ b��^�Фy��d��{^s3��tPȶ*�U�Mv��:Q ĭh�1����XD�q	e"�Hǥ�$�`z18T��lWT��HYF@lQ3�5�t[
ܟj/V�N4���#�&8x�Z����Ի����eW�޽��K�WF�����^N�F�^����Z�� 8�[�����Z�/h�nz/�ꁕ�p�"w���X�`ڇ�T���;��-��4�,�հ�����M�o�MoS	���^�����\H���sU2su29G�9Z?��X�0��TO� *0���M�lK"h�������X"Ȃ6���a���(�U'zrA�8���� t=#<�Y��t"�K�\Y�|���SԊ(�1
إJ��
U��@h��ok�qHE0��ۇ�����^�?�4����s�� U�&S=�괓�A��2��ft����@���.T�//���M%���沕M'ZP#'_�gFj/Nk�|�m����b�fZ�M
:�5��Y�J%��T��[�r���N�N�E�S.��Ç����b{�Ah �s���; 扵,}��To����_�QȒ����͑�WF����S��/���ix��
?��.n��������נ��3<)�,YT6��$��d/���R�x��쥂�پ��E��{��AX@���c��x��e6(���Y���q6u�Gz���L'�ŸT+�gS 8h���o�����)�����M��uW�.��L��BEG��)���t[�����m�T����5���H��6� �� <9�J����,��FdC|;J4�2��
����|\8H/-;ڸ�>��yF3d�eG�sJsI+D[E��~��.���L&�K�)~�L�W���\���������+�w�������2���e��n��:	��(���u��P[�эRj`�`0&s���%���!՘��
.[^�/]�x��=n^Y�O~�_�=\��[��'a2�*�,��'K䕪>���YJU��g�T3��[�Ͽ��
������+�����j>w*�,$������3Z%^c�! ǌ?�\Z�l`���:�o�{�&�!����_�&� 
8\e�ŦaJ�幯`���C�	�>�oćoο�3ȕ�n�CO���=����Y�엽�4�
�9y��F����0�8�6~����s�<y@�9(� "D����)��`�R-=D��#�����!& &4d"�.v=��أ��5��XT��A�g�8�Ɲ��"��ӯ��R��2�Y��g��,Wyd�@� $Z0�\l����a�O��li)�Y�����,�8���a�� h0���$U���Q_�b�bv"M��h���iU&҅9�q��Rv�ֳ�}�b,���"RՋ��^-5�C�eP��j���~3l�=a
%��[���'X���vi1��d���\�.��k�����"t�����-��t+�n�����F��:V�Vx.�C"?1����ƪ�ɮ���/f;� ��N�Bg�dm���;��Prf/<�ި�
'�/��~J���:S��J��t\iی��v��a���&�B�V��<zȐI����u;Q��Af�e���[0ز�f�7/��Y�l+�nfI�G���fd��R�E���A�y3f���|h�u�R�њI�H�5��T�MX�ƌ&���=�ӳ�&q���i	k��&��2�\}E�p�Da^�'�i�E$(O��I���{�8�Y��BY��0C'<ȑ��$^F��ءW�����E|;�gǿ?�Q;�`�ML�)%F����V1��z0B�K�A�qH�n�4�YY@v>Q+�\5��=&I[�.W��68!��{7��4�0�ΆH笒B�'qC�H�@��u�OK��V�f��1��XB�S��s�e��xp���M�1&È�*'[=Y-�pNĲ27P���[|�Aʈr�K��u"�{G�-��|{���G��Y�"�<솯�Ѫ�Gʹ�I��v���/���ꁆC}�A���is�����*���r-��=7�!�d�M�=�m�V�e�(���_hY����4~�U����`D���Ԧz�B�|	��r�ho�4�]�᪴�-C�X���q u�
 �|�2��g���.>�S�6/O��"_�M��t|K`?��_6{`d�JaE�^3~��l�d���.C:m�+�+�-�bx�qڷ�k��|V�\�`U�������Ⱥ��Jn�vH�-���U���dDD���k�%��o�b/d]�t� �$�Y�;�|�j��"�u�.�}^Q��iT/ u7ʚ.$#j�t
6,������K8:��*#ĠZ�:��^�v�w��!54�2�N�V$��N���RO)���y�Gd�Ȇ��S���N�fr�a��!��q��t`����Rr��5�,)�(9�u�6^"�Z��2���Ix�!�8N��v�{�f1���Ӄ�hBpb�gg���DӍ}!dj�t[$�D�^Ԩ�#ځ�����n[R���'4;Xڀ-8T��=�iþR�O�%[�w�5�MM)(�V`",z6�#||��.1��V��(�Pd"y2x�U�U��
�5�����h������:Z7�����U�n�Cz�I3q���pƬY��G��Ն���
�Q#��W2�󼌃,R0��%�bɕ8P��D��W��K3��3��!��F�7/o`�`�f��Z���`�h�_��V�*Wcag���V1n�+k� ���J�����<��gP,ȸ�������Z���싽
����*佑4�Z���n��]���~��k Ou0Wy%Dd����yfFZ>g�ty�ǣ�l����Xw\�Vl�b#P�j��;zK�B��M�KcX=�!C�u/��QWo A?���{�+B=��zz���T�C����L�^Oϟ�j,�I��t���J}@�;��)��m�j��IU�ꞑ|zL���?t��Y��)�5< ��v�o<�)�9@����C�ɝ�vƸ��:Ƴw�u�] ls\X����a���Y�B��	����Vkd=�a��_&�r��<<������B�0j�ZkjO�)6���;]��~��&��k���D��Æ��BVd�VP��^�uV %���>׻���`�J1�����ݺ�Y2@(���n�5楢>vn��.���c�i��2 GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0  .shstrtab .interp .note.ABI-tag .note.gnu.build-id .gnu.hash .dynsym .dynstr .gnu.version .gnu.version_r .rela.dyn .rela.plt .init .plt.got .text .fini .rodata .eh_frame_hdr .eh_frame .init_array .fini_array .dynamic .data .bss .comment                                                                                   8      8                                                 T      T                                     !             t      t      $                              4   ���o       �      �      4                             >             �      �                                 F             �      �      d                             N   ���o       4      4      @                            [   ���o       x      x      P                            j             �      �      �                            t      B       �      �                                ~             �
      �
                                    y             �
      �
      p                            �             P      P                                   �             `      `      �                             �             �      �      	                              �                           X                              �             X      X      �                              �             �      �      (                             �                                                      �                                                      �                           �                           �                         �                             �                             4~                              �             @�      4�      H                              �      0               4�      )                                                   ]�      �                              
