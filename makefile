include config.mk

LIBNAME = lpeg
LUADIR = ../lua/

COPT = -O2 -DNDEBUG
# COPT = -g

CWARNS = -Wall -Wextra -pedantic \
	-Waggregate-return \
	-Wcast-align \
	-Wcast-qual \
	-Wdisabled-optimization \
	-Wpointer-arith \
	-Wshadow \
	-Wsign-compare \
	-Wundef \
	-Wwrite-strings \
	-Wbad-function-cast \
	-Wdeclaration-after-statement \
	-Wmissing-prototypes \
	-Wnested-externs \
	-Wstrict-prototypes \
# -Wunreachable-code \


CFLAGS = $(CWARNS) $(COPT) -std=c99 -I$(LUADIR) -fPIC
CC = gcc
AR = ar
RANLIB = ranlib


FILES = lpvm.o lpcap.o lptree.o lpcode.o lpprint.o

build: liblpeg.so liblpeg.a

liblpeg.so: $(FILES)
	env $(CC) $(LDFLAGS) $(FILES) -o liblpeg.so

liblpeg.a: $(FILES)
	env $(AR) rc liblpeg.a $(FILES)
	env $(RANLIB) liblpeg.a

install: liblpeg.so liblpeg.a
	@echo installing library files to ${PREFIX}/lib
	@cp -v liblpeg.a liblpeg.so ${PREFIX}/lib

$(FILES): makefile

test: test.lua re.lua lpeg.so
	./test.lua

clean:
	rm -f $(FILES) liblpeg.so liblpeg.a


lpcap.o: lpcap.c lpcap.h lptypes.h
lpcode.o: lpcode.c lptypes.h lpcode.h lptree.h lpvm.h lpcap.h
lpprint.o: lpprint.c lptypes.h lpprint.h lptree.h lpvm.h lpcap.h
lptree.o: lptree.c lptypes.h lpcap.h lpcode.h lptree.h lpvm.h lpprint.h
lpvm.o: lpvm.c lpcap.h lptypes.h lpvm.h lpprint.h lptree.h

