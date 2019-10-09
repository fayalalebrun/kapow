OUTPUT_FORMAT("elf32-i386")

SECTIONS {
	 . = 0x7c00;
	 .booter : {
		*(.text);
		. = 0x1fe;
		BYTE(0x55);
		BYTE(0xaa);
	 }
}
