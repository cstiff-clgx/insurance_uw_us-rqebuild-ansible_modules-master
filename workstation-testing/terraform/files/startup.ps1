
$OutputFileLocation = "C:\Startup.log"

Function Write-VerboseLog {
    $Message = $args[0]
    Write-Verbose $Message
    Add-Content $OutputFileLocation "$Message"
}

Function setPassword {

    if (Test-Path -Path password_ran.log) {
        Write-VerboseLog "Password already changed..."
        return 1
    }
    Write-VerboseLog "Setting admin password"
    $DecodedText = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("${admin_password}"))
    New-LocalUser "admin" -AccountNeverExpires:$true -PasswordNeverExpires:$true -Password (ConvertTo-SecureString -AsPlainText -Force "$DecodedText") -FullName "Ansible Admin" -Description "Admin account for Ansible"
    Add-LocalGroupMember -Group "Administrators" -Member "admin"

    Write-VerboseLog "Done Setting admin password"
    New-item -itemtype file password_ran.log | Out-Null
}

setPassword
