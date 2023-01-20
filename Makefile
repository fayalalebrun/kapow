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
IMAGE = out/kapow.img

.PHONY: assets write_assets

all: boot game assets pad Makefile

pad:
	dd if=/dev/zero of=$(IMAGE) bs=1 count=1 seek=163839


define add_asset
	$(CONV) -compress none assets/$(1).PCX out/assets/$(1).bmp
	out/conv_asset.o out/assets/$(1).bmp out/assets/$(1).bin $(2) $(3)
#	dd if=assets/$(1).bin of=$(IMAGE) bs=512 oflag=append conv=notrunc
	cat out/assets/$(1).bin >> $(IMAGE)
endef


assets:
	mkdir -p out/assets
	gcc -o out/extract_palette.o src/assets/extract_palette.c
	$(CONV) -compress none assets/PALETTE.PCX out/assets/PALETTE.bmp
	out/extract_palette.o out/assets/PALETTE.bmp out/assets/palette.bin
	cat out/assets/palette.bin >> $(IMAGE)


	gcc -o out/conv_asset.o src/assets/conv_asset.c
	$(call add_asset,BOMB,16,32)
	$(call add_asset,BOMB8S,8,8)
	$(call add_asset,BOMBER,32,32)
	$(call add_asset,PADDLE,32,8)
	$(call add_asset,CHAR0,12,12)
	$(call add_asset,CHAR1,12,12)
	$(call add_asset,CHAR2,12,12)
	$(call add_asset,CHAR3,12,12)
	$(call add_asset,CHAR4,12,12)
	$(call add_asset,CHAR5,12,12)
	$(call add_asset,CHAR6,12,12)
	$(call add_asset,CHAR7,12,12)
	$(call add_asset,CHAR8,12,12)
	$(call add_asset,CHAR9,12,12)
	$(call add_asset,TOPSC,40,12)
	$(call add_asset,EXP1,8,8)
	$(call add_asset,EXP2,8,8)
	$(call add_asset,EXP3,8,8)
	$(call add_asset,EXP4,8,8)
	$(call add_asset,CHALKBOA,100,32)
	$(call add_asset,ENTER,96,20)
boot:
	$(NASM) -f elf32 -F dwarf -g src/bootup/booter.asm -o out/booter.o
	$(LD) -T src/bootup/booter_link.ld -m elf_i386  out/booter.o -o out/booter.elf
	$(OBJC) -O binary out/booter.elf out/booter.o1
	dd if=out/booter.o1 of=$(IMAGE) bs=512 conv=notrunc

game:
	$(NASM) -f elf32 -F dwarf -g src/game/game.asm -o out/game.o
	$(LD) -T src/game/game_link.ld -m elf_i386  out/game.o -o out/game.elf
	$(OBJC) -O binary out/game.elf out/game.o1
	dd if=out/game.o1 of=$(IMAGE) bs=512 seek=1


qemu:	all
	$(QEMU) -fda $(IMAGE) -enable-kvm

gdb:	all
	$(QEMU) -S -s -fda $(IMAGE) -enable-kvm &
	sleep 1
	$(GDB) -ix gdbinit_real_mode.txt -ex 'target remote localhost:1234' -ex 'set architecture i8086'  -ex 'file out/game.elf' -ex 'set step-mode'

dosbox:	all
	dosbox -fastlaunch -c "mount c ./out/" -c "loadfix" -c "c:" -c "imgmount 0 $(IMAGE) -t floppy -fs none" -c "boot -l a"
