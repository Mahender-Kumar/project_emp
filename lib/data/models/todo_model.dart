import 'package:uuid/uuid.dart';

class Employee {
  final String? id;
  String name;
  String position;
  String department;
  String email;
  String phone;
  double salary;
  DateTime hireDate;
  String location;

  Employee({
    this.id,
    required this.name,
    required this.position,
    required this.department,
    required this.email,
    required this.phone,
    required this.salary,
    required this.hireDate,
    required this.location,
  });

  // Convert a Todo to a Map (for storing in Firestore or local storage)
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'id': id ?? const Uuid().v4(),
      'name': name,
      'position': position,
      'department': department,
      'email': email,
      'phone': phone,
      'salary': salary,
      'hireDate': hireDate.toIso8601String(),
      'location': location,
    };

    return map;
  }

  // Create a Todo from a Map
  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      position: map['position'],
      department: map['department'],
      email: map['email'],
      phone: map['phone'],
      salary: (map['salary'] as num).toDouble(),
      hireDate: DateTime.parse(map['hireDate']),
      location: map['location'],
    );
  }
}
