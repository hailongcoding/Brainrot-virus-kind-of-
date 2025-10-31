@echo off
setlocal

:: === MUST RUN AS ADMIN ===
net session >nul 2>&1 || (
    echo RUN AS ADMINISTRATOR!
    pause
    exit /b
)

echo.
echo [NUKE MODE] KILLING PROCESSES + FORCE DELETING...
echo.

set "DESKTOP=%USERPROFILE%\Desktop"
set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "HANDLE=C:\Windows\handle.exe"

:: === KILL ANY PROCESS USING audio_*, background_*, Brainrot.exe ===
echo Killing processes locking files...
for /f "tokens=2 delims=," %%P in ('"%HANDLE%" -accepteula "audio_" -nobanner 2^>nul ^| findstr /i "pid:"') do taskkill /PID %%P /F >nul 2>&1
for /f "tokens=2 delims=," %%P in ('"%HANDLE%" -accepteula "background_" -nobanner 2^>nul ^| findstr /i "pid:"') do taskkill /PID %%P /F >nul 2>&1
for /f "tokens=2 delims=," %%P in ('"%HANDLE%" -accepteula "Brainrot.exe" -nobanner 2^>nul ^| findstr /i "pid:"') do taskkill /PID %%P /F >nul 2>&1

:: === FORCE DELETE audio_*.mp3 ===
echo.
echo Deleting audio_*.mp3...
for /f "delims=" %%F in ('dir /b /a-d "%DESKTOP%\audio_*.mp3" 2^>nul') do (
    echo   [DEL] %%F
    del /F /Q "%DESKTOP%\%%F" >nul 2>&1 || (
        echo   [LOCKED] %%F - Will delete on REBOOT
        echo Y | cacls "%DESKTOP%\%%F" /T /C /G Administrators:F >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\PendingFileRenameOperations" /v "DeleteAudio" /t REG_MULTI_SZ /d "\??\%DESKTOP%\%%F\0\0" /f >nul
    )
)

:: === FORCE DELETE background_* ===
echo.
echo Deleting background_*...
for /f "delims=" %%F in ('dir /b /a-d "%DESKTOP%\background_*" 2^>nul') do (
    echo   [DEL] %%F
    del /F /Q "%DESKTOP%\%%F" >nul 2>&1 || (
        echo   [LOCKED] %%F - Will delete on REBOOT
        echo Y | cacls "%DESKTOP%\%%F" /T /C /G Administrators:F >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\PendingFileRenameOperations" /v "DeleteBG" /t REG_MULTI_SZ /d "\??\%DESKTOP%\%%F\0\0" /f >nul
    )
)

:: === DELETE BR background.jpg ===
set "BRFILE=%DESKTOP%\BR background.jpg"
if exist "%BRFILE%" (
    echo.
    echo Deleting BR background.jpg...
    del /F /Q "%BRFILE%" >nul 2>&1 || (
        echo   [LOCKED] BR background.jpg - Will delete on REBOOT
        echo Y | cacls "%BRFILE%" /T /C /G Administrators:F >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\PendingFileRenameOperations" /v "DeleteBR" /t REG_MULTI_SZ /d "\??\%BRFILE%\0\0" /f >nul
    )
)

:: === DELETE Brainrot.exe from Startup ===
set "BRAIN=%STARTUP%\Brainrot.exe"
if exist "%BRAIN%" (
    echo.
    echo Deleting Brainrot.exe...
    del /F /Q "%BRAIN%" >nul 2>&1 || (
        echo   [LOCKED] Brainrot.exe - Will delete on REBOOT
        echo Y | cacls "%BRAIN%" /T /C /G Administrators:F >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\PendingFileRenameOperations" /v "DeleteBrain" /t REG_MULTI_SZ /d "\??\%BRAIN%\0\0" /f >nul
    )
)

echo.
echo ================================================
echo    ALL POSSIBLE DELETES ATTEMPTED
echo    LOCKED FILES WILL BE DELETED ON REBOOT
echo ================================================
echo.
echo REBOOT NOW TO FINISH CLEANUP!
echo.

pause
