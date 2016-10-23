
DST = build
RM = rm -vrdf
CP = cp
MKDIR = mkdir -p
CMAKE = cmake


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

.PHONY: load
load: | $(DST)/release
	cd $(DST)/release && $(MAKE) launchctl_load

.PHONY: unload
unload: | $(DST)/release
	cd $(DST)/release && $(MAKE) launchctl_unload

.PHONY: install
install: setup $(DST)/release
	cd $(DST)/release && $(MAKE) install
	$(MAKE) load

.PHONY: uninstall
uninstall: | $(DST)/release
	$(MAKE) unload
	cd $(DST)/release && $(MAKE) uninstall

.PHONY: clean
clean:
	$(RM) $(DST) tmp
