<#
.SYNOPSIS
    Change Local User Password

.DESCRIPTION
    This script demos the following:
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
    Date: 1/07/23
#>

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

# Varable to hold User Input
$userInput = 0

#Try Catch Block
try 
{
    
    # Start Loop / Menu Here
    while ($userInput -ne 5)
     {
         # Prompts the menu and gets the users input
        $userInput = Get-UserInput
        $localUsers = Get-LocalUser
        $arr = $localUsers | ForEach-Object {"User: [$_],"}
        
        # Switch case statment that runs on the input from the user
        switch ($userInput) 
        {
            # Option 1: Displays all accounts on the local machine in yellow
            1 { 
                Clear-Host
                Write-Host -ForegroundColor Yellow $arr
                Write-Host -ForegroundColor Cyan "Last Option Ran:"$userInput
                Write-Host -ForegroundColor Cyan "Listed Local Users on this PC.....Complete"
            }

            # Option 2: Creates a New Local Account and set password
            2 { 
                Clear-Host
                $getFullName = Write-Host "Enter New Persons Full Name"; Read-Host
                $getAccountName = Write-Host "Enter Account Username"; Read-Host
                $getDescription = Write-Host "Enter Account Description i.e: Manager, Tech, Dr. Front Desk, Receptionist, etc."; Read-Host 
                $getPassword = Write-Host "Enter New Password Greater than 10 Characters"; Read-Host -AsSecureString 
                New-LocalUser $getAccountName -Password $getPassword -FullName $getFullName -Description $getDescription
                
                Write-Host -ForegroundColor Cyan "Last Option Ran:"$userInput
                Write-Host -ForegroundColor Cyan "Created New account for $getFullName.....Complete"
            }

            # Option 3: Update Password for a User
            3 { 
                Clear-Host
                Write-Host -ForegroundColor Yellow $arr
                $username = Read-Host "Enter the Username you wish to update / change"
                $newPassword = Read-Host "Enter New Password Greater than 10 Characters" -AsSecureString
                Set-LocalUser $username -Password $newPassword
                Clear-Host
                Write-Host -ForegroundColor Cyan "Last Option Ran:"$userInput
                Write-Host -ForegroundColor Cyan "Updated Password for $username.....Complete"

            }

            # Option 4: Disables an account for an employee who no longer works in the company
            4 { 

                Clear-Host
                Write-Host -ForegroundColor Yellow $arr
                $disableUser = Read-Host "Enter the Username you wish to Disable the account for"
                Disable-LocalUser -Name $disableUser
                Clear-Host
                Write-Host -ForegroundColor Cyan "Last Option Ran:"$userInput
                Write-Host -ForegroundColor Red "Disabled User $disableUser.....Complete"
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
finally 
    {
        # Close any open resources
        # Runs before the scrips ends
        # Only included for completness of the Try Catch block and my reference
    }