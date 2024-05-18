<#
  .Description 
   Custom Detection script for checking install of Bitlocker-TPMPin script   
.NOTES
    Author:       Raman Lodhi
    Created:      18-May-2024
    Last Updated: 18-May-2024
    Version:      1.0
    Email:        Ramanlodhiddun@gmail.com
    Website:      ramanlodhi.com
#>

   $KeyProtectorType = (Get-BitLockerVolume -MountPoint C:).KeyProtector.KeyProtectorType

IF($KeyProtectorType -contains "TPM"){

  Write-Output "TPM PIN exists"
  Exist 0
}

Else{

Write-Output "TPM PIN Does not exists"

Exit 1

}