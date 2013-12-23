function Test-ZipFile
{
<#
.SYNOPSIS
    Tests for the magic ZIP file header bytes.

.DESCRIPTION
    Inspired by http://stackoverflow.com/a/1887113/31308
#>
	[CmdletBinding()]
	param(
		[Parameter(
			ParameterSetName  = "Path",
            Position = 0,
            Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true
		)]
		[string[]]$Path,

        [Alias("PSPath")]
		[Parameter(
			ParameterSetName = "LiteralPath",
            Mandatory = $true,
			ValueFromPipelineByPropertyName = $true
		)]
		[string[]]$LiteralPath
	)

    process {
        # Only expand wildcards if the -Path parameter was used.
        if ($PSCmdlet.ParameterSetName -eq "Path") {
            $filePaths = Resolve-Path -Path $Path -ErrorAction SilentlyContinue |
                         select -ExpandProperty Path
        }
        elseif ($PSCmdlet.ParameterSetName -eq "LiteralPath") {
            $filePaths = $PSCmdlet.GetUnresolvedProviderPathFromPSPath($LiteralPath)
        }
        
        foreach ($filePath in $filePaths) {
            $isZip = $false

            if (Test-Path -LiteralPath $filePath -PathType Leaf) {
	            try {
	                $stream = New-Object System.IO.StreamReader -ArgumentList @($filePath)
	                $reader = New-Object System.IO.BinaryReader -ArgumentList @($stream.BaseStream)
	                $bytes = $reader.ReadBytes(4)
	                if ($bytes.Length -eq 4) {
	                    if ($bytes[0] -eq 80 -and
	                        $bytes[1] -eq 75 -and
	                        $bytes[2] -eq 3 -and
	                        $bytes[3] -eq 4) {
	                        $isZip = $true
	                    }
	                }
	            }
	            finally {
	                if ($reader) {
	                    $reader.Dispose()
	                }
	                if ($stream) {
	                    $stream.Dispose()
	                }
	            }
            }

            Write-Output $isZip
        }
    }
}