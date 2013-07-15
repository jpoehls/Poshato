function Get-Directory([string]$Path) {
<#
.SYNOPSIS
  Gets the directory portion of the given path.
#>

  return [IO.Path]::GetDirectoryName($Path)

}

function Shorten-Path([string] $Path) { 
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