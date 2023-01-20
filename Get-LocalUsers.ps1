<#
.SYNOPSIS
    Change Local User Password

.DESCRIPTION
    This script handles printing out local users on the machine, adds new local users, disables local user accounts and updates / creates new passwords for local users:
        1. Prints out Local Users on this PC
        2. Adds a new user to the local users accounts
        3. Update users password
        4. Disables a users account
        5. Exits the script

.INPUTS
    None

.OUTPUTS
    Outputs the selected option to the screen

.EXAMPLE
PS>.\promts.ps1

.NOTES
    Author: Avi Avila
    Date: 1/18/23
    v1.2.0
#>

function textTitle {    
Write-Host  "  ____      _        _                    _ _   _                   "
Write-Host  " / ___| ___| |_     | |    ___   ___ __ _| | | | |___  ___ _ __ ___ "
Write-Host  "| |  _ / _ \ __|____| |   / _ \ / __/ _`` | | | | / __|/ _ \ '__/ __|"
Write-Host  "| |_| |  __/ ||_____| |__| (_) | (_| (_| | | |_| \__ \  __/ |  \__ \"
Write-Host  " \____|\___|\__|    |_____\___/ \___\__,_|_|\___/|___/\___|_|  |___/"
}

# Define a function for the menu and user input
function Get-UserInput {
    <#
    .SYNOPSIS
        Function to display meanu and collect user input.
    .DESCRIPTION
        This function uses a StringBuilder to build and display the menu
        that is prsented to the user. It then returns the result of the
        Read-Host command.
    #>
    
    $menu = New-Object -TypeName System.Text.StringBuilder
    [void]$menu.AppendLine("`n  .........Local Users.......... ")
    [void]$menu.AppendLine(" _________________________________")
    [void]$menu.AppendLine("|                                 |")
    [void]$menu.AppendLine("| 1. Get Local Users              |")
    [void]$menu.AppendLine("| 2. Add New User                 |")
    [void]$menu.AppendLine("| 3. Update User Password         |")
    [void]$menu.AppendLine("| 4. Make User Inactive           |")
    [void]$menu.AppendLine("| 5. Exit Script                  |")
    [void]$menu.AppendLine("|_________________________________|")

    Write-Host -ForegroundColor Cyan $menu.ToString()
    return $(Write-Host -ForegroundColor Cyan ">> Select a Command 1 - 5`n"; Read-Host)
}

function getLocalUsers {
        <#
    .SYNOPSIS
        Outputs LocalUsers
    .DESCRIPTION
        A simple function used to send print out a list of localusers found on the device
    #>

    Clear-Host
    Write-Host -ForegroundColor Yellow $userList
    Write-Host -ForegroundColor Cyan "`nLast Option Ran:"$userInput
    Write-Host -ForegroundColor Cyan "Listed Local Users on this PC.....Complete"
}

function addLocalUser {
        <#
    .SYNOPSIS
        Add a new localuser to the device
    .DESCRIPTION
        This function that adds a new local user and set the password for the account
    #>

    Clear-Host
    Write-Host -ForegroundColor Cyan "Enter Account Username (i.e. jsmith | john.smith | John | Lauren | lsmith | lauren.smith | etc |" 
    $getAccountName = Read-Host

    $userExists = $false

    foreach ($user in $localUsers) {
        if ($user.Name -eq $getAccountName) {
            $userExists = $true
            break
        }
    }

    if ($userExists) {
        Write-Host -ForegroundColor Yellow "User $getAccountName already exists, please press 2 again and try again."

    } else {
            Write-Host -ForegroundColor Cyan "Enter New Persons Full Name of the new user $getAccountName"
            $getFullName =  Read-Host

            Write-Host -ForegroundColor Cyan "Enter Account Description i.e: Account for Manager / Tech / Dr. / Front Desk Receptionist, etc." 
            $getDescription = Read-Host 

            Write-Host -ForegroundColor Cyan "Enter New Password Greater than 10 Characters, at least 1 uppercase letter and at least 1 symbol" 
            $getPassword = Read-Host -AsSecureString
            $pwIntPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPassword)
            $pwInPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($pwIntPtr) 
                         [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($pwIntPtr)

            if (((($pwInPlain).Length) -ge 10) -and ($pwInPlain -match '[A-Z]') -and ($pwInPlain -match '[!@#$%^&*(),.?":{}|<>]')) {
                Write-Host -ForegroundColor Cyan "Your password is strong"
                Pause

                New-LocalUser $getAccountName -Password $getPassword -FullName $getFullName -Description $getDescription
                Clear-Host
                Write-Host -ForegroundColor Cyan "Last Option Ran: $userInput Add New User"
                Write-Host -ForegroundColor Cyan "Created New account for $getFullName.....Complete"
            } else {

                Write-Host -ForegroundColor Yellow "The password you enter is too weak. Please select 2 and try again"
            }
    }
}

function resetPassword {
        <#
    .SYNOPSIS
        Function to reset localuser password
    .DESCRIPTION
        This function allows the admin to reset a localusers password
    #>

    Clear-Host
    Write-Host -ForegroundColor Yellow $userList
    Write-Host -ForegroundColor Cyan "Enter the Username you wish to update / change"
    $username = Read-Host 

    Write-Host -ForegroundColor Cyan "Enter New Password Greater than 10 Characters, at least 1 uppercase letter and at least 1 symbol" 
    $newPassword = Read-Host -AsSecureString
    $pwIntPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPassword)
    $pwInPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($pwIntPtr) 
                 [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($pwIntPtr)
    

    if (((($pwInPlain).Length) -ge 10) -and ($pwInPlain -match '[A-Z]') -and ($pwInPlain -match '[!@#$%^&*(),.?":{}|<>]')) {
        Write-Host -ForegroundColor Cyan "Your password is strong"
        Set-LocalUser $username -Password $newPassword 
        Pause

        Clear-Host
        Write-Host -ForegroundColor Cyan "Last Option Ran: $userInput Update User Password"
        Write-Host -ForegroundColor Cyan "Updated Password for $username.....Complete"
    } else {
        Write-Host -ForegroundColor Yellow "The password you enter is too weak. Please select 3 and try again"
    }    
}

function disableUser {
        <#
    .SYNOPSIS
        Function to disable localuser accounts
    .DESCRIPTION
        This function allows the admin to disable localuser accounts
    #>

    Clear-Host
    Write-Host -ForegroundColor Yellow $userList
    $disableUser = Read-Host "`nEnter the Username you wish to Disable the account for"
    Disable-LocalUser -Name $disableUser
    Clear-Host
    Write-Host -ForegroundColor Cyan "Last Option Ran: $userInput Make User Inactive"
    Write-Host -ForegroundColor Red "Disabled User $disableUser.....Complete"
}

# Varable to hold User Input
$userInput = 0

#Try Catch Block
try 
{
    
    # Start Loop / Menu Here
    while ($userInput -ne 5)
     {
        
        textTitle
        
        # Prompts the menu and gets the users input
        $userInput = Get-UserInput

        # Gets the local users and stores them in the array variable
        $localUsers = Get-LocalUser

        # Takes an array and adds User: [] to help define each user
        $userList = $localUsers | ForEach-Object {"User-->[$_]"}
        
        # Switch case statment that runs on the input from the user
        switch ($userInput) 
        {
            # Option 1: Displays all accounts on the local machine in yellow
            1 { 
                getLocalUsers
            }

            # Option 2: Creates a New Local Account and set password
            2 { 
                addLocalUser
            }

            # Option 3: Update Password for a User
            3 { 
                resetPassword
            }

            # Option 4: Disables an account for an employee who no longer works in the company
            4 { 
                disableUser
            }

            # Option 5: Exit Script
            5 { 
                Clear-Host
                Write-Host -ForegroundColor Cyan "Thank you and Have a Nice Day`n" 
            }

            # If user tries to enter any other character, it will ask the user to select the correct numbers only
            Default {
                Clear-Host 
                Write-Host -ForegroundColor Red -BackgroundColor Yellow "Please Select Numbers 1 - 5 Only" 
            }
        }
    }
}
Catch [System.OutOfMemoryException] 
    # To handle a specific error
    {
        Write-Host -BackgroundColor Red -ForegroundColor Yellow "An Memory Error Has Occured"
        Write-Host -ForegroundColor Red -BackgroundColor Yellow "$_"
    }
Catch
    # To handle any other error
    {
        Write-Host -BackgroundColor Red -ForegroundColor Yellow "An unhandled Execption has Occurred"
        Write-Host -ForegroundColor Red -BackgroundColor Yellow "$_"
    }