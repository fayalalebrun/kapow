OUTPUT_FORMAT("elf32-i386")

SECTIONS {
	 . = 0x10000;
	 .game :{
	       *(.text);
	       BYTE(0x42);
	   
	   }
}
