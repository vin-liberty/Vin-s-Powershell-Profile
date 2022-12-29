# Vin-s-Powershell-Profile
My Microsoft PowerShell Profile.

English | [简体中文](README-CN.md)

## Usage
Copy the contents of "Microsoft.PowerShell_profile.ps1" to you own PowerShell Profile.

## Feature
### 1.  More humanized "ls"
Folders are displayed in blue, executable files are displayed in green, other files are displayed in white when execute command "ls". And the result will be left justified.
![ls](./img/ls.png)

### 2. Add-Path command
Add-Path command can add a spectifc directory to user's PATH environment variable. 
![Add-Path](./img/Add-Path.png)

#### Usage
Basic usage:
```powershell
Add-Path "C:/Users/vin/AppData/Local/Programs/Microsoft VS Code"
```
Besides,use relative path can reach the same effect:
```powershell
cd '.\AppData\Local\Programs\Microsoft VS Code\'
Add Path "."
```