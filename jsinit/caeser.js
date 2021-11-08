function caesar(str, shift, action) {
    let alphabet = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя";
    let res = "";

    for (let char of str) {
        if (char == " "){
            res = res + char;
            continue;
        }
        switch (action) {
            case ("encode"): 
                res = res + alphabet[(alphabet.indexOf(char) + shift) % alphabet.length];
                break;
            case ("decode"):
                if (alphabet.indexOf(char) - shift >= 0) {
                    res = res + alphabet[(alphabet.indexOf(char) - shift) % alphabet.length];
                }
                else {
                    res = res + alphabet[( alphabet.length + alphabet.indexOf(char) - shift) % alphabet.length];
                }
                break;
            default:
                break;
        }
    }
    return res;
}

for (let i = 1; i <= 33; i++) {
    console.log(cesar("эзтыхз фзъзъз", i, "decode"))
}