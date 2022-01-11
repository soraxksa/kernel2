
ISO_NAME := myiso.iso

BUILD_DIR = ./build
SRC_DIR = ./src


GRUB_DIR := ./isofiles



CC = ~/opt/cross/bin/i686-elf-gcc
LINKER = ~/opt/cross/bin/i686-elf-ld

SRCS := $(notdir $(wildcard $(SRC_DIR)/*.c)) 

all: init kernel.bin grub 

init:
	-@mkdir -p $(BUILD_DIR)
	-@mkdir -p $(GRUB_DIR)/boot/grub

grub: grub.cfg
	@cp grub.cfg $(GRUB_DIR)/boot/grub/
	@grub-mkrescue -o $(ISO_NAME) $(GRUB_DIR)

OBJS := $(SRCS:%=$(BUILD_DIR)/%.o) 
# (TODO): add -MMD -MP to CPPFLAGS
DEPS := $(OBJS:.o=.d)

kernel.bin: $(OBJS) $(BUILD_DIR)/boot.o $(BUILD_DIR)/multiboot.o
	$(LINKER) -nmagic -o $(GRUB_DIR)/boot/$@ --script=linker.ld $^

$(BUILD_DIR)/boot.o: $(SRC_DIR)/boot.asm
	nasm -f elf32 $< -o $@
$(BUILD_DIR)/multiboot.o: $(SRC_DIR)/multiboot.asm
	nasm -f elf32 $< -o $@
	

.PONTY: clean
clean:
	-@rm -rf isofiles
	-@rm -rf build
	-@rm -f $(ISO_NAME)





