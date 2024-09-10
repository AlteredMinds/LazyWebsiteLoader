# Lazy Website Loader

This PowerShell script automates the process of launching specific websites based on the user's class schedule, ensuring the websites load at system login via a scheduled task. The script reads class and website configurations from a JSON file and attempts to open the relevant URLs during the specified days and times. 

## Features

- **Configurable Classes & Websites:** Reads configuration data from a `webloader_config.json` file, allowing easy customization for different classes and schedules.
- **Automated Task Scheduling:** Automatically creates a Windows scheduled task that launches the script and loads the websites at login.
- **Real-time Verification:** Checks the current day and time to verify if a class is in session, then launches associated URLs.
- **Logging and Feedback:** Provides interactive feedback and logs important steps during the execution.

## Requirements

- PowerShell
- Administrator privileges (for creating scheduled tasks)
- `webloader_config.json` file in the same directory as the script

## Setup Instructions

1. **Run the Script:**  
   Run the script, and it will prompt you to create a scheduled task if one doesn't already exist. This task will run the script automatically upon login.

2. **Modify the Schedule:**  
   You can edit the `webloader_config.json` file to match your current schedule and preferences.

## Troubleshooting

- **Configuration Issues:**  
   If the configuration file is missing or improperly formatted, the script will display an error and abort. Ensure the `webloader_config.json` file is in the correct directory and follows proper JSON formatting.

- **No Classes Found:**  
   If no class is found for the current time, the script will exit without opening any websites.  
