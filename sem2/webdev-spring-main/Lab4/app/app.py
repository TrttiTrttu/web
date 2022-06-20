from flask import Flask, render_template, session, request, redirect, url_for, flash
from flask_login import LoginManager, UserMixin, login_user, logout_user, login_required, current_user
from mysql_db import MySQL
import mysql.connector as connector

login_manager = LoginManager()

app = Flask(__name__)
application = app

mysql = MySQL(app)

CREATE_PARAMS = ['login', 'password', 'first_name', 'last_name', 'middle_name', 'role_id']

UPDATE_PARAMS = [ 'first_name','last_name', 'middle_name', 'role_id']

def request_params(params_list):
    params = {}
    for param_name in params_list:
        params[param_name] = request.form.get(param_name) or None
    return params

def load_roles():
    with mysql.connection.cursor(named_tuple=True) as cursor:
        cursor.execute('SELECT id, name FROM roles;')
        roles = cursor.fetchall()
    return roles

login_manager.init_app(app)
login_manager.login_view = 'login'
login_manager.login_message = 'Для доступа к этой странице необходимо пройти процедуру аутентификации'
login_manager.login_message_category = 'warning'


class User(UserMixin):
    def __init__(self, user_id, login):
        super().__init__()
        self.id = user_id
        self.login = login

@login_manager.user_loader
def load_user(user_id):
    with mysql.connection.cursor(named_tuple=True) as cursor:
        cursor.execute('SELECT * FROM users WHERE id=%s;', (user_id,))
        db_user = cursor.fetchone()
    if db_user:
            return User(user_id=db_user.id, login=db_user.login)
    return None 


app.config.from_pyfile('config.py')

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/login', methods = ['GET', 'POST'])
def login():
    if request.method == "POST":
        login_ = request.form.get('login')
        password = request.form.get('password')
        remember_me = request.form.get('remember_me')
        with mysql.connection.cursor(named_tuple=True) as cursor:
            cursor.execute('SELECT * FROM users WHERE login=%s AND password_hash=SHA2(%s, 256);', (login_, password))
            db_user = cursor.fetchone()
        if db_user:
            login_user(User(user_id=db_user.id, login=db_user.login), remember=remember_me)
            flash('Вы успешно прошли процедуру аутентификации.', 'success')
            next_ = request.args.get('next')
            return redirect(next_ or url_for('index'))
        flash('Введены неверные логин и/или пароль.', 'danger')
    return render_template('login.html')

@app.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('index'))

@app.route('/users')
def users():
    with mysql.connection.cursor(named_tuple=True) as cursor:
        cursor.execute('SELECT users.*, roles.name AS role_name FROM users LEFT JOIN roles ON users.role_id = roles.id;')
        users = cursor.fetchall()
    return render_template('users/index.html', users=users)

@app.route('/users/new')
@login_required
def new():
    return render_template('users/new.html', errors={}, user={}, roles=load_roles())

@app.route('/users/create', methods=['POST'])
@login_required
def create():
    params = request_params(CREATE_PARAMS)

    errors = check_input_data(params)
    if errors['login'] is not None or errors['password'] is not None or errors['first_name'] is not None or errors['last_name'] is not None:
        return render_template('users/new.html', errors=errors, user=params, roles=load_roles())

    with mysql.connection.cursor(named_tuple=True) as cursor:
        try:
            cursor.execute(
                ('INSERT INTO users (login, password_hash, last_name, first_name, middle_name, role_id)' 
                'VALUES (%(login)s, SHA2(%(password)s, 256), %(last_name)s, %(first_name)s, %(middle_name)s, %(role_id)s);'), 
                params
            )
            mysql.connection.commit()
        except connector.Error:
            flash('Введены некорректные данные. Ошибка сохранения', 'danger')
            return render_template('users/new.html', user=params, roles=load_roles(), errors=errors)
    flash(f"Пользователь {params.get('login')} был успешно создан!", 'success')
    return redirect(url_for('users'))

@app.route('/users/<int:user_id>')
def show(user_id):
    with mysql.connection.cursor(named_tuple=True) as cursor:
        cursor.execute('SELECT * FROM users WHERE id=%s;', (user_id,))
        user = cursor.fetchone()
    return render_template('users/show.html', user=user)

@app.route('/users/<int:user_id>/edit')
@login_required
def edit(user_id):
    with mysql.connection.cursor(named_tuple=True) as cursor:
        cursor.execute('SELECT * FROM users WHERE id=%s;', (user_id,))
        user = cursor.fetchone()
    return render_template('users/edit.html', user=user, errors={}, roles=load_roles())

@app.route('/users/<int:user_id>/update', methods=['POST'])
@login_required
def update(user_id):
    params = request_params(UPDATE_PARAMS)
    params['role_id'] = int(params['role_id']) if params['role_id'] else None
    params['id'] = user_id

    errors = check_input_data(params)
    if errors['first_name'] is not None or errors['last_name'] is not None:
        return render_template('users/edit.html', errors=errors, user=params, roles=load_roles())

    with mysql.connection.cursor(named_tuple=True) as cursor:
        try:
            cursor.execute(
                ('UPDATE users SET last_name=%(last_name)s, first_name=%(first_name)s, middle_name=%(middle_name)s, role_id=%(role_id)s,'
                 'middle_name=%(middle_name)s, role_id=%(role_id)s WHERE id=%(id)s;'), params)
            mysql.connection.commit()
        except connector.Error:
            flash('Введены некорректные данные. Ошибка сохранения', 'danger')
            return render_template('users/edit.html', user=params, roles=load_roles())
    flash("Пользователь был успешно обновлен!", 'success')
    return redirect(url_for('show', user_id=user_id))

@app.route('/users/<int:user_id>/delete', methods=['POST'])
@login_required
def delete(user_id):
    with mysql.connection.cursor(named_tuple=True) as cursor:
        try:
            cursor.execute(
                ('DELETE FROM users WHERE id=%s'), (user_id, ))
            mysql.connection.commit()
        except connector.Error:
            flash('Не удалось удалить пользователя', 'danger')
            return redirect(url_for('users'))
    flash("Пользователь был успешно удален!", 'success')
    return redirect(url_for('users'))

@app.route('/change', methods=['GET', 'POST'])
@login_required
def changepswd():
    if request.method == 'POST':
        oldPswd = request.form.get('oldPswd')
        newPswd = request.form.get('newPswd')
        confNewPswd = request.form.get('confNewPswd')
        login = current_user.login

        with mysql.connection.cursor(named_tuple=True) as cursor:
            cursor.execute(
                'SELECT * FROM users WHERE login=%s and password_hash=SHA2(%s, 256);', (login, oldPswd))
            db_user = cursor.fetchone()
        
        if db_user:
            if newPswd != confNewPswd:
                flash('Новый пароль не подтвержден', 'danger')
                return redirect(url_for('changepswd'))

            isPswd = check_password(newPswd)
            if isPswd is not None:
                flash(isPswd, 'danger')
                return redirect(url_for('changepswd'))
            
            with mysql.connection.cursor(named_tuple=True) as cursor:
                cursor.execute(
                    ("UPDATE users SET password_hash=SHA2(%s, 256) WHERE login=%s;"), (newPswd, login))
                mysql.connection.commit()

            flash('Пароль успешно изменён', 'success')
            return redirect(url_for('index'))
        else:
            flash('Старый пароль не совпадает', 'danger')
            return redirect(url_for('changepswd'))

    return render_template('changepswd.html')

def check_input_data(params):
    error = {'login': None, 'password': None,'first_name': None, 'last_name': None}

    error['login'] = check_login(params['login'])
    error['password'] = check_password(params['password'])
    error['first_name'] = check_first_name(params['first_name'])
    error['last_name'] = check_last_name(params['last_name'])

    return error


def check_login(login):
    allowedChars = "abcdefghijklmnopqrstuvwxyz1234567890"

    if login is None:
        return "Логин не может быть пустым"
    if len(login) < 5:
        return "Длина логина должна быть не менее 5 символов"

    for char in login:
        if allowedChars.find(char) == -1:
            return "Логин должен состоять только из латинских букв и цифр"

    return None

def check_first_name(first_name):
    if first_name is None:
        return "Поле не должно быть пустым"
    if len(first_name) == 0:
        return "Поле не должно быть пустым"
    return None


def check_last_name(last_name):
    # if last_name is None:
    #     return "Поле не должно быть пустым"
    if last_name is None or len(last_name) == 0:
        return "Поле не должно быть пустым"
    return None

def check_password(password):
    allowedChars = "abcdefghijklmnopqrstuvwxyzабвгдеёжзийклмнопрстуфхцчшщъыьэюя1234567890~!?@#$%^&*_-+()[]{>}</\|\"\'.,:;"
    if password is None:
        return "Длина пароля от 8 до 128 символов"
    if len(password) < 8 or len(password) > 128:
        return "Длина пароля от 8 до 128 символов"

    for char in password:
        if char == " ":
            return "Пароль не может содержать пробелы"
        if allowedChars.find(char.lower()) == -1:
            return "Пароль содержит запрещенные символы"

    oneUp = False
    oneLow = False
    i = 0

    while not (oneUp and oneLow) and i < len(password):
        if password[i].islower():
            oneLow = True
        if password[i].isupper():
            oneUp = True
        i += 1 

    if not oneUp or not oneLow:
        return "Пароль должен содержать хотя бы одну заглавную и одну строчную букву"

    return None