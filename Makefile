builddir=build
installdir=/usr/bin/
install_flags=--installdir=$(builddir) --overwrite-policy=always --install-method=copy
package=priceof

all:
ifeq ($(package),)
	@echo "nothing was done"
else
	@cabal update
	@cabal v2-install $(package) $(install_flags)
endif

install:
ifeq ($(package),)
	@echo "nothing was done"
else
	@install -Dm755 $(builddir)/$(package) $(installdir)
	@echo "installed!"
endif

clean:
	@rm -rf $(builddir) dist-newstyle

uninstall:
ifeq ($(package),)
	@echo "nothing was done"
else
	@echo "removing $(package)"
	@rm -rf $(installdir)/$(package)
	@echo "done!"
endif

help:
	@echo "make - to build it"
	@echo "sudo make install - to install it"
	@echo "sudo make uninstall - to uninstall it"
	@echo "make clean - clear out build process"
