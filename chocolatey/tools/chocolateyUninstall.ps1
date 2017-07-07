## Original idea from https://github.com/dahlbyk/posh-git

try {
    $colorHostPath = join-path (Get-ToolsLocation) 'colorhost'

    if(Test-Path $Profile) {
        $oldProfile = @(Get-Content $Profile)
        $oldProfileEncoding = Get-FileEncoding $Profile

        $newProfile = @()
        foreach($line in $oldProfile) {
            if($line -like 'Import-Module *\src\ColorHost.psd1*') {
                continue;
            }
            $newProfile += $line
        }
        Set-Content -Path $Profile -Value $newProfile -Force -Encoding $oldProfileEncoding
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
      Set-Content -Path $Profile -Value $oldProfile -Force -Encoding $oldProfileEncoding
    }
  }
  catch {}
  throw
}
