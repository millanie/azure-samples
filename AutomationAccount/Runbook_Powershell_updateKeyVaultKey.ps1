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

    # Target Date 
    $Today=Get-Date
    $TargetDate=$Today.AddYears(1)
    $ExpirePolicyDays=7

    # Update the expiration date
    $VaultList=Get-AzKeyVault
    foreach ($vault in $VaultList){
      $keyList=Get-AzKeyVaultKey -VaultName $vault.VaultName | Where-Object {($_.Expires - $today).Days -lt $ExpirePolicyDays}
  
      foreach ($key in $keyList){
        # Extend the expiration date of key
        $msg = " ### UPDATE KEY "+$key.Name+" IN THE VAULT "+$vault.VaultName
        Write-Output $msg
        #Update-AzKeyVaultKey -VaultName $vault.VaultName -Name $key.Name -Expires $TargetDate

      }
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
