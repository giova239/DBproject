from flask import Flask, render_template, redirect, url_for, request, make_response
from flask_login import LoginManager, UserMixin, current_user, login_required, login_user, logout_user
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
        "SELECT id_user, username, hashed_password FROM \"DBquestionario\".\"User\" WHERE id_user = %s;", user_id)
    user = rs.fetchone()
    connection.close()
    return User(user.id_user, user.username, user.hashed_password)


def get_user_by_username(username):
    connection = engine.connect()
    rs = connection.execute(
        "SELECT id_user, username, hashed_password FROM \"DBquestionario\".\"User\" WHERE username = %s;", username)
    user = rs.fetchone()
    connection.close()
    if user:
        return User(user.id_user, user.username, user.hashed_password)
    else:
        return None


@app.route('/')
def route():
    return render_template('home.html')


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        # DB query to find username
        user = get_user_by_username(request.form['login_username'])

        if user is not None:
            # check pwd
            if request.form['login_password'] == user.pwd:
                login_user(user)
                print("user  loggato")
                return redirect(url_for('profile'))
            else:
                return render_template('login.html', error="password isn't correct")
        else:
            return render_template('login.html', error="username doesn't exist")
    else:
        if current_user.is_authenticated:
            return redirect(url_for('profile'))
        return render_template('login.html')


@app.route('/logout')
@login_required  # richiede autenticazione
def logout():
    logout_user()  # chiamata a Flask - Login
    return redirect(url_for('route'))


@app.route('/registration')
def register():
    if current_user.is_authenticated:
        return redirect(url_for('profile'))
    return render_template('register.html')


@app.route('/profile')
@login_required
def profile():
    return make_response(render_template('profile.html', user=current_user.user))


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

@app.route('/textquestion')
def textquestion():
    return render_template('textquestion.html', text="bamo raga!")

@app.route('/datequestion')
def datequestion():
    return render_template('datequestion.html', text="LEtzee gooo")