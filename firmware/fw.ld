ENTRY(_start)

MEMORY
{	
    bootrom (rx)  : ORIGIN = 0x0, LENGTH = 64K
    sram (rw) : ORIGIN = 0x10000, LENGTH = 32K
}

SECTIONS
{
	. = ORIGIN(bootrom);
    .text : 
    {
        *(.text.start)
		*(.text)
		*(.srodata)
    }
	. = ORIGIN(sram);
	.data :
	{
		*(.sdata)
		*(.sbss)
	}
	/DISCARD/ :
	{
		*
	}	
}
