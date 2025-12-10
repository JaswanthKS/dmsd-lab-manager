# 📚 Research Lab Manager – Flask + PostgreSQL

A full-stack web application for managing research members, projects, equipment, grants, publications, and analytical reports.  
Built with **Flask**, **PostgreSQL**, **HTML/CSS**, and **Jinja2 templates**.

---

## 🚀 Features

### 👥 Member Management
- Add, edit, delete **Students**, **Faculty**, and **Collaborators**
- Subtype handling (student/faculty/collaborator tables)
- Safe delete by clearing dependent tables first

### 🗂 Project Management
- Create/edit/delete projects
- Assign project leaders
- Auto-duration calculation
- Fund projects using grants

### 🧪 Equipment Management
- Track type, name, purpose, status, purchase date
- Status values supported:
  - `AVAILABLE`
  - `IN_USE`
  - `OUT_OF_SERVICE`
  - `RETIRED`

### 💰 Grant Management
- Add grants
- Track budget, start date, duration
- Used in reporting queries

### 📑 Publication Management
- Add publications
- Add member ↔ publication relationships (publishes table)

### 📊 Reporting (4 Required Queries)
1. Members with highest publication count  
2. Average number of student publications by major  
3. Projects funded by a grant and active in a date range  
4. Top 3 most prolific members for projects funded by a grant  

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|------------|
| Backend | Flask |
| Database | PostgreSQL |
| Templates | Jinja2 |
| Frontend | HTML5, CSS3 |
| Authentication | Session-based login |

---

## 📦 Project Structure

```
DMSD Project/
│── app.py
│── requirements.txt
│── README.md
│── /templates
│     ├── dashboard.html
│     ├── members.html
│     ├── edit_member.html
│     ├── projects.html
│     ├── equipment.html
│     ├── grants.html
│     ├── publications.html
│     ├── publishes.html
│     ├── reports.html
│── /static
└── venv/   (ignored using .gitignore)
```

---

## ⚙️ Installation & Setup

### 1️⃣ Clone the Repository

```bash
git clone <your_repo_link>
cd "DMSD Project"
```

### 2️⃣ Create Virtual Environment

```bash
python -m venv venv
source venv/Scripts/activate   # Windows
```

### 3️⃣ Install Dependencies

```bash
pip install -r requirements.txt
```

### 4️⃣ Setup PostgreSQL Database

Create database:

```sql
CREATE DATABASE research_lab;
```

Apply corrected equipment status constraint:

```sql
ALTER TABLE equipment
DROP CONSTRAINT equipment_status_check,
ADD CONSTRAINT equipment_status_check
CHECK (status IN ('AVAILABLE','IN_USE','OUT_OF_SERVICE','RETIRED'));
```

### 5️⃣ Run Flask App

```bash
python app.py
```

Open in browser:

```
http://127.0.0.1:5000/
```

---

## 🧾 Notes

### ✔ Safe Delete Logic
Before deleting a member, system deletes rows from:
- student  
- faculty  
- collaborator  
- works  
- uses  
- publishes  

This prevents FK violations.

### ✔ Equipment Status Fix
Updated CHECK constraint allows all four UI statuses.

### ✔ Reports
All 4 SQL report queries implemented using:
- Joins  
- Aggregations  
- Grouping  
- Date comparisons  
- Parameterized queries  

---

## 🧪 Testing Checklist

### CRUD Tests
- Add/Edit/Delete Member  
- Add/Delete Project  
- Add/Delete Equipment  
- Add/Delete Grant  
- Add/Delete Publication  
- Add/Delete Publish relation  

### Report Tests
- Add 3 publications → appears in Query 1  
- Add students in multiple majors → Query 2  
- Funded projects + date range → Query 3  
- Add multiple publishes under one grant → Query 4  

---

## 🏁 Final Deliverable Summary

This project completes **Phase 3 – Application Development**:

- Fully functional Flask + PostgreSQL application  
- CRUD for all entities  
- Complex SQL reporting  
- Schema correction documented  
- Clean UI with dark theme  

---

## 📄 License

Academic use for NJIT DMSD coursework.

