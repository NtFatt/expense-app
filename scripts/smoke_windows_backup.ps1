# Windows Backup Smoke - Screen-coordinate based approach
param(
    [string]$BackupDir = "$env:TEMP\smoke_backup_win7",
    [string]$ExportFileName = "expense_backup_win7.json",
    [int]$LaunchWait = 6
)

$ErrorActionPreference = "Continue"
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$exitCode = 0
$startTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$exePath = Join-Path $RepoRoot "build\windows\x64\runner\Release\expense_app.exe"
$exportFullPath = Join-Path $BackupDir $ExportFileName
$targetDir = Split-Path $exportFullPath -Parent

Write-Host "=== Windows Backup Smoke ===" -ForegroundColor Cyan
Write-Host "Start: $startTime"

# Cleanup
if (Test-Path $BackupDir) { Remove-Item -Path $BackupDir -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
Get-Process -Name "expense_app" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# Launch
Write-Host "`n[1] Launching expense_app.exe..."
$proc = Start-Process -FilePath $exePath -PassThru -WindowStyle Normal
Start-Sleep -Seconds $LaunchWait
if ($proc.HasExited) {
    Write-Host "[FATAL] App exited. Code: $($proc.ExitCode)" -ForegroundColor Red
    exit 1
}
Write-Host "[PASS] App launched. PID: $($proc.Id)" -ForegroundColor Green

# Get app window position
Write-Host "[2] Finding app window..."
Start-Sleep -Seconds 2

Add-Type @"
using System;
using System.Runtime.InteropServices;
using System.Drawing;
public class Win32 {
    [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc proc, IntPtr data);
    [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
    [DllImport("user32.dll")] public static extern int GetWindowText(IntPtr h, System.Text.StringBuilder sb, int n);
    [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT rc);
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
    [DllImport("user32.dll")] public static extern bool MoveWindow(IntPtr h, int x, int y, int w, int h, bool repaint);
    [DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr h, IntPtr after, int x, int y, int cx, int cy, uint flags);
    [StructLayout(LayoutKind.Sequential)] public struct RECT { public int Left, Top, Right, Bottom; }
    public delegate bool EnumProc(IntPtr h, IntPtr data);
}
"@

$appHwnd = [IntPtr]::Zero
Add-Type @"
using System;
using System.Runtime.InteropServices;
using System.Text;
public class FindHwnd {
    [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc proc, IntPtr data);
    [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
    [DllImport("user32.dll")] public static extern int GetWindowText(IntPtr h, StringBuilder sb, int n);
    [DllImport("user32.dll")] public static extern int GetWindowLongPtr(IntPtr h, int index);
    public delegate bool EnumProc(IntPtr h, IntPtr data);
    public const int GWL_STYLE = -16;
    public const int WS_VISIBLE = 0x10000000;
}
"@

$found = $false
FindHwnd::EnumWindows([FindHwnd+EnumProc]{
    param([IntPtr]$h, [IntPtr]$_)
    $len = FindHwnd::GetWindowText($h)
    if ($len -gt 0) {
        $sb = New-Object System.Text.StringBuilder($len + 1)
        [void]FindHwnd::GetWindowText($h, $sb, $sb.Capacity)
        $title = $sb.ToString()
        $style = FindHwnd::GetWindowLongPtr($h, [FindHwnd]::GWL_STYLE)
        if (($style -band [FindHwnd]::WS_VISIBLE) -ne 0 -and $title -match "Expense") {
            $script:appHwnd = $h
            $script:found = $true
        }
    }
    return (-not $script:found)
}, [IntPtr]::Zero) | Out-Null

if ($appHwnd -ne [IntPtr]::Zero) {
    $rc = New-Object Win32+RECT
    [void][Win32]::GetWindowRect($appHwnd, [ref]$rc)
    Write-Host "[PASS] App window: HWND=$appHwnd Left=$($rc.Left) Top=$($rc.Top) Right=$($rc.Right) Bottom=$($rc.Bottom)" -ForegroundColor Green
    [void][Win32]::SetForegroundWindow($appHwnd)
    Start-Sleep -Milliseconds 300
    
    $winWidth = $rc.Right - $rc.Left
    $winHeight = $rc.Bottom - $rc.Top
    Write-Host "  Window size: ${winWidth}x${winHeight}"
} else {
    Write-Host "[FAIL] Could not find app window" -ForegroundColor Red
    $exitCode = 1
}

# Navigate to Reports: Alt+4
if ($exitCode -eq 0) {
    Write-Host "[3] Alt+4 for Reports..."
    Start-Sleep -Seconds 1
    [System.Windows.Forms.SendKeys]::SendWait("%(4)")
    Start-Sleep -Seconds 3
    Write-Host "[PASS] Alt+4 sent"
    
    # Take screenshot to see Reports page layout
    $ss = [System.Windows.Forms.Screen]::PrimaryScreen
    $bmp = New-Object System.Drawing.Bitmap($ss.Bounds.Width, $ss.Bounds.Height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.CopyFromScreen($ss.Bounds.Location, [System.Drawing.Point]::Empty, $ss.Bounds.Size)
    $ssPath = Join-Path $BackupDir "before_click.png"
    $bmp.Save($ssPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose()
    Write-Host "  Screenshot: $ssPath"
}

# Click Export Backup button using mouse click
# The Reports page has action cards. The Backup card is at the bottom.
# Estimated position: in the Flutter window, near the bottom-right area
if ($exitCode -eq 0 -and $appHwnd -ne [IntPtr]::Zero) {
    Write-Host "[4] Clicking Export Backup button via mouse..."
    Start-Sleep -Seconds 1
    
    # The Backup card is likely at the bottom of the scrollable column
    # Click roughly at the bottom-right of the app window where the Export Backup button should be
    # In a typical 1200x800 window, the Backup card is at roughly (600-800, 500-600) relative coords
    $clickX = [int]($rc.Left + $winWidth * 0.8)  # Right side of window
    $clickY = [int]($rc.Top + $winHeight * 0.85)  # Near bottom
    Write-Host "  Clicking at: ($clickX, $clickY)"
    
    [System.Windows.Forms.Cursor]::Position = [System.Drawing.Point]::new($clickX, $clickY)
    Start-Sleep -Milliseconds 200
    [System.Windows.Forms.MouseEvent]::MouseDown([System.Windows.Forms.MouseButtons]::Left) | Out-Null
    [System.Windows.Forms.MouseEvent]::MouseUp([System.Windows.Forms.MouseButtons]::Left) | Out-Null
    Write-Host "  Mouse click sent"
    Start-Sleep -Seconds 5
}

# Take screenshot to check if dialog appeared
if ($exitCode -eq 0) {
    Write-Host "[DIAG] Checking for dialog..."
    Start-Sleep -Seconds 1
    $ss2 = [System.Windows.Forms.Screen]::PrimaryScreen
    $bmp2 = New-Object System.Drawing.Bitmap($ss2.Bounds.Width, $ss2.Bounds.Height)
    $g2 = [System.Drawing.Graphics]::FromImage($bmp2)
    $g2.CopyFromScreen($ss2.Bounds.Location, [System.Drawing.Point]::Empty, $ss2.Bounds.Size)
    $ssPath2 = Join-Path $BackupDir "after_click.png"
    $bmp2.Save($ssPath2, [System.Drawing.Imaging.ImageFormat]::Png)
    $g2.Dispose(); $bmp2.Dispose()
    $ssSize2 = (Get-Item $ssPath2).Length
    Write-Host "  Screenshot: $ssPath2 ($ssSize2 bytes)"
    
    if ($ssSize2 -gt 500000) {
        Write-Host "  [PASS] Large screenshot - likely has dialog content" -ForegroundColor Green
    } else {
        Write-Host "  [WARN] Small screenshot - dialog may not have appeared" -ForegroundColor Yellow
    }
}

# Save As dialog - type path and click Save
if ($exitCode -eq 0) {
    Write-Host "[5] Save As dialog..."
    Start-Sleep -Seconds 2
    
    # Try Ctrl+G approach
    [System.Windows.Forms.SendKeys]::SendWait("^g")
    Start-Sleep -Milliseconds 400
    [System.Windows.Forms.SendKeys]::SendWait($targetDir)
    Start-Sleep -Milliseconds 400
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
    Start-Sleep -Seconds 2
    
    $fn = Split-Path $exportFullPath -Leaf
    [System.Windows.Forms.SendKeys]::SendWait($fn)
    Start-Sleep -Milliseconds 400
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
    Write-Host "  Enter (Save)"
    Start-Sleep -Seconds 4
}

# Check file
if (Test-Path $exportFullPath) {
    $fi = Get-Item $exportFullPath
    Write-Host "[PASS] Backup: $($fi.Name) ($($fi.Length) bytes)" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Backup not found" -ForegroundColor Red
    $exitCode = 1
}

# Import
if ($exitCode -eq 0) {
    Write-Host "[6] Import..."
    Start-Sleep -Seconds 2
    $clickX2 = [int]($rc.Left + $winWidth * 0.8)
    $clickY2 = [int]($rc.Top + $winHeight * 0.92)
    [System.Windows.Forms.Cursor]::Position = [System.Drawing.Point]::new($clickX2, $clickY2)
    Start-Sleep -Milliseconds 200
    [System.Windows.Forms.MouseEvent]::MouseDown([System.Windows.Forms.MouseButtons]::Left) | Out-Null
    [System.Windows.Forms.MouseEvent]::MouseUp([System.Windows.Forms.MouseButtons]::Left) | Out-Null
    Start-Sleep -Seconds 5
    
    [System.Windows.Forms.SendKeys]::SendWait("^g")
    Start-Sleep -Milliseconds 400
    [System.Windows.Forms.SendKeys]::SendWait($targetDir)
    Start-Sleep -Milliseconds 400
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
    Start-Sleep -Seconds 2
    [System.Windows.Forms.SendKeys]::SendWait($fn)
    Start-Sleep -Milliseconds 400
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
    Write-Host "  File selected"
    Start-Sleep -Seconds 3
    
    Start-Sleep -Seconds 1
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
    Write-Host "  Confirmed"
    Start-Sleep -Seconds 2
}

if (-not $proc.HasExited) {
    Write-Host "[PASS] App still running PID=$($proc.Id)" -ForegroundColor Green
} else {
    Write-Host "[FAIL] App crashed $($proc.ExitCode)" -ForegroundColor Red
    $exitCode = 1
}

Stop-Process -Name "expense_app" -Force -ErrorAction SilentlyContinue

$endTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host ""
Write-Host "=== Result: $(if($exitCode -eq 0){'PASS'}else{'FAIL'}) ===" -ForegroundColor $(if($exitCode -eq 0){'Green'}else{'Red'})
Write-Host "$startTime -> $endTime"
exit $exitCode
