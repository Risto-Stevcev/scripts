# Commands

## Luks

```
$ sudo cryptsetup luksDump /dev/nvme0n1p2
$ sudo cryptsetup luksAddKey /dev/nvme0n1p2
$ sudo cryptsetup --verbose open --test-passphrase /dev/nvme0n1p2
```

## Squashfs

### Make squashfs filesystem

```
$ mksquashfs runit/ runit.sqsh
```

### Create dirs (`fm` is the folder you want to squash)

```
$ mkdir -p fm to temp fin
```

### Mount the squashfs the usual way (read-only)

```
$ mount runit.sqsh /home/risto/tmp/fm -t squashfs -o loop
```

### But we also want to write, so mount an overlay "union" filesystem

```
$ mount -t overlay -o lowerdir=fm,upperdir=to,workdir=temp overlay fin
```

### Check that they're mounted (findmnt since it's not a block device)

```
$ findmnt -t squashfs,overlay
TARGET              SOURCE     FSTYPE   OPTIONS
/home/risto/tmp/fm  /dev/loop0 squashfs ro,relatime,errors=continue
/home/risto/tmp/fin overlay    overlay  rw,relatime,lowerdir=fm,upperdir=to,workdir=temp,xino=off
```

### New squashfs

```
$ sudo mksquashfs fin /full_path/filesystem.squashfs
```

### Unmount

```
$ sudo umount fin fm
```

### Base Conversion Calc

```
echo "obase=10; ibase=2; 10101010" | bc
```

### Xorg

#### View settings, including for screensaver

```
xset q
```

#### Turn on screensaver

```
xset s on
```
