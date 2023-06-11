# System Memory Map

| Address Range (Hex) | Size | Name    | Decoding | Note                                                   |
|---------------------|------|---------|----------|--------------------------------------------------------|
| 00000000 - 0000ffff | 64K  | Bootrom | I        |                                                        |
| 00010000 - 0001ffff | 64K  | SRAM    | D        | Actually only 32KiB implemented due to FPGA limitation |
| 00020000 - 00020fff | 4K   | GPIO    | D        |                                                        |
| 00021000 - 00021fff | 4K   | Timer32 | D        |                                                        |
