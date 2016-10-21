
TARGET ?= 10.11
TARGETS_RELEASE = $(TARGET)
TARGETS_DEBUG = $(TARGET)
DST = build
RM = rm -rdf
CP = cp
MKDIR = mkdir -p
CMAKE = cmake
LAUNCHD_CONFIG_DIR = /Library/LaunchAgents
CMUSCONTROLD_LOG = /tmp/cmuscontrold.log
INSTALL_DIR = /usr/local/bin

TARGETS_RELEASE_DIR := $(addprefix $(DST)/release/target_, $(TARGETS_RELEASE))
TARGETS_DEBUG_DIR := $(addprefix $(DST)/debug/target_, $(TARGETS_DEBUG))

.PHONY: all
all: setup release

.PHONY: setup
setup:
	which -a $(CMAKE) &> /dev/null
	@echo 'setup done'

.PHONY: release
release: $(TARGETS_RELEASE_DIR)

.PHONY: debug
debug: $(TARGETS_DEBUG_DIR)

$(DST)/release/target_%:
	$(eval TARGET_STAGE := $(subst $(DST)/release/target_,,$@))
	$(MKDIR) $@
	cd $@; \
	$(CMAKE) -DCMAKE_BUILD_TYPE=Release -DCMAKE_OSX_DEPLOYMENT_TARGET=$(TARGET_STAGE) ../../..; \
	$(MAKE)

$(DST)/debug/target_%:
	$(eval TARGET_STAGE := $(subst $(DST)/debug/target_,,$@))
	$(MKDIR) $@
	cd $@; \
	$(CMAKE) -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_DEPLOYMENT_TARGET=$(TARGET_STAGE) ../../..; \
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
install: tmp/at.fox21.cmuscontrold.plist setup $(DST)/release/target_$(TARGET)
	sudo -v
	sudo $(CP) $< $(LAUNCHD_CONFIG_DIR)
	install -c $(lastword $(TARGETS_RELEASE_DIR))/bin/cmuscontrold $(INSTALL_DIR)
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
