@echo off
chcp 65001 >nul
title Informacion del Dispositivo
color 0B
 
echo.
echo   INFORMACION DEL DISPOSITIVO
echo.
 
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$os = Get-CimInstance Win32_OperatingSystem;" ^
    "$cs = Get-CimInstance Win32_ComputerSystem;" ^
    "$cpu = Get-CimInstance Win32_Processor;" ^
    "Write-Host '  SISTEMA OPERATIVO    ' -ForegroundColor Yellow;" ^
    "Write-Host ('  Nombre:       ' + $os.Caption);" ^
    "Write-Host ('  Version:      ' + $os.Version);" ^
    "Write-Host ('  Arquitectura: ' + $os.OSArchitecture);" ^
    "Write-Host '';" ^
    "Write-Host '  EQUIPO    ' -ForegroundColor Yellow;" ^
    "Write-Host ('  Nombre:       ' + $cs.Name);" ^
    "Write-Host ('  Fabricante:   ' + $cs.Manufacturer);" ^
    "Write-Host ('  Modelo:       ' + $cs.Model);" ^
    "Write-Host ('  Usuario:      ' + $cs.UserName);" ^
    "Write-Host '';" ^
    "Write-Host '  PROCESADOR (CPU)    ' -ForegroundColor Yellow;" ^
    "Write-Host ('  Nombre:       ' + $cpu.Name);" ^
    "Write-Host ('  Nucleos:      ' + $cpu.NumberOfCores);" ^
    "Write-Host ('  Hilos:        ' + $cpu.NumberOfLogicalProcessors);" ^
    "Write-Host ('  Velocidad:    ' + $cpu.MaxClockSpeed + ' MHz');" ^
    "Write-Host '';" ^
    "Write-Host '  MEMORIA RAM    ' -ForegroundColor Yellow;" ^
    "$ramTotal = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2);" ^
    "$ramLibre = [math]::Round(($os.FreePhysicalMemory * 1KB) / 1GB, 2);" ^
    "Write-Host ('  Total:        ' + $ramTotal + ' GB');" ^
    "Write-Host ('  Disponible:   ' + $ramLibre + ' GB');" ^
    "Write-Host '';" ^
    "Write-Host '  ALMACENAMIENTO    ' -ForegroundColor Yellow;" ^
    "Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' | ForEach-Object { $t=[math]::Round($_.Size/1GB,2); $l=[math]::Round($_.FreeSpace/1GB,2); Write-Host ('  Unidad ' + $_.DeviceID + '   Total: ' + $t + ' GB   Libre: ' + $l + ' GB') };" ^
    "Write-Host '';" ^
    "Write-Host '  TARJETA GRAFICA (GPU)    ' -ForegroundColor Yellow;" ^
    "Get-CimInstance Win32_VideoController | ForEach-Object { Write-Host ('  ' + $_.Name) };" ^
    "Write-Host '';" ^
    "Write-Host '  RED    ' -ForegroundColor Yellow;" ^
    "Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike '169.*' -and $_.InterfaceAlias -notlike '*Loopback*' } | ForEach-Object { Write-Host ('  ' + $_.InterfaceAlias + ': ' + $_.IPAddress) };" ^
    "Write-Host '';" ^
    "$rutas = @('HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*','HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*');" ^
    "$apps = @(Get-ItemProperty $rutas -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName } | Sort-Object -Property DisplayName -Unique);" ^
    "Write-Host ('  PROGRAMAS INSTALADOS (' + $apps.Count + ')    ') -ForegroundColor Yellow;" ^
    "$apps | ForEach-Object { $v = ''; if ($_.DisplayVersion) { $v = '  [v' + $_.DisplayVersion + ']' }; Write-Host ('  - ' + $_.DisplayName + $v) };"
 

echo.

pause >nul