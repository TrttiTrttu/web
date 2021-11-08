"use strict";

function Pluralization(num) {
    if (num%10 == 1 && num%100 != 11) return `${num} запись`;
    if ((num%10 == 2 || num%10 == 3 || num%10 == 4) && 
        num%100 != 12 && num%100 != 13 && num%100 != 14)
        return `${num} записи`;
    else return `${num} записей`;
}