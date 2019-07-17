export
CC = arm-none-eabi-gcc
AR = arm-none-eabi-ar
OBJCOPY = arm-none-eabi-objcopy
DESTDIR = /tmp/tora/mbedtls

CC310_BACKEND_CONFIG ?= configs/nrf-config.cc310.h
MBEDTLS_BACKEND_CONFIG ?= configs/nrf-config.mbed.h
GLUE_BACKEND_CONFIG ?= configs/nrf-config.combo.h

MBEDTLS_CONFIG = $(NRFXLIB_DIR)/nrf_security/$(NRF_CONFIG)

# Default selection of backend implementation
NRFXLIB_DIR ?=  $(dir $(abspath $(lastword $(MAKEFILE_LIST))/../))
MBEDTLS_DIR ?=  $(dir $(abspath $(lastword $(MAKEFILE_LIST))/../../))mbedtls/
NRFSEC_DIR   =  $(NRFXLIB_DIR)/nrf_security

# Valid values: cortex-m4, cortex-m33
ARCH ?= cortex-m4
# Valid values: hard, soft
FLOAT ?= hard
# Valid values: yes, no
INTERRUPTS ?= no
VERSION ?= 0.8.2-rc1

CC310_LIB ?= $(NRFXLIB_DIR)/crypto/nrf_cc310_mbedcrypto/lib/$(ARCH)/$(FLOAT)-float/$(subst yes,,$(subst no,no-interrupts,$(INTERRUPTS)))/libnrf_cc310_mbedcrypto_$(VERSION).a
CC310_CONFIG ?= RSA SHA1 SHA256
MBEDTLS_CONFIG ?=

CC310_KEEP := $(foreach conf,$(CC310_CONFIG),-e "s/\$${KEEP_MBEDTLS_$(conf)_C}/\#/g")
MBEDTLS_KEEP := $(foreach conf,$(MBEDTLS_CONFIG),-e "s/\$${KEEP_MBEDTLS_$(conf)_C}/\#/g")
RENAME_TEMPLATE = src/mbedcrypto_glue/symbol_rename.template.txt

INCLUDE_DIRS =	-I$(MBEDTLS_DIR)/include -I$(MBEDTLS_DIR)/include/mbedtls
GLUE_INCLUDE_DIRS =	-I$(NRFSEC_DIR)/include/mbedcrypto_glue		\
			-I$(NRFSEC_DIR)/include/mbedcrypto_glue/mbedtls
CC310_INCLUDE_DIRS = 	-I$(NRFXLIB_DIR)/crypto/nrf_cc310_mbedcrypto/include/mbedtls \
			-I$(NRFXLIB_DIR)/crypto/nrf_cc310_mbedcrypto/include
WARNING_CFLAGS 	?=  -Wall
# Note: most falgs are directly copied from NCS compilation flag
CFLAGS		?= -Os -DMBEDTLS_CONFIG_FILE=\"$(MBEDTLS_CONFIG)\" $(WARNING_CFLAGS) 	\
		   $(INCLUDE_DIRS) -ffreestanding -fno-common -mthumb -mcpu=$(ARCH)  	\
		   -Wformat -Wformat-security -Wno-format-zero-length -Wno-main		\
		   -Wno-pointer-sign -Wpointer-arith -Wno-unused-but-set-variable	\
		   -Werror=implicit-int -fno-asynchronous-unwind-tables -fno-pie	\
		   -fno-pic -fno-strict-overflow -fno-reorder-functions -fno-defer-pop	\
		   -ffunction-sections -fdata-sections -mabi=aapcs -std=c99

ifeq ($(ARCH),cortex-m4)
CFLAGS += -march=armv7e-m
endif
ifeq ($(ARCH),cortex-m33)
CFLAGS += -march=armv8-m.main+dsp
endif
LDFLAGS 	?=

ifdef DEBUG
CFLAGS += -g3
endif

.PHONY: clean mbedtls-install cc310-install combo-install \
	libmbedcrypto_vanilla.a libmbedcrypto_glue.a

all:	libmbedcrypto_vanilla_backend.a libmbedcrypto_cc310_backend.a	\
	libmbedcrypto_glue.a

combo-backend: NRF_CONFIG = $(GLUE_BACKEND_CONFIG)
combo-backend: GLUE = yes
combo-backend: INCLUDE_DIRS += $(GLUE_INCLUDE_DIRS)
combo-backend: 	libmbedcrypto_vanilla_backend.a libmbedcrypto_cc310_backend.a	\
		libmbedcrypto_glue.a

cc310-backend: NRF_CONFIG = $(CC310_BACKEND_CONFIG)
cc310-backend: INCLUDE_DIRS += $(CC310_INCLUDE_DIRS)
cc310-backend: libmbedcrypto_vanilla.a

mbedtls-backend: NRF_CONFIG = $(MBEDTLS_BACKEND_CONFIG)
mbedtls-backend: libmbedcrypto_vanilla.a

libmbedcrypto_vanilla.a:
	$(MAKE) -C src/mbedtls

libmbedcrypto_glue.a:
	$(MAKE) -C src/mbedcrypto_glue

libmbedcrypto_vanilla_backend.a: libmbedcrypto_vanilla.a
	@echo 'renaming symbols in $<'
	sed $(VANILLA_KEEP) -e 's/\$${MBEDTLS_BACKEND_PREFIX}/vanilla/g' -e 's/\$${KEEP_[_A-Z0-9]*}//g' $(RENAME_TEMPLATE) > $(RENAME_TEMPLATE:.template.txt=.vanilla.txt)
	$(OBJCOPY) --redefine-syms $(RENAME_TEMPLATE:.template.txt=.vanilla.txt) src/mbedtls/$< $@

# Remember to export conf settings in glue for building


libmbedcrypto_cc310_backend.a:
	@echo 'renaming symbols in $(CC310_LIB)'
	sed $(CC310_KEEP) -e 's/\$${MBEDTLS_BACKEND_PREFIX}/cc310/g' -e 's/\$${KEEP_[_A-Z0-9]*}//g' $(RENAME_TEMPLATE) > $(RENAME_TEMPLATE:.template.txt=.cc310.txt)
	$(OBJCOPY) --redefine-syms $(RENAME_TEMPLATE:.template.txt=.cc310.txt) $(CC310_LIB) $@

mbedtls-install:
	mkdir -p $(DESTDIR)/include/mbedtls
	cp -rp $(MBEDTLS_DIR)/include/mbedtls $(DESTDIR)/include
	mkdir -p $(DESTDIR)/lib
	cp -RP src/mbedtls/libmbedtls_vanilla.*    $(DESTDIR)/lib
	cp -RP src/mbedtls/libmbedx509_vanilla.*   $(DESTDIR)/lib
	cp -RP $(if $(GLUE),libmbedcrypto_vanilla_backend.*,src/mbedtls/libmbedcrypto_vanilla.*) $(DESTDIR)/lib

cc310-install: mbedtls-install
	cp -RP $(NRFXLIB_DIR)/crypto/nrf_cc310_mbedcrypto/include/mbedtls $(DESTDIR)/include
	cp -RP $(CC310_LIB) $(DESTDIR)/lib

combo-install: GLUE = yes
combo-install: mbedtls-install
	cp -RP $(NRFSEC_DIR)/include/mbedcrypto_glue/mbedtls $(DESTDIR)/include
	cp -RP src/mbedcrypto_glue/libmbed*.* $(DESTDIR)/lib
	cp -RP libmbedcrypto_cc310_backend.* $(DESTDIR)/lib

clean:
	$(MAKE) -C src/mbedtls clean
	$(MAKE) -C src/mbedcrypto_glue clean
	rm -f libmbed*.a
	rm -f $(RENAME_TEMPLATE:.template.txt=.cc310.txt)
	rm -f $(RENAME_TEMPLATE:.template.txt=.vanilla.txt)
