from flask import Flask, render_template, send_file, send_from_directory, request
from sqlalchemy import MetaData
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_login import current_user
import os

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

app.register_blueprint(auth_bp)
app.register_blueprint(library_bp)
init_login_manager(app)

from models import User, Books, Covers, Reviews


@app.route('/')
def index():
    page = request.args.get('page', 1, type=int)
    books = Books.query.order_by(Books.year.desc())
    pagination = books.paginate(page, PER_PAGE)
    books = pagination.items
    reviews = []
    for book in books:
        reviews.append(Reviews.query.filter(Reviews.book_id == book.id).order_by(Reviews.created_at.desc()).all())
    
    return render_template('index.html', pagination=pagination, books=books, reviews=reviews)

@app.route('/media/images/<cover_id>')
def image(cover_id):
    cover_img = Covers.query.get(cover_id)
    if cover_img is None:
        abort(404)
    return send_file(os.path.join(app.config['UPLOAD_FOLDER'], cover_img.storage_filename))
    # return send_from_directory(app.config['UPLOAD_FOLDER'], cover_img.storage_filename)