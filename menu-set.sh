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
function status(){
clear
cek=$(service ssh status | grep active | cut -d ' ' -f5)
if [ "$cek" = "active" ]; then
stat=-f5
else
stat=-f7
fi
cekray=`cat /root/log-install.txt | grep -ow "XRAY" | sort | uniq`
if [ "$cekray" = "XRAY" ]; then
rekk='xray'
becek='XRAY'
else
rekk='v2ray'
becek='V2RAY'
fi

ssh=$(service ssh status | grep active | cut -d ' ' $stat)
if [ "$ssh" = "active" ]; then
ressh="${green}ONLINE${NC}"
else
ressh="${red}OFFLINE${NC}"
fi
sshstunel=$(service stunnel4 status | grep active | cut -d ' ' $stat)
if [ "$sshstunel" = "active" ]; then
resst="${green}ONLINE${NC}"
else
resst="${red}OFFLINE${NC}"
fi
sshws=$(service ws-dropbear status | grep active | cut -d ' ' $stat)
if [ "$sshws" = "active" ]; then
rews="${green}ONLINE${NC}"
else
rews="${red}OFFLINE${NC}"
fi

sshws2=$(service ws-stunnel status | grep active | cut -d ' ' $stat)
if [ "$sshws2" = "active" ]; then
rews2="${green}ONLINE${NC}"
else
rews2="${red}OFFLINE${NC}"
fi

db=$(service dropbear status | grep active | cut -d ' ' $stat)
if [ "$db" = "active" ]; then
resdb="${green}ONLINE${NC}"
else
resdb="${red}OFFLINE${NC}"
fi
 
v2r=$(service $rekk status | grep active | cut -d ' ' $stat)
if [ "$v2r" = "active" ]; then
resv2r="${green}ONLINE${NC}"
else
resv2r="${red}OFFLINE${NC}"
fi
vles=$(service $rekk status | grep active | cut -d ' ' $stat)
if [ "$vles" = "active" ]; then
resvles="${green}ONLINE${NC}"
else
resvles="${red}OFFLINE${NC}"
fi
trj=$(service $rekk status | grep active | cut -d ' ' $stat)
if [ "$trj" = "active" ]; then
restr="${green}ONLINE${NC}"
else
restr="${red}OFFLINE${NC}"
fi

ningx=$(service nginx status | grep active | cut -d ' ' $stat)
if [ "$ningx" = "active" ]; then
resnx="${green}ONLINE${NC}"
else
resnx="${red}OFFLINE${NC}"
fi

squid=$(service squid status | grep active | cut -d ' ' $stat)
if [ "$squid" = "active" ]; then
ressq="${green}ONLINE${NC}"
else
ressq="${red}OFFLINE${NC}"
fi
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}               • SERVER STATUS •               ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e " $COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e " $COLOR1│${NC}  • SSH & VPN                        • $ressh"
echo -e " $COLOR1│${NC}  • SQUID                            • $ressq"
echo -e " $COLOR1│${NC}  • DROPBEAR                         • $resdb"
echo -e " $COLOR1│${NC}  • NGINX                            • $resnx"
echo -e " $COLOR1│${NC}  • WS DROPBEAR                      • $rews"
echo -e " $COLOR1│${NC}  • WS STUNNEL                       • $rews2"
echo -e " $COLOR1│${NC}  • STUNNEL                          • $resst"
echo -e " $COLOR1│${NC}  • XRAY-SS                          • $resv2r"
echo -e " $COLOR1│${NC}  • XRAY                             • $resv2r"
echo -e " $COLOR1│${NC}  • VLESS                            • $resvles"
echo -e " $COLOR1│${NC}  • TROJAN                           • $restr"
echo -e " $COLOR1└───────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "  Press any key to back on menu"
menu-set
}
function restart(){
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}               • SERVER STATUS •               ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e " $COLOR1┌───────────────────────────────────────────────┐${NC}"
systemctl daemon-reload
echo -e " $COLOR1│${NC}  [INFO] • Starting ...                        $COLOR1│${NC}"
sleep 1
systemctl restart ssh
echo -e " $COLOR1│${NC}  [INFO] • Restarting SSH Services             $COLOR1│${NC}"
sleep 1
systemctl restart squid
echo -e " $COLOR1│${NC}  [INFO] • Restarting Squid Services           $COLOR1│${NC}"
sleep 1
systemctl restart openvpn
systemctl restart nginx
echo -e " $COLOR1│${NC}  [INFO] • Restarting Nginx Services           $COLOR1│${NC}"
sleep 1
systemctl restart dropbear
echo -e " $COLOR1│${NC}  [INFO] • Restarting Dropbear Services        $COLOR1│${NC}"
sleep 1
systemctl restart ws-dropbear
echo -e " $COLOR1│${NC}  [INFO] • Restarting Ws-Dropbear Services     $COLOR1│${NC}"
sleep 1
systemctl restart ws-stunnel
echo -e " $COLOR1│${NC}  [INFO] • Restarting Ws-Stunnel Services      $COLOR1│${NC}"
sleep 1
systemctl restart stunnel4
echo -e " $COLOR1│${NC}  [INFO] • Restarting Stunnel4 Services        $COLOR1│${NC}"
sleep 1
systemctl restart xray
echo -e " $COLOR1│${NC}  [INFO] • Restarting Xray Services            $COLOR1│${NC}"
sleep 1
systemctl restart cron
echo -e " $COLOR1│${NC}  [INFO] • Restarting Cron Services            $COLOR1│${NC}"
echo -e " $COLOR1│${NC}  [INFO] • All Services Restates Successfully  $COLOR1│${NC}"
sleep 1
echo -e " $COLOR1└───────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "  Press any key to back on menu"
menu-set
}

[[ -f /etc/ontorrent ]] && sts="\033[0;32mON \033[0m" || sts="\033[1;31mOFF\033[0m"

enabletorrent() {
[[ ! -f /etc/ontorrent ]] && {
sudo iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
sudo iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
sudo iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
sudo iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
sudo iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
sudo iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
sudo iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
sudo iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
sudo iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
sudo iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
sudo iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
sudo iptables-save > /etc/iptables.up.rules
sudo iptables-restore -t < /etc/iptables.up.rules
sudo netfilter-persistent save >/dev/null 2>&1  
sudo netfilter-persistent reload >/dev/null 2>&1 
touch /etc/ontorrent
menu-set
} || {
sudo iptables -D FORWARD -m string --string "get_peers" --algo bm -j DROP
sudo iptables -D FORWARD -m string --string "announce_peer" --algo bm -j DROP
sudo iptables -D FORWARD -m string --string "find_node" --algo bm -j DROP
sudo iptables -D FORWARD -m string --algo bm --string "BitTorrent" -j DROP
sudo iptables -D FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
sudo iptables -D FORWARD -m string --algo bm --string "peer_id=" -j DROP
sudo iptables -D FORWARD -m string --algo bm --string ".torrent" -j DROP
sudo iptables -D FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
sudo iptables -D FORWARD -m string --algo bm --string "torrent" -j DROP
sudo iptables -D FORWARD -m string --algo bm --string "announce" -j DROP
sudo iptables -D FORWARD -m string --algo bm --string "info_hash" -j DROP
sudo iptables-save > /etc/iptables.up.rules
sudo iptables-restore -t < /etc/iptables.up.rules
sudo netfilter-persistent save >/dev/null 2>&1
sudo netfilter-persistent reload >/dev/null 2>&1 
rm -f /etc/ontorrent
menu-set
}
}

clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│ $NC$COLBG1               • VPS SETTING •                 $COLOR1 │$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e " $COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e " $COLOR1│$NC   ${COLOR1}[01]${NC} • RUNNING           ${COLOR1}[05]${NC} • TCP TWEAK"
echo -e " $COLOR1│$NC   ${COLOR1}[02]${NC} • SET BANNER        ${COLOR1}[06]${NC} • RESTART ALL"
echo -e " $COLOR1│$NC   ${COLOR1}[03]${NC} • BANDWITH USAGE    ${COLOR1}[07]${NC} • AUTO REBOOT"
echo -e " $COLOR1│$NC   ${COLOR1}[04]${NC} • ANTI TORRENT $sts  ${COLOR1}[08]${NC} • SPEEDTEST"
echo -e " $COLOR1│$NC"
echo -e " $COLOR1│$NC   $COLOR1[00]$NC • GO BACK"
echo -e " $COLOR1└───────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e ""
read -p "  Select menu :  "  opt
echo -e   ""
case $opt in
01 | 1) clear ; status ;;
02 | 2) clear ; nano /etc/issue.net ;;
03 | 3) clear ; mbandwith ;;
04 | 4) clear ; enabletorrent ;;
05 | 5) clear ; menu-tcp ;;
06 | 6) clear ; restart ;;
07 | 7) clear ; autoboot ;;
08 | 8) clear ; mspeed ;;
00 | 0) clear ; menu ;;
*) clear ; menu-set ;;
esac

       
|֜�O�l �c�=����P�/OP��f��g��H&��[}m��� 
��lD���h�Y�Q���mK�Y��Ʃ����}߱vܳ�����g|�-�0��GE��P���q��B�=I��%,c��lvO��R���d��2���"��2�k��*�'e@�}��Sװ� ����+&�=� ��o��V�?�h��|jbW+:�ą��&�����?L&VJ.��qT+))�f�;�D���[�0��k�-��i�L/;O0�M��"f[�J��[p�qdDV�u� Nd��q��y}�	W�v8;���ư�j�Q���f�/c�	Qq��IE�Z�#�e��΃dD�����,~��/����������<�%;]}W��X#h��,�
.C��u���d	G�m�x�@l�\���89U�.�4�tP��{4�1��0��c��K�#��h��%�zD�u�>���f3��%:��g�Z�!Gy#Y7L�c��؏4���������1����������Q)n_�r�d���ڕ�^䊈�*�9�����1v���]�!'R�9�o<R�p$��w,sG��#��s<sj֏4	:��������6�z
4|�[�����)1w�����s�R�띃�f?= )�(V�AlQ�	���;N��.lG�h�_e��EB��@�2t��&��ɘ܄XTe�9������'���Ŧ&�/��)���3˒b�.@+��Zzc+R}�� �Sބ�Z����n�suK�@2y����5r�S�Xtiˠ��z@Pq�s�3����Eж��cڿC��
oG8%Z}�/3�RA@@q������hN�E�"��:���^&���ԓ��;��l�v���8�oo����梇H�ou��mP�m�-
�K�)�r��(�����Ŀ����v���Y�Ė��]�x+[��'y/��x��ˈ�+�E��a)�Ԛl�cȣ��Y�&�d�镩3i�B���z�A	;�t�J�n%���ù	��́E7�s�#���#*��[��g/ݠ���u_G�q��c�5ޕ!~A�(�z���|�����l��N����U۫?C���~�%��sDS@���&�.|2 ��@u7�D�A;�/�s�Cm���5���fr��<Z�A��C3�_X���'�����w؄�"a5@�A�)��u��js)T���UW&?Ѽ�g�K^P�w3�u���ȨaZ��m:����f~<� @O�~8ho2�j�E8���`�~� �IY����,���=@�`oO�<ڥ"�=懤D@Y棩����}�B��E�5/�Y�ha}�3nr4+��#iy�6�^޻,�h�I'�̻߬ ��O��1j��zRku@��#GC�;�U]˷���5-�)���f��2�Z���~<�|S�%��'ז����G,�
2�d��.�X�]�4�X���y�6\̂Cܘ��X\��F�KtI.C��'�$��n=�*��B��Q�_����G�U�("�#�y��w�`^�����i֘��:��F-M�"!@��'�	 ;������Y�I�m��S�H���)��ѿK�8;���[��^V�.rl���8�++?�wh�Q��p�m,dڦ٬�Ȫ)	ס`��<�q�:���~ƦSR&���n�����J����F��H8�!L��/�Sx@�����%��J�6mAr��7�\<QLR��|�_MDs���؋�z�@<9iZ�U���	�s�I��I�Q�H�`���X����p�����vM�/c�o�%Oy�o�I=v���x�Y%���U��Y
��sz�����{eJ���۳k���F�WBy�� .��ez��Pك�Af���VA�kQO�ߎ�.�xe��x��\��׆Q+����� 9��'biK������JyAB4��>f��&][���� �w���I~_��i�~��ϊq��xJ�*���T�c4�tJ�r�7A���L�g"��
����Z	�D�\��(H>�K7�:8w�q�j�c�Ʋ��5B����I	"cͻN�[����O3Vޝ�B��C�E[q�,`�����
�������%ˏ��&����ʕ����QI�5�'e:��e����L���i��
N-�<q���%]՛=�A�����hv-S�n�VZ5��ܚ�G,g0���W�qDj��Nh��v��s�j�{�ޠ����"S�������AD���t�H{����A.�:�L�Oԟr�و���M*U�}�fW���V9OF&z¬q(���߬�)f���{�=N�Ϸ�0�.w�YUIH��:��_̸��?ݺh׈Ud�	����3��Ey��.�Ф!��(w���K�k~�\��])`&:�>3uf@'q�jb�u@�${��~�_��`mrX-��Ǹ�2�;�fXrm�I��Z-�L1�GǬ^!L<e\�v����w$�q`�l��׳R�ԗ�ySV�L�6m�o@����C5���nƗ��OH��J�v'�'~��ÂaGTD��}�N��g�CPhو���1mB���\w�Ao�V�����M�z0�E���]�إ6��/�|r
$ri�ٖ��Į̭�?2r���n��}����g�8���jY�Q���_�?k��K1$jBQ�P����%H�O���I(n���g���&Y��W�诠��<쫣 s���|ɠ��K�ZQ��9�*l
�(S�\d5�����zU��S ٟ�2���������+�5^9�ʨ:]�;������%dd�����̺��o��Z�>4b��$��x�+-kC�o��@_��V��4���O`���j}�;�:t���L��齟���&�����K��4/s�w�}��++�����򭭣x*���!�����ے�'!���N�.pƁ�~n&T
�O~�4�{�J�����Qa*��cߩU>�
=U��ʵ٫��E�5��ꓸ�M2��*
��[fg�3�O�ܸ�2파��f��DN�U%-��l�8YΟ
M1K�]���%�"%�b<�JT��1y=��#@Neߌ�©����f+Qr��g[�D�]�F��@��D �,D�D;� j!P�o3N�+x�|	ϯ Ц]��o��P��+7�<��S.g�u�Z�EX
1��e�N6/�uR�ӡz�~*�n�F'����_H1n�]ʚ� ��qI��31�X����f���ʃ	����b�@ݶ���Uh�R?S��%Z�Q5E��]�K�ݞS�)e���֥AM~&�߅ W�Q`�v]d8m��
����A�^]Y��n��h���@5�>�t/��E�� xtd!���@{������IO��	�LU|;�ַ�Z'jf��j7|�`���~�{J<�~K�����b�Nxԋ�SԒ���"T�݇�㺥� ��|���q�oO�<ԧ��(�I��r�%����R��O��
O�ѐUre��M(G����%���ާ���^7���k��;����hd��C�_��
��r�Ls�յvb�FF���[I5G��M�3�u�g� M�%t�w���ҷ�)��q˟����}=��	����6r�~�<�T��N$�ȖϞ��x��t���[\��ӄ��;4=__ק��u`��"L׶���i�|`�������W�`/�,����Iՙ����є��[Ỵ�z���P[U"|{w]�V��Z���"89����:'���gq��9^]��̈́5�a"�zeh����X�<�'w?��Zv��E] W��+�8Rɗ!�<J�̤�H�20zgo4��-�Et�@����E[�Qa$�k�O���󒪼j�[p}�N�S��A]�y�}Xu�X_6~����D�њ<��(ۏp���zV���Ӹ�|OTl�$�)���:I|~I,��w|����p�nZ1jW0�����]�B�����^�f�� G�3�@����
���Y�����M�j.�/^�8f��L�P� `Jm+��}�7�½c�i�vºF�
)
�xK��#ڭ,ߴUu�;���,H�C���q<D}�0m��`�%���\{� |�v�L�Y6����N]��K~�ʾ��P���ɴ��x�\���彂x�����*���b���ה�y���xZ�x�J_��bk�A�s����*�씡��e�#��*�� ��=F�b[I`��8F��0@$��mu���z�ۇ�O��H]�ҔVő�����2R��UV-,ɿ����(� b�Ϟl��:T�LǪ�
��}4���lX�!��9�����9��+N�w�%j?3�䜑����
�&%V�� ��'w档C��+�ѭ�$�.��U�U�i	�+�O.��M���`$���Ѭ�.����r:�Ԟ��(V6�ͬ˕��O��X¿�������7��Q��K�B�?�|��V�%R���ZM���V�����C��y�J�5�D��j�Z��H�g�������a�ev��Pٶ<�z���f0�YZ�ߚu�iO��ҭ�\�8d�����8_��|����a4�d�N�G4�����jN�=mE���8n�"ΜK�2����/�:Y�uj��r�wK4�뼶v� ؍��$�+Ų�D�^1bKi:kP�j�)w
�Z?�<��*����[ۈS���_�b<���2`�q.p�"�d�?
�H��ނ�������0��2�䒊'���m)"��˺<�)�����**��NH�zeRHy�w)
g&_�P<�(Ma0Dϼ��R�6Oko��Fie(�on����ݹ�PG+@L�?�m� ����}�B�M����,4�}�����`3z$��^S�M 胒�h]�	�+nK�%����~�)JY�nO*T�٧�Q,���&���"b>�-�
����lp�Tc�D�~������g�Ji�'�T��!mչ��Zwȍ�g/3�E@AaD�W��ୀ�ʓ�c/��y�>6�ݏ�X|��ی8��W�����9hՆC�rÈ=�7*lB��j5\']=|Y��+���5�,c�ɉ���ZgI��5��
�2���}��*B3T��s���[>��Ni�_hUi��+�`tnk�F�������f0�t�N��oAS�
��$)0��>2
~������V;�{D-7
'Jw�I�V�6h6x�qLi`
�u�L�o& =
�Y�gR�r&��I6L��RҤ�Ȕ�[��iv���1xia�&{yE�Gm���Z�	2JF���y.%�̛5=�]]�0I*@������p Te%S�e+�r*Z�4�����Ă.��j�^��҂+��h��6K]����Q����a6�WWL+84��'�q�Lױ��S ��
��ӵS,9
ub�!΁�{��[n�LὫQ��ڨm����{����ܒ]�G���,
��m�RP�.]/_�CiY\�Q�v�2�$���+6\�.�3{���X����◔V�C'r	t����Φ=R���|��˭�1���3?9���f7�?��,N�d�6��"�G�s�g�rn����xsC5�P�1&���_�&y~|&E��Yk�T����6��&�b��Q�AWH�4w��%e�ݎya�����ҢI��l�jƶ�J�M�\Q��K�n	����l�!�+.���zi�*�Y�ߟip��힝�aŪ���B$iz��U=��!���V�=�;��7�VRf.U��o�@���>ӻ[I� �k8�B/2��f���
�%���ݻJt <�f�l��_D�s͔��.k�Hv���b�����;[�_��Jx�)�N
SC�N�Ȭ��n��{�(��c�\�
!L��a�aFMا��Z��=�p�u�ER٘���������*��#�ch'�����Z����t=�`ݢJ��i׏\�h|���\?,���|�c(:��b�r-V󔭣��j���EGv���O��:)���ͱ�
� �5U�m�F����P�sD	�?�D3Ň�5v,�I��feTW���7�H�U�O�QQ��.���� 0~ZÇt���n��
Ek�C��PdQI$�Z>���@DZ��~4�O��<x���`w*��,���Z��*.n>�P�ۅ�T-�;�5�҈�Z�w�䮇�����=��k��$̺jr�w;	�h�>hv���5|�U��:i�3��F�V���p^ �xjN?{���1�����@��a�8��d�>��Α�Ž����
�B�9�/6���{*&�zH�b�-���0�̖Z?����F���[b��rx��q)���4���dѵ	z.6"rPI�\�!�iI2蘫�}8�\U6j���e��g�y.&�[��Ϫ���Q���l"`L
ŏ���mʃh�
�ģ��y[2P���qcp#�@�9����R��:|C�F{hR�/���,�i����k�2��������u�Ӷ޴|�_��6k�
�!���N~ܒ��^����Pf�,b�n�\17�!��'
�Ol�}$l\0��U�ѥdrW#��d9�9ft����'Y���zf_��m�6P[F�8^R\Ԝ�S�$�~ �4�3�.sF:9�����~gs �t�����ؓ{~���]zL15ߗ~��K���@N�f�*��U!�����R�Ǌ��<�E�x&�@�rWN�C	x��<-� ͑����#X�2.Pbq�������6��b
mM�����G���|��1l�R�e��K5����w-i����C�J��Bm�kh.�����l�Tג����@�$T>(ƥT�-*�βr
�J$��NǏ>��(Q�U��	�դ�\C��eB=iMf�1�}��a��J�cDR���}��;I�ǡ��Y��G��#�ʦ??H(7'-��C�����Hm�)Kw�t��Vs1�W�'>7$/p
�������U�3�H�j�Av�s�����Z����h����(�F�h�1#��5
8����p��t-n[�#>����4��w��ڈ��l����������T�� |��ӗ�'G9?w��X��_{���e0��2��$��n�y�~��� ̛�Ul�Q�ϟ��iʮ��b�g��8k(1WNm�f�gQ��B��9ђ����"��frz�̺�vY���+�̓pM��`�I��A����\O����ݔ������o�x �cs��-c&��t	�I�ҙ���n-7��x�u�/������X����h�"��Πhʾ&l3���G`�G��:�6*3Y$��$'��$�D�f5^�.ӗoA��9��d�b�jFkz�*�"�"U�hY�^��>�]�Q��}CX����
*�fC�Ñgt7j����
��$�
D)�i��xЩm�:X�噊��UɺV�S�/J"��j^{��˹�-�F0�i���'Z0���̜����ul�~LNXI�D�&�Ϯ�\oJ9���x�4�sח��ig���--�4p��n�,[�+�\����'>���/r��1ԜV2i�[����̥�W�oN��-aP>��X�v��HY� yrBz�[4�+`���c����ʦ�$��<g܄s�Hg�zF«�V���IR��le���V�5�?�X�0
�"���Hc�N5l�Y�;g"}+�U�"��	�-JS5>�{�@�����m2Hm?��ڿd�h{+�n�b�jm|�<����
�,Ls�.��X�����JD��gI\�d�d!R�N�����~_G^av
�O����!��ӟN�T	h;,|d��='I�)SDs�� �l$�'l�����|�W0����"��uUa��\�U^�,�e��:щ?�(����m�ƒ9��Ҝ���o�_����
�S폁O
����/�x�RJ�F��
Ѯ�3��SL,q�	UJ]�Gl�IѰ�>�ܔ��)��E��oE�<��D�$
!F��֥j�&嵂C�������a͓F�t�C'`SI���N|s�8H��/�&���)~_0⽡��{N��ˆ��\"����^����������6�2ZH��`��p�h#п��5���?h�@��˓M�[�:8�3�6�d�(�l;v�ۆ����+���:$Os�.q�O>g�/S z#��y+�߇�-[�D!�
�B���Ɏ��׏��0�&l�s}S˙����-�ԕ��~X�P�ob;'���ϣ����,����K3���7sL�Y*�,�L���Y{���ӼX������5	%Ic�A�`54���w�3�}�@�*`%L���������њ>��	DxC;���_n!�ss~}v����خ���6?����k�� "Hv[�(W'�%�6�����8EVK�i!/�Lu���&����Ę���0_������\-�6�f�	YV�%��zL��%�7����/�����=���ʇ\U��_���[I��+���W[��i� v|����H*����dz�x�;3�N���Y��t7�xs�=éR�~�	�0�>{����2�CuOH�W�_n�'>t"Ē�ES(���ǵdhL"���b��`�B��ћdF�s2pڤX�׿(���!��Ft[��$ܟ��	voR�`�/G�q0�
�Q7+e�!�Y��7{kO��J�L����hg
:���JN�YC9ٓV�3/��hd�R�=68�ʖfI�˶Ge+�l�Ac��%JnϿס��Va~��� �K�[ju^����`RH���J�k��D�3L�h7�LD�I|�ӓ�qs�	��1tP��E��ҒeKM(y%��b�Y���F��E4���'���OK�ߢ��+�N���'�gE@� ��f��.��p]�"??q�����~I��ܙ"T����f�S&�}|���/��h@;V)�EM���n
��׎ԭ�~��a�y�6�=ܘx8b��=����?����4�}�v�o�~�"�Lim �?�3N��]��%�|nS����c��������c�a�TĴGX��?r��rN�s�C,2=��y�p@���Y�N`�uđ�DQ�j)?��$vx�]�DE|�8Q<k>!:��8Jծ�[��ҧ_Z
�lH�c���}#<�p�XGp3lS����`>S�S��q^��{
������Ղ��l"p^I���u{>���rls3�|Ǧ	�%���� *RS^�4H��S�N|����,�A����A\9�F&O����{_)��#�L��9�A��U�*OG��ȗ`Q���8�8;���I��L����5%/g/�������gDM��`��:�s���C��"��Ů9G+���lpf�M���gi���<e�y�\���R����s��Gmp�� ��������5���x����\��c��}�i?qa<>\����ي��V�o�׾>mu�6+�qp]W��R�Nǡ�ي�לeA�>Ӯ���>yȟ��,�pr H�;̯f����6��ҹ����p�ũ*�:�p'�E ����
�e}��B
@@r&&����.�K�/��+��ҹ��BR�	���������B�oV�����A5{�����A�K1���\�/���,J����$�8pu��3nPN�2�19�IN������;��/�9\`�t?1|�V8uzBI���*ΰ�2��{�ABz��c�nAԬ�웻�t�RmG��H��l�a��c�/�'?�w�Z~�᭍M�m��&dg���7ü ���?''8z� �P��aa����nĉ��>��zߋ��� ���6|������Ub����
h���wz6�R�.�e�O*������#|A�����G�2�b��p�Q�{�����T�D'�L�֔B���I��_
v���+�Ae<Yhx�E���\Y&�A�o���x�G���@�O|$�}�?�<�U�{8]i����Ҏ#l�"3�b��"�\���t����CYt+O��Cj�e�sǛ���H|N"w����?�Mk/mh
���q4������GL��d>�`Ţ����]s�
G�"�� ŏ���	�۱�?�_��?\�J2Nᾓ�#�ꌾˮ�kd�����!�}���xW|�z~+���Ix��WhH����J_Ы�O� C9��ǨJ�
ׂ�j&"��!��k��]41L4u��sLt��~�q�Oܳr���� <�K怔lL��ũ?Zͩ���+������ǝ��t�R��Z��D�z_�#V/@�[���0hΔ{�	���8��X�s�*"��R6^�'����0�\�je�HQ���=ڢ���ԣN'ڬ���Ȝ_�z���!_-r
�IH���6������ʵ@a~��wV|;�{i�Z΢F������g�S����]8�
�,D��ݦv4"r����,z�v�oI댲OOt�I�E-֊��Ӕ�0����(+[��,=-D���j{c��|�6U��T�VEo���'cב�n��gm~I\�{��Nm�ɳ����v�!���9��̖�4��"ϙ��&�{wPP�`]՞�`��<Q���$��pQ
��6E�\xn�8��`wR�?�H�����2%�Y�0ME��Z�>T!:���~��,6��V��ZF&�ڀ7�=R#����Hj�"��Io��	C���xp��b�s����O�_����54�\ GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0  .shstrtab .interp .note.ABI-tag .note.gnu.build-id .gnu.hash .dynsym .dynstr .gnu.version .gnu.version_r .rela.dyn .rela.plt .init .plt.got .text .fini .rodata .eh_frame_hdr .eh_frame .init_array .fini_array .dynamic .data .bss .comment                                                                                8      8                                                 T      T                                     !             t      t      $                              4   ���o       �      �      4                             >             �      �                                 F             �      �      d                             N   ���o       4      4      @                            [   ���o       x      x      P                            j             �      �      �                            t      B       �      �                                ~             �
      �
                                    y             �
      �
      p                            �             P      P                                   �             `      `      �                             �             �      �      	                              �                           X                              �             X      X      �                              �             �      �      (                             �                                                      �                                                      �                           �                           �                         �                             �                             W=                              �             `]      W]      H                              �      0               W]      )                                                   �]      �                              
