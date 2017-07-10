# ColorHost
A PowerShell module to write colorful messages to a host.

## TL;DR;
__ColorHost__ lets you format messages you output to the host. With __ColorHost__ you can say goodbye to the thousands of lines of code needed to format a simple message.  

Consider this output message:   
![Output](https://user-images.githubusercontent.com/19519411/27975613-a083675a-6328-11e7-9490-f6ec4ed51795.png)

To get this, you need these lines of code:
```powershell
Write-Host "ColorHost " -ForegroundColor Green -NoNewLine
Write-Host "lets you write colorful " -NoNewLine
Write-Host "messages" -ForegroundColor Red
```

__ColorHost__ converts that into this:
```powershell
Write-ColorHost "$[32mColorHost$[0m lets you write colorful $[31mmessages$[0m"
```

## Installation
```powershell
choco install ColorHost
```

## Usage
The module can be used in two different ways.

### As a regular cmdlet

```powershell
Write-ColorHost
    [[-Objects] <Object[]>]
    [-NoNewLine]
    [-Separator <Object>]
    [-ForegroundColor { ConsoleColor | string }]
    [-BackgroundColor { ConsoleColor | string }]
    [<\CommonParameters\>]
```

### As part of the pipeline

```powershell
Object | Write-ColorHost
           [-NoNewLine]
           [-Separator <Object>]
           [-ForegroundColor { ConsoleColor | string }]
           [-BackgroundColor { ConsoleColor | string }]
           [<\CommonParameters\>]
```

Note: __ColorHost__ is 100% compatible with __Write-Host__, in fact, both functions behave the same way and produce exactly the same outputs. Please refer to 
[Write-Host](https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.utility/write-host) documentation for a detail description on how objects are processed.

## ANSI Color Codes
Due to limitations imposed by _PowerShell_ (not a lot of output processing options other than 16 bit foreground and background colors for now, hopefully this will change in the near future with the introduction of _Bash on Windows_ 10 and newer versions of _PowerShell_), __ColorHost__ supports only a subset of all valid _ANSI color codes_.  

### Escape characters
_ANSI color codes_ require the `<ESC>` character to be processed. In _Bash_, and other scripting languages, this character can be represented in several ways:  
- `\e`
- `\033`
- `\x1B`

__ColorHost__ supports all of them plus the character `$` (sooner or later you will realize the character `$` is extensively used in _PowerShell_, so why not support it?).  

### Formatting
__ColorHost__ supports the following control sequences:

__Reset__

| Code | Description          | Example                             |
| :--: | -------------------- | ----------------------------------- |
| 0    | Reset all attributes | `Write-ColorHost "$[0mNormal text"` |

__Foreground__

| Code | Description              | Example                                     | Equivalent                                                                 |
| :--: | ------------------------ | ------------------------------------------- | -------------------------------------------------------------------------- |
| 39   | Default foreground color | `Write-ColorHost "$[39mNormal text"`        | `Write-Host "Normal text" -ForegroundColor $HOST.UI.RawUI.ForegroundColor` |
| 30   | Black                    | `Write-ColorHost "$[30mBlack text"`         | `Write-Host "Normal text" -ForegroundColor Black`                          |
| 31   | Red                      | `Write-ColorHost "$[31mRed text"`           | `Write-Host "Normal text" -ForegroundColor DarkRed`                        |
| 32   | Green                    | `Write-ColorHost "$[32mGreen text"`         | `Write-Host "Normal text" -ForegroundColor DarkGreen`                      |
| 33   | Yellow                   | `Write-ColorHost "$[33mYellow text"`        | `Write-Host "Normal text" -ForegroundColor DarkYellow`                     |
| 34   | Blue                     | `Write-ColorHost "$[34mBlue text"`          | `Write-Host "Normal text" -ForegroundColor DarkBlue`                       | 
| 35   | Magenta                  | `Write-ColorHost "$[35mMagenta text"`       | `Write-Host "Normal text" -ForegroundColor DarkMagenta`                    |
| 36   | Cyan                     | `Write-ColorHost "$[36mCyan text"`          | `Write-Host "Normal text" -ForegroundColor DarkCyan`                       |
| 37   | Light Gray               | `Write-ColorHost "$[37mLight Gray text"`    | `Write-Host "Normal text" -ForegroundColor Gray`                           |
| 90   | Dark Gray                | `Write-ColorHost "$[90mDark Gray text"`     | `Write-Host "Normal text" -ForegroundColor DarkGray`                       |
| 91   | Light Red                | `Write-ColorHost "$[91mLight Red text"`     | `Write-Host "Normal text" -ForegroundColor Red`                            |
| 92   | Light Green              | `Write-ColorHost "$[92mLight Green text"`   | `Write-Host "Normal text" -ForegroundColor Green`                          |
| 93   | Light Yellow             | `Write-ColorHost "$[93mLight Yellow text"`  | `Write-Host "Normal text" -ForegroundColor Yellow`                         |
| 94   | Light Blue               | `Write-ColorHost "$[94mLight Blue text"`    | `Write-Host "Normal text" -ForegroundColor Blue`                           |
| 95   | Light Magenta            | `Write-ColorHost "$[95mLight Magenta text"` | `Write-Host "Normal text" -ForegroundColor Magenta`                        |
| 96   | Light Cyan               | `Write-ColorHost "$[96mLight Cyan text"`    | `Write-Host "Normal text" -ForegroundColor Cyan`                           |
| 97   | White                    | `Write-ColorHost "$[97mWhite text"`         | `Write-Host "Normal text" -ForegroundColor White`                          |

__Background__

| Code | Description              | Example                                      | Equivalent                                                                 |
| :--: | ------------------------ | -------------------------------------------- | -------------------------------------------------------------------------- |
| 49   | Default background color | `Write-ColorHost "$[49mNormal text"`         | `Write-Host "Normal text" -BackgroundColor $HOST.UI.RawUI.BackgroundColor` |
| 40   | Black                    | `Write-ColorHost "$[40mBlack text"`          | `Write-Host "Normal text" -BackgroundColor Black`                          |
| 41   | Red                      | `Write-ColorHost "$[41mRed text"`            | `Write-Host "Normal text" -BackgroundColor DarkRed`                        |
| 42   | Green                    | `Write-ColorHost "$[42mGreen text"`          | `Write-Host "Normal text" -BackgroundColor DarkGreen`                      |
| 43   | Yellow                   | `Write-ColorHost "$[43mYellow text"`         | `Write-Host "Normal text" -BackgroundColor DarkYellow`                     |
| 44   | Blue                     | `Write-ColorHost "$[44mBlue text"`           | `Write-Host "Normal text" -BackgroundColor DarkBlue`                       | 
| 45   | Magenta                  | `Write-ColorHost "$[45mMagenta text"`        | `Write-Host "Normal text" -BackgroundColor DarkMagenta`                    |
| 46   | Cyan                     | `Write-ColorHost "$[46mCyan text"`           | `Write-Host "Normal text" -BackgroundColor DarkCyan`                       |
| 47   | Light Gray               | `Write-ColorHost "$[47mLight Gray text"`     | `Write-Host "Normal text" -BackgroundColor Gray`                           |
| 100  | Dark Gray                | `Write-ColorHost "$[100mDark Gray text"`     | `Write-Host "Normal text" -BackgroundColor DarkGray`                       |
| 101  | Light Red                | `Write-ColorHost "$[101mLight Red text"`     | `Write-Host "Normal text" -BackgroundColor Red`                            |
| 102  | Light Green              | `Write-ColorHost "$[102mLight Green text"`   | `Write-Host "Normal text" -BackgroundColor Green`                          |
| 103  | Light Yellow             | `Write-ColorHost "$[103mLight Yellow text"`  | `Write-Host "Normal text" -BackgroundColor Yellow`                         |
| 104  | Light Blue               | `Write-ColorHost "$[104mLight Blue text"`    | `Write-Host "Normal text" -BackgroundColor Blue`                           |
| 105  | Light Magenta            | `Write-ColorHost "$[105mLight Magenta text"` | `Write-Host "Normal text" -BackgroundColor Magenta`                        |
| 106  | Light Cyan               | `Write-ColorHost "$[106mLight Cyan text"`    | `Write-Host "Normal text" -BackgroundColor Cyan`                           |
| 107  | White                    | `Write-ColorHost "$[107mWhite text"`         | `Write-Host "Normal text" -BackgroundColor White`                          |

Sequences can be combined using `;`, e.g. `Write-ColorHost $[31;42mOK$[0m` will output the 'OK' in red on a green background.
