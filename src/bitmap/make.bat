@echo off
set KICKASS_PATH="..\..\bin\Kickass.jar"

call java -jar %KICKASS_PATH% bitmap.asm -o bitmap.prg
call ..\..\bin\exomizer.exe mem -B bitmap.prg,$4a00 -o bitmap_exo.bin  
