class Employee {
  final String id;
  final String name;
  final String position;
  final String department;
  final String email;
  final String phone;
  final double salary;
  final DateTime hireDate;
  final String location;

  Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.department,
    required this.email,
    required this.phone,
    required this.salary,
    required this.hireDate,
    required this.location,
  });

  // Convert Employee object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'department': department,
      'email': email,
      'phone': phone,
      'salary': salary,
      'hireDate': hireDate.toIso8601String(),
      'location': location,
    };
  }

  // Create Employee object from JSON
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      department: json['department'],
      email: json['email'],
      phone: json['phone'],
      salary: (json['salary'] as num).toDouble(),
      hireDate: DateTime.parse(json['hireDate']),
      location: json['location'],
    );
  }
}
 