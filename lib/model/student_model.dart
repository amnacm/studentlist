class StudentModel {
  int? id;
  final String name;
  final String age;
  final String course;
  final String? imagePath;

  StudentModel({
    this.id,
    required this.name,
    required this.age,
    required this.course,
    this.imagePath,
  });

  static StudentModel fromMap(Map<String, Object?> map) {
    final id = map['id'] as int;
    final name = map['name'] as String;
    final age = map['age'] as String;
    final course = map['course'] as String;
    final imagePath = map['imagePath'] as String?;

    return StudentModel(
        id: id, name: name, age: age, course: course, imagePath: imagePath);
  }
}
