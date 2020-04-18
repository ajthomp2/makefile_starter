IDIR=../include
CC=gcc

# -g flag builds the executable with debugging symbols. Should only be used during development
# -Wall turns on all of the compiler warning flags
# -Werror turns any warnings into compilation errors
# 
CFLAGS=-I$(IDIR) -g -Wall -Werror -std=c99

ODIR=obj

# Libaries to link. For example -lm for linking the basic math library
LIBS=

# _DEPS is a macro defining the list of header files that the .c files depend on.
# It is a space separated list of header files.
# DEPS replaces each of the files with the path to that file: IDIR/*filename*.
# It uses patsubst, which is a function built into Make
# (https://www.gnu.org/software/make/manual/html_node/Text-Functions.html#Text-Functions)
# $(patsubst pattern,replacement,text)
# where % is a wildcard.
_DEPS = main.h
DEPS = $(patsubst %,$(IDIR)/%,$(_DEPS)) 

# _OBJ is a macro defining the list of object files that will generate before generating the final executable.
# OBJ replaces each of the files with the path to the file: ODIR/*filename*.
# Process is desribed above.
_OBJ = main.o 
OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))


# rule that says that each object file depends on its corresponding .c file and all of the dependency files.
# -c flag says to generate the object file.
# -o flag says to put the output of the compilation in $@.
# $@ is the file on the left side of the :.
# %< is the first file on the right side of the colon.
# expanded out this command might look like `gcc -c -o main.o main.c -I../include`.
$(ODIR)/%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

# rule run when the command `make` is executed in a directory that contains a file named makefile or Makefile.
# Says that it depends on the list of object files, so if any change, it will recompile executable.
# $^ are all of the files on the right side of the :
# expanded this might look like `gcc -o main main.o -I../include -ledit`
main: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

# prevents make from doing anything with a file called clean
.PHONY: clean

# removes any object files and any core dumps caused by seg faults (core)
clean:
	rm -rf $(ODIR)/*.o *~ core
