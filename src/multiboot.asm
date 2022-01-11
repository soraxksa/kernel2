

section .multiboot
header_start:
	dd 0xe85250d6
	dd 0 ; flag for protected mode 
	dd header_end - header_start

	;checksum
	dd 0x100000000 - (0xe85250d6 + 0 + (header_end - header_start))

	;ending tag
	dw 0
	dw 0
	dd 8
header_end:
