'use strict';

function createUpvotesElement(num) {
    let upvotesElement = document.createElement('div');
    upvotesElement.classList.add('upvotes');
    upvotesElement.textContent = num;
    return upvotesElement;
}

function createAuthorElement(user) {
    user = user || { name: { fisrt: '', last: '' } };
    let authorElement = document.createElement('div');
    authorElement.classList.add('author-name');
    authorElement.textContent = user.name.first + ' ' + user.name.last;
    return authorElement;
}

function createFooterElement(record) {
    let footerElement = document.createElement('footer');
    footerElement.classList.add('item-footer');
    footerElement.append(createAuthorElement(record.user));
    footerElement.append(createUpvotesElement(record.upvotes));
    return footerElement;
}

function createContentElement(record) {
    let contentElement = document.createElement('div');
    contentElement.classList.add('item-content');
    contentElement.innerHTML = record.text;
    return contentElement;
}

function createListItemElement(record) {
    let itemElement = document.createElement('div');
    itemElement.classList.add('facts-list-item');
    itemElement.append(createContentElement(record));
    itemElement.append(createFooterElement(record));
    return itemElement;
}

function renderRecords(records) {
    let factsList = document.querySelector('.facts-list');
    factsList.innerHTML = '';
    for (let record of records) {
        factsList.append(createListItemElement(record));
    }
}

function setPaginationInfo(info) {
    document.querySelector('.total-count').innerHTML = info.total_count;
    let start = info.total_count > 0 ? (info.current_page -1)*info.per_page + 1 : 0;
    document.querySelector('.current-interval-start').innerHTML = start;
    let end = Math.min(info.total_count, start + info.per_page -1);
    document.querySelector('.current-interval-end').innerHTML = end;
}

function downloadData(page=1) {
    let factsList = document.querySelector('.facts-list');
    let perPage = document.querySelector('.per-page-btn').value;
    let url = new URL(factsList.dataset.url);
    url.searchParams.append('page', page);
    url.searchParams.append('per-page', perPage);
    
    let xhr = new XMLHttpRequest();
    xhr.open('GET', url);
    xhr.responseType = 'json';
    xhr.onload = function () {
        renderRecords(this.response.records);
        setPaginationInfo(this.response['_pagination']);
    }
    xhr.send();
}

function pageBtnHandler(event) {
    if (event.target.dataset.page) {
        downloadData(event.target.dataset.page);
        window.scrollTo(0, 0);
    }
}

function perPageBtnHandler(event) {
    downloadData(1);
}

window.onload = function () {
    downloadData();
    document.querySelector('.pagination').onclick = pageBtnHandler;
    document.querySelector('.per-page-btn').onchange = perPageBtnHandler;
}