# -*- mode: makefile-gmake; coding: utf-8 -*-

# libs goes to: /usr/mipsel-linux-gnu/lib
# headers in:   /usr/mipsel-linux-gnu/include

include carambola.mk
export CXXFLAGS

SHELL       = /bin/bash
SOURCE_VER  = 1.3.0
SOURCE_URL  = http://www.zeroc.com/download/IceE/1.3
SOURCE_FILE = IceE-$(SOURCE_VER)-linux.tar.gz
SOURCE_DIR  = IceE-$(SOURCE_VER)


all:

install: HEADERS_DIR = $(DESTDIR)/usr/mipsel-linux-gnu/include
install: LIB_DIR     = $(DESTDIR)/usr/mipsel-linux-gnu/lib
install: SLICE_DIR   = $(DESTDIR)/usr/mipsel-linux-gnu/slice
install: BIN_DIR     = $(DESTDIR)/usr/bin
install:
	install -d $(HEADERS_DIR)/IceE
	cp -r $(SOURCE_DIR)/cppe/include/IceE/*.h $(HEADERS_DIR)/IceE
	cp -r $(SOURCE_DIR)/slice/IceE/*.h $(HEADERS_DIR)/IceE

	install -d $(LIB_DIR)
	cp -d $(SOURCE_DIR)/cppe/lib/* $(LIB_DIR)

	install -d $(SLICE_DIR)/IceE
	cp -r $(SOURCE_DIR)/slice/IceE/*.ice $(SLICE_DIR)/IceE

	install -d $(BIN_DIR)
	cp $(SOURCE_DIR)/cpp/bin/slice2cppe $(BIN_DIR)

download:
	wget $(SOURCE_URL)/$(SOURCE_FILE)

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

patch:
	patch -d $(SOURCE_DIR) -p1 < openwrt.patch

compile-slices: SLICE2CPPE = $(SOURCE_DIR)/cpp/bin/slice2cppe
compile-slices:
	for f in $(SOURCE_DIR)/slice/IceE/*.ice; do\
	    $(SLICE2CPPE) $$f --ice \
	        -I$(SOURCE_DIR)/slice \
		--output-dir $(SOURCE_DIR)/slice/IceE; \
	done

compile-library:
	$(MAKE) -C $(SOURCE_DIR) \
		CXX=$(CXX) \
		LDPLATFORMFLAGS="$(LDFLAGS) -nodefaultlibs -lgcc -lc -luClibc++"

build-package:
	ian-build

debian-package: download extract configure patch \
	compile-slices compile-library build-package

vclean:
	ian-clean
	rm -fr $(SOURCE_FILE) $(SOURCE_DIR)
