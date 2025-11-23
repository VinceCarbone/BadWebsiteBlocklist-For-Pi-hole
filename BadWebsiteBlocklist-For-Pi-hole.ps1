# sets some variables
$date = Get-Date
$pattern = '\*:\/\/\*.'
$ExtractedUrls = @()
$FilePath = "$PSScriptRoot\BadWebsiteBlocklist-For-Pi-Hole.txt"

# checks to see if there's a local list already created
try {
    $ExistingFile = Get-Content $FilePath -ErrorAction Stop
    Write-Host "[OK] Imported existing local list with $($ExistingFile.count) URLs" -ForegroundColor Green
} catch {
    $ExistingFile = $null
    Write-Host "[WARN] Did not find existing list locally, will create new file" -ForegroundColor Yellow
}

# Reads the existing list from popcar2's repo
try {
    $response = Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/popcar2/BadWebsiteBlocklist/refs/heads/main/uBlacklist.txt' -ErrorAction Stop
    if ($response.statuscode -eq '200') {
        write-host "[OK] Invoke-WebRequest was successful" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Status code is '$($response.statuscode)' with message '$($response.StatusDescription)'"
    }
} catch {
    Write-Host "[ERROR] failed to download blacklist" -ForegroundColor Red
}

# If it was able to read popcar2's repo, it parses the response
if($response.StatusCode -eq '200'){
    $lines = $response.content -split "`n"
    $urls = ($lines -match $pattern) -replace $pattern
    ForEach($url in $urls){
        $ExtractedUrls += ($url -split "/")[0]
    }
    $ExtractedUrls = $ExtractedUrls | Sort-Object | Get-Unique
    Write-Host "[OK] Extracted $($ExtractedUrls.count) unique URLs" -ForegroundColor Green
}

# if it extracted any URLs, it compares what it pulled vs what is in the local list (if it exists)
if($ExtractedUrls){
    if($ExistingFile){
        if($ExtractedUrls.count -gt $ExistingFile.count){
            $continue = $true
        } elseif ($ExtractedUrls.count -eq $ExistingFile.count){
            if(Compare-Object -ReferenceObject $ExistingFile -DifferenceObject $ExtractedUrls){
                $continue = $true
            } else {
                Write-Host "[OK] No new sites detected" -ForegroundColor Green
                $continue = $false
            }
        } else {
            $continue = $false
            Write-Host "[ERROR] Extracted URL count is less than the local list '$FilePath'" -ForegroundColor Red
        }
    } else {
        $continue = $true
    }

    if($continue){        
        try {
            $ExtractedUrls | Set-Content "$FilePath" -Force -ErrorAction Stop
            Write-Host "[OK] Exported URL list to '$FilePath'" -ForegroundColor Green

            try {
                & git add "$filepath"
                & git commit -m "Site list update $(get-date -format MM/dd/yyyy)"
                & git push                
            } catch {
                Write-Host "[ERROR] Failed to push to Github" -ForegroundColor Red
            }
        } catch {
            Write-Host "[ERROR] Failed to export URL list to '$FilePath'" -ForegroundColor Red
        }
    }
}