# set encoding UTF-8
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# ========================================== Prompt ==========================================
function prompt {
	Write-Host ("PS:$(Get-Location)>") -NoNewLine ` -ForegroundColor 2
	return " "
}

# ========================================== KeyBord Shortcuts ==========================================

# Use "Ctrl+D" to exit PowerShell
Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function ViExit

# ========================================== Aliases / Commands ==========================================

# "touch"
New-Alias -Name touch -Value New-Item

# "ifconfig"
New-Alias -Name ifconfig -Value ipconfig

# "vim"
New-Alias -Name vim -Value nvim

# "grep"
New-Alias -Name grep -Value findstr

# "ls"
Remove-Item Alias:ls
function ls ([string] $dir = ".") {
	_ListFile $dir $false
}

# "la"
function la ([string] $dir = ".") {
	_ListFile $dir $true
}

# "ll"
function ll ([string] $dir = ".") {
	# if dir ends with ":",like "ll C:"
	if($dir -match ":$") {
		# add "\" to the end of dir
		$dir = $dir + "\"
	}
	$files = Get-ChildItem -Path $dir
	Write-Host "Mode              LastWriteTime               Length   Name"
	Write-Host "----              -------------------         ------   ----"
	foreach ($file in $files) {
		$mode = $file.Mode.PadRight(18)
		$datetime = $file.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
		$length = IF ($file.Length -ne 1) { $file.Length.ToString().PadLeft(15) } ELSE { "".PadLeft(15) }
		$name = -Join("   " ,$file.Name)

		Write-Host $mode,$datetime,$length -Separator "" -NoNewLine
		
		$path = Join-Path $dir $file.Name
		if (Test-Path $path -PathType Container) {
			Write-Host $name -ForegroundColor 3
		} elseif (Test-Path $path -PathType Leaf -Include "*.exe") {
			Write-Host $name -ForegroundColor 2
		} else {
			Write-Host $name
		}
	}
}

# Add spectifc directory to user's PATH environment variable.
function Add-Path([string] $value) {
    if(-not $value) {
        Write-Host "Add-Path: Usage: Add-Path <value>"
        Write-Host
        Write-Host "Add-Path: Example: Add-Path `"C:\Program Files\Java\jdk1.8.0_144\bin`""
		Write-Host "Add-Path: Example: cd C:\Program Files\Java\jdk1.8.0_144\bin; Add-Path `".`""
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

# ========================================== Private Functions ==========================================

function _ListFile([string]$dir = ".",[bool]$showHidden) {
	# if dir ends with ":",like "ls C:"
	if($dir -match ":$") {
		# add "\" to the end of dir
		$dir = $dir + "\"
	}
	$names = (Get-ChildItem $dir).Name
	if(-not $showHidden) {
		$names = $names | Where-Object { $_ -notmatch "^[.].*" }
	}
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

# private function use in "_ListFile"
function _nextStep($cnt, $nameLength) {
	if($maxLength -gt 43) {
		Write-Host ""
	} elseif ($maxLength -gt 37) {
		if($cnt % 2 -eq 0) {
			Write-Host ""
		} else {
			Write-Host -NoNewLine (" " * (44 - $nameLength))
		}
	} elseif ($maxLength -gt 32) {
		if($cnt % 3 -eq 0) {
			Write-Host ""
		} else {
			Write-Host -NoNewLine (" " * (38 - $nameLength))
		}
	} elseif ($maxLength -gt 27) {
		if($cnt % 3 -eq 0) {
			Write-Host ""
		} else {
			Write-Host -NoNewLine (" " * (33 - $nameLength))
		}
	} elseif ($maxLength -gt 22) {
		if($cnt % 4 -eq 0) {
			Write-Host ""
		} else {
			Write-Host -NoNewLine (" " * (28 - $nameLength))
		}
	} elseif ($maxLength -gt 17) {
		if($cnt % 5 -eq 0) {
			Write-Host ""
		} else {
			Write-Host -NoNewLine (" " * (23 - $nameLength))
		}
	} else {
		if($cnt % 6 -eq 0) {
			Write-Host ""
		} else {
			Write-Host -NoNewLine (" " * (18 - $nameLength))
		}
	}
}