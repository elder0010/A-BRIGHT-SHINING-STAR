@echo off
Taskkill /IM xpet.exe /F
set KICKASS_PATH="bin\Kickass.jar"

call java -jar %KICKASS_PATH% src\main.asm -o main.pet

start main.pet