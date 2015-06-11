# HEX to IEEE-754 Converter

This is a (very) small Delphi application I wrote for a friend to demonstrate hexadecimal to [IEEE-754 floating point](http://en.wikipedia.org/wiki/IEEE_floating_point) number conversion.  

![screenshot](https://raw.githubusercontent.com/Tominator2/HEXtoIEEE-754/master/screenshot.png)

His work had a [Richtmass RP-3440 power meter](http://www.siamenergysaving.com/product/7451/%E0%B9%80%E0%B8%9E%E0%B8%B2%E0%B9%80%E0%B8%A7%E0%B8%AD%E0%B8%A3%E0%B9%8C%E0%B8%A1%E0%B8%B4%E0%B9%80%E0%B8%95%E0%B8%AD%E0%B8%A3%E0%B9%8C__%E0%B8%A3%E0%B8%B8%E0%B9%88%E0%B8%99_RP-3440/?lang=EN) wtih a Modbus serial port on the back.  They were able to extract data from the meter which they were putting into CSV format like this (note that the date is in Buddhsit Era (BE) format):

```
22/4/2554 23:48:01,4367F3DD,436816D3,4367F5AA,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000
```
However, they needed some help converting the 32 bit hexadecimal values.

## Conversion

Let's find the decimal value of the first hexadecimal number from the data above: `4367F3DD`.  We'll start by converting it into binary and looking at what each of the bits represents in the IEEE-754 standard: 
```
    Data Hi Word | Data Hi Word | Data Lo Word | Data Lo Word
      Hi Byte    |   Lo Byte    |   Hi Byte    |   Lo Byte
    ---------------------------------------------------------
HEX      43      |      67      |      F3      |      DD 
BIN   0100 0011  |  0110 0111   |  1111 0011   |  1101 1101
MAP   SEEE EEEE  |  EMMM MMMM   |  MMMM MMMM   |  MMMM MMMM

BIN   0 10000110 11001111111001111011101
MAP   S EEEEEEEE MMMMMMMMMMMMMMMMMMMMMMM
BITS  1    8               23
```
Where:
``` 
S = SIGN      0
E = EXPONENT  10000110 
M = MANTISSA  11001111111001111011101
```

The first sign bit is 0 for a positive number and 1 for a negative number so this is a positive number.

The next 8 bits are the exponent which is stored in 2's complement format.  To get the value subtract 127:
```
  HEX 10000110 (DEC 134)
- HEX 10000000 (DEC 127)
--------------
  HEX      110 (DEC   7)
```

The remaining 23 bits are the mantissa which always has a leading 1 before the decimal point that is not stored:
```
  BIN 1.11001111111001111011101
        |------ 23 bits ------|
```
The decimal place then gets shifted to the right by the exponent (here 7 places):
```
 BIN 11100111.1111001111011101 = DEC 231.952590942383 Volts
```

The Delphi code to accomplish this is in the file [IEEE754.pas](https://github.com/Tominator2/HEXtoIEEE-754/blob/master/IEEE754.pas).

Download the executable for Windows: [IEEE754_Converter.exe](https://github.com/Tominator2/HEXtoIEEE-754/releases/download/v1.0/IEEE754_Converter.exe) (416 KB)
