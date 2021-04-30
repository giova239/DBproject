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
-- Name: Choice_MultipleAnswer; Type: TABLE; Schema: DBquestionario; Owner: postgres
--

CREATE TABLE "DBquestionario"."Choice_MultipleAnswer" (
    choice bigint NOT NULL,
    answer bigint NOT NULL
);


ALTER TABLE "DBquestionario"."Choice_MultipleAnswer" OWNER TO postgres;

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
    asnwer bigint NOT NULL,
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



--
-- Data for Name: AnswerType; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--

INSERT INTO "DBquestionario"."AnswerType" VALUES (1, 'Multiple answer (One selectable option)');
INSERT INTO "DBquestionario"."AnswerType" VALUES (2, 'Multiple answer (Multiple selectable options)');
INSERT INTO "DBquestionario"."AnswerType" VALUES (3, 'Text answer');
INSERT INTO "DBquestionario"."AnswerType" VALUES (4, 'Date answer');
INSERT INTO "DBquestionario"."AnswerType" VALUES (5, 'Time answer');
INSERT INTO "DBquestionario"."AnswerType" VALUES (6, 'Liking answer');


--
-- Data for Name: Choice; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--



--
-- Data for Name: Choice_MultipleAnswer; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--



--
-- Data for Name: DateAnswer; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--



--
-- Data for Name: Filling; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--



--
-- Data for Name: LikingAnswer; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--



--
-- Data for Name: MultipleAnswer; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--



--
-- Data for Name: Question; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--



--
-- Data for Name: Range; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--



--
-- Data for Name: Survey; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--



--
-- Data for Name: TextAnswer; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--



--
-- Data for Name: TimeAnswer; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--



--
-- Data for Name: User; Type: TABLE DATA; Schema: DBquestionario; Owner: postgres
--

INSERT INTO "DBquestionario"."User" VALUES (10, 'admin', 'pbkdf2:sha256:150000$HG5XG7mr$e173d32b07cabd0362dbdf6395722fe391a9321093375aad115c5844696426be', 'stevanay@gmail.com', '2000-09-23');


--
-- Name: AnswerType_id_answer_type_seq; Type: SEQUENCE SET; Schema: DBquestionario; Owner: postgres
--

SELECT pg_catalog.setval('"DBquestionario"."AnswerType_id_answer_type_seq"', 6, true);


--
-- Name: Answer_id_answer_seq; Type: SEQUENCE SET; Schema: DBquestionario; Owner: postgres
--

SELECT pg_catalog.setval('"DBquestionario"."Answer_id_answer_seq"', 1, false);


--
-- Name: Choice_id_choice_seq; Type: SEQUENCE SET; Schema: DBquestionario; Owner: postgres
--

SELECT pg_catalog.setval('"DBquestionario"."Choice_id_choice_seq"', 1, false);


--
-- Name: Filling_id_filling_seq; Type: SEQUENCE SET; Schema: DBquestionario; Owner: postgres
--

SELECT pg_catalog.setval('"DBquestionario"."Filling_id_filling_seq"', 1, false);


--
-- Name: Question_id_question_seq; Type: SEQUENCE SET; Schema: DBquestionario; Owner: postgres
--

SELECT pg_catalog.setval('"DBquestionario"."Question_id_question_seq"', 1, false);


--
-- Name: Range_id_range_seq; Type: SEQUENCE SET; Schema: DBquestionario; Owner: postgres
--

SELECT pg_catalog.setval('"DBquestionario"."Range_id_range_seq"', 1, false);


--
-- Name: Survey_id_survey_seq; Type: SEQUENCE SET; Schema: DBquestionario; Owner: postgres
--

SELECT pg_catalog.setval('"DBquestionario"."Survey_id_survey_seq"', 1, false);


--
-- Name: Utente_id_user_seq; Type: SEQUENCE SET; Schema: DBquestionario; Owner: postgres
--

SELECT pg_catalog.setval('"DBquestionario"."Utente_id_user_seq"', 10, true);


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
-- Name: Choice_MultipleAnswer Choice_MultipleAnswer_pkey; Type: CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Choice_MultipleAnswer"
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
-- Name: MultipleAnswer MultipleAnswer_pkey; Type: CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."MultipleAnswer"
    ADD CONSTRAINT "MultipleAnswer_pkey" PRIMARY KEY (answer);


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
    ADD CONSTRAINT "TimeAnswer_pkey" PRIMARY KEY (asnwer);


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
-- Name: Choice_MultipleAnswer Choice_MultipleAnswer_answer_fkey; Type: FK CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Choice_MultipleAnswer"
    ADD CONSTRAINT "Choice_MultipleAnswer_answer_fkey" FOREIGN KEY (answer) REFERENCES "DBquestionario"."Answer"(id_answer);


--
-- Name: Choice_MultipleAnswer Choice_MultipleAnswer_choice_fkey; Type: FK CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."Choice_MultipleAnswer"
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
-- Name: MultipleAnswer MultipleAnswer_answer_fkey; Type: FK CONSTRAINT; Schema: DBquestionario; Owner: postgres
--

ALTER TABLE ONLY "DBquestionario"."MultipleAnswer"
    ADD CONSTRAINT "MultipleAnswer_answer_fkey" FOREIGN KEY (answer) REFERENCES "DBquestionario"."Answer"(id_answer);


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
    ADD CONSTRAINT "TimeAnswer_asnwer_fkey" FOREIGN KEY (asnwer) REFERENCES "DBquestionario"."Answer"(id_answer);


--
-- PostgreSQL database dump complete
--

