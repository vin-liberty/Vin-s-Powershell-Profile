# set encoding UTF-8
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

function prompt {
	Write-Host ("PS:$(Get-Location)>") -NoNewLine ` -ForegroundColor 2
	return " "
}

# Use "touch" to create a new file
New-Alias -Name touch -Value New-Item
# Use "ifconfig" to replace "ipconfig
New-Alias -Name ifconfig -Value ipconfig
# Use "vim" to replace "nvim (Need to install nvim at first)"
New-Alias -Name vim -Value nvim
# Use "grep" to replace "findstr"
New-Alias -Name grep -Value findstr
# Customize "ls" as Mac OS X
Remove-Item Alias:ls
function ls([string]$dir = ".") {
	# if dir ends with ":",like "ls C:"
	if($dir -match ":$") {
		# add "\" to the end of dir
		$dir = $dir + "\"
	}
	$names = (Get-ChildItem $dir).Name
	$names = $names | Where-Object { $_ -notmatch "^[.].*" }
	$maxLength = $names | Measure-Object -Property Length -Maximum | Select-Object -ExpandProperty Maximum
	$cnt = 0
	foreach ($name in $names) {
		# append $dir to $name
		$path = Join-Path $dir $name
		if (Test-Path $path -PathType Container) {
			Write-Host $name -NoNewLine -ForegroundColor 3
		} elseif (Test-Path $path -PathType Leaf -Include "*.exe") {
			Write-Host $name -NoNewLine -ForegroundColor 2
		} else {
			Write-Host $name -NoNewLine
		}
		$cnt++
		_nextStep $cnt $name.Length
	}
}

# TODO: Customize "ll" as Mac OS X
New-Alias -Name ll -Value Get-ChildItem

# Use "Ctrl+D" to exit PowerShell
Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function ViExit

# private function use in "ls"
function _nextStep($cnt, $nameLength) {
	if($maxLength -gt 40) {
		Write-Host ""
	} elseif ($maxLength -gt 34) {
		if($cnt % 2 -eq 0) {
			Write-Host ""
		} else {
			Write-Host -NoNewLine (" " * (40 - $nameLength))
		}
	} elseif ($maxLength -gt 29) {
		if($cnt % 3 -eq 0) {
			Write-Host ""
		} else {
			Write-Host -NoNewLine (" " * (34 - $nameLength))
		}
	} elseif ($maxLength -gt 24) {
		if($cnt % 3 -eq 0) {
			Write-Host ""
		} else {
			Write-Host -NoNewLine (" " * (29 - $nameLength))
		}
	} elseif ($maxLength -gt 19) {
		if($cnt % 4 -eq 0) {
			Write-Host ""
		} else {
			Write-Host -NoNewLine (" " * (24 - $nameLength))
		}
	} elseif ($maxLength -gt 14) {
		if($cnt % 5 -eq 0) {
			Write-Host ""
		} else {
			Write-Host -NoNewLine (" " * (19 - $nameLength))
		}
	} else {
		if($cnt % 6 -eq 0) {
			Write-Host ""
		} else {
			Write-Host -NoNewLine (" " * (14 - $nameLength))
		}
	}
}

# Add spectifc directory to user's PATH environment variable.
function Add-Path([string] $value) {
    if(-not $value) {
        Write-Host "Add-Path: Usage: Add-Path <value>"
        Write-Host
        Write-Host "Add-Path: Example: Add-Path `"C:\Program Files\Java\jdk1.8.0_144\bin`""
        return
    }
    if(-not (Test-Path $value)) {
        Write-Host "Add-Path: Path `"$value`" not exist"
        return
    }
    $value = [System.IO.Path]::GetFullPath($value)
    $userEnv = Reg Query HKCU\Environment
    $success = $false
    foreach ($key in $userEnv) {
        # Split "  Path REG_EXPAND_SZ    ..."
        # Because of the space in environment variable ,like "C:\Program Files", the split will return 4 items
        $key = $key -Split "\s+",4
        if($key[1] -eq "Path") {
            $curr = $key[3]
            $new = $curr + ";" + $value
            Reg Add HKCU\Environment /v Path /t REG_EXPAND_SZ /d $new /f
            Write-Host "Add $value to Path Success"
            $success = $true
            break
        }
    }
    if(-not $success) {
        Write-Host "Add $value to Path Failed"
    }
}