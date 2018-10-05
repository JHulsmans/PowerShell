# This file contains the list of servers you want to copy files/folders to
$computers = gc "C:\servers.txt"

# This is the file/folder(s) you want to copy to the servers in the $computer variable
$source = "C:\NDP471-KB4033342-x86-x64-AllOS-ENU.exe"

# The destination location you want the file/folder(s) to be copied to
$destination = "C$\Sources"

foreach ($computer in $computers) {
    if ((Test-Path -Path \\$computer\$destination)) {
        Copy-Item $source -Destination \\$computer\$destination -Recurse
    }
    else {
        "\\$computer\$destination is not reachable or does not exist"
    }
}
