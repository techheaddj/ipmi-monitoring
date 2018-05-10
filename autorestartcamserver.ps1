#Gets the admin credentials for the IPMI connection
$cred = get-credential ADMIN

while ($true) {
    filter timestamp {"$(Get-Date -Format G): $_"}
    #checks to see if logfile exists
    $logName = "C:\vidlogs\$(get-date -f yyyy-MM-dd).txt"
    If (Test-Path -Path $logname) {
        #already exists
        Write-Output "$logname exists"
    } Else {
        Write-Output "$logname does NOT exist"
        #creates one with this content $text at top
        $text = "Starting log for Ubuntu Video Server"
        $text | Out-File $logName
    }
    filter timestamp {"$(Get-Date -Format G): $_"}
    
    #check status of server, which returns a true or false, replace with your own IP address
    if (Test-Connection 172.16.2.48) {
        #if true is returned, the server is up, so all clear displayed to console and
        #to log file
        write-output "All Clear" | timestamp
        write-output "All Clear" | timestamp >> $logName
        start-sleep -Seconds 600
    } else {
        #if false is returned, it will send an ipmi call to the onboard controller
        #which will initiate a power reset
        write-output "Rebooting" | timestamp
        write-output "Rebooting" | timestamp >> $logName
        Restart-PcsvDevice -TargetAddress "172.16.14.252" -Credential $cred -ManagementProtocol IPMI -Confirm:$false
        Start-Sleep -Seconds 300
    }
}