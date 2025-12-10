--
-- PostgreSQL database dump
--

\restrict 4FgDfrpOQXZWQWVJhbEy5PpKTiKTS1pMbyythn5xpTgXsbcpI3b7LxJ2Xfsq6eI

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2025-12-09 23:02:16

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 236 (class 1259 OID 16575)
-- Name: app_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.app_user (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password_hash character varying(200) NOT NULL,
    role character varying(20) DEFAULT 'admin'::character varying
);


ALTER TABLE public.app_user OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16574)
-- Name: app_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_user_id_seq OWNER TO postgres;

--
-- TOC entry 5120 (class 0 OID 0)
-- Dependencies: 235
-- Name: app_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.app_user_id_seq OWNED BY public.app_user.id;


--
-- TOC entry 222 (class 1259 OID 16423)
-- Name: collaborator; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collaborator (
    mid integer NOT NULL,
    affiliation character varying(100) NOT NULL,
    biography character varying(500)
);


ALTER TABLE public.collaborator OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16515)
-- Name: equipment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.equipment (
    eid integer NOT NULL,
    etype character varying(50) NOT NULL,
    ename character varying(100) NOT NULL,
    status character varying(20) NOT NULL,
    pdate date NOT NULL,
    purpose character varying(200),
    CONSTRAINT equipment_status_check CHECK (((status)::text = ANY ((ARRAY['AVAILABLE'::character varying, 'IN_USE'::character varying, 'OUT_OF_SERVICE'::character varying, 'RETIRED'::character varying])::text[])))
);


ALTER TABLE public.equipment OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16514)
-- Name: equipment_eid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.equipment_eid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.equipment_eid_seq OWNER TO postgres;

--
-- TOC entry 5121 (class 0 OID 0)
-- Dependencies: 229
-- Name: equipment_eid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.equipment_eid_seq OWNED BY public.equipment.eid;


--
-- TOC entry 223 (class 1259 OID 16437)
-- Name: faculty; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.faculty (
    mid integer NOT NULL,
    department character varying(50) NOT NULL
);


ALTER TABLE public.faculty OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16613)
-- Name: funds; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.funds (
    gid integer NOT NULL,
    pid integer NOT NULL
);


ALTER TABLE public.funds OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16468)
-- Name: grant_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grant_info (
    gid integer NOT NULL,
    source character varying(100) NOT NULL,
    budget numeric(12,2),
    startdate date NOT NULL,
    duration integer,
    CONSTRAINT grant_info_budget_check CHECK ((budget > (0)::numeric)),
    CONSTRAINT grant_info_duration_check CHECK ((duration >= 0))
);


ALTER TABLE public.grant_info OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16467)
-- Name: grant_info_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grant_info_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.grant_info_gid_seq OWNER TO postgres;

--
-- TOC entry 5122 (class 0 OID 0)
-- Dependencies: 226
-- Name: grant_info_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grant_info_gid_seq OWNED BY public.grant_info.gid;


--
-- TOC entry 220 (class 1259 OID 16390)
-- Name: lab_member; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lab_member (
    mid integer NOT NULL,
    name character varying(100) NOT NULL,
    joindate date NOT NULL,
    mtype character varying(20) NOT NULL,
    mentor integer,
    major character varying(100),
    sid character varying(20),
    level character varying(50),
    department character varying(100),
    affiliation character varying(200),
    biography text,
    CONSTRAINT chk_not_self_mentor CHECK (((mentor IS NULL) OR (mentor <> mid))),
    CONSTRAINT lab_member_mtype_check CHECK (((mtype)::text = ANY ((ARRAY['STUDENT'::character varying, 'COLLABORATOR'::character varying, 'FACULTY'::character varying])::text[])))
);


ALTER TABLE public.lab_member OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16389)
-- Name: lab_member_mid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lab_member_mid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lab_member_mid_seq OWNER TO postgres;

--
-- TOC entry 5123 (class 0 OID 0)
-- Dependencies: 219
-- Name: lab_member_mid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lab_member_mid_seq OWNED BY public.lab_member.mid;


--
-- TOC entry 225 (class 1259 OID 16450)
-- Name: project; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project (
    pid integer NOT NULL,
    title character varying(150) NOT NULL,
    sdate date NOT NULL,
    edate date,
    eduration integer,
    leader integer NOT NULL,
    CONSTRAINT chk_project_dates CHECK (((edate IS NULL) OR (edate >= sdate))),
    CONSTRAINT project_eduration_check CHECK ((eduration >= 0))
);


ALTER TABLE public.project OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16449)
-- Name: project_pid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.project_pid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project_pid_seq OWNER TO postgres;

--
-- TOC entry 5124 (class 0 OID 0)
-- Dependencies: 224
-- Name: project_pid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.project_pid_seq OWNED BY public.project.pid;


--
-- TOC entry 233 (class 1259 OID 16547)
-- Name: publication; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publication (
    pubid integer NOT NULL,
    title character varying(200) NOT NULL,
    venue character varying(100) NOT NULL,
    pdate date NOT NULL,
    doi character varying(100)
);


ALTER TABLE public.publication OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16546)
-- Name: publication_pubid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.publication_pubid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.publication_pubid_seq OWNER TO postgres;

--
-- TOC entry 5125 (class 0 OID 0)
-- Dependencies: 232
-- Name: publication_pubid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.publication_pubid_seq OWNED BY public.publication.pubid;


--
-- TOC entry 234 (class 1259 OID 16557)
-- Name: publishes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publishes (
    mid integer NOT NULL,
    pid integer CONSTRAINT publishes_pubid_not_null NOT NULL,
    sdate date,
    edate date,
    purpose character varying(200)
);


ALTER TABLE public.publishes OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16407)
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student (
    mid integer NOT NULL,
    sid character varying(20) NOT NULL,
    level character varying(20) NOT NULL,
    major character varying(50) NOT NULL
);


ALTER TABLE public.student OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16527)
-- Name: uses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.uses (
    mid integer NOT NULL,
    eid integer NOT NULL,
    sdate timestamp without time zone NOT NULL,
    edate timestamp without time zone,
    purpose character varying(200),
    CONSTRAINT chk_uses_dates CHECK (((edate IS NULL) OR (edate >= sdate)))
);


ALTER TABLE public.uses OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16496)
-- Name: works; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.works (
    pid integer NOT NULL,
    mid integer NOT NULL,
    role character varying(50),
    hours integer,
    CONSTRAINT works_hours_check CHECK ((hours >= 0))
);


ALTER TABLE public.works OWNER TO postgres;

--
-- TOC entry 4914 (class 2604 OID 16578)
-- Name: app_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_user ALTER COLUMN id SET DEFAULT nextval('public.app_user_id_seq'::regclass);


--
-- TOC entry 4912 (class 2604 OID 16518)
-- Name: equipment eid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment ALTER COLUMN eid SET DEFAULT nextval('public.equipment_eid_seq'::regclass);


--
-- TOC entry 4911 (class 2604 OID 16471)
-- Name: grant_info gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_info ALTER COLUMN gid SET DEFAULT nextval('public.grant_info_gid_seq'::regclass);


--
-- TOC entry 4909 (class 2604 OID 16393)
-- Name: lab_member mid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_member ALTER COLUMN mid SET DEFAULT nextval('public.lab_member_mid_seq'::regclass);


--
-- TOC entry 4910 (class 2604 OID 16453)
-- Name: project pid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project ALTER COLUMN pid SET DEFAULT nextval('public.project_pid_seq'::regclass);


--
-- TOC entry 4913 (class 2604 OID 16550)
-- Name: publication pubid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publication ALTER COLUMN pubid SET DEFAULT nextval('public.publication_pubid_seq'::regclass);


--
-- TOC entry 4950 (class 2606 OID 16584)
-- Name: app_user app_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_user
    ADD CONSTRAINT app_user_pkey PRIMARY KEY (id);


--
-- TOC entry 4952 (class 2606 OID 16586)
-- Name: app_user app_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_user
    ADD CONSTRAINT app_user_username_key UNIQUE (username);


--
-- TOC entry 4932 (class 2606 OID 16431)
-- Name: collaborator collaborator_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collaborator
    ADD CONSTRAINT collaborator_pkey PRIMARY KEY (mid);


--
-- TOC entry 4942 (class 2606 OID 16526)
-- Name: equipment equipment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_pkey PRIMARY KEY (eid);


--
-- TOC entry 4934 (class 2606 OID 16443)
-- Name: faculty faculty_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_pkey PRIMARY KEY (mid);


--
-- TOC entry 4954 (class 2606 OID 16619)
-- Name: funds funds_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funds
    ADD CONSTRAINT funds_pkey PRIMARY KEY (gid, pid);


--
-- TOC entry 4938 (class 2606 OID 16478)
-- Name: grant_info grant_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grant_info
    ADD CONSTRAINT grant_info_pkey PRIMARY KEY (gid);


--
-- TOC entry 4926 (class 2606 OID 16401)
-- Name: lab_member lab_member_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_member
    ADD CONSTRAINT lab_member_pkey PRIMARY KEY (mid);


--
-- TOC entry 4936 (class 2606 OID 16461)
-- Name: project project_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT project_pkey PRIMARY KEY (pid);


--
-- TOC entry 4946 (class 2606 OID 16556)
-- Name: publication publication_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publication
    ADD CONSTRAINT publication_pkey PRIMARY KEY (pubid);


--
-- TOC entry 4948 (class 2606 OID 16563)
-- Name: publishes publishes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publishes
    ADD CONSTRAINT publishes_pkey PRIMARY KEY (mid, pid);


--
-- TOC entry 4928 (class 2606 OID 16415)
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (mid);


--
-- TOC entry 4930 (class 2606 OID 16417)
-- Name: student student_sid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_sid_key UNIQUE (sid);


--
-- TOC entry 4944 (class 2606 OID 16535)
-- Name: uses uses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uses
    ADD CONSTRAINT uses_pkey PRIMARY KEY (mid, eid, sdate);


--
-- TOC entry 4940 (class 2606 OID 16503)
-- Name: works works_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.works
    ADD CONSTRAINT works_pkey PRIMARY KEY (pid, mid);


--
-- TOC entry 4957 (class 2606 OID 16432)
-- Name: collaborator fk_collab_member; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collaborator
    ADD CONSTRAINT fk_collab_member FOREIGN KEY (mid) REFERENCES public.lab_member(mid);


--
-- TOC entry 4958 (class 2606 OID 16444)
-- Name: faculty fk_faculty_member; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT fk_faculty_member FOREIGN KEY (mid) REFERENCES public.lab_member(mid);


--
-- TOC entry 4955 (class 2606 OID 16402)
-- Name: lab_member fk_labmember_mentor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_member
    ADD CONSTRAINT fk_labmember_mentor FOREIGN KEY (mentor) REFERENCES public.lab_member(mid);


--
-- TOC entry 4959 (class 2606 OID 16462)
-- Name: project fk_project_leader; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT fk_project_leader FOREIGN KEY (leader) REFERENCES public.lab_member(mid);


--
-- TOC entry 4964 (class 2606 OID 16564)
-- Name: publishes fk_publ_member; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publishes
    ADD CONSTRAINT fk_publ_member FOREIGN KEY (mid) REFERENCES public.lab_member(mid);


--
-- TOC entry 4965 (class 2606 OID 16569)
-- Name: publishes fk_publ_publication; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publishes
    ADD CONSTRAINT fk_publ_publication FOREIGN KEY (pid) REFERENCES public.publication(pubid);


--
-- TOC entry 4956 (class 2606 OID 16418)
-- Name: student fk_student_member; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT fk_student_member FOREIGN KEY (mid) REFERENCES public.lab_member(mid);


--
-- TOC entry 4962 (class 2606 OID 16541)
-- Name: uses fk_uses_equipment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uses
    ADD CONSTRAINT fk_uses_equipment FOREIGN KEY (eid) REFERENCES public.equipment(eid);


--
-- TOC entry 4963 (class 2606 OID 16536)
-- Name: uses fk_uses_member; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uses
    ADD CONSTRAINT fk_uses_member FOREIGN KEY (mid) REFERENCES public.lab_member(mid);


--
-- TOC entry 4960 (class 2606 OID 16509)
-- Name: works fk_works_member; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.works
    ADD CONSTRAINT fk_works_member FOREIGN KEY (mid) REFERENCES public.lab_member(mid);


--
-- TOC entry 4961 (class 2606 OID 16504)
-- Name: works fk_works_project; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.works
    ADD CONSTRAINT fk_works_project FOREIGN KEY (pid) REFERENCES public.project(pid);


--
-- TOC entry 4966 (class 2606 OID 16620)
-- Name: funds funds_gid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funds
    ADD CONSTRAINT funds_gid_fkey FOREIGN KEY (gid) REFERENCES public.grant_info(gid);


--
-- TOC entry 4967 (class 2606 OID 16625)
-- Name: funds funds_pid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funds
    ADD CONSTRAINT funds_pid_fkey FOREIGN KEY (pid) REFERENCES public.project(pid);


-- Completed on 2025-12-09 23:02:16

--
-- PostgreSQL database dump complete
--

\unrestrict 4FgDfrpOQXZWQWVJhbEy5PpKTiKTS1pMbyythn5xpTgXsbcpI3b7LxJ2Xfsq6eI

