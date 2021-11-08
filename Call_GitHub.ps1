#Get the required params
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true,
    HelpMessage="Enter Token")]
  [String]$arg1,

  [Parameter(HelpMessage="Enter Username")]
  [String]$Username="ZoltanJu",

  [Parameter(HelpMessage="Enter Repo")]
  [String]$Repo="Scripts",

  [Parameter(Mandatory=$true,
    HelpMessage="Enter Filename")]
  [String]$arg2
)

$Token=$arg1
$FileName=$arg2

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$URI = "https://api.github.com/repos/$Username/$Repo/contents/$FileName"

$Headers = @{
    accept = "application/vnd.github.v3.raw"
    authorization = "Token " + $Token
}

Try 
{
    Write-Host "Starting powershell script $Filename from $Repo..." -ForegroundColor Yellow
    $Script = Invoke-RestMethod -Uri $URI -Headers $Headers
    Invoke-Expression $Script
} 
catch [System.Net.WebException] 
{
    Write-Host "Error connecting to $Filename. Please check your file name or repo name and try again." -ForegroundColor Red
}

Write-Host "Success. Now executing $Filename from $Repo." -ForegroundColor Green
