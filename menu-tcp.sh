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
    echo -e "$COLOR1│${NC}   TCP 1 Current status : ${green}Installed${NC}"
  else
    echo -e "$COLOR1│${NC}   TCP 1 Current status : ${red}Not Installed${NC}"
  fi
}

# status tweak
tcp_2_status() {
  if [[ $(grep -c "^##VpsPack" /etc/sysctl.conf) -eq 1 ]]; then
    echo -e "$COLOR1│${NC}   TCP 2 Current status : ${green}Installed${NC}"
  else
    echo -e "$COLOR1│${NC}   TCP 2 Current status : ${red}Not Installed${NC}"
  fi
}

# status bbr
bbr_status() {
  local param=$(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')
  if [[ x"${param}" == x"bbr" ]]; then
    echo -e "$COLOR1│${NC}   BBR status : ${green}Installed${NC}"
  else
    echo -e "$COLOR1│${NC}   BBR status : ${red}Not Installed${NC}"
  fi
}

delete_bbr() {
  clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│ $NC$COLBG1              • TCP TWEAK PANEL •              $COLOR1 │$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
  read -p "   [INFO] Do you want to remove BBR? [y/n]: " -e answer0
  if [[ "$answer0" = 'y' ]]; then
    grep -v "^#BBR
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr" /etc/sysctl.conf >/tmp/syscl && mv /tmp/syscl /etc/sysctl.conf
sysctl -p /etc/sysctl.conf >/dev/null
echo "cubic" >/proc/sys/net/ipv4/tcp_congestion_control
echo -e "$COLOR1│$NC   [INFO] BBR settings successfully removed."
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
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
echo -e "$COLOR1│$NC   [INFO]  TCP BBR already  installed."
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
    echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
    menu-tcp
  fi
  check_kernel_version
  if [ $? -eq 0 ]; then
echo -e "$COLOR1│$NC  [INFO]  Your kernel version is greater than 4.9, directly setting TCP BBR..."
    sysctl_config
echo -e "$COLOR1│$NC   [INFO]  Setting TCP BBR completed..."
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
    echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
    menu-tcp
  fi

  if [[ x"${release}" == x"centos" ]]; then
echo -e "$COLOR1│$NC   [ERROR] Centos not support"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
    echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
    menu-tcp
  fi
}

install_bbr() {
  clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│ $NC$COLBG1              • TCP TWEAK PANEL •              $COLOR1 │$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
  read -p "   [INFO] Proceed with installation? [y/n]: " -e answer
  if [[ "$answer" = 'y' ]]; then
    install_bbr2
  else
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
    echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
    menu-tcp
  fi
}

delete_Tweaker() {
  clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│ $NC$COLBG1              • TCP TWEAK PANEL •              $COLOR1 │$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
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
echo -e "$COLOR1│$NC   [INFO] TCP Tweaker settings successfully removed."
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
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
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│ $NC$COLBG1              • TCP TWEAK PANEL •              $COLOR1 │$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
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
echo -e "$COLOR1│$NC  [INFO] TCP Tweaker settings added successfully."
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
    echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
    menu-tcp
  else
echo -e "$COLOR1│$NC Installation was canceled by the user!"
  fi
}

delete_Tweaker_2() {
  clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│ $NC$COLBG1              • TCP TWEAK PANEL •              $COLOR1 │$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
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
echo -e "$COLOR1│$NC  TCP Tweaker settings successfully removed."
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
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
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│ $NC$COLBG1              • TCP TWEAK PANEL •              $COLOR1 │$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
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
echo -e "$COLOR1│$NC   [INFO] TCP Tweaker settings added successfully."
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
    echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
    menu-tcp
  else
    
echo -e "$COLOR1│$NC   Installation was canceled by the user!"
    
  fi
}

# menu tweaker
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│ $NC$COLBG1              • TCP TWEAK PANEL •              $COLOR1 │$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
tcp_status
tcp_2_status
bbr_status
echo -e "$COLOR1│${NC}  "
echo -e "$COLOR1│${NC}  ${COLOR1}[01]${NC} • Install BBR      ${COLOR1}[04]${NC} • Delete BBR "
echo -e "$COLOR1│${NC}  ${COLOR1}[02]${NC} • Install TCP 1    ${COLOR1}[05]${NC} • Delete TCP 1"
echo -e "$COLOR1│${NC}  ${COLOR1}[03]${NC} • Install TCP 2    ${COLOR1}[06]${NC} • Delete TCP 2"
echo -e "$COLOR1│${NC}  "
echo -e "$COLOR1│${NC}  ${COLOR1}[00]${NC} • GO BACK          ${COLOR1}[07]${NC} • REBOOT"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
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
Waa�ԡ/��m<�f
)�����g<O|��,.�5=�q>;5G�Q�h'����8�p��6z�K�8�O�X�0��GzG�:�q9E��S�1�m����W7�F��?)�;�2C�te�<��\�����Γ���oK�GO�RjLw=�{�j�ҷS$m�lf?2� ��c��^�o��U4w�"S����Yjy���_�b�ޭvGU�̋
A��d��#��K�*�ĢlV�1;B^��rM �]_3O9�$�g{H�~�ޫ���(�/�-����ǚ���R)J�䶒�i�L�B��nd��-��:Bs�S�!^����@��|p'il�~D'#bi��(m�Dd>��Ϟ���䟭H���;O��0ٻ/�LlF�(�ߕ��?'3��t�=6�rc(��{�*I�l+ӹI'���_�<�9�)�wU��/���2.�N����c�:�i�Z�<|�}鴁1�D:k)v���uRPD迮����W�c�^(�)�B_�-X����/���\�׶�Ow5'!����m�͝1����X� �`�	nr�f��u�Z����gG��1�f3BiVϘ�͎�`���'?�>m���A���Wn��A,/J+��4s���&;db!q�������t��~���f%�KY�����M����ɒ�ʭ �4���Fb�mg��\��d��� p��î:������0#1�=F�u�~V��g�T�O�AB~>x��:�)�U�����+��A��_�8�wRR+x��8[Di��m�����ͩi�L6�՛�D��r)_=`)�)�K��5�$�}�k�}z<�z�I����o��G�����B�N@�,H:����ݙk�as�[�����H�rA�����=��U��r"F#,�;>��܇1�&��ޜl'ybUG�h��N(ƌ]�<���~�U�&&
��Y&��l�v/�&T♰11��#��	�ɍ1���T(Ib^���T�a8Ho���M~6�l�R�Ȋ�Y<Q��%���yAv�=���ּ8����.��$f�@�}�*�y�tBm�@�T%���c�d�?`�����b��o<�_��$Yc�J�oK�hf��r2����;Un�*!�����\�;�E�.��ؕ� ���g���c���U���o��ɍ�=��"�Ù�w�j�e�gycYy���#���W�˾7:٦��#�be4dpS呐���Hӳ�-�P-��5�Ȼ�q���ؗ�E3M�����;#���C��a�;�Ѻ��b �F��-�9F�t��QP��?�m;���6^����y|j�z�B^͟���a��q�����b14�Oq�L�9)�R����~K��_�$��C�D�������B��YRh���
�Z7I�>��R�F���6Z��!�^Զ��LIXcX�淀D_>�f��`��Hy|n���zqJ]�{��_���E�]��mG/T��+���\rOSm����"��k�a�=�~L���љ������Ř`��?��ң�
Ƹ�Kƀ�R��}R�03Z���_�CY�^��юo�Z��	"RZ�����nֻ:��	��Q&s������_�=�����������0
��.�z-+�9�I�㕕�1�G�J�i��U���X<�B�ū�+r�����yl�=�W`J>̟;�7�%MB��	��Y}ǳ��o��;{�T3��9�[I˭#;]��ξl��"�ҺA�z���!��,�:��~;�^sU�r_���
��{[�n�¹3�w��+y�:�4]����A�NC��
k9�d�e���'��PȺ=@q�5��XEooX'�؄�ݼ$J��{����
W�%4�`��{��ұ%�pR׬�p�嫷�U��ƨg�C��pmJ�P�$�S�����Q��Wm�E�	�*(���֗�Q<���}kH����A°	p�;��{tF+�-6����(l��jB�|�:]+H�����$�z��~� L�{?%��_�,s���ᣅ"^�];q�aFx ���<lg�R�Rv�Q�"�ST�O�l����=�_yM��Z�QD>�;�X�#��N���U�}�$��G;=i#as+ų��@2���G-W�p	x$o^�|���eQ����XG?	+%F�Ϣ��KEʲ�I��i?I�yٝ���-�*��?���śm���ޫ�7uO�'	��U�W�M�
*qI��V�s?q���m�C��7nNM`'TU���֦^���yq��׃�?��[�ʋ�Ԏj��D|���X�Q��C��"��谦�!�����gFM���Dd�+
��n-J) �{?�����%��@;��I]R��4���tO�09���NW������F��-�zj�+�6{��{đH����U�(=�;r��(~�OkqQ�䋐���}<�^���`n�O�1.�|���/QH�����d��|/O�F�	��96�4�D��.{��7%��? �i�:�"x	��?���8��LZ`6�D�`;e��~� x<��դ�90>�h~ud١Ԏ�3E#S���}T�+{��kvo�,��IF-�XDl˱�Ny�#�n 7o���5�,���Iť�� .��-�8�3��%L������#�9K�w��sP�PH��)�<Sa*3���ʁ � b���+P���H `����� ����z!= c��Tx��G�I��z�H��f2��p�� Y�߲_t+�]�m0��9�+�v�2��{���� ��XߔL�_�(W��m��%�dP�s~r8�x6����>lJ6 ����c3s�ф��?ͼ}�]x܊�Џ��A����۔1Z(��(���,f�~d��7d3�����v�	��D�����C�2m�].:>�$�������C>vj��ځZ=4!� �OC�ϋ����x��g�M�c���\���$!���֠�ҟ�ky �Ƌ�B��fR˸���kq����+�?W���b�_�_�wԇ|�2ȱi^j��\���`+94��������g��'�}��tf
��K}-E�Q�z9��-�r.�6S�N�Aso����Ls�6fT�
Q�*��?�~xHb����3��&;0�յ�b�����w����>dȆ7`�E�m��A�`p��<�7�p.sGSnB�PL����T�]h�c.u�0X8��#8��)*(!$�-��\�Ay3Ƈ������˶#�`�\]�$LM1u�9�}����0m{;"t���r�4���������Q�~��<��8�f�������+B*$?��!eB�>[�\��I<Б"<m/'5S�hc�(�l�6#��7,��pLE�h���hł������e���mw���C���׫[�`������ћ��,M�ی濭�"
eiHjm��~�7�m�B�0����u5�Gʷ=g��_\�0ϐ �"UYj�3x1��y6��A�b"��Բ9�{�=��FJ����E �8��ȧ,k�\{V�����N�#t�&�ݯ{+�S��(��iNR��s&�Q(_(�W�ed�;���bQ�8�h4<�f	$5�kK�2��e6�p�{GԴ���~w�h�x6�sr�]�(u<Ŷ{~J;�^<�43F ��y�y66z�m���Y�h�z�E�H����.�腣iw��+�9f"�#FOb9~���y�m�
O���{#
m��&g/�G��T����h��s��E���yx9F�	=�HJ��1
3��#P��y�L�oJ� �0�������=���P�G�WČ���v���W4ͭ��w݌�bhd.��1�{���5�x��[��<=!\64�{�&$l��d��nӶ�yQ�mEk�(�V��!�,ƿ��T����p�.�P��f��k�Rs�0�M5�U�\��Ty�϶G�>@g3j���Gk� o���v�<�!�b�|M�l�}R�.�Ô���;E�i���f��`�͆�����3#|{w0q����V�.�Y��$��J�A�������hI�uB��(Ů�����TGuh<r&�Q���ݛ�l�j1�d�/���l�&��1e$����pX��r��i�T�T�gCz�ħ`R��޲�s~L�+=�߁�G
Ց��,�U &���ƟܨN�8���T��o�4�E�3�����<?f�o�P�K�!w��b\�r~��=l?g1�S�$)hZ�Q�2��@�7���ie���1M&/���1U_�;	�S�d��	�e��A3�7f� oB��D6+����D��9�kP����y�M�{�<�1�x�PW�v��L�� G��6���ٙ�dn��j��3: (}�Y�BOm�NA�p�:��RTȦ#��Z�8�*~���O�z^
�8��v:E`�/2���p��L�Sl�F��\�yǴ�����Z�d��F��
�mE���9����d�5��R��z�>��J���/�O#8�TT>���AnZ��N����t �>����f�U%�W���-���^dS���n�n,�O���=�T��'u�i��؂�!����QO���K�> ��2y�Q�2���Ր��J�IG�#�ՈO���X��ԟ`�oٌ�nY�_��c��Q"�����d
��2��Kz��C�a=��Iކ��=��������$��x�U0=�T�̊�z��n<6�6ȵ�.���YT�*U _9=�y��<�CMN����JW�����S;��3�Q��;�z�EO��*��r��ӳ�N��ʥKI�����%�a�-�u����QD�=�p�S!*D1��؝ �^2�~i؃3��5O��J
!:�� �z�����ۨ�M�C������n0���]V���+��
Ї���,q������	��T	�����2��Am��̨A��r�E˺@��y�{֤�0�mg|�6h讀��W*K
il�Љ�:�J7�{5��\F���H6L���i���1{������<��OzD!��c�2���V]z�C�H�U/5C�p[`�үpI���
�tƘ)���l|3�4��-^N2\��OmT�Dr0��<0�{����\�HBm���GJyl�G2]	N�"C�3��8�w����1�b6�o'?�Ñ�1����t�pIK��2��b��<�P�X��j�P![��i��+�l������@N!��M������o�

���@v���mkq�R��0"�]&6�21
IR��؜�[�qΎv� ���:�H�Zf[g��L��]t>HY�;�	1�E<q� ;*l �@Aޕ+m/d;{W*�);%�9�y����6���ݔ��[ �q�WA7enPW.��$�jOz2��r�ao�o1��S�S�B<��F�R��l���Aq�^	��;Q������c={>]���pt��М��h�Q,�]W/7O��C��RU��v�⍗$%ѵ6�/�_���Wgi+KA߯fN����u�H@��# Y(V�ٷ:(�e������T?�\��QC���J/%"��q����U8�7���6�b���1�N��m��e�*1M��1�Z��<�7��6BIY��k�ƅ��O8��Vݶ4�i�(��.���� 7���!%��EF"TJ��R�>�N�ئpl�$�-)P�-��<&;f�\=�\��g�'��߯/?r���P���CN�I>V�L��n�.��IX�.n��V�4��p�c�:8�;��R����p��Ⱥ=	���E�����e;�+|��Ǫy)��Ϡ�:�U�njFi��N���a�9�"H@�	�=����E�<�,l��^����kZ�	�)p��E&y��������>+���.�҃�"'$"CMmޘ��i͏��Sf�B�=�)v���3��p���I"�0e�e93����,��E��D>���Lx��5�,/	�.x�)�z�ȫ�R#�U�����"��soΖ?�u�Ƴ�wt|a�I�T�0[H^���I ���
�(��+����}"�_�fO�o�^C��x��y����vp�Y�f�����d�����6nPm�!k�VCL�#
�?%"O�v ͜��=Xi�s�R�����?e���J�"��-Y�=��Iq<|5��=��$f�&��Ͽ����\?�;��`1�|������d���U%i22��IW'%Tj���m�U���̍�����%F�n]+��ɬ��=bT7&0s�GH�O,ǭ}�������
7��N�� Q����2~k��z�?փ�����0�*5X*(����AU��f= �`wP�Js@�����^k�$����S���q����Z�T�<�����[�6��Q�o�r֓ߞ�ay�����m��a�$��_Tl� ��66M_����� �,�)M.͂|��튐�k��g�%P�b�hI��.!�Q�A K��kP�Ai��Oi��?���͈w�C$��;}��y|�)����P����G������F����!'��NÛb������}&pD��?�V�|�'GV�����8�%b���Y�ZeK2r�緳eB�j<��rD,ܮ������b�+�j*�@�^h�&9����n���߬���C���xk���[_G���&x��I���	ʮQ�B4�M��g������4��m-?�Y�]���O�A�B��u��M�.<)����I(V/�2�����I����ʁ%ZS������
�}����q�&�#�@5�;t2zk� �%�b��}��U]�}Q������ r�=g�G�LT;
�MTf*8���Fy�_�{K�j��*إ*��5����}����><����_�k�̑d���c��}Q\˂���b�G�@�l/~�����v�`=w�f<Y�_m�-NyfH�H�%kU4�"� D4�������;/h0?58;�����&��u�K�+B�E%#���"Bu� �BSẀu��$�]ÔS�ŉ�z�a�-w�|�*��>Z;�?�$D&�P��\�x�����]ڃ����F�� t�6��Yct�kc�hh��Z:#Ջ�Ԕ��������R��;�
�/G����N��~�$�j¸}��������#7{��W�c�s��1���4A��'�0\*k����W��>i�!�t�>x/8N����IY~��#]�aBJ�Ϊ�N��I��iŅ���lZ	���"���>۾���H�֨��PI��=|(L�a�Y�x�G-������|	T�B�u��o��"Ly�#"��_ae��^�u �/�`����Wg�����_��� ����RI��@ZԎ���O���L��rC7�ƅ\F�7O�	��eɜ$<?s��*�b���$S
׸��E�,�[Q9g��߁�ӹ\ ����8x��Ng�.v�7�$~e-q��E@��NmUz)3�������D�����'�m�� 䭖�u(!�M}m���ۇQ�ϔi{@��Z����5�����l3�7b�I�{�2E@/��6G���tN�egqBt��kW����f4��7~�,��`�s3���N��fS<���R:am�ߗ��M����M(i��P �D�i�y��'��r��?��5Q�h-��E��Vfa���n3�����9V����(hX�q;��	���V�G /��.Ǹ�T7e}aV���HQ{NG��,J���FV�Q, �~��b��J>J��!e9�l���e� 1�����9{�#r>���
HEose�2S����`��ʅR�T1�F�I쏂��N�)�'�]�} )>���.LONw�>��If���ΕO/�F�-��FUB�y6�Ql;E�p�9�xL����� �j�w�P`ū榘zY���GX�P?�?;�M�[u�=�$Z�\r�q;�ʴ��³6�b�ց��l�?��avKS0'�I1���WK�%�� v0�0�s<O� K�m�¨E��ǽ}�%��5�t�۪C@NИ�f{σ�x_C�sn����;�R.3j�@�܎x��z7Q�,(zw[��*���W��']0�䕱u�^�?ML=�Jj�$YL"S��W6�A�as�1���(ˇ�-n�6�\T���C����Y�)TXDuô?�[�H�{;��&���u��
�>u��\��e@��j�K�E"F����]@����ظw��	%!*�B��6�$�=�1I-��*w�4z�??�s��aA\��o=�_\zOB|[���b��0�Z�<a2٦Z����98�}55�,T��o�aơ��ǵ6G���m��!�1`�у*x���s��c9���ta<�p���4�YP8�|_�0�R�[d�ź��p'_�����:?,����.��K��=Ļ�[��Ԉ�c:?�K!�ogN�!�/�hR��ǰ��� `m�_�NVqB+���Ӣ��Wp�N
Ф
"�(cN�Φ�D�k[�u=�M�Ba�:�Vӂ�����w*���Cۓ��ȒQ)9q'�F���d��Z�50}�v�S�jSd�4��M�0��|���lf����о��(�\_O ��L:i���Y�cTT#�.q/�8x�ݘ˳��g��9JQ@XҬ����*?�R:��Q͑RT d]��	Ht�2J��N�Fա �2.tV����d�S}&�Y}�^����3�J�4�E�+vU�)\�����$a�}I�ȀP"�k��
MW�a����8���/2E�D��a�}�( �!@��ɳ��8\�R�D?�xY���T�`I���Sj�k
8�c{�R�������p�����>�c�K*C/{��49�ؚ@��DQ��Xd��=V�H��vY��osl|DE�Ĺ��s6\#�H��U�f��L����$�m�Hr0����E$Q��G�$��GJ��&�NU��oeL�CV�O��B?A��������ni��Y�R�܃�u �5������J`R̂�? �sGl$�sw)�3L\��>��D��� GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0  .shstrtab .interp .note.ABI-tag .note.gnu.build-id .gnu.hash .dynsym .dynstr .gnu.version .gnu.version_r .rela.dyn .rela.plt .init .plt.got .text .fini .rodata .eh_frame_hdr .eh_frame .init_array .fini_array .dynamic .data .bss .comment                                                                              8      8                                                 T      T                                     !             t      t      $                              4   ���o       �      �      4                             >             �      �                                 F             �      �      d                             N   ���o       4      4      @                            [   ���o       x      x      P                            j             �      �      �                            t      B       �      �                                ~             �
      �
                                    y             �
      �
      p                            �             P      P                                   �             `      `      �                             �             �      �      	                              �                           X                              �             X      X      �                              �             �      �      (                             �                                                      �                                                      �                           �                           �                         �                             �                             �K                              �             �k      �k      H                              �      0               �k      )                                                   �k      �                              