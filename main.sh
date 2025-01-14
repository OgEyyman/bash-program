#!/bin/bash

function display_date_time() {
    # Function to display current date and time
    
    # Get the current date and time
    datetime=$(date +"%A, %B %d, %Y%n%r")
    
    zenity --info --width=200 --height=100 --title "Date/Time" \
        --text='<span font="Arial 16">'"$datetime"'</span>' --ok-label="Return to main menu"
}

function main() {
    # Function to display main menu
    
    while true; do
        # Display Main menu
        choice=$(zenity --list --title="Menu" --width=450 --height=380 --text="Select an option:" \
            --column="Option" --column="Description" \
            "System information      " "Display specification of the system" \
            "Date/Time" "Display today's date and current time" \
            "Calendar" "Display calendar (can add and view reminders)" \
            "Delete" "Delete files on your computer system" \
            "Games" "Play a game of your choice" \
            "Facts" "Learn 100 facts about the solar systems" \
            "Weather forecast" "Receive the weather forecast" \
            "Quiz" "Attempt a quiz based on the 100 facts" \
            "Memes" "Display some funny images" \
            "Savings" "Add or view savings" \
            "Exit" "Close the menu" --cancel-label="Exit")
        
        if [ $? -ne 0 ]; then
            exit
        fi

        # Source appropriate files and call appropriate functions
        case "$choice" in
            "System information      ")
                source ~/Desktop/coursework2/allfiles/display.sh
                ;;
            "Date/Time")
                display_date_time
                ;;
            "Calendar")
                source ~/Desktop/coursework2/allfiles/calendar.sh
                ;;
            "Delete")
                source ~/Desktop/coursework2/allfiles/file_deletion.sh
                ;;
            "Games")
                source ~/Desktop/coursework2/allfiles/game.sh
                ;;
            "Facts")
                source ~/Desktop/coursework2/allfiles/webscraping.sh
                facts
                ;;
            "Quiz")
                source ~/Desktop/coursework2/allfiles/webscraping.sh
                mcq
                ;;
            "Weather forecast")
                source ~/Desktop/coursework2/allfiles/webscraping.sh
                weather_forecast
                # Remove temporary html file
                rm output.html
                ;;
            "Memes")
                source ~/Desktop/coursework2/allfiles/meme.sh
                ;;
            "Savings")
                source ~/Desktop/coursework2/allfiles/savings.sh
                ;;
            "Exit")
                exit 0
                ;;
            *)
                # Display a warning window to force the user to select an option
                zenity --warning --text='<span font="Helvetica 20" foreground="red">Select an item</span>' --title="Warning"
                ;;
        esac
    done
}

main
