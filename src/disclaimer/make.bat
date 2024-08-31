@echo off
set KICKASS_PATH="..\..\bin\Kickass.jar"

call java -jar %KICKASS_PATH% disclaimer.asm -o disclaimer.prg
call ..\..\bin\exomizer.exe mem -B disclaimer.prg,$5000 -o disclaimer_exo.bin  
