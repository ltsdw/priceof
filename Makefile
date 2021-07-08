builddir=build
installdir=/usr/bin/
install_flags=--installdir=$(builddir) --overwrite-policy=always --install-method=copy
package=priceof

all:
ifeq ($(package),)
	@echo "nothing was done"
else
	@cabal v2-install $(package) $(install_flags)
endif

install:
ifeq ($(package),)
	@echo "nothing was done"
else
	@install -Dm755 $(builddir)/$(package) $(installdir)
endif

uninstall:
ifeq ($(package),)
	@echo "nothing was done"
else
	@echo "removing $(package)"
	@rm -rf $(installdir)/$(package)
	@echo "done!"
endif

help:
	@echo "use make install package=package_name or uninstall package=package_name"


