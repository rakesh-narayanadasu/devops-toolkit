# How to increase EBS volume without stopping EC2 instance?

Step 1:
EC2 -> Volumes -> Select Volume -> Actions -> Modify volume -> increase desired size -> Click on Modify

Step 2:

```
# Check the volume
df -h

# list block 
lsblk  # you will see the increased volume, notedown the fs name

# Install cloud-guest-utils
sudo apt install cloud-guest-utils

# grow the partition
sudo growpart /dev/nvme0n1 1

# Update the file system
sudo resize2fs /dev/nvme0n1p1   

# Now check the volumme
df- h

```

