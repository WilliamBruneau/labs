# Purpose: Install the GPO that allows windomain\vagrant to RDP

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Importing the GPO to allow windomain/vagrant to RDP..."
# Fix generic GPO using the current domain SID
$DomainSID = (Get-ADDomain).DomainSid.Value
gci -r -Path c:\vagrant\resources\GPO\rdp_users\ | foreach-object {
  if ( -not $_.PSIsContainer ) {
    $a = $_.FullName;
    $b = $a -replace 'c:\\vagrant\\resources\\GPO\\rdp_users','c:\tmp\rdp_users'
    New-Item -Path $b -Type file -Force | Out-Null
    gc $a | foreach-object {
      $_ -replace "S-1-5-21-2442050065-1280348291-2767644839",$DomainSID
    }  | set-content $b
  }
}
Import-GPO -BackupGpoName 'Allow Domain Users RDP' -Path 'c:\tmp\rdp_users\' -TargetName 'Allow Domain Users RDP' -CreateIfNeeded
del -Force -Recurse 'c:\tmp\rdp_users\'

$OU = "ou=Workstations,dc=windomain,dc=local"
$gPLinks = $null
$gPLinks = Get-ADOrganizationalUnit -Identity $OU -Properties name,distinguishedName, gPLink, gPOptions
$GPO = Get-GPO -Name 'Allow Domain Users RDP'
If ($gPLinks.LinkedGroupPolicyObjects -notcontains $gpo.path)
{
  New-GPLink -Name 'Allow Domain Users RDP' -Target $OU -Enforced yes
}
else
{
  Write-Host "Allow Domain Users RDP GPO was already linked at $OU. Moving On."
}
$OU = "ou=Servers,dc=windomain,dc=local"
$gPLinks = $null
$gPLinks = Get-ADOrganizationalUnit -Identity $OU -Properties name,distinguishedName, gPLink, gPOptions
$GPO = Get-GPO -Name 'Allow Domain Users RDP'
If ($gPLinks.LinkedGroupPolicyObjects -notcontains $gpo.path)
{
    New-GPLink -Name 'Allow Domain Users RDP' -Target $OU -Enforced yes
}
else
{
  Write-Host "Allow Domain Users RDP GPO was already linked at $OU. Moving On."
}
gpupdate /force
