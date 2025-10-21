# Compiler and flags
CXX = clang++
CC = clang
ARCH = arm64
CXXFLAGS = -std=c++17 -Wall -Iinclude -arch $(ARCH)
CFLAGS = -Wall -Iinclude -arch $(ARCH)

# Homebrew paths (auto-detected)
BREW_PREFIX := $(shell brew --prefix)
CXXFLAGS += -I$(BREW_PREFIX)/include
LDFLAGS = -L$(BREW_PREFIX)/lib -arch $(ARCH)

# Directories
SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin

# Output binary
TARGET = $(BIN_DIR)/app

# Source and object files
CPP_SRCS = $(wildcard $(SRC_DIR)/*.cpp)
C_SRCS   = $(wildcard $(SRC_DIR)/*.c)
OBJS     = $(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(CPP_SRCS)) \
           $(patsubst $(SRC_DIR)/%.c,   $(OBJ_DIR)/%.o, $(C_SRCS))

# macOS frameworks and libraries
LIBS = -lglfw -framework OpenGL

# Default target
all: $(TARGET)

$(TARGET): $(OBJS)
	@mkdir -p $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

run: all
	./$(TARGET)

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

.PHONY: all run clean

