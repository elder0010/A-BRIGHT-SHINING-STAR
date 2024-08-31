@echo off
set KICKASS_PATH="..\..\bin\Kickass.jar"

call java -jar %KICKASS_PATH% nave.asm -o nave.prg
call ..\..\bin\exomizer.exe mem -B nave.prg,$5000 -o nave_exo.bin  
