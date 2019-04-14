# Coerchck

#### Description:

A PowerShell utility that scans networks to search for local administrator accounts on Windows machines. Requires admin privileges on the target machines.

#### Usage:

When run under the context of a user with admin privileges on the target machines, Coerchck will iterate through a user-supplied subnet and pull a list of local administrators for each Windows machine contacted.

#### Notes:

- Now supports subnets of any size!
- Speed of script depends on a number of factors, subnet size being the most obvious, including number of active Windows workstations within the scan scope.

#### Plans:

- Allow for input of command-line parameters to ease automation.
- Allow for increased output options.
- Allow for verbose output of scanning process.
- Allow for non-CIDR subnet masks (such as 255.255.255.0).
- Display hostname/FQDN instead of just the IP.
- Possible support for non-domain or out-of-permission targets.
- Possible support for user-supplied credentials at the command-line.
- Possible support for non-contiguous, separate subnets to be queued up at beginning of scan (e.g., 192.168.1.0-256, 10.10.1.0-256, etc.)
- Possible use of pings and/or OS detection to drop targets from the scan scope and speed up total scan time.
- Possible support for automatically pulling the local IP and subnet mask of the machine running the script to use as the input.

### Credit:

Credit for the portion of the script that actually retrieves local admins (which actually inspired this entire script) goes to Paperclip on the Microsoft TechNet Gallery (https://gallery.technet.microsoft.com/scriptcenter/Get-remote-machine-members-bc5faa57). I contacted them and received approval before reusing their function.

Credit for the portion of the script that performs subnet calculation based upon the user's inpurt goes to Mark Gossa on the Microsoft TechNet Gallery (https://gallery.technet.microsoft.com/scriptcenter/PowerShell-Subnet-db45ec74). I ensured the license is fine for me to include this function in my script.