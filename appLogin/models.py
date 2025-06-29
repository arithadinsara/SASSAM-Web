from django.db import models

class Program(models.Model):
    ProgramId = models.CharField(max_length=10, primary_key=True)
    ProgramName = models.CharField(max_length=50)

    def __str__(self):
        return self.ProgramName
    
class Semester(models.Model):
    SemesterId = models.CharField(max_length=10, primary_key=True)
    SemesterNo = models.IntegerField() 

    def __str__(self):
        return str(self.SemesterNo)

class Batch(models.Model):
    BatchId = models.CharField(max_length=10, primary_key=True)
    BatchName = models.CharField(max_length=50)
    ProgramId = models.ForeignKey(Program, on_delete=models.CASCADE)
    SemesterId = models.ForeignKey(Semester, on_delete=models.CASCADE)

    def __str__(self):
        return self.BatchName

class Module(models.Model):
    ModuleId = models.CharField(max_length=10, primary_key=True)
    ModuleName = models.CharField(max_length=100)
    SemesterId = models.ForeignKey(Semester, on_delete=models.CASCADE)

    def __str__(self):
        return self.ModuleName

class Lecture(models.Model):
    LectureId = models.CharField(max_length=10, primary_key=True)
    LectureNumber = models.IntegerField()
    LecturerName = models.CharField(max_length=100)
    ModuleId = models.ForeignKey(Module, on_delete=models.CASCADE)

    def __str__(self):
        return f"Lecture {self.LectureNumber} by {self.LecturerName}"

from django.db import models



class Student(models.Model):
    StudentId = models.CharField(max_length=20, primary_key=True)
    StudentName = models.CharField(max_length=100)
    BatchId = models.ForeignKey(Batch, on_delete=models.CASCADE)

    def __str__(self):
        return self.StudentName
    
class Absence(models.Model):
    AbsenceId = models.CharField(primary_key=True, max_length=10, unique=True)
    AbsenceDate = models.FloatField(default=1.0)
    StudentId = models.ForeignKey(Student, on_delete=models.CASCADE, db_column='student_id')
    LectureId_id = models.ForeignKey(Lecture, on_delete=models.CASCADE, db_column='lecture_id')

    def __str__(self):
        return f"Absence {self.AbsenceId} for {self.LectureId}"

    def save(self, *args, **kwargs):
        if not self.AbsenceId:
            last_absence = Absence.objects.all().order_by('AbsenceId').last()
            if last_absence:
                last_id = int(last_absence.AbsenceId[2:])  # Remove 'AB' and get the integer part
                new_id = f"AB{last_id + 1:03d}"
            else:
                new_id = "AB001"
            self.AbsenceId = new_id
        super(Absence, self).save(*args, **kwargs)

class Meta:
        db_table = 'applogin_absence'  # Explicitly tell Django the table name