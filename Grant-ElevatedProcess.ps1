function Grant-ElevatedProcess
{
<#
.SYNOPSIS
  Runs a process as administrator. Stolen from http://weestro.blogspot.com/2009/08/sudo-for-powershell.html.
#>
    $file, [string]$arguments = $args
    $psi = New-Object System.Diagnostics.ProcessStartInfo $file
    $psi.Arguments = $arguments
    $psi.Verb = "runas"
    $psi.WorkingDirectory = Get-Location
    [System.Diagnostics.Process]::Start($psi) | Out-Null
}

Set-Alias sudo Grant-ElevatedProcess