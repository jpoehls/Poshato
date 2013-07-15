$_notes = "$dropbox\Drafts\Notes"

Set-Bookmark n $_notes

function Get-Notes() {
  # list all notes
  ls $_notes
}

function New-Note($name) {
  pushd $_notes

  if ($name -eq $null) {
    $name = "temp"
  }

  $name = (Join-Path $_notes ($name + ".md"))
  
  # open note in sublime
  subl $name

  popd
}
Set-Alias n "New-Note"