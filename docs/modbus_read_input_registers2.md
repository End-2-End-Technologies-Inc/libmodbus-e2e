# modbus_read_input_registers2

## Name

modbus_read_input_registers2 - read many input registers

## Synopsis

```c
int modbus_read_input_registers2(modbus_t *ctx, int addr, int nb, uint16_t *dest
                                 bool from_start, bool swap_bytes);
```

## Description

The *modbus_read_input_registers2()* function shall read the content of the `nb`
input registers to address `addr` of the remote device. The result of the
reading is stored in `dest` array as word values (16 bits).

`from_start` controls whether read output should include additional two leading bytes.

`swap_bytes` controls whether bytes should be swapped in the received 16-bit values.

You must take care to allocate enough memory to store the results in `dest` (at
least `nb * sizeof(uint16_t)` if `from_start` is `false`,
or `(nb + 1) * sizeof(uint16_t)` otherwise).

The function uses the Modbus function code 0x04 (read input registers). The
holding registers and input registers have different historical meaning, but
nowadays it's more common to use holding registers only.

## Return value

The function shall return the number of read values if
successful. Otherwise it shall return -1 and set errno.

## Errors

- *EMBMDATA*, too many bits requested.

## See also

- [modbus_read_input_bits](modbus_read_input_bits.md)
- [modbus_read_input_registers](modbus_read_input_registers.md)
- [modbus_write_register](modbus_write_register.md)
- [modbus_write_registers](modbus_write_registers.md)

## Copyright

This page is added by End 2 End Technologies, Inc.

Most of text on this page is derived from documentation page for the function `modbus_read_input_registers()`.

Copyright (c) Stéphane Raimbault <stephane.raimbault@gmail.com> and/or contributors.
Copyright (c) End 2 End Technologies, Inc., 2025.
