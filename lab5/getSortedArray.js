"use strict";

let array = [{name: 'Макар', age: 20}, {name: 'Роберт', age: 32}, {name: 'Екатерина', age: 50}, {name: 'Оксана', age: 24}, {name: 'Святослав', age: 43}];

console.log(array);

function getSortedArray(arr, key) {
    for (let j = arr.length - 1; j > 0; j--) {
        for (let i = 0; i < j; i++) {
            if (arr[i][key] > arr[i + 1][key]) {
                let temp = arr[i];
                arr[i] = arr[i + 1];
                arr[i + 1] = temp;
            }
        }
    }
}

getSortedArray(array,'age');

console.log(array);