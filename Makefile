release_version := $(shell GIT_CEILING_DIRECTORIES=$(PWD) bin/rbenv --version | cut -d' ' -f2)

all: share/man/man1/rbenv.1 share/man/ja/man1/rbenv.1
.PHONY: all

share/man/man1/rbenv.1: share/man/man1/rbenv.1.adoc
	asciidoctor -b manpage -a version=$(release_version:v%=%) $<

share/man/ja/man1/rbenv.1: share/man/ja/man1/rbenv.1.adoc
	asciidoctor -b manpage -a version=$(release_version:v%=%) $<

share/man/ja/man1/rbenv.1.adoc: \
		share/man/man1/rbenv.1.adoc \
		README.md \
		translation/po/ja.po \
		translation/po4a.cfg \
		translation/add_ja/credit.adoc \
		translation/add_ja/credit.md
	./src/translate $@
