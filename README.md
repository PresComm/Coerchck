# Coerchck

#### Description:

A PowerShell utility that scans networks to search for local administrator accounts on Windows machines. Requires admin privileges on the target machines.

#### Usage:

When run under the context of a user with admin privileges on the target machines, Coerchck will iterate through a user-supplied subnet and pull a list of local administrators for each Windows machine contacted.

Coerchck can be run with parameters supplied at the command line; any parameters that aren't supplied on the command line will be asked for interactively upon running the script.

Accepted parameters:

-subnets

Specificies the target subnet to be scanned.

Example: 192.168.1.0/24

-output

Specifies the output format (if left blank, no file will be output; results will be written to the terminal).

Currently supported output options: TXT, CSV, HTML

-filepath

Specificies the path for the output file (cannot be used without -output; if left blank, no file will be written [I will address this in an upcoming update]).

Example: C:\Users\Username\Desktop\Output.txt

#### Notes:

- Now supports subnets of any size!
- Now supports command-line parameters (see "Usage" for more information)!
- Now supports file output in TXT, CSV, and HTML formats (this feature is VERY rough. I will address formatting in an upcoming update.)
- Speed of script depends on a number of factors, subnet size being the most obvious, including number of active Windows workstations within the scan scope.

#### Plans:

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