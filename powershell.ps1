$filename = "$ENV:UserProfile\A55EA7.PedsPlus.BlackScreen." + (Get-Date -Format yyyy-M-d) + ".txt"
Write-Host "Please Desrcribe the Nature of the issue:"
Write-Host "1) Long Black Screen (5-10 Minutes)"
Write-Host "2) Slowness"
Write-Host "3) Persistant Blackscreen"
Write-Host "4) Profile Broken"
Write-Host "5) Office 365 Broken"
Write-Host "6) Sfax Broken"
Write-Host "7) Other"
$IssueNumber = Read-Host "Please Enter an option:"

    switch ( $IssueNumber )
    {
        0 { $result = '0'    }
        1 { $result = 'Long Black Screen (5-10 Minutes)'    }
        2 { $result = 'Slowness'    }
        3 { $result = 'Persistant Blackscreen'    }
        4 { $result = 'Profile Broken'    }
        5 { $result = 'Office 365 Broken'    }
        6 { $result = 'Sfax Broken'    }
        7 { $result = 'Other'    }
    }

    if ($result -eq '7') {
        $result = Read-Host "General Issue Description: Enter to Skip"
    }

    $AdditionalInformation = Read-Host "Additional Information: Enter to Skip"

$date=date
$whoami=whoami
$dom = $env:userdomain
$usr = $env:username
$FullName = ([adsi]"WinNT://$dom/$usr,user").fullname
$hostname=hostname
$gpresult=(gpresult /r)
$UserProcesses=(Get-Process | ? {$_.SI -eq (Get-Process -PID $PID).SessionId})
$SystemServices=(Get-Service | Where-Object {$_.Status -eq "Running"})

Write-Output 'Help Me Obi-Wan Kenobi!' | Out-File -Encoding "UTF8" $filename
$UserRequest = "Full Name: $FullName`nUser: $whoami`nHostname: `t`t`t$hostname `nDate: `t$date `nIssue Number: `t`t$result `nAdditional Information: `t`t$AdditionalInformation"
Write-Host "Your request:"
Write-Host $UserRequest
$UserRequest = "User: `t`t`t`t$whoami`nHostname: `t`t`t$hostname `nDate: `t`t`t`t$date `nIssue Number: `t`t`t$result `nAdditional Information: `t`t$AdditionalInformation `nGPResults: `n#################################################################################################"
Write-Output $UserRequest | Out-File -Encoding "UTF8" $filename -Append
Write-Output $gpresult | Out-File -Encoding "UTF8" $filename -Append
$UserProcessesString = "`nUser Processes: `n#################################################################################################"
Write-Output $UserProcessesString | Out-File -Encoding "UTF8" $filename -Append
Write-Output $UserProcesses | Out-File -Encoding "UTF8" $filename -Append
$SystemServicesString = "`nSystem Services: `n#################################################################################################"
Write-Output $SystemServicesString | Out-File -Encoding "UTF8" $filename -Append
Write-Output $SystemServices | Out-File -Encoding "UTF8" $filename -Append

## Prepare server for Mail
Write-Host "Resolving Prominic.NET MX Records"
$prominicDomain = (Resolve-DnsName -Name prominic.net -Type MX).NameExchange

##Send Message
Write-Host "E-Mailing Prominic.NET Staff JSON File using domino-42.prominic.net"
$FileContents = (Get-Content $filename) -join "`n"
Send-MailMessage -Subject "Help Me Obi-Wan Kenobi!" -To mark.gilbert@prominic.net -From "rds_user_counts@prominic.cloud" -Body "$FileContents" -SmtpServer domino-42.prominic.net -Port 25
$IssueDescription = Read-Host "Press enter to send"
#
