import datetime
from flask import Blueprint, render_template, request, redirect, url_for, flash, send_file, make_response
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
        db.session.rollback()
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
    reviews = Reviews.query.filter(Reviews.book_id==book_id).all()

    for review in reviews:
        db.session.delete(review)
    db.session.delete(book)

    if cover is not None:
        cover_img = cover.storage_filename
        if os.path.exists(os.path.join(app.config['UPLOAD_FOLDER'], cover_img)):
            os.remove(os.path.join(app.config['UPLOAD_FOLDER'], cover_img))
        db.session.delete(cover)

   
    try:
        db.session.commit()
    except:
        db.session.rollback()
        flash("Произошла ошибка, книга не удалена", 'danger')
        return redirect(url_for('index'))

    flash("Книга была успешно удалена!", 'success')
    return redirect(url_for('index'))



@bp.route('/<int:book_id>/show')
def show(book_id):
    book = Books.query.get(book_id)
    genres = Genre.query.all()
    cover = Covers.query.filter(Covers.book_id==book_id).first()
    reviews = Reviews.query.filter(Reviews.book_id == book.id).order_by(Reviews.created_at.desc()).all()
        
    user_review = None
    if current_user.is_authenticated:
        user_review = Reviews.query.filter(Reviews.book_id == book.id).filter(Reviews.user_id == current_user.id).first()
    rsp =  make_response(render_template('library/show.html', genres=genres, book=book, cover=cover, reviews=reviews, user_review=user_review))
    new_cookies = ''
    old_cookies = request.cookies.get('5last') or ''
    
    if old_cookies.count('>') > 5:
        old_cookies = old_cookies[:old_cookies.rfind('<')]

    if f'<{book.id}>' in old_cookies:
        old_cookies = old_cookies.replace(f'<{book.id}>', '')

    new_cookies += f'<{book.id}>' + old_cookies
    rsp.set_cookie('5last', new_cookies)
    
    return rsp


@bp.route('/<int:book_id>/reviews/create', methods=["POST"])
@login_required
def create_review(book_id):
    user_id = current_user.id
    review_rating = bleach.clean(request.form.get('review-rating'))
    review_text = bleach.clean(request.form.get('review-text'))

    user_review = Reviews(user_id=user_id, rating=review_rating, text=review_text, book_id=book_id)
    db.session.add(user_review)

    book = Books.query.get(book_id)
    book.rating_num += 1
    book.rating_sum += int(review_rating)
    try:
        db.session.commit()
    except:
        db.session.rollback()
        flash("Произошла ошибка, отзыв не был добавлен", 'danger')
        return redirect(url_for('index'))
    flash("Отзыв был успешно добавлен!", 'success')
    return redirect(url_for('index'))