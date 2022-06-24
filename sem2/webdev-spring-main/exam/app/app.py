from flask import Flask, render_template, send_file, send_from_directory, request
from sqlalchemy import MetaData
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_login import current_user
import os
import sqlalchemy as sa
from sqlalchemy import select, func
import datetime

app = Flask(__name__)
application = app
app.config.from_pyfile('cfg.py')

PER_PAGE = 5

convention = {
    "ix": 'ix_%(column_0_label)s',
    "uq": "uq_%(table_name)s_%(column_0_name)s",
    "ck": "ck_%(table_name)s_%(constraint_name)s",
    "fk": "fk_%(table_name)s_%(column_0_name)s_%(referred_table_name)s",
    "pk": "pk_%(table_name)s"
}

metadata = MetaData(naming_convention=convention)
db = SQLAlchemy(app, metadata=metadata)
migrate = Migrate(app, db)

from auth import bp as auth_bp, init_login_manager
from library import bp as library_bp 
from visits import bp as visits_bp

app.register_blueprint(auth_bp)
app.register_blueprint(library_bp)
app.register_blueprint(visits_bp)
init_login_manager(app)

from models import User, Books, Covers, Reviews, Visits

@app.before_request
def log_visit_info():
    if request.endpoint == 'static' or request.args.get('download_csv'):
        return None
    
    user_id = getattr(current_user, 'id', None)
    visit = Visits()
    visit.user_id = user_id
    visit.path = request.path
    if '/images' not in visit.path and visits_count(visit.path, user_id):
        try:
            db.session.add(visit)
            db.session.commit()
        except:
            db.session.rollback()

def visits_count(path, user_id):
    if 'show' in  path:
        at_DB = Visits.query.filter(sa.sql.func.substring(Visits.created_at, 1, 10) ==
             datetime.datetime.now().strftime('%Y-%m-%d')).filter(Visits.path == path).filter(Visits.user_id == user_id).limit(10).all()
        if len(at_DB) == 10:
            return False
    return True

@app.route('/')
def index():
    page = request.args.get('page', 1, type=int)
    books = Books.query.order_by(Books.year.desc())
    pagination = books.paginate(page, PER_PAGE)
    books = pagination.items
    reviews = []
    for book in books:
        reviews.append(Reviews.query.filter(Reviews.book_id == book.id).order_by(Reviews.created_at.desc()).all())

    dict_top_books = {}
    all_visits = Visits.query.filter(sa.sql.func.substring(sa.sql.func.reverse(Visits.path), 1, 4) == 'wohs').order_by(Visits.created_at.desc())
    for visit in all_visits:
        book_id = visit.path[visit.path.find('/'): visit.path.rfind('/')]
        book_id = book_id[book_id.rfind('/') + 1:]
        if book_id in dict_top_books:
            dict_top_books[book_id] += 1
        else:
            dict_top_books[book_id] = 1  

    top_books_ids = sorted(dict_top_books, key=dict_top_books.get)
    top_books_ids = top_books_ids[::-1]
    top_books = []
    visit_num = []

    for i in top_books_ids:
        if Books.query.get(i) is not None:
            visit_num.append(dict_top_books.get(i))
            top_books.append(Books.query.get(i))
        top_books = top_books[0:5]

    last_books = []
    cookies = request.cookies.get('5last') or ''
    
    for i in range(cookies.count('>')):
        id = cookies[cookies.find('<') + 1:cookies.find('>')]
        cookies = cookies[cookies.find('>') + 1:]
        if Books.query.get(id) is not None:
            last_books.append(Books.query.get(id))

    return render_template('index.html', pagination=pagination, books=books, reviews=reviews, top_books=top_books, visit_num=visit_num, last_books=last_books)

@app.route('/media/images/<cover_id>')
def image(cover_id):
    cover_img = Covers.query.get(cover_id)
    if cover_img is None:
        abort(404)
    return send_file(os.path.join(app.config['UPLOAD_FOLDER'], cover_img.storage_filename))