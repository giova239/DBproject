import sqlalchemy.exc
from flask import Flask, render_template, redirect, url_for, request, make_response
from flask_login import LoginManager, UserMixin, current_user, login_required, login_user, logout_user
from sqlalchemy import create_engine
from validate_email import validate_email

#TODO: hashing passwords
#TODO: survey creation
#TODO: improve private area (add My Surveys, share link)
#TODO: survey compilation

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

                # login
                login_user(user)
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
    # logout
    logout_user()
    return redirect(url_for('route'))


@app.route('/registration', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        print("POSTED")
        # taking data from the form
        username = request.form['register_username']
        mail = request.form['register_email']
        password = request.form['register_password']
        birth_date = request.form['register_birth_date']

        # check if username is written
        if username:

            # DB query to check if user already exists
            user = get_user_by_username(request.form['register_username'])

            if user is None:
                # check if email is written
                if mail:
                    # check if it is a valid mail
                    if validate_email(mail):
                        # check if a password is written
                        if password:
                            # check if birth date  was picked
                            if birth_date:
                                try:
                                    # registration
                                    connection = engine.connect()
                                    connection.execute("INSERT INTO \"DBquestionario\".\"User\"(username,hashed_password,email,birth_date) VALUES (%s,%s,%s,%s)",username, password, mail, birth_date)
                                    return redirect(url_for('registrationCompleted'))
                                except (TypeError, sqlalchemy.exc.DataError):
                                    return render_template('register.html', error="date format not valid(has to be yyyy-mm-dd)")
                            else:
                                return render_template('register.html', error="please insert your birth date")
                        else:
                            return render_template('register.html', error="please type a password")
                    else:
                        return render_template('register.html', error="email not valid")
                else:
                    return render_template('register.html', error="please type your email")
            else:
                return render_template('register.html', error="username already occupied")
        else:
            return render_template('register.html', error="please type a username")
    else:
        if current_user.is_authenticated:
            return redirect(url_for('profile'))
        return render_template('register.html')


@app.route('/registrationCompleted')
def registrationCompleted():
    return render_template('registrationCompleted.html')

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
    return render_template('textquestion.html', text="domanda di prova?")


@app.route('/datequestion')
def datequestion():
    return render_template('datequestion.html', text="domanda di prova?")
