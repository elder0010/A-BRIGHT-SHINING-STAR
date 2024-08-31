@echo off
set KICKASS_PATH="..\..\bin\Kickass.jar"

call java -jar %KICKASS_PATH% intro.asm -o intro.prg
call ..\..\bin\exomizer.exe mem -B intro.prg,$5000 -o intro_exo.bin  
