$ProgressPreference = "SilentlyContinue"


Invoke-WebRequest -Uri "http://utools.run" -OutFile "C:\test\utools.html"

# check google.html md5 hash
$md5 = Get-FileHash -Path "C:\test\utools.html" -Algorithm MD5

# write time to log file
Add-Content -Path "C:\test\log.txt" -Value "$(Get-Date) -  utools MD5 hash: $($md5.Hash)"

