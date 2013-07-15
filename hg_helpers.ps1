function Hg-Import([string]$Path) {
<#
.SYNOPSIS
  Applies the given patch/diff file on the working directory.

.EXAMPLE
  Hg-Import changes.diff
  # equivelant to: hg import --no-commit changes.diff
#>
  hg import --no-commit $Path
}


function Hg-Export([string]$Path) {
<#
.SYNOPSIS
  Exports all uncommitted changes in the current HG repository
  to a git formatted diff file at the specified path.
  
  The resultant diff file can be re-imported into a repo using: hg import changes.diff

.EXAMPLE
  Hg-Export changes.diff
  # equivelant to: hg diff --git | Out-File changes.diff -Encoding ASCII; hg diff --stat
#>

  hg diff --git | Out-File $Path -Encoding UTF8
  hg diff --stat
}