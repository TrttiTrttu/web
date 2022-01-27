'use strict';

let api_key = '9d2427f4-8d5f-47be-888b-0159c5a73edb'
let url = new URL('http://exam-2022-1-api.std-900.ist.mospolytech.ru/api/restaurants')
let json_copy


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

    if (action_btn == '›' || action_btn == '»' || action_btn == '‹' || action_btn == '«') {
        if (action_btn == '‹') flag = -1;
        else if (action_btn == '»') flag = 10;
        else if (action_btn == '›') flag = 1;
        else flag = -10;
    }
    else { flag = Number(action_btn) - current_page}

    if ((Number(current_page) + flag) >= 50) {
        new_page = 50;

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
    else {
        new_page = (Number(current_page) + flag);
        if (new_page >= 40) { event.target.closest('.pagination').querySelector('.next_ten').classList.add('disabled'); }
        else { event.target.closest('.pagination').querySelector('.next_ten').classList.remove('disabled'); }
        if (new_page <= 10) { event.target.closest('.pagination').querySelector('.back_ten').classList.add('disabled'); }
        else { event.target.closest('.pagination').querySelector('.back_ten').classList.remove('disabled'); }
        event.target.closest('.pagination').querySelector('.next').classList.remove('disabled');
        event.target.closest('.pagination').querySelector('.back').classList.remove('disabled');
        if (new_page > 2 && new_page < 49) {
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
    if (current_page < 48)
        event.target.closest('.pagination').querySelector('.empty_end').classList.remove('d-none');
    else
        event.target.closest('.pagination').querySelector('.empty_end').classList.add('d-none');

    renderRestaurants(json_copy, current_page - 1)
}

async function renderRestaurants(json, page_num = 0) {
    document.getElementById('rest-list').innerHTML = '';
    for (let i = page_num * 10; i < (page_num * 10 + 10); i++) {
        let newTaskElement = document.getElementById('restaurant-template').cloneNode(true);
        newTaskElement.querySelector('.rest-name').innerHTML = json[i].name;
        newTaskElement.querySelector('.rest-type').innerHTML = json[i].typeObject;
        newTaskElement.querySelector('.rest-address').innerHTML = json[i].address;
        newTaskElement.classList.remove('d-none');

        let listElement = document.getElementById(`rest-list`);
        listElement.append(newTaskElement);
    }
}

async function tasksJsonPreload() {
    return fetch(url + '?api_key=' + api_key)
        .then(res => res.json())
        .catch(err => showAlert(err, 'danger'));
}

window.onload = function () {
    tasksJsonPreload()
        .then(json => json_copy = json)
        .then(json_copy => renderRestaurants(json_copy));

    for (let btn of document.querySelectorAll('.pagination-btn')) {
        btn.onclick = paginationBtnHandler;
    }
}