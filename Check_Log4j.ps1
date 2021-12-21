$ErrorActionPreference= 'silentlycontinue'

# source from https://www.pdq.com/blog/log4j-vulnerability-cve-2021-44228/

###Get Vulnerable Hashes
$vulnerablesums = -split $(Invoke-WebRequest https://github.com/mubix/CVE-2021-44228-Log4Shell-Hashes/raw/main/sha256sums.txt -UseBasicParsing).content | Where-Object {$_.length -eq 64}
###Get Hash and file location for each log4j*.jar file
$localsums =  @(get-childitem "C:\log4j*.jar" -file -Recurse | Select-Object Fullname, @{Name = "Hash"; Expression = {(Get-FileHash -Path $_.FullName).Hash}})
###If Log4j*.jar is found compare hash to bad hashes
if(-not($null -eq $localsums)){$BadHash = Compare-Object -ReferenceObject $vulnerablesums -DifferenceObject $localsums.Hash -ExcludeDifferent -IncludeEqual -ErrorAction SilentlyContinue}
###Return FileLocation and hash for each vulnerable result

foreach($Entry in $localsums){
    if($BadHash.InputObject -contains $Entry.Hash){
        $result += $Entry
    }
}
if($null -eq $result){
#    [pscustomobject]@{
#        FullName = "No File"
#        Hash = " "
#    }
    echo "not vulnerable"
    [pscustomObject]$localsums
}Else{
    [pscustomObject]$result
}
