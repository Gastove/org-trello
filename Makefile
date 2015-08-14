PACKAGE=org-trello
VERSION=$$(grep "^;; Version: " $(PACKAGE).el | cut -f3 -d' ')
ARCHIVE=$(PACKAGE)-$(VERSION).tar
EMACS=emacs

.PHONY: clean

pr:
	hub pull-request -b org-trello:master

deps:
	cask

build:
	cask build

clean-dist:
	rm -rf dist/

clean: clean-dist
	rm -rf *.tar
	cask clean-elc

install:
	cask install

test: clean
	cask exec ert-runner

pkg-file:
	cask pkg-file

pkg-el: pkg-file
	cask package

package: clean pkg-el
	cp dist/$(ARCHIVE) .
	make clean-dist

info:
	cask info

install-package-from-melpa:
	./install-package-from.sh melpa

install-file-with-deps-from-melpa: package
	./install-file-with-deps-from.sh melpa $(VERSION)

cleanup-data:
	rm -rvf ~/.emacs.d/elnode/public_html/org-trello/{1,2,3}/.scanning/* \
		~/.emacs.d/elnode/public_html/org-trello/{1,2,3}/* \
		~/.emacs.d/elnode/public_html/org-trello/*.lock

release:
	./release.sh $(VERSION) $(PACKAGE)

version:
	echo "application $(PACKAGE): $(VERSION)\npackage: $(ARCHIVE)"

install-cask:
	curl -fsSkL https://raw.github.com/cask/cask/master/go | python

emacs-install-clean: package
	~/bin/emacs/emacs-install-clean.sh ./$(ARCHIVE)

respect-convention:
	./contrib/respect-elisp-conventions.sh
