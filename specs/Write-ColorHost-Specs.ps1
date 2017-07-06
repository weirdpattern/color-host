[System.String] $root = Split-Path -Parent (Split-Path -Parent $Script:MyInvocation.MyCommand.Path)
[System.String] $src = Join-Path -Path $root -ChildPath "src"
[System.String] $global:defaultForeground = $HOST.UI.RawUI.ForegroundColor.ToString()
[System.String] $global:defaultBackground = $HOST.UI.RawUI.BackgroundColor.ToString()

Import-Module (Join-Path -Path $src -ChildPath "Write-ColorHost.psm1") -Force

InModuleScope "Write-ColorHost" {
  Describe "Writing colored output messages" {
    BeforeEach {
      $global:message = ""
      $global:foregrounds = New-Object System.Collections.ArrayList
      $global:backgrounds = New-Object System.Collections.ArrayList
    }

    Mock Write-Host {
      $global:message += $args[1]
      $global:foregrounds.Add($args[7])
      $global:backgrounds.Add($args[3])
    }

    Context "Passing arguments" {
      It "Accepts \033 as escape character" {
        Write-ColorHost "\033[31mOK\033[0m"
        Assert-MockCalled "Write-Host" -Exactly 4 -Scope It
        $global:message | Should Be "OK"
      }

      It "Accepts \e as escape character" {
        Write-ColorHost "\e[31mOK\e[0m"
        Assert-MockCalled "Write-Host" -Exactly 4 -Scope It
        $global:message | Should Be "OK"
      }

      It "Accepts $ as escape character" {
        Write-ColorHost "$[31mOK$[0m"
        Assert-MockCalled "Write-Host" -Exactly 4 -Scope It
        $global:message | Should Be "OK"
      }

      It "Should convert a sequence of foregrounds to valid color and leave the rest as is" {
        Write-ColorHost "$[31mOK$[0m - Correct message"
        Assert-MockCalled "Write-Host" -Exactly 4 -Scope It
        $global:message | Should Be "OK - Correct message"
        $global:foregrounds | Select-Object $_ | Should be @($global:defaultForeground, "DarkRed", $global:defaultForeground)
        $global:backgrounds | Select-Object $_ | Should be @($global:defaultBackground, $global:defaultBackground, $global:defaultBackground)
      }

      It "Should convert all sequences of foregrounds to valid colors" {
        Write-ColorHost "$[31mOK$[0m - Correct $[33mmessage$[0m"
        Assert-MockCalled "Write-Host" -Exactly 6 -Scope It
        $global:message | Should Be "OK - Correct message"
        $global:foregrounds | Select-Object $_ | Should be @($global:defaultForeground, "DarkRed", "DarkYellow")
        $global:backgrounds | Select-Object $_ | Should be @($global:defaultBackground, $global:defaultBackground, $global:defaultBackground)
      }

      It "Should convert a sequence of backgrounds to valid color and leave the rest as is" {
        Write-ColorHost "$[41mOK$[0m - Correct message"
        Assert-MockCalled "Write-Host" -Exactly 4 -Scope It
        $global:message | Should Be "OK - Correct message"
        $global:foregrounds | Select-Object $_ | Should be @($global:defaultForeground, $global:defaultForeground, $global:defaultForeground)
        $global:backgrounds | Select-Object $_ | Should be @($global:defaultBackground, "DarkRed", $global:defaultBackground)
      }

      It "Should convert all sequences of backgrounds to valid colors" {
        Write-ColorHost "$[41mOK$[0m - Correct $[43mmessage$[0m"
        Assert-MockCalled "Write-Host" -Exactly 6 -Scope It
        $global:message | Should Be "OK - Correct message"
        $global:foregrounds | Select-Object $_ | Should be @($global:defaultForeground, $global:defaultForeground, $global:defaultForeground)
        $global:backgrounds | Select-Object $_ | Should be @($global:defaultBackground, "DarkRed", "DarkYellow")
      }

      It "Should convert all mixed sequences to valid colors" {
        Write-ColorHost "$[31;42mOK$[0m - Correct $[31;43mmessage$[0m"
        Assert-MockCalled "Write-Host" -Exactly 6 -Scope It
        $global:message | Should Be "OK - Correct message"
        $global:foregrounds | Select-Object $_ | Should be @($global:defaultForeground, "DarkRed", "DarkRed")
        $global:backgrounds | Select-Object $_ | Should be @($global:defaultBackground, "DarkGreen", "DarkYellow")
      }
    }
  }
}
