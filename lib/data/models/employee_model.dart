import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_emp/data/enum/status.dart';
import 'package:uuid/uuid.dart';

class Employee {
  final String? id;
  String name;
  String position;
  String? department;
  String? email;
  String? phone;
  double? salary;
  DateTime hireDate;
  DateTime? leavingDate;
  String? location;
  final bool isCurrent;

  Employee({
    String? id,
    required this.name,
    required this.position,
    this.department,
    this.email,
    this.phone,
    this.salary,
    required this.hireDate,
    this.leavingDate,
    this.location,
    required this.isCurrent,
  }) : id = id ?? const Uuid().v4();

  // Getter for status

  // Convert an Employee to a Map (for storing in Firestore or local storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'department': department,
      'email': email,
      'phone': phone,
      'salary': salary,
      'hireDate': hireDate,
      'leavingDate': leavingDate,
      'location': location,
      'isCurrent': isCurrent,
    };
  }

  // Create an Employee from a Map
  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'] ?? '',
      position: map['position'] ?? '',
      department: map['department'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      salary: (map['salary'] as num?)?.toDouble(),
      hireDate: (map['hireDate'] ?? Timestamp.now()).toDate(),
      leavingDate:
          map['leavingDate'] != null
              ? (map['leavingDate']?.toDate() ?? Timestamp.now()).toDate()
              : null,
      location: map['location'] ?? '',
      isCurrent: map['isCurrent'],
    );
  }
}
