#########################################################################
# Copyright (c) 2017, Patricio Trevino                                  #
# All rights reserved.                                                  #
#                                                                       #
# This source code is licensed under the MIT-style license found in the #
# LICENSE file in the root directory of this source tree.               #
#########################################################################

<#
  .SYNOPSIS
      Parses the given object looking for ANSI/VT100 codes.

  .DESCRIPTION
      The Write-PrivateColorHost cmdlet customizes a single entry passed to Write-ColorHost.
      You can specify the default color of text by using the ForegroundColor parameter, and you
      can specify the default background color by using the BackgroundColor parameter, but ultimately
      the colors will be determine by the ANSI/VT100 color codes presented in the passed on object.

  .PARAMETER Object
      The object to be parsed.

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
      Write-PrivateColorHost "\x1B[31mOK\x1B[0m"
      # Outputs 'OK' in red foreground

      Same as writing
      Write-Host 'OK' -ForegroundColor Red

  .EXAMPLE
      Write-PrivateColorHost "\033[31mOK\033[0m"
      # Outputs 'OK' in red foreground

      Same as writing
      Write-Host 'OK' -ForegroundColor Red

  .EXAMPLE
      Write-PrivateColorHost "\e[31mOK\e[0m"
      # Outputs 'OK' in red foreground

      Same as writing
      Write-Host 'OK' -ForegroundColor Red

  .EXAMPLE
      Write-PrivateColorHost "$[31mOK$[0m"
      # Outputs 'OK' in red foreground

      Same as writing
      Write-Host 'OK' -ForegroundColor Red

  .EXAMPLE
      Write-PrivateColorHost "\033[41mOK\033[0m"
      # Outputs 'OK' in red background

      Same as writing
      Write-Host 'OK' -ForegroundColor Red

  .EXAMPLE
      Write-PrivateColorHost "\x1B[41mOK\x1B[0m"
      # Outputs 'OK' in red background

      Same as writing
      Write-Host 'OK' -ForegroundColor Red

  .EXAMPLE
      Write-PrivateColorHost "\e[41mOK\e[0m"
      # Outputs 'OK' in red background

      Same as writing
      Write-Host 'OK' -BackgroundColor Red

  .EXAMPLE
      Write-PrivateColorHost "$[41mOK$[0m"
      # Outputs 'OK' in red background

      Same as writing
      Write-Host 'OK' -BackgroundColor Red

  .EXAMPLE
      Write-PrivateColorHost "\033[32;41mOK\033[0m"
      # Outputs 'OK' in green foreground and red background

      Same as writing
      Write-Host 'OK' -ForegroundColor Green -BackgroundColor Red

  .EXAMPLE
      Write-PrivateColorHost "\0x1B[32;41mOK\x1B[0m"
      # Outputs 'OK' in green foreground and red background

      Same as writing
      Write-Host 'OK' -ForegroundColor Green -BackgroundColor Red

  .EXAMPLE
      Write-PrivateColorHost "\e[32;41mOK\e[0m"
      # Outputs 'OK' in green foreground and red background

      Same as writing
      Write-Host 'OK' -ForegroundColor Green -BackgroundColor Red

  .EXAMPLE
      Write-PrivateColorHost "$[32;41mOK$[0m"
      # Outputs 'OK' in green foreground and red background

      Same as writing
      Write-Host 'OK' -ForegroundColor Green -BackgroundColor Red

  .EXAMPLE
      Write-PrivateColorHost "$[32mOK$[0m - Process $[33mCalculation$[0m completed successfully"
      # Outputs 'OK' in green foreground, followed by ' - Process ' in default foreground (white),
      # followed by 'Calculation' in yellow foreground, followed by ' completed successfully'
      # in default foreground (white)

      Same as writing
      Write-Host 'OK' -ForegroundColor Green -NoNewLine
      Write-Host ' - Process ' -NoNewLine
      Write-Host 'Calculation' -ForegroundColor Yellow -NoNewLine
      Write-Host ' completed successfully'

  .NOTES
      This is a private method not meant for public usage.
#>
function Write-PrivateColorHost {
  PARAM (
		[Parameter(Position=0)]
    [System.Object]$Object,

    [System.ConsoleColor]$ForegroundColor = $HOST.UI.RawUI.ForegroundColor,
    [System.ConsoleColor]$BackgroundColor = $HOST.UI.RawUI.BackgroundColor
  )
  PROCESS {
    # We only process non-nullable objects
    if ($Object -eq $Null) {
      Write-Host "" -NoNewline
      Return

    # For non-strings fail fast and just let Write-Host do its thing
    } elseif ($Object.GetType().FullName -ne "System.String") {
      Write-Host $Object `
            -NoNewline `
            -ForegroundColor $foreground `
            -BackgroundColor $background
      Return
    }

    # Get the tokens to be processed
    # $coloredTokens contains each one of the ansi color blocks
    $coloredTokens = ([Regex]"(?:\\x1B|\\033|\$|\\e)\[(\d{1,2});?(\d{0,3})m").Matches($Object)

    # Loop through all $coloredTokens
    $index = 0
    foreach ($coloredToken in $coloredTokens) {

      # Output everything before the token
      $token = $Object.Substring($index, $coloredToken.Index - $index)
      Write-Host $token `
            -NoNewline `
            -ForegroundColor $foreground `
            -BackgroundColor $background

      # Pick the new colors
      $coloredtoken.Groups | ForEach-Object {
        switch -regex ($_) {
          "^0{1,2}$" { $foreground, $background = $foregroundColor, $backgroundColor }
          "^30$"     { $foreground              = "Black"                            }
          "^31$"     { $foreground              = "DarkRed"                          }
          "^32$"     { $foreground              = "DarkGreen"                        }
          "^33$"     { $foreground              = "DarkYellow"                       }
          "^34$"     { $foreground              = "DarkBlue"                         }
          "^35$"     { $foreground              = "DarkMagenta"                      }
          "^36$"     { $foreground              = "DarkCyan"                         }
          "^37$"     { $foreground              = "Gray"                             }
          "^39$"     { $foreground              = $foregroundColor                   }
          "^90$"     { $foreground              = "DarkGray"                         }
          "^91$"     { $foreground              = "Red"                              }
          "^92$"     { $foreground              = "Green"                            }
          "^93$"     { $foreground              = "Yellow"                           }
          "^94$"     { $foreground              = "Blue"                             }
          "^95$"     { $foreground              = "Magenta"                          }
          "^96$"     { $foreground              = "Cyan"                             }
          "^97$"     { $foreground              = "White"                            }
          "^40$"     {              $background =                   "Black"          }
          "^41$"     {              $background =                   "DarkRed"        }
          "^42$"     {              $background =                   "DarkGreen"      }
          "^43$"     {              $background =                   "DarkYellow"     }
          "^44$"     {              $background =                   "DarkBlue"       }
          "^45$"     {              $background =                   "DarkMagenta"    }
          "^46$"     {              $background =                   "DarkCyan"       }
          "^47$"     {              $background =                   "Gray"           }
          "^49$"     {              $background =                   $backgroundColor }
          "^100$"    {              $background =                   "DarkGray"       }
          "^101$"    {              $background =                   "Red"            }
          "^102$"    {              $background =                   "Green"          }
          "^103$"    {              $background =                   "Yellow"         }
          "^104$"    {              $background =                   "Blue"           }
          "^105$"    {              $background =                   "Magenta"        }
          "^106$"    {              $background =                   "Cyan"           }
          "^107$"    {              $background =                   "White"          }
        }
      }

      # Move the index to the end of the current colored token
      $index = $coloredToken.Index + $coloredToken.Length
    }

    # Output the rest of the string
    $token = $Object.Substring($index)
    Write-Host $token `
          -NoNewline `
          -ForegroundColor $foreground `
          -BackgroundColor $background
  }
}
