# Get-LocalUsers

Created this script to help a business add / disable and update local user on their Windows Home machine which they do not have an IT person to help
manage their computers or accounts.

Local business needed a way for a central person or manager to update other employee's accounts or to disable them when they were no longer
employeed. 

With the script, they are able to view local user accounts, add a new user, change their passwords or disable an account.

I did not add a way to remove / delete an account for the purpose of keeping former employee's data intact in case they every came back or needed any files from 
their local profile.


# How to Use

The best way to run this script is to create a shortcut by right clicking and mousing over "Send To" and select Desktop. 
Then right click on the on on the shortcut and select / click on "Properties".

Place the following in front of the Target field / input field so the file will run as a Powershell.exe file:

`powershell.exe -command "& 'C:\A path with spaces\Get-LocalUser.ps1'"`

or

`powershell.exe -command "& 'C:\A-pathWithNoSpaces\Get-LocalUser.ps1'"`


Then, under the Shortcut tab, click on Advanced and select the checkbox "Run as Administrator" and click ok.

If you are a standard user, it will prompt you for admin creds and then launch the script
If you are an admin, it will prompt you and you can click on Yes

Dont forget to have your CurrentUser RemoteSigned for the ExecutionPolicy

To Check your current ExecutionPolicy enter:

`Get-ExecutionPolicy -List`

To Set your ExecutionPolicy to RemoteSigned enter:

`Set-ExecutionPolicy -ExecutionPlicy RemoteSigned -Scope CurrentUser`

You can replace CurrentUser with any of the the following:

* MachinePolicy
* UserPolicy
* Process
* CurrentUser
* LocalMachine