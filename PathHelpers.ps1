function Get-Directory([string]$Path) {
<#
.SYNOPSIS
  Gets the directory portion of the given path.
#>

  return [IO.Path]::GetDirectoryName($Path)
}

function Get-ShortPath([string] $Path) { 
<#
http://winterdom.com/2008/08/mypowershellprompt
#>
   $loc = $Path.Replace($HOME, '~') 
   # remove prefix for UNC paths 
   $loc = $loc -replace '^[^:]+::', '' 
   # make path shorter like tabs in Vim, 
   # handle paths starting with \\ and . correctly 
   return ($loc -replace '\\(\.?)([^\\])[^\\]*(?=\\)','\$1$2') 
}

function Get-ScriptPath {
<#
.SYNOPSIS
  Gets the directory path of the currently executing script.
  Returns $PWD.Path if $myInvocation.ScriptName is $null.
#>
  if ($myInvocation.ScriptName) {
    Split-Path $myInvocation.ScriptName
  } else {
    $pwd.Path
  }
}

function Resolve-ExactPath([string]$Path, [switch]$Relative) {
<#
.SYNOPSIS
    Uses `Resolve-Path -LiteralPath` to resolve the path and then ensures that
    the result path's casing matches the file system's casing.
#>

    $Path = (Resolve-Path -LiteralPath $Path).Path
    
    $exactPath = ""
    $parts = $Path.Split(@([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar))

    foreach ($p in $parts)
    {
        if ($exactPath.Length -gt 0) { $exactPath += [System.IO.Path]::DirectorySeparatorChar.ToString() }
        if (([string]::IsNullOrEmpty($p)) -or $exactPath.Length -eq 0) {
            $exactPath += $p
        }
        else
        {
            $exactPath = [System.IO.Directory]::GetFileSystemEntries($exactPath, $p)[0]
        }
    }

    if ($Relative) {
        return Resolve-Path -Relative -LiteralPath $exactPath
    }
    else {
        return $exactPath
    }
}