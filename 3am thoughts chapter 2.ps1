Set-StrictMode -Version Latest
$Host.UI.RawUI.WindowTitle = "3am thoughts chapter 2 -P1"

$State = @{
    PlayerName = "Adam"
    Chill      = 0
    Project    = 0
    Chapter    = 1
}

function Write-Dialogue {
    param(
        [Parameter(Mandatory)]
        [string]$Speaker,

        [Parameter(Mandatory)]
        [string]$Text,

        [ConsoleColor]$Color = [ConsoleColor]::White,

        [int]$SpeedMs = 20
    )
    Write-Host "`n[$Speaker]" -ForegroundColor $Color
    foreach ($char in $Text.ToCharArray()) {
        Write-Host -NoNewline $char
        Start-Sleep -Milliseconds $SpeedMs
    }
    Write-Host ""
}

function Get-Choice {
    param(
        [Parameter(Mandatory)]
        [string[]]$Options
    )
    Write-Host ""
    for ($i = 0; $i -lt $Options.Count; $i++) {
        Write-Host "  $($i + 1). $($Options[$i])" -ForegroundColor Gray
    }
    do {
        $pick = Read-Host "`nChoose (1-$($Options.Count))"
    } until (($pick -as [int]) -and [int]$pick -ge 1 -and [int]$pick -le $Options.Count)
    return [int]$pick
}

$Scene = "Start"

while ($Scene -ne "Exit") {
    Clear-Host
    switch ($Scene) {
        "Start" {
            Write-Dialogue -Speaker "Brain" -Text "Mann Last night 3am was holy work done now lets start working on the hackathon but let us revise" -Color Blue
            $name = Read-Host "`nEnter your name (Enter for Adam)"
            if (-not [string]::IsNullOrWhiteSpace($name)) {
                $State.PlayerName = $name.Trim()
            }
            $Scene = "begin"
        }
        "begin"{



        }


    }
}