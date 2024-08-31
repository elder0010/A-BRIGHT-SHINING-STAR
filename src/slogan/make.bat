@echo off
set KICKASS_PATH="..\..\bin\Kickass.jar"

call java -jar %KICKASS_PATH% slogan.asm -o slogan.prg
call ..\..\bin\exomizer.exe mem -B slogan.prg,$5000 -o slogan_exo.bin  
