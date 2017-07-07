## Original idea from https://github.com/dahlbyk/posh-git

try {
    $colorHostPath = join-path (Get-ToolsLocation) 'colorhost'
    $currentVersionPath = Get-ChildItem "$colorHostPath\*ColorHost*\" | Sort-Object -Property LastWriteTime | Select-Object -Last 1

    if(Test-Path $PROFILE) {
        $oldProfile = @(Get-Content $PROFILE)
        $oldProfileEncoding = Get-FileEncoding $PROFILE

        $newProfile = @()
        foreach($line in $oldProfile) {
            if($line -like 'Import-Module *\src\ColorHost.psd1*') {
                continue;
            }
            $newProfile += $line
        }
        Set-Content -Path $profile -Value $newProfile -Force -Encoding $oldProfileEncoding
    }

    try {
      if (test-path($colorHostPath)) {
        Write-Host "Attempting to remove existing `'$colorHostPath`'."
        Remove-Item $colorHostPath -Recurse -Force
      }
    } catch {
      Write-Host "Could not remove `'$colorHostPath`'"
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
