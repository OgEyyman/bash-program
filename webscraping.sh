#!/bin/bash

function weather_forecast() {
    # Function to webscrape and display weather forecast for today or for 7 days, as per user's choice.
    
    exit_flag=0

    while [ $exit_flag -eq 0 ]; do
        choice=$(zenity --list --title="Weather Forecast" --text="Select an option:" \
            --column="Choice" --column="Description" \
            "Today" "Weather Forecast for Today" \
            "7 Days" "Weather Forecast for 7 Days" --cancel-label="Return to main menu")
        
        if [ $? -ne 0 ]; then
            exit_flag=1
            continue
        fi

        case $choice in
            "Today")
                # Scrape the website and save the output to a file using curl command
                curl -s "http://metservice.intnet.mu/forecast-bulletin-englishmauritius.php" > output.html
                
                # Display the content of the file using Zenity
                zenity --text-info --title "Website Content" --filename="output.html" \
                    --html --width=1050 --height=1080 --cancel-label="Return to main menu" --ok-label="Back" 2>/dev/null
                
                if [ $? -ne 0 ]; then
                    exit_flag=1
                    break
                fi
                ;;
            "7 Days")
                # Scrape the website and save the output to a file
                curl -s "http://metservice.intnet.mu/probabilistic-forecast.php" > output.html
                
                # Display the content of the file using Zenity
                zenity --text-info --title "Website Content" --filename="output.html" \
                    --html --width=1050 --height=1080 --cancel-label="Return to main menu" --ok-label="Back" 2>/dev/null
                
                if [ $? -ne 0 ]; then
                    exit_flag=1
                    break
                fi
                ;;
            *)
                zenity --warning --text='<span font="Helvetica 20" foreground="red">Select an item</span>' --title="Warning"
                ;;
        esac
    done
}

function facts() {
    # Function to webscrape and display 100 facts from a website
    
    # Scrape the website and save the output to a file
    curl -s "https://www.makemegenius.com/factlist16.php" > output.html
    
    # Define the start and end tags to identify the desired content
    start_tag='<p style="color:#000; text-align:center; width:100%; font-size:20px; padding:15px 0px; font-weight:700;">Solar System Planets Space 100 Interesting Facts<\/p>'
    end_tag='<\/html>'
    
    # Find the line number where the start tag occurs in the output
    start_line=$(grep -n "$start_tag" output.html | cut -d ":" -f 1)
    
    # Extract the content starting from the line with the start tag and ending with the end tag
    content=$(tail -n +$start_line output.html | sed -n "/$end_tag/q;p")
    
    # Display the content using Zenity
    zenity --text-info --title "Website Content" --html --width=1200 --height=1080 --ok-label="Close" --filename <(echo "$content") 2>/dev/null
}

function mcq() {
    # Function to conduct a multiple-choice quiz on the solar system
    
    # Define the questions
    questions=("Question 1: Which planet is closest to the Sun?"
        "Question 2: Which planet is known as the Red Planet?"
        "Question 3: Which planet is the largest in our solar system?"
        "Question 4: Which planet has the most moons?"
        "Question 5: Which planet has rings around it?")
    
    # Define the choices for each question
    choices=("A. Venus" "B. Mercury" "C. Mars" "D. Earth"
        "A. Venus" "B. Mars" "C. Jupiter" "D. Saturn"
        "A. Earth" "B. Uranus" "C. Saturn" "D. Jupiter"
        "A. Saturn" "B. Jupiter" "C. Uranus" "D. Neptune"
        "A. Mars" "B. Venus" "C. Jupiter" "D. Saturn")
    
    # Define the correct answers
    correct_answers=("B. Mercury"
        "B. Mars"
        "D. Jupiter"
        "B. Jupiter"
        "D. Saturn")
    
    # Initialize variables for score and user's answers
    score=0
    user_answers=()
    
    # Loop through the questions
    for ((i=0; i<${#questions[@]}; i++)); do
        selected_option=""
        
        # Continue displaying the dialog until a valid selection is made
        while [[ -z "$selected_option" ]]; do
            selected_option=$(zenity --list \
                --title "Solar System Quiz" \
                --text "${questions[i]}" \
                --radiolist \
                --column "" --column "Option" \
                FALSE "${choices[$((i*4))]}" \
                FALSE "${choices[$((i*4+1))]}" \
                FALSE "${choices[$((i*4+2))]}" \
                FALSE "${choices[$((i*4+3))]}" \
                --cancel-label "Return" \
                --width=500 --height=250)
            
            if [[ $? -eq 1 ]]; then
                return
            fi
        done
        
        # Store the user's answer
        user_answers+=("$selected_option")
        
        # Check if the answer is correct
        if [[ "$selected_option" == "${correct_answers[i]}" ]]; then
            score=$((score + 1))
        fi
        
        # Check if it's the last question
        if [[ $i -eq 4 ]]; then
            # Display the user's score and provide feedback
            percentage=$((score * 100 / ${#questions[@]}))
            feedback="You answered $score out of ${#questions[@]} questions correctly.\nPercentage: $percentage%"
            zenity --info --title "Quiz Results" --text "$feedback"
        fi
    done
}
