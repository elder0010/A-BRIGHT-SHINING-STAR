@echo off
set KICKASS_PATH="..\..\bin\Kickass.jar"

call java -jar %KICKASS_PATH% symbol.asm -o symbol.prg
call ..\..\bin\exomizer.exe mem -B symbol.prg,$5000 -o symbol_exo.bin  
