#!/bin/bash

function progress() {
    # Function to display a progress bar

    # Progress message
    local message=$1

    # Progress percentage
    local percentage=$2

    echo "$percentage"
    echo "# $message"

    # Time elapse of 1s
    sleep 1
}

function display_progress() {
    # Function containing the main script to display the bar

    # Calling function progress with its parameters
    progress "Starting..." 0
    progress "Adding the information..." 25
    progress "Almost done..." 75
    progress "Information has been written" 100
}

function show_calendar() {
    # Function to display calendar and allow selecting a date

    while true; do
        # Display a calendar for the user to choose a date
        selected_date=$(zenity --calendar --width=300 --height=200 --title="Select a Date" \
            --text="Choose a date to add or view information:" --date-format="%Y-%m-%d" \
            --day=$(date +%d) --month=$(date +%m) --year=$(date +%Y) --cancel-label="Return to Menu")

        if [ $? -ne 0 ]; then
            break
        fi

        while true; do
            # Display options available to the user
            action=$(zenity --list --width=300 --height=220 --title="Select Action" \
                --text="Choose an action for $selected_date:" --column="Action" \
                "Add Information" "View Information" "Delete Information" \
                --cancel-label="Return")

            if [ $? -ne 0 ]; then
                break
            fi

            # Executes respective block of code according to user's choice
            case "$action" in
                "Add Information")
                    while true; do
                        # Adding information for a particular date
                        info=$(zenity --title="Add Information" --text="Enter relevant information for $selected_date:" \
                            --entry --width=400 --height=200 --cancel-label="Back")

                        if [ $? -ne 0 ]; then
                            break
                        fi

                        # Validating that the input is not empty
                        if [ -z "$info" ]; then
                            zenity --warning --title "Menu Item" --text "Please enter a text"
                        else
                            display_progress | zenity --progress --title="Progress Bar" --text="Working..." --auto-close

                            # If user cancels the progress window, no information is added
                            if [ $? -ne 0 ]; then
                                zenity --info --title="No entry made" --text="No information added on $selected_date." --ok-label="Back"
                            else
                                datetime=$(date +"%A, %B %d %Y at %r")
                                echo "$selected_date: INFORMATION: $info WAS ADDED ON: $datetime" >> /home/ayman/Desktop/coursework2/allfiles/date.txt
                                zenity --info --title="Information Added" --text="Information added successfully for $selected_date." --ok-label="Back"
                            fi

                            break
                        fi
                    done
                    ;;
                "View Information")
                    # This line retrieves information from the file date.txt for the selected date.
                    info=$(grep "^$selected_date" /home/ayman/Desktop/coursework2/allfiles/date.txt | cut -d ":" -f2-)

                    # Checks if $info is empty and displays appropriate Zenity info dialog
                    if [[ -z $info ]]; then
                        zenity --info --title="No Information Found" --text="No information available for $selected_date." --ok-label="Back"
                    else
                        zenity --info --title="Information for $selected_date" --text="$info" --ok-label="Back"
                    fi
                    continue
                    ;;
                "Delete Information")
                    # Array lines
                    lines=()

                    # Read each line from the file
                    while IFS= read -r line; do
                        # Checks if line starts with the date the user selected, adding it to the array
                        if [[ $line == "$selected_date"* ]]; then
                            lines+=("$line")
                        fi
                    done < "/home/ayman/Desktop/coursework2/allfiles/date.txt"

                    # Check if any matching lines were found
                    if [ ${#lines[@]} -eq 0 ]; then
                        zenity --info --title "No information found" --text "No information available for $selected_date."
                        break
                    fi

                    # Display the list using Zenity
                    selection=$(zenity --list --width=700 --height=700 --title "Information List" \
                        --text "Select an information:" --column "Informations" "${lines[@]}" \
                        --ok-label="Delete" --cancel-label="Back")

                    # Delete the selected line from the file
                    if [ -n "$selection" ]; then
                        sed -i "/^$selection$/d" "/home/ayman/Desktop/coursework2/allfiles/date.txt"
                        zenity --info --title "Deletion Successful" --text "The selected information has been deleted."
                        continue
                    fi
                    ;;

                *)
                    zenity --warning --title "Menu Item" --text "Please enter a text"
                    continue
                    ;;
            esac
        done
    done
}

show_calendar
