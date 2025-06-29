# SASSAM-Web
LNBTI Student Attendance Management System
 Student Attendance System – Setup Guide
🛠️ Prerequisites
Make sure you have the following installed on your machine:

Python 3.10+
MySQL Server (e.g., WAMP/XAMPP or standalone)
Git (optional)
Virtualenv (optional but recommended)
Django (5.x recommended)
MySQL client library (mysqlclient)

📁 Project Folder Structure
Student Attendance System/
│
├── Logins/
│   ├── manage.py
│   ├── env/ (virtual environment)
│   ├── appLogin/ (main Django app)
│   ├── templates/ (HTML files)
│   └── static/ (CSS/JS files)

⚙️ Project Setup Instructions
1. Clone or download the project
If using Git:
git clone https://github.com/your-repo/student-attendance-system.git
cd Logins

2. Create and activate a virtual environment
python -m venv env
env\Scripts\activate

3. Install required packages
pip install django mysqlclient

4. Configure your MySQL databas
Create a database (e.g., newdb) using MySQL Workbench or phpMyAdmin.
In settings.py, update the DATABASES section
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

5. Run migrations
python manage.py makemigrations
python manage.py migrate
If errors occur like "foreign key constraint fails", make sure referenced records (like Program, Semester) exist.

6. Create a superuser (optional)
python manage.py createsuperuser

7. Run the development server
python manage.py runserver
Access the site at: http://127.0.0.1:8000/

📋 Basic Usage (via Django Shell)
Open shell
python manage.py shell
Add Programs
from appLogin.models import Program
Program.objects.create(ProgramId="P001", ProgramName="Software Engineering")
Add Semesters
from appLogin.models import Semester
Semester.objects.create(SemesterId="S001", SemesterNo=1)
Add Batch
from appLogin.models import Batch
program = Program.objects.get(ProgramId="P001")
semester = Semester.objects.get(SemesterId="S001")
Batch.objects.create(BatchId="B001", BatchName="UOG03", ProgramId=program, SemesterId=semester)
Delete a record
Program.objects.get(ProgramId="P002").delete()
Exit the shell
exit()

🧩 Common Issues & Fixes
404 for output.css
Make sure you are correctly linking your static files in the HTML and running:
python manage.py collectstatic
And ensure in settings.py:
STATIC_URL = '/static/'
STATICFILES_DIRS = [BASE_DIR / "static"]

🔐 Login Logic

Admins login with is_staff=True → redirected to home.html

Lecturers login → redirected to lecturer.html
Form processing is handled in postsign() view.

📄 Useful Django Commands
Command	Purpose
python manage.py runserver	Start dev server
python manage.py migrate	Apply database migrations
python manage.py makemigrations	Create migration files
python manage.py createsuperuser	Create admin user
python manage.py shell	Open Python shell with Django loaded
python manage.py collectstatic	Collect static files

✅ Summary
This document helps new developers:
Set up the environment
Configure MySQL
Use Django shell to create and manage data
Understand structure and run the server
