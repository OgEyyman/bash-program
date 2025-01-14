#!/bin/bash

function is_number() {
    # Function to validate if input is a number

    # Check if the input matches the pattern of a number
    if [[ "$1" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        return 0
    else
        return 1
    fi
}

function get_user_input() {
    # Function to display the entry form and validate user input

    while true; do
        local form=$(zenity --forms \
            --title="Saving Entry Form" \
            --text="Enter the details:" \
            --add-calendar="Date:" \
            --add-entry="Amount Earned:" \
            --add-entry="Amount Spent:" \
            --cancel-label="Back")

        if [[ -z "$form" ]]; then
            return
        fi

        # Parse the user input from the form
        date=$(echo "$form" | awk -F'|' '{print $1}')
        amount_earned=$(echo "$form" | awk -F'|' '{print $2}')
        amount_spent=$(echo "$form" | awk -F'|' '{print $3}')

        # Check if the amount earned or amount spent is blank
        if [[ -z "$amount_earned" || -z "$amount_spent" ]]; then
            zenity --error --title="Error" --text="Amount earned and amount spent cannot be blank."
            continue
        # Check if the amount earned or amount spent is not a number
        elif ! is_number "$amount_earned" || ! is_number "$amount_spent"; then
            zenity --error --title="Error" --text="Amount earned and amount spent must be numeric values."
            continue
        fi
        break
    done

    # Calculate amount saved
    amount_saved=$(echo "$amount_earned - $amount_spent" | bc)

    # Save the data to the SQLite database
    cmd="sqlite3 mydatabase.db  \"BEGIN TRANSACTION; INSERT INTO saving (date, amount_earned, amount_spent, amount_saved) VALUES ('$date', $amount_earned, $amount_spent, $amount_saved); COMMIT;\""
    eval "$cmd"

    zenity --info --title="Saving Entry" --text="Data saved successfully."
}

function calculate_total_amount_saved() {
    # Function to calculate the total amount saved

    # Execute the SQL query to calculate the sum of amount_saved
    cmd="sqlite3 mydatabase.db 'SELECT SUM(amount_saved) FROM saving;'"
    total_amount_saved=$(eval "$cmd")

    # Check if the total amount saved is negative
    if (( $(echo "$total_amount_saved < 0" | bc -l) )); then
        # If negative, convert it to positive and display as "Amount Lost"
        total_amount_saved=$(echo "$total_amount_saved * -1" | bc)
        zenity --info --title="Total Amount lost" --text="Amount Lost: $total_amount_saved" --ok-label="Back"
    else
        # If positive or zero, display as "Amount Saved"
        zenity --info --title="Total Amount Saved" --text="Amount Saved: $total_amount_saved" --ok-label="Back"
    fi
}

function view_by_date() {
    # Function to view sum of amount_saved by date

    # Prompt the user to choose a date from a calendar
    selected_date=$(zenity --calendar --title="Select Date" --text="Choose a date:" --date-format="%d/%m/%y" --cancel-label="Back")

    if [[ -z "$selected_date" ]]; then
        return
    fi

    # Execute the SQL query to calculate the sum of amount_saved for the selected date
    cmd="sqlite3 mydatabase.db \"SELECT SUM(amount_saved) FROM saving WHERE date='$selected_date';\""
    amount_saved=$(eval "$cmd")

    # Check if the total amount saved is negative
    if (( $(echo "$amount_saved < 0" | bc -l) )); then
        # If negative, convert it to positive and display as "Amount Lost"
        amount_saved=$(echo "$amount_saved * -1" | bc)
        zenity --info --title="Amount lost" --text="Amount Lost: $amount_saved" --ok-label="Back"
    else
        # If positive or zero, display as "Amount Saved"
        zenity --info --title="Amount Saved for $selected_date" --text="Amount Saved: $amount_saved" --ok-label="Back"
    fi
}

function get_user_choice() {
    # Function to display the options available to the user

    while true; do
        # Display a list of options using Zenity dialog
        choice=$(zenity --list \
            --title="Savings Tracker" \
            --column="Options" \
            --text="Choose an option:" \
            "Add Saving Entry" \
            "View Total Amount Saved" \
            "Saving made on a specific date" --cancel-label="Return to main menu")

        if [ $? -ne 0 ]; then
            return
        fi

        case $choice in
            "Add Saving Entry")
                get_user_input
            ;;
            "View Total Amount Saved")
                calculate_total_amount_saved
            ;;
            "Saving made on a specific date")
                view_by_date
            ;;
            *)
                zenity --warning --title "Menu Item" --text "Please make a choice"
            ;;
        esac
    done
}

get_user_choice
