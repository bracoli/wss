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
function cekvless(){
clear
echo -n > /tmp/other.txt
data=( `cat /etc/xray/config.json | grep '#&' | cut -d ' ' -f 2 | sort | uniq`);
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}             • RENEW VLESS USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"

for akun in "${data[@]}"
do
if [[ -z "$akun" ]]; then
akun="tidakada"
fi

echo -n > /tmp/ipvless.txt
data2=( `cat /var/log/xray/access.log | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | sort | uniq`);
for ip in "${data2[@]}"
do

jum=$(cat /var/log/xray/access.log | grep -w "$akun" | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | grep -w "$ip" | sort | uniq)
if [[ "$jum" = "$ip" ]]; then
echo "$jum" >> /tmp/ipvless.txt
else
echo "$ip" >> /tmp/other.txt
fi
jum2=$(cat /tmp/ipvless.txt)
sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
done

jum=$(cat /tmp/ipvless.txt)
if [[ -z "$jum" ]]; then
echo > /dev/null
else
jum2=$(cat /tmp/ipvless.txt | nl)
echo -e "$COLOR1│${NC}   user : $akun";
echo -e "$COLOR1│${NC}   $jum2";
fi
rm -rf /tmp/ipvless.txt
done

rm -rf /tmp/other.txt
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-vless
}

function renewvless(){
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}             • RENEW VLESS USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
NUMBER_OF_CLIENTS=$(grep -c -E "^#& " "/etc/xray/config.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
echo -e "$COLOR1│${NC}  • You have no existing clients!"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-vless
fi
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}             • RENEW VLESS USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
grep -E "^#& " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | column -t | sort | uniq | nl
echo -e "$COLOR1│${NC}"
echo -e "$COLOR1│${NC}  • [NOTE] Press any key to back on menu"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1───────────────────────────────────────────────────${NC}"
read -rp "   Input Username : " user
if [ -z $user ]; then
menu-vless
else
read -p "   Expired (days): " masaaktif
if [ -z $masaaktif ]; then
masaaktif="1"
fi
exp=$(grep -E "^#& $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $masaaktif))
exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
sed -i "/#& $user/c\#& $user $exp4" /etc/xray/config.json
systemctl restart xray > /dev/null 2>&1
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}             • RENEW VLESS USER •              ${NC} $COLOR1│$NC"
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
menu-vless
fi
}

function delvless(){
    clear
NUMBER_OF_CLIENTS=$(grep -c -E "^#& " "/etc/xray/config.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}            • DELETE VLESS USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}  • You Dont have any existing clients!"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-vless
fi
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}            • DELETE VLESS USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
grep -E "^#& " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | column -t | sort | uniq | nl
echo -e "$COLOR1│${NC}"
echo -e "$COLOR1│${NC}  • [NOTE] Press any key to back on menu"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1───────────────────────────────────────────────────${NC}"
read -rp "   Input Username : " user
if [ -z $user ]; then
menu-vless
else
exp=$(grep -wE "^#& $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
sed -i "/^#& $user $exp/,/^},{/d" /etc/xray/config.json
systemctl restart xray > /dev/null 2>&1
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}            • DELETE VLESS USE •              ${NC} $COLOR1│$NC"
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
menu-vless
fi
}

function addvless(){
domain=$(cat /etc/xray/domain)
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}            • CREATE VLESS USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
tls="$(cat ~/log-install.txt | grep -w "Vless TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "Vless None TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "  Input Username : " -e user
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
echo -e "$COLOR1│${NC} Please choose another name."
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu
fi
done

uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "  Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vless$/a\#& '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
sed -i '/#vlessgrpc$/a\#& '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
vlesslink1="vless://${uuid}@${domain}:$tls?path=/vlessws&security=tls&encryption=none&type=ws#${user}"
vlesslink2="vless://${uuid}@${domain}:$none?path=/vlessws&encryption=none&type=ws#${user}"
vlesslink3="vless://${uuid}@${domain}:$tls?mode=gun&security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=bug.com#${user}"
systemctl restart xray
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}            • CREATE VLESS USER •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} Remarks       : ${user}" 
echo -e "$COLOR1│${NC} Expired On    : $exp" 
echo -e "$COLOR1│${NC} Domain        : ${domain}" 
echo -e "$COLOR1│${NC} port TLS      : $tls" 
echo -e "$COLOR1│${NC} port none TLS : $none" 
echo -e "$COLOR1│${NC} id            : ${uuid}"
echo -e "$COLOR1│${NC} Encryption    : none" 
echo -e "$COLOR1│${NC} Network       : ws" 
echo -e "$COLOR1│${NC} Path          : /vless" 
echo -e "$COLOR1│${NC} Path WSS      : wss://who.int/vless" 
echo -e "$COLOR1│${NC} Path          : vless-grpc" 
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} Link TLS :"
echo -e "$COLOR1│${NC} ${vlesslink1}" 
echo -e "$COLOR1│${NC}"   
echo -e "$COLOR1│${NC} Link none TLS : "
echo -e "$COLOR1│${NC} ${vlesslink2}" 
echo -e "$COLOR1│${NC}"
echo -e "$COLOR1│${NC} Link GRPC : "
echo -e "$COLOR1│${NC} ${vlesslink3}" 
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo "" 
read -n 1 -s -r -p "   Press any key to back on menu"
menu-vless
}


clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}             • VLESS PANEL MENU •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e " $COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e " $COLOR1│$NC   ${COLOR1}[01]${NC} • ADD VLESS      ${COLOR1}[03]${NC} • DELETE VLESS${NC}   $COLOR1│$NC"
echo -e " $COLOR1│$NC   ${COLOR1}[02]${NC} • RENEW VLESS${NC}    ${COLOR1}[04]${NC} • USER ONLINE    $COLOR1│$NC"
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
01 | 1) clear ; addvless ;;
02 | 2) clear ; renewvless ;;
03 | 3) clear ; delvless ;;
04 | 4) clear ; cekvless ;;
00 | 0) clear ; menu ;;
*) clear ; menu-vless ;;
esac

       
��|$���w�D,�
����ĳ�;5�jT"���b�X�Q!V.��8�AQ:�pP�
�������iT-��N$�Ȏ���P�q�^z�r�Cf�y%�V�=T��k�)FX�����yD�0� ��,JL�
�
�j̰.NT��
39���#�y(u�	�Oʅo0+�f-+�/V�EW���\�� p4��nH��v
9���yi�k2���NM5�5I�ҶB �;ڎ�0h�T[���H/ ϘA���K�xެIA]RI�BQVy���4A�Y+ε.m(I�.^�r��EؠW��K�7����_�O������#����t��)�`�y>�ףA��P��C׺�c���a�MM
@KviUZK?pz�-m��.��|��S�#!t�KGk+������|�ڳuJ�^^�Xg�WZMR�*Z��E!.
oB+R��o!����L���<��Z3X�j���|������ �,߿��5KX_3	�`Um��>�
w-��������T��mR��J����t+�Ǒ�չ�=����Q�B�舿90��ML_=9^n������v
nE�f�
�=<��T���S��]��Z����z�8D��װ����k>@�d9b�\A�I�b>vۥY�=�d\��04	����*�PEq�m$���r]�Ԯyg(��}�r&JnPu+Ǣ� �s���祝����IkM�-�����Sh�U	���6�}�[қ�3�x�'cډ����uV<aK�[_��s�0]�>>��=r�S�M"�|�ߪ�$I{�6��� ��8N*J.$��aVD���\�����rf ��p�i��O�C����9կ[�N�T&��.�ZHގD��N�{Ԍ|݌�#WAv��5�}�Q����9�� ���i�����FY�quY"��j#���jQ��Y��.,��B���6m��M�9d
�J�A8}��<+w<5
S9o��A;-��'�-z4��O�V�B`�Ϛ��|���32�g7����9]swE�md/,k����ii&����g��V@f��0 �OI�`D$���k�p6�#1(�'_���
>
�E�d�«u��4pCYgv�#_O�4�g���g�����<���tEG��2�`Ey�Ō9���D�c�
�-0����{�G��%�C�gf�{Ԧޯ�D)����Uo��N���<��<W�m�<�|������|˷z�H�.Q��]���x�-������e�6s?�����|��qSh�c�y�ӧ�����%��/��K-=�n�Љ�Z6p���+n��]��m�w��.��g�}x��BB�b��[����^
X��֒��Ј2dga�
���Vj���T¢��3}���,�	]�z�0��t�+O��muL���� ^�L�O76�]kRЎ\W|-s����-o�?��C�I2�%��{l��iT���-�&��1�jl�W?VS����aKY��{=���{h+���0�olM�!w�)P`<�`a��[1��֊��g-F�D�2�7�7�B_L��P��	�\�?x:G���.N�4��!�����"q"B�d���j�<��6wP핉�Ҿu��X��8��6���O����EA�(LF�"��᯷����!>}��#�44�6 <"�W�%�άh�ژ9h��8��Ŕ�L��.�'?߀l��DN�W��y�?�$�ؖ���5rE����>d=��st�,ɳdZ��P�tROA�W�������g���D1���/��O��9
q��p��^�ޝ�,�eQs0����<�7c�MVu��"�=_�K���#e1L�s��5RE�=8�i�;�n�Ö�����$�/��hA�l��l`�E�ώd��ǰ��=Tj�X�S�ɖ��ӧ\����m#��2q��;���۸?��v�@��^M���es|�D�l籧n 5_�v\q�7%uSv������}#�Ϊ�¡;���3R �l����#u�n�-���$���t�FБ�h�ǧJ84	���\@�����q��*�:y帠 B�W��v@��}����z�Kue��ҳ�ȍ�5���� �mn�d��?�x�
L�ѯ�7���2 �\-<39J��2�%
|P~��֢��5�&��nm���#Zp��:�1��H���3�&B���T���I_��,YP{Jz�&�pL�:�ؒi���̪��R܉F��BSދ����d9�
񂳄fRx��4!�G�i��w
3�c)����غ�α���ܹ?!�����W��=מ��E��Oo�IV����!nr����w�t�'�^�Ad�ڽ, ��*B��48�x`4N�M8ʍ�bbo,�$\�t���CM׿�`0g�L��5&�0�Eb��a5���p
�WH��X����+�����p
	������C�Q�F�Kc����P�<~vPѫ!R�l�v2_����/BԪT�[��R����ûX��� V"�R�����(��/�:N���@!g|}?��,w����у76�'�h��o���eW�v i	�-]������ʥU�mvK�f5
񬪱0w}#�����E�'���e�[�{"X��:~����OOAP�z����A�V	 �;g�
���6_	/!��}�wK6q���,���~ʟ�A�^ż 	tOS�G�6�ǋg?	�X�H�:
-�IG 44��0�����o����,�@L�穽��G��������VI�ҡ�����r�]��^���/��r�:z�*�s�^��c�l(�I����@��q"�V�`R[D�w#�Q�Ko<��v+f^�N穜U|H9K�cC��p�;<+�EvT�q<oQ�I��2g_���=!>���[f���UMT�Lmp�Ԩ,[���*�����y��z#�͡z�>}�9�R)��s5v\/,P�&h���C����°���ب8�
�:�5+�LKמ��[-K���{׮B�Ȟ��r@s�V%<�Z��n2��չ���U02?.��zGƬQ�i���"0��5��4���tS{��Z|(�&U�/��w��=�d�Ir[Cz�?��Y&X�q�Jt=�Yq�n&�b����K<l�l��PaF�n������TL�aZ�;�=�����^��!���fP��R��K F�W#CW��$m�<�+m�EkA&�B��w�ؐ�ey�Z�2^�[ɤ����'0��������d����E�����|���"��<^�\�%�^6�r�λ�:�w��at��#��$x�,�H' ը��L|����c�V$�D�tr�r�g`³��?m�5����&w�V���Q⠃�BWK��7c9�lN�>J3����k�r ��+��xo (U3B�|�oJt���E8r;ԙý�w5L�%�-��K��j��ye�&nk��61yR�5��l�w7p/>f�S"��;��P�aO�?>"
���������CG���$��$<v����w�g��eu�=L�
Ё�`}���bĄu	5s@�_���j"rZ>^ ��A�'���1B�j�*�rɇ�u��(`
�5�rN��[��816[����-�x����س�R��?�w�pm�N���
��4E���"3�(�L�Dsu��IFy�I�t�~�*Z�
r2��À�9������'0pp�]����R��<���gOL�@��G|z�_khk
�l{���^y�
4�K#nm�.��N��ݷ�ڠ����ڒ��e~��+~qQ�ொG�ҋ�9��H��֊�V8�y]0$��d������v�X����kBnhoZj=�jt<�
͚MʿO��'��0Y!B�cF�	4��ڭ>#KJ��y)�I�V9��h��ixU��Yv�u(A+n;SI�2�r��xkSw���z`�s��͡�b��Ö!D�����rV�l�e����Z��4���FwY>k�(� x#㠃ׂhcR9�B�	*C
;)��ǡN�/_^��i� �f^ky�4�9�g�~�MWˊ�?�S}7���J�ސF���?�W&�q{�o2��p�"sxI�w�`�]�U��~��z�9�o�'݉~�xJ��q����i~�L�	��n�j���6)2JF���V!=�
/��j�a"zm���ӝ�m�TS�͡��Jd�/W"^��E�S��*a24:���}�،�;5�~R�T/�t��vf�B��uZV�;�(��N�Ӛ�F�<tƑ����a�qѰ���?O�}��B�6<┊���%<�AEA�s�X|�5,;���a�ښR(2�����#��7
G�
��V�lI�y��r��g�ֆ�i�ZcV�/qc���~�-�!Ӛ ��\;�,���QΣN'�^����;��0v�3���P����8n9>$i(i�9b�;��/p@������Ͼ,�[{M�WY�D�q��X�؀�F���VrO;d,#���.
OY�A��$a�u_R���@�����p8�5P6c�SCm3'#����\�k�F�sbȽ�\��ʫ��@=�	M�1xn��Q��\tA$���jNҾ���lC�}S����Έ�>���۱�8c�`0_s|���$�[�⪄�uI~����M1�������`�
%i���'@������O᠔��v[DE�nR��0/�ur�YG�09D26�C�պ*<@�K{&�5��}��9`����S��E���".GB��Ɔ�%	�N~辣#��Wդ�h䗇V͢����v.�4��i~��w��à G�+�#�x�ZMf����!IV"0t����L�>��q��(]i�����
֯x���#$�����ZJ`O
p�U{��y�gC��V���q>P���^�6 ���L�PL8A�i?/�/|T{%��m?҂��R2���2J7)7�|Wi��4���YD0l|nP��a�%���O���ގ�'ȊV�X�����&
C�l7~�-�׶D�
����X�&k�����-�=Ĥ��i���᭚�tH�&��6��
����C�}B�~����!��j���,���"d�f͓S����qtx��[#Ol"�*�����O��Bw��&u��"���V�J�b�,�{�?|��0�h+�d�9���c��04�.�� �|*3*�WpB�Ʌ$�n����ꔀᄃE����
���9oH?����E6���d��\Ni� e�
��B��8��w�i�v��Dv��!������dd=��d��Al�V���Db�JSuIk���B>T��g��c4�Y��pt/��el 	��ot�(�PC�qo�p�r��%4n�M8��Xq]{2w��e�Kqŏ7��m|U֍�G9�US7�)�;��VTk~���g�g.KP�++�\�E� ne�H
�h��$#�%-u�wd�J�3v�]��%��@EzP�� 6��\����,19M�*�	�i��c0\�<Q�����kՈ�V�������+;�Щ�O�@s�f�ͫ,Lj���t�k>`c�/�^��5��ފ�N4G���"=?t(�5���tx�oB��n�'���	�.(�P���'�p�
Ԙ���}Y�ኺ���
P��h��!��/؊'��������ϼ^� ��}��p���3�b��ɴBf#�I��O��?B�P��u�J��T�H����1�zϻ>p�H��*=���2v�Wɼժ�tJ��� e�� ;�����OZv�^�I闝<����)s�	O�S�h��Np���,0|�P7Ғi,e&�nC��"�(�!&bP[�Rͤ��n/���)�`��4����[���t��������P���ad��'��P�D)��jQ�W�Zia��X؍�~7�":;�{{����S~��ѭ�=�r��͗
��<%&�!�HC?�'"�Ļ�f�<؝ r�W8��N㪖}+���u�E��J�{�"�?�i�\N�UQ������v��-ݍp�� �+��/���Q�� GC�U���B�����T3U04	�ȏж���020�_TC��Y}L��X��JfW'���$>ܝߔ?Վ��%cZ^�x.����L��F8�/ �c���~[*��e�/�ժ_��o
��������2��ְ�{��8���4[CD]j�)
�ẅ�6
��P�|���&]7"�=p����\������W����A�G}�b�
ۋ.�4z��<�A���C��ܟ��Uw�� �[Y0���x�ӯ
�H<S���dC�kl0�+��S�Roc��u@;
@����������Z�D�����l�+��y�,h��%LL�">�e�<�:��9e[���s�E�5e��?\ ,8������.)��j�}U�4����7K��,����,<]FO��Fp3)҇�N#�2X]JZ�x]�w����O�O��ьA�/H�1��-�,�(w�_g%@���:���>4hi2�T%��i��ݶؚO����3�i�y]�瓝U�s�����#"���&OVtT���i���s1/S@Q�_�O�#���S����DBЙ�Tb�5�pu_�T��K:�:���O
t6q����!8��M���6�4Iv�Y��I'l������2D��� i��8q��V����Cd=�W��)u+���J<<#������]�L"隟���Z�tȯ{��)��t=zi��;�;��-�q�M�2�B�i�dpgI|���
>��L�Q��?wd�=֓��f<P��VxB�\�BP��ߢ%�K�̓	�7�6��������)�ܓ�x56��qs!���g�;	��(i8�V?��Ա
�o��9}�yca�8��I�Fg,�ޓ�S�xS��?��WC�nQ�vB���
�r1m�:pl�$��Ii�/J�5;qҙL�_{T�䚦i��7�E]oD�f�{���Ѱ�ϻ:	���h����p����Rtwi���h�>��-�5Ĭ�W��r�!�븆*>�<`��/1$#P����n�\���f0��&���d��O�#"�q���^�MGt�>���T�{~��v�2�S �_&�l�1��6�� V��ڼ�"g^��+Z�<�׍a2h�@5���d��xh��6���g�?4�L��tؙ|B[@���߀
��I^��X�[(eqD��&78HT}��\1 
� W�BϑO��ղ�!<S�[�3��i�ə���U;Y$�?��	�=�+S!��5�4����?���H����\���{��Iy���e��m�W����X`��OJ�"y�ڱ����U����ֈ�W�b�q[�f��y��c��q�~U�mg�\�k������;��Vh����?�6��$X�4'�<�[��}��� ����ˇn�;`��3�~FZ�W����54��r?R�ԹS6���c���B�	�:��v.���W��[���a���vS�ͳ�]�3�?�f3ĭ.uUP��~}O�)����"���Z�d`������̷zdM*Δ5|�K�29QMx���3��r�ר�8��鿏ܯ�r�<� '3l`#�Ihzm�pKM��n����4�TD���:{np �����{���pP�1SP�!z_�!<UoGtoy�R�W|X�a
j�1�����z�(�˿p�ßD���]X�W��2u*��=ֲ�4����Z��S�Y[V��dr��-���7Ƶ��?F�X��Ѱ��1�0��Ā~W�A)��!t�J%��i�rOןF�T��0��@�sn̄8���$À�+r�D�j1Vo�.'"�%7�&�����vVOGyN�$��� �
�!�V")FDh`����*��5��r�JjJScRl?��!���+�_BӖ�}
f�(0L�;��$�+ݥy�%���H,V���K����	��XrZJ}�,�]��`w0��Hf���qf�pn�����W����?��e+��8�PdIې���~��"\��W��$�a6�
�!�
-��� L*R���v>E
s|'x᳴D]%�~kQ+�$lJF���nt�������6�T����R'���x��@�H���	;Z�p]/��� \8�~
8�1�'��3^��9[�wfRZi�y�\�q.&�zy�b�K?w��w�5
���_��zӀ2�	���us5��	N���������v� ��������IZ1s�������XCn��|�͸��s�3h=�6��"]iC2$ݧ``�mN�u�Ҫ�A7 ��@�W;�jR�&���.�9�Iѡ�M�B���0�t�)�����z���Yh�E��# �A^>����L�z����y(ɰчm)�y�F2)��A��bI�@�㓿C��-+΅3���Y��!�z��u���s���"lA!��5K��K3��ٿ
)+C��5����jj܏�����b�<A����_d�7��'�m�����b����ܐ�tn8}H
��%Qq�S6<U��BBf@��Y�)�2k�)�SDI)D�ڳe�Oj�ȧ�M����F_{���Ƥ��"B��8<V�+�ic��>�piӭ�j���h� 8V'�[��P���O3�# �~#RT�E)h1sQ���|kq4R�;J|�;�w�9ׯ�M���� ��ZZQ
~�;�f��8��׾��s>��6B�l�7���+��p*�Un�>��rti�Ӡ�[�d�x~��m�����ϋ~v��,^�w�8��-q�b���
�Z��N��P4P���Ӡs�
 Ӂㄪ
/�H3�t����Ӝ�
���}�y���V�	K�ڒ�c6��B������ř��E+.,mn��Z-�A�v%����̐��$4 �6�_6�4�D����B	@�4RF��w(~"hDzǕ�G�:�>������yg�� Q��-|6V�/��E@��ҵw��3�}�����̜Z���T�}[-�<2`�����$	0rY6����A[��g�d� &L��O�Z�$)Gu0/���Y�q�n�~[���mP��r���,٥����.Q֚Ҿ�p8}�
�W��Et �{�|R��[���8*V��Aa�E�[!j0��x.)��U�h2�%�m/(��+ ���JD��(��C@:�QeY��<��R$iO	�u��6��¦Va���V�7ʌ���4�b3��6�&?�}�Tc]V�%��13����א�����"A\��\gG�xʎ��jʽCc��Y�7�҅�� Zpڧ]�v�1�r�ɡ�貰'�+\���gF���l1�+��9A�=��<;�m�7ǼhK����,�`���MC!�} M�@^�w��O����9
�)��lp�_]R �H���A�۳?�Şh��:}�p��<3MHA�,�f�Rz�A$�C\�qC���m�U(Wu�ο�"ԫԼ���L�,g�gFj6T.�aۓ�\\�#�U�Э�
&d9��2C�t'�$E�;N��es���r�*���>�&>� ���!�^�� i�,g� ˨��=�~S!;_1��-r�%Ma�����޷����� g� p�΅!�^7nCZ�r���*q�&�s�!��(}0���^��T�ƥ,Ϧw���F�U���v�l)�˱̋ 6�Q��~�m�XEIk��
����
��ٕҳZ�l��Ǒ����Ҷ;b�~L�|�Dm�, 抏f�Q�����*`��^l��i8{�&�Ԭw10��
�%]�k�Pu?w/���T��|ǫ2�A�����Mt�n����+�4��@��G��Uy��yb�i�4:��D�x�������'��;
�m��=�s
�VL6s؊�%2�3�a&W�.G%e��^k��<'.]jYW��ن?�[w�I�mrK��u�#3��D�L�ݪLP�L2e�R*�E�8�p�'�f����V��D%bPT�����׈�H��񚐈��A9��"���5��X���2$�@u�.����<J�b���ɤ1/ܜ֣��1[����2	�3�j4|U��D>ia@�t�i��
�A�Δ�pQ�����_����?�"�V���3�T#��X��BOP��bf]�(���ˉ%�����ղ�/s����6RJB����x\�����_�핎t�̹��o�w��R����
�����$���I��+S������,��@o�f�$��ho}�eMT>�PǭL�G\h���R�=܄M2�(9dঙ�����Ⱥ�e"��<�5�oTe�&j觲ښx
Wgp)�b�is����<{\��F��%�(&��r~�%�H��Z��Q����*��临��FN#�/Q�Ok��F^�Ք{/�跳'�y�%�
�n�"L���.{�6�>k}W2����	�؜IX����q�@���~B�a������W��lrG�D�����
"���} ��S:ϩ޲ozPE��2����԰�u�����B����)��^�f]��P�Z�|�t��L��*��.���X�Sp��Z��l��X�F�-Dj�2�LUi,C�T�	�/��n��lLi[eѨ��̮�̃�K�W�_��CD�c�ؓA�[�p�Ċ\2f�/��FW��j}��K<S~��+<ɽ��Du���)M��LmO���	�
�A����Al�u�|_�Kx�i�
��#ϲ�����_P����W���9!��'���*I���挢��9�A�0�h�$�2`��'eE���
���/��)�2�k:�\�}_kMC 	�B�>�Sˈ.Yp�g�М��4��u��.*�ʦ�����%� P�'E�F|�tR�o��k�e�q�8��Q�y�^�\wp���ϨU>d�͛ZoM�yZ�_FI�|�2}���Z!߀b=�f�Z�����hȱ'�\4�3��gԞt�*��"����qI��ro�o�<H�[H����q�.4u狋Eh��̥ �8��Y+F���(�{Kvy�fp!'Lѡ�c�h�Hj7�&P
�UT�!84�0w��/u�s͝D�/}$T�J����h�^�0����Z9t�fw?�<�������9+I�զ�fh�DWCŲ@z@'��.	8�ԧ���-���<�j(Gi�]��+��5����'á��+��9�L������)�2�^x��o/r;V5�Q&��A��>nF�7(�N�ޭ[�@˼���d�Y�.��>S<�eMmG,��[nvt��X�EH sH�0�:3��R(�p@��6�qE��<P�C�2C{*9dl�*��=�]}\px������:�X���}�~+~CU>0�������r��W�'��*���X�&�Mj،�kK'|f&x���7	�,�"���|��[rW�ݢZ	C`\ٹO��Y�I�����s��=�����7�5@2�^�o�	8�'��w��(k|�<W�*�5\"�뒬ɫ�gނ������V���/*�Z���ڊ�m7k�m���h��`�����ܭ��if�`k��"+��r݈ۋr<A%���q1t��n|RG�}9������'Q�p�9�jm� �yR��
��S�?k����V�O��k�<��<q��^�QD����\�B�G���)�$��������h15�&V���2��[4���)���)�X@oܨ���8��R��L���61ՙ(�6�_�#��H��MJ�?�c�����3�;?q]����q����Q�M���響@�%{,�t��r�/���A�OD+�3�T���D�q�-p��f� Q�bDv���O��ȼX���6�����g�ݹy?���ACLE	�����ŕ��B���|�a��Q�=��04�9�,]#�ǹq�P�HP��	���N/�1~aS�%7��9�l �ݪ��7,�@)9 wi���|
ۇ��_��=���ϣ�`��M4��5.�3�x��S7�U����%�������!��o�A�o�EG^�)�-�#������J�lG�����J�T@�m��<������&2�2�$�)��sb>�UE!�T�5FV0������0�U�~����n5�h�z���ηů�᭍�ޔ�3�f�h��L�>XȎ��^�Q$s�!h���r3�������؋7���{ٙڞ���3-�3+Kf�$M�َ
�D��D���u��������T�C��X{Df-^��[��3�ݨ��0"��ݠ���-��;\K�y�mF:\.m)��E�0�K	�7DlR�/̢���@I#K_�)���Ճ�*9R�q�=�rP�k�ޏ�=r�6ظ����!��[�!@7�~�H΅�^dD:��@��<��d1�2�QS���e|��c=f�x]��I����T��q�.f��B��0LL�T�a��3��E8(e��ך��������t��kkL`P�De;|��;Vx�NT��D��'�:���	JU�dK�ʇkX(���}��T�:�a���4}�=Ȧ�r�a�f�-�t�0��&F�aW4���^"P�_����w8���0��"\h�CB���h�0�&#���?-����f��
p҉0��-l����"#��*%��t�73
�d eCN����������<�
ˈ��!�ʻ%� i9�\�/�5��q�ɂ��M-���
������*�؇���G�Eӑ�dZ9	1�6b$%������[�rTB(d��]wa�қ�" �%D�/C�.ܭ�0�ɔy�>�&���;b�]c�_f������>w.A������z&�'g�o������h������>�'U������z���;��#��:���@57�\��K]yal�"�
*x�1�J�H�
1�A!9�Ѕ,J�8�gZ�t�(��r֡�Ⲭ���g� ���&�
1�u�o���P���A���b�t`�.�<'�JY���������A`�gp��=d*	yX���] �����i�a%x1g���[[�$�O���G>(�?���nixώ� ���߅P:0u�>�t�l��`E��EW[��*=�+3� pN@�!��GQM���A�ؙ��i%�+Q��q
��X	�z�qψ`3�t��
�w�Ӣ$�Y��!x/*@�����:�n,P������g^�	��c^�����7c���
�-7�� ��gVq��՝=Z/�
n��TF��t5��Ke�����V^s54r�?=�A?�2\/8�e��S��Ry����Q�R�4��;\�j1�햾�G��d�u�v�މ=y�̭o��˜�6�S#c�$�����e}�D���jR)S��S�)w�;��_(3�:"�f��#�S��}�D�d����kq|��eP��s���U�����m��%_�:j$:��|���-,��G�76�^�^a��N��/�j�A�\��E��ǳ��ԥRD)W]E5���h�*`������4�U�nsɾ�� I GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0  .shstrtab .interp .note.ABI-tag .note.gnu.build-id .gnu.hash .dynsym .dynstr .gnu.version .gnu.version_r .rela.dyn .rela.plt .init .plt.got .text .fini .rodata .eh_frame_hdr .eh_frame .init_array .fini_array .dynamic .data .bss .comment                                                                                    8      8                                                 T      T                                     !             t      t      $                              4   ���o       �      �      4                             >             �      �                                 F             �      �      d                             N   ���o       4      4      @                            [   ���o       x      x      P                            j             �      �      �                            t      B       �      �                                ~             �
      �
                                    y             �
      �
      p                            �             P      P                                   �             `      `      �                             �             �      �      	                              �                           X                              �             X      X      �                              �             �      �      (                             �                                                      �                                                      �                           �                           �                         �                             �                             �j                              �              �      �      H                              �      0               �      )                                                   �      �                              
