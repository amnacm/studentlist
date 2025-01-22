import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student_portal/model/student_model.dart';

ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);

late Database _db;

Future<void> getdatabase() async {
  _db = await openDatabase(
    'student',
    version: 1,
    onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE student (id INTEGER PRIMARY KEY,name TEXT,age TEXT,course TEXT,imagePath TEXT)');
    },
  );
}

Future<void> addStudentData(StudentModel value) async {
  await _db.rawInsert(
      'INSERT INTO student(name, age, course,imagePath) VALUES(?, ?, ?, ?)',
      [value.name, value.age, value.course, value.imagePath]);
  await getAllStudent();
}

Future<void> getAllStudent() async {
  final List<Map<String, dynamic>> value =
      await _db.rawQuery('SELECT * FROM student ');
  studentListNotifier.value.clear();
  for (var map in value) {
    final students = StudentModel.fromMap(map);
    studentListNotifier.value.add(students);
  }
  studentListNotifier.notifyListeners();
}

Future<void> updateStudents(StudentModel updatedStudent) async {
  await _db.rawUpdate(
    'UPDATE student SET name = ?, age = ?, course = ?,imagePath = ?  WHERE id = ?',
    [
      updatedStudent.name,
      updatedStudent.age,
      updatedStudent.course,
      updatedStudent.imagePath,
      updatedStudent.id
    ],
  );
  await getAllStudent();
}

Future<void> deleteStudent(int id) async {
  await _db.rawDelete('DELETE FROM student WHERE id = ? ', [id]);
  studentListNotifier.value.removeWhere((student) => student.id == id);
  studentListNotifier.notifyListeners();
}
