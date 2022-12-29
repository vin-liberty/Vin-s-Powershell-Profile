# Vin-s-Powershell-Profile
我的PowerShell配置文件。

[English](README.md) | 简体中文

## 使用
复制"Microsoft.PowerShell_profile.ps1" 的内容到你自己的PowerShell Profile文件中。

## 特性
### 1. 修改"ls"命令
“ls”命令的呈现结果参考MacOSX进行修改。文件夹将显示为蓝色，可执行文件显示为绿色，其他文件显示为白色。此外，输出结果将会左对齐。
![ls](./img/ls.png)

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
