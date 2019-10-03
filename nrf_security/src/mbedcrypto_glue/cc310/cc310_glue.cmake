#
# Copyright (c) 2019 Nordic Semiconductor
#
# SPDX-License-Identifier: LicenseRef-BSD-5-Clause-Nordic
#
kconfig_mbedtls_debug("######### Creating cc310 glue library #########")

if (CONFIG_GLUE_MBEDTLS_AES_C AND CC310_MBEDTLS_AES_C)
  set(GLUE_CC310_MBEDTLS_AES_C TRUE)
  kconfig_mbedtls_debug("cc310 backend glue: AES")
endif()

if (CONFIG_GLUE_MBEDTLS_CCM_C AND CC310_MBEDTLS_CCM_C)
  set(GLUE_CC310_MBEDTLS_CCM_C TRUE)
  kconfig_mbedtls_debug("cc310 backend glue: CCM")
endif()

if (CONFIG_GLUE_MBEDTLS_DHM_C AND CC310_MBEDTLS_DHM_C)
  set(GLUE_CC310_MBEDTLS_DHM_C TRUE)
  kconfig_mbedtls_debug("cc310 backend glue: DHM")
endif()


zephyr_library_named(mbedcrypto_glue_cc310)

#
# Adding cc310 backend glue files
#
zephyr_library_sources_ifdef(GLUE_CC310_MBEDTLS_AES_C
  ${CMAKE_CURRENT_LIST_DIR}/aes_cc310.c
)
zephyr_library_sources_ifdef(GLUE_CC310_MBEDTLS_CCM_C
  ${CMAKE_CURRENT_LIST_DIR}/ccm_cc310.c
)
zephyr_library_sources_ifdef(GLUE_CC310_MBEDTLS_DHM_C
  ${CMAKE_CURRENT_LIST_DIR}/dhm_cc310.c
)

zephyr_library_sources(${ZEPHYR_BASE}/misc/empty_file.c)

zephyr_library_compile_definitions(MBEDTLS_BACKEND_PREFIX=cc310)
zephyr_library_link_libraries(${IMAGE}mbedtls_common_glue)
kconfig_mbedtls_debug_list_target_files(${IMAGE}mbedcrypto_glue_cc310)
#
# Rename the external symbols as referenced through the glue files
# The APIs will match cc310_mbedtls_<xxxx> after this.
#
add_custom_command(
  TARGET ${IMAGE}mbedcrypto_glue_cc310
  POST_BUILD
  COMMAND ${CMAKE_OBJCOPY}
          --redefine-syms
          ${CMAKE_CURRENT_BINARY_DIR}/symbol_rename_cc310.txt
          $<TARGET_FILE:${IMAGE}mbedcrypto_glue_cc310>
)
