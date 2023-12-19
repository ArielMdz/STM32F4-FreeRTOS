# Toolchain
TOOLCHAIN = arm-none-eabi-
CC= $(TOOLCHAIN)gcc
AS= $(TOOLCHAIN)as
GDB= $(TOOLCHAIN)gdb
PROGRAMMER=openocd

# Compiler Flags
CFLAGS=	-mcpu=cortex-m4 -mthumb --specs=nano.specs \

CPPFLAGS= \
	-DSTM32F446xx \
	-ICore/Inc \
	-IDrivers/CMSIS/Include \
	-IDrivers/STM32F4/Include 
		
PROGRAMMER_FLAGS=-f interface/stlink.cfg -f target/stm32f4x.cfg

# Source Code Direcction
SRC_DIR= Core/Src
STARTUP_DIR= Core/Startup
TEMPLATES_DIR= Drivers/STM32F4/Source/Templates

# Include File Directory
INC_DIRS= \
	-I$(SRC_DIR) \
	-I$(STARTUP_DIR) \
	-I$(TEMPLATES_DIR) 

# Destination Folder
BUILD_DIR= build
BIN_DIR= bin

# Source Code Files
SRC= $(wildcard $(SRC_DIR)/*.c)
STARTUP= $(wildcard $(STARTUP_DIR)/*.c)
TEMPLATES= $(wildcard $(TEMPLATES_DIR)/*.c)

# Object Files Generated in the build folder
SRC_OBJ = $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SRC))
STARTUP_OBJ = $(patsubst $(STARTUP_DIR)/%.c, $(BUILD_DIR)/%.o, $(STARTUP))
TEMPLATES_OBJ = $(patsubst $(TEMPLATES_DIR)/%.c, $(BUILD_DIR)/%.o, $(TEMPLATES))

# Final object files
OBJ= \
	$(SRC_OBJ) \
	$(STARTUP_OBJ) \
	$(TEMPLATES_OBJ) 

# Linker File
LINKER_FILE=linker_script.ld 
LDFLAGS=-T $(LINKER_FILE) -u _printf_float
#LINKER_FILE=STM32F446RETX_FLASH.ld

# Executable File Name
EXECUTABLE= main.elf

#
# Makefile reles
#

# Default make rule
all: clean build flash

# Rule to generate executable file .elf
build: makedir $(BIN_DIR)/$(EXECUTABLE)

$(BIN_DIR)/$(EXECUTABLE): $(OBJ)
	#clear
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $^ -o $@

# Rule to generate file .o file from .c files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(STARTUP_DIR)/%.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@


$(BUILD_DIR)/%.o: $(TEMPLATES_DIR)/%.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@


# Rule to generate build folder
makedir:
	mkdir -p $(BUILD_DIR)
	mkdir -p $(BIN_DIR)
	clear

# Rule to clean files 
clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(BIN_DIR)

# Rule for flashing STM32 board
flash: $(BIN_DIR)/$(EXECUTABLE)
	$(PROGRAMMER) $(PROGRAMMER_FLAGS) -c "program $(BIN_DIR)/$(EXECUTABLE) verify reset exit"

# Rule for debugging code
debug: 
	$(GDB) $(BIN_DIR)/$(EXECUTABLE)

.PHONY: clean