
<# Take General Parameters from User #>
param([string] $ServerName=(Read-Host -prompt "Please Enter Server Name"),[string] $UserName=(Read-Host -prompt "Please Enter Your User Name"),[string] $Password=(Read-Host -prompt "Please Enter Your Password"))

<# Start Logging #>
Start-Transcript -Path "$(Get-Location)\log $(get-date -f "yyyy-MM-dd HHmm").txt" -Force

<# Build Credential Object #>
$SecurePassword=ConvertTo-SecureString -AsPlainText -Force -String $Password
$Credential=New-Object System.Management.Automation.PSCredential $UserName,$SecurePassword 


<# Enter into a Remote Session #>
$Session=Get-PSSession -ComputerName $ServerName -ErrorAction SilentlyContinue
If($Session.Name -eq $null)
{
    $Session = New-PSSession -ComputerName $ServerName -Authentication "Negotiate" -Credential $Credential 
}

Enter-PSSession $Session

<# Call Deploy Database #>
./DeployDatabase.ps1

Exit-PSSession
Remove-PSSession -ComputerName $ServerName

<# Stop Logging #>
Stop-Transcript