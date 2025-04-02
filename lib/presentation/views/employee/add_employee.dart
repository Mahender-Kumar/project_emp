import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_emp/blocs/employee/add_employee_bloc.dart';
import 'package:project_emp/blocs/employee/add_employee_event.dart';
import 'package:project_emp/blocs/employee/add_employee_state.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/data/enum/priority.dart';
import 'package:project_emp/data/models/jobs_model.dart';
import 'package:project_emp/data/models/todo_model.dart';
import 'package:project_emp/extensions/string_extensions.dart';
import 'package:project_emp/presentation/widgets/date_picker.dart';
import 'package:project_emp/presentation/widgets/expanded_btn.dart';
import 'package:project_emp/presentation/widgets/role_sheet.dart';
import 'package:uuid/uuid.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final _formKey = GlobalKey<FormState>();

  final _dateController = TextEditingController();

  late Employee todo;

  @override
  void initState() {
    todo = Employee(
      id: const Uuid().v4(),
      name: '',
      position: '',
      department: '',
      email: '',
      phone: '',
      salary: 0.0,
      hireDate: DateTime.now(),
      location: '',
    );
    super.initState();
  }

  void _addEmployee(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<AddEmployeeBloc>().add(AddEmployeeEvent(todo));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Employee Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: BlocListener<AddEmployeeBloc, EmployeeState>(
            listener: (context, state) {
              // print(' state: $state');
              if (state is EmployeeSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Todo Added Successfully")),
                );
                _formKey.currentState!.reset(); // Reset the form
                _dateController.clear(); // Clear the date controller
                todo = Employee(
                  id: const Uuid().v4(),

                  name: '',
                  position: '',
                  department: '',
                  email: '',
                  phone: '',
                  salary: 0.0,
                  hireDate: DateTime.now(),
                  location: '',
                ); // Reset the todo object
                // Close screen on success
              } else if (state is EmployeeFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: ${state.error}")),
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Employee Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_2_outlined),
                  ),
                  validator:
                      (value) => value!.isEmpty ? "Please enter name" : null,
                  onChanged: (value) => todo.name = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Employee Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_2_outlined),
                  ),
                  onTap: () {
                    JobSelectionBottomSheet.showJobSelectionSheet(
                      context: context,
                      onJobSelected: (job) {},
                    );
                  },
                  validator:
                      (value) => value!.isEmpty ? "Please enter name" : null,
                  onChanged: (value) => todo.name = value,
                ),
                const SizedBox(height: defaultGapping),
                DropdownButtonFormField<Job>(
                  decoration: const InputDecoration(
                    isDense: true,
                    // labelText: "Role",
                    hintText: 'Select Role',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.work_outline),
                  ),
                  items:
                      sampleJobs.map((job) {
                        return DropdownMenuItem(
                          value: job,
                          child: Text(job.title),
                        );
                      }).toList(),
                  onChanged: (value) {
                    // Handle selection
                  },
                  validator:
                      (value) => value == null ? "Please select a Role" : null,
                ),

                const SizedBox(height: defaultGapping),
                Row(
                  children: [
                    Flexible(
                      child: DatePicker(
                        validate: true,
                        controller: _dateController,
                        onDateTimeSelected: (dateSelected) {
                          // todo.dueDate = Timestamp.fromDate(dateSelected);
                        },
                      ),
                    ),
                    const SizedBox(width: defaultGapping),
                    Icon(Icons.arrow_forward_rounded, size: btnFontSize * 1.5),
                    const SizedBox(width: defaultGapping),

                    Flexible(
                      child: DatePicker(
                        validate: true,
                        controller: _dateController,
                        onDateTimeSelected: (dateSelected) {
                          // todo.dueDate = Timestamp.fromDate(dateSelected);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: defaultGapping),

                BlocBuilder<AddEmployeeBloc, EmployeeState>(
                  builder: (context, state) {
                    return ExpandedBtn(
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(btnRadius),
                        ),
                      ),
                      onPressed:
                          state is EmployeeLoading
                              ? null
                              : () => _addEmployee(context),
                      child:
                          state is EmployeeLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text("Save"),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
