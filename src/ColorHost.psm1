#########################################################################
# Copyright (c) 2017, Patricio Trevino                                  #
# All rights reserved.                                                  #
#                                                                       #
# This source code is licensed under the MIT-style license found in the #
# LICENSE file in the root directory of this source tree.               #
#########################################################################

<#
  .SYNOPSIS PowerShell module for ANSI/VT100 color codes.
#>

. $PSScriptRoot\Utils.ps1

<#
  .SYNOPSIS
      Writes customized output to a host.

  .DESCRIPTION
      The Write-ColorHost cmdlet customizes a set of entries passed to the method.
      You can specify the default color of text by using the ForegroundColor parameter, and you
      can specify the default background color by using the BackgroundColor parameter, but ultimately
      the colors will be determine by the ANSI/VT100 color codes presented in the passed on objects.

      The method uses escape sequences to parse the content of each object. The escape sequence is as follows:

                            <escape_char><color>[;<color>]m

      Where
         escape_char is one of these: $[, \e[, \033[, \x1B[
         color is a digit

      Valid colors are:
      -- Foregrounds
         30  (Black)
         31  (DarkRed)
         32  (DarkGreen)
         33  (DarkYellow)
         34  (DarkBlue)
         35  (DarkMagenta)
         36  (DarkCyan)
         37  (Gray)
         39  (Default foreground)
         90  (DarkGray)
         91  (Red)
         92  (Green)
         93  (Yellow)
         94  (Blue)
         95  (Magenta)
         96  (Cyan)
         97  (White)

      -- Backgrounds
         40  (Black)
         41  (DarkRed)
         42  (DarkGreen)
         43  (DarkYellow)
         44  (DarkBlue)
         45  (DarkMagenta)
         46  (DarkCyan)
         47  (Gray)
         49  (Default background)
         100 (DarkGray)
         101 (Red)
         102 (Green)
         103 (Yellow)
         104 (Blue)
         105 (Magenta)
         106 (Cyan)
         107 (White)

      -- Generics
         0  (reset, back to default foreground and background)
         00 (reset, back to default foreground and background)

      For a more detail description of ANSI/VT100 color codes visit: https://en.wikipedia.org/wiki/ANSI_escape_code

  .PARAMETER Objects
      The objects to be formatted.
      The value can also be obtained from the pipeline.
      The value can also be obtained from the remaining arguments in which case multiple objects can be passed on.

  .PARAMETER NoNewLine
      Specifies that the content displayed in the console does not end with a newline character.

  .PARAMETER Separator
      Specifies a separator string to the output between objects displayed on the console.

  .PARAMETER ForegroundColor
      The default foreground color to be used. Default is $HOST.UI.RawUI.ForegroundColor.

      The acceptable values are:
      -- Black
      -- DarkBlue
      -- DarkGreen
      -- DarkCyan
      -- DarkRed
      -- DarkMagenta
      -- DarkYellow
      -- Gray
      -- DarkGray
      -- Blue
      -- Green
      -- Cyan
      -- Red
      -- Magenta
      -- Yellow
      -- White

  .PARAMETER BackgroundColor
      The default background color to be used. Default is $HOST.UI.RawUI.ForegroundColor.

      The acceptable values are:
      -- Black
      -- DarkBlue
      -- DarkGreen
      -- DarkCyan
      -- DarkRed
      -- DarkMagenta
      -- DarkYellow
      -- Gray
      -- DarkGray
      -- Blue
      -- Green
      -- Cyan
      -- Red
      -- Magenta
      -- Yellow
      -- White

  .EXAMPLE
      Write-ColorHost "\033[31mOK\033[0m"
      # Outputs 'OK' in red foreground

      Same as writing
      Write-Host 'OK' -ForegroundColor Red

  .EXAMPLE
      Write-ColorHost "\e[31mOK\e[0m"
      # Outputs 'OK' in red foreground

      Same as writing
      Write-Host 'OK' -ForegroundColor Red

  .EXAMPLE
      Write-ColorHost "$[31mOK$[0m"
      # Outputs 'OK' in red foreground

      Same as writing
      Write-Host 'OK' -ForegroundColor Red

  .EXAMPLE
      Write-ColorHost "\033[41mOK\033[0m"
      # Outputs 'OK' in red background

      Same as writing
      Write-Host 'OK' -ForegroundColor Red

  .EXAMPLE
      Write-ColorHost "\e[41mOK\e[0m"
      # Outputs 'OK' in red background

      Same as writing
      Write-Host 'OK' -BackgroundColor Red

  .EXAMPLE
      Write-ColorHost "$[41mOK$[0m"
      # Outputs 'OK' in red background

      Same as writing
      Write-Host 'OK' -BackgroundColor Red

  .EXAMPLE
      Write-ColorHost "\033[32;41mOK\033[0m"
      # Outputs 'OK' in green foreground and red background

      Same as writing
      Write-Host 'OK' -ForegroundColor Green -BackgroundColor Red

  .EXAMPLE
      Write-ColorHost "\e[32;41mOK\e[0m"
      # Outputs 'OK' in green foreground and red background

      Same as writing
      Write-Host 'OK' -ForegroundColor Green -BackgroundColor Red

  .EXAMPLE
      Write-ColorHost "$[32;41mOK$[0m"
      # Outputs 'OK' in green foreground and red background

      Same as writing
      Write-Host 'OK' -ForegroundColor Green -BackgroundColor Red

  .EXAMPLE
      Write-ColorHost "$[32mOK$[0m - Process $[33mCalculation$[0m completed successfully"
      # Outputs 'OK' in green foreground, followed by ' - Process ' in default foreground (white),
      # followed by 'Calculation' in yellow foreground, followed by ' completed successfully'
      # in default foreground (white)

      Same as writing
      Write-Host 'OK' -ForegroundColor Green -NoNewLine
      Write-Host ' - Process ' -NoNewLine
      Write-Host 'Calculation' -ForegroundColor Yellow -NoNewLine
      Write-Host ' completed successfully'

  .EXAMPLE
      Write-ColorHost ("$[31mOK$[0m", "Process $[33mCalculation$[0m completed successfully")
      # Outputs 'OK' in green foreground, followed by ' Process ' in default foreground (white),
      # followed by 'Calculation' in yellow foreground, followed by ' completed successfully'
      # in default foreground (white)

      Same as writing
      Write-Host 'OK' -ForegroundColor Green -NoNewLine
      Write-Host ' Process ' -NoNewLine
      Write-Host 'Calculation' -ForegroundColor Yellow -NoNewLine
      Write-Host ' completed successfully'

  .EXAMPLE
      Write-ColorHost ("$[31mOK$[0m", "Process $[33mCalculation$[0m completed successfully") -Separator " - "
      # Outputs 'OK' in green foreground, followed by ' - Process ' in default foreground (white),
      # followed by 'Calculation' in yellow foreground, followed by ' completed successfully'
      # in default foreground (white)

      Same as writing
      Write-Host 'OK' -ForegroundColor Green -NoNewLine
      Write-Host ' - Process ' -NoNewLine
      Write-Host 'Calculation' -ForegroundColor Yellow -NoNewLine
      Write-Host ' completed successfully'

  .EXAMPLE
      Get-Content <file> | Write-ColorHost
      # Parses the file looking for ANSI/VT100

  .NOTES
      Only string objects can be processed.
      When an array is passed on, the array will get flattened before processing, then each element is analyzed.
#>
function Write-ColorHost
{
  PARAM (
		[Parameter(Position=0, ValueFromPipeline=$True, ValueFromRemainingArguments=$True)]
    [System.Object[]]$Objects,

    [Switch]$NoNewLine,
    [System.Object]$Separator = " ",
    [System.ConsoleColor]$ForegroundColor = $HOST.UI.RawUI.ForegroundColor,
    [System.ConsoleColor]$BackgroundColor = $HOST.UI.RawUI.BackgroundColor
  )
  BEGIN {
    $foreground, $background = $ForegroundColor, $BackgroundColor
  }
  PROCESS {

    # Flatten the object
    $Objects = @($Objects | ForEach-Object { $_ })

    # Loop thought all the items, processing one at the time
    $index = $Objects.Count
    foreach ($element in $Objects) {

      # Recursively call the function
      Write-PrivateColorHost $element `
            -ForegroundColor $foreground `
            -BackgroundColor $background

      # For lists, support the separator
      if (--$index -gt 0) { Write-Host $Separator -NoNewline }
    }

    # Write the end line
    if (!$NoNewLine) { Write-Host }
  }
}
