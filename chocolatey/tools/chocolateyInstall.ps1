## Original idea from https://github.com/dahlbyk/posh-git

try {
    $colorHostPath = join-path (Get-ToolsLocation) 'colorhost'

    try {
      if (test-path($colorHostPath)) {
        Write-Host "Attempting to remove existing `'$colorHostPath`'."
        Remove-Item $colorHostPath -Recurse -Force
      }
    } catch {
      Write-Host "Could not remove `'$colorHostPath`'"
    }

    $version = "v$Env:chocolateyPackageVersion"
    if ($version -eq 'v') {
      $version = 'master'
    }

    $colorHostInstall = "https://github.com/weirdpattern/color-host/zipball/$version"
    $zip = Install-ChocolateyZipPackage 'colorhost' $colorHostInstall $colorHostPath
    $currentVersionPath = Get-ChildItem "$colorHostPath\*ColorHost*\" | Sort-Object -Property LastWriteTime | Select-Object -Last 1

    if(Test-Path $PROFILE) {
        $oldProfile = @(Get-Content $PROFILE)
        $oldProfileEncoding = Get-FileEncoding $PROFILE

        $newProfile = @()
        foreach($line in $oldProfile) {
            if($line -like 'Import-Module *\src\ColorHost.psd1*') {
                $line = "Import-Module '$currentVersionPath\src\ColorHost.psd1'"
            }
            $newProfile += $line
        }
        Set-Content -Path $profile -Value $newProfile -Force -Encoding $oldProfileEncoding
    }
} catch {
  try {
    if ($oldProfile) {
      Set-Content -Path $PROFILE -Value $oldProfile -Force -Encoding $oldProfileEncoding
    }
  }
  catch {}
  throw
}
