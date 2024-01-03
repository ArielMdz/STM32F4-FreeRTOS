# Toolchain
TOOLCHAIN = arm-none-eabi-
CC= $(TOOLCHAIN)gcc
AS= $(TOOLCHAIN)as
GDB= $(TOOLCHAIN)gdb
PROGRAMMER=openocd

# Compiler Flags
CFLAGS=	\
	-mcpu=cortex-m4 -mthumb --specs=nano.specs \
	-mfloat-abi=hard -mfpu=fpv4-sp-d16 \
	-std=c11 -mcpu=cortex-m4

CPPFLAGS= \
	-DSTM32F446xx \
	-ICore/Inc \
	-IDrivers/CMSIS/Include \
	-IDrivers/CMSIS/Device/ST/STM32F4xx/Include \
	-IDrivers/STM32F4xx_HAL_Driver/Inc \
	-IFreeRTOS/portable/GCC/ARM_CM4F \
	-IFreeRTOS/include \
#	-ISystemView/Config \
	-ISystemView/OS \
	-ISystemView/SEGGER 
		
PROGRAMMER_FLAGS=-f interface/stlink.cfg -f target/stm32f4x.cfg

# Source Code Direcction
SRC_DIR= Core/Src
STARTUP_DIR= Core/Startup
TEMPLATES_DIR= Drivers/CMSIS/Device/ST/STM32F4xx/Source/Templates
STM32F_HAL_DIR= Drivers/STM32F4xx_HAL_Driver/Src
FREERTOS_DIR= FreeRTOS
GCC_DIR= FreeRTOS/portable/GCC/ARM_CM4F
MEMMANG_DIR= FreeRTOS/portable/MemMang
SEGGER_C_DIR= SystemView/Config
SEGGER_O_DIR= SystemView/OS
SEGGER_S_DIR= SystemView/SEGGER

# Include File Directory
INC_DIRS= \
	-I$(SRC_DIR) \
	-I$(STARTUP_DIR) \
	-I$(TEMPLATES_DIR) \
	-I$(STM32F_HAL_DIR) \
	-I$(FREERTOS_DIR) \
	-I$(GCC_DIR) \
	-I$(MEMMANG_DIR) \
#	-I$(SEGGER_C_DIR) \
	-I$(SEGGER_O_DIR) \
	-I$(SEGGER_S_DIR) 

# Destination Folder
BUILD_DIR= build
BIN_DIR= bin

# Source Code Files
SRC= $(wildcard $(SRC_DIR)/*.c)
STARTUP= $(wildcard $(STARTUP_DIR)/*.s)
TEMPLATES= $(wildcard $(TEMPLATES_DIR)/*.c)
STM32F_HAL= $(wildcard $(STM32F_HAL_DIR)/*.c)
FREERTOS= $(wildcard $(FREERTOS_DIR)/*.c)
GCC= $(wildcard $(GCC_DIR)/*.c)
MEMMANG= $(wildcard $(MEMMANG_DIR)/*.c)
SEGGER_C= $(wildcard $(SEGGER_C_DIR)/*.c)
SEGGER_O= $(wildcard $(SEGGER_O_DIR)/*.c)
SEGGER_S= $(wildcard $(SEGGER_S_DIR)/*.c)

# Object Files Generated in the build folder
SRC_OBJ = $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SRC))
STARTUP_OBJ = $(patsubst $(STARTUP_DIR)/%.s, $(BUILD_DIR)/%.o, $(STARTUP))
TEMPLATES_OBJ = $(patsubst $(TEMPLATES_DIR)/%.c, $(BUILD_DIR)/%.o, $(TEMPLATES))
STM32F_HAL_OBJ = $(patsubst $(STM32F_HAL_DIR)/%.c, $(BUILD_DIR)/%.o, $(STM32F_HAL))
FREERTOS_OBJ = $(patsubst $(FREERTOS_DIR)/%.c, $(BUILD_DIR)/%.o, $(FREERTOS))
GCC_OBJ = $(patsubst $(GCC_DIR)/%.c, $(BUILD_DIR)/%.o, $(GCC))
MEMMANG_OBJ = $(patsubst $(MEMMANG_DIR)/%.c, $(BUILD_DIR)/%.o, $(MEMMANG))
SEGGER_C_OBJ = $(patsubst $(SEGGER_C_DIR)/%.c, $(BUILD_DIR)/%.o, $(SEGGER_C))
SEGGER_O_OBJ = $(patsubst $(SEGGER_O_DIR)/%.c, $(BUILD_DIR)/%.o, $(SEGGER_O))
SEGGER_S_OBJ = $(patsubst $(SEGGER_S_DIR)/%.c, $(BUILD_DIR)/%.o, $(SEGGER_S))

# Final object files
OBJ= \
	$(SRC_OBJ) \
	$(STARTUP_OBJ) \
	$(TEMPLATES_OBJ) \
	$(STM32F_HAL_OBJ) \
	$(FREERTOS_OBJ) \
	$(GCC_OBJ) \
	$(MEMMANG_OBJ) \
#	$(SEGGER_C_OBJ) \
	$(SEGMENT_O_OBJ) \
	$(SEGMENT_S_OBJ) \
	$(BUILD_DIR)/SEGGER_RTT_ASM_ARMv7M.o

# Linker File
#LINKER_FILE=linker_script.ld 
LINKER_FILE=STM32F446RETX_FLASH.ld
LDFLAGS=-T $(LINKER_FILE) -u _printf_float

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
#	clear
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $^ -o $@

# Rule to generate file .o file from .c files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

#$(BUILD_DIR)/%.o: $(STARTUP_DIR)/%.c
#	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(STARTUP_DIR)/%.s
	$(AS) -mcpu=cortex-m4 -o $@ $<

$(BUILD_DIR)/%.o: $(TEMPLATES_DIR)/%.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(STM32F_HAL_DIR)/%.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(FREERTOS_DIR)/%.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC_DIRS) -c $< -o $@

$(BUILD_DIR)/%.o: $(GCC_DIR)/%.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC_DIRS) -c $< -o $@

$(BUILD_DIR)/%.o: $(MEMMANG_DIR)/%.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC_DIRS) -c $< -o $@

$(BUILD_DIR)/%.o: $(SEGGER_C_DIR)/%.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(SEGGER_O_DIR)/%.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(SEGGER_S_DIR)/%.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

$(BUILD_DIR)/SEGGER_RTT_ASM_ARMv7M.o: SystemView/SEGGER/SEGGER_RTT_ASM_ARMv7M.s
	$(AS) -mcpu=cortex-m4 -o $@ $<

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
#debug: $(BIN_DIR)/$(EXECUTABLE)
#	$(GDB) $< -ex "target extended-remote 3333" \
            -ex "load" \
            -ex "break main" \
            -ex "continue"

.PHONY: clean