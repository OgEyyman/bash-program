#!/bin/bash

function guess_number() {
    # Function to generate a random number and ask the user to guess it

    # Generate a random number between 1 and 100
    target=$((RANDOM % 100 + 1))

    while true; do
        guess=$(zenity --entry --title="Guess the Number" --text="Enter your guess (between 1 and 100):" \
            --width=300 --height=200 --cancel-label="Back")

        if [ $? -ne 0 ]; then
            return
        fi

        # Validate the input
        if [[ ! $guess =~ ^[0-9]+$ ]]; then
            zenity --error --title="Error" --text="Invalid input. Please enter a positive integer."
            continue
        fi

        # Compare the guess with the target number
        if (( guess < target )); then
            zenity --info --title="Result" --text="Too low! Try a higher number."
        elif (( guess > target )); then
            zenity --info --title="Result" --text="Too high! Try a lower number."
        else
            zenity --info --title="Congratulations!" --text="You guessed the correct number!" \
                --width=200 --height=100
            zenity --info --title="Game Over" --text="Thank you for playing Guess the Number!" \
                --width=200 --height=100

            break
        fi
    done
}

function rock_paper_scissors() {
    # Function to randomly choose among rock/paper/scissors and compare it to the user's choice to determine the winner

    while true; do
        # Display the dialog box to choose the move
        choice=$(zenity --list --title="Rock, Paper, Scissors" --text="Choose your move:" \
            --column="Move" Rock Paper Scissors --width=300 --height=200 --cancel-label="Back")

        if [ $? -ne 0 ]; then
            break
        fi

        if [[ -z "$choice" ]]; then
            zenity --error --title "Error" --text "No option selected. Please choose an option."
            continue
        fi

        # Assign the proper value to the variable of the user choice
        case $choice in
            Rock)
                user_choice="rock"
                ;;
            Paper)
                user_choice="paper"
                ;;
            Scissors)
                user_choice="scissors"
                ;;
        esac

        # Generate the computer's choice
        choices=("rock" "paper" "scissors")
        index=$((RANDOM % ${#choices[@]}))
        comp_choice=${choices[$index]}

        # Determine the winner
        if [[ $user_choice == $comp_choice ]]; then
            zenity --info --title="Result" --text="It's a tie!"
        elif [[ ($user_choice == "rock" && $comp_choice == "scissors") || \
               ($user_choice == "paper" && $comp_choice == "rock") || \
               ($user_choice == "scissors" && $comp_choice == "paper") ]]; then
            zenity --info --title="Result" --text="You win! $user_choice beats $comp_choice." --ok-label="Back"
        else
            zenity --info --title="Result" --text="You lose! $comp_choice beats $user_choice." --ok-label="Back"
        fi
    done
}

function game_selection_dialog() {
    # Function to display the dialog box for game selection and allow the user to choose which game to play

    while true; do
        response=$(zenity --list --title="Game Selection" --text="Choose a game to play:" \
            --column="Game" "Rock Paper Scissors" "Guess the Number" --cancel-label="Return to main menu" \
            --width=300 --height=200)

        if [ $? -ne 0 ]; then
            break
        fi

        if [[ -z "$response" ]]; then
            zenity --warning --title "Choice" --text "Please make a choice"
            continue
        fi

        # Call the respective function as per user's choice
        if [[ $response == "Rock Paper Scissors" ]]; then
            rock_paper_scissors
        elif [[ $response == "Guess the Number" ]]; then
            guess_number
        fi
    done
}

game_selection_dialog
