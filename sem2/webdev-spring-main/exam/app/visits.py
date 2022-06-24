import math
import io
import datetime
from auth import check_rights
from flask import Blueprint, render_template, request, redirect, url_for, flash, send_file
from flask_login import login_required, current_user
from models import User, Books, Visits
import sqlalchemy as sa
import csv
from collections import Counter

bp = Blueprint('visits', __name__, url_prefix ='/visits')

PER_PAGE = 10

def convert_to_csv(records):
    fields = [column.name for column in Visits.__mapper__.columns]
    print(fields, 'qwer')
    result = ','.join(fields) + '\n'
    for i, record in enumerate(records):
        result += ','.join([str(getattr(record, f, '')) for f in fields]) + '\n'
    return result
    

def generate_report(records):
    buffer = io.BytesIO()
    buffer.write(convert_to_csv(records).encode('utf-8'))
    buffer.seek(0)
    return buffer

@bp.route('/logs')
@login_required
def logs():
    return render_template('visits/logs.html', user=current_user)

@bp.route('/stats/users', methods=['GET','POST'])
@check_rights('view_logs')
@login_required
def users_stat():
    page = request.args.get('page', 1, type=int)

    fromdate = request.form.get('trip-start')
    todate = request.form.get('trip-end')
    
    if request.args.get('fromdate') and request.args.get('fromdate') != '':
        fromdate = request.args.get('fromdate')
    if request.args.get('todate') and request.args.get('todate') != '':
        todate = request.args.get('todate')
    
    if fromdate is None and todate is None or fromdate == '' and todate == '':
        records = Visits.query 
    else:
        if fromdate is None or fromdate == '':
            fromdate = datetime.datetime.now().strftime('%Y-%m-%d')
        if todate is None or todate == '':
            todate = datetime.datetime.now().strftime('%Y-%m-%d')
        records = Visits.query.filter(Visits.created_at > datetime.datetime.now().strftime(fromdate+' 00:00:00')).filter(Visits.created_at < datetime.datetime.now().strftime(todate+' 23:59:59'))
        
    pagination = records.paginate(page, PER_PAGE)
    records = records.all()

    if request.args.get('download_csv'):
        f = generate_report(Visits.query)
        filename = now_date + '_stat.csv'
        return send_file(f, mimetype='text/csv', as_attachment=True, attachment_filename=filename)

    records = pagination.items

    return render_template('visits/users_stat.html', pagination=pagination, records=records, user=current_user, fromdate=fromdate, todate=todate )

@bp.route('/stats/pages')
@check_rights('view_logs')
@login_required
def books_stat():
    dict_books = {}
    all_visits = Visits.query.filter(sa.sql.func.substring(sa.sql.func.reverse(Visits.path), 1, 4) == 'wohs').order_by(Visits.created_at.desc())
    for visit in all_visits:
        book_id = visit.path[visit.path.find('/'): visit.path.rfind('/')]
        book_id = book_id[book_id.rfind('/') + 1:]
        if book_id in dict_books:
            dict_books[book_id] += 1
        else:
            dict_books[book_id] = 1  

    books_ids = sorted(dict_books, key=dict_books.get)
    books_ids = books_ids[::-1]
    records = {}

    for i in books_ids:
        if Books.query.get(i) is not None:
            book = Books.query.get(i)
            records[book.name] = dict_books[i]

    return render_template('visits/books_stat.html', records=records, user=current_user)
