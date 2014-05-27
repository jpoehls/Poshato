function Get-PhabricatorRepoBaseUrl {
<#
.SYNOPSIS
    Gets the phabricator URL associated with the HG repo of the current folder.
#>
    $hgpaths = Get-HgPaths
    $defaultpath = $hgpaths['default']

    if ($defaultpath) {
        # Trim the last part of the URL. i.e. "https://code.interworks.com/diffusion/EDT/enterprise-deployment-tool" -> "https://code.interworks.com/diffusion/EDT"
        $defaultpath = $defaultpath.TrimEnd('/')
        $url = $defaultpath.Substring(0, $defaultpath.LastIndexOf('/'))
        return $url
    }
    else {
        throw "hg repo doesn't have a default path"
    }
}

function Invoke-Phabricator {
<#
.SYNOPSIS
    Launches phabricator to browse the current directory (default) or specified file.
#>
    param (
    [string]$Path = (Get-Location).Path,
    [string]$Line = $null
    )

    $phabUrl = Get-PhabricatorRepoBaseUrl
    $hgparent = Get-HgParent -Path $Path

    $reporelpath = Get-HgRelativePath $Path

    if (Test-Path $Path -PathType Container) {
        $reporelpath += '\'
    }

    $branch = $hgparent["branch"]
    $revision = $hgparent["revision"]

    $builder = new-object System.UriBuilder -ArgumentList @($phabUrl)
    $builder.Path += "/browse/$branch/" + $reporelpath.TrimStart('.\').Replace('\','/') + ";$revision"

    if ($Line) {
        $builder.Path += "`$$Line"
    }

    Write-Output $builder.ToString()
    start $builder.ToString()
}

Export-ModuleMember -Function Invoke-Phabricator