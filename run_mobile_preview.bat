@echo off
chcp 65001 >nul
echo ===================================================================
echo   Запуск КлассМейт для VS Code Mobile Preview Simulator
echo   URL: http://localhost:8080
echo ===================================================================
echo.
echo Шаги:
echo 1. Дождитесь надписи "Flutter Web Server is available at http://127.0.0.1:8080"
echo 2. В расширении Mobile Preview вставьте адрес: http://localhost:8080
echo.
"C:\flutter\bin\flutter.bat" run -d web-server --web-port 8080 --web-hostname 127.0.0.1
pause
