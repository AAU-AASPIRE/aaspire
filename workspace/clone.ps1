# Clone every AASPIRE repository side by side, into the folder above this repository (AAU-AASPIRE),
# and install the Python parts editable into the current environment:
#   .\workspace\clone.ps1             # clone what is missing
#   .\workspace\clone.ps1 -Install    # ... and pip install -e every Python part
param([switch]$Install)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$names = Get-Content (Join-Path $PSScriptRoot 'repositories.txt') | Where-Object { $_ -notmatch '^\s*#' -and $_.Trim() } |
    ForEach-Object { ($_ -split '\s+')[0] }
foreach ($name in $names) {
    $dir = Join-Path $root $name
    if (Test-Path -LiteralPath (Join-Path $dir '.git')) { "${name}: there"; continue }
    git clone "https://github.com/AAU-AASPIRE/$name.git" $dir
    if ($LASTEXITCODE -ne 0) { throw "clone of $name failed" }
}
if ($Install) {
    # In dependency order; each with its tests' extras.
    foreach ($name in 'iec61499-mgmt-py', 'iec61499-skill-lib', 'modlink', 'modsync', 'modplan', 'modreg', 'module-py', 'AAS-MAS') {
        python -m pip install --no-deps -e (Join-Path $root $name)
        if ($LASTEXITCODE -ne 0) { throw "pip install of $name failed" }
    }
}
