@echo off
set KICKASS_PATH="..\..\bin\Kickass.jar"

call java -jar %KICKASS_PATH% parallax.asm -o parallax.prg
call ..\..\bin\exomizer.exe mem -B parallax.prg,$5000 -o parallax_exo.bin  
