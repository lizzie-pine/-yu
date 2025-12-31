# Hadoop集群启动脚本
Write-Host "正在启动Hadoop Docker集群..." -ForegroundColor Green

# 检查Docker Desktop是否正在运行
$dockerStatus = docker info 2>&1
if ($dockerStatus -like "*error during connect*" -or $dockerStatus -like "*connection refused*") {
    Write-Host "Docker Desktop未运行，请先启动Docker Desktop！" -ForegroundColor Red
    Read-Host "按任意键退出..."
    exit 1
}

# 进入项目目录
Set-Location $PSScriptRoot

# 构建并启动集群
docker-compose up -d

if ($LASTEXITCODE -eq 0) {
    Write-Host "集群启动成功！" -ForegroundColor Green
    Write-Host ""
    Write-Host "===========================================" -ForegroundColor Cyan
    Write-Host "Hadoop 集群访问地址" -ForegroundColor Cyan
    Write-Host "===========================================" -ForegroundColor Cyan
    Write-Host "HDFS 管理界面: http://localhost:9870" -ForegroundColor Yellow
    Write-Host "YARN 资源管理器: http://localhost:8088" -ForegroundColor Yellow
    Write-Host "自定义监控界面: web/index.html" -ForegroundColor Yellow
    Write-Host "===========================================" -ForegroundColor Cyan
    Write-Host ""
    
    # 询问用户是否打开自定义监控界面
    $openWeb = Read-Host "是否打开自定义监控界面？(Y/N)"
    if ($openWeb -eq "Y" -or $openWeb -eq "y") {
        Write-Host "正在打开自定义监控界面..." -ForegroundColor Green
        Start-Process "$PSScriptRoot\web\index.html"
    }
    
    # 询问用户是否进入Master节点
    $enterMaster = Read-Host "是否进入Master节点控制台？(Y/N)"
    if ($enterMaster -eq "Y" -or $enterMaster -eq "y") {
        Write-Host "正在进入Master节点控制台..." -ForegroundColor Green
        docker exec -it hadoop-master bash
    }
} else {
    Write-Host "集群启动失败，请检查错误信息！" -ForegroundColor Red
}

Write-Host ""
Read-Host "按任意键退出..."