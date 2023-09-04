# System Memory Map

| Address Range (Hex) | Size | Name     | Decoding | Note                                                   |
|---------------------|------|----------|----------|--------------------------------------------------------|
| 00000000 - 0000ffff | 64K  | BootROM  | I        |                                                        |
| 00010000 - 0001ffff | 64K  | SRAM     | D        | Actually only 32KiB implemented due to FPGA limitation |
| 00020000 - 00020fff | 4K   | GPIO     | D        |                                                        |
| 00021000 - 00021fff | 4K   | Timer32  | D        |                                                        |
| 00022000 - 00022fff | 4K   | IntrCtrl | D        |                                                        |
| 00023000 - 00023fff | 4K   | UART     | D        |                                                        |

# GPIO controller register map
| Offset | Name                 | Bit Field | R/W | Description                                  | Internal |
|--------|----------------------|-----------|-----|----------------------------------------------|----------|
| 0x0    | GPIO\_IN0            | [31:0]    | R   | GPIO Pin 0-31 Input                          | 0        |
| 0x4    | GPIO\_IN1            | [31:0]    | R   | GPIO Pin 32-63 Input                         | 1        |
| 0x8    | GPIO\_OUT\_EN0       | [31:0]    | RW  | GPIO Pin 0-31 Output Enable                  | 2        |
| 0xC    | GPIO\_OUT\_EN1       | [31:0]    | RW  | GPIO Pin 32-63 Output Enable                 | 3        |
| 0x10   | GPIO\_OUT0           | [31:0]    | RW  | GPIO Pin 0-31 Output Value                   | 4        |
| 0x14   | GPIO\_OUT1           | [31:0]    | RW  | GPIO Pin 32-63 Output Value                  | 5        |
| 0x18   | GPIO\_POSEDGE\_EN0   | [31:0]    | RW  | GPIO Pin 0-31 Rising Edge detection enable   | 6        |
| 0x1C   | GPIO\_POSEDGE\_EN1   | [31:0]    | RW  | GPIO Pin 32-63 Rising Edge detection enable  | 7        |
| 0x20   | GPIO\_NEGEDGE\_EN0   | [31:0]    | RW  | GPIO Pin 0-31 Falling Edge detection enable  | 8        |
| 0x24   | GPIO\_NEDEDGE\_EN1   | [31:0]    | RW  | GPIO Pin 32-63 Falling Edge detection enable | 9        |
| 0x28   | GPIO\_POSEDGE\_STAT0 | [31:0]    | RC  | GPIO Pin 0-31 Rising Edge detected           | 10       |
| 0x2C   | GPIO\_POSEDGE\_STAT1 | [31:0]    | RC  | GPIO Pin 32-63 Rising Edge detected          | 11       |
| 0x30   | GPIO\_NEGEDGE\_STAT0 | [31:0]    | RC  | GPIO Pin 0-31 Falling Edge detected          | 12       |
| 0x34   | GPIO\_NEDEDGE\_STAT1 | [31:0]    | RC  | GPIO Pin 32-63 Falling Edge detected         | 13       |

# Timer register map
| Offset | Name               | Bit Field | R/W | Description                              | Internal |
|--------|--------------------|-----------|-----|------------------------------------------|----------|
| 0x0    | COUNTER            | [31:0]    | R   | Counter                                  | 0        |
| 0x4    | RESET              | [0]       | W   | Write to reset counter to 0              | 1        |
| 0x8    | TIMEOUT\_THRESHOLD | [31:0]    | RW  | Minimum counter value to issue interrupt | 2        |
| 0xC    | TIMEOUT\_CSR       | [1:0]     | RW  | Timeout control and status               | 3        |
|        | TIMEOUT\_ENABLE    | [0]       | RW  | Enable timeout                           |          |
|        | TIMEOUT\_OCCURED   | [1]       | RC  | Timeout occured                          |          |

# Interrupt controller register map

| Offset | Name        | Bit Field | R/W | Description                      | Internal |
|--------|-------------|-----------|-----|----------------------------------|----------|
| 0x0    | INTR\_EN0   | [31:0]    |     | Interrupt enable bits 0-31       | 0        |
| 0x4    | INTR\_EN1   | [31:0]    |     | Interrupt enable bits 32-63      | 1        |
| 0x8    | INTR\_EN2   | [31:0]    |     | Interrupt enable bits 64-95      | 2        |
| 0xC    | INTR\_EN3   | [31:0]    |     | Interrupt enable bits 96-127     | 3        |
| 0x10   | INTR\_EN4   | [31:0]    |     |                                  | 4        |
| 0x14   | INTR\_EN5   | [31:0]    |     |                                  | 5        |
| 0x18   | INTR\_EN6   | [31:0]    |     |                                  | 6        |
| 0x1C   | INTR\_EN7   | [31:0]    |     |                                  | 7        |
| 0x20   | INTR\_PEND0 | [31:0]    |     | Interrupt pending bits 0-31      | 8        |
| 0x24   | INTR\_PEND1 | [31:0]    |     | Interrupt pending bits 32-63     | 9        |
| 0x28   | INTR\_PEND2 | [31:0]    |     | Interrupt pending bits 64-95     | 10       |
| 0x2C   | INTR\_PEND3 | [31:0]    |     | Interrupt pending bits 96-127    | 11       |
| 0x30   | INTR\_PEND4 | [31:0]    |     |                                  | 12       |
| 0x34   | INTR\_PEND5 | [31:0]    |     |                                  | 13       |
| 0x38   | INTR\_PEND6 | [31:0]    |     |                                  | 14       |
| 0x3C   | INTR\_PEND7 | [31:0]    |     |                                  | 15       |
| 0x40   | INTR\_ID0   | [15:0]    |     | Processor Interrupt ID for IRQ 0 |          |
|        |             | [31:16]   |     | Processor Interrupt ID for IRQ 1 |          |

# UART controller register map
| Offset | Name     | Bit Field | R/W | Description                   | Internal |
|--------|----------|-----------|-----|-------------------------------|----------|
| 0x0    | TX\_BUF  | [7:0]     | RW  | Transmit buffer               | 0        |
| 0x4    | TX\_CTRL | [1:0]     | RW  | Transmit Control              | 1        |
|        |          | [1]       | RW  | Transmit Parity enable        |          |
|        |          | [0]       | W   | Start transmit                |          |
| 0x8    | TX\_BAUD | TBD       | RW  | Transmit baud rate            | 2        |
| 0xC    | TX\_STAT | [0]       | R   | Transmit status(busy)         | 3        |
| 0x10   | RX\_STAT | [3:0]     | RW  | Receive control & status      | 4        |
|        |          | [3]       | RC  | Received invalid parity       |          |
|        |          | [2]       | RW  | Receive parity enable         |          |
|        |          | [1]       | RW  | Receive discard policy        |          |
|        |          | [0]       | RC  | RX_BUF contains received data |          |
| 0x14   | RX\_BUF  | [7:0]     | R   | Received Buffer               | 5        |
| 0x18   | RX\_BAUD | TBD       | RW  | Receive baud rate             | 6        |

