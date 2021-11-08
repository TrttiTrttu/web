"use strict";

function minDigit(x) {
    let res = 10;
    if (x == 0) {
        return 0;
    }
    while (x) {
        if (x % 10 < res){
            res = x % 10
        }
        x = Math.trunc(x / 10)
    }
    return res;
}

console.log(minDigit(12837172831));