# Vin-s-Powershell-Profile
我的PowerShell配置文件。

[English](README.md) | 简体中文

## 说明
PowerShell配置文件类似于Linux中的`/etc/profile`，当PowerShell启动时会自动执行。  
基于Windows 11，PowerShell 5.1编写。不适用于Linux、MacOSX等其他平台。



## 使用
复制"Microsoft.PowerShell_profile.ps1" 的内容到你自己的PowerShell Profile文件中。

## 特性
### 1. 命令"ls"、"la"和"ll"
`ls`命令将列出所有文件，不包括隐藏文件。  
`la`命令将列出所有文件，包括隐藏文件。（隐藏文件是指以点开头的文件，而不是Windows中真正的隐藏文件）  
`ll`命令将列出所有文件，包括隐藏文件，并显示更多的详细信息。
文件夹将以蓝色显示，可执行文件将以绿色显示，其他文件将以白色显示。并且结果将左对齐。  

### 2. 添加"Add-Path"命令
“Add-Path”命令可以将路径添加到用户环境变量PATH中。
![Add-Path](./img/Add-Path.png)

#### 使用
基本用法：
```powershell
Add-Path "C:/Users/vin/AppData/Local/Programs/Microsoft VS Code"
```
此外，你也可以使用相对路径达到相同的效果：
```powershell
cd '.\AppData\Local\Programs\Microsoft VS Code\'
Add Path "."
```
