<#
.SYNOPSIS
 Applies color to a single element.

.DESCRIPTION
 The method

.PARAMETER Object
 The object to be formatted.

.PARAMETER ForegroundColor
 The current foreground color to be used.

.PARAMETER BackgroundColor
 The current background color to be used.

.EXAMPLE
 Write-SingleColorHost "\033[31mOK\033[0m" # Outputs OK in red
 Write-SingleColorHost "\e[31mOK\e[0m"     # Outputs OK in red
 Write-SingleColorHost "$[31mOK$[0m"       # Outputs OK in red

 Write-SingleColorHost "\033[41mOK\033[0m" # Outputs OK in red background
 Write-SingleColorHost "\e[41mOK\e[0m"     # Outputs OK in red background
 Write-SingleColorHost "$[41mOK$[0m"       # Outputs OK in red background

.NOTES
 This is a private method
#>
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
    $coloredTokens = ([Regex]"(?:\\033|\$|\\e)\[(\d{1,2});?(\d{0,3})m").Matches($Object)

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

    # Flatten the object
    $Object = @($Object | ForEach-Object { $_ })

    # Loop thought all the items, processing one at the time
    $index = $Object.Count
    foreach ($element in $Object) {

      # Recursively call the function
      Write-SingleColorHost $element `
            -ForegroundColor $foreground `
            -BackgroundColor $background

      # For lists, support the separator
      if (--$index -gt 0) { Write-Host $Separator -NoNewline }
    }
  }
}
