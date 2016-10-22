
DST = build
RM = rm -rdf
CP = cp
MKDIR = mkdir -p
CMAKE = cmake
LAUNCHD_CONFIG_DIR = /Library/LaunchAgents
CMUSCONTROLD_LOG = /tmp/cmuscontrold.log
INSTALL_DIR = /usr/local/bin


.PHONY: all
all: setup $(DST)/release

.PHONY: setup
setup:
	which -a $(CMAKE) &> /dev/null
	@echo 'setup done'

$(DST)/release:
	$(MKDIR) $@
	cd $@; \
	$(CMAKE) -DCMAKE_BUILD_TYPE=Release ../..; \
	$(MAKE)

$(DST)/debug:
	$(MKDIR) $@
	cd $@; \
	$(CMAKE) -DCMAKE_BUILD_TYPE=Debug ../..; \
	$(MAKE)

tmp:
	$(MKDIR) $@

tmp/at.fox21.cmuscontrold.plist: skel/at.fox21.cmuscontrold.plist | tmp
	sed ' \
		s|%BIN_PATH%|$(INSTALL_DIR)/cmuscontrold|g; \
		s|%LOG_PATH%|$(CMUSCONTROLD_LOG)|g; \
		' $< > $@

controld_load:
	launchctl load /Library/LaunchAgents/at.fox21.cmuscontrold.plist

controld_unload:
	launchctl unload /Library/LaunchAgents/at.fox21.cmuscontrold.plist

.PHONY: install
install: tmp/at.fox21.cmuscontrold.plist setup $(DST)/release
	sudo -v
	sudo $(CP) $< $(LAUNCHD_CONFIG_DIR)
	install -c $(DST)/release/bin/cmuscontrold $(INSTALL_DIR)
	$(MAKE) controld_load

.PHONY: uninstall
uninstall:
	sudo -v
	$(MAKE) controld_unload
	sudo $(RM) $(LAUNCHD_CONFIG_DIR)/at.fox21.cmuscontrold.plist
	$(RM) $(INSTALL_DIR)/cmuscontrold

.PHONY: clean
clean:
	$(RM) $(DST) tmp
