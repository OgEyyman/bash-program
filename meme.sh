#!/bin/bash

function display_image() {
    # Function to display the image at the current index

    # Array of image paths
    image_paths=(
        "/home/ayman/Desktop/coursework2/allfiles/meme1.jpeg"
        "/home/ayman/Desktop/coursework2/allfiles/meme2.jpeg"
        "/home/ayman/Desktop/coursework2/allfiles/meme3.jpeg"
    )

    # Total number of images
    total_images=${#image_paths[@]}

    # Variable to track the current image index
    current_image=0

    while true; do
        # Setting up the HTML content with an image path
        local image_path="${image_paths[$current_image]}"
        local html_content="<html><body><img src='file://$image_path' style='max-width: 100%; max-height: 100%;'></body></html>"

        # Displaying the image
        zenity --text-info --width=1000 --height=700 --title="Memes" --html \
            --filename=<(echo "$html_content") --ok-label="Next" --cancel-label="Return to menu" 2>/dev/null

        if [ $? -ne 0 ]; then
            return
        fi

        current_image=$((current_image + 1))

        # Loop back to the first image if we've reached the end
        if [ $current_image -ge $total_images ]; then
            current_image=0
        fi
    done
}

display_image
