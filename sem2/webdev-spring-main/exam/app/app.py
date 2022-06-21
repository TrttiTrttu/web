from flask import Flask, render_template, send_file, send_from_directory
from sqlalchemy import MetaData
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_login import current_user
import os

app = Flask(__name__)
application = app
app.config.from_pyfile('cfg.py')

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

from models import User, Books
# from models import Category, User, Image

@app.route('/')
def index():
    books = Books.query.all()

    return render_template('index.html', books=books)

@app.route('/media/images/<image_id>')
def image(image_id):
    image = Image.query.get(image_id)
    if image is None:
        abort(404)
    # return send_file(os.path.join(app.config['UPLOAD_FOLDER'], image.storage_filename))
    return send_from_directory(app.config['UPLOAD_FOLDER'], image.storage_filename)