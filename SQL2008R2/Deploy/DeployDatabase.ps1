# Get the SQL Server Parameters
param([string] $dbInstance=(Read-Host -prompt "Please Enter SQL Server Instance"),[string] $dbName=(Read-Host -prompt "Please Enter Database Name"))


[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
$dbServer = new-object Microsoft.SqlServer.Management.Smo.Server ($dbInstance)
$db = new-object Microsoft.SqlServer.Management.Smo.Database


# Loop thru the db list to see if it already exists. If found, End Session and Exit with Error

foreach ($_ in $dbServer.Databases)
{
        if ($_.Name -eq $dbName)
        {
            $db = $_
            "Error : Database Already Exists "
            Exit
        }
}

<# Create Database #>

"Creating database $dbName..."
$db = new-object Microsoft.SqlServer.Management.Smo.Database ($dbServer, $dbName)
$db.Create()