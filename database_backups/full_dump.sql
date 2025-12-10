--
-- PostgreSQL database dump
--

\restrict t7y9REU9pHw03wNHYKdgOOSP5GPWpFUfb9tqoz3BDI5dtvZv1Dtks6uzYEuOPkR

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2025-12-09 23:13:28

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

--
-- TOC entry 5139 (class 1262 OID 16388)
-- Name: research_lab_manager; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE research_lab_manager WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_India.1252';


ALTER DATABASE research_lab_manager OWNER TO postgres;

\unrestrict t7y9REU9pHw03wNHYKdgOOSP5GPWpFUfb9tqoz3BDI5dtvZv1Dtks6uzYEuOPkR
\connect research_lab_manager
\restrict t7y9REU9pHw03wNHYKdgOOSP5GPWpFUfb9tqoz3BDI5dtvZv1Dtks6uzYEuOPkR

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

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


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
-- TOC entry 5141 (class 0 OID 0)
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
-- TOC entry 5142 (class 0 OID 0)
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
-- TOC entry 5143 (class 0 OID 0)
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
-- TOC entry 5144 (class 0 OID 0)
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
-- TOC entry 5145 (class 0 OID 0)
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
-- TOC entry 5146 (class 0 OID 0)
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
-- TOC entry 5132 (class 0 OID 16575)
-- Dependencies: 236
-- Data for Name: app_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.app_user VALUES (3, 'admin', '$2b$12$TwzfnRx8nLGhQpcUfRUEdOL2RAPVXuI4QpwawEo6eJ4ihMYMJ54uu', 'admin');


--
-- TOC entry 5118 (class 0 OID 16423)
-- Dependencies: 222
-- Data for Name: collaborator; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.collaborator VALUES (7, 'Johns Hopkins University', NULL);
INSERT INTO public.collaborator VALUES (8, 'Johns Hopkins University', NULL);
INSERT INTO public.collaborator VALUES (14, 'Johns Hopkins University', 'Assistant to Martin Brenner');


--
-- TOC entry 5126 (class 0 OID 16515)
-- Dependencies: 230
-- Data for Name: equipment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.equipment VALUES (1, 'Barcode Scanner', 'Zebra DS2208 Handheld Scanner', 'IN_USE', '2020-01-15', 'Scanning asset barcodes for inventory tracking');
INSERT INTO public.equipment VALUES (2, 'Label Printer', 'Brother QL-800 Label Printer', 'IN_USE', '2020-01-20', 'Printing inventory & storage labels for samples/equipment');
INSERT INTO public.equipment VALUES (3, 'Server', 'Inventory DB Server – Dell PowerEdge', 'AVAILABLE', '2020-02-01', 'Central database server for inventory & project applications');
INSERT INTO public.equipment VALUES (4, 'Server', 'Grants Application Server – HP ProLiant', 'IN_USE', '2020-03-10', 'Server for running grant automation and workflow systems');
INSERT INTO public.equipment VALUES (5, 'Storage', 'Synology NAS for Proposal Backups', 'IN_USE', '2020-03-20', 'Backup storage for proposals, experiment files, and datasets');
INSERT INTO public.equipment VALUES (6, 'RFID Reader', 'HID ProxPoint Plus Door Reader', 'IN_USE', '2020-04-05', 'RFID entry authentication and lab access control');
INSERT INTO public.equipment VALUES (7, 'Door Controller', 'Schneider Electric Access Controller', 'IN_USE', '2020-04-10', 'Controls electronic door access for restricted lab rooms');
INSERT INTO public.equipment VALUES (8, 'Camera', 'Axis M3046-V Dome Camera', 'IN_USE', '2020-04-15', 'Security camera for lab surveillance and equipment monitoring');
INSERT INTO public.equipment VALUES (9, 'DNA Sequencer', 'Illumina MiSeq Sequencer', 'IN_USE', '2020-05-01', 'DNA analysis and sequencing research experiments');
INSERT INTO public.equipment VALUES (10, 'Compute Node', 'GPU Workstation for Sequence Analysis', 'IN_USE', '2020-05-10', 'High-performance compute node for data-heavy research');
INSERT INTO public.equipment VALUES (11, 'Storage', 'Bioinformatics Shared Storage Array', 'AVAILABLE', '2020-05-20', 'Shared storage array for bioinformatics workflows');
INSERT INTO public.equipment VALUES (12, 'Sensor', 'Security Onion IDS Sensor Appliance', 'IN_USE', '2020-06-01', 'Intrusion detection system for lab network monitoring');
INSERT INTO public.equipment VALUES (15, 'Sensor', 'TP-Link Network Analyzer Pack', 'IN_USE', '2021-05-30', 'Wi-Fi packets for intrusion detection experiments');
INSERT INTO public.equipment VALUES (16, 'Autonomous Drone Prototype', 'ADS-Proto Mk II', 'AVAILABLE', '2023-02-10', 'Used for swarm simulation testing and flight path coordination experiments.');
INSERT INTO public.equipment VALUES (18, 'Lidar Sensor', 'QuantumBeam Lidar X2', 'AVAILABLE', '2022-09-01', 'High-resolution terrain mapping');
INSERT INTO public.equipment VALUES (19, 'Microscope', 'Pro', 'AVAILABLE', '2021-02-01', 'Imaging');
INSERT INTO public.equipment VALUES (13, 'Firewall', 'Palo Alto Perimeter Firewall', 'OUT_OF_SERVICE', '2020-06-05', 'Network firewall for securing research infrastructure');


--
-- TOC entry 5119 (class 0 OID 16437)
-- Dependencies: 223
-- Data for Name: faculty; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.faculty VALUES (1, 'Computer Science');
INSERT INTO public.faculty VALUES (2, 'Computer Science');
INSERT INTO public.faculty VALUES (3, 'Computer Science');
INSERT INTO public.faculty VALUES (13, 'Computer Science');


--
-- TOC entry 5133 (class 0 OID 16613)
-- Dependencies: 237
-- Data for Name: funds; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.funds VALUES (1, 1);
INSERT INTO public.funds VALUES (1, 2);
INSERT INTO public.funds VALUES (2, 3);
INSERT INTO public.funds VALUES (3, 4);
INSERT INTO public.funds VALUES (4, 5);
INSERT INTO public.funds VALUES (13, 7);


--
-- TOC entry 5123 (class 0 OID 16468)
-- Dependencies: 227
-- Data for Name: grant_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.grant_info VALUES (1, 'NASA', 250000.00, '2021-01-15', 365);
INSERT INTO public.grant_info VALUES (2, 'NSF', 180000.00, '2021-03-01', 364);
INSERT INTO public.grant_info VALUES (3, 'NSF', 300000.00, '2021-04-01', 364);
INSERT INTO public.grant_info VALUES (4, 'NIH', 220000.00, '2021-06-10', 364);
INSERT INTO public.grant_info VALUES (5, 'Department of Homeland Security', 450000.00, '2021-02-01', 364);
INSERT INTO public.grant_info VALUES (6, 'DARPA', 500000.00, '2021-05-15', 364);
INSERT INTO public.grant_info VALUES (7, 'NIH', 600000.00, '2021-03-20', 364);
INSERT INTO public.grant_info VALUES (8, 'NSF', 350000.00, '2021-07-01', 364);
INSERT INTO public.grant_info VALUES (9, 'DARPA', 800000.00, '2021-01-20', 364);
INSERT INTO public.grant_info VALUES (10, 'Department of Defense', 550000.00, '2021-04-10', 364);
INSERT INTO public.grant_info VALUES (11, 'Department of Homeland Security', 350000.00, '2021-03-01', 365);
INSERT INTO public.grant_info VALUES (13, 'DARPA Swarm Intelligence Research Grant', 850000.00, '2023-01-01', 450);
INSERT INTO public.grant_info VALUES (14, 'DARPA Autonomous Systems Program', 750000.00, '2023-01-10', 365);


--
-- TOC entry 5116 (class 0 OID 16390)
-- Dependencies: 220
-- Data for Name: lab_member; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.lab_member VALUES (1, 'Jim Hopper', '2020-01-01', 'FACULTY', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.lab_member VALUES (2, 'Winona Ryder', '2020-01-02', 'FACULTY', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.lab_member VALUES (3, 'Vecna', '2020-02-02', 'FACULTY', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.lab_member VALUES (4, 'Eleven', '2020-06-08', 'STUDENT', NULL, 'Computer Science', NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.lab_member VALUES (5, 'Mike Wheeler', '2020-06-07', 'STUDENT', NULL, 'Computer Science', NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.lab_member VALUES (6, 'Holly Wheeler', '2020-09-30', 'STUDENT', NULL, 'Computer Science', NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.lab_member VALUES (9, 'Max Mayfiled', '2020-05-02', 'STUDENT', NULL, 'Computer Science', NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.lab_member VALUES (7, 'Murray Bauman', '2020-02-03', 'COLLABORATOR', NULL, NULL, NULL, NULL, NULL, NULL, 'External collaborator from Johns Hopkins University.');
INSERT INTO public.lab_member VALUES (8, 'Martin Brenner', '2019-01-01', 'COLLABORATOR', NULL, NULL, NULL, NULL, NULL, NULL, 'Industry collaborator supporting lab projects.');
INSERT INTO public.lab_member VALUES (11, 'Steve Harrington', '2020-06-05', 'STUDENT', NULL, 'Computer Science', 'S004', 'Graduate', NULL, NULL, NULL);
INSERT INTO public.lab_member VALUES (12, 'Jonathan Byers', '2020-07-06', 'STUDENT', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.lab_member VALUES (10, 'Dustin Henderson', '2020-05-08', 'STUDENT', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.lab_member VALUES (13, 'Karen Wheeler', '2020-01-04', 'FACULTY', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.lab_member VALUES (14, 'Dr Sam owens', '2020-01-06', 'COLLABORATOR', NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- TOC entry 5121 (class 0 OID 16450)
-- Dependencies: 225
-- Data for Name: project; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.project VALUES (1, 'Research Lab Inventory Tracking System', '2021-01-01', '2021-12-31', 364, 1);
INSERT INTO public.project VALUES (2, 'Research Grant Management & Funding Tracker', '2021-01-01', '2021-12-31', 364, 2);
INSERT INTO public.project VALUES (3, 'Smart Campus Access Control System', '2021-01-01', '2021-12-31', 364, 1);
INSERT INTO public.project VALUES (4, 'Bioinformatics Sequence Analysis Platform', '2021-01-01', '2021-12-31', 364, 2);
INSERT INTO public.project VALUES (5, 'Cybersecurity Threat Event Analysis System', '2021-01-01', '2021-12-31', 364, 3);
INSERT INTO public.project VALUES (6, 'Smart Home Intrusion Detection', '2021-09-01', '2022-08-31', 364, 12);
INSERT INTO public.project VALUES (7, 'Autonomous Drone Swarm Coordination System.', '2023-01-15', '2024-02-20', 401, 4);
INSERT INTO public.project VALUES (9, 'AI-Driven Lidar Mapping System', '2023-02-01', '2023-11-15', 287, 2);


--
-- TOC entry 5129 (class 0 OID 16547)
-- Dependencies: 233
-- Data for Name: publication; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.publication VALUES (1, 'High-Resolution 3D Urban Mapping Using Autonomous Drones', 'IEEE ICRA', '2022-05-15', '10.1109/icra.2022.001');
INSERT INTO public.publication VALUES (2, 'Optimizing Drone Flight Paths for Real-Time Reconstruction', 'ACM Transactions on Sensor Networks', '2023-02-10', '10.1145/3520001');
INSERT INTO public.publication VALUES (3, 'RFID-Based Inventory Automation for Smart Research Labs', 'IEEE Internet of Things Journal', '2021-11-05', '10.1109/jiot.2021.015');
INSERT INTO public.publication VALUES (4, 'Automated Resource Allocation in University Laboratories', 'Journal of Laboratory Automation', '2022-08-21', '10.1016/j.jala.2022.004');
INSERT INTO public.publication VALUES (5, 'AI-Enabled Access Control for Secure University Campuses', 'ACM WiSec', '2022-09-13', '10.1145/3501001');
INSERT INTO public.publication VALUES (6, 'RFID and Facial Recognition Hybrid Entry System', 'IEEE Transactions on Information Forensics and Security', '2023-01-05', '10.1109/tifs.2023.002');
INSERT INTO public.publication VALUES (7, 'GPU-Accelerated DNA Sequence Alignment', 'Nature Computational Science', '2021-12-10', '10.1038/ncompsci.2021.004');
INSERT INTO public.publication VALUES (8, 'Parallel Mutation Analysis Using Multi-core Architectures', 'Bioinformatics Research Conference', '2022-07-14', '10.1093/bioinformatics/btac120');
INSERT INTO public.publication VALUES (9, 'Deep Learning Intrusion Detection for Enterprise Networks', 'IEEE Security & Privacy', '2022-03-18', '10.1109/sp.2022.033');
INSERT INTO public.publication VALUES (10, 'High-Volume Network Traffic Anomaly Detection: A Comparative Study', 'ACM CCS', '2023-04-09', '10.1145/3501234');
INSERT INTO public.publication VALUES (11, 'Smart Home Intrusion Detection Using Deep Learning', 'IEEE Internet of Things Journal', '2022-03-10', '10.1109/iotj.2022.00123');
INSERT INTO public.publication VALUES (13, 'Adaptive Neural Flight Control Models for Drone Swarm Coordination', 'IEEE International Conference on Robotics', '2023-11-20', '10.1184/ads.swarms.2023.1120');
INSERT INTO public.publication VALUES (14, 'High-Resolution Real-Time Lidar Mapping', 'IEEE Robotics & Automation Letters', '2023-10-05', '10.1109/winona.2023.014');


--
-- TOC entry 5130 (class 0 OID 16557)
-- Dependencies: 234
-- Data for Name: publishes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.publishes VALUES (1, 1, '2020-01-15', '2020-06-01', 'Primary Author');
INSERT INTO public.publishes VALUES (1, 2, '2020-03-01', '2020-10-15', 'Research Supervisor');
INSERT INTO public.publishes VALUES (2, 1, '2020-01-20', '2020-06-01', 'Co-Author');
INSERT INTO public.publishes VALUES (2, 3, '2020-04-01', '2020-11-30', 'Primary Author');
INSERT INTO public.publishes VALUES (2, 4, '2020-07-10', '2021-02-10', 'Research Supervisor');
INSERT INTO public.publishes VALUES (4, 2, '2020-03-05', '2020-10-15', 'Data Collection Lead');
INSERT INTO public.publishes VALUES (4, 5, '2020-09-01', '2021-03-01', 'System Evaluation');
INSERT INTO public.publishes VALUES (5, 3, '2020-04-10', '2020-11-30', 'Experimental Assistant');
INSERT INTO public.publishes VALUES (6, 5, '2020-09-15', '2021-03-01', 'Data Analyst');
INSERT INTO public.publishes VALUES (7, 2, '2020-03-02', '2020-10-15', 'External Reviewer');
INSERT INTO public.publishes VALUES (7, 4, '2020-07-15', '2021-02-10', 'Industry Consultant');
INSERT INTO public.publishes VALUES (12, 11, '2022-01-01', '2022-06-10', 'Lead Author');
INSERT INTO public.publishes VALUES (4, 13, '2023-09-01', '2023-12-01', 'Lead Author');


--
-- TOC entry 5117 (class 0 OID 16407)
-- Dependencies: 221
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.student VALUES (4, 'S001', 'Graduate', 'Computer Science');
INSERT INTO public.student VALUES (5, 'S002', 'Graduate', 'Computer Science');
INSERT INTO public.student VALUES (6, 'S1001', 'Undergraduate', 'Computer Science');
INSERT INTO public.student VALUES (9, 'S003', 'Graduate', 'Computer Science');
INSERT INTO public.student VALUES (12, 'S005', 'Graduate', 'Computer Science');
INSERT INTO public.student VALUES (11, 'S006', 'Graduate', 'Computer Science');
INSERT INTO public.student VALUES (10, 'S004', 'Graduate', 'Computer Science');


--
-- TOC entry 5127 (class 0 OID 16527)
-- Dependencies: 231
-- Data for Name: uses; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.uses VALUES (1, 1, '2020-01-10 00:00:00', '2020-01-15 00:00:00', 'Initial lab equipment tagging');
INSERT INTO public.uses VALUES (2, 2, '2020-02-05 00:00:00', '2020-02-12 00:00:00', 'Labeling inventory samples');
INSERT INTO public.uses VALUES (4, 3, '2020-03-10 00:00:00', '2020-04-01 00:00:00', 'Running access control simulations');
INSERT INTO public.uses VALUES (5, 6, '2020-03-20 00:00:00', '2020-04-05 00:00:00', 'RFID badge testing');
INSERT INTO public.uses VALUES (6, 8, '2020-04-15 00:00:00', '2020-04-20 00:00:00', 'Collecting surveillance dataset');
INSERT INTO public.uses VALUES (7, 10, '2020-05-10 00:00:00', '2020-05-20 00:00:00', 'Sequence computation');
INSERT INTO public.uses VALUES (9, 12, '2020-06-01 00:00:00', '2020-06-07 00:00:00', 'Network traffic capture');
INSERT INTO public.uses VALUES (10, 11, '2020-05-15 00:00:00', '2020-05-30 00:00:00', 'Dataset archiving');
INSERT INTO public.uses VALUES (11, 13, '2020-06-05 00:00:00', '2020-06-09 00:00:00', 'Firewall rule tuning');
INSERT INTO public.uses VALUES (12, 9, '2020-07-06 00:00:00', '2020-07-15 00:00:00', 'Genome sequencing');
INSERT INTO public.uses VALUES (13, 4, '2020-01-04 00:00:00', '2020-01-20 00:00:00', 'Application hosting');
INSERT INTO public.uses VALUES (14, 5, '2020-01-06 00:00:00', '2020-01-22 00:00:00', 'Storing experiment data');


--
-- TOC entry 5124 (class 0 OID 16496)
-- Dependencies: 228
-- Data for Name: works; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.works VALUES (1, 1, 'Principal Investigator', 120);
INSERT INTO public.works VALUES (1, 5, 'Graduate Research Assistant', 90);
INSERT INTO public.works VALUES (1, 9, 'Graduate Research Assistant', 80);
INSERT INTO public.works VALUES (1, 12, 'Graduate Research Intern', 70);
INSERT INTO public.works VALUES (2, 2, 'Principal Investigator', 110);
INSERT INTO public.works VALUES (2, 11, 'Graduate Research Assistant', 85);
INSERT INTO public.works VALUES (2, 10, 'Graduate Research Assistant', 75);
INSERT INTO public.works VALUES (2, 14, 'External Advisor', 40);
INSERT INTO public.works VALUES (3, 1, 'Principal Investigator', 130);
INSERT INTO public.works VALUES (3, 4, 'Graduate Developer', 95);
INSERT INTO public.works VALUES (3, 6, 'Undergraduate Developer', 60);
INSERT INTO public.works VALUES (3, 7, 'Security Consultant', 50);
INSERT INTO public.works VALUES (4, 2, 'Principal Investigator', 125);
INSERT INTO public.works VALUES (4, 12, 'Graduate Bioinformatics Analyst', 90);
INSERT INTO public.works VALUES (4, 5, 'Graduate Research Assistant', 85);
INSERT INTO public.works VALUES (4, 8, 'External Collaborator', 55);
INSERT INTO public.works VALUES (5, 3, 'Project Lead', 140);
INSERT INTO public.works VALUES (5, 9, 'Threat Analysis Intern', 85);
INSERT INTO public.works VALUES (5, 10, 'Graduate Analyst', 90);
INSERT INTO public.works VALUES (5, 7, 'Cybersecurity Consultant', 60);
INSERT INTO public.works VALUES (7, 4, NULL, NULL);


--
-- TOC entry 5147 (class 0 OID 0)
-- Dependencies: 235
-- Name: app_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_user_id_seq', 3, true);


--
-- TOC entry 5148 (class 0 OID 0)
-- Dependencies: 229
-- Name: equipment_eid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.equipment_eid_seq', 19, true);


--
-- TOC entry 5149 (class 0 OID 0)
-- Dependencies: 226
-- Name: grant_info_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grant_info_gid_seq', 14, true);


--
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 219
-- Name: lab_member_mid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lab_member_mid_seq', 14, true);


--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 224
-- Name: project_pid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.project_pid_seq', 9, true);


--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 232
-- Name: publication_pubid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.publication_pubid_seq', 14, true);


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


-- Completed on 2025-12-09 23:13:29

--
-- PostgreSQL database dump complete
--

\unrestrict t7y9REU9pHw03wNHYKdgOOSP5GPWpFUfb9tqoz3BDI5dtvZv1Dtks6uzYEuOPkR

