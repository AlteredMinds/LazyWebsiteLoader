# LOAD CONFIG
$configPath = Join-Path -Path $PSScriptRoot -ChildPath "webloader_config.json"
$configExists = Test-Path $configPath
if (!$configExists)
{
    Read-Host 'Missing Configuration file. Is "webloader_config.json" in the script directory?'
    return
}

try
{
    $configData = Get-Content -Raw -Path $configPath | ConvertFrom-Json
    $urls = $configData.urls
    $classes = foreach ($class in $configData.classes) {
        [PSCustomObject]@{
            Name  = $class.Name
            Room  = $class.Room
            URLs  = $class.URLs | ForEach-Object { $urls.$_ }
            Days  = $class.Days
            Times = $class.Times
        }
    }
}
catch
{
    Write-Host 'Failed to load configuration' -ForegroundColor Yellow
    Write-Host 'Configuration file is improperly formatted. Ensure that "webloader_config.json" is in the proper JSON format.'
    Write-Host ''
    Read-Host 'Press Enter to abort'
    return
}

#TASK SCHEDULE
$taskName = "Start Websites at Login"
$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $taskName }
if(!$taskExists) 
{
    if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) 
    {
        if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) 
        {
            $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
            Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
            Exit
        }
    }
    $args = '-command ' + $MyInvocation.MyCommand.Path
    $action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument $args
    $trigger = New-ScheduledTaskTrigger -AtLogOn
    try
    {
        Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger *> $null
        Read-Host 'A new scheduled task was created! Your websites will now load at login. Dont forget to modify the script to match your schedule and needs. Press ENTER to continue'
    }
    catch
    {
        Read-Host 'Failed to create a new scheduled task. Press ENTER to continue'
    }
}

function Verify-Class
{
    param (
        [Parameter(Mandatory=$true)]
        [string[]]$_days,
        
        [Parameter(Mandatory=$true)]
        [float[]]$_times
    )

    $timeMod = 0 #Debug variable
    $currentDay = (Get-Date).DayOfWeek #'Monday'
    $currentTime = [float](((Get-Date).Hour + $timeMod) + (Get-Date).Minute * 0.01)
    if ($_days -contains $currentDay)
    {
        if ($currentTime -ge $_times[0] -and $currentTime -lt $_times[1])
        {
            return $true     
        }
    }  
    return $false
}

Write-Host 'Initiating boot sequence......'
Start-Sleep -Milliseconds 200
foreach ($class In $classes)
{
    Write-Host "> Scanning space and time for" $class.Name
    Start-Sleep -Milliseconds 100
    $isCurrentClass = Verify-Class -_days $class.Days -_times $class.Times
    if ($isCurrentClass)
    {
        Write-Host $class.Name 'found in Sector' $class.Room
        Write-Host 'Starting loading sequence.....'
        Start-Sleep -Milliseconds 100
        foreach ($website In $class.URLs)
        {
            $newrl = $website -replace '^https?://([^/]+).*', '$1'
            $ip = [System.Net.Dns]::GetHostAddresses($newrl)[0].IPAddressToString;
            $refNum = ""
            for ($i = 0; $i -lt 14; $i++)
            {
                $refNum = $refNum + [int](Get-Random -Minimum 0 -Maximum 9)
            }
            Write-Host "Opening portal to" $newrl
            Write-Host " Link established via" $ip "Ref#$refNum"
            Start-Process $website
            Start-Sleep -Milliseconds 100
        }
        Write-Host "Loading sequence Complete." 
        return
    }    
}
Write-Host "Aborting... No classes found. Try again later or modify the script configuration.."
