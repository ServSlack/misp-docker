# Install Latest Docker:
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose docker-compose-plugin resource-agents-extra -y

# Start Docker:
sudo systemctl restart docker
sudo systemctl status docker

echo "Create VG, LV and Format " /SRV" using "/DEV/SDB" disk:"
vgcreate vgmisp /dev/sdb1
lvcreate -n data -l 100%FREE vgmisp
mkfs.xfs /dev/vgmisp/data
echo '/dev/vgmisp/data /srv         xfs     noatime        0 0' >> /etc/fstab
mount -a && df -HT /srv
