Param (
  [Parameter(Mandatory=$true)]
	    [string] $firstName,	
	[Parameter(Mandatory=$true)]
		[string] $lastName
)

$name = $firstname + ' ' + $lastName

Connect-MgGraph -Identity -NoWelcome

$loopCounter = 0
While (1)
{
   If ($loopCounter -gt 20) {
      Return "timeout" # We waited too long, exit script
   }

   If (Get-MgUser -ConsistencyLevel eventual -Filter "startsWith(DisplayName, '$name')") {
      Break # User is there, exit the loop and continue
   }

   $loopCounter++
   Start-Sleep -Seconds 10 # Wait to try again
} 
