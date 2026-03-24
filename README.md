# liberty2tech

`liberty2tech` is a small standalone converter from Liberty `.lib` files to a GENLIB-style technology library.

This project uses:

- a C++ CLI entry point in `src/liberty2tech.cpp`
- qflow's vendored C Liberty parser in `vendor/qflow/readliberty.c`

The front-end stays in C++, while the vendor parser continues to be compiled as C.

## Build

```bash
make
```

The binary is generated at `bin/liberty2tech`.

The default build uses:

- `c++` for `src/liberty2tech.cpp`
- `cc` for `vendor/qflow/readliberty.c`

## Install

```bash
make install
```

This installs the binary into `~/.local/bin/liberty2tech`.

## Usage

```bash
./bin/liberty2tech input.lib -o output.genlib
./bin/liberty2tech input.lib > output.genlib
./bin/liberty2tech input.lib -p '^AND'
```

## Current behavior

- Supports common combinational cells, including repeated `GATE` emission for multi-output cells.
- Skips obvious sequential cells.
- Emits GENLIB-style `GATE` and `PIN` records.
- Preserves the Liberty output pin name in each boolean function, for example `CON = ...` and `SN = ...`.

## Limitations

- Uses an approximate timing/load projection from Liberty tables.
- Some complex Liberty constructs may still need follow-up handling.

## Multi-output convention

`genlib` itself does not natively model true multi-output cells. This tool represents them by emitting one `GATE` record per output pin, reusing the same cell name and input `PIN` data. For example, a half-adder is written as:

```genlib
GATE HA_X1                              1.0000  CON = (!A) + (!B);
    PIN A                UNKNOWN  1.0000   999.0   0.0000   0.0000   0.0000   0.0000
    PIN B                UNKNOWN  1.0000   999.0   0.0000   0.0000   0.0000   0.0000
GATE HA_X1                              1.0000  SN = (A * B) + (!A * !B);
    PIN A                UNKNOWN  1.0000   999.0   0.0000   0.0000   0.0000   0.0000
    PIN B                UNKNOWN  1.0000   999.0   0.0000   0.0000   0.0000   0.0000
```

This repository has been validated against [`SO3_L3_tt_0.7_25_nldm.lib`](/data2/bingjin/PROJECT/liberty2tech/SO3_L3_tt_0.7_25_nldm.lib), where `FA_X1_DH` and `HA_X1` are the combinational dual-output reference cells.
