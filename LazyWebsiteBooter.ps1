##############################################################################################################
##################################### S T A R T   O F   C O N F I G ##########################################


# Website variables you use for classes including the website urls. Remove or create variables to fit your needs.

$otc = "https://my.otc.edu/"
$netlab = "https://netlab.otc.edu/"
$netacad = "https://www.netacad.com/"
$testout = "https://labsimapp.testout.com/v6_0_583/index.html"
$gitHub = "https://github.com/AlteredMinds"


$classes = @(
#########################################################################################################################
# List of your classes. Each object represents a class and includes the following properties:                           #
#  Name - The name of the class.                                                                                        #
#  URLs - The websites you want to load for the class.                                                                  #
#  Days - The days that you have class.                                                                                 #
#  Times - The start and end times of class. Represented as a decimal in 24hr format (hour.min). Ex. (11.00, 13.05) is  #
#          equal to 11:00am - 1:05pm.                                                                                   #
#                                                                                                                       #
#  Create or remove objects to match your number of classes. Then, customize the properties for each class.             #
#  NOTE: The last object cannot have a ',' at the end, objects preceding the last object must.                          #
#########################################################################################################################

    ###   CLASS 1    ###
    [PSCustomObject]@{
        Name = "THE LINUX OPERATING SYSTEM"
        URLs = @($otc, $testout, $netlab)
        Days = @("Monday", "Wednesday")
        Times = @(8.00, 10.30)
    },

    ###   CLASS 2   ###
    [PSCustomObject]@{
        Name = "FIREWALL ESSENTIALS"
        URLs = @($otc, $netlab)
        Days = @("Monday", "Wednesday")
        Times = @(13.00, 15.05)
    },

    ###   CLASS 3  ###
    [PSCustomObject]@{
        Name = "CCNAv7: SRWE"
        URLs = @($otc, $netacad, $netlab)
        Days = @("Monday", "Wednesday")
        Times = @(15.30, 23.03)
    }

####################################### E N D   O F   C O N F I G ############################################
##############################################################################################################
)

#variables for the current date and time
$dayOfWeek = (Get-Date).DayOfWeek
$time = [float]((Get-Date).Hour + (Get-Date).Minute * 0.01)


function CheckClass($_days, $_times)
{
    # Get the current day of the week
    $currentDay = (Get-Date).DayOfWeek.ToString()

    # Debug output to check the current day and the days array
    Write-Host "Current Day: $currentDay"
    Write-Host "Days Array: $($_days -join ', ')"

    # Ensure $_days is an array and handle it correctly
    if ($_days -is [Array] -and $_days -contains $currentDay)
    {
        # Output the current time and the time range being checked
        Write-Host "Current Time: $time"
        Write-Host "Class Time Range: $($_times[0]) to $($_times[1])"

        # Check if the current time is within the class time range
        if ($time -ge $_times[0] -and $time -lt $_times[1])
        {
            Write-Host "Class is currently ongoing."
            return $true     
        }
        else
        {
            Write-Host "Class time does not match."
        }
    }
    else
    {
        Write-Host "Current day is not a class day."
    }
    
    return $false
}


#logic beepboop oO
foreach ($class In $classes)
{
    $isCurrentClass = CheckClass($class.Days, $class.Times)
    if ($isCurrentClass)
    {
            Write-Host "Current class:" $class.Name
            foreach ($website In $class.URLs)
            {
                Write-Host "Starting" $website
                Start-Process $website
                Start-Sleep -Milliseconds 100
            }        

    }
}

#Creates a scheduled task to run this script at login if it doesnt exist
$taskName = "Start Websites at Login"
$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $taskName }

if(!$taskExists) 
{
    $args = '-command ' + $MyInvocation.MyCommand.Path
    $action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument $args
    $trigger = New-ScheduledTaskTrigger -AtLogOn
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger *> $null
    Write-Host 'Created new scheduled task! Your websites will now load at login.'
}
