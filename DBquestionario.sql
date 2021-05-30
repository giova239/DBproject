--
-- PostgreSQL database dump
--

-- Dumped from database version 13.2
-- Dumped by pg_dump version 13.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DBquestionario; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "DBquestionario";


ALTER SCHEMA "DBquestionario" OWNER TO postgres;

--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Answer; Type: TABLE; Schema: DBquestionario; Owner: postgres
--

CREATE TABLE "DBquestionario"."Answer" (
    id_answer bigint NOT NULL,
    filling bigint NOT NULL,
    referred_question bigint NOT NULL
);


ALTER TABLE "DBquestionario"."Answer" OWNER TO postgres;

--
-- Name: AnswerType; Type: TABLE; Schema: DBquestionario; Owner: postgres
--

CREATE TABLE "DBquestionario"."AnswerType" (
    id_answer_type bigint NOT NULL,
    name text NOT NULL
);


ALTER TABLE "DBquestionario"."AnswerType" OWNER TO postgres;

--
-- Name: AnswerType_id_answer_type_seq; Type: SEQUENCE; Schema: DBquestionario; Owner: postgres
--

CREATE SEQUENCE "DBquestionario"."AnswerType_id_answer_type_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "DBquestionario"."AnswerType_id_answer_type_seq" OWNER TO postgres;

--
-- Name: AnswerType_id_answer_type_seq; Type: SEQUENCE OWNED BY; Schema: DBquestionario; Owner: postgres
--

ALTER SEQUENCE "DBquestionario"."AnswerType_id_answer_type_seq" OWNED BY "DBquestionario"."AnswerType".id_answer_type;


--
-- Name: Answer_id_answer_seq; Type: SEQUENCE; Schema: DBquestionario; Owner: postgres
--

CREATE SEQUENCE "DBquestionario"."Answer_id_answer_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "DBquestionario"."Answer_id_answer_seq" OWNER TO postgres;

--
-- Name: Answer_id_answer_seq; Type: SEQUENCE OWNED BY; Schema: DBquestionario; Owner: postgres
--

ALTER SEQUENCE "DBquestionario"."Answer_id_answer_seq" OWNED BY "DBquestionario"."Answer".id_answer;


--
-- Name: Choice; Type: TABLE; Schema: DBquestionario; Owner: postgres
--

CREATE TABLE "DBquestionario"."Choice" (
    id_choice bigint NOT NULL,
    text text NOT NULL,
    referred_question bigint NOT NULL
);


ALTER TABLE "DBquestionario"."Choice" OWNER TO postgres;

--
-- Name: Choice_id_choice_seq; Type: SEQUENCE; Schema: DBquestionario; Owner: postgres
--

CREATE SEQUENCE "DBquestionario"."Choice_id_choice_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "DBquestionario"."Choice_id_choice_seq" OWNER TO postgres;

--
-- Name: Choice_id_choice_seq; Type: SEQUENCE OWNED BY; Schema: DBquestionario; Owner: postgres
--

ALTER SEQUENCE "DBquestionario"."Choice_id_choice_seq" OWNED BY "DBquestionario"."Choice".id_choice;


--
-- Name: DateAnswer; Type: TABLE; Schema: DBquestionario; Owner: postgres
--

CREATE TABLE "DBquestionario"."DateAnswer" (
    answer bigint NOT NULL,
    date date NOT NULL
);


ALTER TABLE "DBquestionario"."DateAnswer" OWNER TO postgres;

--
-- Name: Filling; Type: TABLE; Schema: DBquestionario; Owner: postgres
--

CREATE TABLE "DBquestionario"."Filling" (
    id_filling bigint NOT NULL,
    interviewed_user bigint NOT NULL,
    referred_survey bigint NOT NULL,
    filling_date date NOT NULL,
    filling_time time without time zone NOT NULL
);


ALTER TABLE "DBquestionario"."Filling" OWNER TO postgres;

--
-- Name: Filling_id_filling_seq; Type: SEQUENCE; Schema: DBquestionario; Owner: postgres
--

CREATE SEQUENCE "DBquestionario"."Filling_id_filling_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "DBquestionario"."Filling_id_filling_seq" OWNER TO postgres;

--
-- Name: Filling_id_filling_seq; Type: SEQUENCE OWNED BY; Schema: DBquestionario; Owner: postgres
--

ALTER SEQUENCE "DBquestionario"."Filling_id_filling_seq" OWNED BY "DBquestionario"."Filling".id_filling;


--
-- Name: LikingAnswer; Type: TABLE; Schema: DBquestionario; Owner: postgres
--

CREATE TABLE "DBquestionario"."LikingAnswer" (
    answer bigint NOT NULL,
    liking integer NOT NULL
);


ALTER TABLE "DBquestionario"."LikingAnswer" OWNER TO postgres;

--
-- Name: MultipleAnswer; Type: TABLE; Schema: DBquestionario; Owner: postgres
--

CREATE TABLE "DBquestionario"."MultipleAnswer" (
    choice bigint NOT NULL,
    answer bigint NOT NULL
);


ALTER TABLE "DBquestionario"."MultipleAnswer" OWNER TO postgres;

--
-- Name: Question; Type: TABLE; Schema: DBquestionario; Owner: postgres
--

CREATE TABLE "DBquestionario"."Question" (
    id_question bigint NOT NULL,
    text text NOT NULL,
    next bigint,
    type bigint NOT NULL
);


ALTER TABLE "DBquestionario"."Question" OWNER TO postgres;

--
-- Name: Question_id_question_seq; Type: SEQUENCE; Schema: DBquestionario; Owner: postgres
--

CREATE SEQUENCE "DBquestionario"."Question_id_question_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "DBquestionario"."Question_id_question_seq" OWNER TO postgres;

--
-- Name: Question_id_question_seq; Type: SEQUENCE OWNED BY; Schema: DBquestionario; Owner: postgres
--

ALTER SEQUENCE "DBquestionario"."Question_id_question_seq" OWNED BY "DBquestionario"."Question".id_question;


--
-- Name: Range; Type: TABLE; Schema: DBquestionario; Owner: postgres
--

CREATE TABLE "DBquestionario"."Range" (
    id_range bigint NOT NULL,
    min integer NOT NULL,
    max integer NOT NULL,
    referred_question bigint NOT NULL
);


ALTER TABLE "DBquestionario"."Range" OWNER TO postgres;

--
-- Name: Range_id_range_seq; Type: SEQUENCE; Schema: DBquestionario; Owner: postgres
--

CREATE SEQUENCE "DBquestionario"."Range_id_range_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "DBquestionario"."Range_id_range_seq" OWNER TO postgres;

--
-- Name: Range_id_range_seq; Type: SEQUENCE OWNED BY; Schema: DBquestionario; Owner: postgres
--

ALTER SEQUENCE "DBquestionario"."Range_id_range_seq" OWNED BY "DBquestionario"."Range".id_range;


--
-- Name: Survey; Type: TABLE; Schema: DBquestionario; Owner: postgres
--

CREATE TABLE "DBquestionario"."Survey" (
    id_survey bigint NOT NULL,
    title text NOT NULL,
    creator bigint NOT NULL,
    first_question bigint NOT NULL
);


ALTER TABLE "DBquestionario"."Survey" OWNER TO postgres;

--
-- Name: Survey_id_survey_seq; Type: SEQUENCE; Schema: DBquestionario; Owner: postgres
--

CREATE SEQUENCE "DBquestionario"."Survey_id_survey_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "DBquestionario"."Survey_id_survey_seq" OWNER TO postgres;

--
-- Name: Survey_id_survey_seq; Type: SEQUENCE OWNED BY; Schema: DBquestionario; Owner: postgres
--

ALTER SEQUENCE "DBquestionario"."Survey_id_survey_seq" OWNED BY "DBquestionario"."Survey".id_survey;


--
-- Name: TextAnswer; Type: TABLE; Schema: DBquestionario; Owner: postgres
--

CREATE TABLE "DBquestionario"."TextAnswer" (
    answer bigint NOT NULL,
    text text NOT NULL
);


ALTER TABLE "DBquestionario"."TextAnswer" OWNER TO postgres;

--
-- Name: TimeAnswer; Type: TABLE; Schema: DBquestionario; Owner: postgres
--

CREATE TABLE "DBquestionario"."TimeAnswer" (
    answer bigint NOT NULL,
    "time" time with time zone NOT NULL
);


ALTER TABLE "DBquestionario"."TimeAnswer" OWNER TO postgres;

--
-- Name: User; Type: TABLE; Schema: DBquestionario; Owner: postgres
--

CREATE TABLE "DBquestionario"."User" (
    id_user bigint NOT NULL,
    username text NOT NULL,
    hashed_password text NOT NULL,
    email text NOT NULL,
    birth_date date NOT NULL
);


ALTER TABLE "DBquestionario"."User" OWNER TO postgres;

--
-- Name: Utente_id_user_seq; Type: SEQUENCE; Schema: DBquestionario; Owner: postgres
--

CREATE SEQUENCE "DBquestionario"."Utente_id_user_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "DBquestionario"."Utente_id_user_seq" OWNER TO postgres;

--
-- Name: Utente_id_user_seq; Type: SEQUENCE OWNED BY; Schema: DBquestionario; Owner: postgres
--

ALTER SEQUENCE "DBquestionario"."Utente_id_user_seq" OWNED BY "DBquestionario"."User".id_user;


--
-- Name: Answer id_answer; Type: DEFAULT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Answer" ALTER COLUMN id_answer SET DEFAULT nextval('"DBquestionario"."Answer_id_answer_seq"'::regclass);


--
-- Name: AnswerType id_answer_type; Type: DEFAULT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."AnswerType" ALTER COLUMN id_answer_type SET DEFAULT nextval('"DBquestionario"."AnswerType_id_answer_type_seq"'::regclass);


--
-- Name: Choice id_choice; Type: DEFAULT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Choice" ALTER COLUMN id_choice SET DEFAULT nextval('"DBquestionario"."Choice_id_choice_seq"'::regclass);


--
-- Name: Filling id_filling; Type: DEFAULT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Filling" ALTER COLUMN id_filling SET DEFAULT nextval('"DBquestionario"."Filling_id_filling_seq"'::regclass);


--
-- Name: Question id_question; Type: DEFAULT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Question" ALTER COLUMN id_question SET DEFAULT nextval('"DBquestionario"."Question_id_question_seq"'::regclass);


--
-- Name: Range id_range; Type: DEFAULT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Range" ALTER COLUMN id_range SET DEFAULT nextval('"DBquestionario"."Range_id_range_seq"'::regclass);


--
-- Name: Survey id_survey; Type: DEFAULT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Survey" ALTER COLUMN id_survey SET DEFAULT nextval('"DBquestionario"."Survey_id_survey_seq"'::regclass);


--
-- Name: User id_user; Type: DEFAULT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."User" ALTER COLUMN id_user SET DEFAULT nextval('"DBquestionario"."Utente_id_user_seq"'::regclass);


--
-- Data for Name: Answer; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--

COPY "DBquestionario"."Answer" (id_answer, filling, referred_question) FROM stdin;
42	18	6
43	18	5
44	18	4
45	18	3
46	18	2
47	18	1
\.


--
-- Data for Name: AnswerType; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--

COPY "DBquestionario"."AnswerType" (id_answer_type, name) FROM stdin;
1	Multiple answer (One selectable option)
2	Multiple answer (Multiple selectable options)
3	Text answer
4	Date answer
5	Time answer
6	Liking answer
\.


--
-- Data for Name: Choice; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--

COPY "DBquestionario"."Choice" (id_choice, text, referred_question) FROM stdin;
1	opzione di prova 2.1	5
2	opzione di prova 2.2	5
3	opzione di prova 2.3	5
4	opzione di prova 2.4	5
5	opzione di prova 1.1	6
6	opzione di prova 1.2	6
7	opzione di prova 1.3	6
8	opzione di prova 1.4	6
9	bru	11
10	bru2	11
11	bru	14
12	bru2	14
13	o1	16
14	rty	16
15	opzione di prova 1.3	16
16	opt1	18
17	opt2	18
18	opt3	18
19	awf	20
20	vero	22
21	falso	22
22	lol	24
23	sos	24
24	sosos	24
25	awdawd	24
26	awd	24
27	gay	26
28	frocio	26
29	ricchione	26
30	sos	30
31	sus	30
32	prova	33
33	lol	33
34	1	35
35	2	35
36	3	35
37	1	36
38	2	36
39	3	36
40	1	37
41	2	37
42	3	37
\.


--
-- Data for Name: DateAnswer; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--

COPY "DBquestionario"."DateAnswer" (answer, date) FROM stdin;
45	2021-05-30
\.


--
-- Data for Name: Filling; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--

COPY "DBquestionario"."Filling" (id_filling, interviewed_user, referred_survey, filling_date, filling_time) FROM stdin;
18	10	1	2021-05-30	23:07:09
\.


--
-- Data for Name: LikingAnswer; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--

COPY "DBquestionario"."LikingAnswer" (answer, liking) FROM stdin;
47	8
\.


--
-- Data for Name: MultipleAnswer; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--

COPY "DBquestionario"."MultipleAnswer" (choice, answer) FROM stdin;
5	42
2	43
4	43
\.


--
-- Data for Name: Question; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--

COPY "DBquestionario"."Question" (id_question, text, next, type) FROM stdin;
1	domanda di prova 6	\N	6
2	domanda di prova 5	1	5
3	domanda di prova 4	2	4
4	domanda di prova 3	3	3
5	domanda di prova 2	4	2
6	domanda di prova 1	5	1
7	seconda domanda	\N	4
8	prima domanda	7	3
9	ciaociao	\N	6
10	ciaooone	9	5
11	ciaoooo	10	1
12	ciaociao	\N	6
13	ciaooone	12	5
14	ciaoooo	13	1
15	cista	\N	4
16	lol	15	1
17	ciao	\N	3
18	opzioni	\N	2
19	lol	18	6
20	awfawf	\N	2
21	quanto sono belle le fabie da 1 a 10	\N	6
22	ti chiami fabio	21	1
23	provetta	\N	6
24	provona	23	1
25	perchè?	\N	3
26	fabio  é?	25	1
27	11	\N	3
28	sasso	\N	4
29	lal	\N	6
30	ciau	29	2
31	oki	\N	5
32	lol	31	4
33	prova	32	1
34	speremo	\N	6
35	q	34	1
36	prova2	\N	1
37	prova1	36	1
\.


--
-- Data for Name: Range; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--

COPY "DBquestionario"."Range" (id_range, min, max, referred_question) FROM stdin;
1	0	10	1
2	2	7	9
3	2	7	12
4	0	10	19
5	1	10	21
6	5	17	23
7	6	7	29
8	2	1	34
\.


--
-- Data for Name: Survey; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--

COPY "DBquestionario"."Survey" (id_survey, title, creator, first_question) FROM stdin;
1	questionario di prova	10	6
2	questionario 2	11	8
3	proviamo	11	11
4	proviamo	11	14
5	proviamo ancora dc	11	16
6	lol	11	17
7	prova2	10	19
8	poro,foa,kwf	10	20
9	questionario di fabio	10	22
10	lalalalalalalalalal	10	24
11	prova	10	26
12	lol11	10	27
13	provola	10	28
14	provalla	10	30
15	prova	10	33
16	funzia	10	35
17	typ1 conflict	10	37
\.


--
-- Data for Name: TextAnswer; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--

COPY "DBquestionario"."TextAnswer" (answer, text) FROM stdin;
44	risposta di prova alla domanda 3
\.


--
-- Data for Name: TimeAnswer; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--

COPY "DBquestionario"."TimeAnswer" (answer, "time") FROM stdin;
46	23:05:00+02
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--

COPY "DBquestionario"."User" (id_user, username, hashed_password, email, birth_date) FROM stdin;
10	admin	pbkdf2:sha256:150000$HG5XG7mr$e173d32b07cabd0362dbdf6395722fe391a9321093375aad115c5844696426be	stevanay@gmail.com	2000-09-23
11	prova	pbkdf2:sha256:150000$u3jsQ4a2$103e0c53b3995a6fae5fb8dde4116ce4b153a582825b79635322724581e1c705	prova@gmail.ru	1997-12-12
\.


--
-- Name: AnswerType_id_answer_type_seq; Type: SEQUENCE SET; Schema: DBquestionario; Owner: postgres
--

SELECT pg_catalog.setval('"DBquestionario"."AnswerType_id_answer_type_seq"', 6, true);


--
-- Name: Answer_id_answer_seq; Type: SEQUENCE SET; Schema: DBquestionario; Owner: postgres
--

SELECT pg_catalog.setval('"DBquestionario"."Answer_id_answer_seq"', 47, true);


--
-- Name: Choice_id_choice_seq; Type: SEQUENCE SET; Schema: DBquestionario; Owner: postgres
--

SELECT pg_catalog.setval('"DBquestionario"."Choice_id_choice_seq"', 42, true);


--
-- Name: Filling_id_filling_seq; Type: SEQUENCE SET; Schema: DBquestionario; Owner: postgres
--

SELECT pg_catalog.setval('"DBquestionario"."Filling_id_filling_seq"', 18, true);


--
-- Name: Question_id_question_seq; Type: SEQUENCE SET; Schema: DBquestionario; Owner: postgres
--

SELECT pg_catalog.setval('"DBquestionario"."Question_id_question_seq"', 37, true);


--
-- Name: Range_id_range_seq; Type: SEQUENCE SET; Schema: DBquestionario; Owner: postgres
--

SELECT pg_catalog.setval('"DBquestionario"."Range_id_range_seq"', 8, true);


--
-- Name: Survey_id_survey_seq; Type: SEQUENCE SET; Schema: DBquestionario; Owner: postgres
--

SELECT pg_catalog.setval('"DBquestionario"."Survey_id_survey_seq"', 17, true);


--
-- Name: Utente_id_user_seq; Type: SEQUENCE SET; Schema: DBquestionario; Owner: postgres
--

SELECT pg_catalog.setval('"DBquestionario"."Utente_id_user_seq"', 11, true);


--
-- Name: AnswerType AnswerType_pkey; Type: CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."AnswerType"
    ADD CONSTRAINT "AnswerType_pkey" PRIMARY KEY (id_answer_type);


--
-- Name: Answer Answer_pkey; Type: CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Answer"
    ADD CONSTRAINT "Answer_pkey" PRIMARY KEY (id_answer);


--
-- Name: MultipleAnswer Choice_MultipleAnswer_pkey; Type: CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."MultipleAnswer"
    ADD CONSTRAINT "Choice_MultipleAnswer_pkey" PRIMARY KEY (choice, answer);


--
-- Name: Choice Choice_pkey; Type: CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Choice"
    ADD CONSTRAINT "Choice_pkey" PRIMARY KEY (id_choice);


--
-- Name: DateAnswer DateAnswer_pkey; Type: CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."DateAnswer"
    ADD CONSTRAINT "DateAnswer_pkey" PRIMARY KEY (answer);


--
-- Name: Filling Filling_pkey; Type: CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Filling"
    ADD CONSTRAINT "Filling_pkey" PRIMARY KEY (id_filling);


--
-- Name: LikingAnswer LikingAnswer_pkey; Type: CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."LikingAnswer"
    ADD CONSTRAINT "LikingAnswer_pkey" PRIMARY KEY (answer);


--
-- Name: Question Question_pkey; Type: CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Question"
    ADD CONSTRAINT "Question_pkey" PRIMARY KEY (id_question);


--
-- Name: Range Range_pkey; Type: CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Range"
    ADD CONSTRAINT "Range_pkey" PRIMARY KEY (id_range);


--
-- Name: Survey Survey_pkey; Type: CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Survey"
    ADD CONSTRAINT "Survey_pkey" PRIMARY KEY (id_survey);


--
-- Name: TextAnswer TextAnswer_pkey; Type: CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."TextAnswer"
    ADD CONSTRAINT "TextAnswer_pkey" PRIMARY KEY (answer);


--
-- Name: TimeAnswer TimeAnswer_pkey; Type: CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."TimeAnswer"
    ADD CONSTRAINT "TimeAnswer_pkey" PRIMARY KEY (answer);


--
-- Name: User Utente_pkey; Type: CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."User"
    ADD CONSTRAINT "Utente_pkey" PRIMARY KEY (id_user);


--
-- Name: Answer Answer_filling_fkey; Type: FK CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Answer"
    ADD CONSTRAINT "Answer_filling_fkey" FOREIGN KEY (filling) REFERENCES "DBquestionario"."Filling"(id_filling);


--
-- Name: Answer Answer_referred_question_fkey; Type: FK CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Answer"
    ADD CONSTRAINT "Answer_referred_question_fkey" FOREIGN KEY (referred_question) REFERENCES "DBquestionario"."Question"(id_question);


--
-- Name: MultipleAnswer Choice_MultipleAnswer_answer_fkey; Type: FK CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."MultipleAnswer"
    ADD CONSTRAINT "Choice_MultipleAnswer_answer_fkey" FOREIGN KEY (answer) REFERENCES "DBquestionario"."Answer"(id_answer);


--
-- Name: MultipleAnswer Choice_MultipleAnswer_choice_fkey; Type: FK CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."MultipleAnswer"
    ADD CONSTRAINT "Choice_MultipleAnswer_choice_fkey" FOREIGN KEY (choice) REFERENCES "DBquestionario"."Choice"(id_choice);


--
-- Name: Choice Choice_referred_question_fkey; Type: FK CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Choice"
    ADD CONSTRAINT "Choice_referred_question_fkey" FOREIGN KEY (referred_question) REFERENCES "DBquestionario"."Question"(id_question);


--
-- Name: DateAnswer DateAnswer_answer_fkey; Type: FK CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."DateAnswer"
    ADD CONSTRAINT "DateAnswer_answer_fkey" FOREIGN KEY (answer) REFERENCES "DBquestionario"."Answer"(id_answer);


--
-- Name: Filling Filling_interviewed_user_fkey; Type: FK CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Filling"
    ADD CONSTRAINT "Filling_interviewed_user_fkey" FOREIGN KEY (interviewed_user) REFERENCES "DBquestionario"."User"(id_user);


--
-- Name: Filling Filling_referred_survey_fkey; Type: FK CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Filling"
    ADD CONSTRAINT "Filling_referred_survey_fkey" FOREIGN KEY (referred_survey) REFERENCES "DBquestionario"."Survey"(id_survey);


--
-- Name: LikingAnswer LikingAnswer_answer_fkey; Type: FK CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."LikingAnswer"
    ADD CONSTRAINT "LikingAnswer_answer_fkey" FOREIGN KEY (answer) REFERENCES "DBquestionario"."Answer"(id_answer);


--
-- Name: Question Question_next_fkey; Type: FK CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Question"
    ADD CONSTRAINT "Question_next_fkey" FOREIGN KEY (next) REFERENCES "DBquestionario"."Question"(id_question);


--
-- Name: Question Question_type_fkey; Type: FK CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Question"
    ADD CONSTRAINT "Question_type_fkey" FOREIGN KEY (type) REFERENCES "DBquestionario"."AnswerType"(id_answer_type);


--
-- Name: Range Range_referred_question_fkey; Type: FK CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Range"
    ADD CONSTRAINT "Range_referred_question_fkey" FOREIGN KEY (referred_question) REFERENCES "DBquestionario"."Question"(id_question);


--
-- Name: Survey Survey_creator_fkey; Type: FK CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Survey"
    ADD CONSTRAINT "Survey_creator_fkey" FOREIGN KEY (creator) REFERENCES "DBquestionario"."User"(id_user);


--
-- Name: Survey Survey_first_question_fkey; Type: FK CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Survey"
    ADD CONSTRAINT "Survey_first_question_fkey" FOREIGN KEY (first_question) REFERENCES "DBquestionario"."Question"(id_question);


--
-- Name: TextAnswer TextAnswer_answer_fkey; Type: FK CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."TextAnswer"
    ADD CONSTRAINT "TextAnswer_answer_fkey" FOREIGN KEY (answer) REFERENCES "DBquestionario"."Answer"(id_answer);


--
-- Name: TimeAnswer TimeAnswer_asnwer_fkey; Type: FK CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."TimeAnswer"
    ADD CONSTRAINT "TimeAnswer_asnwer_fkey" FOREIGN KEY (answer) REFERENCES "DBquestionario"."Answer"(id_answer);


--
-- PostgreSQL database dump complete
--

