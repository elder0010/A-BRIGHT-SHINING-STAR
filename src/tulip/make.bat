@echo off
set KICKASS_PATH="..\..\bin\Kickass.jar"

call java -jar %KICKASS_PATH% tulip.asm -o tulip.prg
call ..\..\bin\exomizer.exe mem -B tulip.prg,$5000 -o tulip_exo.bin  
