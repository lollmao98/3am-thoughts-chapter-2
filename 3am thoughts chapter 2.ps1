Set-StrictMode -Version Latest
$Host.UI.RawUI.WindowTitle = "3am thoughts chapter 2 -P1"

$State = @{
    PlayerName = "Adam"
    Chill      = 0
    Project    = 0
    Chapter    = 1
}

function Clear-KeyBuffer {
    try {
        while ([Console]::KeyAvailable) {
            $null = [Console]::ReadKey($true)
        }
    }
    catch { }
}

function Wait-Continue {
    param(
        [double]$DelaySeconds = 1.5,
        [string]$Prompt = "Press Enter to continue"
    )

    Clear-KeyBuffer
    $milliseconds = [int]([Math]::Max(0, $DelaySeconds * 1000))
    if ($milliseconds -gt 0) {
        Write-Host "`n(Wait ${DelaySeconds}s...)" -ForegroundColor Blue
        Start-Sleep -Milliseconds $milliseconds
        Clear-KeyBuffer
    }

    $null = Read-Host "`n$Prompt"
}

function Write-Dialogue {
    param(
        [Parameter(Mandatory)]
        [string]$Speaker,

        [Parameter(Mandatory)]
        [string]$Text,

        [ConsoleColor]$Color = [ConsoleColor]::Blue,

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
        Write-Host "  $($i + 1). $($Options[$i])" -ForegroundColor Green
    }
    do {
        $pick = Read-Host "`nChoose (1-$($Options.Count))"
    } until (($pick -as [int]) -and [int]$pick -ge 1 -and [int]$pick -le $Options.Count)
    return [int]$pick
}

function Invoke-EnterMash {
    param(
        [int]$Seconds = 5,
        [string]$Prompt = "Mash ENTER to huss!"
    )

    $count = 0
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $lastSecondShown = -1
    $canPollKeys = $true

    Write-Host "`n$Prompt ($Seconds seconds)" -ForegroundColor Green

    while ($stopwatch.Elapsed.TotalSeconds -lt $Seconds) {
        $remaining = [Math]::Ceiling($Seconds - $stopwatch.Elapsed.TotalSeconds)
        if ($remaining -lt 1) { $remaining = 1 }

        if ($remaining -ne $lastSecondShown) {
            $lastSecondShown = $remaining
            Write-Host "`rTime left: ${remaining}s | Enters: $count   " -NoNewline -ForegroundColor Blue
        }

        if ($canPollKeys) {
            try {
                if ([Console]::KeyAvailable) {
                    $key = [Console]::ReadKey($true)
                    if ($key.Key -eq [ConsoleKey]::Enter) {
                        $count++
                        Write-Host "`rTime left: ${remaining}s | Enters: $count   " -NoNewline -ForegroundColor Green
                    }
                }
            }
            catch {
                $canPollKeys = $false
            }
        }

        Start-Sleep -Milliseconds 25
    }

    $stopwatch.Stop()
    Clear-KeyBuffer

    Write-Host "`nTime's up! Total Enters: $count" -ForegroundColor Green
    Wait-Continue -DelaySeconds 1.5 -Prompt "Press Enter to continue"
    return $count
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

        "begin" {
            Write-Dialogue -Speaker "Brain" -Text "In this town every body is asleep except you. (Press Enter to huss)" -Color Blue
            $hussCount = Invoke-EnterMash -Seconds 5 -Prompt "Press ENTER to huss!"
            Write-Dialogue -Speaker "Brain" -Text "$($State.PlayerName). You Hussed $hussCount times." -Color Green
            Wait-Continue -DelaySeconds 1.5 -Prompt "Press Enter to continue"

            if ($hussCount -gt 30) {
                $State.Chill += 10
                $State.Project += 20
                Write-Dialogue -Speaker "Brain" -Text "Holly husser you knocked down 20 percent of our work" -Color Blue
                Wait-Continue -DelaySeconds 1.5 -Prompt "Press Enter to continue"
            }
            else {
                $State.Project += 5
                Write-Dialogue -Speaker "Brain" -Text "pshht rookie husser even a child is better (5 percent done)" -Color Blue
                Wait-Continue -DelaySeconds 1.5 -Prompt "Press Enter to continue"
            }

            if ($State.Project -gt 100) {
                $State.Project = 100
            }

            $Scene = "e"
        }

        "e" {
            Write-Dialogue -Speaker "Brain" -Text "Final Stats - Chill: $($State.Chill) | Project: $($State.Project)%" -Color Green
            Wait-Continue -DelaySeconds 1.5 -Prompt "Press Enter to end program"
            $Scene = "Exit"
        }

        default {
            $Scene = "Exit"
        }
    }
}