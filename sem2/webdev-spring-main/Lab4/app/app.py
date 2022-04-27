
from flask import Flask, make_response, render_template, request, session, redirect, url_for, flash
from flask_login import LoginManager, UserMixin, login_user, logout_user, login_required
from mysql_db import MySQL

app = Flask(__name__)
application = app

login_manager = LoginManager()

login_manager.init_app(app)
login_manager.login_view = 'login'
login_manager.login_message = 'авторизуйтесь'
login_manager.login_message_category = 'warning'


mysql = MySQL(app)

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

@app.route('/visits')
def visits():
    if session.get('visits_count') is None:
        session['visits_count'] = 1
    else:
        session['visits_count'] += 1
    return render_template('visits.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        login_ = request.form.get('login')
        password_ = request.form.get('password')
        remember_me = request.form.get('remember_me') == 'on'
        with mysql.connection.cursor(named_tuple=True) as cursor:
            cursor.execute('SELECT * FROM users WHERE login=%s AND password_hash=SHA2(%s, 256);', (login_, password_))
            db_user = cursor.fetchone()
            if db_user:
                login_user(User(user_id=db_user.id, login=db_user.login),
                    remember=remember_me)
                flash('Классный вход', 'success')
                next_ = request.args.get('next')
                return redirect(next_ or url_for('index'))
        flash('Плохо, что-то плохо', 'danger')
    return render_template('login.html')

@app.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('index'))

@app.route('/secret_page')
@login_required
def secret_page():
    return render_template('secret_page.html')