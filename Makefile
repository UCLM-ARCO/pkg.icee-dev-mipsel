# -*- mode: makefile-gmake; coding: utf-8 -*-

SHELL       = /bin/bash
GET         = wget
SOURCE_VER  = 1.3.0
SOURCE_URL  = http://www.zeroc.com/download/IceE/1.3
SOURCE_FILE = IceE-$(SOURCE_VER)-linux.tar.gz
SOURCE_DIR  = IceE-$(SOURCE_VER)


all:

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

install:
	install -d $(DESTDIR)/usr/
	cp -r $(SOURCE_DIR)/cppe/include $(DESTDIR)/usr/

build-package:
	ian-build

debian-package: download extract configure build-package


vclean:
	ian-clean
	rm -fr $(SOURCE_FILE) $(SOURCE_DIR)
