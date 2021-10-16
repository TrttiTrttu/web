"use strict";

function minDigit(x) {
    let minTemp = 9;
    while (x) {
        if (x%10 < minTemp) minTemp = x%10;
        x = Math.trunc(x/10);
    }
    return minTemp;
}