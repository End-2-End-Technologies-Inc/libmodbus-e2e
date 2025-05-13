/*
 * Copyright © Stéphane Raimbault <stephane.raimbault@gmail.com>
 * Copyright © End 2 End Technologies, LLC., 2025.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include <modbus.h>
#include <stdio.h>

int main(void)
{
    printf("Compiled with libmodbus_e2e version %s (%06X)\n",
           LIBMODBUS_E2E_VERSION_STRING,
           LIBMODBUS_E2E_VERSION_HEX);
    printf("Linked with libmodbus_e2e version %d.%d.%d\n",
           libmodbus_version_major,
           libmodbus_version_minor,
           libmodbus_version_micro);

    if (LIBMODBUS_VERSION_CHECK(2, 1, 0)) {
        printf("The functions to read/write float values are available (2.1.0).\n");
    }

    if (LIBMODBUS_VERSION_CHECK(2, 1, 1)) {
        printf("Oh gosh, brand new API (2.1.1)!\n");
    }

    return 0;
}
