import os
SECRET_KEY = '6415c23e7c2d000e95d4b157c0522e33fde56fae2f5364ced196966e49a25a6b'

SQLALCHEMY_DATABASE_URI = 'mysql+mysqlconnector://std_1695_lab6:zxczxczxc@std-mysql/std_1695_lab6'
SQLALCHEMY_TRACK_MODIFICATIONS = False
# SQLALCHEMY_ECHO = True

UPLOAD_FOLDER = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'media', 'images')