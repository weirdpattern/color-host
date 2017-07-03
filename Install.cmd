@ECHO OFF
SET CurrentDir=%~dp0
SET PowerShellScriptPath=%CurrentDir%Install.ps1
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& { Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%PowerShellScriptPath%""' -Verb RunAs }";
