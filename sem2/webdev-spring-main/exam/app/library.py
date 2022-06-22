import datetime
from flask import Blueprint, render_template, request, redirect, url_for, flash, send_file
from flask_login import login_required, current_user
from models import User, Books, Reviews, Genre, book_genre_like, Covers
from auth import check_rights
from tools import ImageSaver
from app import db, app
import os
import bleach

bp = Blueprint('library', __name__, url_prefix='/library')

PER_PAGE = 5

BOOK_PARAMS = ['name', 'short_desc', 'year', 'author', 'publisher', 'volume']

def params():
    return {p: bleach.clean(request.form.get(p)) for p in BOOK_PARAMS }

@bp.route('/new')
@login_required
@check_rights('create')
def new():
    genres = Genre.query.all()
    return render_template('library/new.html', genres=genres)

@bp.route('/create', methods=['GET', 'POST'])
@login_required
@check_rights('create')
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
    
    try:
        db.session.commit()
    except:
        flash("Произошла ошибка, книга не была добавлена", 'danger')
        return redirect(url_for('index'))

    flash(f'Книга {book.name} была успешна добавлена.', 'success')
    return redirect(url_for('index'))

@bp.route('/<int:book_id>/update')
@login_required
@check_rights('update')
def update(book_id):
    book= Books.query.get(book_id)
    genres = Genre.query.all()
    return render_template('library/update.html', genres=genres, book=book)

@bp.route('/<int:book_id>/edit', methods=['GET','POST'])
@login_required
@check_rights('update')
def edit(book_id):
    book = Books.query.get(book_id)
    genres = request.form.getlist('genres')
    try:
        book.name = bleach.clean(request.form.get('name')) 
        book.short_desc = bleach.clean(request.form.get('short_desc')) 
        book.year = bleach.clean(request.form.get('year')) 
        book.author = bleach.clean(request.form.get('author')) 
        book.publisher = bleach.clean(request.form.get('publisher')) 
        book.volume = bleach.clean(request.form.get('volume')) 
        book.genre.clear()
        for genre_ in genres:
            genre = Genre.query.get(genre_)
            book.genre.append(genre, book.id)

        db.session.add(book)
        db.session.commit()
    except:
        db.session.rollback()
        flash("Произошла ошибка, книга не была обновлена", 'danger')
        return redirect(url_for('index'))

    flash(f'Книга {book.name} была успешна обновлена.', 'success')
    return redirect(url_for('index'))

@bp.route('/<int:book_id>/delete', methods=['GET','POST'])
@login_required
@check_rights('delete')
def delete(book_id):
    book = Books.query.get(book_id)
    cover = Covers.query.filter(Covers.book_id==book_id).first()
    db.session.delete(book)

    if cover is not None:
        cover_img = cover.get(storage_filename, None)
        os.remove(os.path.join(app.config['UPLOAD_FOLDER'], cover_img))
        db.session.delete(cover)

    try:
        db.session.commit()
    except:
        flash("Произошла ошибка, книга не удалена", 'danger')
        return redirect(url_for('index'))

    flash("Книга была успешно удалена!", 'success')
    return redirect(url_for('index'))



@bp.route('/<int:book_id>/show')
def show(book_id):
    book = Books.query.get(book_id)
    genres = Genre.query.all()
    cover = Covers.query.filter(Covers.book_id==book_id).first()
    return render_template('library/show.html', genres=genres, book=book, cover=cover)