param( 
	[Parameter(Mandatory=$true)]
		[string] $email    
)

$dl = Get-AutomationVariable -Name "dlall"
$org = Get-AutomationVariable -Name "org"

Connect-ExchangeOnline -ManagedIdentity -Organization $org

$loopCounter = 0
While (1)
{
   If ($loopCounter -gt 20) {
      Return "timeout" # We waited too long, exit script
   }

   If (Get-Mailbox -Identity $email) {
      Break # User is there, exit the loop and continue
   }

   $loopCounter1++
   Start-Sleep -Seconds 10 # Wait to try again
} 


Add-DistributionGroupMember -Identity $dl -Member $email
