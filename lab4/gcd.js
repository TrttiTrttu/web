"use strict";

function gcd (x, y) {
    if (x % y == 0) return y;
    if (y % x == 0) return x;
    if (x > y)
        return gcd(x%y, y);
    return gcd(x, y%x);
}