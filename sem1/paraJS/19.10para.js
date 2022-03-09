"use strict";

let arr = [1,2,53,2,6,4,2,5,7];

function bubbleSort(arr) {
    for (let j = arr.length - 1; j > 0; j--) {
      for (let i = 0; i < j; i++) {
        if (arr[i] > arr[i + 1]) {
          let temp = arr[i];
          arr[i] = arr[i + 1];
          arr[i + 1] = temp;
        }
      }
    }
  }

function counting(arr) {
    let res = {};
    let count = 1;

    arr.sort(function(a, b) {
        return a - b;
    });

    for (let i = 0; i < arr.length - 1; i++) {
        if (arr[i] == arr[i+1])
            count++;
        else {
            if (count > 1) {
                res[arr[i]] = count;
            }

            count = 1;
        }
    }
    return res;
}

function matr(matr) {
    let resArr = [];
    for (const i of matr) {
        let min = i[0];
        for (const j of i) {
            if (j < min) min = j;
        }
        resArr.push(min);
    }
    let res = resArr[0];
    for (const i of resArr) {
        if (res < i) res = i;
    }

    return res;
}

// let mat = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [9, 10, 11]];

let vector = {
    x = 0,
    y = 0,
    z = 0,

    sum(vect) {
        return new vector(this.x + vect.x, this.y + vect.y, this.z + vect.z);
    },

    mult(vect) {
        return new vector(this.x * vect.x, this.y * vect.y, this.z * vect.z);
    },

    subtr(vect) {
        return new vector(this.x - vect.x, this.y - vect.y, this.z - vect.z);
    },

    multNum(num) {
        return new vector(this.x * num, this.y * num, this.z * num);
    },

    length() {
        return Math.sqrt(this.x ^ 2 + this.y ^ 2 + this.y ^ 2);
    },

    scalar(vect){
        return this.x * vect.x + this.y * vect.y + this.z * vect.z;
    }
};