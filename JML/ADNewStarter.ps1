Param (
  [Parameter(Mandatory=$true)]
	    [string] $firstName,	
	[Parameter(Mandatory=$true)]
		[string] $lastName,
	[Parameter(Mandatory=$true)]
		[string] $office,
	[Parameter(Mandatory=$true)]
		[string] $title,
  [Parameter(Mandatory=$true)]
		[string] $department,
  [Parameter(Mandatory=$true)]
		[string] $license
)

$path = Get-AutomationVariable -Name "adpath"
$name = $firstName + ' ' + $lastName
$ou = "OU=" + $office + $path
$domain = Get-AutomationVariable -Name "domain"
$email = "$firstName.$lastName@$domain"

$uri = Get-AutomationVariable -Name "uri"
$password = Invoke-RestMethod $uri
 
$splat = @{
    GivenName = $firstName
    Surname = $lastName
    SamAccountName = "$firstName.$lastName"
    Name = $name
    Enabled = $True
    Path = $ou
    Department = $department
    Title = $title
    Email = $email
    AccountPassword = (ConvertTo-SecureString $password -AsPlainText -Force)
    DisplayName = $name
    Office = $office
    UserPrincipalName = $email

}

New-ADUser @splat

$objOut = [PSCustomObject]@{
    Password = $password
    Email = $email
}

Write-Output ( $objOut | ConvertTo-Json)
