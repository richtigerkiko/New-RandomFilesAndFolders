function New-RandomFilesAndFolders {
    <#
    .SYNOPSIS
    Generates a dummy folderstructure with given Depth
    
    .DESCRIPTION
    This function generates a structure of folders and files with a given depth. For simplicity, every random string is some kind of GUID.
    
    .PARAMETER Path
    Starting Path of dummy structure
    
    .PARAMETER Depth
    Depth of folder structure, Default = 5
    
    .PARAMETER OnlyFolders
    If switch is on, no files are beeing generated
    
    .PARAMETER FixedFolderCount
    If switch is on, every Folder has MaxFolderCount folders in it
    
    .PARAMETER MinFolderCount
    Min folders per Level (Default = 3)
    
    .PARAMETER MaxFolderCount
    Max folders per Level (Default = 5)
    
    .PARAMETER MinFileCount
    Min files per Level (Default = 3)
    
    .PARAMETER MaxFileCount
    Max files per Level (Default = 5)
    
    .EXAMPLE
    An example
    
    .NOTES
        Version:        1.0

        Author:         Alexander Kiko

        Creation Date:  04.09.2019

        Purpose/Change: Initial script development

    #>
    
        PARAM(
            [Parameter(Mandatory = $false)][string]$Path = (get-location).Path,
            [Parameter(Mandatory = $false)][int]$Depth = 5,
            [Parameter(Mandatory = $false)][Switch]$OnlyFolders,
            [Parameter(Mandatory = $false)][Switch]$FixedFolderCount,
            [Parameter(Mandatory = $false)][int]$MinFolderCount = 3,
            [Parameter(Mandatory = $false)][int]$MaxFolderCount = 5,
            [Parameter(Mandatory = $false)][int]$MinFileCount = 3,
            [Parameter(Mandatory = $false)][int]$MaxFileCount = 5
        )
    
    
        Begin{
            
            # Functions
    
            function GenerateRandomText(){
                # This function generates sudo-random text with GUIDs
    
                $content = ""
                $numberOfGuids = Get-Random -Minimum 2 -Maximum 20
    
                for($i = 0; $i -lt $numberOfGuids; $i++){
                    $content += (New-Guid).ToString()
                }
    
                return $content
            }
    
            function GenerateGuidString($length){
                # Helperfunction to get File/Foldernames
                return  (New-Guid).ToString().Replace("-","").SubString(0,$length)
            }
    
            function GenerateRandomFilesAndFolders($path){
                # This function generates a random amount of files and folders
    
                $folderCount = $MaxFolderCount
                if(!$FixedFolderCount){
                    $folderCount = Get-Random -Minimum $MinFolderCount -Maximum $MaxFolderCount
                }
    
                for ($i = 0; $i -lt $folderCount; $i++){
                    $folderName =   GenerateGuidString 5
                    New-Item ($path + "\" + $folderName) -ItemType "Directory"
                }
            
                
                if(!$OnlyFolders){
                    $fileCount = Get-Random -Minimum $MinFileCount -Maximum $MaxFileCount
    
                    for ($i = 0; $i -lt $fileCount; $i++){
                        $fileName = GenerateGuidString 5
                        $fileContent = GenerateRandomText     
                        New-Item ($path + "\" + $fileName + ".txt") -ItemType "File" -Value $fileContent
                    }
                }
            }
    
            function GenerateDirsRecursive($thisPath, $currentdepth){
    
    
                if($currentdepth -lt $Depth){
                    GenerateRandomFilesAndFolders $thisPath
    
                    $currentdepth++
    
                    foreach ($folder in Get-ChildItem $thisPath -Directory){
                        GenerateDirsRecursive $folder.FullName ($currentdepth)
                    }
                }
            }
        }
    
        Process{
    
            if($Depth -gt 5){
                Write-Host "Folderstructures bigger than 5, this might take a while"
                $confirmation = Read-Host "Want to Continue? (Y/N)"
                if($confirmation -ne 'y'){
                    break
                }
            }
    
            GenerateDirsRecursive $Path 0
        }
    }
    