# Format and mount a non-boot disk on a Linux VM

List the disk that attached to the instance
```
sudo lsblk

NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda       8:0    0   15G  0 disk 
sdb       8:16   0   10G  0 disk 
├─sdb1    8:17   0  9.9G  0 part /
├─sdb14   8:30   0    3M  0 part 
└─sdb15   8:31   0  124M  0 part /boot/efi
```

Format the disk device using the mkfs tool. This command deletes all data from the specified disk, so make sure that you specify the disk device correctly.
```
 sudo mkfs.FILE_SYSTEM_TYPE -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/DEVICE_NAME
# Example
sudo mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sda         
```
Replace the following:
- FILE_SYSTEM_TYPE: the file system type. For example, ext2, ext3, ext4, or xfs.
- DEVICE_NAME: the device name of the disk that you are formatting. For example, using the example output from the first step, you would use sdb for the device name.

Mount the disk:

Create a directory that serves as the mount point for the new disk on the VM. You can use any directory. The following example creates a directory under /mnt/disks/.
```
sudo mkdir -p /mnt/disks/MOUNT_DIR

# Example
sudo mkdir -p /mnt/disks/demo
```
Replace MOUNT_DIR with the directory at which to mount disk.

Use the mount tool to mount the disk to the instance, and enable the discard option:
```
sudo mount -o discard,defaults /dev/DEVICE_NAME /mnt/disks/MOUNT_DIR

# Example
sudo mount -o discard,defaults /dev/sda /mnt/disks/demo
```
Replace the following:
- DEVICE_NAME: the device name of the disk to mount.
- MOUNT_DIR: the directory in which to mount your disk.

Configure read and write permissions on the disk. For this example, grant write access to the disk for all users.
```
sudo chmod a+w /mnt/disks/MOUNT_DIR

# Example
sudo chmod a+w /mnt/disks/demo
```
Replace MOUNT_DIR with the directory where you mounted your disk.

# Configure automatic mounting on VM restart

Add the disk to your /etc/fstab file, so that the disk automatically mounts again when the VM restarts. On Linux operating systems, the device name can change with each reboot, but the device UUID always points to the same volume, even when you move disks between systems. Because of this, we recommend using the device UUID instead of the device name to configure automatic mounting on VM restart.

# How to Mount a Disk Permanently Using /etc/fstab

## Backup the current fstab file

Always keep a backup.

```bash
sudo cp /etc/fstab /etc/fstab.backup
```

## Get the UUID of the disk

Run:

```bash
# sudo blkid /dev/DEVICE_NAME

sudo blkid /dev/sdb
```

Example output:

```
/dev/sdb: UUID="a9e1c14b-f06a-47eb-adb7-622226fee060" TYPE="ext4"
```

Copy the UUID value.

## Edit the /etc/fstab file

Open it:

```bash
sudo nano /etc/fstab
```

Add this line at the bottom:

```
# UUID=UUID_VALUE /mnt/disks/MOUNT_DIR FILE_SYSTEM_TYPE discard,MOUNT_OPTION 0 2

UUID=a9e1c14b-f06a-47eb-adb7-622226fee060 /mnt/disks/demo ext4 defaults,nofail,discard 0 2
```

**Replace:**

- `UUID` → your disk UUID
- `/mnt/disks/demo` → your mount directory
- `ext4` → filesystem type (most common)

### Explanation of options:

| Option | Meaning |
|--------|---------|
| `defaults` | Standard mount options |
| `nofail` | VM will still boot even if disk missing |
| `discard` | Optimizes SSD persistent disks (good for cloud disks) |
| `0` | No dump backup |
| `2` | Filesystem check order |

Save the file.

## Verify the configuration (important)

Run:

```bash
sudo mount -a
```

If no errors appear, the configuration is correct.

## Confirm

```bash
df -h
```

You should see:

```
/dev/sdb  15G  ...  /mnt/disks/demo
```

## Test by rebooting

```bash
sudo reboot
```

After reboot:

```bash
df -h
```

The disk should automatically mount.
