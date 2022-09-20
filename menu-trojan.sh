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


function cektrojan(){
clear
echo -n > /tmp/other.txt
data=( `cat /etc/xray/config.json | grep '^#!' | cut -d ' ' -f 2 | sort | uniq`);
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}            • TROJAN ONLINE NOW •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"

for akun in "${data[@]}"
do
if [[ -z "$akun" ]]; then
akun="tidakada"
fi

echo -n > /tmp/iptrojan.txt
data2=( `cat /var/log/xray/access.log | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | sort | uniq`);
for ip in "${data2[@]}"
do

jum=$(cat /var/log/xray/access.log | grep -w "$akun" | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | grep -w "$ip" | sort | uniq)
if [[ "$jum" = "$ip" ]]; then
echo "$jum" >> /tmp/iptrojan.txt
else
echo "$ip" >> /tmp/other.txt
fi
jum2=$(cat /tmp/iptrojan.txt)
sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
done

jum=$(cat /tmp/iptrojan.txt)
if [[ -z "$jum" ]]; then
echo > /dev/null
else
jum2=$(cat /tmp/iptrojan.txt | nl)
echo -e "$COLOR1│${NC}   user : $akun";
echo -e "$COLOR1│${NC}   $jum2";
fi
rm -rf /tmp/iptrojan.txt
done

rm -rf /tmp/other.txt
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-trojan
}


function deltrojan(){
    clear
NUMBER_OF_CLIENTS=$(grep -c -E "^#! " "/etc/xray/config.json")
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
menu-trojan
fi
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}           • DELETE TROJAN USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
grep -E "^#! " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | column -t | sort | uniq | nl
echo -e "$COLOR1│${NC}"
echo -e "$COLOR1│${NC}  • [NOTE] Press any key to back on menu"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1───────────────────────────────────────────────────${NC}"
read -rp "   Input Username : " user
if [ -z $user ]; then
menu-trojan
else
exp=$(grep -wE "^#! $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
sed -i "/^#! $user $exp/,/^},{/d" /etc/xray/config.json
systemctl restart xray > /dev/null 2>&1
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
menu-trojan
fi
}

function renewtrojan(){
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}            • RENEW TROJAN USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
NUMBER_OF_CLIENTS=$(grep -c -E "^#! " "/etc/xray/config.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
echo -e "$COLOR1│${NC}  • You have no existing clients!"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-trojan
fi
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}            • RENEW TROJAN USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
grep -E "^#! " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | column -t | sort | uniq | nl
echo -e "$COLOR1│${NC}"
echo -e "$COLOR1│${NC}  • [NOTE] Press any key to back on menu"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1───────────────────────────────────────────────────${NC}"
read -rp "   Input Username : " user
if [ -z $user ]; then
menu-trojan
else
read -p "   Expired (days): " masaaktif
if [ -z $masaaktif ]; then
masaaktif="1"
fi
exp=$(grep -E "^#! $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $masaaktif))
exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
sed -i "/#! $user/c\#! $user $exp4" /etc/xray/config.json
systemctl restart xray > /dev/null 2>&1
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}            • RENEW TROJAN USER •              ${NC} $COLOR1│$NC"
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
menu-trojan
fi
}

function addtrojan(){
source /var/lib/squidvpn-pro/ipvps.conf
domain=$(cat /etc/xray/domain)
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}           • CREATE TROJAN USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
tr="$(cat ~/log-install.txt | grep -w "Trojan WS " | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
read -rp "   Input Username : " -e user
if [ -z $user ]; then
echo -e "$COLOR1│${NC}   [Error] Username cannot be empty "
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu
fi
user_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)
if [[ ${user_EXISTS} == '1' ]]; then
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}           • CREATE TROJAN USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}  Please choose another name."
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
read -n 1 -s -r -p "   Press any key to back on menu"
trojan-menu
fi
done
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "   Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#trojanws$/a\#! '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
sed -i '/#trojangrpc$/a\#! '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
systemctl restart xray
trojanlink1="trojan://${uuid}@${domain}:${tr}?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni=bug.com#${user}"
trojanlink="trojan://${uuid}@${domain}:${tr}?path=%2Ftrojan-ws&security=tls&host=bug.com&type=ws&sni=bug.com#${user}"
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}           • CREATE TROJAN USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} Remarks     : ${user}" 
echo -e "$COLOR1│${NC} Expired On  : $exp" 
echo -e "$COLOR1│${NC} Host/IP     : ${domain}" 
echo -e "$COLOR1│${NC} Port        : ${tr}" 
echo -e "$COLOR1│${NC} Key         : ${uuid}" 
echo -e "$COLOR1│${NC} Path        : /trojan-ws"
echo -e "$COLOR1│${NC} Path WSS    : wss://who.int/trojan-ws" 
echo -e "$COLOR1│${NC} ServiceName : trojan-grpc" 
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} Link WS : "
echo -e "$COLOR1│${NC} ${trojanlink}" 
echo -e "$COLOR1│${NC} "
echo -e "$COLOR1│${NC} Link GRPC : "
echo -e "$COLOR1│${NC} ${trojanlink1}"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo "" 
read -n 1 -s -r -p "   Press any key to back on menu"
menu-trojan
}


clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}              • TROJAN PANEL MENU •            ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e " $COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e " $COLOR1│$NC   ${COLOR1}[01]${NC} • ADD TROJAN    ${COLOR1}[03]${NC} • DELETE TROJAN${NC}   $COLOR1│$NC"
echo -e " $COLOR1│$NC   ${COLOR1}[02]${NC} • RENEW TROJAN${NC}  ${COLOR1}[04]${NC} • USER ONLINE     $COLOR1│$NC"
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
01 | 1) clear ; addtrojan ;;
02 | 2) clear ; renewtrojan ;;
03 | 3) clear ; deltrojan ;;
04 | 4) clear ; cektrojan ;;
00 | 0) clear ; menu ;;
*) clear ; menu-trojan ;;
esac

       
����:/W�D����a�*�����/��#NM@nZ�vߊ��S�~�R=g(�:ɋ_b�nl�'�Y�+�?��k�̎W��T���������V� ����ֆ�� �[�\lZ�(�x0}�y�z�uQӠ�����_� L�(�i�x���Ukj,
㠯��D�+_M�5����JQ�Ja|��4i�4�ndw�D��a�����9vՆ��i��ތUq�.�XS�	|�!#����M�o��H��u�1wm	�V�����^^
<kk�@j�H�p�I�r��F�Erb���٢	��f���x5zs^71S��S?�7�e�o�wPs�N
���}�����:R6SHϼE,UV�����q����۾����"O�)9�h��K���A9�E�״��>{�Ƽ�7���ȍ2u'�&��Y����[̊[q%��G��!�H`N���dK�0�֐Uz��me�����">���:W��P�h@�ژ�:̀e����&v�֣=c�7e�@"+.��������Q܊7>�)�@��j��2"�@\C�yc ���~�[��惛��Ć\��
���K�0{�޲�#�2Z�5�����vi՘f(=t��Y����L, �}�����`Pz{��;0�ʜ��txu��D�'�M%���c��Xr���W� ~�m��'���/X
�|;<j�'45̕�����ւ]�� Ѻ��0ɕ\�Rᯨ*��g��+�
==h�&�J��-�^��v�F�Vx�$|"�3(��\��ts���cC`��Z�Ԑ=�:�Pb��	��p �y�%��fX��H[D�=��YY@<��Xտm&�K�	�N�	#�W�Ĩ��,N��}\��ybx���#b� ���'`���[k?�rn5�#l�|he�Ǚ��q��Z%{A�)1t�c��z|���<�r��P��2b|o^pe���:x[�Ksͭ����S�ЈĻ�����u�ѿg�螟Ќ�9��ﵽ�L�iv<?y��3s���������@(��AΒ� u�5W�ˉ�&ӻ��2�B�X�Ox�ʂ%o{�Py�t�T+�H��ē�޳9�5R�#)@��k7<����	P��x*O.M��<�;�<�n�e�y���(�.���!���V�<C�FJ7�����?\�������(
�8���,'�w��
�y,�z��������jo3�$���y\��Amgj�������%a	~0[mO�:�m��eJ�П?'EJ$�N�R��.�����SF�.��dNBt$6��O���z
�����@�Ċ�|ұ�IO1���ܬr�?hyQs�>7��[�c���'TЇ^��Vw�z��dIr~�$z���#68��bW�@!��,ߍ_�G4����N�CPH'q������Ũ�ans��W���Rf3lu3f{~�t[iOG�꯯��L��³���S��h�zl)�1������ ��d��;��Tzw	*�=�uc7�����n��3
�д>F�s��۞��`��S�V�#NJ���X`�ZT$��SE��;��U�Z��9�� �ٻ�L<G�Ye'�86��E �T��}��T�1����s��4���i�&�Ik���xF�n�n˙0�-��ކ��~���ΊÃ�yF�-ws�$�l��q�ܰ�ߙ�4����jS�9�n�&x�^^��I�� Pӏz˓�n�����P0#�U\!vߧ�U@�_;�C
�X����o��ɀ��[Y_�a� �q�E/����Y_�B
VQ�<I�Ty���j`Lb%_�"\���
9�H��x!'�f���ob�ꌗ���ף
c�U���<�Pc�Z�'RږV�b��� U#w&o>�5����S��N�q���}��$fO��w�5�Q�6���ӌe�XH.�e�h���M�U�6s���Xs���p-/χ�5��G��EI/�7l4+NS�3�k^]1Y��u��f?C��Iud�=*�h��m� ��-�g�ـ�L����
>e%�"�0����-N��.7�o�6MM��d�t�7�U�Բ�H5�_<��s����h���0%�z]�*��R*� �ȰS�V|]߽D�Gꮯ��C%2��2W.�+�c
��,7�i`5�s��7bV��W��p5�/ʇ�c�2��_��H9�+=�{Ϸ�����C��ɞ�/Ҡ�%�S�K����*��n�4!z���A�#>�XA���+��s�+�Hh��H��Q���9�(XO��n�;͞�d�4rS�2��%0���Qo�A3*]:�8�������� ѹ�?%��.�M]|:d!ui�͕]�y,�!nz$nYp���+Rs���n:���?��g�;�+n���ͼ�5�������^犖<��z�<��x\��,(�h��d�c1�b$xBí�]1�|e�O±��_�]��y�p?1���7ꙮiY-���Sq/
���>��V쪪Eإ���_��_���ZPZ+w1=��@I�Ƴ�X��ao��%xFj>��	|џq\���9�2F�z�s
@e(j
:�k�T���م��k"qR�?M��n.��+ E;V"����#UN_�5��Wy��;N��g�7���%$�����-����ր�YE^��0?�G�rT-2AJ0;`y����h �g��M��8�+�:3�h�f�xu¢
�p(&3�!�@ݜ�䥑��j��������O�|+�x�Vn-��J�r�`1.^�9�d �C�2*)#��p��'dA1�݁��s�r��AU���B��D�A����h
Ļ۫�b=L+)q�m(�f�0�/{"@�#~m�JT~�C�kI��)�]�9Nv�T�
�Fnw���g"�!���n@�ə��Bwuc Ͳ����HhHG>���*(����4;�O����.t(TV�εڍ��D�
����Y�m�曡�?�L���q��?y�T0��{�_T��MI�ㆰ�<5�&�>�fa$ρ%���U�-���ۀbI�� 3w;��9m~|�0!�E�Y���$x�,>��c�OV��
��3Ȕ����Z�P#�<�}K��(���1����M-*�a[7��dX��x+��+�Puq���
�WG��T�NU�6{^B�������CO�>��@�ZX]zFt�wD�7!��؞�(sg�۬�l?/5Н�lg
\�/p�J;�¶�o��w	+s��MWu�� D�9çX�m؃%�Oh�۰iw���ҡ�g#fQ����W<�Ռ�U��1����{7�W6�g{)��v�/���Ƥ�}уv�J���[�f��5���L���"�$˱��i�X�O��
��jl�@g���Q�%:��D1D��[�5�2 �څ�����u�O���y�!�n6�W��M�^�!�9�o
~?��&�Q�28�c넍#;	�R*�mv#rr�!�םJGv��t��Y�`p��I~��x*� z�\���XPƲs�?�0�����÷�BTz�����/>�*r��N�roO�Od����b��M
&4v�|�����t�Mx+���1~.G��s�ݼ��q�x�W�r������נ#���e�l���i��l_˳��X�P�x�C�s�U���8�،�a=iʆo��L�6���!ro��-��P�>�OY�ήO�lފ���aV-;�X��W"��+X4>�i@J�F�Hn)ҹ݂�+[��ϥcRzkˮ	+{D0SjICoCh�l��6��B�g�]�L	jl:�̦+�E���R��KL;b�������A˞����y���FH֒-���d.J��a��o��������5�{��X���T<U��5���_Ɛ�7����QD�C�3h����,��Z ;�lHx�V1���m��$�[��PHO�%�m��\p��m5�����]f����AqI�0u�p�#B>);��R&�D+��%p��]�+u���X�Ƈ�B1�ctГcGy���;P�6�cԻKr{��ݓk��o���fm��˂6�C�I�����2��+~QmY�~�l��/�b��,���`Om�?�?�!�lm� c8�ݒ���W;��0�z���4_K��j�#LK�trx�"��I	�ܕ��Ax�O�����/����|�������=� ���(�S49Rr	Ȥ��a%��t�U�C���4q{u�$4,�T�� �U+�����h��9��0D��/��~8U1?��4�[5=���y���V�����Hă��_O��=�4[	Y#S���:�����l����+.�iyOK�ػ��'p"�2��
�bve��$���Ŷ��d\VRf��Uj����A1t� �x8ϭi��~wYm�}ħ�����#,r�&n
�SX.�.��;����c�ĩ���߬�Zȼ*�0�5�\0��W���V�u�|'eZtO�,T�{ݦz��������uyD�H�sH�CP�b!�+��]������C��|E�1��n,9�	��6�LՇ�mD���$�?�ԯ��K
X	��Q��1�l����d���շ�^�roa��u�i�˒�	e��Q��[���ˇ>=']ԝ?��r���y�n���<�����J���Ψ�(V{��Go`u	}���d��!�x��+@+��>�R]7�%��r�R��C�6�R�����Q�W����ux���x����x�8/��D��}� ��t���o�
�f�nn*�,�6���OU���E�A�s�_����wF|Z��
�y��3��q�Ꮗk�~��!�q3+�ڵ+����|���m����f	��2���^*S��4�g?�0 y�͵2��[rё�KA~�
5L0��B��5V��=�ר
/�����5,B��d�!��KTY��9�0�)�4
!)<��W�����*
^<[ό9�������|�v�	j�~�'��6-cL�d�Jy�n��D�RLc��ڑC.,7�,z��G4[��J
Zw�
E����o�08��x+w��n@V���[I����^�D}'�y�
le���������7âg��J�����U���>aV�XfK7(8��#�-��ou�l��"��q6l���(��Gf���#MU�MH
���F�P�rMW�Ԇ���G�2V�����r���D�c�\�B�F�B�%p��_��~��|K�y���w$Q�҆+졉\�6\fl� ���� ����5�Υc�Ƞ���"�
�LY�0�����Z>�P���XE��˴),/��(�
S����A�����V�^�kn�g;w�	X	�])J�
�z]\-4Hi��0+Ist9�
��nbdH���m�U���5���`���Z��3��h���#�2����E��<}��L��^�����ڢ�_2��i�wل)�}eDs�*�
�
Ջt��\���D�6�\Z�ͷ���V$�Z
�����@�!�*�4٠>��hԞl-}j@����0��/S7ɼ%o�M���x�Y
�J���C��H�xV�S�U"� �V�Hg8��|���UuR�F�bD�B����a5�_؋W�4��7���ր���\�%�Dΐ?����c?�#��u\�A"�� 腠�+�� `�Ӷ
�@U��8����S6�?VP;�|v�}��h����c'�928\�����3���3�BWǶ_̰�z�){N)oj����ДQ����5��/-��T{t��A@Jz���!���v���yR�#1�i��B�c��A"5;��)|fs��ip!}
~�Au$�ʊ'A�JX&���1��A�;��<.Gp@�C�?X�^�܋���_BJ��q:�+��9n}�d�H%�1A����n
�ٟ ��z�Ni�W2����L����8&�9���ҟ��*�E$}3�w��<�O(�\�Q0�ˑB�B�Z¶��R�勤)��8����=�KC1��`-˿��S�ة��I����8�:�d��m��ܾ���8zS�
DcH���׼l��_ی0����jf�VJ�`(~د��+�D<��Y�d�y�_�oء���L�	���>ْ�e���t��9���s��fq�x�M4~�V�@���4� ��.5Rthp��vVȤF��'8��冓��r�B�����s��l�3��F����ϝ�t�I|�15��"�0�4�Ɲ�T��(��`z��0��H�NE=�8e,a�{}r;��E~G�X����.��֯�A)t����`m��m�㨖��0.���V�cʔ;-
���:	�N������nr�����5y�:��K�?
�uN���X�a���S+��\pc^�w�ժ�;�H4�gB�]�*�� ]8�X���UI�k�H��4��P$�oݨс�55������L,�_�i	�� �s�[T��Y����������)U�i�|Ҟ�v��>[v����a�6s	s�:�=\ɡ�9s���[u,x�uPjʒ!N��{�,�5E�L�\?|��	C�.�ppyV��6ި<���:	]�O.�<{uD�E�~+�}z~9Nf0�<���5׺MSt�Vz��=X����ى8F��O(j1���8�9�P�<�����KS͜ z�I�'�=U�O;���]7��6X��̞-�O%�͒nΪ�ne�L���Uhf	�v�!��<�:���0 
s���^lA)j߸�g+]i�+[i�a[����$ƜE>�s��̀y+��7��DMz7��-��*p�罻�`���:��2w?tc�ʷ2d�9�҄����Eĝ ���~0X��U���ͲW���5$Ҏ�=gq]�"c-��Da����8�w����b��M-iUHL������B���$6��S���]��:X�H�cf��p�j�R��ŗN����*��ZD��`�/�2߯�Aam�RP�'�lc!�_��63%��%�$�ؾR�8��F�OM9�Q�Ĩ��;�*���(���H��A���
V�nw�$Pr��]���
���@�+����Hn'�$��!������3l�z�^K�_�j�Zx�pE�������J�K����ɔ&�ڈ<c�-�-*��k:���fEA���(�hƟ�J����������4�ggE��=�g���I6��=JKa�3����2ǹ%�V)��ͧ����_Ӳ�Ɠ�#���-]]M5��J��ڑ.+����J����b�'�O����j-��e,�R�M��f	{ �[��'�b��#��ˇ�?�h5�����OIPÇ���/�l�R%#�v���A��]t={�;��4	|��K����1� �lje�z�/���K=�2?�[Z�eU"���0���^�:	�q������$�K�چA�M��P�G�3�i{� ��M,r,�r�][JV���Rv��o�Ϳ��8����(��C��� �6蘹`���4����b���i+/,PX�:	�woY�͈XI�xR�n�b>a)��w2�cvǰ�Ϝ�.��bE�ftF^*9w��'{!yd�1
r�d�]?��Yϓ�+M�D��/�5��b���b$���8.�$b�p_�Yj��W��PK��F^kW���p�E�h�n�Y���^
W	p� �W�<�׃H,��e� ?>+x6�Ǯ�3!zлZ�^�+�N2�3X.!���N�Z�1�7Ѭ9E��r�.oSIPq�b�~�`������n'KW@�#P�B�.�!�_�H$��	�͓��™j?\��ͩ�V4)-o���A��Er���z��]��EMF�`p /���J1���6����T�L�\���(����.�~8oŕp�!/���SS.���/�rt���h���Cԑ�<bdP�Z��~p�M�n��0�!��HA��p�"R�Rf�C�<�̡�������
��\�ƽ�y�E\IJ.����}=/�F&�[?���SZȠ���*��>"��=)G9���;M	�%�"�Q�-/"ե��׹I�J/�zz�6�և$�2�Rv|U>Mzʙ%9��㽧%x:��#�@)�iE���,�+��Y���YF�/�9�E����� q
@�I��D�,<��*��Zǆ�i,�{nK��g$�dB
N.��x��꡽��)���kRg蟕��f��}.�
�3�oU]�Z5�Q�[M�E�V}P���/@�Da̞P��KG{@&i}�-S��qնv����f�@�#E����z�3��\s�\��&�GX�t�M$e)��Ą;�6r�͌�N.$�W�h��o$�^��>�q��H�
Z`��l��3D�s�v����B��t���6Ō����;�z]�.�|J>��#�I��_ɺ��d�Q���
̻���9D�s;	{�"@��+o1�2d'�(��t�-���҃��3Z%����� Ɵ��������i��Dm�Q}�i ��v�}a3ZL��ÿ������$J�U}+�C��9�̝~R�x�qi0]sSZ,���dy�	m�B~����P��a9��d� ��� ���h�F�8�X��Y�N~�m�gꌅ��A&c�E�71@˔�b[w 1S#��E��lB������R"~�� �Q�z���uh>�3)�'}���Eϯ��n0�쑞HB�ّJ�\�ȇJ_`�3��\�YNC�S#�D�5m���:�J��߾�J����S�.��yJ�{���捹a��'�v"HV���'�-���&�n�a�zY��
��0u)PK��u?�{Y�.5ܜ05����!J��(
$��M 5�жq�`���%F��p`�H)�v�A��؃�(��4Dv����eL'ʞE��1�-xT�\���,��<Y�z�;��������ND���� �1�E�l
W�#��j�⮑��-z�d
;럓2��ش�k��)F���k�\���w�E��k{:/�e��	�U������BX{}U�(���B+i��ƻ9�Jd��Yb��9����IZ���
���j�z��a���^)H�]����j��m��z,�P�U���������x�޾�y�*;Ŀ��/Cz~S��YN_#=`
e�y�j��f
C�?^~ϯAHف�s�)jΖ�p��bٗEƴ�ի!dЙ�憞�����D�!6���b��w��m�wǀ�c��ʸR4]8�uBۮ�^�
�b�&+8��hj��J~I��2��?��$p����ܑ�ȓ��'� :ax?�՟�y��ք,���A~7����@�^\HT���cm� ��_C�ڋI�,g��	L��9�����4��m�fsy�'sL]��
���k�������������:H{=W��Bg����|:��8�8eF��̿���y>Ư���*�xnp��D
7��� 		`"4$�kG���4ƌ��uÛ+���/��!�� ����8,��	
६�}�#����l)t^�_B������.�ҕ�꼙�Z��ѹs2�O������G����L�=�7��+`�g�"�HT�d�h+5�+
���Uç_p�\����jW�Lp��RyBdI�"j��3aQ�SN� J%�L�A�w�v�;��}�m��|V@���JD7�a&?���V����1�M�4���ޗ�n����O��c��@ٚ�����q|��ţ&�d@H�#ɦR�F�E��h|ؓxdx���YL4g���
EB����U
�L��"�U�p��	�Q��Ӷ��c=O	�;�u*�=��oT���~	݁��-*��Hֺ/����6�{�����CE���J���A=ѵ`#@�Φ�AQ�f�Z8�_�"�.lf<TU{�D�_�y7��$�E&?0�D����f4X�Q
?:@� Nz4�⨈���Q*kȤ�y�x�>?PRD�]:���9s%`'̟������d
��25|�rb:��]s*F�oR�l���<�kῊ���J0��(���Ӧni[?|�N�(���9]�}n����L��P��+�Q86��qv�=�Udz��nϻtt�Ae=��!K_P�-X���e���x��\,��晟aS>;�����+��b:@�o9�7��b��OAx�6˶��]����Ĩ���������R&�Fv,����+u�Zy���i&י8�(Ν<�C�L3�-2҉�s?����n&H��h�4U���*)FQT�S�����fAi���m��"ql�V�U�#�������
N��d�C!uEG�0��c�"t�Wm��[%���1�Ck�$�c�{͹��3��'ބ���iJD��kI�q�+���3cvđ��4T�`�����_#ѱaCner��#h��^�tFO��/*[�|���NȨ+��q�^gؗ�v�ƛ?
���z�4�7o���c�+� �a���O5S|.�"
����E-� �3�<�ٻ?��]��ќ�BY$(����l'�@ Jp�9_�f����!��l�P���피_��i�`����������¯9X�'��f�ã}����cu�c-Q�3��*=b8]���ٺOl��XI�^}Bvu�S��)�+�!��Tz_k�!��)�-��ܺf	�nr�L�-1YҨ~���@*7�;ٵKq[+N�܀_�����q�ב��d����h�޾^��#ce_�`
`m3����v��$�6]��5L���+D�k�E	9���r��=�e�DzĴ�Uig��c�zrrR���6i�q�6N�2�ɯ�Ξ�����q-7l�.7�}�L��+��
w�n2L�����h.m�ؤ�Nq ��!SX��!����7v}��$��H]`X^�z�9*���{WHq�C�$�أ*��b���B�	���v/e@���J���N����L�A_�����H�a��x��:�TGL �$�3*Q�;:�*�$�7���-���Ia�btkS�u�45�z�l�	�~q{k�<�#}��h�9�UfG&4�aRҴ�67E���@�N����@2v�f�
*��Vk�V�"K^���:L��T�Uy�Eq�%J��� ��̟XS��6�:!#�̘G�knk�ŧ�߉<P�
�/��e��i�2�w��� B���n6�ה;�5	~���	�����+G��믈��e�'�>�V򒵖9l(�!�Ga���F٘u����l9�T ��
k�_W;��{�=�tQ��+ݦ��J�/tq�7H�~+�٢A��^��$=����bl��I=c�͜*F��V�lE�@fޅa^OR~���HJK?7���3�P����>Zx��QU7-`~=";g:Ì�]� s]���iy؊�T�ZЎ	��:�P[	�/�_��>���԰��>�峲Q�Z��R�"Y,E����h�8��Wݓ��9�(�L��нD���!~��Fư߂�]�.4���^s��L�UI�q]�hD��/հ�)i�b�iMٹ��7Oͪc������)-ߵY)ՈVǴ쇙Z� k�g�b�tY��Z��̛�1ʯL$���� �ޥ�܏��_�y�Ͳ�#ZB�$�&�г��f�%z��Z���?t��N��k0��C��Q(y]&��G'�ӱ�T���ȸw��s�ԏU� V__N�3�KA��[�,m�)4	;���ub(���?���*,�"��x�gש�<e��[
e�������!�������Hs�1E:h��IF���_�E)�O��+��Кn��oP���gC��C�e�>,��0�EX���l4���d�\;{�ݘ质j鱈�R?�됍	椩8�%�*
�3��sH���SH�FT�KP|z�vYXН�x�
�T����0�3'B�I[}�c��e�%9��g�,C����K�$�$J��[!�a���)�L�<0q�aô�Z��웛�P���o(��!�e��z%j���	�����.���Zd�VTd ��#m2��ŻaX��s]�r�#& AN������f+l����W
7#C޳��Tυ#+�ɛ��B˹�!���<0C~,�l�K:5��#����郞��1a|��e���ؽP=��[�.r5�Jw��}�%����^�E�A���A)���KlҌX
>�gNk?�я�yPL��
����>�Y�h�~�x~�͵��Z�ǁ_3//��[7 e��3YAġ��̉�2c	�_��I�i��]<c�K':�:�������z2	W�
��u��˞6%ބ@�>+.@����^w�	 ^Z|���2@�s�4y���!E ��&&�u�H�R4p�{0 ��r{��϶~���Ų�ʗ١'��V�-�n�K^q� �
�(,���#�����m�c�t$��g 17'�1��+����"5��K:�:ke�j��	ǉL�~^I�[�F�К1r���TS�(��l�=~�)ِ�-��ag]|1��Nc�7�)� �~��Q+/Bf��h2;[y�����]��V���Nz�
E5{#�+�P谩C`y�����-��|o>��ϒ}���i�|﫶���
j���v�3��>ʳ�-,�F�������%	Ѡ��6iQk�a�º����*�xP��.k��G<lAf���[tn��\����]��M�U��)j��[M`�|͔��c�*-TT� �]�t�Y,.)����O!ɸwipPd�n��.=�y��mǅƝ��R~��פ�	�sb�����H��&H�-� S�R���X�vR���F���M8���G%�5U�w/���w��$��k7���n�b~\��CRw��Tp�/�i��)���+p��V�G-t��{�k�J�9��r[FeÞU�%bƷ,�,�O-���bf=�Ό��$�SJ��%��$��x;e@��F�G`�HCW�Z��&���O8F�-2'�H�|G;����%��Bө �W�ɝ
B>0ޒh����������*�W�m	I��#-��M�T�9��Z���;S�.N
o@&����#��K���ˏ��g`���~�E�S�������0~* Ye��r1�o��� ҭs�J�+�>Y6�Yk�5 Tp��'�\�c�)u��Op��R�]B,.k��pā�����[.�# �NI�'7�l�w��xb��p��3�:pS�wn^	��g��q��g��1�e��Tn�����ʐɺ�|�v�������U$�[D�Ͼ�C�	( ������ZƘ��v�5�7��!�wJb�����<�y�1���M�[<�"�߅{wwYU��Yo�7���0#/�i�TCh���=!ʢF^�p%<����X?3#/�9Ȋ�W��8�ٹ�"5\A}ۮ����=���g	���tlJ����"��8��e��LX%ሳ����mL�W���#���r�Ns&̀�yo��TA�����C���¹
��1򕍜��#�o�&I��U}
s��=x�v�g<���� ��� ����8��]�#����^�7��S���x'�$��� �1���<�dܩ�
v��B���Q�L;��]ZPs�8��rW��߹�ل�f��n���-��o*Q�!;`�?���{L�3�0\�8��G���PPK-(\V��^���dn��?�(ay��{�mOP�A!��ޫi.AA�y�4]�B�;$��n����49��s#+II�n��	�*w=&Z�?m
��ŝ��pGt�2�a��<��������ܝ:"���dĵS��y�Ѯ���rs��\pq����w��p(�����_�8�$�����i�!VK�D"��!Y�]�]�,+rCǚ�1�Nיo\I�{�8��'�o_&�.h��Q�=��!�2�f4��8�-�' m��Dy2xa{��T�@�%:��h�փ�O��;���\`��+]|,�����������x��'�� -\|�=�}��fv�cX����EzS�g���/��+�w��^�rV��;[c��ikEM]F�pu�33˫�R	�O^����I��'a,l�����)��\����f$���;��cF���~��y�Sr	97�N#��H��1��8� J���s�q�J�^S��e�䉧��`\;�<>}1YO����A�𕄆��k�(U�bX�n���Ǝݧ�8X$(�)lQ �ڃp�������n+�dO0�>�<'W�TxW/�r��#��W�)7�T.��~,F���	�w^R΍NA-;d�,
�3U����AŇ��
���26���(�����К�%7S�ϔ��h_&	4!gB'�1���uU� �Gsh�${
K�?V�����`��韫^�Dn��k̑~w���~�X%h��6R�;TĚI	^��w�x�.��0nG���zi���sģ�ͬ�kQ�|G��7ۦ�d:vޤ\��\�6!V���ne�a_<��>�|yZx�չ����/���'G��&�̑x��a�w6��,��͵�P�8���n��mrI�[5|�%��Ђ�1X��v�]#` ���y��7a�]U�.أ����Ĺ~:��^�����{��O�6�-�c[dY�% �ߞ�zz9uV)w���BT#"������mh��-�q���E^�^QnJ��m�D<"1��2,-;$[�;} ����.Y*��wa����~���ų���G�����	V��sjC��Xv�'�?�N"_g!q0�n�ū�85d;�UƬ��T�гG�%w�O�X�ɑߝE��sWGdN����V�{~�λgɄ��d�R������U6�g؄K.� �
�ؠ �%{����G;�8#��YL�2�@a\agF�?���
�]���r�4,X������EOP|��~�����"����*�ÃE|5-*�_�i�x �5~��
��,X����l�t�/��Z��s"���;ݘp\WDf�d�US��@s5�R������;��ˁ���jW�+^ʞ���$a
(1�
�����OgC0|G��v�@�����U�߇��[��k�c�R�|��b8�u68&�,�}�v\		Fe��Ѭ���3��$q�<T�ՁK�U%s�E��&�DZOR't�-��i�ng��l��z-��3��Zb	��\�& 	��s����p����1�
�ngKx���#���vwBX{R*�:��O`��	�jx%��A��:ֺ<�z�(��5�Ig�akՄ��9�<�v�S�t�f��qA����9}
Q�u'X!V,^C���{��r_Y,�ep��/�$� z�^�z3ē�@z�X�����D^x�f�ڋ0��9�^m��'�l�!Y��U�C�����Γ�����]:O�,w��H��!�HY��Q-�D5�Ɉ�bd�����fWc�)V�Ϟ�))�zWS����Vn���+xq;�v�/���o�ט�^�С���.��Y)JsH��%"_!έ�fkXx	I!���ʂt���<S��y�Z�(A��q,{RN=g�X2G�%�ah�]፸u���pc8x�����E�aw�-����[q\=����hsgˬ�[`�91�~���B��$����3��B�N�bcBu�����-��$c���K�;&KA�<[D�u���jК_r�)�"�|A�o�+�Al�ϩ�Is�+_&���n¡��!�S��C
�o�4�F�Dϸ����e�!��B��ߴ�����e������ʵ�Ĭ�C�dT��+�}Ds$� 3�����͡��e:��L�]޵&	<�N����O��m��FW"��
�1ZR?�0��91���I���(�`�;�
^z���7W�gLx�}�(^D��V��N�ڬ@���۩�EzM�ʹD)�S�<f����a������hʟ�D�m`�&��#� w�<�sH�(/���ĆD�%��a3ɇת���#��/��^��kq�/��ߒ/@��Ȟ�s*M�;4��d,kô6.&�^�<��k�ud�%=U�x�S7���4��[�=y�Z�)
!�ē����In��]x%����,�8�8b�Yt�9�o"tSǾ��@9e.�e�HpUϩ�`,p�eR���OGi��H�/S�p���7|K:��
�q�Y䡁�)
=�lk��۱��Q�Ƥ��uj�4Np�C������x�Ǒ�d�Lo~�Se6�4j�P?���`�w7>Ȣ��Z���5-Dk�x���G\�N5�]�e����b}�<]�i�>TK8	��ݫ��@����i�8���M]���аW�랖����h�iK (�u�-˅9�5���|B��.,�������/�y�b���
r�
X�*�W�T/������m��?��J>��T����(�A�l����̙��bn\�bB.Zl�@��>mqg7��I���d=c;�їq4ځc������[�B�6���?@}����[RẋSN�=)� FK�I3d(
ZhN؅���XM��
��4��z��"��K����8�_>�N��w�BqI�oė_ూaJ��>��
��i�B��5���J9#��	�Z�)�Y���햂W�� ��)¬t�φ��/��:�.��o��*V��g��:߫�T���Mo	��7���[�;�A-)����n���Xj��٦��9�`����ᾟ#���	Y�$��ֺ@W��a�7;B1���ü��g��k��c����uYs����<��:ۚ�z���cR���3�ER1BȊZ;ES�;��ɟ��/a����c�*�^p菲��_`ӛ�6]zP��M!��X��G<�aI���v]�
SDjΕ���9Ҟ��Iu���s�����>��ވ`s�
W�C)9�����<#�79U��g^��=��*\1c1FUP� 
)�Db�!(^=������t�|�n���e��k�ҕ���8 �u��`k�Z�Bl]��
�z�ck��]�d�\|�|f[$5���p8��']�%�׉C�X�1���
Ėt���J���u� �b&�:�������+�t��.I�y�4�
���!�[�w1�8e#CNȷ��77_ Д��S��t�I�%� ��9+�Wn7&&�^�l~�a�TVȒ���`�~&ҩ*GJ?m�K��J���7���D,p��	{��$�=	Q|vM�B3���:8	I� .Ð+P��v��~�τEM�Q�#	M-R7�rf��ٝ7���pa���>ЬS���"��z?p}�I	&.��9"��.q2�f�#���oh<��
) P.#�;S�C�iq%��r��Pc�^��u�����J񸍥"�ʾ�VA	j��mRO��@�ٵ� �f�w��BG���<���C�"+ �,��
���$W����12g�4�a&nui�U��vm�p���(�%�o����[%��K2���AW��8n�&�K��	px��t��1;�c���1���Y�8��-��F_y�+���͂No4'Y9��q���&i�)�=B�h/�XN�%��s@��"�M�F�J�	��3}�p����1>YV4�QBd�e99-xd%,/X���j��Y>Ә�)����X�u��;uaH���\`%���N8!��m؊��-3I���*O����/������'� �����٤�")h�T�8#�R��!r�(�s4�CUB� ֌�z_��Ǳ��	o����I����1 Bs�CJx��i��c�(��l��87r%hsh�`�&����UQ��pe8�&L���@�6��&l{��_���bt����j��������x����&���7���"����5��y"�>���%V(|�
��$���^�b���A&��6�ٍ�	�
ަ�:�ݘi?-1$�s,��֏)�h��j��>̙sX ���FY=s�a"����d�
�ЖZ�%�\����~��`7�sZ�R�f��q��%U,���t�K 	 �j2�U�W?���OՇu*�3ݟ�`��a�&F#l�{��%Ǣ��!���o�\���J�>uKR�b��΅:{_B�
�ąu��O�cc|����t)�3�ns+ε����ݓHS/*k~��p�Ld/v�cn��-��xg�V��*I�Q��TF"�v�������L��������.۸��CV�y�u� ��Չ�s��X�~g�Z Ac�-���$o�?�UE�*�r�B ~���sW"�q�L�u^�e�1�#�זw���h��J؏�_�Z�:�9��k��񈸣_Nx,m�HN��
�e��Y(�V�,녵�(�C��U�eY���W��q;a+q������W��JZBe���Vg�x1�D�cj� %�u��g�&����E��>|�Z�z)T{�;�>����9����ƺ7�_��$�/��,��+~B*�cȿD���ŋ6V�U��y����~K��'��t��+K���F�Y1���x�a������p���^�-��2�%<_�McM0C1# �+%�9�O
,@�"s����^�ʬ6�zI ��+��et�r��Ƚ�;i�::��
{ED�"��#Y�Or��l'q��/��"T����M4%�W�z<��U��g���k���Eu�3V5g|�`�:�^�Y���)Κ�����D�ڹ�
�u��5��o�t|a�R"! ���_@Z��4^cBn�����\r����B&�c�(B�濸D#��B��3����
p��t�<��}!ȿK������'�L[Q�)M���%�0�'R��U،�w��%�b��F�*5EET�C�Ϝ�w�H>�G�J
1Q毦�W��H�"&	�����4�z�#��g�o��`p�F��*��3�X�'��-k�Q:�����?�ܚ7�\L 8<����u�(G���).�h<pl�h��-ޚ=�9�bR�f�1��_�6����F�i7�	d���B��-0P�Ձ����|}1
��w���_I%gh�z
�]���/%�D�<P}n^@Z�;V�O{���{1��N&^-V�욃)� �I@�|�uG���20Ź
�kA6�.�rW�r���&0؛I��a1O'�];��}���+���QԻ��W�����E�:m昨�a&�҄E���(�_,����U;01
c�c Ί��~�ի0FѮ���_�&�l��>���G�39����lf��sZ�#v_n������*2���
}t ��[�سMMOjG+���z�l4���I����{�[3G�< ���������%1�	�5��yi�B�#�41B*��G����S���S���3e{�B����Wq#����"���c=0 GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0  .shstrtab .interp .note.ABI-tag .note.gnu.build-id .gnu.hash .dynsym .dynstr .gnu.version .gnu.version_r .rela.dyn .rela.plt .init .plt.got .text .fini .rodata .eh_frame_hdr .eh_frame .init_array .fini_array .dynamic .data .bss .comment                                                                                     8      8                                                 T      T                                     !             t      t      $                              4   ���o       �      �      4                             >             �      �                                 F             �      �      d                             N   ���o       4      4      @                            [   ���o       x      x      P                            j             �      �      �                            t      B       �      �                                ~             �
      �
                                    y             �
      �
      p                            �             P      P                                   �             `      `      �                             �             �      �      	                              �                           X                              �             X      X      �                              �             �      �      (                             �                                                      �                                                      �                           �                           �                         �                             �                             ��                              �             ��      ��      H                              �      0               ��      )                                                   �      �                              
