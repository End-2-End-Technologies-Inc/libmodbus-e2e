# modbus_mask_write_register

## Name

modbus_mask_write_register - mask a single register

## Synopsis

```c
int modbus_mask_write_register(modbus_t *ctx, int addr, uint16_t and, uint16_t or);
```

## Description

The *modbus_mask_write_register()* function shall modify the value of the
holding register at the address 'addr' of the remote device using the algorithm:

  new value = (current value AND 'and') OR ('or' AND (NOT 'and'))

The function uses the Modbus function code 0x16 (mask single register).

## Return value

The function shall return 1 if successful. Otherwise it shall return -1 and set
errno.

## See also

- [modbus_read_registers](modbus_read_registers.md)
- [modbus_read_registers2](modbus_read_registers2.md)
- [modbus_write_registers](modbus_write_registers.md)

## Copyright

This page is modified by End 2 End Technologies, Inc.

Copyright (c) Stéphane Raimbault <stephane.raimbault@gmail.com> and/or contributors.
Copyright (c) End 2 End Technologies, Inc., 2025.
