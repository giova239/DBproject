import werkzeug.exceptions
import sqlalchemy.exc
from flask import Flask, render_template, redirect, url_for, request, make_response
from flask_login import LoginManager, UserMixin, current_user, login_required, login_user, logout_user
from sqlalchemy import create_engine
from validate_email import validate_email
from werkzeug.security import generate_password_hash, check_password_hash

# TODO: make query for createSurvey
# TODO: improve private area (add My Surveys, share link, check results with charts)
# TODO: survey compilation
# TODO: user discrimination on all pages

# setup FLASK
app = Flask(__name__)
app.config['SECRET_KEY'] = "secretSurveyProjectDB"

# DATABASE connection
engine = create_engine('postgresql://postgres:admin@localhost:5432/postgres')

# setup login manager
login_manager = LoginManager()
login_manager.init_app(app)


# ----------------- CLASS USER -----------------
class User(UserMixin):
    def __init__(self, id, user, pwd):
        self.id = id
        self.user = user
        self.pwd = pwd

    def verify_password(self, pwd):
        return check_password_hash(self.pwd, pwd)


@login_manager.user_loader
def load_user(user_id):
    connection = engine.connect()
    rs = connection.execute(
        'SELECT id_user, username, hashed_password FROM "DBquestionario"."User" WHERE id_user = %s;', user_id)
    user = rs.fetchone()
    connection.close()
    if user:
        return User(user.id_user, user.username, user.hashed_password)
    else:
        return None


def get_user_by_username(username):
    connection = engine.connect()
    rs = connection.execute(
        'SELECT id_user, username, hashed_password FROM "DBquestionario"."User" WHERE username = %s;', username)
    user = rs.fetchone()
    connection.close()
    if user:
        return User(user.id_user, user.username, user.hashed_password)
    else:
        return None


# ----------------- LOGIN -----------------
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        # DB query to find username
        user = get_user_by_username(request.form['login_username'])
        if user is not None:
            # check pwd
            if user.verify_password(request.form['login_password']):
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


# ----------------- LOGOUT -----------------
@app.route('/logout')
@login_required  # richiede autenticazione
def logout():
    # logout
    logout_user()
    return redirect(url_for('route'))


# ----------------- REGISTRATION -----------------
@app.route('/registration', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
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
                                    connection.execute(
                                        'INSERT INTO "DBquestionario"."User"(username,hashed_password,email,birth_date) VALUES (%s,%s,%s,%s);',
                                        username, generate_password_hash(password), mail, birth_date)
                                    return redirect(url_for('registrationCompleted'))
                                except (TypeError, sqlalchemy.exc.DataError):
                                    return render_template('register.html',
                                                           error="date format not valid(has to be yyyy-mm-dd)")
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


# ----------------- PAGES -----------------


@app.route('/')
def route():
    if current_user.is_authenticated:
        return render_template('home.html', user=current_user.user)
    else:
        return render_template('home.html')


@app.route('/profile')
def profile():
    if current_user.is_authenticated:
        return make_response(render_template('profile.html', user=current_user.user))
    else:
        return redirect(url_for('login'))


@app.route('/createsurvey', methods=['GET', 'POST'])
def createsurvey():
    if request.method == 'POST':
        title = request.form['survey_title']
        question_number = int(request.form['questions_number'])
        print(title)
        questions_texts = []
        questions_types = []
        questions_options = []
        questions_options_number = []

        # GETTING FORMS INFO
        try:
            for i in range(1, question_number + 1):
                questions_texts.append(request.form['question_text_' + str(i)])
                questions_types.append(request.form['question_type_' + str(i)])
                print('Question #' + str(i) + ' -> ' + questions_texts[i - 1] + ' WITH TYPE ' + questions_types[i - 1])
                if (int(questions_types[i - 1]) == 1) or (int(questions_types[i - 1]) == 2):
                    options = []
                    questions_options_number.append(int(request.form['options_number_q' + str(i)]))
                    for j in range(1, questions_options_number[i-1] + 1):
                        options.append(request.form['option_' + str(j) + '_q' + str(i)])
                    questions_options.append(options)
                    print('option list:')
                    print(questions_options[i - 1])
                elif int(questions_types[i - 1]) == 6:
                    options = [request.form['min_q' + str(i)], request.form['max_q' + str(i)]]
                    questions_options.append(options)
                    questions_options_number.append(2)
                    print('min,max:')
                    print(questions_options[i - 1])
                else:
                    questions_options.append([])
                    questions_options_number.append(0)
        except werkzeug.exceptions.BadRequestKeyError:
            return make_response(
                render_template('createsurvey.html', user=current_user.user, error="missing parameters"))

        # POPULATING DATABASE
        connection = engine.connect()
        last_id = None
        print("question number: " + str(question_number))
        for i in range((question_number - 1), -1, -1):
            # inserting questions
            last_id = connection.execute(
                'INSERT INTO "DBquestionario"."Question"(text,next,type) VALUES(%s,%s,%s) RETURNING id_question;',
                questions_texts[i], last_id, questions_types[i]).fetchone()[0]
            if (int(questions_types[i]) == 1) or (int(questions_types[i]) == 2):
                for j in range(0, questions_options_number[i]):
                    # inserting options
                    connection.execute('INSERT INTO "DBquestionario"."Choice"(text,referred_question) VALUES(%s,%s);',
                                       questions_options[i][j], last_id)
            elif int(questions_types[i]) == 6:
                connection.execute('INSERT INTO "DBquestionario"."Range"(min,max,referred_question) VALUES(%s,%s,%s);',
                                   questions_options[i][0], questions_options[i][1], last_id)
        # inserting survey
        connection.execute('INSERT INTO "DBquestionario"."Survey"(title, creator, first_question) VALUES( %s, %s, %s);',
                           title, current_user.id, last_id)
        return redirect(url_for('surveyCreated'))
    else:
        if current_user.is_authenticated:
            return make_response(render_template('createsurvey.html', user=current_user.user))
        else:
            return redirect(url_for('login'))


@app.route('/textquestion')
def textquestion():

    return render_template('textquestion.html', text="domanda di prova?")


@app.route('/datequestion')
def datequestion():
    return render_template('datequestion.html', text="domanda di prova?")


@app.route('/timequestion')
def timequestion():
    return render_template('timequestion.html', text="domanda di prova?")


@app.route('/rangequestion')
def rangequestion():
    return render_template('rangequestion.html', text="domanda di prova?")


@app.route('/singlemultiplequestion')
def singlemultiplequestion():
    return render_template('singlemultiplequestion.html', text="domanda di prova?", opt1="risposta opt1",
                           opt2="risposta opt2", opt3="risposta opt3", opt4="risposta opt4", opt5="risposta opt5")


@app.route('/multiplequestion')
def multiplequestion():
    return render_template('multiplequestion.html', text="domanda di prova?", opt1="risposta opt1",
                           opt2="risposta opt2", opt3="risposta opt3", opt4="risposta opt4", opt5="risposta opt5")


@app.route('/yoursurvey')
def survey():
    return render_template('survey.html', title="titolo")


@app.route('/surveyCreated')
def surveyCreated():
    return render_template('surveyCreated.html')


# ----------------- DEBUG PAGES -----------------

@app.route('/testquery')
def testquery():
    connection = engine.connect()
    users = connection.execute('SELECT * FROM "DBquestionario"."User";')
    s = ""

    for user in users:
        s += str(user) + "<br>"

    return s
    # return "fatto";


class DBConnection:
    def __init__(self, db_instance):
        self.db_engine = create_engine('postgresql://postgres:admin@localhost:5432/postgres')
        self.db_engine.connect()

    def read(self, statement):
        #Executes a read query and returns a list of dicts, whose keys are column names.
        data = self.db_engine.execute(statement).fetchall()
        results = []

        if len(data) == 0:
            return results

        # results from sqlalchemy are returned as a list of tuples; this procedure converts it into a list of dicts
        for row_number, row in enumerate(data):
            results.append({})
            for column_number, value in enumerate(row):
                results[row_number][row.keys()[column_number]] = value

        return results

def query_to_dict(ret):
    if ret is not None:
        return [{key: value for key, value in row.items()} for row in ret if row is not None]
    else:
        return [{}]

@app.route('/questions')
def questions():

    connection = engine.connect()
    surv = [100]
    quest = ""
    i = 0
    q = connection.execute("SELECT * FROM \"DBquestionario\".\"Survey\" WHERE id_survey=1;").fetchall()

    res = query_to_dict(q)

    return res[0]

    """
    for x in q:0
        quest += str(x)

    surv[i] = quest[1]
    id = surv[0]

    q = connection.execute("SELECT next FROM \"DBquestionario\".\"Question\" WHERE id_question = %s ", str(id))

    for x in q:
        quest += str(x)

    while True:
        q = connection.execute("SELECT next FROM \"DBquestionario\".\"Question\" WHERE id_question = %s ", str(id))
        for x in q:
            quest += str(x)
        if q is None:
            break
        i += 1
        print(quest)


    return quest

    """
