@echo off
Taskkill /IM xpet.exe /F
set KICKASS_PATH="..\..\bin\Kickass.jar"

call java -jar %KICKASS_PATH% note.asm -o note.pet

start note.pet