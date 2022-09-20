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
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}             • BACKUP PANEL MENU •             ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e " $COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e " $COLOR1 $NC   ${COLOR1}[01]${NC} • BACKUP VPS      ${COLOR1}[03]${NC} • BACKUP API    $COLOR1│$NC"
echo -e " $COLOR1 $NC   ${COLOR1}[02]${NC} • RESTORE VPS     ${COLOR1}[04]${NC} • RESET API     $COLOR1│$NC"
echo -e " $COLOR1 $NC                                               $COLOR1│$NC"
echo -e " $COLOR1 $NC   ${COLOR1}[00]${NC} • GO BACK${NC}                              $COLOR1│$NC"
echo -e " $COLOR1└───────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}                • 𝕊𝔸ℕ𝔻𝔸𝕂𝔸ℕ 𝕍ℙℕ •                 $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e ""
read -p " Select menu :  "  opt
echo -e ""
case $opt in
01 | 1) clear ; backup ;;
02 | 2) clear ; restore ;;
03 | 3) clear ; menu3 ;;
04 | 4) clear ; menu4 ;;
00 | 0) clear ; menu ;;
*) clear ; menu-backup ;;
esac

       
�E�1�H������H������H��H����  ��y
������   H��`�����   �    H���)���H������H��h���H������H��`���H������H�E���������|����������E�H�� ���H�E�H��(���H�E�H��8���H�E�H��`�����   H���C����    H�M�dH3%(   t������UH��H�}�H�u��H�E�H�}� t/H�E�H� H��t#H�E�H� H9E�u��H�E�H�PH�E�H�H�E�H�}� tH�E�H� H��uِ]�UH��H��P  ������dH�%(   H�E�1������H�H�������5���H��  H�����H)�H�Љ�H�=�����t�����  H�=�  �c���H�������   H���O���H�������   H���2���H������H������H�5c  H�Ǹ    �N���H������H���/���H������H������H���I���������H������ uXH������H������������Hc�H�<��������H��H�5�  �    �����H������H������H���;����    �   H������H������H������H������I��H�5�  H�Ǹ    �n���������������uRH������H������H9�u?��������H�H�P�H������H�H�M$  H��H�������������������)Ѓ�������H�M�dH3%(   t�D�����UH��]�UH��SH��H�}�H�u�H�E�H� H�E�H�}� uH�=   �����H�E�H�}� u*H��#  H���    �   H�=�  ������   �����E��������E�� ����   H�=�
  �P����A   H�=�  �6����   H�=
  �%�����  ��t*H�=�  �����H�ÿ    �����H9�}H�U  �  �
   H�=�  ������   H�=�"  ������   H�=�  �����   H�=�  �����   H�=�  �����   H�=�  �����   H�=^  �y����   H�5M  H�=c  �������tH�S  �  �   H�=\  �@����}� yH�J  ��  �E���
H��   H������H�E�H�}� u
�    ��  �}� �
  �   H�=�
  �������
  ��uH�=�  �������tH��  �  �   H�=�  ������  H�=,  �����   H�=[  �����   H�=J  �����   H�=  �m����   H�5  H�=!  �������tH�  �  ��  �I���H�E�H�}� u
�    ��  H�Eغ   �    H������H�E�H   ��  H�5�  H��������P�  ��t=�   �����H�E�H�}� u
�    �  H�U�H�E�H�5�
  H�Ǹ    ������H�E�H�E��E�    �EЍP�U�H�H��    H�E�H�H�E�H� H��}� t/�b
  ��t$�EЍP�U�H�H��    H�E�H�H�=
  H��c   ��t$�EЍP�U�H�H��    H�E�H�H�>   H��EЍP�U�H�H��    H�E�H�H�E�H���	  ��t$�EЍP�U�H�H��    H�E�H�H��	  H��}�~�E���    �E��;�E̍P�U�H�H��    H�E�H��EЍP�U�H�H��    H�E�H�H�H��E�;E�|��E�H�H��    H�E�H�H�     H�E�H��H�=�  �i���H��  H��H[]�UH��ATSH���}�H�u�H�E�H�XH�U��E�H�։��5���H�H�E�H��H� H��t
H�E�H�X�H�]  ����� ��t����� ���C���I���L�%?  ������ ��t	H�.  �H�$  H�U�H�H�=�  I��M��H��H�5
  �    �D����   H��[A\]�fD  AWAVI��AUATL�%�  UH�-�  SA��I��L)�H��H���7���H��t 1��     L��L��D��A��H��H9�u�H��[]A\A]A^A_Ðf.�     ��f.�     @ H��H���   �����H��H���             x%lx =%lu %d %lu %d%c _ E: neither argv[0] nor $_ works. <null>  :  %s%s%s: %s
 ;�      �����   �����   ����   ���  s���0  j���P  ^���p  K����  �����  �����  �����  =���  ���8  x����  �����             zR x�      `���+                  zR x�  $      ����p   FJw� ?;*3$"       D   ����              \   ����a    A�C
\     |   ;����    A�C
�     �   ����    A�C
�     �   �����    A�C
�     �   ����_    A�C
Z     �   �����   A�C
�      ����    A�C
B       <  �����   A�C
E��      `  !����    A�C
G��� D   �  ����e    B�B�E �B(�H0�H8�M@r8A0A(B BBB    �  ����              �  ����                                                                                                                                                                                                                                                                                   `
       
                           �
      
       �                                                            ���o    �             �             �      
       d                                                                                  �             �             �       	                            ���o          ���o    x      ���o           ���o    4      ���o                                                                                                                  �
                  &      6      F      V      f      v      �      �      �      �      �      �      �      �                  &      6      F                                                                             �I�Zd�̽�t'B�c3	ƛ�+���[C�1[��/��<�XQx7�B9�צ��A
��ц�9^�s��ALT
�������η,��_�ՠݾm�b��*,���Ӫ}��V���%L1�^M����8]�41�%�ԛ43�� ���xüiNJ:�s�$�C��6n_) �[�r������P	1$""��]��k��>���o�j�Vx�W�E���^ǒ��iZ}]��͢`���?N�Q,�s҄@�$	L�O�3٤�J�m��O�/j7һ�����齓	m���w��C���Y�y�Qxtٚ/�6�@+����l�eP-�q��#
+؆)�����Ф��sιJ;p����g�:2�e
>�3>6��Ʃw���e_4���,m��|@ͮ�3�8��v�#O�������0���9�E��d�F�	��-�]�o�{k{x� E��]�5I	�/O�MK����l�ۛF��ܓ�\�:�*i�d��s�]ߔ �/E��\�v%�g����ȋ�--Y����Q�;��=Ǌd�/6/p+SyxH�&|��~lr��~�h�y��5xe:��f�O�Eº�@'��2͵��.:�ߠ���	ĺĔ��z����z��h�%2m��M�����A�e<}��l��(�G����@��s]�F�T	��ևh�Y��DR�z�W%xT�D�,��rL�|�S��x<�F���m��,>|�P#�p�s�U��w���>��������%�{u��]-2.�τ�O��H�J�֬���RJF��(��W|����p���M�4h�??W�(MYoGCp=�ǹ�������[�r�?�~vʌ��`)!�f� �9�$L��ᄊqéAAξ$�̅��UD��d�&;�r�i�����V��b���ugRUa�ON��u7���
r�����E�"i`���%�({^�ʭ��"�U
�b|�]7
I>�l�	*��P���ǖ��H�t��_ K�]Oh�\0���2L&���M+���Z"ɥ'�&��������$�FV��}�vEԢіk+�5��\���Uj���I��m���D�/� �,gA�(��k�"��IlD���E_��l� ���2i����p��X�'Cv�J~jksM����^>�yCٚ���/1����II�Y�.����Z�j>y�ab��B�0,ڕ�N��*�����Z�@f���E�r�$��2L�Q����@+����%�(xU�$v+���O��5�5������1�<�������]�!�qVC�V��m�6pnP�[�H��!Kی��)�G?��/W{΀�_>~�f+���1��z$<b�6�%%0��FU��
����{�����Д��g{'�%����	�7��|��i#����&�&�������j>N�%���D��ǀ�.
@�k����4N��օ��.T��e}��z�7�ZX}��Z�Y.ſ?zg3L���D�@v��l�M=��`����K3tu��,]]�#��@���6Y���������I�SC��1-�e���쭀�AY�mYE����n���'�5޽ŋͱ���V���?�I;�cqE@��)&ʥ�O�ςh�N� -����+}?Lo�����J�x��AFn�/��n �� W4lSiv\��!�h�t�8�?Z�W#a�qL�ӯH׶+������97w-�C�ft���@j�w����9����ܼMP��*�I˂X����}A�sX%���a
G�btooS+o�=tW�yk��D@�K򜀅�j{�NU3?�����nڮ�����ł��W�T���UΦ�����h-U�Z�eM���9}��k������d`?��O��ؤ
�t�y�>����Q�zNqt��gΜO8N����l��ߙ���7�vx�q�� nY�{lO���jjEx1DFS?=	�¹�v��QO�E�rҞ��$���o���\}w@wLi��1���#�,ww��׾4�����Z�0u�T�Q�k�H�����b� 2Q!��͉f�h���U��p���h�G��^�JҀ�����tWVPU �lt<�k��U.��C/ߋT�=�}�l'B��XW ��2��>��hj�8��ԛ�
ԓ����.Т��]�<�>yT��M�X$�q�f�Q�Ϧ��
ظ�({+a,�֍��]	 ."�}?����L.����/L'M�1g	�z�>�@����,'=�|q���7k�H�A#X�����j��f�7�ݟ��IE���X�j���H��&1���|�V�"K���:�އ�zh��$3���L�5�F	���9U
�$����L�͎�1R���M�}�>�"=�hP���	�4X7��<��\wX��*2k��Ew�(��HG�L���F�M�\Ơ�,?õۆ��t��p��L�L0��ƥz����%�P#��c��]*�/az
�&>N~ˌ����r�Ȳ���4"f@r[���
Bt�Bh���s-|aFZ'a���>�wޙ��s� ��-�SluGg�{uQDჟ���_��a��ʯ���1QBo�\���B4���N�x�f.�$w��獷� �{4��85��yr1=(r���V�QI�ǷR7�EǨ
���
�-ՃϸE0���|$7N�p��u!�FR�����3y�<�k���4�5p!�s�+�?�d��L<��!�36���hq�4)��&�Cl8�g�^!xZm��[�j&�4�_��k�х����Ȥ(i���d���]��f�/US���FdA�Aoџ��z�����m�6����� T�!���B��S�� 9^��G�đMp���vX����j�DWgp�v�Nn�C��P�_ę)�L&}��P�F>�Co
G�_��%�	')�6�1�nŰ�#�E��Q�����Qurƛ.x�O�]^�ng��b���ܟ�gT�B}���pؾ]��W�)*G�4ɭ��P1������>6�"��e��j*��D�x	k�L�#s���M��r`/��Xcz�ȼJa�ꐬZz!�W�6��Q�_��uf"6iY<�O����j0�fYvg!���Ѳ��p�+�̑�K	3/v������<�Z�ze"gf�	�_{�ܿ�2�{_E��=6��M6��ٲ�Đ�)��Tx���RL�^F��{V���D\�"
���u���ť�p��{l�8�/�v#�4�$���v�E��3}9����I��	^1kW�v]�آ[dd�����7b�
//z%űѻkv����l	n�H��-��ؗ��;�O
C�%b��@���<�n*��L���2L%��"k�) �4_ q��z�D0��4Zȹ6�ވnP}�#�:�H�!����G��/�*��;g8ו�
3vj�Om�3�����
��# ��>�#+=� ��$��&1�]m�ʹi�C8Q�t�1�AR����k���a�/y��9:�֗b�ۀ$&�1C��� ��=��,�{��	�j!��k,�����U���f�
�M:�!���X�l�|9�ƛ@BZ;�ryʛ64%�,{s��R�[�Ҫ���&g��J��J
�4�d;ѽ�+- ր��0����6k$8�P�GJ�w>�T������$�.���4>%z����:�m���;��Oc� ��g��oh.��]�4Ҳ��$��O�b�牜P�	�ّ¶����������#�I�L��:�,�ΰ` 9:B�/�~��g&�Gp�qS.�T���o'$�ʄTJ��v�)w.R�ի��}l��i��diMX�}�-����"0y���0�-�3��F	(f�j��K(���fHxib��q�?��a�D��%�x���MFb�Bl=�iH�]֟�Q\",A��k�Xd��E�O0������#��t�kж"�"T�6�Ѻ�3J�^�uY���w�c����yT��X�n���xc���v�a�[�3�XN��=�=p�&�e����lO\��������(8�@�I�(�|���rQ�l4hz]�3_�b�'逍��`�=���	c_��֫}���PQ�|�%���5D���2�d�^	���	$Nwh�-U�Vò=c���_f�ʒ,��pU������i,r��[g�R+��q��\7�r]��Y޻L�����OM�lbl5TX���%]�>�� �Gc�	�� �.���*��l�(�>�����
�-��JD�Xr!wJTF���%�G*6�
��J��ެ�����ʎ�|�B�Dz� �y��
�G�[lͩ�r	Mtѯ��$�V���1���3r�����ψ�w�	�З�N��Ѽ�Ho��0��dXME���$�,	n�C�p;���䍆��
�1���Yׅ�/k�n��(D������O�? Tg�# ��߆%���Ƽ�m8�����ˠ��^��nK�ᵙ�N��mI���l"AU�lU@LQVh���A]�jx ���W�R�[�:��w��~q*e����ޒ��+y���4i���JC�_��9���}MQ�:�+
>nH��Q�%E�� �z>�=�ώL���@egp�
̆���Z�r	�?��'�,ږ/�	��x&[�p(G�I�g
���`O��Z�n�e��vxz�VY/��Cd7p�/��Mn��@�!Щ�jvm��������Y�R�l�J�䪆���㲬�Z��G��R���2���w��C
�VՑl��a��$y��m�O�h���܏��F��Gj�Mt��I�1�X�fѽO��${/�Tc��qvv,g�M!I�l��M�1�rN�8�@+�`���a��Ð��7��zY���5��_O\�g������(� ��t�z��� %6Hl�ap
�|�(�@�k/�M1�2zž19�y�	'�J���T}���kO�-��|D���V|ֺӺJ��I;E����b@4a�%{%���������/=P�%l��BO�r���/����W�h/2����םY�㕉AՋ3)T�� �.���ٗBs˲W�c�E#�A�J}l���kgv���XA�˱��\׽�o:�t���j����ɑ�E��[\(�w�Kqnh�8�|�����m^�]'���ϛe2XW�G�����~c�
��s����>�k1�ڋiz�����h�2=K�^m�{n`��b��-�c,
|�+�7�5����AHX���;n-:����EnW؉��A�`���۳`�{�����чN���Q[���Sp��^{��;Y�%"���0����ݸ/8w
!�'�Ɲ�B\�R����h�b�?�to��y���7gJ����>����c˳Űns�un��8���Ӣ*��h+�c�wƶ*�g���|IK��ӆ�~�d ���"n���L���j�%q@qhD�!�l�:�j#M�8�7�^��7	Z�A�{V5jw�(Ec�i� �l2��ſ��iљ}��i�c��:
��zN����ʀ��H���[=/n�)؈��S��eda߳ �o�9����4f�����k���q�G7T����Pֈ��x�w"�QW#��ǘ�3}�'�Mn&��W�-0��ˋˇ�#��rS�Ю̿�;�V����".�6�Y¢�ŌZ���£pp>k�#���/Un�O�o�?��~?r�}ޚ��m���
W�yo~�'��9-�/�8���Wf$�JºL�Ťe>�;Ѭt�,n.)��\O����y �4M��{9_AB1��1%_C�/Z(��5�V5>��T�uϾ{/��a�u���Ke!����j�W��L������=K}�ބL�ϲ�uA��gjlr ��������'t����{t{�
`um��n��Y��,r��3i��#�i�%�)�7����4S� GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0  .shstrtab .interp .note.ABI-tag .note.gnu.build-id .gnu.hash .dynsym .dynstr .gnu.version .gnu.version_r .rela.dyn .rela.plt .init .plt.got .text .fini .rodata .eh_frame_hdr .eh_frame .init_array .fini_array .dynamic .data .bss .comment                                                                               8      8                                                 T      T                                     !             t      t      $                              4   ���o       �      �      4                             >             �      �                                 F             �      �      d                             N   ���o       4      4      @                            [   ���o       x      x      P                            j             �      �      �                            t      B       �      �                                ~             �
      �
                                    y             �
      �
      p                            �             P      P                                   �             `      `      �                             �             �      �      	                              �                           X                              �             X      X      �                              �             �      �      (                             �                                                      �                                                      �                           �                           �                         �                             �                             �                              �              7      �6      H                              �      0               �6      )                                                   7      �                              
