#
# Copyright (c) 2021 Nordic Semiconductor ASA
#
# SPDX-License-Identifier: BSD-3-Clause
#

if(RADIO_DRIVER)
  add_subdirectory(driver)
  add_subdirectory(sl)
endif()

if(SERIALIZATION)
  add_subdirectory(serialization)
endif()


