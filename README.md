# FreeRTOS Project for STM32F446RE

This repository contains a FreeRTOS project designed for the STM32F446RE microcontroller. The project is set up to work in Visual Studio and uses the arm-none-eabi-gcc/as toolchain for compilation, OpenOCD for flashing the program onto the microcontroller, Makefiles to streamline these processes, and the cortex-debug extension in Visual Studio Code for debugging purposes.

## Requirements
- **STM32F446RE Development Board**: This project is specifically designed for this microcontroller. Ensure you have the necessary hardware.
- **Visual Studio Code**: The project is set up to work in Visual Studio Code, so make sure you have this editor installed.
- **arm-none-eabi-gcc/as Toolchain**: Install this toolchain to compile the programs for the ARM architecture.
- **OpenOCD**: Required for flashing the compiled code onto the STM32F446RE.
- **Makefiles**: Used to automate the build process; ensure you have Makefiles configured for this project.
- **cortex-debug Extension**: Install this extension in Visual Studio Code for debugging support.

## Usage
1. Clone this repository to your local machine.
2. Set up Visual Studio Code with the necessary extensions (cortex-debug).
3. Ensure you have the arm-none-eabi-gcc/as toolchain, OpenOCD, and Makefiles properly installed and configured.
4. Open the project in Visual Studio Code.
5. Use the provided Makefiles to compile the code.
    - `make build`: Compile the code for the STM32F446RE.
    - `make clean`: Remove compiled files and folders.
    - `make flash`: Load the compiled program onto the STM32F446RE using OpenOCD.
6. Debug and test the project as needed.

## Additional Notes
- Modify the `Makefile` and project configurations in Visual Studio Code to suit your specific requirements or hardware setup.
- Refer to the official documentation of FreeRTOS and STM32F446RE for further customization and understanding of the project components.
