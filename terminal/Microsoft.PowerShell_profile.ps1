chcp 65001
#Import-Module posh-git
#Import-Module oh-my-posh
#Import-Module PSColor
#Set-PoshPrompt powerlevel10k_rainbow
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\powerlevel10k_rainbow.omp.json" | Invoke-Expression

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
