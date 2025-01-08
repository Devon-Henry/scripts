# Connect to Azure account using the System/User assigned Identity (must provide appropriate permissions on automation account in specified resource group)
Connect-AzAccount -Identity

# Grabs Variable stored in azure automation account
$resourcegroup = Get-AutomationVariable -Name "avdresourcegrp"

# Get the resources that fit the criteria
$resources = Get-AzResource -ResourceGroupName $resourcegroup -ResourceType Microsoft.Compute/virtualMachines 

# Loop through each resource in $resources variable
foreach ($resrc in $resources) {

    # If the resource contains a tag key value run this if statement, otherwise do nothing
    if ($resrc.Tags.Keys -contains "ExcludeFromScaling") {

    # using the resource Id of the resource found to contain the key value specified, delete this tag
    Update-AzTag -ResourceId $resrc.ResourceId -Tag @{"ExcludeFromScaling"=$null} -Operation Delete
    
    }

}
