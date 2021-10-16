"use strict";

function fibb(n){
    let res, prev;
    res = 1;
    prev = 0;
    for (let i = 0; i < n-1; i++){
        res += prev;
        prev = res-prev;
    }
    return res;
}
