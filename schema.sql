-- ========= MAIN ENTITIES =========

CREATE TABLE LAB_MEMBER (
    mid        SERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    joindate   DATE NOT NULL,
    mtype      VARCHAR(20) NOT NULL
               CHECK (mtype IN ('STUDENT','COLLABORATOR','FACULTY')),
    mentor     INTEGER,
    CONSTRAINT fk_labmember_mentor
        FOREIGN KEY (mentor) REFERENCES LAB_MEMBER(mid),
    CONSTRAINT chk_not_self_mentor
        CHECK (mentor IS NULL OR mentor <> mid)
);

CREATE TABLE STUDENT (
    mid     INTEGER PRIMARY KEY,
    sid     VARCHAR(20) UNIQUE NOT NULL,
    level   VARCHAR(20) NOT NULL,
    major   VARCHAR(50) NOT NULL,
    CONSTRAINT fk_student_member
        FOREIGN KEY (mid) REFERENCES LAB_MEMBER(mid)
);

CREATE TABLE COLLABORATOR (
    mid          INTEGER PRIMARY KEY,
    affiliation  VARCHAR(100) NOT NULL,
    biography    VARCHAR(500),
    CONSTRAINT fk_collab_member
        FOREIGN KEY (mid) REFERENCES LAB_MEMBER(mid)
);

CREATE TABLE FACULTY (
    mid        INTEGER PRIMARY KEY,
    department VARCHAR(50) NOT NULL,
    CONSTRAINT fk_faculty_member
        FOREIGN KEY (mid) REFERENCES LAB_MEMBER(mid)
);

CREATE TABLE PROJECT (
    pid        SERIAL PRIMARY KEY,
    title      VARCHAR(150) NOT NULL,
    sdate      DATE NOT NULL,
    edate      DATE,
    eduration  INTEGER CHECK (eduration >= 0),
    leader     INTEGER NOT NULL,
    CONSTRAINT fk_project_leader
        FOREIGN KEY (leader) REFERENCES LAB_MEMBER(mid),
    CONSTRAINT chk_project_dates
        CHECK (edate IS NULL OR edate >= sdate)
);

CREATE TABLE GRANT_INFO (
    gid        SERIAL PRIMARY KEY,
    source     VARCHAR(100) NOT NULL,
    budget     NUMERIC(12,2) CHECK (budget > 0),
    startdate  DATE NOT NULL,
    duration   INTEGER CHECK (duration >= 0)
);

CREATE TABLE FUNDS (
    gid INTEGER NOT NULL,
    pid INTEGER NOT NULL,
    PRIMARY KEY (gid, pid),
    CONSTRAINT fk_funds_grant
        FOREIGN KEY (gid) REFERENCES GRANT_INFO(gid),
    CONSTRAINT fk_funds_project
        FOREIGN KEY (pid) REFERENCES PROJECT(pid)
);

CREATE TABLE WORKS (
    pid   INTEGER NOT NULL,
    mid   INTEGER NOT NULL,
    role  VARCHAR(50),
    hours INTEGER CHECK (hours >= 0),
    PRIMARY KEY (pid, mid),
    CONSTRAINT fk_works_project
        FOREIGN KEY (pid) REFERENCES PROJECT(pid),
    CONSTRAINT fk_works_member
        FOREIGN KEY (mid) REFERENCES LAB_MEMBER(mid)
);

CREATE TABLE EQUIPMENT (
    eid     SERIAL PRIMARY KEY,
    etype   VARCHAR(50) NOT NULL,
    ename   VARCHAR(100) NOT NULL,
    status  VARCHAR(20) NOT NULL
            CHECK (status IN ('AVAILABLE','IN_USE','RETIRED')),
    pdate   DATE NOT NULL
);

CREATE TABLE USES (
    mid     INTEGER NOT NULL,
    eid     INTEGER NOT NULL,
    sdate   TIMESTAMP NOT NULL,
    edate   TIMESTAMP,
    purpose VARCHAR(200),
    PRIMARY KEY (mid, eid, sdate),
    CONSTRAINT fk_uses_member
        FOREIGN KEY (mid) REFERENCES LAB_MEMBER(mid),
    CONSTRAINT fk_uses_equipment
        FOREIGN KEY (eid) REFERENCES EQUIPMENT(eid),
    CONSTRAINT chk_uses_dates
        CHECK (edate IS NULL OR edate >= sdate)
);

CREATE TABLE PUBLICATION (
    pubid   SERIAL PRIMARY KEY,
    title   VARCHAR(200) NOT NULL,
    venue   VARCHAR(100) NOT NULL,
    pdate   DATE NOT NULL,
    doi     VARCHAR(100)
);

CREATE TABLE PUBLISHES (
    mid   INTEGER NOT NULL,
    pubid INTEGER NOT NULL,
    PRIMARY KEY (mid, pubid),
    CONSTRAINT fk_publ_member
        FOREIGN KEY (mid) REFERENCES LAB_MEMBER(mid),
    CONSTRAINT fk_publ_publication
        FOREIGN KEY (pubid) REFERENCES PUBLICATION(pubid)
);

-- ========= USERS TABLE FOR LOGIN =========

CREATE TABLE APP_USER (
    id            SERIAL PRIMARY KEY,
    username      VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(200) NOT NULL,
    role          VARCHAR(20) DEFAULT 'admin'
);
