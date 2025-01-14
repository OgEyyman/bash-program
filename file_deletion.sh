#!/bin/bash

function show_menu() {
    # Function to display the menu and get the user's choice
    local selected_file=$(zenity --list --width=300 --height=600 --title="Select a file to delete" \
        --column="File" "${options[@]}" --cancel-label="Back")

    # Check if the user canceled the dialog
    if [ $? -ne 0 ]; then
        return
    fi

    if [ -z "$selected_file" ]; then
        zenity --warning --text='Select a file' --title="Warning"
    else
        echo "$selected_file"
    fi
}

delete_file() {
    # Function to delete the selected file
    local file="$1"

    # Check if the file path is not empty
    if [ -n "$file" ]; then
        # Check if the file exists
        if [ -f "$file" ]; then
            local response=$(zenity --question --title="Confirmation" --text="Are you sure you want to delete $file?")

            # Check if the user confirmed the deletion
            if [ $? -eq 0 ]; then
                rm "$file"
                zenity --info --title="Success" --text="$file deleted successfully."
            else
                zenity --info --title="Cancelled" --text="Deletion cancelled."
            fi
        fi
    else
        # Display an error message using Zenity if the file path is empty
        zenity --error --title="Error" --text="File does not exist."
    fi
}

while true; do
    # Prompt for directory name or use the current directory
    directory=$(zenity --entry --title="Directory" --text="Enter directory path (leave blank for current directory):" \
        --cancel-label="Return to main menu")

    if [ $? -ne 0 ]; then
        return
    fi

    # If directory is empty, set it to the current directory
    if [ -z "$directory" ]; then
        directory=$(pwd)
    fi

    # Check if the directory exists
    if [ ! -d "$directory" ]; then
        zenity --error --title="Error" --text="Directory does not exist."
        continue
    fi

    # Get a list of files in the specified directory using the 'find' command
    files=$(find "$directory" -maxdepth 1 -type f -printf "%f\n")

    # Check if any files exist in the directory
    if [ -z "$files" ]; then
        zenity --error --title="Error" --text="No files found in the directory."
        exit 1
    fi

    # Create an array of options for the menu
    options=()
    while IFS= read -r file; do
        # Add each file name to the 'options' array
        options+=("$file")
    done <<< "$files"

    # Display the menu and get the user's choice using the 'show_menu' function
    selected=$(show_menu)

    # Delete the selected file by calling the 'delete_file' function with the full file path
    delete_file "$directory/$selected"
done
