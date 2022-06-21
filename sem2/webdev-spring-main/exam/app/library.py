import io
import datetime
from flask import Blueprint, render_template, request, redirect, url_for, flash, send_file
from flask_login import login_required, current_user
from models import User, Books, Reviews
from auth import check_rights, User as User_

bp = Blueprint('library', __name__, url_prefix='/library')

PER_PAGE = 5

@bp.route('/new')
@check_rights('create')
@login_required
def new():
    print('qwerqwer')
    return render_template('library/new.html')