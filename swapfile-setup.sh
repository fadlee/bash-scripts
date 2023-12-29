#!/bin/bash

# Prompt the user for swap size (default is 2G)
read -p "Enter swap size (e.g., 1G, 512M, default is 2G): " swap_size
swap_size=${swap_size:-2G}

# Prompt the user for swap file name (default is /swapfile)
read -p "Enter swap file name (default is /swapfile): " swap_filename
swap_filename=${swap_filename:-/swapfile}

# Create a swap file
fallocate -l $swap_size $swap_filename
chmod 600 $swap_filename
mkswap $swap_filename

# Activate the swap
swapon $swap_filename

# Update /etc/fstab to mount swap at boot time
echo "$swap_filename none swap sw 0 0" | sudo tee -a /etc/fstab

echo "Swap has been created and activated. Swap size: $swap_size, Swap filename: $swap_filename"
