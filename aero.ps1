function Enable-Aero {
<#
.SYNOPSIS
    Forces the Aero system service to stop and start.
    Useful for fixing issues with Aero not being enabled
    when it should be.

.NOTES
    Author: Joshua Poehls
    Inspired by http://www.ihackintosh.com/2009/01/how-to-enable-aero-effect-in-windows-7-by-simple-registry-tweak/
#>

    net stop uxsms
    net start uxsms
}
Set-Alias fixaero Enable-Aero