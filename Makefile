# -*- mode: makefile-gmake; coding: utf-8 -*-

SHELL       = /bin/bash
GET         = wget
SOURCE_VER  = 1.3.0
SOURCE_URL  = http://www.zeroc.com/download/IceE/1.3
SOURCE_FILE = IceE-$(SOURCE_VER)-linux.tar.gz


all:

download:
	$(GET) $(SOURCE_URL)/$(SOURCE_FILE)

extract:
	tar -zxvf $(SOURCE_FILE)

install:
	install -d $(DESTDIR)/usr/
	cp -r IceE-$(SOURCE_VER)/cppe/include $(DESTDIR)/usr/

build-package:
	ian-build

debian-package: download extract build-package


vclean:
	ian-clean
	rm -fr $(SOURCE_FILE) IceE-$(SOURCE_VER)
