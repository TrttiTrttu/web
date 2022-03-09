"use strict";

function fibb(n) {
    if (n <= 1) {
        return n;
    }
   else {
       return fibb(n - 1) + fibb(n - 2);
   }
}

console.log(fibb(5));