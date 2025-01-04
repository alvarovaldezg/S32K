

# All of the sources participating in the build are defined here
#-include Debug/sources.mk
#-include Debug/src/subdir.mk
#-include Debug/Project_Settings/Startup_Code/subdir.mk
#-include Debug/Project_Settings/Linker_Files/subdir.mk
#-include Debug/subdir.mk
#-include Debug/objects.mk


# Toolchain configuration
CC = arm-none-eabi-gcc.exe
CXX = arm-none-eabi-g++.exe
AS = arm-none-eabi-as.exe
LD = arm-none-eabi-ld.exe
OBJCOPY = arm-none-eabi-objcopy.exe
OBJDUMP = arm-none-eabi-objdump.exe
SIZE = arm-none-eabi-size.exe
READ = arm-none-eabi-readelf.exe

# MCU and architecture specific flags
MCU = cortex-m4
FPU = -mfpu=fpv4-sp-d16
FLOAT_ABI = -mfloat-abi=hard
CPU_FLAGS = -mcpu=$(MCU) -mthumb $(FPU) $(FLOAT_ABI)

# Directories
SRC_DIR = src
STARTUP_DIR = startup
INCLUDE_DIR = include
BUILD_DIR = build
LINKER_DIR = Linker_Files

# Files
STARTUP_FILE = $(STARTUP_DIR)/startup_S32K144.S
LINKER_SCRIPT = $(LINKER_DIR)/S32K1xx_flash.ld

# Output
TARGET = hello

# Compilation flags
CFLAGS = $(CPU_FLAGS) -O2 -Wall -ffreestanding -nostdlib -g -I$(INCLUDE_DIR)
CXXFLAGS = $(CFLAGS) -std=c++17
LDFLAGS = $(CPU_FLAGS) -T$(LINKER_SCRIPT) -nostartfiles -Wl,--gc-sections

# Sources and objects
CXX_SRCS = $(wildcard $(SRC_DIR)/*.cpp)
C_SRCS = $(wildcard $(SRC_DIR)/*.c)
AS_SRCS = $(STARTUP_FILE)


OBJS = $(patsubst $(SRC_DIR)/%.cpp, $(BUILD_DIR)/%.o, $(CXX_SRCS)) \
       $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(C_SRCS)) \
       $(patsubst $(STARTUP_DIR)/%.s, $(BUILD_DIR)/%.o, $(AS_SRCS))

# Default target
all: prebuild $(BUILD_DIR) $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin

	@echo 'Building target 1: $@'

# Prebuild step to fix timestamps
prebuild:
	@echo 'Synchronizing file timestamps...'
	find . -exec touch {} \;

# Create build directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Compile C++ sources
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Compile C sources
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@echo 'Building C source files: $@'
	$(CC) $(CFLAGS) -c $< -o $@

# Assemble startup code
$(BUILD_DIR)/%.o: $(STARTUP_DIR)/%.s
	@echo 'Building startup code: $@'
	$(AS) $(CPU_FLAGS) $< -o $@

# Link
$(BUILD_DIR)/$(TARGET).elf: $(OBJS) $(LINKER_SCRIPT)
	@echo 'Linking: $@'
	$(CXX) $(LDFLAGS) $(OBJS) -o $@

# Convert to HEX
$(BUILD_DIR)/$(TARGET).hex: $(BUILD_DIR)/$(TARGET).elf
	@echo 'Convert to hex: $@'
	$(OBJCOPY) -O ihex $< $@

# Convert to binary
$(BUILD_DIR)/$(TARGET).bin: $(BUILD_DIR)/$(TARGET).elf
	@echo 'Convert to bin: $@'
	$(OBJCOPY) -O binary $< $@

# Print size information
size: $(BUILD_DIR)/$(TARGET).elf
	$(SIZE) $<

read: $(BUILD_DIR)/$(TARGET).elf
	$(READ) -h -S $<

# Clean build directory
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean read size