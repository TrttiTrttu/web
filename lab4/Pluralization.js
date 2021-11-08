"use strict";

function pluralizeRecords(n) {
    
    let ending = "";
    
    if ((n % 10 == 1) && (n % 100 != 11)) {
        ending = "ь";
        return `В результате выполнения запроса была найдена ${n} запис${ending}`;
    }
    if (((n % 10 >= 2) && (n % 10 <= 4)) && ((n % 100 < 12) || (n % 100 > 14))){
        ending = "и";
        return `В результате выполнения запроса были найдены ${n} запис${ending}`;
    }
    if ((n % 10 == 0) || ((n % 10 >= 5) && (n % 10 <= 9)) || ((n % 100 >= 11) && (n % 100 <= 14))){
        ending = "ей"

        return `В результате выполнения запроса было найдено ${n} запис${ending}`;
    }
}


// console.log(pluralizeRecords(22));
