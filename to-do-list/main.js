'use strict';

let api_key = '50d2199a-42dc-447d-81ed-d68a443b697e'
let url = new URL('http://tasks-api.std-900.ist.mospolytech.ru/')

function showAlert(msg, category = 'success') {
    let alertsContainer = document.querySelector('.alerts');
    let newAlertElement = document.getElementById('alerts-template').cloneNode(true);
    newAlertElement.classList.add('alert-' + category);
    newAlertElement.querySelector('.msg').innerHTML = msg;
    newAlertElement.classList.remove('d-none');
    alertsContainer.append(newAlertElement);
}

async function creatingTasks(form) {
    let newURL = url + '/api/tasks' + '?api_key=' + api_key;
    let data = new FormData(form);
    data.set('status', form.elements['column'].value);
    data.set('desc', form.elements['description'].value);
    data.set('id', form.elements['task-id'].value);

    let result = await fetch(newURL, {
        method: 'POST',
        body: data
    })
    return await result.json();
}

async function createTaskElement(form) {
    let data = await creatingTasks(form)
        .then(function (res) {
            let newTaskElement = document.getElementById('task-template').cloneNode(true);
            newTaskElement.id = res.id;
            newTaskElement.querySelector('.task-name').innerHTML = form.elements['name'].value;
            newTaskElement.querySelector('.task-description').innerHTML = form.elements['description'].value;
            newTaskElement.classList.remove('d-none');
            for (let btn of newTaskElement.querySelectorAll('.move-btn')) {
                btn.onclick = moveBtnHandler;
            }
            return newTaskElement
        })
        .catch(err => showAlert(err, 'danger'));
    return data

}

async function updatingTasks(form, name, description) {
    let data = new FormData(form);
    data.delete('action');
    data.delete('description');
    data.delete('column');
    if (name != '')
        data.set('name', name);
    else
        data.set('desc', description);

    let newURL = url + 'api/tasks/' + form.elements['task-id'].value + '?api_key=' + api_key;

    let results = await fetch(newURL, {
        method: 'PUT',
        body: data
    })
    return results;
}


function updateTask(form) {
    let taskElement = document.getElementById(form.elements['task-id'].value);
    let currentTaskName = taskElement.querySelector('.task-name').innerHTML;
    let currentTaskDescription = taskElement.querySelector('.task-description').innerHTML;
    if (currentTaskName != form.elements['name'].value)
        currentTaskName = form.elements['name'].value;
    else
        currentTaskName = '';
    if (currentTaskDescription != form.elements['description'].value)
        currentTaskDescription = form.elements['description'].value;
    else
        currentTaskDescription = '';

    updatingTasks(form, currentTaskName, currentTaskDescription)
        .then(function () {
            taskElement.querySelector('.task-name').innerHTML = form.elements['name'].value;
            taskElement.querySelector('.task-description').innerHTML = form.elements['description'].value;
        })
        .catch(err => showAlert(err, 'danger'));
}

function actionTaskBtnHandler(event) {
    let form, listElement, tasksCounterElement, alertMsg, action;
    form = event.target.closest('.modal').querySelector('form');
    action = form.elements['action'].value;

    if (action == 'create') {
        listElement = document.getElementById(`${form.elements['column'].value}-list`);
        createTaskElement(form)
            .then(elem => listElement.append(elem))
            .catch(err => showAlert(err, 'danger'));

        tasksCounterElement = listElement.closest('.card').querySelector('.tasks-counter');
        tasksCounterElement.innerHTML = Number(tasksCounterElement.innerHTML) + 1;

        alertMsg = `Задача ${form.elements['name'].value} была успешно создана!`;
    } else if (action == 'edit') {
        updateTask(form);

        alertMsg = `Задача ${form.elements['name'].value} была успешно обновлена!`;
    }

    if (alertMsg) {
        showAlert(alertMsg);
    }
}

function resetForm(form) {
    form.reset();
    form.querySelector('select').closest('.mb-3').classList.remove('d-none');
    form.elements['name'].classList.remove('form-control-plaintext');
    form.elements['description'].classList.remove('form-control-plaintext');
}

function setFormValues(form, taskId) {
    let taskElement = document.getElementById(taskId);
    form.elements['name'].value = taskElement.querySelector('.task-name').innerHTML;
    form.elements['description'].value = taskElement.querySelector('.task-description').innerHTML;
    form.elements['task-id'].value = taskId;
}

function prepareModalContent(event) {
    let form = event.target.querySelector('form');
    resetForm(form);

    let action = event.relatedTarget.dataset.action || 'create';

    form.elements['action'].value = action;
    event.target.querySelector('.modal-title').innerHTML = titles[action];
    event.target.querySelector('.action-task-btn').innerHTML = actionBtnText[action];

    if (action == 'show' || action == 'edit') {
        setFormValues(form, event.relatedTarget.closest('.task').id);
        event.target.querySelector('select').closest('.mb-3').classList.add('d-none');
    }

    if (action == 'show') {
        form.elements['name'].classList.add('form-control-plaintext');
        form.elements['description'].classList.add('form-control-plaintext');
    }

}

async function tasksRemoving(form) {
    let newURL = url + '/api/tasks/' + form.elements['task-id'].value + '?api_key=' + api_key;
    return fetch(newURL, {
        method: 'DELETE'
    })
}

function removeTaskBtnHandler(event) {
    tasksRemoving(event.target.closest('.modal').querySelector('form'))
        .then(() => {
            let form = event.target.closest('.modal').querySelector('form');
            let taskElement = document.getElementById(form.elements['task-id'].value);

            let tasksCounterElement = taskElement.closest('.card').querySelector('.tasks-counter');
            tasksCounterElement.innerHTML = Number(tasksCounterElement.innerHTML) - 1;

            taskElement.remove();
        })
        .catch(err => showAlert(err, 'danger'));



}

async function movingTasks(listElement, id) {
    let data = new FormData();
    data.set('status', listElement.replace('-list', ''));

    let newURL = url + 'api/tasks/' + id + '?api_key=' + api_key;

    let results = await fetch(newURL, {
        method: 'PUT',
        body: data
    })
    return results;
}

function moveBtnHandler(event) {
    let taskElement = event.target.closest('.task');
    let currentListElement = taskElement.closest('ul');
    let targetListElement = document.getElementById(currentListElement.id == 'to-do-list' ? 'done-list' : 'to-do-list');
    console.log(targetListElement.id);
    movingTasks(targetListElement.id, taskElement.id)
        .then(function () {
            let tasksCounterElement = taskElement.closest('.card').querySelector('.tasks-counter');
            tasksCounterElement.innerHTML = Number(tasksCounterElement.innerHTML) - 1;

            targetListElement.append(taskElement);

            tasksCounterElement = targetListElement.closest('.card').querySelector('.tasks-counter');
            tasksCounterElement.innerHTML = Number(tasksCounterElement.innerHTML) + 1;
        })
        .catch(err => showAlert(err, 'danger'));
}

let taskCounter = 0;

let titles = {
    'create': 'Создание новой задачи',
    'edit': 'Редактирование задачи',
    'show': 'Просмотр задачи'
}

let actionBtnText = {
    'create': 'Создать',
    'edit': 'Сохранить',
    'show': 'Ок'
}

async function tasksJsonPreload() {
    return fetch(url + '/api/tasks' + '?api_key=' + api_key)
        .then(res => res.json())
        .catch(err => showAlert(err, 'danger'));
}

async function renderTasks(tasks) {
    for (let i = 0; i < tasks.length; i++) {
        taskCounter = i + 1;
        let newTaskElement = document.getElementById('task-template').cloneNode(true);
        newTaskElement.id = tasks[i].id;
        newTaskElement.querySelector('.task-name').innerHTML = tasks[i].name;
        newTaskElement.querySelector('.task-description').innerHTML = tasks[i].desc;
        newTaskElement.classList.remove('d-none');
        for (let btn of newTaskElement.querySelectorAll('.move-btn')) {
            btn.onclick = moveBtnHandler;
        }
        let listElement = document.getElementById(`${tasks[i].status}-list`);
        listElement.append(newTaskElement);

        let tasksCounterElement = listElement.closest('.card').querySelector('.tasks-counter')
        tasksCounterElement.innerHTML = Number(tasksCounterElement.innerHTML) + 1;
    }
}

window.onload = function () {
    tasksJsonPreload()
        .then(json => renderTasks(json.tasks));


    document.querySelector('.action-task-btn').onclick = actionTaskBtnHandler;

    document.getElementById('task-modal').addEventListener('show.bs.modal', prepareModalContent);

    document.getElementById('remove-task-modal').addEventListener('show.bs.modal', function (event) {
        let taskElement = event.relatedTarget.closest('.task');
        let form = event.target.querySelector('form');
        form.elements['task-id'].value = taskElement.id;
        event.target.querySelector('.task-name').innerHTML = taskElement.querySelector('.task-name').innerHTML;
    });
    document.querySelector('.remove-task-btn').onclick = removeTaskBtnHandler;

    for (let btn of document.querySelectorAll('.move-btn')) {
        btn.onclick = moveBtnHandler;
    }
}