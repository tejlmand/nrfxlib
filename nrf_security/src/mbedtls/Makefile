# Also see "include/mbedtls/config.h"

# Those shall only bet set if glue is enabled
ifeq ($(GLUE),yes)
LOCAL_GLUE_FLAGS =	-UMBEDTLS_AES_ALT			\
			-UMBEDTLS_CCM_ALT			\
			-UMBEDTLS_CMAC_ALT			\
			-UMBEDTLS_DHM_ALT			\
			-UMBEDTLS_ECDH_GEN_PUBLIC_ALT		\
			-UMBEDTLS_ECDH_COMPUTE_SHARED_ALT	\
			-UMBEDTLS_ECDSA_VERIFY_ALT		\
			-UMBEDTLS_ECDSA_SIGN_ALT		\
			-UMBEDTLS_ECDSA_GENKEY_ALT
endif

LOCAL_CFLAGS = $(LOCAL_GLUE_FLAGS) $(LOCAL_WARNING_CFLAGS) $(LOCAL_INCLUDE_DIRS)
LOCAL_LDFLAGS =

# Set AR_DASH= (empty string) to use an ar implentation that does not accept
# the - prefix for command line options (e.g. llvm-ar)
AR_DASH ?= -

ARFLAGS = $(AR_DASH)src

OBJS_CRYPTO=	aes.o		aesni.o		arc4.o		\
		aria.o		asn1parse.o	asn1write.o	\
		base64.o	bignum.o	blowfish.o	\
		camellia.o	ccm.o		chacha20.o	\
		chachapoly.o	cipher.o	                \
		cmac.o		des.o				\
		dhm.o		ecdh.o		ecdsa.o		\
		ecjpake.o	ecp.o				\
		ecp_curves.o	entropy_poll.o			\
		error.o		gcm.o		havege.o	\
		hkdf.o						\
		hmac_drbg.o	md.o		md2.o		\
		md4.o		md5.o				\
		memory_buffer_alloc.o		nist_kw.o	\
		oid.o		padlock.o	replacements/pem.o \
		pk.o		pkcs12.o			\
		pkcs5.o		pkparse.o	pkwrite.o	\
		platform.o	platform_util.o	poly1305.o	\
		ripemd160.o	rsa_internal.o	rsa.o  		\
		sha1.o		sha256.o	sha512.o	\
		threading.o	timing.o	version.o	\
		version_features.o		xtea.o

OBJS_X509=	certs.o		pkcs11.o	x509.o		\
		x509_create.o	x509_crl.o	x509_crt.o	\
		x509_csr.o	x509write_crt.o	x509write_csr.o

OBJS_TLS=	debug.o		net_sockets.o			\
		ssl_cache.o	replacements/ssl_ciphersuites.o	\
		ssl_cli.o	ssl_cookie.o			\
		ssl_srv.o	ssl_ticket.o			\
		ssl_tls.o

OBJS_MBEDWRAP =	ctr_drbg.o	pk_wrap.o	md_wrap.o	\
		replacements/entropy.o replacements/cipher_wrap.o

.SILENT:

.PHONY: all static clean

all: static

static: libmbedcrypto_vanilla.a libmbedx509_vanilla.a libmbedtls_vanilla.a libmbedwrap.a

libmbedwrap.a: $(OBJS_MBEDWRAP)
	echo "  AR    $@"
	$(AR) $(ARFLAGS) $@ $(OBJS_MBEDWRAP)

# tls
libmbedtls_vanilla.a: $(OBJS_TLS)
	echo "  AR    $@"
	$(AR) $(ARFLAGS) $@ $(OBJS_TLS)

# x509
libmbedx509_vanilla.a: $(OBJS_X509)
	echo "  AR    $@"
	$(AR) $(ARFLAGS) $@ $(OBJS_X509)


# crypto
libmbedcrypto_vanilla.a: $(OBJS_CRYPTO)
	echo "  AR    $@"
	$(AR) $(ARFLAGS) $@ $(OBJS_CRYPTO)

%.o: $(MBEDTLS_DIR)/library/%.c
	echo "  CC    $<"
	$(CC) $(LOCAL_CFLAGS) $(CFLAGS) -o $@ -c $<

replacements/%.o: $(NRFXLIB_DIR)/nrf_security/src/mbedtls/replacements/%.c
	echo "  CC    $<"
	$(CC) $(LOCAL_CFLAGS) $(CFLAGS) -o $@ -c $<

replacements/entropy.o: $(NRFXLIB_DIR)/nrf_security/src/backend/cc310/replacements/entropy.c
	echo "  CC    $<"
	$(CC) $(LOCAL_CFLAGS) $(CFLAGS) -o $@ -c $<

clean:
	rm -f *.o replacements/*.o libmbed*
