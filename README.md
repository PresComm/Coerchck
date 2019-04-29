# Coerchck

#### Description:

A PowerShell utility that scans networks to search for local administrator accounts on Windows machines. Requires admin privileges on the target machines.

#### Usage:

When run under the context of a user with admin privileges on the target machines, Coerchck will iterate through a user-supplied target or target list and pull a list of local administrators for each Windows machine contacted.

Accepted parameters:

-targets

Specifies the target(s) to be scanned.

Examples: 192.168.1.1, 192.168.1.25-50, 192.168.1.0/24

-intarget

Allows user to specify an input file of targets, one entry per line (see -targets example for acceptable input types.)

Example: .\input.txt

-output

Specifies the output format (if left blank, no file will be output; results will be written to the terminal.)

Currently supported output options: TXT, CSV, HTML

-filepath

Specifies the path for the output file (cannot be used without -output; if left blank, no file will be written [I will address this in an upcoming update]).

Example: C:\Users\Username\Desktop\Output.txt

-help

Displays help information.

Accepted values: true

#### Notes:

- Now supports single IPs, IP ranges, and subnets of any size!
- Now supports parameters only via the command-line; no more interactive prompts.
- Now has a -help parameter!
- Functions have been re-added.
- Now attempts to connect to potential targets on TCP port 445 before polling for administrator list. Speed is significantly increased as a result (I realize this may lead to false negatives and blank input for non-Windows SMB/Samba shares or other services running on this well-known port. I will continue to polish this feature in future updates.)
- Now supports input text files containing a list of targets. This means the user can supply a mixture of single IPs, IP ranges, and subnets of any size for a single scan!

#### Plans:

- Allow for verbose output of scanning process.
- Allow for non-CIDR subnet masks (such as 255.255.255.0).
- Possible support for non-domain or out-of-permission targets.
- Possible support for user-supplied credentials at the command-line.
- Possible support for automatically pulling the local IP and subnet mask of the machine running the script to use as the input.

### Credit:

Credit for the portion of the script that actually retrieves local admins (which actually inspired this entire script) goes to Paperclip on the Microsoft TechNet Gallery (https://gallery.technet.microsoft.com/scriptcenter/Get-remote-machine-members-bc5faa57). I contacted them and received approval before reusing their function.

Credit for the portion of the script that performs subnet calculation based upon the user's inpurt goes to Mark Gossa on the Microsoft TechNet Gallery (https://gallery.technet.microsoft.com/scriptcenter/PowerShell-Subnet-db45ec74). I ensured the license is fine for me to include this function in my script.