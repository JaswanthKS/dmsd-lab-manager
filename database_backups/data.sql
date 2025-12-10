--
-- PostgreSQL database dump
--

\restrict 4Kgw2aN6NSOCMfE0A7J7i2YntJAuJUuhNMNiChV0ZJ574geAjXti7GWSpkBINUD

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2025-12-09 23:02:53

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
-- TOC entry 5116 (class 0 OID 16575)
-- Dependencies: 236
-- Data for Name: app_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_user (id, username, password_hash, role) FROM stdin;
3	admin	$2b$12$TwzfnRx8nLGhQpcUfRUEdOL2RAPVXuI4QpwawEo6eJ4ihMYMJ54uu	admin
\.


--
-- TOC entry 5100 (class 0 OID 16390)
-- Dependencies: 220
-- Data for Name: lab_member; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_member (mid, name, joindate, mtype, mentor, major, sid, level, department, affiliation, biography) FROM stdin;
1	Jim Hopper	2020-01-01	FACULTY	\N	\N	\N	\N	\N	\N	\N
2	Winona Ryder	2020-01-02	FACULTY	\N	\N	\N	\N	\N	\N	\N
3	Vecna	2020-02-02	FACULTY	\N	\N	\N	\N	\N	\N	\N
4	Eleven	2020-06-08	STUDENT	\N	Computer Science	\N	\N	\N	\N	\N
5	Mike Wheeler	2020-06-07	STUDENT	\N	Computer Science	\N	\N	\N	\N	\N
6	Holly Wheeler	2020-09-30	STUDENT	\N	Computer Science	\N	\N	\N	\N	\N
9	Max Mayfiled	2020-05-02	STUDENT	\N	Computer Science	\N	\N	\N	\N	\N
7	Murray Bauman	2020-02-03	COLLABORATOR	\N	\N	\N	\N	\N	\N	External collaborator from Johns Hopkins University.
8	Martin Brenner	2019-01-01	COLLABORATOR	\N	\N	\N	\N	\N	\N	Industry collaborator supporting lab projects.
11	Steve Harrington	2020-06-05	STUDENT	\N	Computer Science	S004	Graduate	\N	\N	\N
12	Jonathan Byers	2020-07-06	STUDENT	\N	\N	\N	\N	\N	\N	\N
10	Dustin Henderson	2020-05-08	STUDENT	\N	\N	\N	\N	\N	\N	\N
13	Karen Wheeler	2020-01-04	FACULTY	\N	\N	\N	\N	\N	\N	\N
14	Dr Sam owens	2020-01-06	COLLABORATOR	\N	\N	\N	\N	\N	\N	\N
\.


--
-- TOC entry 5102 (class 0 OID 16423)
-- Dependencies: 222
-- Data for Name: collaborator; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.collaborator (mid, affiliation, biography) FROM stdin;
7	Johns Hopkins University	\N
8	Johns Hopkins University	\N
14	Johns Hopkins University	Assistant to Martin Brenner
\.


--
-- TOC entry 5110 (class 0 OID 16515)
-- Dependencies: 230
-- Data for Name: equipment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.equipment (eid, etype, ename, status, pdate, purpose) FROM stdin;
1	Barcode Scanner	Zebra DS2208 Handheld Scanner	IN_USE	2020-01-15	Scanning asset barcodes for inventory tracking
2	Label Printer	Brother QL-800 Label Printer	IN_USE	2020-01-20	Printing inventory & storage labels for samples/equipment
3	Server	Inventory DB Server – Dell PowerEdge	AVAILABLE	2020-02-01	Central database server for inventory & project applications
4	Server	Grants Application Server – HP ProLiant	IN_USE	2020-03-10	Server for running grant automation and workflow systems
5	Storage	Synology NAS for Proposal Backups	IN_USE	2020-03-20	Backup storage for proposals, experiment files, and datasets
6	RFID Reader	HID ProxPoint Plus Door Reader	IN_USE	2020-04-05	RFID entry authentication and lab access control
7	Door Controller	Schneider Electric Access Controller	IN_USE	2020-04-10	Controls electronic door access for restricted lab rooms
8	Camera	Axis M3046-V Dome Camera	IN_USE	2020-04-15	Security camera for lab surveillance and equipment monitoring
9	DNA Sequencer	Illumina MiSeq Sequencer	IN_USE	2020-05-01	DNA analysis and sequencing research experiments
10	Compute Node	GPU Workstation for Sequence Analysis	IN_USE	2020-05-10	High-performance compute node for data-heavy research
11	Storage	Bioinformatics Shared Storage Array	AVAILABLE	2020-05-20	Shared storage array for bioinformatics workflows
12	Sensor	Security Onion IDS Sensor Appliance	IN_USE	2020-06-01	Intrusion detection system for lab network monitoring
15	Sensor	TP-Link Network Analyzer Pack	IN_USE	2021-05-30	Wi-Fi packets for intrusion detection experiments
16	Autonomous Drone Prototype	ADS-Proto Mk II	AVAILABLE	2023-02-10	Used for swarm simulation testing and flight path coordination experiments.
18	Lidar Sensor	QuantumBeam Lidar X2	AVAILABLE	2022-09-01	High-resolution terrain mapping
19	Microscope	Pro	AVAILABLE	2021-02-01	Imaging
13	Firewall	Palo Alto Perimeter Firewall	OUT_OF_SERVICE	2020-06-05	Network firewall for securing research infrastructure
\.


--
-- TOC entry 5103 (class 0 OID 16437)
-- Dependencies: 223
-- Data for Name: faculty; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.faculty (mid, department) FROM stdin;
1	Computer Science
2	Computer Science
3	Computer Science
13	Computer Science
\.


--
-- TOC entry 5107 (class 0 OID 16468)
-- Dependencies: 227
-- Data for Name: grant_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grant_info (gid, source, budget, startdate, duration) FROM stdin;
1	NASA	250000.00	2021-01-15	365
2	NSF	180000.00	2021-03-01	364
3	NSF	300000.00	2021-04-01	364
4	NIH	220000.00	2021-06-10	364
5	Department of Homeland Security	450000.00	2021-02-01	364
6	DARPA	500000.00	2021-05-15	364
7	NIH	600000.00	2021-03-20	364
8	NSF	350000.00	2021-07-01	364
9	DARPA	800000.00	2021-01-20	364
10	Department of Defense	550000.00	2021-04-10	364
11	Department of Homeland Security	350000.00	2021-03-01	365
13	DARPA Swarm Intelligence Research Grant	850000.00	2023-01-01	450
14	DARPA Autonomous Systems Program	750000.00	2023-01-10	365
\.


--
-- TOC entry 5105 (class 0 OID 16450)
-- Dependencies: 225
-- Data for Name: project; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project (pid, title, sdate, edate, eduration, leader) FROM stdin;
1	Research Lab Inventory Tracking System	2021-01-01	2021-12-31	364	1
2	Research Grant Management & Funding Tracker	2021-01-01	2021-12-31	364	2
3	Smart Campus Access Control System	2021-01-01	2021-12-31	364	1
4	Bioinformatics Sequence Analysis Platform	2021-01-01	2021-12-31	364	2
5	Cybersecurity Threat Event Analysis System	2021-01-01	2021-12-31	364	3
6	Smart Home Intrusion Detection	2021-09-01	2022-08-31	364	12
7	Autonomous Drone Swarm Coordination System.	2023-01-15	2024-02-20	401	4
9	AI-Driven Lidar Mapping System	2023-02-01	2023-11-15	287	2
\.


--
-- TOC entry 5117 (class 0 OID 16613)
-- Dependencies: 237
-- Data for Name: funds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.funds (gid, pid) FROM stdin;
1	1
1	2
2	3
3	4
4	5
13	7
\.


--
-- TOC entry 5113 (class 0 OID 16547)
-- Dependencies: 233
-- Data for Name: publication; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publication (pubid, title, venue, pdate, doi) FROM stdin;
1	High-Resolution 3D Urban Mapping Using Autonomous Drones	IEEE ICRA	2022-05-15	10.1109/icra.2022.001
2	Optimizing Drone Flight Paths for Real-Time Reconstruction	ACM Transactions on Sensor Networks	2023-02-10	10.1145/3520001
3	RFID-Based Inventory Automation for Smart Research Labs	IEEE Internet of Things Journal	2021-11-05	10.1109/jiot.2021.015
4	Automated Resource Allocation in University Laboratories	Journal of Laboratory Automation	2022-08-21	10.1016/j.jala.2022.004
5	AI-Enabled Access Control for Secure University Campuses	ACM WiSec	2022-09-13	10.1145/3501001
6	RFID and Facial Recognition Hybrid Entry System	IEEE Transactions on Information Forensics and Security	2023-01-05	10.1109/tifs.2023.002
7	GPU-Accelerated DNA Sequence Alignment	Nature Computational Science	2021-12-10	10.1038/ncompsci.2021.004
8	Parallel Mutation Analysis Using Multi-core Architectures	Bioinformatics Research Conference	2022-07-14	10.1093/bioinformatics/btac120
9	Deep Learning Intrusion Detection for Enterprise Networks	IEEE Security & Privacy	2022-03-18	10.1109/sp.2022.033
10	High-Volume Network Traffic Anomaly Detection: A Comparative Study	ACM CCS	2023-04-09	10.1145/3501234
11	Smart Home Intrusion Detection Using Deep Learning	IEEE Internet of Things Journal	2022-03-10	10.1109/iotj.2022.00123
13	Adaptive Neural Flight Control Models for Drone Swarm Coordination	IEEE International Conference on Robotics	2023-11-20	10.1184/ads.swarms.2023.1120
14	High-Resolution Real-Time Lidar Mapping	IEEE Robotics & Automation Letters	2023-10-05	10.1109/winona.2023.014
\.


--
-- TOC entry 5114 (class 0 OID 16557)
-- Dependencies: 234
-- Data for Name: publishes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publishes (mid, pid, sdate, edate, purpose) FROM stdin;
1	1	2020-01-15	2020-06-01	Primary Author
1	2	2020-03-01	2020-10-15	Research Supervisor
2	1	2020-01-20	2020-06-01	Co-Author
2	3	2020-04-01	2020-11-30	Primary Author
2	4	2020-07-10	2021-02-10	Research Supervisor
4	2	2020-03-05	2020-10-15	Data Collection Lead
4	5	2020-09-01	2021-03-01	System Evaluation
5	3	2020-04-10	2020-11-30	Experimental Assistant
6	5	2020-09-15	2021-03-01	Data Analyst
7	2	2020-03-02	2020-10-15	External Reviewer
7	4	2020-07-15	2021-02-10	Industry Consultant
12	11	2022-01-01	2022-06-10	Lead Author
4	13	2023-09-01	2023-12-01	Lead Author
\.


--
-- TOC entry 5101 (class 0 OID 16407)
-- Dependencies: 221
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student (mid, sid, level, major) FROM stdin;
4	S001	Graduate	Computer Science
5	S002	Graduate	Computer Science
6	S1001	Undergraduate	Computer Science
9	S003	Graduate	Computer Science
12	S005	Graduate	Computer Science
11	S006	Graduate	Computer Science
10	S004	Graduate	Computer Science
\.


--
-- TOC entry 5111 (class 0 OID 16527)
-- Dependencies: 231
-- Data for Name: uses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.uses (mid, eid, sdate, edate, purpose) FROM stdin;
1	1	2020-01-10 00:00:00	2020-01-15 00:00:00	Initial lab equipment tagging
2	2	2020-02-05 00:00:00	2020-02-12 00:00:00	Labeling inventory samples
4	3	2020-03-10 00:00:00	2020-04-01 00:00:00	Running access control simulations
5	6	2020-03-20 00:00:00	2020-04-05 00:00:00	RFID badge testing
6	8	2020-04-15 00:00:00	2020-04-20 00:00:00	Collecting surveillance dataset
7	10	2020-05-10 00:00:00	2020-05-20 00:00:00	Sequence computation
9	12	2020-06-01 00:00:00	2020-06-07 00:00:00	Network traffic capture
10	11	2020-05-15 00:00:00	2020-05-30 00:00:00	Dataset archiving
11	13	2020-06-05 00:00:00	2020-06-09 00:00:00	Firewall rule tuning
12	9	2020-07-06 00:00:00	2020-07-15 00:00:00	Genome sequencing
13	4	2020-01-04 00:00:00	2020-01-20 00:00:00	Application hosting
14	5	2020-01-06 00:00:00	2020-01-22 00:00:00	Storing experiment data
\.


--
-- TOC entry 5108 (class 0 OID 16496)
-- Dependencies: 228
-- Data for Name: works; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.works (pid, mid, role, hours) FROM stdin;
1	1	Principal Investigator	120
1	5	Graduate Research Assistant	90
1	9	Graduate Research Assistant	80
1	12	Graduate Research Intern	70
2	2	Principal Investigator	110
2	11	Graduate Research Assistant	85
2	10	Graduate Research Assistant	75
2	14	External Advisor	40
3	1	Principal Investigator	130
3	4	Graduate Developer	95
3	6	Undergraduate Developer	60
3	7	Security Consultant	50
4	2	Principal Investigator	125
4	12	Graduate Bioinformatics Analyst	90
4	5	Graduate Research Assistant	85
4	8	External Collaborator	55
5	3	Project Lead	140
5	9	Threat Analysis Intern	85
5	10	Graduate Analyst	90
5	7	Cybersecurity Consultant	60
7	4	\N	\N
\.


--
-- TOC entry 5123 (class 0 OID 0)
-- Dependencies: 235
-- Name: app_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_user_id_seq', 3, true);


--
-- TOC entry 5124 (class 0 OID 0)
-- Dependencies: 229
-- Name: equipment_eid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.equipment_eid_seq', 19, true);


--
-- TOC entry 5125 (class 0 OID 0)
-- Dependencies: 226
-- Name: grant_info_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grant_info_gid_seq', 14, true);


--
-- TOC entry 5126 (class 0 OID 0)
-- Dependencies: 219
-- Name: lab_member_mid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lab_member_mid_seq', 14, true);


--
-- TOC entry 5127 (class 0 OID 0)
-- Dependencies: 224
-- Name: project_pid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.project_pid_seq', 9, true);


--
-- TOC entry 5128 (class 0 OID 0)
-- Dependencies: 232
-- Name: publication_pubid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.publication_pubid_seq', 14, true);


-- Completed on 2025-12-09 23:02:54

--
-- PostgreSQL database dump complete
--

\unrestrict 4Kgw2aN6NSOCMfE0A7J7i2YntJAuJUuhNMNiChV0ZJ574geAjXti7GWSpkBINUD

