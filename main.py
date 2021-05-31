import datetime

import werkzeug.exceptions
import sqlalchemy.exc
from flask import Flask, render_template, redirect, url_for, request, make_response
from flask_login import LoginManager, UserMixin, current_user, login_required, login_user, logout_user
from sqlalchemy import create_engine
from validate_email import validate_email
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime

# set FLASK_ENV=development & set FLASK_APP=main.py & flask run

# TODO: improve private area (ANALYTICS SETTINGS and MyFillings)
# TODO: profile>my surveys>id change type number to icon

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


@app.route('/profile/mySurveys')
def mySurveys():
    if current_user.is_authenticated:
        connection = engine.connect()
        user_surveys = connection.execute('SELECT * FROM "DBquestionario"."Survey" WHERE creator=%s;', current_user.id)
        survey_id_list = []
        survey_title_list = []
        survey_question_numbers_list = []

        for srv in user_surveys:
            survey_id_list.append(srv.id_survey)
            survey_title_list.append(srv.title)
            questions_query = connection.execute('SELECT * FROM "DBquestionario"."Question" WHERE id_question=%s;',
                                                 srv.first_question).fetchone()
            n = 0
            while questions_query is not None:
                n = n + 1
                questions_query = connection.execute('SELECT * FROM "DBquestionario"."Question" WHERE id_question=%s;',
                                                     questions_query.next).fetchone()
            survey_question_numbers_list.append(n)
        return make_response(
            render_template('mySurveys.html', surveyIdList=survey_id_list,
                            surveyQuestionNumberList=survey_question_numbers_list,
                            surveyTitleList=survey_title_list,
                            user=current_user.user))
    else:
        return redirect(url_for('login'))


@app.route('/profile/mySurveys/<id>')
def my_survey(id=None):
    if current_user.is_authenticated:
        connection = engine.connect()
        survey_query = connection.execute('SELECT * FROM "DBquestionario"."Survey" WHERE id_survey=%s AND creator=%s;',
                                          id, current_user.id).fetchone()
        if survey_query is None:
            return render_template('mySurvey.html', title='SURVEY NOT FOUND')
        else:
            question_list = []
            questions_query = connection.execute('SELECT * FROM "DBquestionario"."Question" WHERE id_question=%s;',
                                                 survey_query.first_question).fetchone()
            while questions_query is not None:
                question_list.append(questions_query)
                questions_query = connection.execute('SELECT * FROM "DBquestionario"."Question" WHERE id_question=%s;',
                                                     questions_query.next).fetchone()
        return make_response(
            render_template('mySurvey.html', user=current_user.user, id=id, title=survey_query.title,
                            questionsList=question_list))
    else:
        return redirect(url_for('login'))


@app.route('/profile/analytics')
def analytics():
    if current_user.is_authenticated:
        connection = engine.connect()
        user_surveys = connection.execute('SELECT * FROM "DBquestionario"."Survey" WHERE creator=%s;', current_user.id)
        survey_id_list = []
        survey_title_list = []
        survey_fillings_number_list = []

        for srv in user_surveys:
            survey_id_list.append(srv.id_survey)
            survey_title_list.append(srv.title)
            fillings_query = connection.execute('SELECT * FROM "DBquestionario"."Filling" WHERE referred_survey=%s;',
                                                srv.id_survey)
            fillings_number = 0
            for f in fillings_query:
                fillings_number += 1
            survey_fillings_number_list.append(fillings_number)
        return make_response(
            render_template('analyticsSurveys.html', surveyIdList=survey_id_list,
                            surveyFillingsNumberList=survey_fillings_number_list,
                            surveyTitleList=survey_title_list,
                            user=current_user.user))
    else:
        return redirect(url_for('login'))


@app.route('/profile/analytics/<id>')
def analytic(id=None):
    if current_user.is_authenticated:
        connection = engine.connect()
        survey_query = connection.execute('SELECT * FROM "DBquestionario"."Survey" WHERE id_survey=%s AND creator=%s;',
                                          id, current_user.id).fetchone()
        if survey_query is None:
            return render_template('analytics.html', title='SURVEY NOT FOUND')
        else:
            fillings_query = connection.execute(
                'SELECT id_filling, username FROM "DBquestionario"."Filling" INNER JOIN "DBquestionario"."User" ON interviewed_user = id_user WHERE referred_survey=%s;',
                survey_query.id_survey)

        return make_response(
            render_template('analytics.html', user=current_user.user, id=id, title=survey_query.title,
                            fillingsList=fillings_query))
    else:
        return redirect(url_for('login'))


@app.route('/filling/<id>')
def filling(id=None):
    if current_user.is_authenticated:
        connection = engine.connect()

        filling_query = connection.execute(
            'SELECT id_filling, username, referred_survey FROM "DBquestionario"."Filling" INNER JOIN "DBquestionario"."User" ON interviewed_user = id_user WHERE id_filling=%s;',
            id).fetchone()

        if filling_query is None:
            return render_template('filling.html', title='FILLING NOT FOUND')
        else:
            n = 1
            s = ""
            answers_query = connection.execute(
                'SELECT * FROM "DBquestionario"."Answer" WHERE filling=%s;',
                id)
            for a in answers_query:
                s += str(n) + ")  ->  "
                qType = connection.execute('SELECT type FROM "DBquestionario"."Question" WHERE id_question=%s',
                                           a.referred_question).fetchone().type
                # SINGLE MULTIPLE
                if qType == 1:
                    s += connection.execute(
                        'SELECT text FROM "DBquestionario"."MultipleAnswer" INNER JOIN "DBquestionario"."Choice" ON choice = id_choice WHERE answer=%s',
                        a.id_answer).fetchone().text + "<br><br>"
                # MULTIPLE
                elif qType == 2:
                    answers = connection.execute(
                        'SELECT text FROM "DBquestionario"."MultipleAnswer" INNER JOIN "DBquestionario"."Choice" ON choice = id_choice WHERE answer=%s',
                        a.id_answer)
                    for answer in answers:
                        s += answer.text + ", "
                    s = s[:-2] + "<br><br>"
                # TEXT
                elif qType == 3:
                    s += connection.execute(
                        'SELECT text FROM "DBquestionario"."TextAnswer" WHERE answer=%s',
                        a.id_answer).fetchone().text + "<br><br>"
                # DATE
                elif qType == 4:
                    s += str(connection.execute(
                        'SELECT date FROM "DBquestionario"."DateAnswer" WHERE answer=%s',
                        a.id_answer).fetchone().date) + "<br><br>"
                # TIME
                elif qType == 5:
                    s += str(connection.execute(
                        'SELECT time FROM "DBquestionario"."TimeAnswer" WHERE answer=%s',
                        a.id_answer).fetchone().time) + "<br><br>"
                # RANGE
                elif qType == 6:
                    s += str(connection.execute(
                        'SELECT liking FROM "DBquestionario"."LikingAnswer" WHERE answer=%s',
                        a.id_answer).fetchone().liking) + "<br><br>"
                n += 1

        print(filling_query)
        return make_response(
            render_template('filling.html', user=current_user.user, id=id, surveyID=filling_query.referred_survey, title=filling_query.username,
                            compilation=s))
    else:
        return redirect(url_for('login'))


# ----------------- SURVEY CREATION  -----------------


@app.route('/createsurvey', methods=['GET', 'POST'])
def createsurvey():
    if current_user.is_authenticated:
        if request.method == 'POST':
            title = request.form['survey_title']
            question_number = int(request.form['questions_number'])
            questions_texts = []
            questions_types = []
            questions_options = []
            questions_options_number = []

            # GETTING FORMS INFO
            try:
                for i in range(1, question_number + 1):
                    questions_texts.append(request.form['question_text_' + str(i)])
                    questions_types.append(request.form['question_type_' + str(i)])
                    if (int(questions_types[i - 1]) == 1) or (int(questions_types[i - 1]) == 2):
                        options = []
                        questions_options_number.append(int(request.form['options_number_q' + str(i)]))
                        for j in range(1, questions_options_number[i - 1] + 1):
                            options.append(request.form['option_' + str(j) + '_q' + str(i)])
                        questions_options.append(options)
                    elif int(questions_types[i - 1]) == 6:
                        options = [request.form['min_q' + str(i)], request.form['max_q' + str(i)]]
                        questions_options.append(options)
                        questions_options_number.append(2)
                    else:
                        questions_options.append([])
                        questions_options_number.append(0)
            except werkzeug.exceptions.BadRequestKeyError:
                return make_response(
                    render_template('createsurvey.html', user=current_user.user, error="missing parameters"))

            # POPULATING DATABASE
            connection = engine.connect()
            last_id = None
            for i in range((question_number - 1), -1, -1):
                # inserting questions
                last_id = connection.execute(
                    'INSERT INTO "DBquestionario"."Question"(text,next,type) VALUES(%s,%s,%s) RETURNING id_question;',
                    questions_texts[i], last_id, questions_types[i]).fetchone()[0]
                if (int(questions_types[i]) == 1) or (int(questions_types[i]) == 2):
                    for j in range(0, questions_options_number[i]):
                        # inserting options
                        connection.execute(
                            'INSERT INTO "DBquestionario"."Choice"(text,referred_question) VALUES(%s,%s);',
                            questions_options[i][j], last_id)
                elif int(questions_types[i]) == 6:
                    connection.execute(
                        'INSERT INTO "DBquestionario"."Range"(min,max,referred_question) VALUES(%s,%s,%s);',
                        questions_options[i][0], questions_options[i][1], last_id)
            # inserting survey
            survey_id = connection.execute(
                'INSERT INTO "DBquestionario"."Survey"(title, creator, first_question) VALUES(%s,%s,%s) RETURNING id_survey;',
                title, current_user.id, last_id)
            return redirect(url_for('surveyCreated', surveyID=survey_id.fetchone().id_survey))
        else:
            return make_response(render_template('createsurvey.html', user=current_user.user))
    else:
        return redirect(url_for('login'))


@app.route('/surveyCreated')
def surveyCreated():
    return render_template('surveyCreated.html', surveyID=request.args['surveyID'], user=current_user.user)


# ----------------- SURVEY COMPILATION -----------------

@app.route('/survey/<id>')
def survey(id=None):
    if current_user.is_authenticated:
        connection = engine.connect()
        survey_query = connection.execute('SELECT * FROM "DBquestionario"."Survey" WHERE id_survey=%s;', id).fetchone()
        if survey_query is None:
            return render_template('survey.html', title='SURVEY NOT FOUND')
        else:
            questions_query = connection.execute('SELECT * FROM "DBquestionario"."Question" WHERE id_question=%s;',
                                                 survey_query.first_question).fetchone()
            n = 0
            while questions_query is not None:
                n = n + 1
                questions_query = connection.execute('SELECT * FROM "DBquestionario"."Question" WHERE id_question=%s;',
                                                     questions_query.next).fetchone()
            return render_template('survey.html', user=current_user.user, id=id, title=survey_query.title,
                                   questionNumber=n)
    else:
        return redirect(url_for('login'))


@app.route('/compile/<id>', methods=['GET', 'POST'])
def compile(id=None):
    if current_user.is_authenticated:
        connection = engine.connect()
        survey_query = connection.execute('SELECT * FROM "DBquestionario"."Survey" WHERE id_survey=%s;',
                                          id).fetchone()
        if survey_query is None:
            return render_template('compilesurvey.html', user=current_user.user, title='SURVEY NOT FOUND')
        else:
            questions_query = connection.execute('SELECT * FROM "DBquestionario"."Question" WHERE id_question=%s;',
                                                 survey_query.first_question).fetchone()
            if request.method == 'POST':
                n = 1
                s = ""
                now = datetime.now()
                filling_id = connection.execute(
                    'INSERT INTO "DBquestionario"."Filling"(interviewed_user, referred_survey, filling_date, filling_time) VALUES(%s,%s,%s,%s) RETURNING id_filling;',
                    current_user.id, id, now.strftime("%Y-%m-%d"), now.strftime("%H:%M:%S")).fetchone().id_filling
                s += "COMPILATION #" + str(filling_id) + "<br><br>"
                while questions_query is not None:
                    s += str(n) + ") -> "
                    answer_id = connection.execute(
                        'INSERT INTO "DBquestionario"."Answer"(filling, referred_question) VALUES(%s,%s) RETURNING id_answer;',
                        filling_id, questions_query.id_question).fetchone().id_answer
                    # SINGLE MULTIPLE
                    if questions_query.type == 1:
                        answer = request.form["group" + str(questions_query.id_question)]
                        s += connection.execute('SELECT text FROM "DBquestionario"."Choice" WHERE id_choice=%s;',
                                                answer).fetchone().text + "<br>"
                        connection.execute(
                            'INSERT INTO "DBquestionario"."MultipleAnswer"(choice, answer) VALUES(%s,%s)', answer,
                            answer_id)
                    # MULTIPLE
                    elif questions_query.type == 2:
                        answers = request.form.getlist("group" + str(questions_query.id_question))
                        for answer in answers:
                            s += connection.execute('SELECT text FROM "DBquestionario"."Choice" WHERE id_choice=%s;',
                                                    answer).fetchone().text + ", "
                            connection.execute(
                                'INSERT INTO "DBquestionario"."MultipleAnswer"(choice, answer) VALUES(%s,%s)', answer,
                                answer_id)
                        s = s[:-2] + "<br>"
                    # TEXT
                    elif questions_query.type == 3:
                        answer = request.form["textarea" + str(questions_query.id_question)]
                        connection.execute('INSERT INTO "DBquestionario"."TextAnswer"(answer, text) VALUES(%s,%s)',
                                           answer_id, answer)
                        s += answer + "<br>"
                    # DATE
                    elif questions_query.type == 4:
                        answer = request.form["date" + str(questions_query.id_question)]
                        connection.execute('INSERT INTO "DBquestionario"."DateAnswer"(answer, date) VALUES(%s,%s)',
                                           answer_id, answer)
                        s += answer + "<br>"
                    # TIME
                    elif questions_query.type == 5:
                        answer = request.form["time" + str(questions_query.id_question)]
                        connection.execute('INSERT INTO "DBquestionario"."TimeAnswer"(answer, time) VALUES(%s,%s)',
                                           answer_id, answer + ":00")
                        s += answer + "<br>"
                    # RANGE
                    elif questions_query.type == 6:
                        answer = request.form["range" + str(questions_query.id_question)]
                        connection.execute('INSERT INTO "DBquestionario"."LikingAnswer"(answer, liking) VALUES(%s,%s)',
                                           answer_id, answer)
                        s += answer + "<br>"

                    questions_query = connection.execute(
                        'SELECT * FROM "DBquestionario"."Question" WHERE id_question=%s;',
                        questions_query.next).fetchone()
                    n += 1
                    print(s)
                return redirect(url_for('compilationSubmitted', surveyID=id, compilation=s))
            else:
                question_list = []
                option_list = []
                while questions_query is not None:
                    question_list.append(questions_query)
                    if questions_query.type == 1 or questions_query.type == 2:
                        options_query = connection.execute(
                            'SELECT * FROM "DBquestionario"."Choice" WHERE referred_question=%s;',
                            questions_query.id_question).fetchall()
                        option_list.append(options_query)
                    elif questions_query.type == 6:
                        options_query = connection.execute(
                            'SELECT * FROM "DBquestionario"."Range" WHERE referred_question=%s;',
                            questions_query.id_question).fetchone()
                        option_list.append(options_query)
                    else:
                        option_list.append([])

                    questions_query = connection.execute(
                        'SELECT * FROM "DBquestionario"."Question" WHERE id_question=%s;',
                        questions_query.next).fetchone()
                return render_template('compilesurvey.html', user=current_user.user, id=id, title=survey_query.title,
                                       questionList=question_list,
                                       optionList=option_list)
    else:
        return redirect(url_for('login'))


@app.route('/compilationSubmitted')
def compilationSubmitted():
    return render_template('compilationSubmitted.html', surveyID=request.args['surveyID'], user=current_user.user,
                           compilation=request.args['compilation'])


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
