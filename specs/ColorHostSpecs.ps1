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
      $global:message += $args[$args.IndexOf("-Object:") + 1]
      $global:foregrounds.Add($args[$args.IndexOf("-ForegroundColor:") + 1])
      $global:backgrounds.Add($args[$args.IndexOf("-BackgroundColor:") + 1])
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

      It "Should support multiple objects" {
        Write-ColorHost "$[31;42mOK$[0m" "Correct $[31;43mmessage$[0m"
        Assert-MockCalled "Write-Host" -Exactly 8 -Scope It
        $global:message | Should Be "OK Correct message"
      }

      It "Should support multiple objects with separator" {
        Write-ColorHost "$[31;42mOK$[0m" "Correct $[31;43mmessage$[0m" -Separator " - "
        Assert-MockCalled "Write-Host" -Exactly 8 -Scope It
        $global:message | Should Be "OK - Correct message"
      }

      It "Prints objects as is" {
        $obj = New-Object System.Object
        $obj | Add-Member -type NoteProperty -name "Property" -value "Test"
        Write-ColorHost $obj
        Assert-MockCalled "Write-Host" -Exactly 2 -Scope It
        $global:message | Should Be "System.Object"
      }

      It "Prints hashtables as is" {
        $hash = {a="one"; b="two"}
        Write-ColorHost $hash
        Assert-MockCalled "Write-Host" -Exactly 2 -Scope It
        $global:message | Should Be 'a="one"; b="two"'
      }
    }

    Context "Pipelining" {
      It "Accepts \033 as escape character" {
        "\033[31mOK\033[0m" | Write-ColorHost
        Assert-MockCalled "Write-Host" -Exactly 4 -Scope It
        $global:message | Should Be "OK"
      }

      It "Accepts \e as escape character" {
        "\e[31mOK\e[0m" | Write-ColorHost
        Assert-MockCalled "Write-Host" -Exactly 4 -Scope It
        $global:message | Should Be "OK"
      }

      It "Accepts $ as escape character" {
        "$[31mOK$[0m" | Write-ColorHost
        Assert-MockCalled "Write-Host" -Exactly 4 -Scope It
        $global:message | Should Be "OK"
      }

      It "Should convert a sequence of foregrounds to valid color and leave the rest as is" {
        "$[31mOK$[0m - Correct message" | Write-ColorHost
        Assert-MockCalled "Write-Host" -Exactly 4 -Scope It
        $global:message | Should Be "OK - Correct message"
        $global:foregrounds | Select-Object $_ | Should be @($global:defaultForeground, "DarkRed", $global:defaultForeground)
        $global:backgrounds | Select-Object $_ | Should be @($global:defaultBackground, $global:defaultBackground, $global:defaultBackground)
      }

      It "Should convert all sequences of foregrounds to valid colors" {
        "$[31mOK$[0m - Correct $[33mmessage$[0m" | Write-ColorHost
        Assert-MockCalled "Write-Host" -Exactly 6 -Scope It
        $global:message | Should Be "OK - Correct message"
        $global:foregrounds | Select-Object $_ | Should be @($global:defaultForeground, "DarkRed", "DarkYellow")
        $global:backgrounds | Select-Object $_ | Should be @($global:defaultBackground, $global:defaultBackground, $global:defaultBackground)
      }

      It "Should convert a sequence of backgrounds to valid color and leave the rest as is" {
        "$[41mOK$[0m - Correct message" | Write-ColorHost
        Assert-MockCalled "Write-Host" -Exactly 4 -Scope It
        $global:message | Should Be "OK - Correct message"
        $global:foregrounds | Select-Object $_ | Should be @($global:defaultForeground, $global:defaultForeground, $global:defaultForeground)
        $global:backgrounds | Select-Object $_ | Should be @($global:defaultBackground, "DarkRed", $global:defaultBackground)
      }

      It "Should convert all sequences of backgrounds to valid colors" {
        "$[41mOK$[0m - Correct $[43mmessage$[0m" | Write-ColorHost
        Assert-MockCalled "Write-Host" -Exactly 6 -Scope It
        $global:message | Should Be "OK - Correct message"
        $global:foregrounds | Select-Object $_ | Should be @($global:defaultForeground, $global:defaultForeground, $global:defaultForeground)
        $global:backgrounds | Select-Object $_ | Should be @($global:defaultBackground, "DarkRed", "DarkYellow")
      }

      It "Should convert all mixed sequences to valid colors" {
        "$[31;42mOK$[0m - Correct $[31;43mmessage$[0m" | Write-ColorHost
        Assert-MockCalled "Write-Host" -Exactly 6 -Scope It
        $global:message | Should Be "OK - Correct message"
        $global:foregrounds | Select-Object $_ | Should be @($global:defaultForeground, "DarkRed", "DarkRed")
        $global:backgrounds | Select-Object $_ | Should be @($global:defaultBackground, "DarkGreen", "DarkYellow")
      }

      It "Should support multiple objects" {
        "$[31;42mOK$[0m", "Correct $[31;43mmessage$[0m" | Write-ColorHost
        Assert-MockCalled "Write-Host" -Exactly 8 -Scope It
        $global:message | Should Be "OKCorrect message"
      }

      It "Prints objects as is" {
        $obj = New-Object System.Object
        $obj | Add-Member -type NoteProperty -name "Property" -value "Test"
        $obj | Write-ColorHost
        Assert-MockCalled "Write-Host" -Exactly 2 -Scope It
        $global:message | Should Be "System.Object"
      }

      It "Prints hashtables as is" {
        $hash = {a="one"; b="two"}
        $hash | Write-ColorHost
        Assert-MockCalled "Write-Host" -Exactly 2 -Scope It
        $global:message | Should Be 'a="one"; b="two"'
      }
    }
  }
}
