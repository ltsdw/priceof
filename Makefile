#installdir=$(HOME)/.local/bin
installdir=build
install_flags=--installdir=$(installdir) --overwrite-policy=always --install-method=copy
package=priceof

install:
ifeq ($(package),)
	@echo "nothing was done, specify the package to INSTALL: make package=package_name"
else
	cabal v2-install $(package) $(install_flags)
endif

uninstall:
ifeq ($(package),)
	@echo "nothing was done, specify the package to DELETE: make package=package_name"
else
	@echo "removing $(package)"
	@rm -rf $(installdir)/$(package)
	@echo "done!"
endif

help:
	@echo "use make install package=package_name or uninstall package=package_name"


