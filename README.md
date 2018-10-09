# Coerchck

#### Description:

A PowerShell utility that scans networks to search for local administrator accounts on Windows machines. Requires domain admin privileges.

#### Usage:

When run under the context of a user with domain admin privileges, Coerchck will iterate through a user-supplied subnet and pull a list of local administrators for each Windows machine contacted. It will output these files to a .TXT file in the directory from which it was run.

#### Notes:

- Currently only supports /24 (255.255.255.0) subnets.
- Speed of script depends on a number of factors, subnet size being the most obvious, including number of active Windows workstations within the scan scope.

#### Plans:

- Allow for subnets of any size.
- Allow for input of command-line parameters to ease automation.
- Allow for increased output options.
- Possible support for non-domain or out-of-permission targets.

### Credit:
Credit for the "get-localadmins" function in the script (which actually inspired this entire script) goes to Paperclip on the Microsoft TechNet Gallery (https://gallery.technet.microsoft.com/scriptcenter/Get-remote-machine-members-bc5faa57). I contacted them and received approval before reusing their function.