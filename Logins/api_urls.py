# app/api_urls.py
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import api

router = DefaultRouter()
router.register(r'programs', api.ProgramViewSet)
router.register(r'batches', api.BatchViewSet)
router.register(r'semesters', api.SemesterViewSet)
router.register(r'modules', api.ModuleViewSet)
router.register(r'lectures', api.LectureViewSet)
router.register(r'students', api.StudentViewSet)

urlpatterns = [
    path('', include(router.urls)),
]
