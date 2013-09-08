LISP=/usr/bin/sbcl

clisp_BUILDOPTS=-K full -on-error exit < ./make-image.lisp
sbcl_BUILDOPTS=--load ./stumpwm.asd --load ./make-image.lisp
ccl_BUILDOPTS=--load ./make-image.lisp
ecl_BUILDOPTS=-shell ./make-image.lisp
lw_BUILDOPTS=-build ./make-image.lisp

clisp_INFOOPTS=-K full -on-error exit -x "(require 'asdf) (asdf:oos 'asdf:load-op :stumpwm) (load (compile-file \"manual.lisp\")) (stumpwm::generate-manual) (ext:exit)"
sbcl_INFOOPTS=--load ./stumpwm.asd --eval "(progn (require 'asdf) (require 'stumpwm) (load \"manual.lisp\"))" --eval "(progn (stumpwm::generate-manual) (sb-ext:quit))"
ccl_INFOOPTS=--eval "(progn (require 'asdf) (require 'stumpwm))" --load manual.lisp --eval "(progn (stumpwm::generate-manual) (quit))"
ecl_INFOOPTS=-eval "(progn (require 'asdf) (require 'stumpwm) (load \"manual.lisp\"))" -eval "(progn (stumpwm::generate-manual) (ext:quit))"
lw_INFOOPTS=-eval "(progn (require 'asdf) (load \"manual.lisp\"))" -eval "(progn (stumpwm::generate-manual) (lw:quit))"

datarootdir = ${prefix}/share
prefix=/usr/local
exec_prefix= ${prefix}
bindir=${exec_prefix}/bin
infodir=${datarootdir}/info

# You shouldn't have to edit past this

# This is copied from the .asd file. It'd be nice to have the list in
# one place, but oh well.
FILES=stumpwm.asd package.lisp primitives.lisp wrappers.lisp		\
pathnames.lisp keysyms.lisp keytrans.lisp kmap.lisp input.lisp		\
core.lisp command.lisp menu.lisp screen.lisp head.lisp group.lisp	\
window.lisp floating-group.lisp tile-window.lisp window-placement.lisp	\
message-window.lisp selection.lisp user.lisp iresize.lisp		\
bindings.lisp events.lisp help.lisp fdump.lisp mode-line.lisp		\
time.lisp color.lisp module.lisp stumpwm.lisp version.lisp

all: stumpwm stumpwm.info

stumpwm.info: stumpwm.texi
	makeinfo stumpwm.texi

# FIXME: This rule is too hardcoded
stumpwm.texi: stumpwm.texi.in
	$(LISP) $(sbcl_INFOOPTS)

stumpwm: $(FILES)
	$(LISP) $(sbcl_BUILDOPTS)

release:
	git tag -a -m "version 0.9.7" 0.9.7
	git archive --format=tar --prefix=stumpwm-0.9.7/ HEAD > stumpwm-0.9.7.tar
	tar xf stumpwm-0.9.7.tar
	cd stumpwm-0.9.7 && tar zxf @PPCRE_PATH@/../cl-ppcre.tar.gz && mv cl-ppcre-* cl-ppcre
	git log > stumpwm-0.9.7/ChangeLog
	cp configure stumpwm-0.9.7/
	tar zcf stumpwm-0.9.7.tgz stumpwm-0.9.7
	rm -fr stumpwm-0.9.7/ stumpwm-0.9.7.tar

upload-release:
	gpg -b stumpwm-0.9.7.tgz
	scp stumpwm-0.9.7.tgz stumpwm-0.9.7.tgz.sig sabetts@dl.sv.nongnu.org:/releases/stumpwm/
	( echo rm stumpwm-latest.tgz.sig && echo rm stumpwm-latest.tgz && echo ln stumpwm-0.9.7.tgz stumpwm-latest.tgz && echo ln stumpwm-0.9.7.tgz.sig stumpwm-latest.tgz.sig ) | sftp -b - sabetts@dl.sv.nongnu.org:/releases/stumpwm/

clean:
	rm -f *.fasl *.fas *.lib *.*fsl
	rm -f *.log *.fns *.fn *.aux *.cp *.ky *.log *.toc *.pg *.tp *.vr *.vrs
	rm -f stumpwm stumpwm.texi stumpwm.info

install: stumpwm.info stumpwm
	test -z "$(destdir)$(bindir)" || mkdir -p "$(destdir)$(bindir)"
	install -m 755 stumpwm "$(destdir)$(bindir)"
	test -z "$(destdir)$(infodir)" || mkdir -p "$(destdir)$(infodir)"
	install -m 644 stumpwm.info "$(destdir)$(infodir)"
	install-info --info-dir="$(destdir)$(infodir)" "$(destdir)$(infodir)/stumpwm.info"

uninstall:
	rm "$(destdir)$(bindir)/stumpwm"
	install-info --info-dir="$(destdir)$(infodir)" --remove "$(destdir)$(infodir)/stumpwm.info"
	rm "$(destdir)$(infodir)/stumpwm.info"

# End of file
