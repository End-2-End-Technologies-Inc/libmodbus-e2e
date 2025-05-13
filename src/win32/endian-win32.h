/*
 * Copyright © End 2 End Technologies, LLC., 2025.
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 *
 * This library implements the Modbus protocol.
 * http://libmodbus.org/
 */

#ifndef WIN32_ENDIAN_H
#define WIN32_ENDIAN_H

#define __LITTLE_ENDIAN 1234
#define __BIG_ENDIAN 4321
#define __PDP_ENDIAN 3412

// Always little endian on Windows
#define __BYTE_ORDER __LITTLE_ENDIAN

#endif // WIN32_ENDIAN_H
