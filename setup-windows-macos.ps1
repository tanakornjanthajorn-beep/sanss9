<#
Setup script for macOS-like appearance on Windows 11.
- Default behavior: download installers to $HOME\Downloads\macos-style-setup
- With -Install switch: will attempt to run installers (requires admin / UAC)
Please review before running.
#>

param(
    [switch]$Install
)

function Test-Admin {
    $current = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $current.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

$OutDir = Join-Path $env:USERPROFILE "Downloads\macos-style-setup"
if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }

Write-Host "ดาวน์โหลดตัวติดตั้งจะถูกเก็บที่: $OutDir" -ForegroundColor Cyan

# Helper: get latest release asset download URL by file pattern from GitHub
function Get-LatestReleaseAssetUrl($owner, $repo, $pattern) {
    $api = "https://api.github.com/repos/$owner/$repo/releases/latest"
    try {
        $headers = @{ "User-Agent" = "Windows-PowerShell" }
        $rel = Invoke-RestMethod -Uri $api -Headers $headers -UseBasicParsing
        foreach ($asset in $rel.assets) {
            if ($asset.name -match $pattern) {
                return $asset.browser_download_url
            }
        }
        return $null
    } catch {
        Write-Warning "ไม่สามารถเข้าถึง GitHub API สำหรับ $owner/$repo : $_"
        return $null
    }
}

$itemsToGet = @(
    @{ name="PowerToys"; owner="microsoft"; repo="PowerToys"; pattern=".*PowerToysSetup.*\.exe$" },
    @{ name="ExplorerPatcher"; owner="valinet"; repo="ExplorerPatcher"; pattern=".*ExplorerPatcher.*\.(msi|exe)$" },
    @{ name="RoundedTB"; owner="Team84"; repo="RoundedTB"; pattern=".*RoundedTB.*\.(exe|msi)$" },
    @{ name="Rainmeter"; owner="rainmeter"; repo="rainmeter"; pattern=".*Rainmeter.*\.exe$" }
)

$downloads = @()

foreach ($item in $itemsToGet) {
    Write-Host "ค้นหา release ล่าสุดสำหรับ $($item.name)..." -ForegroundColor Yellow
    $url = Get-LatestReleaseAssetUrl $item.owner $item.repo $item.pattern
    if ($url) {
        $fileName = Split-Path $url -Leaf
        $outPath = Join-Path $OutDir $fileName
        Write-Host "ดาวน์โหลด $fileName ..." -ForegroundColor Green
        try {
            Invoke-WebRequest -Uri $url -OutFile $outPath -UseBasicParsing -Headers @{ "User-Agent" = "Windows-PowerShell" }
            $downloads += $outPath
        } catch {
            Write-Warning "ดาวน์โหลดล้มเหลว: $url"
        }
    } else {
        Write-Warning "ไม่พบ asset ตรงตาม pattern สำหรับ $($item.name). โปรดดาวน์โหลดด้วยตนเองจาก release page."
        $downloads += "MANUAL: $($item.name) => https://github.com/$($item.owner)/$($item.repo)/releases"
    }
}

# Winstep Nexus: ขอให้ผู้ใช้ดาวน์โหลดเอง (ไม่อยู่ใน GitHub)
$downloads += "MANUAL: Winstep Nexus (Dock) => https://www.winstep.net/nexus.asp"
$downloads += "MANUAL: macOS icon packs / cursors => ค้นหาใน https://www.deviantart.com หรือ https://www.wincustomize.com/"

Write-Host ""
Write-Host "สรุปรายการที่ดาวน์โหลด/แนะนำให้ดาวน์โหลด:" -ForegroundColor Cyan
$downloads | ForEach-Object { Write-Host " - $_" }

if ($Install) {
    if (-not (Test-Admin)) {
        Write-Warning "การติดตั้งอัตโนมัติต้องรัน PowerShell ด้วยสิทธิ์ Administrator. กรุณาเปิด PowerShell as Administrator และรันสคริปต์อีกครั้งด้วย -Install"
        exit 1
    }
    foreach ($item in $downloads) {
        if ($item -like "MANUAL:*") {
            Write-Host "ไฟล์/manual link: $item" -ForegroundColor Yellow
            continue
        }
        Write-Host "กำลังรันตัวติดตั้ง: $item" -ForegroundColor Green
        try {
            Start-Process -FilePath $item -Wait
        } catch {
            Write-Warning "การรันตัวติดตั้งล้มเหลวสำหรับ $item : $_"
        }
    }
    Write-Host "การติดตั้งเสร็จสิ้น (ถ้าไม่มี error) — โปรดทำตาม CHECKLIST.md เพื่อการตั้งค่าต่อ" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "ถ้าต้องการให้สคริปต์รันติดตั้งอัตโนมัติ ให้รันสคริปต์อีกครั้งด้วย -Install (ต้องเปิด PowerShell as Administrator)" -ForegroundColor Magenta
    Write-Host "ตัวอย่าง: .\setup-windows-macos.ps1 -Install" -ForegroundColor Magenta
}

Write-Host ""
Write-Host "เสร็จสิ้นขั้นตอนดาวน์โหลด — อ่าน CHECKLIST.md เพื่อดำเนินการปรับแต่งต่อ" -ForegroundColor Green
