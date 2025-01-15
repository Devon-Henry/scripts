Param (
    [Parameter(Mandatory=$true)]
	    [string] $userId,
    [Parameter(Mandatory=$true)]
	    [string] $office,
    [Parameter(Mandatory=$true)]
	    [string] $license,
)

$officePrint = $office -replace ' ',''
$printGroup = $printPrefix + $officePrint

$license1 = Get-AutomationVariable -Name "license1"
$license1g = Get-AutomationVariable -Name "license1g"
$license2g = Get-AutomationVariable -Name "license2g"

Connect-MgGraph -Identity -NoWelcome

$print = Get-MgGroup -ConsistencyLevel eventual -Filter "startsWith(DisplayName, '$printGroup')"| Select-Object -Property Id
$printId = $print.Id

if ($license -eq $license1){
    $licenseG = Get-MgGroup -ConsistencyLevel eventual -Filter "startsWith(DisplayName, '$license1g')" | Select-Object -Property Id
    $licenseId = $licenseG.Id
}
else {
    $licenseG = Get-MgGroup -ConsistencyLevel eventual -Filter "startsWith(DisplayName, '$license2g')" | Select-Object -Property Id
    $licenseId = $licenseG.Id
}


New-MgGroupMember -GroupId $printId -DirectoryObjectId $userId
New-MgGroupMember -GroupId $licenseId -DirectoryObjectId $userId
