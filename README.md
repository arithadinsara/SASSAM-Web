# 🎓 Student Attendance System – Setup Guide

## 🛠️ Prerequisites

Ensure the following are installed on your machine:

- Python 3.10+
- MySQL Server (WAMP/XAMPP or standalone)
- Git *(optional)*
- Virtualenv *(optional but recommended)*
- Django *(version 5.x recommended)*
- MySQL client library (`mysqlclient`)

---

## 📁 Project Folder Structure

Student Attendance System/
│
├── Logins/
│ ├── manage.py
│ ├── env/ # Virtual environment
│ ├── appLogin/ # Main Django app
│ ├── templates/ # HTML templates
│ └── static/ # CSS/JS static files

yaml
Copy
Edit

---

## ⚙️ Project Setup Instructions

### 1. Clone or Download the Project

Using Git:

```bash
git clone https://github.com/your-repo/student-attendance-system.git
cd student-attendance-system/Logins
2. Create and Activate Virtual Environment
bash
Copy
Edit
python -m venv env
# On Windows:
env\Scripts\activate
# On macOS/Linux:
source env/bin/activate
3. Install Required Packages
bash
Copy
Edit
pip install django mysqlclient
4. Configure MySQL Database
Create a database (e.g., newdb) using MySQL Workbench or phpMyAdmin.

Update Logins/settings.py:

python
Copy
Edit
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'newdb',
        'USER': 'root',
        'PASSWORD': '',
        'HOST': 'localhost',
        'PORT': '3306',
    }
}
5. Run Migrations
bash
Copy
Edit
python manage.py makemigrations
python manage.py migrate
⚠️ If you encounter errors like "foreign key constraint fails", make sure related records (e.g., Program, Semester) exist.

6. Create Superuser (Optional)
bash
Copy
Edit
python manage.py createsuperuser
7. Run the Development Server
bash
Copy
Edit
python manage.py runserver
Visit: http://127.0.0.1:8000/

📋 Basic Usage (Using Django Shell)
Open the shell:

bash
Copy
Edit
python manage.py shell
Add Programs:
python
Copy
Edit
from appLogin.models import Program
Program.objects.create(ProgramId="P001", ProgramName="Software Engineering")
Add Semesters:
python
Copy
Edit
from appLogin.models import Semester
Semester.objects.create(SemesterId="S001", SemesterNo=1)
Add Batch:
python
Copy
Edit
from appLogin.models import Batch
program = Program.objects.get(ProgramId="P001")
semester = Semester.objects.get(SemesterId="S001")
Batch.objects.create(BatchId="B001", BatchName="UOG03", ProgramId=program, SemesterId=semester)
Delete a Record:
python
Copy
Edit
Program.objects.get(ProgramId="P002").delete()
Exit the shell:

python
Copy
Edit
exit()
🧩 Common Issues & Fixes
❌ 404 Error for output.css
Ensure you're linking static files properly in HTML.

Run the following command:

bash
Copy
Edit
python manage.py collectstatic
Check settings.py:

python
Copy
Edit
STATIC_URL = '/static/'
STATICFILES_DIRS = [BASE_DIR / "static"]
🔐 Login Logic
Admin users (is_staff=True) → redirected to home.html.

Lecturers → redirected to lecturer.html.

Form processing is handled in the postsign() view.

📄 Useful Django Commands
Command	Purpose
python manage.py runserver	Start development server
python manage.py migrate	Apply database migrations
python manage.py makemigrations	Create migration files
python manage.py createsuperuser	Create admin user
python manage.py shell	Open Django Python shell
python manage.py collectstatic	Collect static files

✅ Summary
This guide helps developers:

Set up the Python & Django environment

Configure MySQL database

Use Django shell for data manipulation

Understand project structure

Run and access the development server
