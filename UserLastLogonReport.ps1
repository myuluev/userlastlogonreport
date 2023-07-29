# Function to convert LastLogonTimestamp to readable date format
function Convert-LargeIntegerToDate {
    param([int64]$largeInt)

    if ($largeInt -eq 0) {
        return "Never logged on"
    }
    return [datetime]::FromFileTime($largeInt)
}

# Get all user accounts from Active Directory
$users = Get-ADUser -Filter * -Properties LastLogonTimestamp, SamAccountName

# Create an array to store the report data
$report = @()

# Loop through each user and extract necessary information
foreach ($user in $users) {
    $lastLogonDate = Convert-LargeIntegerToDate $user.LastLogonTimestamp
    $reportEntry = [PSCustomObject]@{
        UserName = $user.SamAccountName
        LastLogon = $lastLogonDate
    }
    $report += $reportEntry
}

# Display the report
$report | Format-Table -AutoSize
