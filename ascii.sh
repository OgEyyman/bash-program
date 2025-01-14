#!/bin/bash 
 
function show_menu() { 
# Function to display Zenity menu and handle user's choice 
    while true; do 
         
        choice=$(zenity --list --title "ASCII Art Menu" --text "Choose an option:" -
radiolist --column "Select" --column "Option" TRUE "Animation of text" FALSE "ASCII Art 
of Photo in Color" --width 300 --height 200) 
 
        # Handle user's choice  
        case "$choice" in 
            "Animation of text") 
                 
                user_input=$(zenity --entry --title "Figlet Animation" --text "Enter 
some text:") 
 
                if [ $? -ne 0 ]; then 
                    continue 
                fi 
 
                if [[ -z $user_input ]]; then 
                    zenity --info --title "Figlet Animation" --text "No text entered. 
Exiting." 
                    continue 
                fi 
 
                # Generate the ASCII art animation using Figlet 
                animation=$(figlet "$user_input") 
 
                # Display information messages using Zenity 
                zenity --info --title "Figlet Animation" --text "Animation will start on 
terminal" 
 
                # Display the animation on the command prompt using pv 
                echo "$animation" | pv -qL 10 
 
                zenity --info --title "Figlet Animation" --text "Animation completed" 
                continue 
                ;; 
            "ASCII Art of Photo in Color") 
                # Prompt the user to select a photo using Zenity 
                local file_path=$(zenity --file-selection --title="Select a photo" -
file-filter="Images (jpg, png) | *.jpg *.png") 
 
                if [[ -n "$file_path" ]]; then 
                    # Convert the photo to ASCII art using jp2a 
                    jp2a "$file_path" --size=80x25 --colors 
                else 
                    zenity --warning --title "Ascii art" --text "No photo selected" 
                    continue 
                fi 
                ;; 
            *) 
                return 
                ;; 
        esac 
    done 
} 
 
# Display the Zenity menu 
show_menu 