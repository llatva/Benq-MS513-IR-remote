
# Please select according to the type of board you are using:
MCU=attiny2313
DUDECPUTYPE=t2313
LOADCMD=avrdude

# -U lfuse:w:0xe1:m -U hfuse:w:0x99:m
LOADARG=-p $(DUDECPUTYPE) -c usbtiny -e -U flash:w:
CC=avr-gcc
OBJCOPY=avr-objcopy

## Options common to compile, link and assembly rules
COMMON = -mmcu=$(MCU)

## Compile options common for all C compilation units.
CFLAGS = $(COMMON)
CFLAGS += -Wall -gdwarf-2 -std=gnu99 -Wextra -pedantic -ffunction-sections -fdata-sections -fno-inline-small-functions -Os -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums

#CFLAGS=-g -mmcu=$(MCU) -Wall -W -Os -mcall-prologues
.PHONY: test0 all main

main.hex: main.elf 
	$(OBJCOPY) -R .eeprom -O ihex main.elf main.hex
	avr-size main.elf
	@echo " "
	@echo "Expl.: data=initialized data, bss=uninitialized data, text=code"
	@echo " "

main.elf: main.o
	$(CC) $(CFLAGS) -o main.elf -Wl,-Map,main.map main.o
load: main.hex
	$(LOADCMD) $(LOADARG)main.hex
fuse:
	@echo "Setting clock source"
	
#	$(LOADCMD) -p  $(DUDECPUTYPE) -c usbtiny -U lfuse:w:0xce:m -U hfuse:w:0x99:m
#	$(LOADCMD) -p  $(DUDECPUTYPE) -c usbtiny -U lfuse:w:0xe4:m -U hfuse:w:0x99:m
	$(LOADCMD) -p  $(DUDECPUTYPE) -c usbtiny -U lfuse:w:0xcc:m -U hfuse:w:0xdf:m
# 0xe4 == internal

#-------------------
clean:
	rm -f *.o *.map *.elf test*.hex main.hex *~
#-------------------
