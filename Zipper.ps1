#------ This part creates a Function that will retrieve the documents to put in ZIP. ------
function Compress-Subfolders
{
    param
    (
        [Parameter(Mandatory = $true)][string] $InputFolder,
        [Parameter(Mandatory = $true)][string] $OutputFolder
    )

    $subfolders = Get-ChildItem $InputFolder | Where-Object { $_.PSIsContainer }

    ForEach ($s in $subfolders) 
    {
        $path = $s 
        write-host("-----------" + $s)
        $path
        #Set-Location $path.FullName
        $fullpath = $path.FullName
        $pathName = $path.BaseName

        #Get all items 
        #$items = Get-ChildItem

        $zipname = $path.name + ".zip"
        $zippath = $outputfolder + $zipname
        $t = ($path.FullName.replace("[","``[").replace("]","``]") )

        Compress-Archive -Path $t -DestinationPath $zippath
        write-host("-----------+" + $t)
    }
}
#------ This line will allow to execute the ZIP of the files. ------

#                                   original file                    Destination File
Compress-Subfolders -InputFolder "c:\YourDirectory\*" -OutputFolder "C:\YourDirectory\"

#___________ For my test ___________

#$s = $subfolders[2]
#$d = $s.FullName.Replace("[","`[").Replace("]","`]")
