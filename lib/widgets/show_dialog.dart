import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_portal/model/student_model.dart';
import 'package:student_portal/services/db_functions.dart';
import 'package:image_picker/image_picker.dart';

class StudentDialog {
  // delete dialog
  static Future<void> deletedialog(
    BuildContext context,
    StudentModel student,
  ) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete Student'),
            content: Text('Are you sure you want to delete ${student.name}?'),
            actions: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.cancel),
                label: Text('cancel'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  deleteStudent(student.id!);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Student removed'),
                    behavior: SnackBarBehavior.floating,
                  ));
                  Navigator.pop(context);
                },
                icon: Icon(Icons.delete),
                label: Text('Delete'),
              ),
            ],
          );
        });
  }

  // Add/Edit Dialog Function
  static Future<void> addeditdialoge(
    BuildContext context, {
    StudentModel? student,
    required ImagePicker picker,
    required Function(StudentModel) onUpdatestudent,
    required Function(StudentModel) onAdddatestudent,
  }) async {
    final formkey = GlobalKey<FormState>();

    // Pre-fill controllers based on the existing student data (if provided)
    final nameController = TextEditingController(text: student?.name ?? '');
    final ageController = TextEditingController(text: student?.age ?? '');
    final courseController = TextEditingController(text: student?.course ?? '');
    String? imagePath = student?.imagePath;

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(student == null ? 'Add Student' : 'Edit Student'),
              content: Form(
                key: formkey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final XFile? pickedFile = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (pickedFile != null) {
                            setState(() {
                              imagePath = pickedFile.path;
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: imagePath != null
                              ? FileImage(File(imagePath!))
                              : null,
                          child: imagePath == null
                              ? Icon(Icons.add_a_photo)
                              : null,
                        ),
                      ),
                      SizedBox(height: 16),
                      // Name Field
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a name';
                          }
                          if (value.length < 2) {
                            return 'Name should be at least 2 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      // Age Field
                      TextFormField(
                        controller: ageController,
                        decoration: InputDecoration(
                          labelText: 'Age',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your age';
                          }
                          final age = int.tryParse(value);
                          if (age == null) {
                            return 'Please enter a valid number';
                          }
                          if (age < 18) {
                            return 'Age cannot be less than 18';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      // Course Field
                      TextFormField(
                        controller: courseController,
                        decoration: InputDecoration(
                          labelText: 'Course',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a course';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                // Cancel Button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.cancel),
                  label: Text('Cancel'),
                ),
                // Save Button
                ElevatedButton.icon(
                  onPressed: () async {
                    if (formkey.currentState!.validate()) {
                      final newStudent = StudentModel(
                        id: student?.id, // Use existing ID for edits
                        name: nameController.text,
                        age: ageController.text,
                        course: courseController.text,
                        imagePath: imagePath,
                      );

                      if (student == null) {
                        // Add a new student
                        onAdddatestudent(newStudent);
                      } else {
                        // Update an existing student
                        onUpdatestudent(newStudent);
                      }

                      Navigator.pop(context); // Close the dialog

                      // Display a success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(student == null
                              ? 'Student added successfully'
                              : 'Student updated successfully'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.save),
                  label: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
