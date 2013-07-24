function Invoke-SvnTortoise([string]$Command = "commit") {
<#
.SYNOPSIS
  Launches TortoiseSVN with the given command.
  Opens the commit screen if no command is given.
  
  List of supported commands can be found at:
  http://tortoisesvn.net/docs/release/TortoiseSVN_en/tsvn-automation.html
#>
  TortoiseProc.exe /command:$Command /path:"$pwd"
}
Set-Alias tsvn "Svn-Tortoise"