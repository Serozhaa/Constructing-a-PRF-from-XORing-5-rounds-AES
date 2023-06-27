asmfile=$1.asm
ofile=o$1.o
execfile=$1

nasm -f elf64 -g -o $ofile $asmfile
ld -o $execfile $ofile
