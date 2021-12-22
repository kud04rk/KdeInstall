
#!/usr/bin/env bash
#-----------------------------------------------------------------------
#   █████████                                            █████         
#  ███░░░░░███                                          ░░███          
# ███     ░░░  ████████  █████ ████  █████   ██████   ███████   ██████ 
#░███         ░░███░░███░░███ ░███  ███░░   ███░░███ ███░░███  ███░░███
#░███          ░███ ░░░  ░███ ░███ ░░█████ ░███████ ░███ ░███ ░███ ░███
#░░███     ███ ░███      ░███ ░███  ░░░░███░███░░░  ░███ ░███ ░███ ░███
# ░░█████████  █████     ░░████████ ██████ ░░██████ ░░████████░░██████ 
#  ░░░░░░░░░  ░░░░░       ░░░░░░░░ ░░░░░░   ░░░░░░   ░░░░░░░░  ░░░░░░  
#-------------------------------------------------------------------------

if [ $(whoami) = "root"  ];
then
if lspci | grep -E "NVIDIA|GeForce"; then
    	nvidia-xconfig
fi
umount /.snapshots/
rm -ef /.snapshots/
snapper -c root create-config /
echo "Enter the Name of user who can Access the snapshots"
read userna
echo "yOUCAN EDIT THIS LATER AT /etc/snapper/config/root"
sed -i 's/^ALLOW_USERS=""/ALLOW_USERS="'"$userna"'"/' /etc/snapper/config/root
sed -i 's/^TIMELINE_LIMIT_HOURLY="10"/TIMELINE_LIMIT_HOURLY="8"/' /etc/snapper/config/root
sed -i 's/^TIMELINE_LIMIT_DAILY="10"/TIMELINE_LIMIT_DAILY="6"/' /etc/snapper/config/root
sed -i 's/^TIMELINE_LIMIT_WEEKLY="0"/TIMELINE_LIMIT_WEEKLY="3"/' /etc/snapper/config/root
sed -i 's/^TIMELINE_LIMIT_MONTHLY="10"/TIMELINE_LIMIT_MONTHLY="3"/' /etc/snapper/config/root
sed -i 's/^TIMELINE_LIMIT_YEARLY="10"/TIMELINE_LIMIT_YEARLY="0"/' /etc/snapper/config/root

chmod a+rx /.snapshots/
systemctl start snapper-timeline.timer
systemctl enable snapper-timeline.timer
systemctl start snapper-cleanup.timer
systemctl enable snapper-cleanup.timer

# echo "Enter the Name of BOOTLOADER installed"
# read bootloader
# if [[ ${bootloader} =~ "grub"  ]]; then
# systemctl start grub-btrfs.path
# systemctl enable grub-btrfs.path
# grub-mkconfig -o /boot/grub/grub.cfg
# fi

systemctl start grub-btrfs.path
systemctl enable grub-btrfs.path
grub-mkconfig -o /boot/grub/grub.cfg


echo -e "\nEnabling Login Display Manager"
systemctl enable sddm.service
echo -e "\nSetup SDDM Theme"
cat <<EOF > /etc/sddm.conf
[Theme]
Current=Nordic
EOF
else
echo "-------------------------------------------------"
echo "                 Run As Root                     "
echo "-------------------------------------------------"
fi


