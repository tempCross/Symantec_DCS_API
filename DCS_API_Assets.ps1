### Script to obtain token to access UMC API 
### Must have valid ssl root.key to make API calls
### Run with following commandline: powershell.exe -ExecutionPolicy Bypass .\DCS_API_Assets.ps1
############################################################################################## 
$uri = "https://<UMC_server>:8443/umcservices/rest/v1.0/auth/token" 
$username = Read-Host -Prompt 'Enter your username'
$password = Read-Host -Prompt 'Enter your password' -assecurestring

$BSTR = `
[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password) 
$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

$body = @{username=$username; password=$PlainPassword;} | ConvertTo-Json
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$request = Invoke-RestMethod -Uri $uri -Method Post  -Body $body  -ContentType "application/json" 
$token = $request.tokenType +' '+$request.accessToken
#$token

while($true){

$uri_string = Read-Host -Prompt 'Please enter trailing URI for API access Ex."v1/sa/assets"'
$uri = "https://<UMC_server>:4443/sis-ui/api/$uri_string"

$headers = @{Authorization = $token }

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$response = Invoke-RestMethod -Uri $uri -Headers $headers -Body $params -Method GET -ContentType 'application/json'
#$response
$response | Select-Object -Property name, ipaddress, rid, osversion, ostype, securitygroupname, categoryname, protectionstatus, managername, scspversion, agentstatus, commhealth_d, uptime | Export-Csv ./PCI_Assets.csv -NoType
}
