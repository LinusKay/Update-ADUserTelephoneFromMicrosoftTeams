# Update-ADUserTelephoneFromMicrosoftTeams

Microsoft does not have a way to automatically synchronise Microsoft Teams numbers with Active Directory.

This script grabs a list of all users with Teams mobile numbers, finds the matching AD users, and updates the telephoneNumber attribute with their Teams number. 
There is also a single user version provided.

## Pre-requisites

- Requires the following modules:
  - ActiveDirectory
  - MicrosoftTeams
- An account with Active Directory admin access
- A Microsoft 365 user with access to manage users (Input on run)
- Distinguished name of an organisational unit containing the users to update, entered into the **searchBase** variable. 
