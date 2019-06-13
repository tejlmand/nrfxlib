.. _crypto_changelog_nrf_cc310_platform:

Changelog - nRF cc310 platform
##############################

All notable changes to this project are documented in this file.

nrf_cc310_platform – 0.9.0
**************************

Initial release.

Added
=====

Added the following nRF cc310 platform libraries for nRF9160 and nRF52 architectures.

This library is used for initialization of Arm cc310 Hardware, random number generation (TRNG and PRNG), RTOS integration.

.. note::
   This library is a dependency of nrf_cc310_mbedcrypto. The equivalent library
   version must be used for correct behavior (e.g. hard/soft-float, with/without
   interrupts and with/without short wchar support).

.. note::
   short-wchar: Those libraries are compiled with a wchar_t size of 16 bits.


* nrf_cc310_platform, nRF9160 variants

  * ``cortex-m33/hard-float/libnrf_cc310_platform_0.9.0.a``
  * ``cortex-m33/soft-float/libnrf_cc310_platform_0.9.0.a``

  * No interrupts

    * ``cortex-m33/soft-float/no-interrupts/libnrf_cc310_platform_0.9.0.a``
    * ``cortex-m33/hard-float/no-interrupts/libnrf_cc310_platform_0.9.0.a``

  * short-wchar

    * ``cortex-m33/hard-float/short-wchar/libnrf_cc310_platform_0.9.0.a``
    * ``cortex-m33/soft-float/short-wchar/libnrf_cc310_platform_0.9.0.a``

  * short-wchar, No interrupts

    * ``cortex-m33/hard-float/short-wchar/no-interrupts/libnrf_cc310_platform_0.9.0.a``
    * ``cortex-m33/soft-float/short-wchar/no-interrupts/libnrf_cc310_platform_0.9.0.a``

* nrf_cc310_platform, nRF52 variants

  * ``cortex-m4/soft-float/libnrf_cc310_platform_0.9.0.a``
  * ``cortex-m4/hard-float/libnrf_cc310_platform_0.9.0.a``

  * No interrupts

    * ``cortex-m4/hard-float/no-interrupts/libnrf_cc310_platform_0.9.0.a``
    * ``cortex-m4/soft-float/no-interrupts/libnrf_cc310_platform_0.9.0.a``

  * short-wchar

    * ``cortex-m4/soft-float/short-wchar/libnrf_cc310_platform_0.9.0.a``
    * ``cortex-m4/hard-float/short-wchar/libnrf_cc310_platform_0.9.0.a``

  * short-wchar, No interrupts

    * ``cortex-m4/soft-float/short-wchar/no-interrupts/libnrf_cc310_platform_0.9.0.a``
    * ``cortex-m4/hard-float/short-wchar/no-interrupts/libnrf_cc310_platform_0.9.0.a``
