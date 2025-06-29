import json
from django.shortcuts import render, redirect
from django.http import JsonResponse, HttpResponse
from django.contrib.auth import authenticate
from rest_framework import viewsets
from .models import Program, Batch, Semester, Module, Lecture, Student, Absence
from .serializers import ProgramSerializer, BatchSerializer, SemesterSerializer, ModuleSerializer, LectureSerializer, StudentSerializer
from django.views.decorators.csrf import csrf_exempt
# Render views
def LoginPage(request):
    return render(request, 'login.html')

def index(request):
    return render(request, 'index.html')

def get_report(request):
    return render(request, 'attendancereport.html')

def HomePage(request):
    return render(request, 'home.html')

def HelpPage(request):
    return render(request, 'help_page.html')

def Contact(request):
    return render(request, 'contact_page.html')

def LecturerPage(request):
    return render(request, 'lecturer.html')

def Attendance(request):
    return render(request, 'attendance.html')

def postsign(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        user = authenticate(request, username=username, password=password)
        if user is not None:
            if user.is_staff:
                return redirect('home')
            else:
                return redirect('lecturer')
        else:
            return HttpResponse("Invalid credentials")
    return render(request, 'login.html')

def students_list(request):
    batch_id = request.GET.get('batchId')
    lecturer_name = request.GET.get('lecturerName')
    lecture_number = request.GET.get('lectureNumber')
    module_name = request.GET.get('moduleName')
    semester = request.GET.get('semester')

    students = Student.objects.all()

    if batch_id:
        students = students.filter(BatchId=batch_id)

    lecture_id = None
    if lecture_number and lecturer_name and module_name:
        try:
            module = Module.objects.get(ModuleName=module_name)
            lecture = Lecture.objects.get(
                LectureNumber=lecture_number,
                LecturerName=lecturer_name,
                ModuleId=module.ModuleId
            )
            lecture_id = lecture.LectureId
        except (Lecture.DoesNotExist, Module.DoesNotExist):
            lecture_id = 'Not found'

    return render(request, 'students_list.html', {
        'students': students,
        'batch_id': batch_id,
        'lecturer_name': lecturer_name,
        'lecture_number': lecture_number,
        'module_name': module_name,
        'semester': semester,
        'lecture_id': lecture_id
    })
@csrf_exempt
def submit_attendance(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            attendance_records = data.get('attendance', [])

            for record in attendance_records:
                student_id = record.get('student_id')
                lecture_id = record.get('lecture_id')
                absence_duration = record.get('absence_duration')

                student = Student.objects.get(StudentId=student_id)
                lecture = Lecture.objects.get(LectureId=lecture_id)

                # Update or create absence record with AbsenceDate as absence_duration
                Absence.objects.update_or_create(
                    StudentId=student,
                    LectureId_id=lecture,
                    defaults={'AbsenceDate': absence_duration}  # Set absence duration as AbsenceDate
                )

            return JsonResponse({'status': 'success', 'message': 'Attendance submitted successfully'})
        except Exception as e:
            return JsonResponse({'status': 'failed', 'message': str(e)})
    return JsonResponse({'status': 'failed', 'message': 'Invalid request method'})


def attendance_chart(request):
    students = Student.objects.all()
    data = {}

    for student in students:
        absences = Absence.objects.filter(StudentId=student)
        total_absences = sum([absence.AbsenceDate for absence in absences])  # Summing absence values
        attendance_percentage = (total_absences * 100)  # Assuming 100% is max, subtract absences
        data[student.StudentName] = {
            'attendance_percentage': attendance_percentage,
            'absences': total_absences
        }

    return render(request, 'attendance_chart.html', {
        'student_data': data,
    })

# API views
class ProgramViewSet(viewsets.ModelViewSet):
    queryset = Program.objects.all()
    serializer_class = ProgramSerializer

class BatchViewSet(viewsets.ModelViewSet):
    queryset = Batch.objects.all()
    serializer_class = BatchSerializer

class SemesterViewSet(viewsets.ModelViewSet):
    queryset = Semester.objects.all()
    serializer_class = SemesterSerializer

class ModuleViewSet(viewsets.ModelViewSet):
    queryset = Module.objects.all()
    serializer_class = ModuleSerializer

class LectureViewSet(viewsets.ModelViewSet):
    queryset = Lecture.objects.all()
    serializer_class = LectureSerializer

class StudentViewSet(viewsets.ModelViewSet):
    queryset = Student.objects.all()
    serializer_class = StudentSerializer

# Function-based API views
def fetch_programs(request):
    programs = list(Program.objects.values('ProgramId', 'ProgramName'))
    return JsonResponse({'programs': programs})

def fetch_batches(request):
    program_id = request.GET.get('program_id')
    batches = list(Batch.objects.filter(ProgramId=program_id).values('BatchId', 'BatchName'))
    return JsonResponse({'batches': batches})

def fetch_semester(request):
    batch_id = request.GET.get('batch_id')
    if batch_id:
        try:
            batch = Batch.objects.get(BatchId=batch_id)
            semester = batch.SemesterId
            return JsonResponse({
                'semesterId': semester.SemesterId,
                'semesterNo': semester.SemesterNo
            })
        except (Batch.DoesNotExist, Semester.DoesNotExist):
            return JsonResponse({'semesterNo': None})
    return JsonResponse({'semesterNo': None})

def fetch_modules(request):
    batch_id = request.GET.get('batch_id')
    if batch_id:
        try:
            batch = Batch.objects.get(BatchId=batch_id)
            semester_id = batch.SemesterId.SemesterId
            modules = Module.objects.filter(SemesterId=semester_id).values('ModuleId', 'ModuleName')
            return JsonResponse({'modules': list(modules)})
        except Batch.DoesNotExist:
            return JsonResponse({'modules': []})
    return JsonResponse({'modules': []})

def fetch_lecturer_name(request):
    module_id = request.GET.get('module_id')
    if module_id:
        try:
            lecture = Lecture.objects.get(ModuleId=module_id)
            lecturer_name = lecture.LecturerName
            return JsonResponse({'lecturerName': lecturer_name})
        except Lecture.DoesNotExist:
            return JsonResponse({'lecturerName': None})
    return JsonResponse({'lecturerName': None})

def fetch_lecture_number(request):
    module_id = request.GET.get('module_id')
    if module_id:
        try:
            lecture = Lecture.objects.get(ModuleId=module_id)
            return JsonResponse({'lectureNumber': lecture.LectureNumber})
        except Lecture.DoesNotExist:
            return JsonResponse({'lectureNumber': None})
    return JsonResponse({'lectureNumber': None})

def QRCodePage(request):
    batch_id = request.GET.get('batchId')
    lecturer_name = request.GET.get('lecturerName')
    lecture_number = request.GET.get('lectureNumber')
    module_name = request.GET.get('moduleName')
    semester = request.GET.get('semester')
    
    students = Student.objects.filter(BatchId=batch_id)
    student_data = [{"StudentId": student.StudentId, "StudentName": student.StudentName} for student in students]
    
    context = {
        'batchId': batch_id,
        'lecturerName': lecturer_name,
        'lectureNumber': lecture_number,
        'moduleName': module_name,
        'semester': semester,
        'students': student_data
    }
    
    return render(request, 'qr_code_page.html', context)

def fetch_students(request):
    batch_id = request.GET.get('batch_id')
    batch = Batch.objects.get(BatchId=batch_id)
    students = Student.objects.filter(BatchId=batch)
    
    student_data = [{'id': student.StudentId, 'name': student.StudentName} for student in students]
    
    return JsonResponse({'students': student_data})
