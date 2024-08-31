@echo off
set KICKASS_PATH="..\..\bin\Kickass.jar"

call java -jar %KICKASS_PATH% greetz.asm -o greetz.prg
call ..\..\bin\exomizer.exe mem -B greetz.prg,$5000 -o greetz_exo.bin  
