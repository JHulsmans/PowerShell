$files = get-childitem . | ? {$_.mode -ne "d-----"}
foreach ($file in $files) {
    $extn = [IO.Path]::GetExtension($file)
    if(!(Test-Path -Path .\$extn )){
        New-Item -ItemType directory -Path .\$extn
    }
    mv $file .\$extn\
}