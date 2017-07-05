function Write-SingleColorHost {
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

    # For non-strings failfast and just let Write-Host do its thing
    } elseif ($Object.GetType().FullName -ne "System.String") {
      Write-Host $Object `
            -NoNewline
            -ForegroundColor $foreground `
            -BackgroundColor $background
      Return
    }

    # Get the tokens to be processed
    # $token contains everything before the first escape character (\033, $ or \e)
    # $coloredTokens contains each one of the ansi color blocks
    $token, $coloredTokens = ([Regex]"(\\033|\$|\\e)\[").Split($Object)

    # Write the first token using the default foreground and background
    Write-Host $token `
          -NoNewline `
          -ForegroundColor $foreground `
          -BackgroundColor $background

    # Second loop to process each one of the ansi color blocks
    foreach ($coloredToken in $coloredTokens) {

      # Get the foreground and background colors
      $colorCodes, $token = ([Regex]"m").Split($coloredToken, 2)
      ([Regex]";").split($colorCodes) | ForEach-Object {
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

      # Write the last token using the last selected foreground and background
      Write-Host $token `
            -NoNewLine `
            -foregroundColor $foreground `
            -backgroundColor $background
    }
  }
}

function Write-ColorHost
{
  PARAM (
		[Parameter(Position=0, ValueFromPipeline=$True, ValueFromRemainingArguments=$True)]
    [System.Object]$Object,

    [Switch]$NoNewLine,
    [System.Object]$Separator = " ",
    [System.ConsoleColor]$ForegroundColor = $HOST.UI.RawUI.ForegroundColor,
    [System.ConsoleColor]$BackgroundColor = $HOST.UI.RawUI.BackgroundColor
  )
  BEGIN {
    $foreground, $background = $ForegroundColor, $BackgroundColor
  }
  PROCESS {

    # We only process non-nullable objects
    if ($Object -eq $Null) {
      Write-Host ""
      Break
    }

    # Strings are enumerables, but they behave differently
    # So we need to process these before other enumerables
    if ($Object.GetType().FullName -eq "System.String") {

      # Process the element
      Write-SingleColorHost $Object `
            -ForegroundColor $foreground `
            -BackgroundColor $background

      # Finally append a new line if needed
      if (!$NoNewLine) { Write-Host }

    # Handle enumerables
    } elseif ($Object.Count) {

      # Loop thought all the items, processing one at the time
      $index = 0
      foreach ($element in $Object) {

        # Process the element
        Write-SingleColorHost $element `
              -ForegroundColor $foreground `
              -BackgroundColor $background

        # For lists, support the separator
        if ($index++ -lt ($Object.Count - 1)) {
          Write-Host $Separator -NoNewline
        }

      }

      # Finally append a new line if needed
		  if (!$NoNewLine) { Write-Host }

    # Handle the rest
    } else {

      # Write the object as is
      Write-Host $Object `
            -ForegroundColor $foreground `
            -BackgroundColor $background
    }
  }
}
