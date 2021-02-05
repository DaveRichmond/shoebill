OS = $(shell uname)
ifeq ($(OS), Linux)
	CC = gcc
	CFLAGS = -O3 -Wno-deprecated-declarations
else
	CC = clang
	CFLAGS = -O3 -flto -Wno-deprecated-declarations
endif

all: shoebill

shoebill: make_gui

make_gui:
	./lin_build.sh
clean:
	find . -type f -not -name '*sh' -not -name 'Makefile' -not -name 'win_build.bat' -not -name 'sdl.c' -not -name '=' | xargs rm -f
