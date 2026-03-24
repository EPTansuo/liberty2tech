CXX ?= c++
CC ?= cc
CXXFLAGS ?= -O2 -std=c++17
CFLAGS ?= -O2
CPPFLAGS ?=
LDFLAGS ?=

PROJECT := liberty2tech
SRC_CPP := src/liberty2tech.cpp
SRC_C := vendor/qflow/readliberty.c
OBJ := bin/liberty2tech.o bin/readliberty.o
BIN := bin/$(PROJECT)

.PHONY: all clean install uninstall test

all: $(BIN)

$(BIN): $(OBJ)
	mkdir -p $(dir $@)
	$(CXX) $(LDFLAGS) -o $@ $(OBJ)

bin/liberty2tech.o: $(SRC_CPP)
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

bin/readliberty.o: $(SRC_C)
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

install: $(BIN)
	mkdir -p $(HOME)/.local/bin
	cp $(BIN) $(HOME)/.local/bin/$(PROJECT)

uninstall:
	rm -f $(HOME)/.local/bin/$(PROJECT)

clean:
	rm -f $(BIN) $(OBJ)

test: $(BIN)
	./$(BIN) --help
