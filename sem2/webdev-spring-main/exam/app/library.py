import io
import datetime
from flask import Blueprint, render_template, request, redirect, url_for, flash, send_file
from flask_login import login_required, current_user
from models import User, Books, Reviews, Genre, book_genre_like
from auth import check_rights
from tools import ImageSaver
from app import db

bp = Blueprint('library', __name__, url_prefix='/library')

PER_PAGE = 5

BOOK_PARAMS = ['name', 'short_desc', 'year', 'author', 'publisher', 'volume']

def params():
    return {p: request.form.get(p) for p in BOOK_PARAMS }

@bp.route('/new')
@check_rights('create')
@login_required
def new():
    genres = Genre.query.all()
    return render_template('library/new.html', genres=genres)

@bp.route('/create', methods=['POST'])
@check_rights('create')
@login_required
def create():
    book = Books(**params())
    genres = request.form.getlist('genres')

    for genre_ in genres:
        genre = Genre.query.get(genre_)
        book.genre.append(genre, book.id)

    db.session.add(book)

    f = request.files.get('cover_img')
    if f and f.filename:
        img = ImageSaver(f, book).save()

    db.session.commit()

    flash(f'Книга {book.name} была успешна добавлена.', 'success')
    return redirect(url_for('index'))

@bp.route('/update')
@check_rights('update')
@login_required
def update():
    book= {}
    return render_template('library/update .html', book=book)