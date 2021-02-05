OS = $(shell uname)
ifeq ($(OS), Linux)
	CC = gcc
	CFLAGS = -O3 -Wno-deprecated-declarations
else
	CC = clang
	CFLAGS = -O3 -flto -Wno-deprecated-declarations
endif

all: shoebill

shoebill: make_gui debugger

make_gui: make_core
ifeq ($(OS), Linux)
	$(MAKE) -C sdl-gui
else
	xcodebuild -project gui/Shoebill.xcodeproj SYMROOT=build
endif

debugger: make_core
ifneq ($(OS), Linux)
	$(MAKE) -C debugger
endif

make_core:
	$(MAKE) -C core -j 4

clean:
	rm -rf intermediates gui/build
ifeq ($(OS), Linux)
	find . -name "*.post.c" -exec rm {} \;
	find . -name decoder_gen -exec rm {} \;
	find . -name dis_decoder_guts.c -exec rm {} \;
	find . -name inst_decoder_guts.c -exec rm {} \;
	rm sdl-gui/shoebill
endif
