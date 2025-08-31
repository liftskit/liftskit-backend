--
-- PostgreSQL database dump
--

-- Dumped from database version 14.18 (Homebrew)
-- Dumped by pg_dump version 14.18 (Homebrew)

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
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: exercise_performed; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exercise_performed (
    id bigint NOT NULL,
    _type character varying(255),
    name character varying(255),
    reps integer,
    sets integer,
    "time" integer,
    weight integer,
    workout_performed_id bigint NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: exercise_performed_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exercise_performed_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exercise_performed_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exercise_performed_id_seq OWNED BY public.exercise_performed.id;


--
-- Name: exercise_roots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exercise_roots (
    id bigint NOT NULL,
    name character varying(255),
    _type character varying(255),
    user_id bigint NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: exercise_roots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exercise_roots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exercise_roots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exercise_roots_id_seq OWNED BY public.exercise_roots.id;


--
-- Name: exercise_supersets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exercise_supersets (
    id bigint NOT NULL,
    exercise_id bigint NOT NULL,
    superset_exercise_id bigint NOT NULL,
    "order" integer,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: exercise_supersets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exercise_supersets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exercise_supersets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exercise_supersets_id_seq OWNED BY public.exercise_supersets.id;


--
-- Name: exercises; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exercises (
    id bigint NOT NULL,
    orm_percent numeric,
    reps integer,
    sets integer,
    "time" character varying(255),
    weight integer,
    is_superset boolean DEFAULT false NOT NULL,
    workout_id bigint NOT NULL,
    exercise_root_id bigint NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: exercises_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exercises_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exercises_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exercises_id_seq OWNED BY public.exercises.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.messages (
    id bigint NOT NULL,
    body character varying(255),
    created timestamp(0) without time zone,
    from_user_id bigint,
    to_user_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- Name: official_exercises; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.official_exercises (
    id bigint NOT NULL,
    name character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: official_exercises_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.official_exercises_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: official_exercises_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.official_exercises_id_seq OWNED BY public.official_exercises.id;


--
-- Name: one_rep_max; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.one_rep_max (
    id bigint NOT NULL,
    exercise_name character varying(255),
    one_rep_max integer,
    user_id bigint NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: one_rep_max_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.one_rep_max_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: one_rep_max_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.one_rep_max_id_seq OWNED BY public.one_rep_max.id;


--
-- Name: programs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.programs (
    id bigint NOT NULL,
    name character varying(255),
    description character varying(255),
    user_id bigint NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: programs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.programs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: programs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.programs_id_seq OWNED BY public.programs.id;


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rooms (
    id bigint NOT NULL,
    name character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rooms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rooms_id_seq OWNED BY public.rooms.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    name character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username character varying(255),
    email public.citext NOT NULL,
    hashed_password character varying(255),
    confirmed_at timestamp(0) without time zone,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: users_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_tokens (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    token bytea NOT NULL,
    context character varying(255) NOT NULL,
    sent_to character varying(255),
    authenticated_at timestamp(0) without time zone,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: users_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_tokens_id_seq OWNED BY public.users_tokens.id;


--
-- Name: workouts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workouts (
    id bigint NOT NULL,
    name character varying(255),
    best_workout_time character varying(255),
    program_id bigint NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: workouts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workouts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workouts_id_seq OWNED BY public.workouts.id;


--
-- Name: workouts_performed; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workouts_performed (
    id bigint NOT NULL,
    program_name character varying(255),
    workout_date timestamp(0) without time zone,
    workout_time integer,
    workout_name character varying(255),
    user_id bigint NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: workouts_performed_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workouts_performed_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workouts_performed_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workouts_performed_id_seq OWNED BY public.workouts_performed.id;


--
-- Name: exercise_performed id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercise_performed ALTER COLUMN id SET DEFAULT nextval('public.exercise_performed_id_seq'::regclass);


--
-- Name: exercise_roots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercise_roots ALTER COLUMN id SET DEFAULT nextval('public.exercise_roots_id_seq'::regclass);


--
-- Name: exercise_supersets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercise_supersets ALTER COLUMN id SET DEFAULT nextval('public.exercise_supersets_id_seq'::regclass);


--
-- Name: exercises id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercises ALTER COLUMN id SET DEFAULT nextval('public.exercises_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: official_exercises id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.official_exercises ALTER COLUMN id SET DEFAULT nextval('public.official_exercises_id_seq'::regclass);


--
-- Name: one_rep_max id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.one_rep_max ALTER COLUMN id SET DEFAULT nextval('public.one_rep_max_id_seq'::regclass);


--
-- Name: programs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programs ALTER COLUMN id SET DEFAULT nextval('public.programs_id_seq'::regclass);


--
-- Name: rooms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms ALTER COLUMN id SET DEFAULT nextval('public.rooms_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: users_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_tokens ALTER COLUMN id SET DEFAULT nextval('public.users_tokens_id_seq'::regclass);


--
-- Name: workouts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workouts ALTER COLUMN id SET DEFAULT nextval('public.workouts_id_seq'::regclass);


--
-- Name: workouts_performed id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workouts_performed ALTER COLUMN id SET DEFAULT nextval('public.workouts_performed_id_seq'::regclass);


--
-- Name: exercise_performed exercise_performed_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercise_performed
    ADD CONSTRAINT exercise_performed_pkey PRIMARY KEY (id);


--
-- Name: exercise_roots exercise_roots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercise_roots
    ADD CONSTRAINT exercise_roots_pkey PRIMARY KEY (id);


--
-- Name: exercise_supersets exercise_supersets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercise_supersets
    ADD CONSTRAINT exercise_supersets_pkey PRIMARY KEY (id);


--
-- Name: exercises exercises_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT exercises_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: official_exercises official_exercises_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.official_exercises
    ADD CONSTRAINT official_exercises_pkey PRIMARY KEY (id);


--
-- Name: one_rep_max one_rep_max_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.one_rep_max
    ADD CONSTRAINT one_rep_max_pkey PRIMARY KEY (id);


--
-- Name: programs programs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programs
    ADD CONSTRAINT programs_pkey PRIMARY KEY (id);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_tokens users_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_tokens
    ADD CONSTRAINT users_tokens_pkey PRIMARY KEY (id);


--
-- Name: workouts_performed workouts_performed_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workouts_performed
    ADD CONSTRAINT workouts_performed_pkey PRIMARY KEY (id);


--
-- Name: workouts workouts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workouts
    ADD CONSTRAINT workouts_pkey PRIMARY KEY (id);


--
-- Name: exercise_performed_workout_performed_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX exercise_performed_workout_performed_id_index ON public.exercise_performed USING btree (workout_performed_id);


--
-- Name: exercise_roots_name_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX exercise_roots_name_user_id_index ON public.exercise_roots USING btree (name, user_id);


--
-- Name: exercise_roots_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX exercise_roots_user_id_index ON public.exercise_roots USING btree (user_id);


--
-- Name: exercise_supersets_exercise_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX exercise_supersets_exercise_id_index ON public.exercise_supersets USING btree (exercise_id);


--
-- Name: exercise_supersets_exercise_id_superset_exercise_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX exercise_supersets_exercise_id_superset_exercise_id_index ON public.exercise_supersets USING btree (exercise_id, superset_exercise_id);


--
-- Name: exercise_supersets_superset_exercise_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX exercise_supersets_superset_exercise_id_index ON public.exercise_supersets USING btree (superset_exercise_id);


--
-- Name: exercises_exercise_root_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX exercises_exercise_root_id_index ON public.exercises USING btree (exercise_root_id);


--
-- Name: exercises_workout_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX exercises_workout_id_index ON public.exercises USING btree (workout_id);


--
-- Name: messages_from_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX messages_from_user_id_index ON public.messages USING btree (from_user_id);


--
-- Name: messages_to_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX messages_to_user_id_index ON public.messages USING btree (to_user_id);


--
-- Name: official_exercises_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX official_exercises_name_index ON public.official_exercises USING btree (name);


--
-- Name: one_rep_max_exercise_name_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX one_rep_max_exercise_name_user_id_index ON public.one_rep_max USING btree (exercise_name, user_id);


--
-- Name: one_rep_max_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX one_rep_max_user_id_index ON public.one_rep_max USING btree (user_id);


--
-- Name: programs_name_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX programs_name_user_id_index ON public.programs USING btree (name, user_id);


--
-- Name: programs_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX programs_user_id_index ON public.programs USING btree (user_id);


--
-- Name: rooms_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX rooms_name_index ON public.rooms USING btree (name);


--
-- Name: tags_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX tags_name_index ON public.tags USING btree (name);


--
-- Name: users_email_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_email_index ON public.users USING btree (email);


--
-- Name: users_tokens_context_token_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_tokens_context_token_index ON public.users_tokens USING btree (context, token);


--
-- Name: users_tokens_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_tokens_user_id_index ON public.users_tokens USING btree (user_id);


--
-- Name: users_username_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_username_index ON public.users USING btree (username);


--
-- Name: workouts_performed_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX workouts_performed_user_id_index ON public.workouts_performed USING btree (user_id);


--
-- Name: workouts_program_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX workouts_program_id_index ON public.workouts USING btree (program_id);


--
-- Name: exercise_performed exercise_performed_workout_performed_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercise_performed
    ADD CONSTRAINT exercise_performed_workout_performed_id_fkey FOREIGN KEY (workout_performed_id) REFERENCES public.workouts_performed(id) ON DELETE CASCADE;


--
-- Name: exercise_roots exercise_roots_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercise_roots
    ADD CONSTRAINT exercise_roots_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: exercise_supersets exercise_supersets_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercise_supersets
    ADD CONSTRAINT exercise_supersets_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercises(id) ON DELETE CASCADE;


--
-- Name: exercise_supersets exercise_supersets_superset_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercise_supersets
    ADD CONSTRAINT exercise_supersets_superset_exercise_id_fkey FOREIGN KEY (superset_exercise_id) REFERENCES public.exercises(id) ON DELETE CASCADE;


--
-- Name: exercises exercises_exercise_root_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT exercises_exercise_root_id_fkey FOREIGN KEY (exercise_root_id) REFERENCES public.exercise_roots(id) ON DELETE CASCADE;


--
-- Name: exercises exercises_workout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT exercises_workout_id_fkey FOREIGN KEY (workout_id) REFERENCES public.workouts(id) ON DELETE CASCADE;


--
-- Name: messages messages_from_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_from_user_id_fkey FOREIGN KEY (from_user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: messages messages_to_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_to_user_id_fkey FOREIGN KEY (to_user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: one_rep_max one_rep_max_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.one_rep_max
    ADD CONSTRAINT one_rep_max_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: programs programs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programs
    ADD CONSTRAINT programs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users_tokens users_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_tokens
    ADD CONSTRAINT users_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: workouts_performed workouts_performed_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workouts_performed
    ADD CONSTRAINT workouts_performed_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: workouts workouts_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workouts
    ADD CONSTRAINT workouts_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.programs(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20250819041202);
INSERT INTO public."schema_migrations" (version) VALUES (20250819042715);
INSERT INTO public."schema_migrations" (version) VALUES (20250821005036);
INSERT INTO public."schema_migrations" (version) VALUES (20250821005413);
INSERT INTO public."schema_migrations" (version) VALUES (20250821005703);
INSERT INTO public."schema_migrations" (version) VALUES (20250821013056);
INSERT INTO public."schema_migrations" (version) VALUES (20250823234724);
INSERT INTO public."schema_migrations" (version) VALUES (20250823235904);
INSERT INTO public."schema_migrations" (version) VALUES (20250824004435);
INSERT INTO public."schema_migrations" (version) VALUES (20250824005004);
INSERT INTO public."schema_migrations" (version) VALUES (20250824010339);
INSERT INTO public."schema_migrations" (version) VALUES (20250824012228);
INSERT INTO public."schema_migrations" (version) VALUES (20250824021933);
INSERT INTO public."schema_migrations" (version) VALUES (20250824050225);
INSERT INTO public."schema_migrations" (version) VALUES (20250824054657);
INSERT INTO public."schema_migrations" (version) VALUES (20250824061712);
INSERT INTO public."schema_migrations" (version) VALUES (20250824071137);
INSERT INTO public."schema_migrations" (version) VALUES (20250824071627);
INSERT INTO public."schema_migrations" (version) VALUES (20250824071713);
INSERT INTO public."schema_migrations" (version) VALUES (20250824072427);
INSERT INTO public."schema_migrations" (version) VALUES (20250824074336);
INSERT INTO public."schema_migrations" (version) VALUES (20250824174355);
INSERT INTO public."schema_migrations" (version) VALUES (20250824174854);
INSERT INTO public."schema_migrations" (version) VALUES (20250824175403);
INSERT INTO public."schema_migrations" (version) VALUES (20250824175715);
INSERT INTO public."schema_migrations" (version) VALUES (20250824180759);
INSERT INTO public."schema_migrations" (version) VALUES (20250824185612);
INSERT INTO public."schema_migrations" (version) VALUES (20250824191147);
INSERT INTO public."schema_migrations" (version) VALUES (20250830215829);
INSERT INTO public."schema_migrations" (version) VALUES (20250830220644);
INSERT INTO public."schema_migrations" (version) VALUES (20250830232632);
INSERT INTO public."schema_migrations" (version) VALUES (20250831185827);
INSERT INTO public."schema_migrations" (version) VALUES (20250831191646);
INSERT INTO public."schema_migrations" (version) VALUES (20250831193242);
INSERT INTO public."schema_migrations" (version) VALUES (20250831195157);
INSERT INTO public."schema_migrations" (version) VALUES (20250831195848);
INSERT INTO public."schema_migrations" (version) VALUES (20250831202352);
INSERT INTO public."schema_migrations" (version) VALUES (20250831205822);
INSERT INTO public."schema_migrations" (version) VALUES (20250831205917);
INSERT INTO public."schema_migrations" (version) VALUES (20250831205931);
INSERT INTO public."schema_migrations" (version) VALUES (20250831205946);
INSERT INTO public."schema_migrations" (version) VALUES (20250831210001);
INSERT INTO public."schema_migrations" (version) VALUES (20250831210023);
INSERT INTO public."schema_migrations" (version) VALUES (20250831210038);
INSERT INTO public."schema_migrations" (version) VALUES (20250831210054);
INSERT INTO public."schema_migrations" (version) VALUES (20250831210110);
INSERT INTO public."schema_migrations" (version) VALUES (20250831210125);
INSERT INTO public."schema_migrations" (version) VALUES (20250831210145);
INSERT INTO public."schema_migrations" (version) VALUES (20250831210207);
INSERT INTO public."schema_migrations" (version) VALUES (20250831210224);
INSERT INTO public."schema_migrations" (version) VALUES (20250831210241);
INSERT INTO public."schema_migrations" (version) VALUES (20250831210305);
