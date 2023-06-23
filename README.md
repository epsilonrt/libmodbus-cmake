# A groovy modbus library

## Overview

libmodbus is a free software library to send/receive data with a device which
respects the Modbus protocol. This library can use a serial port or an Ethernet
connection.

The functions included in the library have been derived from the Modicon Modbus
Protocol Reference Guide which can be obtained from [www.modbus.org](http://www.modbus.org).

The license of libmodbus is *LGPL v2.1 or later*.

The official website is [www.libmodbus.org](http://www.libmodbus.org). The
website contains the latest version of the documentation.

The library is written in C and designed to run on Linux, Mac OS X, FreeBSD, Embox,
QNX and Windows.

You can use the library on MCUs with Embox RTOS.

## Installation



## Testing

Some tests are provided in *tests* directory, you can freely edit the source
code to fit your needs (it's Free Software :).

See *tests/README* for a description of each program.

For a quick test of libmodbus, you can run the following programs in two shells:

1. ./unit-test-server
2. ./unit-test-client

By default, all TCP unit tests will be executed (see --help for options).

It's also possible to run the unit tests with `make check`.


## Documentation

You can serve the local documentation with:

```shell
pip install mkdocs-material
mkdocs serve
```
