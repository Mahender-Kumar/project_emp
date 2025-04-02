class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final String description;
  final String employmentType;
  final double salary;
  final DateTime postedDate;
  final List<String> requirements;
  final String contactEmail;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    required this.employmentType,
    required this.salary,
    required this.postedDate,
    required this.requirements,
    required this.contactEmail,
  });

  // Convert Job object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'description': description,
      'employmentType': employmentType,
      'salary': salary,
      'postedDate': postedDate.toIso8601String(),
      'requirements': requirements,
      'contactEmail': contactEmail,
    };
  }

  // Create Job object from JSON
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      title: json['title'],
      company: json['company'],
      location: json['location'],
      description: json['description'],
      employmentType: json['employmentType'],
      salary: (json['salary'] as num).toDouble(),
      postedDate: DateTime.parse(json['postedDate']),
      requirements: List<String>.from(json['requirements']),
      contactEmail: json['contactEmail'],
    );
  }
}

// Sample jobs
List<Job> sampleJobs = [
  Job(
    id: '1',
    title: 'Flutter Developer',
    company: 'Tech Innovations',
    location: 'Bangalore, India',
    description: 'Develop and maintain Flutter applications.',
    employmentType: 'Full-time',
    salary: 80000.0,
    postedDate: DateTime.now(),
    requirements: ['Experience with Flutter', 'Firebase knowledge', 'Good problem-solving skills'],
    contactEmail: 'hr@techinnovations.com',
  ),
  Job(
    id: '2',
    title: 'Backend Engineer',
    company: 'Cloud Solutions',
    location: 'Remote',
    description: 'Build and optimize backend services.',
    employmentType: 'Full-time',
    salary: 90000.0,
    postedDate: DateTime.now(),
    requirements: ['Experience with Node.js', 'Database management skills', 'API development'],
    contactEmail: 'careers@cloudsolutions.com',
  ),
  Job(
    id: '3',
    title: 'UI/UX Designer',
    company: 'Design Studio',
    location: 'Mumbai, India',
    description: 'Create user-friendly interfaces and designs.',
    employmentType: 'Contract',
    salary: 60000.0,
    postedDate: DateTime.now(),
    requirements: ['Experience with Figma', 'Graphic design skills', 'Understanding of UX principles'],
    contactEmail: 'jobs@designstudio.com',
  ),
  Job(
    id: '4',
    title: 'Data Scientist',
    company: 'AI Analytics',
    location: 'Hyderabad, India',
    description: 'Analyze and interpret complex data sets.',
    employmentType: 'Full-time',
    salary: 120000.0,
    postedDate: DateTime.now(),
    requirements: ['Proficiency in Python', 'Machine learning expertise', 'Experience with big data'],
    contactEmail: 'recruitment@aianalytics.com',
  ),
  Job(
    id: '5',
    title: 'Product Designer',
    company: 'Creative Minds',
    location: 'Delhi, India',
    description: 'Design intuitive and engaging digital products.',
    employmentType: 'Full-time',
    salary: 75000.0,
    postedDate: DateTime.now(),
    requirements: ['Experience with UI/UX design', 'Proficiency in Adobe XD', 'Creative problem-solving skills'],
    contactEmail: 'design@creativeminds.com',
  ),
  Job(
    id: '6',
    title: 'QA Tester',
    company: 'Quality Assure',
    location: 'Pune, India',
    description: 'Test and ensure the quality of software applications.',
    employmentType: 'Full-time',
    salary: 70000.0,
    postedDate: DateTime.now(),
    requirements: ['Experience in manual and automated testing', 'Knowledge of test frameworks', 'Detail-oriented'],
    contactEmail: 'qa@qualityassure.com',
  ),
  Job(
    id: '7',
    title: 'Product Owner',
    company: 'Agile Solutions',
    location: 'Chennai, India',
    description: 'Lead product development and strategy.',
    employmentType: 'Full-time',
    salary: 95000.0,
    postedDate: DateTime.now(),
    requirements: ['Experience in Agile methodologies', 'Strong communication skills', 'Ability to prioritize tasks'],
    contactEmail: 'product@agilesolutions.com',
  ),
];