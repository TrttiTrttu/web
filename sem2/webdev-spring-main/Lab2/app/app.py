from flask import Flask, render_template, request, make_response
import operator as op

app = Flask(__name__)
application = app

OPERATIONS = {'+':op.add, '-':op.sub, '*':op.mul, '/':op.truediv}
ALLOWED_SYMBOLS = ['0','1','2','3','4','5','6','7','8','9','(',')',' ','.','-','+']
@app.route('/')
def index():
    url = request.url
    return render_template('index.html')

@app.route('/args')
def args():
    return render_template('args.html')

@app.route('/headers')
def headers():
    return render_template('headers.html')

@app.route('/form', methods=['GET','POST'])
def form():
    return render_template('form.html')

@app.route('/calc', methods=['GET','POST'])
def calc():
    result = None
    error_msg = None
    if request.method == 'POST':
        try:
            operand1 = float(request.form.get('operand1'))
            operand2 = float(request.form.get('operand2'))
            operation = request.form.get('operation')
            result = OPERATIONS[operation](operand1, operand2) 
        except ValueError:
            error_msg = 'нужно вводить только цифры'
        except ZeroDivisionError:
            error_msg = 'на ноль делить нельзя'
    return render_template('calc.html', operations=OPERATIONS, result=result, error_msg=error_msg)

@app.route('/cookies')
def cookies():
    response = make_response(render_template('cookies.html'))
    if request.cookies.get('namecookie') is None:
        response.set_cookie('namecookie', 'valuecookie')
    else:
        response.set_cookie('namecookie', 'valuecookie', expires=0)
    return response

def check_number(number, error_msg):
    dig_counter = 0
    digits_list = []
    number = number.replace('+7','8')
    if (number[0] == '8'):
        number = number[1:]
    for symb in number:
        if symb in ALLOWED_SYMBOLS:
            if symb.isdigit():
                dig_counter += 1
                digits_list.append(symb)
        else:
            error_msg = 'Недопустимый ввод. B номере телефона встречаются недопустимые символы. '
    if (len(digits_list) != 10):
        error_msg += 'Недопустимый ввод. Неверное количество цифр.'
    result = '8-' + ''.join(digits_list[0:3]) + '-' + ''.join(digits_list[3:6]) + '-' + ''.join(digits_list[6:8]) + '-' + ''.join(digits_list[8:])
    return result, error_msg



@app.route('/phone', methods=['GET','POST'])
def phone():
    result = ''
    error_msg = ''
    if request.method == 'POST':
        result,error_msg = check_number(request.form.get('phonenumber'),error_msg)
        
    return render_template('phone.html', result=result, error_msg=error_msg)