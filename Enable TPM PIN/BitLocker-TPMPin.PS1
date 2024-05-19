<#
.DESCRIPTION
 The Script takes TPM PIN as input from user and enables TPM PIN on startup. This script also makes sure that 
 Operating system drive is already encrypted before asking the user for an input.

.PARAMETER [ParameterName]
    None

.EXAMPLE
  Push this script from Intune to the users devcices or use a task scheduler

.NOTES
    Author:       Raman Lodhi
    Created:      16-May-2024
    Last Updated: 18-May-2024
    Version:      1.0
    Email:        Ramanlodhiddun@gmail.com
    Website:      ramanlodhi.com
#>


# Main script logic

.\ServiceUI.exe -process:Explorer.exe "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -WindowStyle Hidden -Ex bypass -file "$PSScriptRoot\Pinform.ps1"

$userInput = Get-Content -Path "$Env:PUBLIC\input.txt"

$SecureString = ConvertTo-SecureString $userInput -AsPlainText -Force

Add-BitLockerKeyProtector -MountPoint "C:" -Pin $SecureString -TPMandPinProtector

Remove-Item -Path "$Env:PUBLIC\input.txt" -Force

New-Item -Path New-Item -Path "HKLM:\Software\Microsoft\Windows" -Name TPMStartupPIN
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\TPMStartupPIN" -Name Enabled -PropertyType string