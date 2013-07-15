#
# Module manifest for module 'Poshato'
#
# Generated by: Joshua Poehls
#
# Generated on: 7/14/2013
#

@{

# Script module or binary module file associated with this manifest
#RootModule = ''

# Version number of this module.
ModuleVersion = '1.0.0'

# ID used to uniquely identify this module
GUID = '3e73e643-1115-4b14-8baf-0cf96da2abec'

# Author of this module
Author = 'Joshua Poehls'

# Company or vendor of this module
CompanyName = 'Unknown'

# Copyright statement for this module
Copyright = '(c) 2013 Joshua Poehls. All rights reserved.'

# Description of the functionality provided by this module
# Description = ''

# Minimum version of the Windows PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of the .NET Framework required by this module
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module
#ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @(
				  ".\benchmark.psm1",
				  ".\bookmarks.psm1",
				  ".\Elevate-Process.ps1",
				  ".\encoding-helpers.ps1",
                  ".\Get-Uptime.ps1",
				  ".\hg_helpers.ps1",
				  ".\mklink.psm1",
				  ".\notes.ps1",
				  ".\PathHelpers.ps1",
				  ".\speech.ps1",
				  ".\svn_helpers.ps1")

# Functions to export from this module
FunctionsToExport = '*'

# Cmdlets to export from this module
CmdletsToExport = '*'

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module
AliasesToExport = '*'

# Commands to export from this module as Workflows
# ExportAsWorkflow = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess
# PrivateData = ''

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}