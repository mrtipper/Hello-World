# Makefile for Hello World project.
#
# The directory structure is:
# ./README
# ./Makefile
# ./include
# ./src
# ./build
# The include dir contains the project header files.
# The src dir contains the project source files.

# The first defined rule is used when invoking make with no arguments.
.PHONY: default_goal
default_goal: all

INCLUDE_DIR = include
BUILD_DIR = build
SRC_DIR = src
OBJ_DIR = $(BUILD_DIR)/obj

CC = gcc
CFLAGS = -Wall -Werror -I$(INCLUDE_DIR)
LDFLAGS = -I$(INCLUDE_DIR)

# define the C source files
SRCS = hello.c

# define the output executable
EXECUTABLE = hello

# ---------------------------------------------------------------
# The following are main build targets intended to be build
# as arguments to make.
# ---------------------------------------------------------------

# build the project.
.PHONY: all
all: $(BUILD_DIR)/$(EXECUTABLE)
	@echo "************************************************"
	@echo "Build Completed."
	@echo "************************************************"

# clean the project.
.PHONY: clean
clean:
	@rm -rf $(BUILD_DIR)
	@echo "== Clean Done. =="

# ---------------------------------------------------------------
# The following are helper build targets that can be used as
# make arguments, but are used as steps to build the main
# build targets specified above.
# ---------------------------------------------------------------

# ---------------------------------------------------------------
# The following are generic rules to build .c files into
# .o files with .d files. The .o's are then linked to
# generate the final executable.
# ---------------------------------------------------------------

# define the C object files 
#
# This uses Suffix Replacement within a macro:
#   $(name:string1=string2)
#         For each word in 'name' replace 'string1' with 'string2'
# Below we are replacing the suffix .c of all words in the macro SRCS
# with the .o suffix
OBJS = $(SRCS:.c=.o)

# include the *.d dependency files which contains entries that will
# be appendeded to the OBJS to include header dependecies.
-include $(OBJS:.o=.d)

# pattern rule for building .o's from .c's. It uses automatic 
# variables $<: the name of the prerequisite of the rule(a .c file)
# and $@: the name of the target of the rule (a .o file) 
# (see the gnu make manual section about automatic variables)
# The pattern rule replaces the obsolete suffix replacement rule .c.o
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(OBJ_DIR)
	@$(CC) $(CFLAGS) -c $< -o $@
	@echo "CC $<"

# Link the .o's to generate the final EXECUTABLE
$(BUILD_DIR)/$(EXECUTABLE): $(OBJ_DIR)/$(OBJS)
	@mkdir -p $(BUILD_DIR)
	@$(CC) $(LFLAGS) $(OBJ_DIR)/$(OBJS) -o $@ 
	@echo "LNK $@"
