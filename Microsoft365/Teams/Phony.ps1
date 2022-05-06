#Install-Module MicrosoftTeams
#Install-Module Microsoft.Graph
 
#Import-Module ActiveDirectory
#Import-Module MicrosoftTeams
#Import-Module Graph
 
$mailAddress ="ChageThisMail@exemple.ch"
$phoneNb = " Add the phone here"
$ADSearchBase = "OU=Change,DC=This,DC=And,DC=This"
 
Connect-MicrosoftTeams #MFA mandatory
Connect-Graph -Scopes User.ReadWrite.All, Organization.Read.All
 
#ajoute lic. Téléphonie Teams Phone Standard
$TeamsPhoneLic = Get-MgSubscribedSku -All | Where SkuPartNumber -eq 'MCOEV'
Set-MgUserLicense -UserId $mailAddress -AddLicenses @{SkuId = $TeamsPhoneLic.SkuId} -RemoveLicenses @()
start-sleep -s 60
 
#Configure Teams phone
Set-CsUser -Identity $mailAddress -EnterpriseVoiceEnabled $true -HostedVoiceMail $true -OnPremLineURI "tel:$phoneNb"
Grant-CsOnlineVoiceRoutingPolicy -PolicyName "Appels monde" -Identity $mailAddress
 
#Set attribute Teams for SBC
$ADUser =  Get-ADUser -Filter {EmailAddress -eq $mailAddress} -SearchBase $ADSearchBase
Set-ADUser -Identity $ADUser -add @{"extensionattribute1"="Teams"}
 
 
#######
#Delete Teams Profile
#######
$mailAddress ="ChageThisMail@exemple.ch"
$ADSearchBase = "OU=Change,DC=This,DC=and,DC=that"
 
#Remove Phone attributes
Set-CsUser -Identity $mailAddress -EnterpriseVoiceEnabled $false -HostedVoiceMail $false -OnPremLineURI ""
 
#Remove Teams phone lic.
$TeamsPhoneLic = Get-MgSubscribedSku -All | Where SkuPartNumber -eq 'MCOEV'
Set-MgUserLicense -UserId $mailAddress -AddLicenses @() -RemoveLicenses @{SkuId = $TeamsPhoneLic.SkuId}
 
$ADUser = Get-ADUser -Filter {EmailAddress -eq $mailAddress} -SearchBase $ADSearchBase
