from flask import Flask, render_template, redirect, url_for, request
from flask_login import LoginManager, UserMixin, current_user, login_required, login_user
from sqlalchemy import create_engine

# setup FLASK
app = Flask(__name__)
app.config['SECRET_KEY'] = "secretSurveyProjectDB"

# DATABASE connection
engine = create_engine('postgresql://postgres:MMgp@23082312@localhost:5432/postgres')

# setup login manager
login_manager = LoginManager()
login_manager.init_app(app)


class User(UserMixin):
    def __init__(self, id, user, pwd):
        self.id = id
        self.user = user
        self.pwd = pwd


@login_manager.user_loader
def load_user(user_id):
    connection = engine.connect()
    rs = connection.execute(
        "SELECT id_user, username, hashed_password FROM \"DBquestionario\".\"User\" WHERE id_user = ?;", user_id)
    user = rs.techone()
    connection.close()
    return User(user.id, user.user, user.pwd)


def get_user_by_username(username):
    connection = engine.connect()
    rs = connection.execute(
        "SELECT id_user, username, hashed_password FROM \"DBquestionario\".\"User\" WHERE username = ?;", username)
    user = rs.techone()
    connection.close()
    return User(user.id, user.user, user.pwd)


@app.route('/')
def route():
    return render_template('home.html')


@app.route('/login', methods=['GET ', 'POST'])
def login():
    if request.method == 'POST':
        connection = engine.connect()
        rs = connection.execute('SELECT hashed_password FROM \"DBquestionario\".\"User\" WHERE user  =  %s', [request.form['login_username']])
        actual_pwd = rs.fetchone()
        connection.close()

        if actual_pwd is not None:
            #check pwd
            if request.form['login_password'] == actual_pwd['hashed_password']:
                login_user(get_user_by_username(request.form['user']))
        else:
            return redirect(url_for('home'))
    else:
        return redirect(url_for('home'))


    if current_user.is_authenticated:
        return redirect(url_for('profile'))
    return render_template('login.html')


@app.route('/registration')
def register():
    if current_user.is_authenticated:
        return redirect(url_for('profile'))
    return render_template('register.html')


@app.route('/profile')
@login_required
def profile():
    return render_template('profile.html', user=current_user.user)


@app.route('/users')
def users():
    # Database connection
    connection = engine.connect()

    # test query
    user_list = connection.execute("SELECT  * FROM \"DBquestionario\".\"User\";")

    # closing connection
    connection.close()

    # result iteration
    s = ""
    for row in user_list:
        s += str(row) + '<br>'
    return s
