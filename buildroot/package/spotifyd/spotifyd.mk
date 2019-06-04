################################################################################
#
# spotifyd
#
################################################################################

SPOTIFYD_VERSION = master
#SPOTIFYD_SITE = $(call github,Spotifyd,spotifyd,$(SPOTIFYD_VERSION))
SPOTIFYD_SITE = $(call github,Spotifyd,spotifyd,master)
SPOTIFYD_LICENSE = GPL-3.0
SPOTIFYD_LICENSE_FILES = LICENSE

SPOTIFYD_DEPENDENCIES = host-cargo

SPOTIFYD_CARGO_ENV = CARGO_HOME=$(HOST_DIR)/share/cargo \
 CC=$(HOST_DIR)/bin/arm-buildroot-linux-gnueabihf-gcc \
 PKG_CONFIG_ALLOW_CROSS=1 \
 OPENSSL_LIB_DIR=$(HOST_DIR)/lib \
 OPENSSL_INCLUDE_DIR=$(HOST_DIR)/include 
SPOTIFYD_CARGO_MODE = $(if $(BR2_ENABLE_DEBUG),debug,release)

SPOTIFYD_BIN_DIR = target/$(RUSTC_TARGET_NAME)/release

SPOTIFYD_CARGO_OPTS = \
  --$(SPOTIFYD_CARGO_MODE) \
    --target=$(RUSTC_TARGET_NAME) \
    --manifest-path=$(@D)/Cargo.toml

define SPOTIFYD_BUILD_CMDS
    $(TARGET_MAKE_ENV) $(SPOTIFYD_CARGO_ENV) \
          cargo build $(SPOTIFYD_CARGO_OPTS)
endef

define SPOTIFYD_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/$(SPOTIFYD_BIN_DIR)/spotifyd \
           $(TARGET_DIR)/usr/bin/spotifyd
    $(INSTALL) -D -m 0755 $(BR2_EXTERNAL_HIFIBERRY_PATH)/package/spotifyd/spotifyd-notification \
           $(TARGET_DIR)/opt/hifiberry/bin/spotifyd-notification
    $(INSTALL) -D -m 0644 $(BR2_EXTERNAL_HIFIBERRY_PATH)/package/spotifyd/spotifyd.conf \
           $(TARGET_DIR)/etc/spotifyd.conf
    $(INSTALL) -D -m 0755 $(BR2_EXTERNAL_HIFIBERRY_PATH)/package/spotifyd/spotify-watchdog \
           $(TARGET_DIR)/opt/hifiberry/bin/spotify-watchdog

endef

define SPOTIFYD_INSTALL_INIT_SYSV
        $(INSTALL) -D -m 0755 $(BR2_EXTERNAL_HIFIBERRY_PATH)/package/spotifyd/S99spotify \
                $(TARGET_DIR)/etc/init.d/S99spotify
        $(INSTALL) -D -m 0755 $(BR2_EXTERNAL_HIFIBERRY_PATH)/package/spotifyd/S99spotify-watchdog \
                $(TARGET_DIR)/etc/init.d/S99spotify-watchdog

endef

define DSPTOOLKIT_INSTALL_INIT_SYSTEMD
        $(INSTALL) -D -m 0755 $(BR2_EXTERNAL_HIFIBERRY_PATH)/package/spotifyd/spotify.service \
                $(TARGET_DIR)/lib/systemd/system/spotify.service
endef

$(eval $(generic-package))