# Coerchck
# v. 0.3 - 04/17/2019
# by PresComm
# https://github.com/PresComm/Coerchck
# https://0x00sec.org

#MIT License

<#Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.#>

#Allow user to provide their desired target subnet as a command-line parameter, as well as their desired output format
Param(
[string]$subnets,
[string]$output,
[string]$filepath
)

#Show banner, version info, authorship, etc.
cls
echo "Coerchck"
echo "v. 0.3 - 04/17/2019"
echo "by PresComm"
echo "https://github.com/PresComm/Coerchck"
echo "https://0x00sec.org"
echo ""

#Trying to poll non-Windows machines results in nasty errors, so let's ignore them and move on when they pop up.
$ErrorActionPreference = 'SilentlyContinue'

#If no command-line paramter was provided for target subnet, prompt user for sample IP and CIDR mask, then create the input string for iteration.
if ($subnets -eq "") {
$networkid = Read-Host -Prompt 'Enter sample IP on the target network'
$cidrmask = Read-Host -Prompt 'Enter CIDR mask (such as 24, 16, 8, etc.)'
$subnets = "$networkid/$cidrmask"
echo ""
}
#If no command-line paramter was provided for output format, ask user for it here
if ($output -eq "") {
    $output = Read-Host -Prompt 'Enter desired output format (TXT, CSV, or HTML), or leave blank for no output file'
    echo ""
    #If no command-line parameter was provided for output filepath, prompt user to supply it here
    if ($filepath -eq "") {
    $filepath = Read-Host -Prompt 'Enter file path for output, or leave blank to write file to current directory with default filename'
    echo ""
    }
}

#If an output format of some kind was supplied as a parameter, react accordingly and create the initial file so we can loop through and append to it.
if ($output -eq "TXT"){
    echo "Scan Results" | Select-Object @{Name='Coerchck - Local Admin Subnet Scanner';Expression={$_}} | Out-File $filepath
}
if ($output -eq "CSV"){
    echo "Scan Results" | Select-Object @{Name='Coerchck - Local Admin Subnet Scanner';Expression={$_}} | Export-Csv -Path $filepath -NoTypeInformation
}
if ($output -eq "HTML"){
    echo "Coerchck - Local Admin Subnet Scanner"''"Scan Results" | Select-Object @{Expression={$_}} | ConvertTo-Html | Out-File $filepath
}

echo "Beginning scan of $subnets..."
echo ""
#This is the function that iterates through the user-supplied subnet.
#Credit for this portion of the script goes to Mark Gossa
#on the Microsoft TechNet Gallery (https://gallery.technet.microsoft.com/scriptcenter/PowerShell-Subnet-db45ec74).
#I ensured the license is fine for me to include this function in my script.
foreach ($subnet in $subnets)
    {
        
        #Split IP and subnet
        $IP = ($Subnet -split "\/")[0]
        $SubnetBits = ($Subnet -split "\/")[1]
        
        #Convert IP into binary
        #Split IP into different octects and for each one, figure out the binary with leading zeros and add to the total
        $Octets = $IP -split "\."
        $IPInBinary = @()
        foreach($Octet in $Octets)
            {
                #convert to binary
                $OctetInBinary = [convert]::ToString($Octet,2)
                
                #get length of binary string add leading zeros to make octet
                $OctetInBinary = ("0" * (8 - ($OctetInBinary).Length) + $OctetInBinary)

                $IPInBinary = $IPInBinary + $OctetInBinary
            }
        $IPInBinary = $IPInBinary -join ""

        #Get network ID by subtracting subnet mask
        $HostBits = 32-$SubnetBits
        $NetworkIDInBinary = $IPInBinary.Substring(0,$SubnetBits)
        
        #Get host ID and get the first host ID by converting all 1s into 0s
        $HostIDInBinary = $IPInBinary.Substring($SubnetBits,$HostBits)        
        $HostIDInBinary = $HostIDInBinary -replace "1","0"

        #Work out all the host IDs in that subnet by cycling through $i from 1 up to max $HostIDInBinary (i.e. 1s stringed up to $HostBits)
        #Work out max $HostIDInBinary
        $imax = [convert]::ToInt32(("1" * $HostBits),2) -1

        $IPs = @()

        #Next ID is first network ID converted to decimal plus $i then converted to binary
        For ($i = 1 ; $i -le $imax ; $i++)
            {
                #Convert to decimal and add $i
                $NextHostIDInDecimal = ([convert]::ToInt32($HostIDInBinary,2) + $i)
                #Convert back to binary
                $NextHostIDInBinary = [convert]::ToString($NextHostIDInDecimal,2)
                #Add leading zeros
                #Number of zeros to add 
                $NoOfZerosToAdd = $HostIDInBinary.Length - $NextHostIDInBinary.Length
                $NextHostIDInBinary = ("0" * $NoOfZerosToAdd) + $NextHostIDInBinary

                #Work out next IP
                #Add networkID to hostID
                $NextIPInBinary = $NetworkIDInBinary + $NextHostIDInBinary
                #Split into octets and separate by . then join
                $IP = @()
                For ($x = 1 ; $x -le 4 ; $x++)
                    {
                        #Work out start character position
                        $StartCharNumber = ($x-1)*8
                        #Get octet in binary
                        $IPOctetInBinary = $NextIPInBinary.Substring($StartCharNumber,8)
                        #Convert octet into decimal
                        $IPOctetInDecimal = [convert]::ToInt32($IPOctetInBinary,2)
                        #Add octet to IP 
                        $IP += $IPOctetInDecimal
                    }

                #Separate by .
                $IP = $IP -join "."

                echo "Loading results for $IP..."
                if ($output -eq "TXT") {
                    echo $IP | Select-Object @{Name='Displaying results for...';Expression={$_}}>>$filepath
                }
                if ($output -eq "CSV") {
                    echo $IP | Select-Object @{Name='Displaying results for...';Expression={$_}} | Out-File $filepath -Append -Encoding Unicode
                }
                if ($output -eq "HTML") {
                    echo "Displaying results for"''$IP | Select-Object @{Expression={$_}} | ConvertTo-Html | Out-File $filepath -Append -Encoding Unicode
                }
                #This is the function that actually polls each target for the list of local administrators.
                #Credit for this portion of the script (which actually inspired this entire script) goes to
                #Paperclip on the Microsoft TechNet Gallery (https://gallery.technet.microsoft.com/scriptcenter/Get-remote-machine-members-bc5faa57).
                #I contacted them and received approval before reusing their function.
                $admins = Gwmi win32_groupuser –computer $IP  
                $admins = $admins |? {$_.groupcomponent –like '*"Administrators"'} 
 

                if ($output -eq "TXT") {
                    $admins |% { 
                    $_.partcomponent –match “.+Domain\=(.+)\,Name\=(.+)$” > $nul 
                    $matches[1].trim('"') + “\” + $matches[2].trim('"') 
                    } | Select-Object @{Name='Account Name';Expression={$_}}>>$filepath
                }
                if ($output -eq "CSV") {
                    $admins |% { 
                    $_.partcomponent –match “.+Domain\=(.+)\,Name\=(.+)$” > $nul 
                    $matches[1].trim('"') + “\” + $matches[2].trim('"') 
                    } | Select-Object @{Name='Account Name';Expression={$_}} | Out-File $filepath -Append -Encoding Unicode
                }
                if ($output -eq "HTML") {
                    $admins |% { 
                    $_.partcomponent –match “.+Domain\=(.+)\,Name\=(.+)$” > $nul 
                    $matches[1].trim('"') + “\” + $matches[2].trim('"') 
                    } | Select-Object @{Expression={$_}} | ConvertTo-Html | Out-File $filepath -Append -Encoding Unicode
                }
                else {
                    $admins |% { 
                    $_.partcomponent –match “.+Domain\=(.+)\,Name\=(.+)$” > $nul 
                    $matches[1].trim('"') + “\” + $matches[2].trim('"') 
                    }
                }
                    
                echo ""
            }
    }