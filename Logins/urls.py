from django.contrib import admin
from django.urls import path, include
from appLogin import views
from django.contrib.staticfiles.urls import staticfiles_urlpatterns

from appLogin.api_urls import urlpatterns as api_urlpatterns

urlpatterns = [
    path('admin/', admin.site.urls),
    path('login/', views.LoginPage, name='login'),
    path('postsign/', views.postsign, name='postsign'),
    path('home/', views.HomePage, name='home'),
    path('help/', views.HelpPage, name='help'),
    path('contact/', views.Contact, name='contact'),
    path('attendance/', views.Attendance, name='attendance'),
    path('lecturer/', views.LecturerPage, name='lecturer'),
    path('students_list/', views.students_list, name='students_list'),
    path('fetch_programs/', views.fetch_programs, name='fetch_programs'),
    path('fetch_batches/', views.fetch_batches, name='fetch_batches'),
    path('fetch_semester/', views.fetch_semester, name='fetch_semester'),
    path('fetch_modules/', views.fetch_modules, name='fetch_modules'),
    path('fetch_lecturer_name/', views.fetch_lecturer_name, name='fetch_lecturer_name'),
    path('fetch_lecture_number/', views.fetch_lecture_number, name='fetch_lecture_number'),
    path('fetch_students/', views.fetch_students, name='fetch_students'),
    path('get_report/', views.get_report, name='get_report'),
    path('api/attendance/', views.submit_attendance, name='submit_attendance'), 
   
    path('api/', include('appLogin.api_urls')),
    path('', views.index, name='index'),
     path('attendance-chart/', views.attendance_chart, name='attendance_chart'),
]

urlpatterns += staticfiles_urlpatterns()
