workflow KeyRorationSample
{
    Param
    (
        [Parameter (Mandatory= $true)]
        [String] $VaultName,
        [Parameter (Mandatory= $true)]
        [String] $rgName
    )
    $connectionName = "AzureRunAsConnection"

    try
    {
        # Get the connection "AzureRunAsConnection "
        $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName
        "Logging in to Azure..."
        $connectionResult =  Connect-AzAccount -Tenant $servicePrincipalConnection.TenantID `
                             -ApplicationId $servicePrincipalConnection.ApplicationID   `
                             -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint `
                             -Subscription $servicePrincipalConnection.subscriptionId `
                             -ServicePrincipal
        "Logged in."
        
        # Get all keys in the input KeyVault
        $Vault=Get-AzKeyVault -Name $VaultName -ResourceGroupName $rgName
        $Keys=Get-AzKeyVaultKey -VaultName $vault.VaultName

        foreach ($key in $Keys){
            $keyInfo=Get-AzKeyVaultKey -VaultName $key.VaultName -Name $key.Name
            "Current Version of "+$key.Name+" : "+$keyInfo.Version
            $newVersion=Add-AzKeyVaultKey -VaultName $key.VaultName -Name $key.Name -Destination "Software"
            "Current Version of "+$key.Name+" : "+$newVersion.Version
        }
    }
    catch {
        if (!$servicePrincipalConnection)
        {
            $ErrorMessage = "Connection $connectionName not found."
            throw $ErrorMessage
        } else{
            Write-Error -Message $_.Exception
            throw $_.Exception
        }
    }
}
