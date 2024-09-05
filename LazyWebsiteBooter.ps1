<#
Script Name: Website Startup
Author: Christopher Bates
Date: 2024-03-07
Description: This PowerShell script automates opening websites used in class based on the current day of the week. It defines an array of objects containing website URLs along with the days they are typically accessed. The script then checks the current day of the week and opens the corresponding websites if they are scheduled for that day.
Version: 1.0
Contact: cb0988836@otc.edu
#>



<# Array of objects containing websites used in class along with their properties.

To customize the list of websites:
1. Update the "Name" property with the website's name.
2. Update the "URL" property with the website's URL.
3. Update the "Days" property with the days you typically access the website.

Add new objects to include additional websites or remove objects to exclude websites that are not needed. #>

$websites = @(
    [PSCustomObject]@{
        Name = "Blank"
        URL = "https://"
        Days = @("Monday", "Tuesday", "Wednesday", "Thursday")
    },
    [PSCustomObject]@{
        Name = "My OTC"
        URL = "https://my.otc.edu/"
        Days = @("Monday", "Tuesday", "Wednesday", "Thursday")
    },
    [PSCustomObject]@{
        Name = "TestOut"
        URL = "https://labsimapp.testout.com/v6_0_583/index.html"
        Days = @("Monday", "Wednesday", "Thursday")
    },
    [PSCustomObject]@{
        Name = "Cisco NetAcademy"
        URL = "https://www.netacad.com/"
        Days = @("Tuesday", "Thursday")
    },
    [PSCustomObject]@{
        Name = "NetLab"
        URL = "https://netlab.otc.edu/"
        Days = @("Monday", "Wednesday")
    }
)



# The current day of the week stored as a variable
$dayOfWeek = (Get-Date).DayOfWeek

# Iterate through the websites array and open url if day of week is in the days array of the website object
foreach ($website In $websites)
{
    if ($website.Days -contains "Monday" -and $dayOfWeek -eq "Monday")
    {
        Start-Process $website.URL
        Start-Sleep -Milliseconds 500
    }
    elseif ($website.Days -contains "Tuesday" -and $dayOfWeek -eq "Tuesday")
    {
        Start-Process $website.URL
        Start-Sleep -Milliseconds 500
    }
    elseif ($website.Days -contains "Wednesday" -and $dayOfWeek -eq "Wednesday")
    {
        Start-Process $website.URL
        Start-Sleep -Milliseconds 500
    }
    elseif ($website.Days -contains "Thursday" -and $dayOfWeek -eq "Thursday")
    {
        Start-Process $website.URL
        Start-Sleep -Milliseconds 500
    }
    elseif ($website.Days -contains "Friday" -and $dayOfWeek -eq "Friday")
    {
        Start-Process $website.URL
    }
}