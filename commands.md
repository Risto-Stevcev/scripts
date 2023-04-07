# Commands 

## Luks
sudo cryptsetup luksDump /dev/nvme0n1p2
sudo cryptsetup luksAddKey /dev/nvme0n1p2
sudo cryptsetup --verbose open --test-passphrase /dev/nvme0n1p2
