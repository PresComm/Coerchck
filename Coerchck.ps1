# Coerchck
# v. 0.1 - 10/08/2018
# by PresComm
# https://github.com/PresComm/Coerchck

#Trying to poll non-Windows machines results in nasty errors, so let's ignore them and move on when they pop up.
$ErrorActionPreference = 'SilentlyContinue'

#Main function
function execute-main {

show-intro
gather-params
scan-targets

#After the guts of this script do the heavy lifting, we'll output all of our results to a .TXT file.
echo $finaloutput | Out-File -filepath LocalAdmins.txt

}

#This function just echos some script, version, and author info.
function show-intro {

cls
echo "Coerchck"
echo "v. 0.1 - 10/08/2018"
echo "by PresComm"
echo "https://github.com/PresComm/Coerchck"
echo ""

}

#This function prompts the user to provide the network ID and CIDR mask of the network they wish to scan.
#The script then calculates the total number of IPs in that range (subtracting any network ID or broadcast IPs)
#and the first IP address. The string that will eventually grow into the final report is also initialized.
function gather-params {

$global:networkid = Read-Host -Prompt 'Enter network ID (in the format 192.168.1. complete with last decimal)'
$cidrmask = Read-Host -Prompt 'Enter CIDR mask (such as 24, 16, 8, etc.) NOTE: Only 24 (255.255.255.0) masks are currently accepted'
$cidrpower = (32 - $cidrmask)
$global:ipcount = [math]::pow( 2, $cidrpower ) - 2
$global:lastoctet = 1
$global:firstip = $networkid+$lastoctet
[string]$global:scanoutput = "Coerchck scan result report"
[string]$global:addline = "" | Out-String

}

#This function takes the user's input and performs the brunt of the script's work.
function scan-targets {

#Initialize a do...while loop to scan each IP until the IP count reaches zero.
do {

#Clear the error variable to prepare for error catching mechanisms.
$error.clear()

#This command calls the function that actually attempts to pull the local user list from the target IP.
try { [string]$currentoutput = get-localadmin $firstip }

#Catch any errors thrown by the above command. Specifically, non-Windows machines will throw RPC errors when polled.
catch { }

#If no error is thrown, this is executed. It stores the scanned IP as a variable, increments the target IP, decrements the IP count,
#and glues the output of the poll to the final output string.
if (!$error) {

[string]$scannedip = $firstip
$lastoctet = $lastoctet + 1 
$ipcount = $ipcount - 1
$firstip = $networkid+$lastoctet
$scanoutput = $scanoutput+$addline+$scannedip+$addline+$currentoutput

}

#If an error is thrown, this is executed. It stores the scanned IP as a variable, increments the target IP, and decrements the IP count.
#No operations are performed on the final output string.
else {

$lastoctet = $lastoctet + 1 
$ipcount = $ipcount - 1
$firstip = $networkid+$lastoctet

}

} while ($ipcount -gt 0)

#Once the loop has terminated, the output string that has been growing is tossed into a global variable for call by the main function.
[string]$global:finaloutput = $scanoutput

}

#This is the function that actually polls each target for the list of local administrators.
#Credit for this portion of the script (which actually inspired this entire script) goes to
#Paperclip on the Microsoft TechNet Gallery (https://gallery.technet.microsoft.com/scriptcenter/Get-remote-machine-members-bc5faa57).
#I contacted them and received approval before reusing their function.
function get-localadmin { 
param ($strcomputer) 
 
$admins = Gwmi win32_groupuser –computer $strcomputer  
$admins = $admins |? {$_.groupcomponent –like '*"Administrators"'} 
 
$admins |% { 
$_.partcomponent –match “.+Domain\=(.+)\,Name\=(.+)$” > $nul 
$matches[1].trim('"') + “\” + $matches[2].trim('"') 
} 
}

#Once all of the functions have been set up, the main function is called and the whole script launches.
execute-main