@echo off
chcp 65001 >nul
echo ========================================================
echo       КлассМейт - Умный помощник школьника (Flutter)
echo ========================================================
echo.
echo 1. Запустить в Google Chrome (Рекомендуется, работает сразу!)
echo 2. Запустить для VS Code Mobile Preview (порт 8080)
echo 3. Запустить в Microsoft Edge (Web)
echo 4. Собрать Windows (.exe) - требует Visual Studio C++
echo 5. Очистить кэш сборщика (flutter clean ^& pub get)
echo.
set /p choice="Выберите вариант [1-5, по умолчанию 1]: "

if "%choice%"=="2" (
    echo Запуск Web Server для VS Code Mobile Preview на http://localhost:8080 ...
    "C:\flutter\bin\flutter.bat" run -d web-server --web-port 8080 --web-hostname 127.0.0.1
) else if "%choice%"=="3" (
    echo Запуск приложения в Microsoft Edge...
    "C:\flutter\bin\flutter.bat" run -d edge
) else if "%choice%"=="4" (
    echo Запуск приложения для Windows Desktop...
    "C:\flutter\bin\flutter.bat" run -d windows
) else if "%choice%"=="5" (
    echo Очистка кэша Flutter...
    "C:\flutter\bin\flutter.bat" clean
    echo Получение пакетов...
    "C:\flutter\bin\flutter.bat" pub get
    echo Готово!
) else (
    echo Запуск приложения в Google Chrome...
    "C:\flutter\bin\flutter.bat" run -d chrome
)

pause
