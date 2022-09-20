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

MYIP=$(wget -qO- ipinfo.io/ip);

function menu1(){
    clear
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚ $NC$COLBG1                â€¢ AUTO REBOOT â€¢                $COLOR1 â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
echo -e " $COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
FILE=/etc/cron.d/re_otm
if [ -f "$FILE" ]; then
rm -f /etc/cron.d/re_otm
else 
re="ok"
fi
rm -f /etc/cron.d/auto_reboot
echo "*/30 * * * * root /usr/bin/rebootvps" > /etc/cron.d/auto_reboot && chmod +x /etc/cron.d/auto_reboot
echo -e " $COLOR1â”‚$NC [INFO] Auto Reboot Active Successfully"
echo -e " $COLOR1â”‚$NC [INFO] Auto Reboot : Every 30 Min"
echo -e " $COLOR1â”‚$NC [INFO] Active & Running Automaticly"
echo -e " $COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ BY â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚${NC}                â€¢ ð•Šð”¸â„•ð”»ð”¸ð•‚ð”¸â„• ð•â„™â„• â€¢                 $COLOR1â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}" 
echo -e ""
read -n 1 -s -r -p "  Press any key to back on menu"
autoboot  
}
function menu2(){
        clear
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚ $NC$COLBG1                â€¢ AUTO REBOOT â€¢                $COLOR1 â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
echo -e " $COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
FILE=/etc/cron.d/re_otm
if [ -f "$FILE" ]; then
rm -f /etc/cron.d/re_otm
else 
re="ok"
fi
rm -f /etc/cron.d/auto_reboot
echo "0 * * * * root /usr/bin/rebootvps" > /etc/cron.d/auto_reboot && chmod +x /etc/cron.d/auto_reboot
echo -e " $COLOR1â”‚$NC [INFO] Auto Reboot Active Successfully"
echo -e " $COLOR1â”‚$NC [INFO] Auto Reboot : Every 1 Hours"
echo -e " $COLOR1â”‚$NC [INFO] Active & Running Automaticly"
echo -e " $COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ BY â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚${NC}                â€¢ ð•Šð”¸â„•ð”»ð”¸ð•‚ð”¸â„• ð•â„™â„• â€¢                 $COLOR1â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}" 
echo -e ""
read -n 1 -s -r -p "  Press any key to back on menu"
autoboot  
}
function menu3(){
        clear
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚ $NC$COLBG1                â€¢ AUTO REBOOT â€¢                $COLOR1 â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
echo -e " $COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
FILE=/etc/cron.d/re_otm
if [ -f "$FILE" ]; then
rm -f /etc/cron.d/re_otm
else 
re="ok"
fi
rm -f /etc/cron.d/auto_reboot
echo "0 */12 * * * root /usr/bin/rebootvps" > /etc/cron.d/auto_reboot && chmod +x /etc/cron.d/auto_reboot
echo -e " $COLOR1â”‚$NC [INFO] Auto Reboot Active Successfully"
echo -e " $COLOR1â”‚$NC [INFO] Auto Reboot : Every 12 Hours"
echo -e " $COLOR1â”‚$NC [INFO] Active & Running Automaticly"
echo -e " $COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ BY â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚${NC}                â€¢ ð•Šð”¸â„•ð”»ð”¸ð•‚ð”¸â„• ð•â„™â„• â€¢                 $COLOR1â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}" 
echo -e ""
read -n 1 -s -r -p "  Press any key to back on menu"
autoboot  
}
function menu4(){
        clear
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚ $NC$COLBG1                â€¢ AUTO REBOOT â€¢                $COLOR1 â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
echo -e " $COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
FILE=/etc/cron.d/re_otm
if [ -f "$FILE" ]; then
rm -f /etc/cron.d/re_otm
else 
re="ok"
fi
rm -f /etc/cron.d/auto_reboot
echo "0 0 * * * root /usr/bin/rebootvps" > /etc/cron.d/auto_reboot && chmod +x /etc/cron.d/auto_reboot
echo -e " $COLOR1â”‚$NC [INFO] Auto Reboot Active Successfully"
echo -e " $COLOR1â”‚$NC [INFO] Auto Reboot : Every 24 Hours"
echo -e " $COLOR1â”‚$NC [INFO] Active & Running Automaticly"
echo -e " $COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ BY â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚${NC}                â€¢ ð•Šð”¸â„•ð”»ð”¸ð•‚ð”¸â„• ð•â„™â„• â€¢                 $COLOR1â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}" 
echo -e ""
read -n 1 -s -r -p "  Press any key to back on menu"
autoboot  
}
clear
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚ $NC$COLBG1                â€¢ AUTO REBOOT â€¢                $COLOR1 â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
echo -e " $COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e " $COLOR1â”‚$NC   ${COLOR1}[01]${NC} â€¢ Every 30 Min  ${COLOR1}[03]${NC} â€¢ Every 12 H/s"
echo -e " $COLOR1â”‚$NC   ${COLOR1}[02]${NC} â€¢ Every 60 Min  ${COLOR1}[04]${NC} â€¢ Every 24 H/s"
echo -e " $COLOR1â”‚$NC "
echo -e " $COLOR1â”‚$NC   ${COLOR1}[00]${NC} â€¢ Go Back"
echo -e " $COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}"
echo -e "$COLOR1â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ BY â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”${NC}"
echo -e "$COLOR1â”‚${NC}                â€¢ ð•Šð”¸â„•ð”»ð”¸ð•‚ð”¸â„• ð•â„™â„• â€¢                 $COLOR1â”‚$NC"
echo -e "$COLOR1â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜${NC}" 
echo -e ""
read -p "  Select menu :  "  opt
echo -e ""
case $opt in
01 | 1) clear ; menu1 ;;
02 | 2) clear ; menu2 ;;
03 | 3) clear ; menu3 ;;
04 | 4) clear ; menu4 ;;
00 | 0) clear ; menu-set ;;
*) clear ; autoboot ;;
esac

š¿úf´ˆÝË§àÁnâo]ø[A.G3GÕåÂ?¦\ÿ Ã´)S‘õúrü 3jâ£ÇÛþ×,Otõ475Û”4|Xè¥«zš¥ì–¦ ˆÃÉcÂ €ïÀÏcµšêß.[‡2‚œØo3~4Sýjê^ºh¾ýž2ú¹$ûë§—ÄÊB¦þJùû´™ŸøZ|	·±&±jJ­VòD]¯§¨
\·¤üËœVG§oÆ°'xÖÙâ!†8ÊSÚ°ËèWtò´+–°÷2?Úw‹ž~bw`ƒý™—Èí´£‹õô~ª ZHbV#Ù\®wÛï<”íÕ,¶ÃàY``åVTcty[ŒÂ¾ãå—@”¥þW9ì-e¢ðFûQ§à¨ûD©p¾ý€ÃàfZ új;Ÿi“ÙUÀ?÷°…ò,Ó©(R™ÖX–Wv½v—·àÒWIe0ž&o•Öôˆ¼ìI»­–,FTEw¹ïÓ¿cÅñ0§I¤WnW›˜º°I`üË¢.8
óÙqã*]¼ÕýtáŸd¥yì*uµ¸ÝFzß¾æ‹Î4WO¿úÈ¸W§`½$Ê¿ž×*vbRÖ[)ÑÒ»Ö«ÀqŒ àÑÇd\t·{g¾‡„Š7÷/]\#†Ï]µT‹j¦=þ‡„Q»§R{~¡kÁIj)2ù2…;W2öGùáÀ¡ÏW.ÇãMHI«Ïgõ8è,Á24¾\÷ÕˆÅôi ä³gc§k§œ°k%¼2Ò‘™È{U¢²8u*…é#©`?CÃT\þ’(3Nç¡>³ð»:ä²PqóM\¬vd1}Áú	’¬ZdõÙçwäöžÞbSÊ*Jâ—.ÑâôÑ°ŠEÌò%Ë=ÒWž¸òæ`ÌÌÖà&	Ð¯Vv¨=òº
$çèßtSî'àŽš¡h)€Šõ´Ö·f0x£Æ|$Ÿ[iâŽÔ0çßÕì‚õHj2žnŽ€U\—%çûÚŒ	 +„1ƒ°B]oç /£¥5§Ð#]&¶$ÓC¼Îá¶¬Ý?œ7ä÷´˜8
ÐxF:×){™Qç®°Høg/_—ø¨*±‡Êð@Q¾ÄAj¦¸,1¯š`½^é§
«êSª×D…ß®”IEoÁg.¢Ÿ»ûùîIàuq–Ñ¶~ìë^G#ØÔç‘ÐI¡WGÉôÀÒzµÂâ£Éƒ§ZE€V†Q}¢ƒÑnÒW­FUþ4Õ~0„óÕhß»8	 ™÷´—’?H2É«…$`ñø?®à[p3áñøŒúFÀµÞKÁœöQ¥â	ÕŒº‚Ç¥Š,ë	žT^îZgW)9vë/ñYf$NFÑž¤ë—²p„%í3æÏ©€ï‹‚HS+tt×±µ=«ý›t1»|2«…5ü¯(ŠÜÙ‚»Î¸øÈ;QRÊñîGåßZ{ü^²¼™fW‹{ul½ëöô{‘TòÙÛ«š²ï|Æ·”¦k‰!îó•lÖö1‡Ä´'pô`£ÿjv1TÖîXà¤‡Œ	½9µ±°vÑ]jÑ£gË´1³»‘ÉLlµÔ( Î‹9'/¸¡‘u¿ó	ÌzJFö"½Û7[Ñß›Ùýzø‰W´ùÀœ‚Ñ=„TDRïôÇÐ_Ndif›|¶œ/]!)K„^ñ9
m§[:B†Wdg»îüÜ^‡PbLÍUE!&0Ç£ÿº¹<rRÜ|=Ü°ðöPûœ5%EÉ­fz˜ß
¥œÕvŠç5ïâ#œýäì¯uIìe¾à…Í}ø²:Ý6 S4vû§¯ŠÙ°]íi­’ÒÎ9YÐ‚]æ—$›"ª‡{ë\ÀúçøE„#ÈöB28kÚÅJÐz\1.w…,¨r4í# ñ…áÝûóhè½[òr¥NhGæÞ¨ÂþS/ÓÇS»4Š•Ê5Íê°é‡Æ˜É
œ6bÎj%ÎŒð7Jw‚å3vâÒ¼_xNÖ)¶íØOzzgF¦#r¿îåØ¿‡Ðz‚¢YŸŽ5ó|VÚZ¹ZP–óQköV)‡¨eA×@^§o„Úé)½Þ¤Wª»’'ÅÈ×ÈAra¶=n0mÃûSšê‰›ÉÓÌ§k
™Ô‰¾i™D	Š)!ÑÜmñóØfæÊ=y¡µmSoõáºÇ¼Û$ÔYóù54÷bXÏÜúÉºCµ=e%vX8ââóðpCª•;bËw€³¯F´âOØÉYŠSµÝVÅ-ÆqáøP¶ÚBÝ¸ÇÜÌóÃ‚Ù¨G¶@FOîÍÖžå|«:ƒL
(pr{Iç\ö6ÔYPÕ¬JÙvÂ?ÃŠŽŒfå²ü]Dþú?ŒlÖÿxIçÅû6M´ ç¯›Fõ@õ¸¹Åi£âQƒ
wZçÏÝ$‡ <zv¨³¯†ã>ö=gmæ	1l¤xœ±]¤þc¡¨çî+Z¯m(ªyâ$®`iÕ!`*îEïÃæu!1
ð©Ì”ºÖ[äúæšoµ]¡t3ãXa“\¤{ñAmµ^8RoçXJf÷õÒƒ|›ì˜|Iµ²ƒ¯"Õ…érAÕIe¿O³£}S’,5<h8ûk{#|ê‚&î®;k]
„uq”‹[—ðw­ÿÕ«ÞŸÍòtz'.IiÏq[O2«z‡jn"ïØM•½ñ²Ÿ­4úl³zOaA»Œü¯Üºû`7BÖ`Âœ6 ±Ñ:rƒÆ,ÂFéS¶¼•wéÖ›>{M€œÆó Âp|ëÐÉªN@íSÔ^•2‰–|ä^¸ÿÑ9ò ¾z\e â”õáCèÙOÎ÷;c³	>¼ÖÈHZYµàøSt4hs4¤Ž—]ãâ%Eç—Ack©€j$›Ë¬Ý¦¸Æí^Z:–hª²Šù—_Œ¿ yØÙŠ·o±ª‰íÀ‰e
·l¹çã­#…)Õõ®g9óÅÞwGâ­l­ïxÄ ¯Ê3n‰/
2ä*öéb¡ý`W`¦Ü{†7:jYWÉröf-{ÂÐ(‹3åŒ2&Þ˜´óªÚr=±Ó\¨MaÅäþ‚pìÐ¸RIÌFQ€>ã¡›²ê"kË÷Q³L<“a~y?AÊQNÐ˜ÚWÄz:¨ÇÊ[ÿë»Œ¹]F“Ép8	WUÖ„­„<:ËŠGß8u³Ó¢=þ8§îì³UüÓ~ú]ÙŠT{(³È… ‡‘˜8ÄÆè´…_r/y°YeˆÌkò¿GòhJ† ¹ä³ó Î˜ájàÆ9Öœ³žDŽ†V üM*»Í:UQ0æ(^	ë‹ê/¹þFUÝ’U?ÇÆºJWôDA^Ò§-e¹öiÙ—nÓþíþÅ§_^^9mÁ´sT\'tœIÖ-§¼{ûþ>¾&Ù&8<þ±p-2 <Ba—™}ÐÛ‚°¢5ì©5Øîl}eØ—Õ] ÚZÚëxÂ8úúÄØ$ÓÌ‹@E
ø¾¾µ6‰YU³ÙÄ  [F9ŽÚ1p¥ëNSËb³V
«æCÇ¿À*·P8ÿ*±«Â²‡ïfYTmŸ’¹Ò«qã§ì¼ã™ôå‹¿U“—ª-ðVæÜéâÚ~§Ê©Fé°:üó¨-ÎÔ¿˜e¹éÙßBÀ¨l…[¬do½È²õ@Pz+¦Æ½¶Eò÷¤YgÙ1ý{qzÿÚ%ß²;ë|ïûÝ™¿4ö­²W€‚cS6Âí}
bø¥­Ö‡4àe8ˆ^u¬eM]k»“À¡/£ÛâKÇ}<ò'ó½KŒª7ÇjRµ}oë½{C•ßÇïK%¨m5ïÈ¾&ô˜b{ê&×+÷cûqt 	&ë^È§–Ú;£b²–1îMÓ¸ˆÕH¼Å.}1à‡gÀWlž°Äw»º\/°Ë¸ë6¹mníØx¡ÁŽ³|™òŽA|
±h«nÛ! \†rŸn´REQàë™=ŽÝ°Æ]³˜6Â¶ÊÕfbÿL Ä”¿!³°ëÐç:ž˜ÝR„Uu>
Œ`<ÁEjµp-ßÝ=AVÚ(j%o5}dñ^¶HaBÃ%ƒ`Ü‰P8œµdA‹¡³úRHœÙr¤JÏ§ñ;“øþ¿©ã6uÁù&‚XSÙ3ž_ðØ‹Ä[p¸ÁJÀœDMwqL­èÜp„H˜ÍÈ®³u8-A7¯šY	:¹f(K-LP‘ÈCO!§Ãü¥T2òÆGåµ [öd3V(ÎÓ²®ÒáX—FÖ'®	Õ1˜^M|è! Ä¦Ÿ®,MóÉ†Þ
é71^œöˆZG2ˆË7³/™…Ûx3=¤ °.=RÜû288KµÎz!«49ÍÑ™%BáxŽÇ‚
—‹HX7€ò`~0xYE5‘·&ùLó›‚Eâ)ïˆ_e¿±qAâ÷Ëi¥èTv„Xí¦F®ÐŒUÌq)L†mÅL­‚d]´.éž¼­¾¾jOJ<¤ÀxÅñŠ´=·©½ý½ÃˆˆÎ>cqÞéÐt.@Çß ¥|+¿@X)iP{~X°­èrkâŠ|Tšó†ž§ßMfy£è¬+°UÀE1ÁßËº±äŒ”îYÃk”_òy–]g¬ÝWÁ¥Ù~sGnè	†ÖwíBOv|ö]!vPOb¡Ö'80oé?[’È³ìÒ6¢x•ªnúwø¥uzê^©î2Z;ÂÊþÔ
W}ËÂIs¢M®ú:V°ªèÑÃoôä·˜o¥­©.nPL£’ýã\§­=Ð5§uÈÎDFªØ8=Žº­—™qí?ÔÓ9J+4\uS‚Ì]-®êÕ½ur&@À^¾=×¸`¸U¶[]þÕ_v]k‹­†sGj’›mBiPq“®L®±0é-÷ä‘7áëÉö*'Ó2UJN’·g´·ªé¡Éñú]#Y¿ýÅ*ÞDÈ½Õ"xæè-Þ•ÜF
ØšiOû¬F}t‚a`wéÄ[3w#Á4íîOÑåŠd]ÝgÚZBYW”fÜ‹fßžb§ÏÀÑCŒå¿fr#dÆÓÓi+lÅJ…RLÈÝz>Õræíº+®šëyß¦pd»iîÀÕ³é¯þ>‘¿-²îœÄ	]Êû¡Ë‡í+áî‹ãžg`"›mÊÍnäd­ã±œTÜõÁâ6+w­óIô=ÙOl;äúµþÅ¯1h 5ÑOÊEÎgµY‰Óî
x6ð»édk¬ÓÌêƒ@W°4ßa+£­ÿ g„•É CBÿQ_”-pF¿›÷£ì3ë‚¤ûãqñƒ#ÝÃKM€ÔwˆúN¯•$'êƒi‹>:›°”ŸÎZû~DšßKx‘<%¯¥A‡‹£z)M˜M&¸k\J¯ÌéNìÓ¾”E²gëø;‚ìÝ‹V'ÎµÊ/«M |Ê"H1ÐK°òxÍõT|¹ÎÏ›&†ÛÛÖa÷MU
ÕÔíz,xA 0“G3áF|gè¿˜áz«n/&ÛZÌ¡Zþ(o
5­WUnw÷2"CF„¾›ÅÅN'JŸßNj1ºDå&8•¤P®ý¦`øF{tˆoœ&05±ÍÆë½Ô¸®9ý34•ww÷˜ .çVâeœ¡îÏ¯'7ËÈE¢¤æ%á0Ós“yrfSª¶8K4õ¿˜êmë”Ô‘ˆi“Ëk°9½¡‘¶ˆbæ-}Q'Ñx#”)\×î´Ò÷å•ÁK¬õeDç^x.¹à
1Z˜Í;Z„0PuSÊ¼Þ¸ˆx½êû¶õ*JÎ$9ëfÞ±ÄNMq‹\ ¶4™ûC}J&AþO½]w¶œÄªhð8¼	D>ÔõŠ8›¼EZâc`³q›z£çvuÀ÷ôhÿÿ0Äÿ±)š¸"êô^CNTO×lÖV€Ð½è×ƒP™çmÞŒ¾ýKU”
‘<øBûø,³Ïã¯ZÀÜxT)gˆ‚‘	o¿©·Ýbäöôû‚PÈ¨xmIÌ±Ñ½³6U=kZ ÉÇîlþDZƒŒ²¨íIØÜâœ	O|:°/úþi¦$Ãh¤‰°ë£ÐÓ#Ã6ÿ¶ÈFnÇ“ƒ.Çå©)W=€º’ýPÿAjþ3Ä„Ÿ+Ý^¨"ð|…÷*;.äI[Ôm¿µ‡ŽÅßR$ä§p•Sž†ú5YkŒœ@3T)P$éçêA^d5¾Ý:%³6¸ðs2[³ŸKßNÿÜ¡æ{
ª‡iƒÑ×jS•ÓÉtèìàk=ÃOö%Âš¹YÀs”Ý<È_øÞÍ(Œ|t©ù s×6ÄÍO¢e²¯–šâ-Šm—€rû¬ÚŠUÞÌ	.n´I­.4uë¯<bŒØÍvâÂÚùõ#¬Zá¤ØEÓ_9Äƒ³ÀŸèÇ­åxr^1©Æ5‡œá7=–n0™l¦ãÂÀrý¶þ¹ïCü#ÓîãOè«$h'8Ì@Cgò|ÖâÅît{7›÷ï, ‘¶'yôÌäö!sêg†I
mN±Ã7ê«ªvò(ì@PhTñ*„$]Ÿø‰Ö{.Ý00äGY3FÒ	†É¨p­ëmor•1‡„3"´˜CD•V1’ôHh6£Ì…ï'ÒM§Ý6ê|z6z“I$ó´Q¶£öÕK[zËê¶ÇØ0ŒqÍ†µÍX–£§Ÿ£¤è‘—5yc|#Sƒ;èÑ‚B;¾/eÒ¶ÿ8Ÿ¾0£vvtqöbî«aóÏkÍRÅn{íýK¸i†:T`#RˆK3ê9T|ô¥ Æe¿â°Š1’Ó¹g¾_Ï¶;Ë˜ïÜPGÙàMÛ}6ÃNaS‹Ç6˜Ë£ÅˆîÔ÷k¨¦¥š—Ñn¼íªáÖûcé¸x…¹,.ê>cHùÚH·a¯¹[‡Ð‡yÕØÓ)œÖZNËFy}”~ÓH#Pê/¢á+Á®¾.n5±aÀwxe³7J¼–ÊžÒ¾R;…2'¡•ÑúÄ}ëbÙ7&"¶úàü)»;,¯ê«8¯Ø$M+ ¨è%ßÛb{Ñ,s¬ÄçÍ 
sÚO…þ1ëŠ¹%Ì×©Û£*%ÁÛ:
/ÆbÂ5gµúÀE)0~_Õ8^z¢[úû±œƒ.ÇÏ$bce:­Iá+b1žzÉÃãæ¬R!èPÉf¬$.ø«Ñ¥õù§o«&‡p(ð_ÏÚ4-ÔwÌžHØ!CÏ}íYöý`Äw÷ŒÚmÃï÷þˆªN¡¸]ŒF,ô*½0Í{˜IWB–h5*—4®ñÏ¶“â\ï•D\ë—¡ÁDkƒ¦ãð€/•Œbq˜Z±/ˆŸ%¡G>H°rY‡V`û 5“¥I6™Ëq`ÞþÍ‰û¤Xî>k¯<FNeÞïôù|m¼ÁC½Š÷Z°´Ý#³n¬P™ÐÀŽÌ™ÔU’Ò¡±€ÑÀ”Y0à˜ ÷Mõ®;2uu[¿S—Œ™ Æx)Xá„
6VÁƒqê–pœ
o”ý¯½^i)¾ôæhû`Éáo\£Î[ÀåÉ¨>Eí‰ù;^]r¨c< L €Ÿ´}]à W§"ý Åƒ¯õÛ\Qôåm´ìõ[B+È	òNüÓè(ËKÂÁéÄ’‡
<Iø‹Í<b÷?Ggâ‹kAÁÊST³×3íhŽ|¿À¡n4xéëôêhê“7”û¹U
™k¼jT=« `HÁ‡T…õS´CFÈDO&©¢nwh‘GyW„­HÈƒëî»r¹{½)¼ŽÒÙ-žÑL:ŠH¯rw.œów›¥.•vc»ÉÀêÂ³”»ËÓ#B×¶±º‘~ƒ‘ëDE¸”¦	gRAFv×c H€j„4xÎÄpz-í&·Ú½ãZ³38ËÇÍ&¡ÈòÄÑRGiâ?S ¬á˜øQJN†MâØif^	Û™äYì†µÎ{Â¯ýA>.4õªMÒf¼ñ¹ì:ÐE×âl»£À
 šDè°y‚ü6ŒÐ€¿]!'Ò¢S¿do¦AÇfYx“¥´ª‡åFzwÂà°\¨b|h$øU¨(ý•!ËšÄ£²AêÏS"3»ÛY+WBM;‹_•¯ê6À"òs4‚‘:Šå …”­àœ·W1¿jŸÝ°–§5]±æôà}ÅôËBsú^å¯He’eÖŒd9'»@\ 1ÎÂãy?Æl†T§áÑÌõ¾˜ŒvŠq:Å«di½€¢)^ß²ƒðÊ*”xM8,ƒ[ÎOŸÿênÁzÛb¥cØ—býD?Uï3#µ_ë"PÉQ–ª<«†'\÷% d·ºr–	íÖ§˜e@D—›Æ­Ù¼ñî×PÃ0¦:z¨ŠÉ9ìTq°Ha¤:<"z½ÍP”zZîäxôš÷ÙšÞ“ÎÿÞTDT,"-Ý–:ìV­AwyWq0aâth´|IBé„‚âéûc»¼5o¢™	ä®íO2«lz…{Œn)üßä,qýÿ¯¤d™›ïÇß>Å·3¢
!iØî$ôŸoˆÔÈXÐË	3Þ›ß¨h¤“–*m­[µÖ]Ÿ¦»¡çø‹órui±"Zh§«‰€úVùÂ±jl×’:nÄl&&Bº/™¹ñX-—/œ%z(žû2Æž¸{g±ËB±ÃRÃþêjÉ¥Î¿Ü¶Á{Ê%i/¹:ö.Ò«ÂÜÉÆ¶±Òd^ÎB¬©.M¶|®î2%Ôc0@O~o"PÌŒUú¸‹4î«xÁQò˜T°KØ¤A/ƒ¡„¾WN–ÿ]Œü¤ÆŒ+ö–±«ñç{{]~ef¬jª,;ê‹)ê½^sUUÉD{!ãß(ªçYDå¥Ž”š(rã¨n7v †ID«Ýè]Æ;]O!vÛê›à/ÈRAëe¥ÔCÿ¾^f‚¯²<×Ç{˜ÀÁI_É)(ùöýSùSpËŠâjÎù›—Ì$¤YxlÛŸ•œ±Æ<×‘lÎñƒß¿xBkÒdûéÐU•‡¸X€^3Œ~Ö±ýªÂ¼e0¹:õ®óš/RxØ×5õ©!Æ'_*$Õ!K«-6ø‚v§¾êŠ)4mÕ¼ƒ-Ý ‹¹®£§£[Þhâ “'È=5 ÷Žø“ÚáF³‰dÐÑ_Œé›
Ï®ž-éÛß’3ÏDþVL£  I)Œ&aÏƒ¯áøzÚô©Y…ã­§óÍ€'™–/ù’õû^påÌd‚CÖLxé¥Ðg«G0‚Vë¾KAú.U)º ‘ÎtQâÎ ð²£úeVYUbtŽ%vRUØLàá¸>„q!-ûšLë5p÷iuYTªF$(=E(ƒ»¡§JÙõÕ7f‰-t-`51Rr? äŸÀËÞüb«ƒT€°>Ð+ž”rXltü-È *ºïwWZŽÞÈ}Lœ}+^Ìê'‡Ëë×FøÞŽfO²KÚ„›ø’x®ÛÙ 4Ž2‚ƒ;AÎ)ö„Ûïª”­ÉkCê8|…R¨0ùÑm-÷èáÒ¡Îš)V	Œ=’<íBøÅW]FåRdj(v~EáóüdEç³ÕÙwÉ¾ptI2cA|çqÁÛ…{³¦téÎö„¸§Æ´"Þ‡Ëeû·žOÆµiçê}‰ùiG®C² ûlYxIÛÇzqþäÒ,›·ÌŒøOŠvîZZþ¼ý•úJ-/G“UT ¼¶<]£0¢ A¾‰TÅîrÉ£èàµôï¼ºûî:7	®»¥ÉÃ^g`_ßL¼°!š¢½\ü}zè(ÜÖIXÅ÷ìœq3³žàÒ>@b º=‡„‚rÕ€jE[ßK(Jøç?+]#Xy9ÄO[CúR¿¹ˆJ¼O8–kzNBÁ6´*có“‹é°1v¢€29©¾k	Q‘»NfgfZ¶??s~w²’¾ÑÅK‚—"BË§¼é#ßKôZR#¥\½¸}9Ù"õ§Q´Tÿ7]ãX¦<8ÌÐÚUÇÅòiLœÍìÚÙ^Ôµå6k|I:„Sìm€¼sæˆKY'ƒ!ÏJ»ZeñBªg€°bÎwÁ^kÑ`­ó°vTˆŒ‰îqîƒ‰m{ìA¤sæ£{·ùŠ&ŠlåÓ–ñ¹+9ŽÃ9OÃ´á>½9ÚCýqºûª'šx`Å}R?Ò¿n€´_Ó@<"5‰Œ™_#iX6É—oUœ(#gçáZg’’ôâkg¥Æ’ &ÎZ ÔZÊuœø!§m‘!‚óõ<¤Ùà¾"k°<…t£¸D.zlK|£ÊìäÌð×Žú°àSí-ÅÚÆw‘Ôl%ÁÏÝY«ÿoËÊ>Å›ÐÊ1ã>ØDHAØö˜¥œÏ•Ÿ]ÍÍ°šÀÝ¤ßóîß®Ô3 ²pà•Ý}8l¨‡=»ƒxnäü+ÊÞÄ·A•ÅWdÑþhë:€ƒ%vh/f²ÕÃÒŠþhZ[ÿZ2úL+kÇ³ê–NãDà'€
ïÎbÛéõ³n@*Ö.ˆÄ³ÖeÇp‹ˆ¸a¬·óÖ3Þ½e‘älvKÐÝ9ñ·ðÐzÈÄu%Ò:´¨wmé"ÕG‡ÜÕ’3kÙå¾Öê?éo´Æ¨9àGDm³–°]rÁ•
)"·Ö)Ê›öê*Zƒ©AiŠßQkíqkx×À‚©vÉºUU«~ÁUù¢fc æ^3ÉçÃ	s*WAFuÑØªü'¿Vç|Ú?†ØZNyŽ¹û†ïöÿ<"ŒCúæf—0§"<•Uÿ¥F,6Š!ÒòRÏOÚÞVDþ˜‹C8 I•¯Z|‹;4m²¡H ô1Œ›,†Æƒ£jÑY¹ðÿ– #X2ÿa‘O3¨«QC/ò¡m„‘{í ¦A‘à¬=R(A—>(¬tH¾Ix>Ù™3®¨RdhÝÖ$>ì‰pN’»°:N´¼{i~ðëê«n‹µ zySÕÁ„ùú0IËþ¦Ê€qÒ–¤Õ—CR}wF1Á${8bcfÓì&È|ú)Ól×›ðÙNW10*AŒ½TÔ‰àöbÕø)õ“Òš2ã<†vÔ&*o·`g~%ZB¾ì¦™÷zëS\v0¾Å¢§AKú ™ÃÆƒìÜF‰!)Ö5ã
“9÷“ír$ðø%D2ÛÈÐÚ¢ö±ttB‚an4£vM‚ûÆN-ø	Át@[jÒŸnMÏ	!þEöÞ	¥Ï’†ðúéÜ¡Þk7šsónfÓ.O’…ÔŽcÑïzÛ»™ÐˆÜù\ÃE”1íaÀgA—¶q
|?ðÏC¥è0òfGW’„qÀ/@«çç[r–ÀúiqÏPg·Â[—á­n`üp‡V?~bÈ¬SCŸ:ÏTÞ±õ®—tÓd¥}¾p,®˜™\#Û<Ÿš»ãþ¢lÙVm¶M5ô‘'Ë•ÊC¬Ù³=)&Cn"ž´n¼Øä¨7oäm"!¥ëØ#£$Ú	S¬Àm|ä•$»œ‚#=HÃ	Ä@&Ü7Q¼fƒ7T½¡ì¡B”[Ç`·zª"u£Ì\=?\?»™ž‚³F"bþêPdL0J§Ú¿æÖÉ¾™©ÇÔƒM‡ÚC±b÷SŽÎP¤¨Ô„EøEo…jÃ:5ç\:VoÖ^`aSñÌÖh‘ çaÞ?XäÅ]J_˜ÅÐD¦Ú|%RfýXgGµ®Ïà(2|ðÛ,ÆDÈ‚ˆMp©¦õÚ¢"ÍFÔ®÷´üø³®¿ÐU®°!@¿§·üëGßoËÁ¶lKŸÂ ­Dø.gÌR6¡B»ËÉ+Ìé…•¸Ù•/	fµÂiìU}6éEÛ4Üf„£SVÁohf»Ñ’gô¯&Ek`þéŠ§k)ÐZ®ùbÑHYI–‹§• Ñ& \ô¤ÿÆ
l;×½7@„³š€©ð×½Ê,À„€X#ÒœºBØtú°C¦ô^JO×†7¢à˜þ3u¹:ì"”W5wüÑi¾VoTƒáhwqh!R) ]Ì,–Æl$2•u>oBöNYNyö1~Tœ6VL ‰cS_|¶Ÿäõ‰1	wØÝü=Þ„ÿ»îv[¬¹0éd×F…V–êÀ£Ë(ñàLõ ^Q?þ¥Í€œ1‚²Æ0u…gÀüp—êÙ¥QÐó%À1z\h˜YÍ„]/#†çM=Ðö'Ô‹7+5˜…QÝ%¹¡k¿¹ys†¸y,Â‰»îƒ“Ú@WÑ¶"|¦A¡ÇÅŒI6ívº‰—ƒ_WHN¸k=r” ÕU•˜yï«ç½…•„ß¤ÈqwT„ ¹\Œ™šþ&öWBx@Gîß!ð×¢Þ4èÔøWÅ›G„oäEƒÚoŒÊ1ßw¯u­—‘·_³¼Ïž!/õMâHHl5ú³’QBBØ'“Í,åF¾m“F]¥“(Év}šåå<ÆÒp¿ßnC¨­uù|ó+þ‹3CÏ_×B¾®UNí4 „(Âœ¯º°^o79ÔòÏŽ°@ D±È5˜#W/¯W–ÙÏûçÿœêub]$DÊ®D #[=ILAæwréà³M‡ÛdŽ6šÁÜ˜!}L¼v?ip¦½§û«1R‰^@AmÿM?R¤õ,øZk3]‰CEÉA±hÎ¶ŠÚ¾·‡›xc¾ß,Ü?ÅãˆG#=ÚPó1Ïˆû¾ƒFC¯W:
ŠgŠKïÕÂyû?.ÕèiÀ-”<ÓýQz;ÿ+@¹ò®$ùÔžc&¹/|Q6^©D‘¡X9HÌç`ºS‘{mµÐá`°‹ÛF}×ºÙçF¬C¹æiTÌÅä|E†Ï?Ž%Õ˜eÄ Ò!0¡Æ>WØ!\ItÔãK,y¢Hï`¾†žYnç¿Ÿ†æ¼¥”$nvëQÂÊd_ºÄAÜ¼›K¤[ê+AøGýûì’ î¨Že“à'«ª‹dP)¦-æAy‹œc¶Ý\þÛXënyÙ>ªçeV’ña÷B‹prßéý{M´Yª³5ž£{wºƒ¶ek»ýôQ©’Áq«íøÎG¢|¥ !—Û¥N@jüyÊÂ•‹Þ6÷ô/Æ;ÒG¸wgÙ™þ´>LõO·ñ]0aúÍö†«ý¼£òìi.¾±ç6ÀÏucj^\¼JgE4Ëàˆ„tî22Ÿi¸Ú9ÏOG2º¦Lb—}Ü²”§“¦0ª¤Ý×§ö@_Ñz. Á`Ûh­ñÊEoJ""ÞÊ¶…úÎ/žÕv|·ÜÔ1
õókÐ[Á&^1q€SPJ	ÕD×ã­Z*éCÞ6|®’•p¹ó¡*sôz¾ýPÕTæƒf@­{R´d•ÅCÌBñ^×aËB?÷½ýõ ËbçNÉ'üDz±©wìÛ¹Ý:‘?R\B•œ:Rš/`šûÃ‚IŒªFÐ$÷y4ne(CJ¹ƒÆ2³ …M0æè,©ju5¼9³m"å}J)È¬es˜Ït¥Ñ­oGâ„è½¶g+ÙL¨$up)"ÖE•n
Œ0¯5€=¤Ç )ÊæoZ¼º~2+§Uìêpôü1¤f$Ëëë4¶ô7c-‘ èS¸¨¥“…×,xÁž¾ÀEžD> 2¦¹å‹›´
> GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0  .shstrtab .interp .note.ABI-tag .note.gnu.build-id .gnu.hash .dynsym .dynstr .gnu.version .gnu.version_r .rela.dyn .rela.plt .init .plt.got .text .fini .rodata .eh_frame_hdr .eh_frame .init_array .fini_array .dynamic .data .bss .comment                                                                                   8      8                                                 T      T                                     !             t      t      $                              4   öÿÿo       ˜      ˜      4                             >             Ð      Ð                                 F             Ð      Ð      d                             N   ÿÿÿo       4      4      @                            [   þÿÿo       x      x      P                            j             È      È      ð                            t      B       ¸      ¸                                ~             È
      È
                                    y             à
      à
      p                            „             P      P                                                `      `                                   “             ð      ð      	                              ™                           X                              ¡             X      X      „                              ¯             à      à      (                             ¹                                                      Å                                                      Ñ                           ð                           ˆ                         ð                             Ú                             T-                              à             `M      TM      H                              å      0               TM      )                                                   }M      î                              