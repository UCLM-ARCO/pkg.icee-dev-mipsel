# -*- mode: makefile-gmake; coding: utf-8 -*-

# libs goes to: /usr/mipsel-linux-gnu/lib
# headers in:   /usr/mipsel-linux-gnu/include

SHELL       = /bin/bash
GET         = wget
SOURCE_VER  = 1.3.0
SOURCE_URL  = http://www.zeroc.com/download/IceE/1.3
SOURCE_FILE = IceE-$(SOURCE_VER)-linux.tar.gz
SOURCE_DIR  = IceE-$(SOURCE_VER)


all:

install: HEADERS_DIR = $(DESTDIR)/usr/mipsel-linux-gnu/include
install: BIN_DIR = $(DESTDIR)/usr/bin
install:
	install -d $(HEADERS_DIR)/IceE
	cp -r $(SOURCE_DIR)/cppe/include/IceE/*.h $(HEADERS_DIR)/IceE
	cp -r $(SOURCE_DIR)/slice/IceE/*.h $(HEADERS_DIR)/IceE

	install -d $(BIN_DIR)
	cp $(SOURCE_DIR)/cpp/bin/slice2cppe $(BIN_DIR)

download:
	$(GET) $(SOURCE_URL)/$(SOURCE_FILE)

extract:
	tar -zxvf $(SOURCE_FILE)

configure:
	$(MAKE) -C $(SOURCE_DIR) configure \
	    HAS_ROUTER=no \
	    HAS_LOCATOR=no \
	    HAS_BATCH=no \
	    HAS_WSTRING=no \
	    HAS_OPAQUE_ENDPOINTS=yes \
	    HAS_AMI=no

compile-slices: SLICE2CPPE = $(SOURCE_DIR)/cpp/bin/slice2cppe
compile-slices:
	for f in $(SOURCE_DIR)/slice/IceE/*.ice; do\
	    $(SLICE2CPPE) $$f --ice \
	        -I$(SOURCE_DIR)/slice \
		--output-dir $(SOURCE_DIR)/slice/IceE; \
	done

build-package:
	ian-build

debian-package: download extract configure compile-slices build-package


vclean:
	ian-clean
	rm -fr $(SOURCE_FILE) $(SOURCE_DIR)
