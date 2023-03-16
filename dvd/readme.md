Place you assembly (`.s` or `.S`) source files in the src directory.
Ensure that you do not have multiple source files with the same name (e.g. `main.c` and `main.s`).

Run `make` to build the software. This produces a build directory, containing:

 - object files (`.o`) produced from your source code
 - a `mem.txt` file which is the memory image for use in the simulator
 - a `program.dump` file which is the full disassembled program output.
 - and some intermediate `.bin` and `.elf` files which you can ignore.

You can also run:

 - `make clean` to remove the build directory
