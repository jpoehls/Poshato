function Invoke-HgImport([string]$Path) {
<#
.SYNOPSIS
  Applies the given patch/diff file on the working directory.

.EXAMPLE
  Hg-Import changes.diff
  # equivelant to: hg import --no-commit changes.diff
#>
  hg --encoding utf8 --color never import --no-commit $Path
}


function Invoke-HgExport([string]$Path) {
<#
.SYNOPSIS
  Exports all uncommitted changes in the current HG repository
  to a git formatted diff file at the specified path.
  
  The resultant diff file can be re-imported into a repo using: hg import changes.diff

.EXAMPLE
  Hg-Export changes.diff
  # equivelant to: hg diff --git | Out-File changes.diff -Encoding ASCII; hg diff --stat
#>

  hg --encoding utf8 --color never diff --git | Out-File $Path -Encoding UTF8
  hg diff --stat
}

function Invoke-HgExportBranchDiff([string]$Branch, [string]$ParentBranch, [string]$Path) {
<#
.SYNOPSIS
    Exports a diff of all changes made in the Branch,
    excluding changesets from the ParentBranch to a git
    formatted diff file at the specified Path.

.EXAMPLE
    Hg-ExportBranchDiff 'feature-branch' 'release-branch' changes.diff
    # equivelant to: hg diff --git --rev "max(ancestors(feature-branch) and branch(release-branch)):feature-branch"
#>
    # Inspired by http://stackoverflow.com/a/10424821/31308
    hg --encoding utf8 --color never diff --git --rev "max(ancestors($Branch) and branch($ParentBranch)):$Branch" | Out-File $Path -Encoding UTF8
    hg diff --stat --rev "max(ancestors($Branch) and branch($ParentBranch)):$Branch"
}

function Get-HgRoot {
<#
.SYNOPSIS
    Walks up from the current directory and returns the path of the first folder that contains a '.hg' sub-folder.
#>
    param (
        [string]$Path = (Get-Location).Path
    )

    $p = (Resolve-Path $Path).Path

    if (Test-Path (Join-Path $p '.hg') -PathType Container) {
        return $p
    } 
  
    # walk up from the current directory until we find a .hg dir
  
    while ($p -ne $null) {
        $pathToTest = Split-Path $p -Parent
        if ($pathToTest) {
            if ((Test-Path (Join-Path $pathToTest '.hg') -PathType Container) -eq $true) {
                return $pathToTest
            } else {
                $p = Split-Path $p -Parent
            }
        }
        else {
            break
        }
    }
    
    throw "not an hg repo: $Path"
}

function Get-HgPaths {
<#
.SYNOPSIS
    Gets a hash map of the output of `hg paths`.
#>
    param (
        [string]$Path = (Get-Location).Path
    )

    $Path = (Resolve-Path $Path).Path

    $map = @{}

    $stdout = hg --encoding utf8 --color never --repository "`"$Path`"" paths
    if ($stdout -and $LASTEXITCODE -eq 0) {
        $stdout = $stdout.Split([Environment]::NewLine, [StringSplitOptions]::RemoveEmptyEntries)
        foreach ($line in $stdout) {
            $name = $line.Substring(0, $line.IndexOf('=') - 1)
            $url = $line.Substring($line.IndexOf('=') + 2)
            $map[$name] = $url
        }
    }
    
    return $map
}

function globify([string]$text) {
    $b = New-Object System.Text.StringBuilder
    if ($input)
    {    
        foreach ($c in $text.ToCharArray()) {
            if ([char]::IsLetter($c)) 
            {
                $b.Append("[" + [char]::ToLowerInvariant($c) + [char]::ToUpperInvariant($c) + "]") | Out-Null
            }
            else
            {
                $b.Append($c) | Out-Null
            }
        }
    }

    return $b.ToString()
}

function Get-HgParent {
<#
.SYNOPSIS
    Gets the branch and revision number of specified working directory or file.
#>
    param (
        [string]$Path = (Get-Location).Path
    )

    $Path = (Resolve-Path $Path).Path

    $map = @{
        "branch" = "";
        "revision" = "";
    }
    
    $ok = $true

    if (Test-Path $Path -PathType Container) {
        $stdout = hg --encoding utf8 --color never identify
        if ($stdout -and $LASTEXITCODE -eq 0) {
            $shortrev = $stdout.Split(' ')[0].TrimEnd('+')
            $stdout = hg --encoding utf8 --color never log --template='{branch}\n{node}\n' -r $shortrev
            if ($LASTEXITCODE -ne 0) {
                $ok = $false
            }
        }
        else {
            $ok = $false
        }
    }
    else {
        $stdout = hg --encoding utf8 --color never parents --template='{branch}\n{node}\n' `"$(globify (Resolve-Path -Relative $Path))`"
        if ($LASTEXITCODE -ne 0) {
            $ok = $false
        }
    }

    if ($ok) {
        $stdout = $stdout.Split([Environment]::NewLine, [StringSplitOptions]::RemoveEmptyEntries)
        for ($i=0; $i -lt $stdout.Length; $i++) {
            if ($i -eq 0) {
                $map["branch"] = $stdout[$i]
            }
            elseif ($i -eq 1) {
                $map["revision"] = $stdout[$i]
            }
        }
    }

    return $map
}

function Get-HgRelativePath {
<#
.SYNOPSIS
    Gets the relative path of the specified file within the repository working directory.
#>
    param (
        [string]$Path = (Get-Location).Path
    )

    $Path = Resolve-ExactPath $Path
    
    $hgroot = Get-HgRoot -Path $Path
    Push-Location $hgroot
    try {
        $rel = Resolve-Path -Relative $Path
        if ($rel -eq "..\$(Split-Path $hgroot -Leaf)") {
            $rel = ".\"
        }
        return $rel
    }
    finally {
        Pop-Location
    }
}

Export-ModuleMember -Function Invoke-HgImport, Invoke-HgExport, Get-HgRoot, Get-HgPaths, Get-HgParent, Get-HgRelativePath, Invoke-HgExportBranchDiff