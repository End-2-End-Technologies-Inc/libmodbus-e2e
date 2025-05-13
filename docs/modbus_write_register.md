# modbus_write_register

## Name

modbus_write_register - write a single register

## Synopsis

```c
int modbus_write_register(modbus_t *ctx, int addr, const uint16_t value);
```

## Description

The *modbus_write_register()* function shall write the value of `value`
holding registers at the address `addr` of the remote device.

The function uses the Modbus function code 0x06 (preset single register).

## Return value

The function shall return 1 if successful. Otherwise it shall return -1 and set
errno.

## See also

- [modbus_read_registers](modbus_read_registers.md)
- [modbus_read_registers2](modbus_read_registers2.md)
- [modbus_write_registers](modbus_write_registers.md)

## Copyright

This page is modified by End 2 End Technologies, LLC.

Copyright (c) Stéphane Raimbault <stephane.raimbault@gmail.com> and/or contributors.
Copyright (c) End 2 End Technologies, LLC., 2025.
