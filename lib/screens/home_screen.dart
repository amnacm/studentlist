import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:student_portal/model/student_model.dart';
import 'package:student_portal/screens/detailscrn.dart';
import 'package:student_portal/services/db_functions.dart';
import 'package:student_portal/widgets/show_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isGridview = false;
  final ImagePicker _picker = ImagePicker();
  String? imagePath;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  bool isSearchActive = false; // Flag to toggle search mode

  @override
  Widget build(BuildContext context) {
    getAllStudent(); // Make sure to fetch students data
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        title: isSearchActive
            ? SizedBox(
                width: 200,
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          searchQuery = "";
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              )
            : const Text(
                'Student List',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearchActive = !isSearchActive; // Toggle search mode
                if (!isSearchActive) {
                  searchController
                      .clear(); // Clear search text when exiting search mode
                  searchQuery = "";
                }
              });
            },
            icon: Icon(isSearchActive ? Icons.close : Icons.search),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isGridview = !isGridview; // Toggle between grid and list view
              });
            },
            icon: Icon(isGridview ? Icons.list : Icons.grid_view),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: studentListNotifier,
        builder: (context, List<StudentModel> students, child) {
          // Filter the students based on the search query
          List<StudentModel> filteredStudents = students
              .where((student) => student.name
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
              .toList();

          // Conditionally choose between ListView and GridView
          return isSearchActive || searchQuery.isNotEmpty
              ? (isGridview
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2.0, // Horizontal spacing
                        mainAxisSpacing: 2.0, // Vertical spacing
                      ),
                      itemCount: filteredStudents.length,
                      itemBuilder: (context, index) {
                        final data = filteredStudents[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                  student: data,
                                  name: data.name,
                                  age: data.age,
                                  course: data.course,
                                  images: data.imagePath,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: data.imagePath != null
                                      ? FileImage(File(data.imagePath!))
                                      : null,
                                  child: data.imagePath == null
                                      ? Icon(Icons.person)
                                      : null,
                                ),
                                SizedBox(height: 10),
                                Text(data.name),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      itemCount: filteredStudents.length,
                      itemBuilder: (context, index) {
                        final data = filteredStudents[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                  student: data,
                                  name: data.name,
                                  age: data.age,
                                  course: data.course,
                                  images: data.imagePath,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: data.imagePath != null
                                    ? FileImage(File(data.imagePath!))
                                    : null,
                                child: data.imagePath == null
                                    ? Icon(Icons.person)
                                    : null,
                              ),
                              title: Text(data.name),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () =>
                                    StudentDialog.deletedialog(context, data),
                              ),
                            ),
                          ),
                        );
                      },
                    ))
              : (isGridview
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2.0, // Horizontal spacing
                        mainAxisSpacing: 2.0, // Vertical spacing
                      ),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final data = students[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                  student: data,
                                  name: data.name,
                                  age: data.age,
                                  course: data.course,
                                  images: data.imagePath,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: data.imagePath != null
                                      ? FileImage(File(data.imagePath!))
                                      : null,
                                  child: data.imagePath == null
                                      ? Icon(Icons.person)
                                      : null,
                                ),
                                SizedBox(height: 10),
                                Text(data.name),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final data = students[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                  student: data,
                                  name: data.name,
                                  age: data.age,
                                  course: data.course,
                                  images: data.imagePath,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: data.imagePath != null
                                    ? FileImage(File(data.imagePath!))
                                    : null,
                                child: data.imagePath == null
                                    ? Icon(Icons.person)
                                    : null,
                              ),
                              title: Text(data.name),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () =>
                                    StudentDialog.deletedialog(context, data),
                              ),
                            ),
                          ),
                        );
                      },
                    ));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          StudentDialog.addeditdialoge(context,
              picker: _picker,
              onAdddatestudent: addStudentData,
              onUpdatestudent: updateStudents);
        },
        icon: Icon(Icons.add),
        label: Text('Add Student'),
      ),
    );
  }
}
