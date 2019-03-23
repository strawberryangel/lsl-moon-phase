# Moon Phase Calculator for LSL

This code is adapted from 
https://github.com/TorLab/MoonPhaseCalculation
for LSL. 

## Important Note

LSL's float is low precision and the phase number may be off by a day
due to rounding errors.
The values that I tested were good for new moon and full moon, 
but one half moon calculation was off by a half day.

## Use

The function `moon_phase` takes 
the calendar year, month and day
and returns an integer in the range [0..27].

* 0 = new moon
* 7 = first quarter
* 14 = full moon
* 21 = last quarter


## Example

```lsl
#include "moon-phase.lsl" 


test()
{
    integer phase = moon_phase(2020, 3, 9);
    llOwnerSay("phase " + string(phase));
}

default {
    touch_end(integer index)
    {
        test();
    }
}
```
