OS = $(shell uname)
CC = clang
CFLAGS = -O3 -ggdb -flto -Wno-deprecated-declarations
LFLAGS = -L ../intermediates -lshoebill_core -framework GLUT -framework OpenGL -ledit

all: debugger

debugger: Makefile debugger.c debugger-glut.c ../intermediates/libshoebill_core.a
ifeq ($(OS),Linux)
	./lin_build.sh
else
	$(CC) $(CFLAGS) $(LFLAGS) debugger.c debugger-glut.c -o debugger
endif

clean:
	find . -type f -not -name '*sh' -not -name 'Makefile' -not -name 'win_build.bat' -not -name 'debugger.c' -not -name '=' | xargs rm -f
