"use strict";

function pow (num, n) {
    let res = 1;
    for (let i = 0; i < n; i++) {
        res *= num;
    }
    return res;
}