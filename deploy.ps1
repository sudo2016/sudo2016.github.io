$repoDir = "C:\Users\16928\AppData\Local\Temp\mywebsite"
$workspace = "C:\Users\16928\Documents\个人网站主页"

Write-Host "===== 吴楠个人主页 · GitHub Pages 部署脚本 =====" -ForegroundColor Cyan
Write-Host ""

# Add Git to PATH if not found
$git = Get-Command git -ErrorAction SilentlyContinue
if (-not $git) {
    $env:Path += ";C:\Program Files\Git\bin"
    $git = Get-Command git -ErrorAction SilentlyContinue
    if (-not $git) {
        Write-Host "⚠ Git 未安装，请先安装 Git: https://git-scm.com/downloads" -ForegroundColor Yellow
        exit 1
    }
    Write-Host "  ✓ Git 已加载" -ForegroundColor Green
}

Write-Host "步骤 1/3: 同步 Git 仓库..." -ForegroundColor Green
Copy-Item -Path "$repoDir\.git" -Destination "$workspace\.git" -Recurse -Force -ErrorAction SilentlyContinue
if (Test-Path "$workspace\.git\HEAD") {
    Write-Host "  ✓ .git 已就绪" -ForegroundColor Green
} else {
    Write-Host "  ⚠ .git 复制失败，请检查 $repoDir 是否存在" -ForegroundColor Yellow
    exit 1
}

# 设置提交者身份
git config user.name "Wu Nan"
git config user.email "t12985648@163.com"

Write-Host ""
Write-Host "步骤 2/3: 提交更改..." -ForegroundColor Green
Set-Location $workspace
git add -A
git commit -m "更新主页内容"
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ 提交成功" -ForegroundColor Green
} else {
    Write-Host "  → 没有新更改，继续推送" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "步骤 3/3: 推送到 GitHub..." -ForegroundColor Green
git push -u origin main
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ 推送成功！" -ForegroundColor Green
} else {
    Write-Host "  ⚠ 推送失败，请检查网络或仓库权限" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "你的个人主页将在几分钟后自动更新：" -ForegroundColor Cyan
Write-Host "  https://sudo2016.github.io" -ForegroundColor White
Write-Host ""
Read-Host "按 Enter 键退出"
