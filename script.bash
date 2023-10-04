#!/bin/bash

# Create a temporary dialogrc file with the desired configurations
DIALOGRC_TEMP=$(mktemp)
echo "screen_color = (black, black, off)" > $DIALOGRC_TEMP

# Use the temporary dialogrc for color configuration
export DIALOGRC=$DIALOGRC_TEMP

# Message text
message="You are accessing an information system that is provided for use to the United States government and other customers. Unauthorized use of the information system is prohibited and may be subject to criminal and civil penalties. Information system usage may be monitored, recorded, and subject to audit to maintain system security and availability, and to ensure authorized usage. Any evidence of possible violations of authorized use or applicable laws may be turned over to law enforcement. Your use of the information system indicates consent to these terms, including such monitoring and recording."

dialog --title "WARNING NOTICE" \
       --backtitle "WARNING NOTICE" \
       --yes-label "Accept" \
       --no-label "Reject" \
       --yesno "$message" 20 60

# Capture the status. "0" means YES ("Accept") and "1" means NO ("Reject")
response=$?

# Remove the temporary dialogrc file
rm -f $DIALOGRC_TEMP

if [ $response -eq 1 ]; then
        session_id=$(loginctl | grep "$USER" | awk '{print $1}')
        loginctl terminate-session $session_id
fi

# Clear the screen after closing the dialog
clear
