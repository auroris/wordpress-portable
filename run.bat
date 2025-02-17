@echo off
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -NoProfile -File "run.ps1"