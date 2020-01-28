@echo off
TITLE Folder creation
color 0A
echo.
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set BS=%%A

set /p folderName=.%BS%  Enter folder name: 
set folder=TogglePeacefulMode_%folderName%

mkdir "%folder%"
exit