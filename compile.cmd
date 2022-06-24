set FREEBASIC_COMPILER_DIRECTORY=C:\Program Files (x86)\FreeBASIC-1.09.0-win64-gcc-9.3.0
set FREEBASIC_COMPILER="%FREEBASIC_COMPILER_DIRECTORY%\fbc32.exe"
set GCC_COMPILER="%FREEBASIC_COMPILER_DIRECTORY%\bin\win32\gcc.exe"
set GCC_ASSEMBLER="%FREEBASIC_COMPILER_DIRECTORY%\bin\win32\as.exe"
set GCC_LINKER="%FREEBASIC_COMPILER_DIRECTORY%\bin\win32\ld.exe"
set ARCHIVE_COMPILER="%FREEBASIC_COMPILER_DIRECTORY%\bin\win32\ar.exe"
set RESOURCE_COMPILER="%FREEBASIC_COMPILER_DIRECTORY%\bin\win32\GoRC.exe"
set COMPILER_LIB_PATH="%FREEBASIC_COMPILER_DIRECTORY%\lib\win32"

set GCC_OPTIMIZATION=-Wall -Werror -Wno-unused-label -Wno-unused-function -Wno-unused-variable -Wno-main -Werror-implicit-function-declaration -nostdlib -nostdinc -fno-strict-aliasing -frounding-math -fno-math-errno -fno-exceptions -fno-ident -mno-stack-arg-probe -fno-stack-check -fno-stack-protector -fno-unwind-tables -fno-asynchronous-unwind-tables -ffunction-sections -fdata-sections

del obj\*.o obj\*.asm obj\*.exe bin\*.com obj\*.c

REM %FREEBASIC_COMPILER% -gen gas -r -w error -maxerr 1 -O 0 -s console "MiniRuntime.bas"
%FREEBASIC_COMPILER% -gen gcc -r -w error -maxerr 1 -O 0 -s console "dos.bas"
REM move /y "dos.asm" "obj\dos.asm"
move /y "dos.c" "obj\dos.c"
REM replace.vbs "MiniRuntime.c" 
replace.vbs "obj\dos.c"

REM %GCC_COMPILER% %GCC_OPTIMIZATION% -masm=intel -S -Os "MiniRuntime.c" -o "MiniRuntime.asm"
%GCC_COMPILER% %GCC_OPTIMIZATION% -masm=intel -S -Ofast "obj\dos.c" -o "obj\dos.asm"

REM %GCC_ASSEMBLER% --32 "MiniRuntime.asm" -o "MiniRuntime.o"
%GCC_ASSEMBLER% --32 --strip-local-absolute "obj\dos.asm" -o "obj\dos.o"

REM %GCC_LINKER% -m i386pe -subsystem console -e _ENTRYPOINT@0 --stack 1048576,1048576 --no-seh -L "." -s --gc-sections --nmagic --script=com.ld "MiniRuntime.o" "dos.o" -o "dos.exe"
%GCC_LINKER% -m i386pe -subsystem console -e _ENTRYPOINT@0 --stack 1048576,1048576 --no-seh -L "." -s -gc-sections --strip-all --nmagic --script=com.ld "obj\dos.o" -o "obj\dos.exe"

"C:\Program Files (x86)\mingw32\bin\objcopy.exe" -O binary -j .text "obj\dos.exe" "bin\dos.com"