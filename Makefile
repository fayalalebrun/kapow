PREFIX=/usr
COMPPATH=$(PREFIX)/bin
CC = $(COMPPATH)/$(TARGET)gcc
CXX = $(COMPPATH)/$(TARGET)g++
AS = $(COMPPATH)/$(TARGET)as
AR = $(COMPPATH)/$(TARGET)ar
NM = $(COMPPATH)/$(TARGET)nm
LD = $(COMPPATH)/$(TARGET)ld
GDB = $(COMPPATH)/$(TARGET)gdb
QEMU = $(COMPPATH)/$(TARGET)qemu-system-i386
NASM = $(COMPPATH)/$(TARGET)nasm
OBJC = $(COMPPATH)/$(TARGET)objcopy
CONV = $(COMPPATH)/$(TARGET)convert

.PHONY: assets write_assets

all: boot game assets Makefile


define add_asset
	$(CONV) -compress none assets/$(1).PCX out/assets/$(1).bmp
	out/conv_asset.o out/assets/$(1).bmp out/assets/$(1).bin $(2) $(3)
#	dd if=assets/$(1).bin of=out/HD.img bs=512 oflag=append conv=notrunc
	cat out/assets/$(1).bin >> out/HD.img
endef


assets:
	gcc -o out/conv_asset.o src/assets/conv_asset.c
	$(call add_asset,BOMB,16,32)
	$(call add_asset,BOMB8,8,16)
	$(call add_asset,BOMBER,32,32)

boot:
	$(NASM) -f elf32 -F dwarf -g src/bootup/booter.asm -o out/booter.o
	$(LD) -T src/bootup/booter_link.ld -m elf_i386  out/booter.o -o out/booter.elf
	$(OBJC) -O binary out/booter.elf out/booter.o1
	dd if=out/booter.o1 of=out/HD.img bs=512 conv=notrunc

game:
	$(NASM) -f elf32 -F dwarf -g src/game/game.asm -o out/game.o
	$(LD) -T src/game/game_link.ld -m elf_i386  out/game.o -o out/game.elf
	$(OBJC) -O binary out/game.elf out/game.o1
	dd if=out/game.o1 of=out/HD.img bs=512 seek=1


qemu:	all
	$(QEMU) -hda out/HD.img -enable-kvm

gdb:	all
	$(QEMU) -S -s -hda out/HD.img -enable-kvm &
	sleep 1
	$(GDB) -ix gdbinit_real_mode.txt -ex 'target remote localhost:1234' -ex 'set architecture i8086' -ex 'hb *0x10002'
