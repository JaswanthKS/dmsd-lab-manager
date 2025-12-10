from flask import Flask, render_template, request, redirect, url_for, session, flash
from datetime import datetime
from flask_bcrypt import Bcrypt
import psycopg2
from psycopg2.extras import RealDictCursor
from dotenv import load_dotenv
import os
from functools import wraps

# Load environment variables from .env
load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv("FLASK_SECRET_KEY", "dev-secret-key")

bcrypt = Bcrypt(app)

# ----------------- DB CONNECTION -----------------
def get_db_connection():
    conn = psycopg2.connect(
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        host=os.getenv("DB_HOST", "localhost"),
        port=os.getenv("DB_PORT", "5432")
    )
    return conn

# ----------------- AUTH DECORATOR -----------------
def login_required(view_func):
    @wraps(view_func)
    def wrapped_view(*args, **kwargs):
        if "user_id" not in session:
            return redirect(url_for("login"))
        return view_func(*args, **kwargs)
    return wrapped_view

# ----------------- ROUTES -----------------

@app.route("/")
def index():
    if "user_id" in session:
        return redirect(url_for("dashboard"))
    return redirect(url_for("login"))

# ----- LOGIN / LOGOUT -----

@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form.get("username", "").strip()
        password = request.form.get("password", "")

        if not username or not password:
            flash("Please enter both username and password.", "error")
            return render_template("login.html")

        conn = get_db_connection()
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute(
            "SELECT id, username, password_hash, role FROM app_user WHERE username = %s",
            (username,),
        )
        user = cur.fetchone()
        cur.close()
        conn.close()

        if user and bcrypt.check_password_hash(user["password_hash"], password):
            session["user_id"] = user["id"]
            session["username"] = user["username"]
            session["role"] = user["role"]
            flash("Logged in successfully.", "success")
            return redirect(url_for("dashboard"))
        else:
            flash("Invalid username or password.", "error")
            return render_template("login.html")

    return render_template("login.html")


@app.route("/logout")
def logout():
    session.clear()
    flash("Logged out.", "info")
    return redirect(url_for("login"))

# ----- DASHBOARD -----

@app.route("/dashboard")
@login_required
def dashboard():
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)

    cur.execute("SELECT COUNT(*) AS count FROM lab_member")
    member_count = cur.fetchone()["count"]

    cur.execute("SELECT COUNT(*) AS count FROM project")
    project_count = cur.fetchone()["count"]

    cur.execute("SELECT COUNT(*) AS count FROM equipment")
    equipment_count = cur.fetchone()["count"]

    cur.close()
    conn.close()

    return render_template(
        "dashboard.html",
        username=session.get("username"),
        member_count=member_count,
        project_count=project_count,
        equipment_count=equipment_count,
    )

# ----- NEW PAGES (PLACEHOLDERS FOR NOW) -----

# ----- MEMBERS: LIST -----
@app.route("/members")
@login_required
def members():
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)

    cur.execute("""
        SELECT
            lm.mid,
            lm.name,
            lm.joindate,
            lm.mtype,
            COALESCE(s.sid, '') AS sid,
            COALESCE(s.level, '') AS level,
            COALESCE(s.major, '') AS major,
            COALESCE(f.department, '') AS department,
            COALESCE(c.affiliation, '') AS affiliation
        FROM lab_member lm
        LEFT JOIN student s ON lm.mid = s.mid
        LEFT JOIN faculty f ON lm.mid = f.mid
        LEFT JOIN collaborator c ON lm.mid = c.mid
        ORDER BY lm.mid
    """)
    members = cur.fetchall()

    cur.close()
    conn.close()

    return render_template("members.html", members=members)


# ----- MEMBERS: ADD NEW -----
@app.route("/members/add", methods=["POST"])
@login_required
def add_member():
    name        = request.form.get("name", "").strip()
    joindate    = request.form.get("joindate")
    mtype       = request.form.get("mtype")

    # Student-only fields
    sid         = request.form.get("sid", "").strip()
    level       = request.form.get("level", "").strip()
    major       = request.form.get("major", "").strip()

    # Faculty-only field
    department  = request.form.get("department", "").strip()

    # Collaborator-only fields
    affiliation = request.form.get("affiliation", "").strip()
    biography   = request.form.get("biography", "").strip()

    # (We are not using mentor from the form for now; keep NULL)
    mentor = None

    # ---- Basic validation ----
    if not name or not joindate or mtype not in ("STUDENT", "FACULTY", "COLLABORATOR"):
        flash("Name, join date, and valid member type are required.", "error")
        return redirect(url_for("members"))

    # Extra checks for each type
    if mtype == "STUDENT" and (not sid or not level or not major):
        flash("Student needs SID, Level, and Major.", "error")
        return redirect(url_for("members"))

    if mtype == "FACULTY" and not department:
        flash("Faculty needs a Department.", "error")
        return redirect(url_for("members"))

    if mtype == "COLLABORATOR" and not affiliation:
        flash("Collaborator needs an Affiliation.", "error")
        return redirect(url_for("members"))

    conn = get_db_connection()
    cur = conn.cursor()

    try:
        # 1) Insert into LAB_MEMBER and get new MID
        cur.execute(
            """
            INSERT INTO lab_member (name, joindate, mtype, mentor)
            VALUES (%s, %s, %s, %s)
            RETURNING mid
            """,
            (name, joindate, mtype, mentor),
        )
        new_mid = cur.fetchone()[0]

        # 2) Insert into subtype table based on mtype
        if mtype == "STUDENT":
            cur.execute(
                """
                INSERT INTO student (mid, sid, level, major)
                VALUES (%s, %s, %s, %s)
                """,
                (new_mid, sid, level, major),
            )

        elif mtype == "FACULTY":
            cur.execute(
                """
                INSERT INTO faculty (mid, department)
                VALUES (%s, %s)
                """,
                (new_mid, department),
            )

        elif mtype == "COLLABORATOR":
            cur.execute(
                """
                INSERT INTO collaborator (mid, affiliation, biography)
                VALUES (%s, %s, %s)
                """,
                (new_mid, affiliation, biography),
            )

        conn.commit()
        flash("Member added successfully.", "success")

    except Exception as e:
        conn.rollback()
        flash(f"Error adding member: {e}", "error")

    finally:
        cur.close()
        conn.close()

    return redirect(url_for("members"))

# ----- DELETE MEMBER -----
@app.route("/members/delete/<int:mid>", methods=["POST"])
@login_required
def delete_member(mid):
    conn = get_db_connection()
    cur = conn.cursor()

    try:
        # Delete dependent rows first (to satisfy FK constraints)
        cur.execute("DELETE FROM student WHERE mid = %s", (mid,))
        cur.execute("DELETE FROM faculty WHERE mid = %s", (mid,))
        cur.execute("DELETE FROM collaborator WHERE mid = %s", (mid,))
        cur.execute("DELETE FROM works WHERE mid = %s", (mid,))
        cur.execute("DELETE FROM uses WHERE mid = %s", (mid,))
        cur.execute("DELETE FROM publishes WHERE mid = %s", (mid,))

        # Finally delete from LAB_MEMBER
        cur.execute("DELETE FROM lab_member WHERE mid = %s", (mid,))

        conn.commit()
        flash("Member deleted successfully.", "success")

    except Exception as e:
        conn.rollback()
        flash(f"Error deleting member: {e}", "error")

    finally:
        cur.close()
        conn.close()

    return redirect(url_for("members"))

# ----- EDIT MEMBER (SHOW FORM) -----
@app.route("/members/edit/<int:mid>", methods=["GET"])
@login_required
def edit_member(mid):
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)

    # Get main member row
    cur.execute("SELECT * FROM lab_member WHERE mid = %s", (mid,))
    member = cur.fetchone()
    if not member:
        cur.close()
        conn.close()
        flash("Member not found.", "error")
        return redirect(url_for("members"))

    # Get subtype details depending on mtype
    student = faculty = collaborator = None

    if member["mtype"] == "STUDENT":
        cur.execute("SELECT * FROM student WHERE mid = %s", (mid,))
        student = cur.fetchone()
    elif member["mtype"] == "FACULTY":
        cur.execute("SELECT * FROM faculty WHERE mid = %s", (mid,))
        faculty = cur.fetchone()
    elif member["mtype"] == "COLLABORATOR":
        cur.execute("SELECT * FROM collaborator WHERE mid = %s", (mid,))
        collaborator = cur.fetchone()

    cur.close()
    conn.close()

    return render_template(
        "edit_member.html",
        member=member,
        student=student,
        faculty=faculty,
        collaborator=collaborator,
    )


# ----- EDIT MEMBER (SUBMIT CHANGES) -----
@app.route("/members/edit/<int:mid>", methods=["POST"])
@login_required
def update_member(mid):
    name = request.form.get("name", "").strip()
    joindate = request.form.get("joindate")
    mtype = request.form.get("mtype")

    sid = request.form.get("sid")
    level = request.form.get("level")
    major = request.form.get("major")
    department = request.form.get("department")
    affiliation = request.form.get("affiliation")

    if not name or not joindate or mtype not in ("STUDENT", "FACULTY", "COLLABORATOR"):
        flash("Name, join date, and valid member type are required.", "error")
        return redirect(url_for("edit_member", mid=mid))

    conn = get_db_connection()
    cur = conn.cursor()

    try:
        # Update LAB_MEMBER basic info and type
        cur.execute(
            "UPDATE lab_member SET name = %s, joindate = %s, mtype = %s WHERE mid = %s",
            (name, joindate, mtype, mid),
        )

        # Clear all subtype records first
        cur.execute("DELETE FROM student WHERE mid = %s", (mid,))
        cur.execute("DELETE FROM faculty WHERE mid = %s", (mid,))
        cur.execute("DELETE FROM collaborator WHERE mid = %s", (mid,))

        # Re-insert appropriate subtype
        if mtype == "STUDENT":
            if not (sid and level and major):
                flash("For STUDENT, SID, level, and major are required.", "error")
            else:
                cur.execute(
                    "INSERT INTO student (mid, sid, level, major) VALUES (%s, %s, %s, %s)",
                    (mid, sid, level, major),
                )

        elif mtype == "FACULTY":
            if not department:
                flash("For FACULTY, department is required.", "error")
            else:
                cur.execute(
                    "INSERT INTO faculty (mid, department) VALUES (%s, %s)",
                    (mid, department),
                )

        elif mtype == "COLLABORATOR":
            if not affiliation:
                flash("For COLLABORATOR, affiliation is required.", "error")
            else:
                cur.execute(
                    "INSERT INTO collaborator (mid, affiliation, biography) VALUES (%s, %s, NULL)",
                    (mid, affiliation),
                )

        conn.commit()
        flash("Member updated successfully.", "success")

    except Exception as e:
        conn.rollback()
        flash(f"Error updating member: {e}", "error")

    finally:
        cur.close()
        conn.close()

    return redirect(url_for("members"))

# ----- PROJECTS: LIST -----
@app.route("/projects")
@login_required
def projects():
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)

    # Projects with leader name
    cur.execute("""
        SELECT p.pid, p.title, p.sdate, p.edate, p.eduration,
               lm.mid AS leader_mid, lm.name AS leader_name
        FROM project p
        JOIN lab_member lm ON p.leader = lm.mid
        ORDER BY p.pid
    """)
    projects = cur.fetchall()

    # Get members list for "leader" dropdown
    cur.execute("""
        SELECT mid, name
        FROM lab_member
        ORDER BY name
    """)
    members = cur.fetchall()

    cur.close()
    conn.close()

    return render_template("projects.html", projects=projects, members=members)


# ----- PROJECTS: ADD NEW -----
@app.route("/projects/add", methods=["POST"])
@login_required
def add_project():
    title = request.form.get("title", "").strip()
    sdate = request.form.get("sdate")
    edate = request.form.get("edate") or None  # empty string -> None
    leader_mid = request.form.get("leader_mid")

    if not title or not sdate or not leader_mid:
        flash("Title, start date, and leader are required.", "error")
        return redirect(url_for("projects"))

    # compute duration in days if edate given, else NULL
    eduration = None
    if edate:
        from datetime import datetime
        try:
            sd = datetime.strptime(sdate, "%Y-%m-%d")
            ed = datetime.strptime(edate, "%Y-%m-%d")
            if ed < sd:
                flash("End date cannot be before start date.", "error")
                return redirect(url_for("projects"))
            eduration = (ed - sd).days
        except ValueError:
            flash("Invalid date format.", "error")
            return redirect(url_for("projects"))

    conn = get_db_connection()
    cur = conn.cursor()

    try:
        cur.execute(
            """
            INSERT INTO project (title, sdate, edate, eduration, leader)
            VALUES (%s, %s, %s, %s, %s)
            """,
            (title, sdate, edate, eduration, int(leader_mid)),
        )
        conn.commit()
        flash("Project added successfully.", "success")
    except Exception as e:
        conn.rollback()
        flash(f"Error adding project: {e}", "error")
    finally:
        cur.close()
        conn.close()

    return redirect(url_for("projects"))

@app.route("/projects/delete/<int:pid>", methods=["POST"])
@login_required
def delete_project(pid):
    conn = get_db_connection()
    cur = conn.cursor()

    try:
        # Delete dependent rows first
        cur.execute("DELETE FROM works WHERE pid = %s", (pid,))
        cur.execute("DELETE FROM funds WHERE pid = %s", (pid,))
        cur.execute("DELETE FROM publishes WHERE pid = %s", (pid,))

        # Delete the project itself
        cur.execute("DELETE FROM project WHERE pid = %s", (pid,))

        conn.commit()
        flash("Project deleted successfully.", "success")

    except Exception as e:
        conn.rollback()
        flash(f"Error deleting project: {e}", "error")

    finally:
        cur.close()
        conn.close()

    return redirect(url_for("projects"))

# ----- EDIT PROJECT (SHOW FORM) -----
@app.route("/projects/edit/<int:pid>", methods=["GET"])
@login_required
def edit_project(pid):
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)

    # Get the project row
    cur.execute("SELECT * FROM project WHERE pid = %s", (pid,))
    project = cur.fetchone()
    if not project:
        cur.close()
        conn.close()
        flash("Project not found.", "error")
        return redirect(url_for("projects"))

    # Get members for leader dropdown
    cur.execute("SELECT mid, name FROM lab_member ORDER BY mid;")
    members = cur.fetchall()

    cur.close()
    conn.close()

    return render_template(
        "edit_project.html",
        project=project,
        members=members,
    )


# ----- EDIT PROJECT (SUBMIT CHANGES) -----
@app.route("/projects/edit/<int:pid>", methods=["POST"])
@login_required
def update_project(pid):
    title = request.form.get("title", "").strip()
    sdate_str = request.form.get("sdate")
    edate_str = request.form.get("edate")
    leader = request.form.get("leader")

    if not title or not sdate_str or not edate_str or not leader:
        flash("Title, start date, end date, and leader are required.", "error")
        return redirect(url_for("edit_project", pid=pid))

    try:
        sdate = datetime.strptime(sdate_str, "%Y-%m-%d").date()
        edate = datetime.strptime(edate_str, "%Y-%m-%d").date()
        eduration = (edate - sdate).days
    except ValueError:
        flash("Invalid date format.", "error")
        return redirect(url_for("edit_project", pid=pid))

    conn = get_db_connection()
    cur = conn.cursor()

    try:
        cur.execute(
            """
            UPDATE project
            SET title = %s,
                sdate = %s,
                edate = %s,
                eduration = %s,
                leader = %s
            WHERE pid = %s
            """,
            (title, sdate, edate, eduration, leader, pid),
        )
        conn.commit()
        flash("Project updated successfully.", "success")

    except Exception as e:
        conn.rollback()
        flash(f"Error updating project: {e}", "error")

    finally:
        cur.close()
        conn.close()

    return redirect(url_for("projects"))


# ----- EQUIPMENT: LIST -----
@app.route("/equipment")
@login_required
def equipment():
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)

    cur.execute("""
    SELECT eid, etype, ename, purpose, status, pdate
    FROM equipment
    ORDER BY eid
""")
    equipment_rows = cur.fetchall()

    cur.close()
    conn.close()

    return render_template("equipment.html", equipment=equipment_rows)


# ----- EQUIPMENT: ADD -----
@app.route("/equipment/add", methods=["POST"])
@login_required
def add_equipment():
    ename = request.form.get("ename", "").strip()
    etype = request.form.get("etype", "").strip()
    purpose = request.form.get("purpose", "").strip()
    status = request.form.get("status", "").strip()
    pdate = request.form.get("pdate")

    # Basic validation
    if not ename or not etype or not status or not pdate:
        flash("Name, type, status, and purchase date are required.", "error")
        return redirect(url_for("equipment"))

    conn = get_db_connection()
    cur = conn.cursor()

    try:
        cur.execute("""
            INSERT INTO equipment (ename, etype, purpose, status, pdate)
            VALUES (%s, %s, %s, %s, %s)
        """, (ename, etype, purpose, status, pdate))

        conn.commit()
        flash("Equipment added successfully.", "success")
    except Exception as e:
        conn.rollback()
        flash(f"Error adding equipment: {e}", "error")
    finally:
        cur.close()
        conn.close()

    return redirect(url_for("equipment"))

# ----- DELETE EQUIPMENT -----
@app.route("/equipment/delete/<int:eid>", methods=["POST"])
@login_required
def delete_equipment(eid):
    conn = get_db_connection()
    cur = conn.cursor()

    try:
        # Delete dependent uses rows
        cur.execute("DELETE FROM uses WHERE eid = %s", (eid,))

        # Delete from EQUIPMENT
        cur.execute("DELETE FROM equipment WHERE eid = %s", (eid,))

        conn.commit()
        flash("Equipment deleted successfully.", "success")

    except Exception as e:
        conn.rollback()
        flash(f"Error deleting equipment: {e}", "error")

    finally:
        cur.close()
        conn.close()

    return redirect(url_for("equipment"))

# ----- EDIT EQUIPMENT (SHOW FORM) -----
@app.route("/equipment/edit/<int:eid>", methods=["GET"])
@login_required
def edit_equipment(eid):
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)

    cur.execute("SELECT * FROM equipment WHERE eid = %s", (eid,))
    equipment = cur.fetchone()
    if not equipment:
        cur.close()
        conn.close()
        flash("Equipment not found.", "error")
        return redirect(url_for("equipment"))

    cur.close()
    conn.close()

    return render_template(
        "edit_equipment.html",
        equipment=equipment,
    )


# ----- EDIT EQUIPMENT (SUBMIT CHANGES) -----
@app.route("/equipment/edit/<int:eid>", methods=["POST"])
@login_required
def update_equipment(eid):
    etype = request.form.get("etype", "").strip()
    ename = request.form.get("ename", "").strip()
    purpose = request.form.get("purpose", "").strip()
    status = request.form.get("status", "").strip()
    pdate = request.form.get("pdate")  # may be empty

    if not etype or not ename or not status:
        flash("Equipment type, name, and status are required.", "error")
        return redirect(url_for("edit_equipment", eid=eid))

    conn = get_db_connection()
    cur = conn.cursor()

    try:
        cur.execute(
            """
            UPDATE equipment
            SET etype = %s,
                ename = %s,
                purpose = %s,
                status = %s,
                pdate = %s
            WHERE eid = %s
            """,
            (etype, ename, purpose or None, status, pdate or None, eid),
        )
        conn.commit()
        flash("Equipment updated successfully.", "success")

    except Exception as e:
        conn.rollback()
        flash(f"Error updating equipment: {e}", "error")

    finally:
        cur.close()
        conn.close()

    return redirect(url_for("equipment"))


# ----- GRANTS: LIST -----
@app.route("/grants")
@login_required
def grants():
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)

    cur.execute("""
        SELECT gid, source, budget, startdate, duration
        FROM grant_info
        ORDER BY gid
    """)
    grants = cur.fetchall()

    cur.close()
    conn.close()

    return render_template("grants.html", grants=grants)


# ----- GRANTS: ADD -----
@app.route("/grants/add", methods=["POST"])
@login_required
def add_grant():
    source = request.form.get("source", "").strip()
    budget_str = request.form.get("budget", "").strip()
    startdate = request.form.get("startdate")
    duration_str = request.form.get("duration", "").strip()

    # basic validation
    if not source or not budget_str or not startdate or not duration_str:
        flash("Source, budget, start date, and duration are required.", "error")
        return redirect(url_for("grants"))

    try:
        budget = float(budget_str)
    except ValueError:
        flash("Budget must be numeric.", "error")
        return redirect(url_for("grants"))

    try:
        duration = int(duration_str)
    except ValueError:
        flash("Duration must be an integer.", "error")
        return redirect(url_for("grants"))

    conn = get_db_connection()
    cur = conn.cursor()

    try:
        cur.execute("""
            INSERT INTO grant_info (source, budget, startdate, duration)
            VALUES (%s, %s, %s, %s)
        """, (source, budget, startdate, duration))

        conn.commit()
        flash("Grant added successfully.", "success")
    except Exception as e:
        conn.rollback()
        flash(f"Error adding grant: {e}", "error")
    finally:
        cur.close()
        conn.close()

    return redirect(url_for("grants"))

# ----- DELETE GRANT -----
@app.route("/grants/delete/<int:gid>", methods=["POST"])
@login_required
def delete_grant(gid):
    conn = get_db_connection()
    cur = conn.cursor()

    try:
        # Delete dependent funds rows
        cur.execute("DELETE FROM funds WHERE gid = %s", (gid,))

        # Delete from GRANT_INFO
        cur.execute("DELETE FROM grant_info WHERE gid = %s", (gid,))

        conn.commit()
        flash("Grant deleted successfully.", "success")

    except Exception as e:
        conn.rollback()
        flash(f"Error deleting grant: {e}", "error")

    finally:
        cur.close()
        conn.close()

    return redirect(url_for("grants"))

# ----- EDIT GRANT (SHOW FORM) -----
@app.route("/grants/edit/<int:gid>", methods=["GET"])
@login_required
def edit_grant(gid):
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)

    cur.execute("SELECT * FROM grant_info WHERE gid = %s", (gid,))
    grant = cur.fetchone()
    if not grant:
        cur.close()
        conn.close()
        flash("Grant not found.", "error")
        return redirect(url_for("grants"))

    cur.close()
    conn.close()

    return render_template(
        "edit_grant.html",
        grant=grant,
    )


# ----- EDIT GRANT (SUBMIT CHANGES) -----
@app.route("/grants/edit/<int:gid>", methods=["POST"])
@login_required
def update_grant(gid):
    source = request.form.get("source", "").strip()
    budget = request.form.get("budget")
    startdate = request.form.get("startdate")
    duration = request.form.get("duration")

    if not source or not budget or not startdate or not duration:
        flash("Source, budget, start date, and duration are required.", "error")
        return redirect(url_for("edit_grant", gid=gid))

    conn = get_db_connection()
    cur = conn.cursor()

    try:
        cur.execute(
            """
            UPDATE grant_info
            SET source = %s,
                budget = %s,
                startdate = %s,
                duration = %s
            WHERE gid = %s
            """,
            (source, budget, startdate, duration, gid),
        )
        conn.commit()
        flash("Grant updated successfully.", "success")

    except Exception as e:
        conn.rollback()
        flash(f"Error updating grant: {e}", "error")

    finally:
        cur.close()
        conn.close()

    return redirect(url_for("grants"))



# ----- PUBLICATIONS: LIST -----
@app.route("/publications")
@login_required
def publications():
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)

    # Matches your actual schema: pubid, title, venue, pdate, doi
    cur.execute("""
        SELECT pubid, title, venue, pdate, doi
        FROM publication
        ORDER BY pdate
    """)
    publications = cur.fetchall()

    cur.close()
    conn.close()

    return render_template("publications.html", publications=publications)


# ----- PUBLICATIONS: ADD -----
@app.route("/publications/add", methods=["POST"])
@login_required
def add_publication():
    title = request.form.get("title", "").strip()
    venue = request.form.get("venue", "").strip()
    pdate = request.form.get("pdate")  # HTML input will be named "pdate"
    doi = request.form.get("doi", "").strip() or None  # optional

    # Basic validation
    if not title or not venue or not pdate:
        flash("Title, venue, and publication date are required.", "error")
        return redirect(url_for("publications"))

    conn = get_db_connection()
    cur = conn.cursor()

    try:
        cur.execute("""
            INSERT INTO publication (title, venue, pdate, doi)
            VALUES (%s, %s, %s, %s)
        """, (title, venue, pdate, doi))

        conn.commit()
        flash("Publication added successfully.", "success")
    except Exception as e:
        conn.rollback()
        flash(f"Error adding publication: {e}", "error")
    finally:
        cur.close()
        conn.close()

    return redirect(url_for("publications"))

# ----- DELETE PUBLICATION -----
@app.route("/publications/delete/<int:pubid>", methods=["POST"])
@login_required
def delete_publication(pubid):
    conn = get_db_connection()
    cur = conn.cursor()

    try:
        # Delete dependent publish rows
        cur.execute("DELETE FROM publishes WHERE pid = %s", (pubid,))

        # Delete from PUBLICATION
        cur.execute("DELETE FROM publication WHERE pubid = %s", (pubid,))

        conn.commit()
        flash("Publication deleted successfully.", "success")

    except Exception as e:
        conn.rollback()
        flash(f"Error deleting publication: {e}", "error")

    finally:
        cur.close()
        conn.close()

    return redirect(url_for("publications"))

# ----- EDIT PUBLICATION (SHOW FORM) -----
@app.route("/publications/edit/<int:pubid>", methods=["GET"])
@login_required
def edit_publication(pubid):
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)

    cur.execute("SELECT * FROM publication WHERE pubid = %s", (pubid,))
    publication = cur.fetchone()
    if not publication:
        cur.close()
        conn.close()
        flash("Publication not found.", "error")
        return redirect(url_for("publications"))

    cur.close()
    conn.close()

    return render_template(
        "edit_publication.html",
        publication=publication,
    )


# ----- EDIT PUBLICATION (SUBMIT CHANGES) -----
@app.route("/publications/edit/<int:pubid>", methods=["POST"])
@login_required
def update_publication(pubid):
    title = request.form.get("title", "").strip()
    venue = request.form.get("venue", "").strip()
    pdate = request.form.get("pdate")
    doi = request.form.get("doi", "").strip()

    if not title or not venue or not pdate:
        flash("Title, venue, and publication date are required.", "error")
        return redirect(url_for("edit_publication", pubid=pubid))

    conn = get_db_connection()
    cur = conn.cursor()

    try:
        cur.execute(
            """
            UPDATE publication
            SET title = %s,
                venue = %s,
                pdate = %s,
                doi = %s
            WHERE pubid = %s
            """,
            (title, venue, pdate, doi or None, pubid),
        )
        conn.commit()
        flash("Publication updated successfully.", "success")

    except Exception as e:
        conn.rollback()
        flash(f"Error updating publication: {e}", "error")

    finally:
        cur.close()
        conn.close()

    return redirect(url_for("publications"))


# -----------------------
#   PUBLISHES: LIST + FORM
# -----------------------
@app.route("/publishes", methods=["GET"])
@login_required
def publishes():
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)

    # 1) Existing publish relationships for the table
    cur.execute("""
        SELECT p.mid,
               m.name AS member_name,
               p.pid,
               pub.title AS publication_title,
               p.sdate,
               p.edate,
               p.purpose
        FROM publishes p
        JOIN lab_member   m   ON p.mid = m.mid
        JOIN publication  pub ON p.pid = pub.pubid
        ORDER BY p.mid, p.pid;
    """)
    publishes_rows = cur.fetchall()

    # 2) Members for the "Member" dropdown
    cur.execute("""
        SELECT mid, name
        FROM lab_member
        ORDER BY mid;
    """)
    members = cur.fetchall()

    # 3) Publications for the "Publication" dropdown
    cur.execute("""
        SELECT pubid, title
        FROM publication
        ORDER BY pubid;
    """)
    papers = cur.fetchall()

    cur.close()
    conn.close()

    return render_template(
        "publishes.html",
        publishes=publishes_rows,
        members=members,
        papers=papers,
    )


# -----------------------
#   PUBLISHES: ADD
# -----------------------
@app.route("/publishes/add", methods=["POST"])
@login_required
def add_publish():
    mid = request.form.get("mid")
    pid = request.form.get("pid")
    sdate = request.form.get("sdate") or None
    edate = request.form.get("edate") or None
    purpose = request.form.get("purpose") or None

    if not mid or not pid:
        flash("Member and Publication are required.", "error")
        return redirect(url_for("publishes"))

    conn = get_db_connection()
    cur = conn.cursor()

    try:
        cur.execute("""
            INSERT INTO publishes (mid, pid, sdate, edate, purpose)
            VALUES (%s, %s, %s, %s, %s)
        """, (mid, pid, sdate, edate, purpose))

        conn.commit()
        flash("Publish entry added successfully!", "success")

    except Exception as e:
        conn.rollback()
        flash(f"Error adding publish record: {e}", "error")

    finally:
        cur.close()
        conn.close()

    return redirect(url_for("publishes"))

# ----- DELETE PUBLISH RELATIONSHIP -----
@app.route("/publishes/delete/<int:mid>/<int:pid>", methods=["POST"])
@login_required
def delete_publish(mid, pid):
    conn = get_db_connection()
    cur = conn.cursor()

    try:
        cur.execute(
            "DELETE FROM publishes WHERE mid = %s AND pid = %s",
            (mid, pid)
        )
        conn.commit()
        flash("Publish relationship deleted successfully.", "success")

    except Exception as e:
        conn.rollback()
        flash(f"Error deleting publish relationship: {e}", "error")

    finally:
        cur.close()
        conn.close()

    return redirect(url_for("publishes"))



# -----------------------
#   REPORTS
# -----------------------
@app.route("/reports", methods=["GET", "POST"])
@login_required
def reports():
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)

    # -------------------------------------------------------------------------
    # 1. Member(s) with highest number of publications
    # -------------------------------------------------------------------------
    cur.execute("""
        SELECT lm.mid,
               lm.name,
               COUNT(pb.pid) AS pub_count
        FROM lab_member lm
        LEFT JOIN publishes pb ON pb.mid = lm.mid
        GROUP BY lm.mid, lm.name
        ORDER BY lm.mid;
    """)
    pub_counts = cur.fetchall()

    max_count = max((row["pub_count"] for row in pub_counts), default=0)
    top_pub_members = [row for row in pub_counts if row["pub_count"] == max_count] if max_count else []

    # -------------------------------------------------------------------------
    # 2. Average # of student publications per major
    # -------------------------------------------------------------------------
    cur.execute("""
        SELECT s.major,
               COUNT(*) AS num_students,
               COALESCE(SUM(s.pub_count)::numeric / COUNT(*), 0) AS avg_pubs
        FROM (
            SELECT lm.mid,
                   lm.major,
                   COUNT(pb.pid) AS pub_count
            FROM lab_member lm
            LEFT JOIN publishes pb ON pb.mid = lm.mid
            WHERE lm.mtype = 'STUDENT'
            GROUP BY lm.mid, lm.major
        ) AS s
        GROUP BY s.major
        ORDER BY s.major;
    """)
    avg_pubs_per_major = cur.fetchall()

    # -------------------------------------------------------------------------
    # Grant dropdown list
    # -------------------------------------------------------------------------
    cur.execute("SELECT gid, source FROM grant_info ORDER BY gid;")
    grants = cur.fetchall()

    # -------------------------------------------------------------------------
    # Defaults for queries 3 & 4
    # -------------------------------------------------------------------------
    num_active_projects = None
    prolific_members = []
    selected_gid_active = None
    selected_start = None
    selected_end = None
    selected_gid_prolific = None

    # -------------------------------------------------------------------------
    # Handle POST forms
    # -------------------------------------------------------------------------
    if request.method == "POST":

        # =====================================================================
        # QUERY 3 — Active projects for selected grant and date range
        # =====================================================================
        if request.form.get("query_type") == "active_projects":
            selected_gid_active = request.form.get("gid_active")
            start_raw = request.form.get("start_active")
            end_raw = request.form.get("end_active")

            if selected_gid_active and start_raw and end_raw:
                try:
                    # HTML <input type="date"> gives YYYY-MM-DD
                    start_date = datetime.strptime(start_raw, "%Y-%m-%d").date()
                    end_date = datetime.strptime(end_raw, "%Y-%m-%d").date()

                    cur.execute("""
                        SELECT COUNT(*) AS count
                        FROM funds f
                        JOIN project p ON p.pid = f.pid
                        WHERE f.gid = %s
                          AND p.sdate <= %s
                          AND p.edate >= %s;
                    """, (selected_gid_active, end_date, start_date))

                    num_active_projects = cur.fetchone()["count"]

                except Exception as e:
                    print("Query 3 ERROR:", e)
                    num_active_projects = "Error"

        # =====================================================================
        # QUERY 4 — Top 3 most prolific members for selected grant
        # =====================================================================
        if request.form.get("query_type") == "top3":
            selected_gid_prolific = request.form.get("gid_prolific")

            if selected_gid_prolific:
                try:
                    cur.execute("""
                        WITH grant_members AS (
                            SELECT DISTINCT w.mid
                            FROM works w
                            JOIN funds f ON w.pid = f.pid
                            WHERE f.gid = %s
                        ),
                        pub_counts AS (
                            SELECT gm.mid,
                                   lm.name,
                                   COUNT(pb.pid) AS pub_count
                            FROM grant_members gm
                            JOIN lab_member lm ON gm.mid = lm.mid
                            LEFT JOIN publishes pb ON pb.mid = gm.mid
                            GROUP BY gm.mid, lm.name
                        )
                        SELECT mid, name, pub_count
                        FROM pub_counts
                        ORDER BY pub_count DESC, name
                        LIMIT 3;
                    """, (selected_gid_prolific,))

                    prolific_members = cur.fetchall()

                except Exception as e:
                    print("Query 4 ERROR:", e)
                    prolific_members = []

    # -------------------------------------------------------------------------
    # Cleanup
    # -------------------------------------------------------------------------
    cur.close()
    conn.close()

    return render_template(
        "reports.html",
        pub_counts=pub_counts,
        top_pub_members=top_pub_members,
        avg_pubs_per_major=avg_pubs_per_major,
        grants=grants,

        # Query 3 results
        num_active_projects=num_active_projects,
        selected_gid_active=selected_gid_active,
        selected_start=selected_start,
        selected_end=selected_end,

        # Query 4 results
        prolific_members=prolific_members,
        selected_gid_prolific=selected_gid_prolific,
    )

# ----------------- MAIN -----------------
if __name__ == "__main__":
    app.run(debug=True)
