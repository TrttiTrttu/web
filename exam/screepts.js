'use strict';

let api_key = '9d2427f4-8d5f-47be-888b-0159c5a73edb'
let url = new URL('http://exam-2022-1-api.std-900.ist.mospolytech.ru/api/restaurants')
let json_copy, json_filtred


function showAlert(msg, category = 'success') {
    let alertsContainer = document.querySelector('.alerts');
    let newAlertElement = document.getElementById('alerts-template').cloneNode(true);
    newAlertElement.classList.add('alert-' + category);
    newAlertElement.querySelector('.msg').innerHTML = msg;
    newAlertElement.classList.remove('d-none');
    alertsContainer.append(newAlertElement);
}

function paginationBtnHandler(event) {
    let action_btn = event.target.innerHTML;
    let current_page = event.target.closest('.pagination').querySelector('.active').querySelector('.pagination-btn').innerHTML;
    let second_btn = event.target.closest('.pagination').querySelector('.second')
    let third_btn = event.target.closest('.pagination').querySelector('.third')
    let fourth_btn = event.target.closest('.pagination').querySelector('.fourth')
    let flag = 1;
    let new_page = 0;

    let pages = Math.floor(json_filtred.length / 20);
    if (json_filtred.length % 20 != 0)
        pages++;

    if (action_btn == '›' || action_btn == '»' || action_btn == '‹' || action_btn == '«') {
        if (action_btn == '‹') flag = -1;
        else if (action_btn == '»') flag = 10;
        else if (action_btn == '›') flag = 1;
        else flag = -10;
    }
    else { flag = Number(action_btn) - current_page }

    if ((Number(current_page) + flag) >= pages && (Number(current_page) + flag) != 2) {
        new_page = pages;

        event.target.closest('.pagination').querySelector('.next').classList.add('disabled');
        event.target.closest('.pagination').querySelector('.next_ten').classList.add('disabled');
        event.target.closest('.pagination').querySelector('.back').classList.remove('disabled');
        event.target.closest('.pagination').querySelector('.back_ten').classList.remove('disabled');

        second_btn.querySelector('.pagination-btn').innerHTML = new_page - 3;
        third_btn.querySelector('.pagination-btn').innerHTML = new_page - 2;
        fourth_btn.querySelector('.pagination-btn').innerHTML = new_page - 1;
    }
    else if ((Number(current_page) + flag) <= 1) {
        new_page = 1;

        event.target.closest('.pagination').querySelector('.next').classList.remove('disabled');
        event.target.closest('.pagination').querySelector('.next_ten').classList.remove('disabled');
        event.target.closest('.pagination').querySelector('.back').classList.add('disabled');
        event.target.closest('.pagination').querySelector('.back_ten').classList.add('disabled');

        second_btn.querySelector('.pagination-btn').innerHTML = new_page + 1;
        third_btn.querySelector('.pagination-btn').innerHTML = new_page + 2;
        fourth_btn.querySelector('.pagination-btn').innerHTML = new_page + 3;
    }
    else if ((Number(current_page) + flag) == 2) {
        new_page = 2;

        event.target.closest('.pagination').querySelector('.next').classList.remove('disabled');
        event.target.closest('.pagination').querySelector('.next_ten').classList.remove('disabled');
        event.target.closest('.pagination').querySelector('.back_ten').classList.add('disabled');
        event.target.closest('.pagination').querySelector('.back').classList.remove('disabled');

        second_btn.querySelector('.pagination-btn').innerHTML = new_page;
        third_btn.querySelector('.pagination-btn').innerHTML = new_page + 1;
        fourth_btn.querySelector('.pagination-btn').innerHTML = new_page + 2;
    }
    else if ((Number(current_page) + flag) == 49) {
        new_page = 49;

        event.target.closest('.pagination').querySelector('.next').classList.remove('disabled');
        event.target.closest('.pagination').querySelector('.next_ten').classList.remove('disabled');
        event.target.closest('.pagination').querySelector('.back').classList.add('disabled');
        event.target.closest('.pagination').querySelector('.back_ten').classList.add('disabled');

        second_btn.querySelector('.pagination-btn').innerHTML = new_page;
        third_btn.querySelector('.pagination-btn').innerHTML = new_page + 1;
        fourth_btn.querySelector('.pagination-btn').innerHTML = new_page + 2;
    }
    else {
        new_page = (Number(current_page) + flag);
        if (new_page >= (pages - 10)) {
            event.target.closest('.pagination').querySelector('.next_ten').classList.add('disabled');
        }
        else {
            event.target.closest('.pagination').querySelector('.next_ten').classList.remove('disabled');
        }
        if (new_page <= 10) {
            event.target.closest('.pagination').querySelector('.back_ten').classList.add('disabled');
        }
        else {
            event.target.closest('.pagination').querySelector('.back_ten').classList.remove('disabled');
        }
        event.target.closest('.pagination').querySelector('.next').classList.remove('disabled');
        event.target.closest('.pagination').querySelector('.back').classList.remove('disabled');
        if (new_page > 2 && new_page < (pages - 1)) {
            second_btn.querySelector('.pagination-btn').innerHTML = new_page - 1;
            third_btn.querySelector('.pagination-btn').innerHTML = new_page;
            fourth_btn.querySelector('.pagination-btn').innerHTML = new_page + 1;
        }
    }

    event.target.closest('.pagination').querySelector('.active').classList.remove('active');

    for (let page of event.target.closest('.pagination').querySelectorAll('.pagination-btn')) {
        if (page.innerHTML == new_page) page.closest('.page-item').classList.add('active');
    }

    current_page = new_page;

    if (current_page > 3)
        event.target.closest('.pagination').querySelector('.empty_start').classList.remove('d-none');
    else
        event.target.closest('.pagination').querySelector('.empty_start').classList.add('d-none');
    if (current_page < (pages - 2))
        event.target.closest('.pagination').querySelector('.empty_end').classList.remove('d-none');
    else
        event.target.closest('.pagination').querySelector('.empty_end').classList.add('d-none');

    renderRestaurants(json_filtred, current_page - 1)
}

function renderFiltres(options, name) {
    let select = document.querySelector(name);
    for (let i = 0; i < options.length; i++) {
        let optionElement = document.createElement('option');
        optionElement.innerHTML = options[i];
        select.append(optionElement);
    }
}

function alphSort(x, y) {
    return x.localeCompare(y);
}

function searchFiltres(json) {
    let Adm = [];
    let Dist = [];
    let Type = [];

    for (let i = 0; i < json.length; i++) {
        if (Adm.indexOf(json[i].admArea) == -1) Adm.push(json[i].admArea);
        if (Dist.indexOf(json[i].district) == -1) Dist.push(json[i].district);
        if (Type.indexOf(json[i].typeObject) == -1) Type.push(json[i].typeObject);
    }
    renderFiltres(Adm.sort(alphSort), '#admArea');
    renderFiltres(Dist.sort(alphSort), '#district');
    renderFiltres(Type.sort(alphSort), '#type');
}

function renderPaginationBtn(json) {
    document.querySelector('.pagination').querySelector('.active').classList.remove('active');
    document.querySelector('.first').classList.add('active');

    document.querySelector('.pagination').querySelector('.next').classList.remove('disabled');
    document.querySelector('.pagination').querySelector('.next_ten').classList.remove('disabled');
    document.querySelector('.pagination').querySelector('.back').classList.add('disabled');
    document.querySelector('.pagination').querySelector('.back_ten').classList.add('disabled');

    document.querySelector('.second').querySelector('.pagination-btn').innerHTML = 2;
    document.querySelector('.third').querySelector('.pagination-btn').innerHTML = 3;
    document.querySelector('.fourth').querySelector('.pagination-btn').innerHTML = 4;

    let pages = Math.floor(json.length / 20);
    if (json.length % 20 != 0)
        pages++;
    if (pages == 1 || pages == 0) {
        for (let btn of document.querySelectorAll('.page-item'))
            btn.classList.add('d-none');
    }
    else if (pages == 2) {
        for (let btn of document.querySelectorAll('.page-item'))
            btn.classList.remove('d-none');
        for (let btn of document.querySelectorAll('.page-item'))
            btn.classList.add('d-none');
        document.querySelector('.back').classList.remove('d-none');
        document.querySelector('.first').classList.remove('d-none');
        document.querySelector('.second').classList.remove('d-none');
        document.querySelector('.next').classList.remove('d-none');
    }
    else if (pages == 3) {
        for (let btn of document.querySelectorAll('.page-item'))
            btn.classList.remove('d-none');
        for (let btn of document.querySelectorAll('.page-item'))
            btn.classList.add('d-none');
        document.querySelector('.back').classList.remove('d-none');
        document.querySelector('.first').classList.remove('d-none');
        document.querySelector('.second').classList.remove('d-none');
        document.querySelector('.third').classList.remove('d-none');
        document.querySelector('.next').classList.remove('d-none');
    }
    else if (pages == 4) {
        for (let btn of document.querySelectorAll('.page-item'))
            btn.classList.remove('d-none');
        for (let btn of document.querySelectorAll('.page-item'))
            btn.classList.add('d-none');
        document.querySelector('.back').classList.remove('d-none');
        document.querySelector('.first').classList.remove('d-none');
        document.querySelector('.second').classList.remove('d-none');
        document.querySelector('.third').classList.remove('d-none');
        document.querySelector('.fourth').classList.remove('d-none');
        document.querySelector('.next').classList.remove('d-none');
    }
    else if (pages == 5) {
        for (let btn of document.querySelectorAll('.page-item'))
            btn.classList.remove('d-none');
        for (let btn of document.querySelectorAll('.page-item'))
            btn.classList.add('d-none');
        document.querySelector('.back').classList.remove('d-none');
        document.querySelector('.first').classList.remove('d-none');
        document.querySelector('.second').classList.remove('d-none');
        document.querySelector('.third').classList.remove('d-none');
        document.querySelector('.fourth').classList.remove('d-none');
        document.querySelector('.last').classList.remove('d-none');
        document.querySelector('.next').classList.remove('d-none');
    }
    else if (pages == 6) {
        for (let btn of document.querySelectorAll('.page-item'))
            btn.classList.remove('d-none');
        for (let btn of document.querySelectorAll('.page-item'))
            btn.classList.add('d-none');
        document.querySelector('.last').querySelector('a').innerHTML = pages;
        document.querySelector('.back').classList.remove('d-none');
        document.querySelector('.first').classList.remove('d-none');
        document.querySelector('.second').classList.remove('d-none');
        document.querySelector('.third').classList.remove('d-none');
        document.querySelector('.fourth').classList.remove('d-none');
        document.querySelector('.last').classList.remove('d-none');
        document.querySelector('.next').classList.remove('d-none');
        document.querySelector('.empty_end').classList.remove('d-none');
    }
    else if (pages > 6 && pages < 11) {
        for (let btn of document.querySelectorAll('.page-item'))
            btn.classList.remove('d-none');
        for (let btn of document.querySelectorAll('.page-item'))
            btn.classList.add('d-none');
        document.querySelector('.last').querySelector('a').innerHTML = pages;
        document.querySelector('.back').classList.remove('d-none');
        document.querySelector('.first').classList.remove('d-none');
        document.querySelector('.second').classList.remove('d-none');
        document.querySelector('.third').classList.remove('d-none');
        document.querySelector('.fourth').classList.remove('d-none');
        document.querySelector('.last').classList.remove('d-none');
        document.querySelector('.next').classList.remove('d-none');

    }
    else {
        console.log('QWEQWEQWEQEQWEQWEQEQWEQEQEQEQWEWE');
        document.querySelector('.last').querySelector('a').innerHTML = pages;
        for (let btn of document.querySelectorAll('.page-item')) {
            btn.classList.remove('d-none');
        }
        document.querySelector('.empty_start').classList.add('d-none');
    }

}

function findBtnHahdler(event) {
    let admArea = event.target.closest('form').elements['admArea'].value;
    let district = event.target.closest('form').elements['district'].value;
    let type = event.target.closest('form').elements['type'].value;
    let discont = event.target.closest('form').elements['discont'].value;
    let rtn = [];



    for (let i = 0; i < json_copy.length; i++) {
        let flag = true;

        if (json_copy[i].admArea != admArea && admArea != 1) flag = false;
        else if (json_copy[i].district != district && district != 1) flag = false;
        else if (json_copy[i].typeObject != type && type != 1) flag = false;
        else if (json_copy[i].socialPrivileges != true && discont != 1) flag = false;

        if (flag) rtn.push(json_copy[i]);
    }
    json_filtred = rtn;
    console.log(json_copy, 'FILTR');
    renderPaginationBtn(rtn);
    renderRestaurants(rtn);

}

function rateSort(json) {
    json_copy = json_filtred;
    searchFiltres(json);
    return json.sort(function (obj1, obj2) {
        return obj2.rate - obj1.rate;
    });
}

async function renderRestaurants(json, page_num = 0) {
    document.getElementById('rest-list').innerHTML = '';
    if (page_num < Math.floor(json.length / 20))
        for (let i = page_num * 20; i < (page_num * 20 + 20); i++) {
            let newRestaurantElement = document.getElementById('restaurant-template').cloneNode(true);
            newRestaurantElement.querySelector('.rest-name').innerHTML = json[i].name;
            newRestaurantElement.querySelector('.rest-type').innerHTML = json[i].typeObject;
            newRestaurantElement.querySelector('.rest-address').innerHTML = json[i].address;
            newRestaurantElement.classList.remove('d-none');

            let listElement = document.getElementById(`rest-list`);
            listElement.append(newRestaurantElement);

            let btn = newRestaurantElement.querySelector('.text-end');
            btn.onclick = choiceBtnHandler;


        }
    else
        for (let i = page_num * 20; i < json.length; i++) {
            let newRestaurantElement = document.getElementById('restaurant-template').cloneNode(true);
            newRestaurantElement.querySelector('.rest-name').innerHTML = json[i].name;
            newRestaurantElement.querySelector('.rest-type').innerHTML = json[i].typeObject;
            newRestaurantElement.querySelector('.rest-address').innerHTML = json[i].address;
            newRestaurantElement.classList.remove('d-none');

            let listElement = document.getElementById(`rest-list`);
            listElement.append(newRestaurantElement);

            let btn = newRestaurantElement.querySelector('.text-end');
            btn.onclick = choiceBtnHandler;
        }
}

function calcBtnHandler(event) {
    let sign = event.target.innerHTML;
    let field = event.target.closest('.row').querySelector('.rounded').value;
    if (sign == '+')
        event.target.closest('.row').querySelector('.rounded').value = Number(event.target.closest('.row').querySelector('.rounded').value) + 1;
    else if (field != 0)
        event.target.closest('.row').querySelector('.rounded').value = Number(event.target.closest('.row').querySelector('.rounded').value) - 1;
}
async function tasksJsonPreload() {
    json_copy = fetch(url + '?api_key=' + api_key)
        .then(res => res.json())
        .catch(err => showAlert(err, 'danger'));
    return json_copy
}

function renderPrice(name, address) {
    for (let el of document.querySelectorAll('#restaurant-template'))
        if (el.classList.contains('table-active') && el.querySelector('.rest-address').innerHTML != address)
            el.classList.remove('table-active')

    let prices = [];
    for (let el of json_filtred) {
        // console.log(name, 'rest-name');
        if (el.name == name && el.address == address) {
            for (let i = 1; i <= 10; i++) {
                let set = 'prices.push(el.set_' + i + ');';
                eval(set);
            }
        }
    }

    for (let i = 1; i < 11; i++) {
        let ids = 'document.getElementById(\'' + i + '\').querySelector(\'.card-price\').innerHTML = (prices[i-1] + \' ₽\')';
        eval(ids);
    }
}

function choiceBtnHandler(event) {
    let str = event.target.closest('#restaurant-template').querySelector('.rest-name').innerHTML;
    if (str.indexOf('&') != -1) {
        str = str.slice(0, str.indexOf('&') + 1) + str.slice(str.indexOf('&') + 5, str.length);
    }

    console.log(str);

    let name = str;
    let address = event.target.closest('#restaurant-template').querySelector('.rest-address').innerHTML;
    event.target.closest('#restaurant-template').classList.add('table-active');
    renderPrice(name, address);
    console.log(name, address);
}

window.onload = function () {
    tasksJsonPreload()
        .then(json => json_filtred = json)
        .then(json_copy => rateSort(json_copy))
        .then(json_copy => renderRestaurants(json_copy));

    document.getElementById('find_btn').onclick = findBtnHahdler;

    for (let btn of document.querySelectorAll('#choice-btn')) {
        btn.onclick = choiceBtnHandler;
    }

    for (let btn of document.querySelectorAll('.calc-btn')) {
        btn.onclick = calcBtnHandler;
    }

    for (let btn of document.querySelectorAll('.pagination-btn')) {
        btn.onclick = paginationBtnHandler;
    }
}