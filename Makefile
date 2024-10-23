# Makefile for managing Lua project

# Variables
LUA = lua
LUAC = luac
SRC_DIR = lua
TEST_DIR = lua/harpoon/test
BIN_DIR = bin

# Targets
.PHONY: all clean test install fmt lint pr-ready

all: install

# Install dependencies
install:
	@echo "Installing dependencies..."
	luarocks install luacheck || { echo "Failed to install luacheck"; exit 1; }
	luarocks install lua-json || { echo "Failed to install lua-json"; exit 1; }
	luarocks install penlight || { echo "Failed to install penlight"; exit 1; }
	@echo "Dependencies installed successfully."

# Run tests
test:
	@echo "Running tests..."
	@$(LUA) $(TEST_DIR)/manage_cmd_spec.lua || { echo "Tests failed"; exit 1; }

# Clean compiled files
clean:
	@echo "Cleaning up..."
	rm -rf $(BIN_DIR)/*.out || { echo "No files to clean"; }

# Compile Lua files
compile:
	@echo "Compiling Lua files..."
	mkdir -p $(BIN_DIR)
	$(LUAC) -o $(BIN_DIR)/compiled_file.out $(SRC_DIR)/**/*.lua || { echo "Compilation failed"; exit 1; }

# Format Lua files
fmt:
	@echo "===> Formatting Lua files..."
	stylua lua/ --config-path=.stylua.toml || { echo "Formatting failed"; exit 1; }
	@echo "Formatting completed."

# Lint Lua files
lint:
	@echo "===> Linting Lua files..."
	luacheck lua/ --globals vim || { echo "Linting failed"; exit 1; }
	@echo "Linting completed."

# Prepare for PR
pr-ready: fmt lint

testing:
	echo "===> Testing:"
	nvim --headless --clean \
	-u scripts/minimal.vim \
	-c "PlenaryBustedDirectory lua/refactoring/tests/ {minimal_init = 'scripts/minimal.vim'}"

ci-install-deps:
	./scripts/find-supported-languages.sh

docker-build:
	docker build --no-cache . -t refactoring

pr-ready-docker:
	docker run -v $(shell pwd):/code/refactoring.nvim -t refactoring

worktree_test:
	GIT_WORKTREE_NVIM_LOG=fatal nvim --headless --noplugin -u tests/minimal_init.vim -c "PlenaryBustedDirectory tests/ { minimal_init = './tests/minimal_init.vim' }"

rfceez_test:
	echo "===> Testing"
	nvim --headless --noplugin -u scripts/tests/minimal.vim \
        -c "PlenaryBustedDirectory lua/rfceez/test/ {minimal_init = 'scripts/tests/minimal.vim'}"