import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_portal/model/student_model.dart';
import 'package:student_portal/services/db_functions.dart';
import 'package:student_portal/widgets/show_dialog.dart';

class DetailScreen extends StatelessWidget {
  final String name;
  final String age;
  final String course;
  final String? images;
  final StudentModel student;
  final ImagePicker picker = ImagePicker();

  DetailScreen(
      {required this.name,
      required this.age,
      required this.course,
      this.images,
      required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
              onPressed: () {
                StudentDialog.addeditdialoge(context,
                    student: student,
                    picker: picker,
                    onAdddatestudent: addStudentData,
                    onUpdatestudent: (updateStudent) {
                  updateStudents(updateStudent);
                  Navigator.pop(context);
                });
              },
              icon: Icon(Icons.edit))
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          CircleAvatar(
              radius: 50,
              backgroundImage: images != null
                  ? FileImage(File(images!))
                  : null, // Replace with an image source if available
              child: images == null ? Icon(Icons.person) : null),
          SizedBox(
            height: 20,
          ),
          Text('Name : $name'),
          SizedBox(
            height: 20,
          ),
          Text('Age : $age'),
          SizedBox(
            height: 20,
          ),
          Text('Course : $course'),
        ]),
      ),
    );
  }
}
