"use strict";

let str ="эзтыхз фзъзъз";

function cesar(str, shift, action) {
    let strcopy = str.replace(/\s/g, '');
    let res = '';
    let alphabet = 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя';
    let code = -1;
    if (action == 'encode') {
        for (let i = 0; i < strcopy.length; i++) {
            code = (alphabet.indexOf(strcopy[i]) + shift) % 33;
            res += alphabet[code]; 
        }
    }
    else {
        for (let i = 0; i < strcopy.length; i++) {
            if ((alphabet.indexOf(strcopy[i]) - shift) < 0)
                code = 33 - Math.abs((alphabet.indexOf(strcopy[i]) - shift));
        
            else 
                code = (alphabet.indexOf(strcopy[i]) - shift) % 33;
            res += alphabet[code];
        }
    }
    return res;
}

for (let i=0; i < 32; i++) {
    console.log(cesar(str, i, 'decode'));
}