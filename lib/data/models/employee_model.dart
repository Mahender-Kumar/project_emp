import 'package:project_emp/data/models/jobs_model.dart';
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
  bool isCurrent;

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
      'hireDate': hireDate.toIso8601String(), // Convert DateTime to string
      'leavingDate': leavingDate?.toIso8601String(), // Nullable conversion
      'location': location,
      'isCurrent': isCurrent,
    };
  }

  // Create an Employee from a Map
  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'] ?? '',
      // position:sampleJobs.where(test) map['position'] ?? '',
      position:
          sampleJobs
              .firstWhere(
                (job) =>
                    job.id ==
                    map['position'], // Match job.id with map['position']
                orElse:
                    () => Job(
                      id: '1',
                      title: 'Flutter Developer',
                    ), // Return a default Job object
              )
              .title,

      department: map['department'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      salary: (map['salary'] as num?)?.toDouble(),
      hireDate: DateTime.parse(map['hireDate']), // Parse from ISO 8601 string
      leavingDate:
          map['leavingDate'] != null
              ? DateTime.parse((map['leavingDate']).toString())
              : null,
      location: map['location'] ?? '',
      isCurrent: map['isCurrent'] ?? true,
    );
  }

  Employee copyWith({
    String? name,
    String? position,
    DateTime? hireDate,
    DateTime? leavingDate,
    bool? isCurrent,
    String? department,
    String? email,
    String? phone,
    double? salary,
    String? location,
  }) {
    return Employee(
      id: id, // Keep the same ID
      name: name ?? this.name,
      position: position ?? this.position,
      hireDate: hireDate ?? this.hireDate,
      leavingDate: leavingDate ?? this.leavingDate,
      isCurrent: isCurrent ?? this.isCurrent,
      department: department ?? department,
      email: email ?? email,
      phone: phone ?? phone,
      salary: salary ?? salary,
      location: location ?? location,
    );
  }
}
