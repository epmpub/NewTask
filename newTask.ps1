# create test folder if not exists
if (!(Test-Path -Path "C:\test")) {
    New-Item -Path "C:\test" -ItemType "directory"
}

Copy-Item -Path .\fetchuri.ps1 -Destination "C:\test\fetchuri.ps1" -Force
Copy-Item -Path .\pingTest.cmd -Destination "C:\test\pingTest.cmd" -Force



# new a test to run file.ps1
$action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c powershell -ExecutionPolicy Bypass c:\test\fetchuri.ps1"
# run at login

# $trigger = New-ScheduledTaskTrigger -AtLogOn
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionDuration  (New-TimeSpan -Days 1)  -RepetitionInterval  (New-TimeSpan -Minutes 5)


$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
$principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount

$task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings -Principal $principal

# if exist task TestTask, delete it
if (Get-ScheduledTask -TaskName "TestTask" -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName "TestTask" -Confirm:$false
}

Register-ScheduledTask -TaskName "TestTask" -InputObject $task -Force
Start-ScheduledTask -TaskName "TestTask"

$action2 = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c c:\test\pingTest.cmd"
$trigger2 = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionDuration  (New-TimeSpan -Days 1)  -RepetitionInterval  (New-TimeSpan -Minutes 5)
$task2 = New-ScheduledTask -Action $action2 -Trigger $trigger2 -Settings $settings -Principal $principal

if (Get-ScheduledTask -TaskName "TestTask2" -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName "TestTask2" -Confirm:$false
}

Register-ScheduledTask -TaskName "TestTask2" -InputObject $task2 -Force
Start-ScheduledTask -TaskName "TestTask2"


