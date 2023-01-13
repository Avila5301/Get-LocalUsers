# Get-LocalUsers

Created this script to help a business add / disable and update local user on their Windows Home machine which they do not have an IT person to help
manage their computers or accounts.

Local business needed a way for a central person or manager to update other employee's accounts or to disable them when they were no longer
employeed. 

With the script, they are able to view local user accounts, add a new user, change their passwords or disable an account.

I did not add a way to remove / delete an account for the purpose of keeping former employee's data intact in case they every came back or needed any files from 
their local profile.


# How To / How to Use

The best way to run this script is to create a shortcut of the file and under the Shortcut tab, click on Advanced
and select the checkbox Run as Administrator and click ok

Place this in the Target so the file will run as a powershell exe. See example below:

`powershell.exe -command "& 'C:\A path with spaces\MyScript.ps1'"`

If you are a standard user, it will prompt you for admin creds and then launch the script
