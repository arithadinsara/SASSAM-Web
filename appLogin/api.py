# app/api.py

from rest_framework import viewsets
from .models import Program, Batch, Semester, Module, Lecture, Student,Absence
from .serializers import ProgramSerializer, BatchSerializer, SemesterSerializer, ModuleSerializer, LectureSerializer, StudentSerializer, AbsenceSerializer
from django.http import JsonResponse
from .models import Program, Batch, Semester, Module, Lecture, Student

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

class AbsenceViewSet(viewsets.ModelViewSet):
    queryset = Absence.objects.all()
    serializer_class = AbsenceSerializer

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

def fetch_students(request):
    batch_id = request.GET.get('batch_id')
    students = Student.objects.filter(BatchId=batch_id)
    student_data = [{"StudentId": student.StudentId, "StudentName": student.StudentName} for student in students]
    return JsonResponse({"students": student_data})