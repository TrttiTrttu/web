import io
import datetime
from flask import Blueprint, render_template, request, redirect, url_for, flash, send_file
from flask_login import login_required, current_user
from models import User, Books, Reviews
from auth import check_rights

bp = Blueprint('library', __name__, url_prefix='/library')

PER_PAGE = 5

@bp.route('/new')
@check_rights('create')
@login_required
def new():
    book= {}
    return render_template('library/new.html', book=book)

@bp.route('/update')
@check_rights('update')
@login_required
def update():
    book= {}
    return render_template('library/update.html', book=book)