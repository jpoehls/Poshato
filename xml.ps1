function Get-XPath {
<#
.SYNOPSIS
    Gets an XPath to the specified XML Node.
    Example: "/root/people/person" or "/root/people/person/@name"

.PARAMETER Node
    Only supports Element and Attribute nodes.

.NOTES
    Author: Joshua Poehls
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [System.Xml.XmlNode]$Node
    )
    
    # PowerShell creates properties to represent attributes on element nodes so
    # we need to use PSBase to avoid any naming collisions.
    $nodeBase = $Node.PSBase

    $xpath = @()
    $parent = $null

    if ($nodeBase.NodeType -eq [System.Xml.XmlNodeType]::Attribute) {
        $xpath += "@" + $nodeBase.Name
        $parent = $nodeBase.OwnerElement
    }
    elseif ($nodeBase.NodeType -eq [System.Xml.XmlNodeType]::Element) {
        $xpath += $nodeBase.Name
        $parent = $nodeBase.ParentNode
    }
    else {
        throw "$($nodeBase.NodeType) nodes are not supported."
    }

    while ($parent -ne $null) {
        if ($parent.PSBase.Name -eq "#document") {
            # There can only be 1 document node and it should be the top-level
            # so we'll put an empty string to represent it for compactness.
            $xpath += ""
        }            
        else {
            $xpath += $parent.PSBase.Name
        }
        $parent = $parent.PSBase.ParentNode
    }

    [array]::Reverse($xpath)
    
    return [string]::Join("/", $xpath)
}