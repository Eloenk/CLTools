
set -e

# Function to display graphical text
show_banner() {
    echo "\e[1;34m"
    echo "  ███████╗██╗      ██████╗ ███████╗███╗   ██╗    ██╗  ██╗ ██████╗  ██████╗██╗  ██╗"
    echo "  ██╔════╝██║     ██╔═══██╗██╔════╝████╗  ██║    ██║ ██║ ██╔═══██╗██╔════╝██║  ██║"
    echo "  █████╗  ██║     ██║   ██║█████╗  ██╔██╗ ██║    █████║  ██║   ██║██║     ███████║"
    echo "  ██╔══╝  ██║     ██║   ██║██╔══╝  ██║╚██╗██║    ██╔═██║ ██║   ██║██║     ██╔══██║"
    echo "  ███████ ███████╗╚██████╔╝███████╗██║ ╚████║    ██║  ██║╚██████╔╝╚██████╗██║  ██║"
    echo "  ╚══════╝╚══════╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝    ╚═╝  ╚═╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝"
    echo "\e[0m"
}
ramin() {
    show_banner
    SWAPFILE="/swapfile"
    SIZE="8G"
    # Create an 8GB swap file
    fallocate -l $SIZE $SWAPFILE || dd if=/dev/zero of=$SWAPFILE bs=1M count=8192
    # Set correct permissions
    chmod 600 $SWAPFILE
    # Format the swap file
    mkswap $SWAPFILE
    # Enable the swap file
    swapon $SWAPFILE
    # Set highest priority (32767)
    sysctl vm.swappiness=100
    swapon --priority 32767 $SWAPFILE
    # Make it persistent
    echo "$SWAPFILE none swap sw 0 0" >> /etc/fstab
    
    echo "Swap file of $SIZE created with highest priority."


}
ramin
echo "done"
echo "vm.swappiness=100" >> /etc/sysctl.conf

