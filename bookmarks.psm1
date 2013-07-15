# holds hash of bookmarked locations
$_bookmarks = @{}

function Get-Bookmark() {
  Write-Output ($_bookmarks.GetEnumerator() | sort Name)
}

function Remove-Bookmark($key) {
<#
.SYNOPSIS
  Removes the bookmark with the given key.
#>
  if ($_bookmarks.keys -contains $key) {
    $_bookmarks.remove($key)
  }
}

function Clear-Bookmarks() {
<#
.SYNOPSIS
  Clears all bookmarks.
#>
  $_bookmarks.Clear()
}

function Set-Bookmark($key, $location) {
<#
.SYNOPSIS
  Bookmarks the given location or the current location (Get-Location).
#>
  # bookmark the current location if a specific path wasn't specified
  if ($location -eq $null) {
    $location = (Get-Location).Path
  }

  # make sure we haven't already bookmarked this location (no need to clutter things)
  if ($_bookmarks.values -contains $location) {
    Write-Warning ("Already bookmarked as: " + ($_bookmarks.keys | where { $_bookmarks[$_] -eq $location }))
    return
  }

  # if no specific key was specified then auto-set the key to the next bookmark number
  if ($key -eq $null) {
    $existingNumbers = ($_bookmarks.keys | Sort-Object -Descending | where { $_ -is [int] })
    if ($existingNumbers.length -gt 0) {
      $key = $existingNumbers[0] + 1
    }
    else {
      $key = 1
    }
  }

  $_bookmarks[$key] = $location
}

function Invoke-Bookmark($key) {
<#
.SYNOPSIS
  Goes to the location specified by the given bookmark.
#>
  if ([string]::IsNullOrEmpty($key)) {
    Get-Bookmarks
    return
  }

  if ($_bookmarks.keys -contains $key) {
    Push-Location $_bookmarks[$key]
  }
  else {
    Write-Warning "No bookmark set for the key: $key"
  }
}

Export-ModuleMember Get-Bookmark, Remove-Bookmark, Clear-Bookmarks, Set-Bookmark, Invoke-Bookmark