## Original idea from https://github.com/dahlbyk/posh-git

try {
    $colorHostPath = join-path (Get-ToolsLocation) 'colorhost'

    try {
      if (test-path($colorHostPath)) {
        Write-Host "Attempting to remove existing `'$colorHostPath`'."
        Remove-Item $colorHostPath -Recurse -Force
      } else {
        MkDir $colorHostPath
      }
    } catch {
      Write-Host "Could not remove `'$colorHostPath`'"
    }

    $version = "v$Env:chocolateyPackageVersion"
    if ($version -eq 'v') {
      $version = 'master'
    }

    $colorHostInstall = "https://github.com/weirdpattern/color-host/zipball/$version"

    Install-ChocolateyZipPackage 'colorhost' $colorHostInstall $colorHostPath
    $currentVersionPath = Get-ChildItem "$colorHostPath\*ColorHost*\" | Sort-Object -Property LastWriteTime | Select-Object -Last 1

    if(Test-Path $Profile) {
        $oldProfile = @(Get-Content $Profile)
        $oldProfileEncoding = Get-FileEncoding $Profile

        $newProfile = @()
        foreach($line in $oldProfile) {
            if($line -like 'Import-Module *\src\ColorHost.psd1*') {
                $line = "Import-Module '$currentVersionPath\src\ColorHost.psd1'"
            }
            $newProfile += $line
        }
        Set-Content -Path $Profile -Value $newProfile -Force -Encoding $oldProfileEncoding
    }
} catch {
  try {
    if ($oldProfile) {
      Set-Content -Path $Profile -Value $oldProfile -Force -Encoding $oldProfileEncoding
    }
  }
  catch {}
  throw
}
