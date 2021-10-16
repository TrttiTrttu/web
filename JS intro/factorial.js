"use strict";

function factorialIter(num) {
    let res = 1;
    for (let i = 1; i <= num; i++) {
        res *= i;
    }
    return res;
}

console.log(factorialIter(5));

function factorialRec (num) {
    if (num == 1 || num == 0) return 1;
    else return factorialRec(num-1)*num;
}

console.log(factorialRec(5));

function xxor (num1, num2) {
    return (num1 + num2)%2
}

console.log(xxor(1, 0))

function isPalindrome(str){
    for (let i = 0; i < str.length/2; i++) {
        if (str[i] != str[str.length - i - 1]) return false;
    }
    return true;
}

console.log(isPalindrome("qwerrewq"));

console.log(isPalindrome("qwerawq"));

function armstrongNum(num){
    let sum = 0, copy = num;
    let digit = String(num).length;
    while (num){
        sum += (num % 10)**digit;
        num = Math.trunc(num/10);
    }
    if (copy == sum) return true
    else return false;
}

console.log(armstrongNum(153))