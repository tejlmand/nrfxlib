
LOCAL_INCLUDE_DIRS =	-I$(MBEDTLS_DIR)/include		\
			-I$(MBEDTLS_DIR)/include/mbedtls

LOCAL_GLUE_FLAGS =  -DMBEDTLS_AES_ALT			\
	      -DMBEDTLS_CCM_ALT			\
	      -DMBEDTLS_CMAC_ALT		\
	      -DMBEDTLS_DHM_ALT			\
	      -DMBEDTLS_ECDH_GEN_PUBLIC_ALT	\
	      -DMBEDTLS_ECDH_COMPUTE_SHARED_ALT	\
	      -DMBEDTLS_ECDSA_VERIFY_ALT	\
	      -DMBEDTLS_ECDSA_SIGN_ALT		\
	      -DMBEDTLS_ECDSA_GENKEY_ALT

LOCAL_CFLAGS = $(LOCAL_GLUE_FLAGS) $(LOCAL_WARNING_CFLAGS) $(LOCAL_INCLUDE_DIRS)
LOCAL_LDFLAGS =

# Set AR_DASH= (empty string) to use an ar implentation that does not accept
# the - prefix for command line options (e.g. llvm-ar)
AR_DASH ?= -

ARFLAGS = $(AR_DASH)src

OBJS_GLUE=	aes_alt.o	ccm_alt.o	dhm_alt.o	\
		ecdh_alt.o	ecdsa_alt.o	platform_alt.o	\
		rsa_alt.o

OBJS_GLUE_CC310=	cc310/aes_cc310.o	cc310/ccm_cc310.o	\
			cc310/cmac_cc310.o	cc310/dhm_cc310.o	\
			cc310/ecdh_cc310.o	cc310/ecdsa_cc310.o	\
			cc310/rsa_cc310.o

OBJS_GLUE_VANILLA=	vanilla/aes_vanilla.o	vanilla/ccm_vanilla.o	\
			vanilla/cmac_vanilla.o	vanilla/dhm_vanilla.o	\
			vanilla/ecdh_vanilla.o	vanilla/ecdsa_vanilla.o	\
			vanilla/rsa_vanilla.o

.SILENT:

.PHONY: all static clean

all: static

static: libmbedcrypto_glue.a libmbedcrypto_glue_cc310.a libmbedcrypto_glue_vanilla.a

# crypto glue
libmbedcrypto_glue.a: $(OBJS_GLUE)
	echo "  AR    $@"
	$(AR) $(ARFLAGS) $@ $(OBJS_GLUE)

libmbedcrypto_glue_cc310.a: $(OBJS_GLUE_CC310)
	echo "  AR    $@"
	$(AR) $(ARFLAGS) $@ $(OBJS_GLUE_CC310)

libmbedcrypto_glue_vanilla.a: $(OBJS_GLUE_VANILLA)
	echo "  AR    $@"
	$(AR) $(ARFLAGS) $@ $(OBJS_GLUE_VANILLA)

%.o: %.c
	echo "  CC    $<"
	$(CC) $(LOCAL_CFLAGS) $(CFLAGS) -o $@ -c $<

vanilla/%.o: vanilla/%.c
	echo "  CC    $<"
	$(CC) -DMBEDTLS_BACKEND_PREFIX=vanilla $(LOCAL_CFLAGS) $(CFLAGS) -o $@ -c $<

cc310/%.o: cc310/%.c
	echo "  CC    $<"
	$(CC) -DMBEDTLS_BACKEND_PREFIX=cc310 $(LOCAL_CFLAGS) $(CFLAGS) -o $@ -c $<

clean:
	rm -f *.o cc310/*.o vanilla/*.o libmbed*
