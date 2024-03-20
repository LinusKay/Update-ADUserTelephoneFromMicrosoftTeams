# Script to synchronise AD user telephone numbers with Teams mobile numbers
#
# Script adapted by Linus Kay
# Based on script from: https://goziro.com/how-to-sync-microsoft-teams-phone-numbers-with-active-directory/

Import-Module ActiveDirectory
Import-Module MicrosoftTeams

# OU to retrieve users from
$searchBase = '[Organisational Unit DN]'
$user = 'user@domain.com'

# Log in with Microsoft admin account
Connect-MicrosoftTeams 

# Fetch all users with Teams numbers from Teams
$voiceUsers = Get-CsOnlineUser -Filter {EnterpriseVoiceEnabled -eq $True} | Select UserPrincipalName, LineUri

# Loop through all fetched users
# Retrieve the matching AD user
# Parse the Teams number value to trim excess text
# Set telephoneNumber attribute on AD user to Teams number
foreach ( $voiceUser in $voiceUsers ) 
{
    $upn = $voiceUser.UserPrincipalName
   
    if($upn -eq $user) {
    Write-Host $upn
 
        $adUserToUpdate = Get-ADUser -Filter "userPrincipalName -eq '$upn'" -SearchBase $searchBase
        if ($null -eq $adUserToUpdate)
        {
            Write-Host "WARNING: Could not update user $upn - user does not exist in local AD" -ForegroundColor Yellow
            continue
        }
        $phoneNumber = $voiceUser.LineUri.replace('tel:', '').split(';ext=')[0]
        Set-ADUser -Identity $adUserToUpdate.DistinguishedName -Replace @{telephoneNumber=$phoneNumber}
        Write-Host "Updated user $upn with phone number $phoneNumber"
    }
}