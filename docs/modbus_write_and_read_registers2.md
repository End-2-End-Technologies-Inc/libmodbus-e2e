# modbus_write_and_read_registers2

## Name

modbus_write_and_read_registers2 - write and read many registers in a single transaction

## Synopsis

```c
int modbus_write_and_read_registers2(
    modbus_t *ctx,
    int write_addr, int write_nb, const uint16_t *src,
    int read_addr, int read_nb, const uint16_t *dest,
    bool read_from_start, bool read_swap_bytes
);
```

## Description

The *modbus_write_and_read_registers2()* function shall write the content of the
`write_nb` holding registers from the array 'src' to the address `write_addr` of
the remote device then shall read the content of the `read_nb` holding registers
to the address `read_addr` of the remote device. The result of reading is stored
in `dest` array as word values (16 bits).

`read_from_start` controls whether read output should include additional two leading bytes.

`read_swap_bytes` controls whether bytes should be swapped in the received 16-bit values.

You must take care to allocate enough memory to store the results in `dest`
(at least `nb * sizeof(uint16_t)` if `read_from_start` is `false`,
or `(nb + 1) * sizeof(uint16_t)` otherwise).

The function uses the Modbus function code 0x17 (write/read registers).

## Return value

The function shall return the number of read values if successful. Otherwise
it shall return -1 and set errno.

## Errors

- *EMBMDATA*, too many registers requested, Too many registers to write

## See also

- [modbus_read_registers](modbus_read_registers.md)
- [modbus_read_registers2](modbus_read_registers2.md)
- [modbus_write_and_read_registers](modbus_write_and_read_registers.md)
- [modbus_write_register](modbus_write_register.md)
- [modbus_write_registers](modbus_write_registers.md)

## Copyright

This page is added by End 2 End Technologies, Inc.

Most of text on this page is derived from documentation page for the function `modbus_write_and_read_registers()`.

Copyright (c) Stéphane Raimbault <stephane.raimbault@gmail.com> and/or contributors.
Copyright (c) End 2 End Technologies, Inc., 2025.
