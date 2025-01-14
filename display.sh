#!/bin/bash

# Operating System Type
os_type=$(cat /etc/os-release)

# Computer CPU Information
cpu_info=$(lscpu)

# Memory Information
mem_info=$(free -h)

# Hard Disk Information
disk_info=$(df -h)

# File System (Mounted)
filesystem_info=$(mount | column -t)

while true; do
    # Display user a list of options
    choice=$(zenity --list --title="System Information" --width=300 --height=230 \
        --column="Types of information" --text="Select one" \
        "Operating System Type" "Cpu Information" "Memory Information" \
        "Hard Disk Information" "File System" --cancel-label="Return to main menu")

    if [ $? -ne 0 ]; then
        return
    fi

    # Display appropriate information in a window
    case "$choice" in
        "Operating System Type")
            zenity --text-info --font="Monospace 10" --filename=<(echo "$os_type") \
                --title="Operating System Type" --width=710 --height=343 \
                --ok-label="Back" --cancel-label="Return to main menu"
            ;;
        "Cpu Information")
            zenity --text-info --font="Monospace 10" --filename=<(echo "$cpu_info") \
                --title="Cpu Information" --width=940 --height=893 \
                --ok-label="Back" --cancel-label="Return to main menu"
            ;;
        "Memory Information")
            zenity --text-info --font="Monospace 10" --filename=<(echo "$mem_info") \
                --title="Memory Information" --width=700 --height=153 \
                --ok-label="Back" --cancel-label="Return to main menu"
            ;;
        "Hard Disk Information")
            zenity --text-info --font="Monospace 10" --filename=<(echo "$disk_info") \
                --title="Hard Disk Information" --width=480 --height=250 \
                --ok-label="Back" --cancel-label="Return to main menu"
            ;;
        "File System")
            zenity --text-info --font="Monospace 10" --filename=<(echo "$filesystem_info") \
                --title="File System Information" --width=1750 --height=1080 \
                --ok-label="Back" --cancel-label="Return to main menu"
            ;;
        *)
            # Warning window to force user to make a selection
            zenity --warning --text='<span font="Calibri 20" foreground="red">Select an item</span>' \
                --title="Warning"
            continue
            ;;
    esac

    if [ $? -ne 0 ]; then
        break
    fi
done
