@echo off
set KICKASS_PATH="..\..\bin\Kickass.jar"

call java -jar %KICKASS_PATH% sinebars.asm -o sinebars.prg
call ..\..\bin\exomizer.exe mem -B sinebars.prg,$5000 -o sinebars_exo.bin  
