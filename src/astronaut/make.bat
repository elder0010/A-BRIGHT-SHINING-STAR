@echo off
set KICKASS_PATH="..\..\bin\Kickass.jar"

call java -jar %KICKASS_PATH% astronaut.asm -o astronaut.prg
call ..\..\bin\exomizer.exe mem -B astronaut.prg,$4600 -o astronaut_exo.bin  
