class Job {
  final String id;
  final String title;

  String? location;
  String? description;
  final String? employmentType;
  double? salary;
  String? contactEmail;

  Job({
    required this.id,
    required this.title,

    this.location,
    this.description,
    this.employmentType,
    this.salary,
    this.contactEmail,
  });

  // Convert Job object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,

      'location': location,
      'description': description,
      'employmentType': employmentType,
      'salary': salary,
      'contactEmail': contactEmail,
    };
  }

  // Create Job object from JSON
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      title: json['title'],

      location: json['location'],
      description: json['description'],
      employmentType: json['employmentType'],
      salary: (json['salary'] as num).toDouble(),

      contactEmail: json['contactEmail'],
    );
  }
}

// Sample jobs
List<Job> sampleJobs = [
  Job(
    id: '1',
    title: 'Flutter Developer',
    location: 'Bangalore, India',
    description: 'Develop and maintain Flutter applications.',
    employmentType: 'Full-time',
    salary: 80000.0,
    contactEmail: 'hr@techinnovations.com',
  ),

  Job(
    id: '5',
    title: 'Product Designer',
    location: 'Delhi, India',
    description: 'Design intuitive and engaging digital products.',
    employmentType: 'Full-time',
    salary: 75000.0,
    contactEmail: 'design@creativeminds.com',
  ),
  Job(
    id: '6',
    title: 'QA Tester',
    location: 'Pune, India',
    description: 'Test and ensure the quality of software applications.',
    employmentType: 'Full-time',
    salary: 70000.0,
    contactEmail: 'qa@qualityassure.com',
  ),
  Job(
    id: '7',
    title: 'Product Owner',
    location: 'Chennai, India',
    description: 'Lead product development and strategy.',
    employmentType: 'Full-time',
    salary: 95000.0,
    contactEmail: 'product@agilesolutions.com',
  ),
];
